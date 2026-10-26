import ImageIO
import UIKit

enum SuliJoyLagoonImageShelf {
    private static let memory = NSCache<NSString, UIImage>()
    private static let gate = SuliJoyImageFetchGate(limit: 6)
    private static let lock = NSLock()
    private static var waiters: [String: [(UIImage?) -> Void]] = [:]

    static func isRemote(_ token: String) -> Bool {
        guard let scheme = URL(string: token)?.scheme?.lowercased() else { return false }
        return scheme == "http" || scheme == "https"
    }

    static func existingFilePath(for token: String) -> String? {
        if token.hasPrefix("/"), FileManager.default.fileExists(atPath: token) {
            return token
        }
        guard isRemote(token) else { return nil }
        let hashed = fileURL(for: token).path
        if FileManager.default.fileExists(atPath: hashed) { return hashed }
        let legacy = legacyFileURL(for: token).path
        if FileManager.default.fileExists(atPath: legacy) { return legacy }
        return nil
    }

    static func cachedImage(for token: String) -> UIImage? {
        let key = cacheKey(for: token) as NSString
        if let image = memory.object(forKey: key) { return image }
        guard let path = existingFilePath(for: token), let image = UIImage(contentsOfFile: path) else { return nil }
        memory.setObject(image, forKey: key)
        return image
    }

    static func load(_ token: String, completion: @escaping (UIImage?) -> Void) {
        let key = cacheKey(for: token)
        if let image = cachedImage(for: token) {
            DispatchQueue.main.async { completion(image) }
            return
        }
        lock.lock()
        if waiters[key] != nil {
            waiters[key]?.append(completion)
            lock.unlock()
            return
        }
        waiters[key] = [completion]
        lock.unlock()
        Task {
            await gate.enter()
            let image = await fetch(token)
            await gate.leave()
            let callbacks: [(UIImage?) -> Void]
            lock.lock()
            callbacks = waiters.removeValue(forKey: key) ?? []
            lock.unlock()
            DispatchQueue.main.async {
                callbacks.forEach { $0(image) }
            }
        }
    }

    private static func fetch(_ token: String) async -> UIImage? {
        if let image = cachedImage(for: token) { return image }
        guard let remoteURL = URL(string: token), isRemote(token) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: remoteURL)
            guard let image = thumbnail(data: data, maxPixel: 960) ?? UIImage(data: data) else { return nil }
            let directory = cacheDirectory()
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            if let jpeg = image.jpegData(compressionQuality: 0.82) {
                try? jpeg.write(to: fileURL(for: token), options: .atomic)
            }
            memory.setObject(image, forKey: cacheKey(for: token) as NSString)
            return image
        } catch {
            return nil
        }
    }

    private static func thumbnail(data: Data, maxPixel: CGFloat) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel,
            kCGImageSourceCreateThumbnailWithTransform: true
        ]
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    private static func cacheKey(for token: String) -> String {
        guard var parts = URLComponents(string: token) else { return token }
        parts.query = nil
        parts.fragment = nil
        return parts.string ?? token
    }

    private static func cacheDirectory() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("SuliJoyLagoonAssets", isDirectory: true)
    }

    private static func fileURL(for token: String) -> URL {
        cacheDirectory().appendingPathComponent(fnv64(cacheKey(for: token)) + ".img")
    }

    private static func legacyFileURL(for token: String) -> URL {
        let fileName = Data(token.utf8).base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
        return cacheDirectory().appendingPathComponent(fileName)
    }

    private static func fnv64(_ text: String) -> String {
        var hash: UInt64 = 0xcbf29ce484222325
        for byte in text.utf8 {
            hash ^= UInt64(byte)
            hash &*= 0x100000001b3
        }
        return String(hash, radix: 16)
    }
}

private actor SuliJoyImageFetchGate {
    private let limit: Int
    private var active = 0
    private var waiting: [CheckedContinuation<Void, Never>] = []

    init(limit: Int) {
        self.limit = limit
    }

    func enter() async {
        if active < limit {
            active += 1
            return
        }
        await withCheckedContinuation { waiting.append($0) }
    }

    func leave() {
        if waiting.isEmpty {
            active = max(0, active - 1)
        } else {
            waiting.removeFirst().resume()
        }
    }
}

private enum SuliJoyImageTokenStore {
    static var key: UInt8 = 0
}

enum SuliJoyImagePlaceholder {
    static let portrait = canvas(symbol: "person.fill")
    static let photo = canvas(symbol: "photo")

    private static func canvas(symbol: String) -> UIImage {
        let side: CGFloat = 160
        let format = UIGraphicsImageRendererFormat()
        format.opaque = true
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: side, height: side), format: format)
        return renderer.image { _ in
            UIColor(red: 0.93, green: 0.93, blue: 0.95, alpha: 1).setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: side, height: side)).fill()
            let configuration = UIImage.SymbolConfiguration(pointSize: 54, weight: .regular)
            let icon = UIImage(systemName: symbol, withConfiguration: configuration)?
                .withTintColor(UIColor(white: 0.74, alpha: 1), renderingMode: .alwaysOriginal)
            let iconSide: CGFloat = 68
            let origin = (side - iconSide) / 2
            icon?.draw(in: CGRect(x: origin, y: origin, width: iconSide, height: iconSide))
        }
    }
}

extension UIImageView {
    private var suliJoyBoundImageToken: String {
        get { objc_getAssociatedObject(self, &SuliJoyImageTokenStore.key) as? String ?? "" }
        set { objc_setAssociatedObject(self, &SuliJoyImageTokenStore.key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    func suliJoyApplyPortrait(_ token: String?) {
        suliJoyApplyRemoteImage(token, placeholder: SuliJoyImagePlaceholder.portrait)
    }

    func suliJoyApplyPhoto(_ token: String?) {
        suliJoyApplyRemoteImage(token, placeholder: SuliJoyImagePlaceholder.photo)
    }

    private func suliJoyApplyRemoteImage(_ token: String?, placeholder: UIImage) {
        let resolved = token?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        suliJoyBoundImageToken = resolved
        if !SuliJoyLagoonImageShelf.isRemote(resolved), let local = UIImage.suliJoyAssetOrLocal(named: resolved) {
            image = local
            return
        }
        if let cached = SuliJoyLagoonImageShelf.cachedImage(for: resolved) {
            image = cached
            return
        }
        image = placeholder
        guard SuliJoyLagoonImageShelf.isRemote(resolved) else { return }
        SuliJoyLagoonImageShelf.load(resolved) { [weak self] loaded in
            guard let self, self.suliJoyBoundImageToken == resolved, let loaded else { return }
            self.image = loaded
        }
    }
}
