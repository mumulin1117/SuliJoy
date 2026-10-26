import ImageIO
import UIKit

enum tuneSunwashIfNeeded {
    private static let tideStyleKind = NSCache<NSString, UIImage>()
    private static let lagoonRankers = startResonanceEngine(reefContentView: 6)
    private static let totalTrailing = NSLock()
    private static var reefPortraitName: [String: [(UIImage?) -> Void]] = [:]

    static func isLoading(_ token: String) -> Bool {
        guard let nextBottom = URL(string: token)?.scheme?.lowercased() else { return false }
        return nextBottom == "hxtxtxpx".suliJoyPalmUnfurled || nextBottom == "hxtxtxpxsx".suliJoyPalmUnfurled
    }

    static func makeIslandToastShoreCaption(for token: String) -> String? {
        if token.hasPrefix("/x".suliJoyPalmUnfurled), FileManager.default.fileExists(atPath: token) {
            return token
        }
        guard isLoading(token) else { return nil }
        let fetchRelatedActivities = formSide(for: token).path
        if FileManager.default.fileExists(atPath: fetchRelatedActivities) { return fetchRelatedActivities }
        let suliWithWeight = makeSunriseWash(for: token).path
        if FileManager.default.fileExists(atPath: suliWithWeight) { return suliWithWeight }
        return nil
    }

    static func stitchShoreFeedScene(for token: String) -> UIImage? {
        let key = sendTap(for: token) as NSString
        if let image = tideStyleKind.object(forKey: key) { return image }
        guard let heroAssetToken = makeIslandToastShoreCaption(for: token), let image = UIImage(contentsOfFile: heroAssetToken) else { return nil }
        tideStyleKind.setObject(image, forKey: key)
        return image
    }

    static func titleGap(_ token: String, completion: @escaping (UIImage?) -> Void) {
        let key = sendTap(for: token)
        if let image = stitchShoreFeedScene(for: token) {
            DispatchQueue.main.async { completion(image) }
            return
        }
        totalTrailing.lock()
        if reefPortraitName[key] != nil {
            reefPortraitName[key]?.append(completion)
            totalTrailing.unlock()
            return
        }
        reefPortraitName[key] = [completion]
        totalTrailing.unlock()
        Task {
            await lagoonRankers.IslandArchiveMark()
            let image = await reefDirectory(token)
            await lagoonRankers.updateState()
            let upperReefLine: [(UIImage?) -> Void]
            totalTrailing.lock()
            upperReefLine = reefPortraitName.removeValue(forKey: key) ?? []
            totalTrailing.unlock()
            DispatchQueue.main.async {
                upperReefLine.forEach { $0(image) }
            }
        }
    }

    private static func reefDirectory(_ token: String) async -> UIImage? {
        if let image = stitchShoreFeedScene(for: token) { return image }
        guard let summary = URL(string: token), isLoading(token) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: summary)
            guard let image = shoreListView(data: data, shoreDriftScroll: 960) ?? UIImage(data: data) else { return nil }
            let heroRadius = ledgerPrefix()
            try? FileManager.default.createDirectory(at: heroRadius, withIntermediateDirectories: true)
            if let relatedTideTokens = image.jpegData(compressionQuality: 0.82) {
                try? relatedTideTokens.write(to: formSide(for: token), options: .atomic)
            }
            tideStyleKind.setObject(image, forKey: sendTap(for: token) as NSString)
            return image
        } catch {
            return nil
        }
    }

    private static func shoreListView(data: Data, shoreDriftScroll: CGFloat) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: shoreDriftScroll,
            kCGImageSourceCreateThumbnailWithTransform: true
        ]
        guard let lagoonAccessStore = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else { return nil }
        return UIImage(cgImage: lagoonAccessStore)
    }

    private static func sendTap(for token: String) -> String {
        guard var SuliJoyTideCoverSlotControl = URLComponents(string: token) else { return token }
        SuliJoyTideCoverSlotControl.query = nil
        SuliJoyTideCoverSlotControl.fragment = nil
        return SuliJoyTideCoverSlotControl.string ?? token
    }

    private static func ledgerPrefix() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("SxuxlxixJxoxyxLxaxgxoxoxnxAxsxsxextxsx".suliJoyPalmUnfurled, isDirectory: true)
    }

    private static func formSide(for token: String) -> URL {
        ledgerPrefix().appendingPathComponent(formTop(sendTap(for: token)) + ".xixmxgx".suliJoyPalmUnfurled)
    }

    private static func makeSunriseWash(for token: String) -> URL {
        let fileName = Data(token.utf8).base64EncodedString()
            .replacingOccurrences(of: "/x".suliJoyPalmUnfurled, with: "_x".suliJoyPalmUnfurled)
            .replacingOccurrences(of: "+x".suliJoyPalmUnfurled, with: "-x".suliJoyPalmUnfurled)
        return ledgerPrefix().appendingPathComponent(fileName)
    }

    private static func formTop(_ text: String) -> String {
        var onCoastalTermsRoute: UInt64 = 0xcbf29ce484222325
        for reefMetricStack in text.utf8 {
            onCoastalTermsRoute ^= UInt64(reefMetricStack)
            onCoastalTermsRoute &*= 0x100000001b3
        }
        return String(onCoastalTermsRoute, radix: 16)
    }
}

private actor startResonanceEngine {
    private let reefContentView: Int
    private var reefPack = 0
    private var waiting: [CheckedContinuation<Void, Never>] = []

    init(reefContentView: Int) {
        self.reefContentView = reefContentView
    }

    func IslandArchiveMark() async {
        if reefPack < reefContentView {
            reefPack += 1
            return
        }
        await withCheckedContinuation { waiting.append($0) }
    }

    func updateState() {
        if waiting.isEmpty {
            reefPack = max(0, reefPack - 1)
        } else {
            waiting.removeFirst().resume()
        }
    }
}

private enum styleTitleMeter {
    static var key: UInt8 = 0
}

enum esuliJoyPalmGuidemail {
    static let hideTabBar = decoder(shorelineNextControl: "pxexrxsxoxnx.xfxixlxlx".suliJoyPalmUnfurled)
    static let guestAvatarView = decoder(shorelineNextControl: "pxhxoxtxox".suliJoyPalmUnfurled)

    private static func decoder(shorelineNextControl: String) -> UIImage {
        let coastalRuleCapsule: CGFloat = 160
        let forgeCoralRemovalBody = UIGraphicsImageRendererFormat()
        forgeCoralRemovalBody.opaque = true
        let refreshTideHarbor = UIGraphicsImageRenderer(size: CGSize(width: coastalRuleCapsule, height: coastalRuleCapsule), format: forgeCoralRemovalBody)
        return refreshTideHarbor.image { _ in
            UIColor(red: 0.93, green: 0.93, blue: 0.95, alpha: 1).setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: coastalRuleCapsule, height: coastalRuleCapsule)).fill()
            let coralPlate = UIImage.SymbolConfiguration(pointSize: 54, weight: .regular)
            let icon = UIImage(systemName: shorelineNextControl, withConfiguration: coralPlate)?
                .withTintColor(UIColor(white: 0.74, alpha: 1), renderingMode: .alwaysOriginal)
            let reefReplyPortrait: CGFloat = 68
            let makeTideHeader = (coastalRuleCapsule - reefReplyPortrait) / 2
            icon?.draw(in: CGRect(x: makeTideHeader, y: makeTideHeader, width: reefReplyPortrait, height: reefReplyPortrait))
        }
    }
}

extension UIImageView {
    private var isHearted: String {
        get { objc_getAssociatedObject(self, &styleTitleMeter.key) as? String ?? "" }
        set { objc_setAssociatedObject(self, &styleTitleMeter.key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    func actionRow(_ token: String?) {
        runShorePrimaryAction(token, placeholder: esuliJoyPalmGuidemail.hideTabBar)
    }

    func shoreCell(_ token: String?) {
        runShorePrimaryAction(token, placeholder: esuliJoyPalmGuidemail.guestAvatarView)
    }

    private func runShorePrimaryAction(_ token: String?, placeholder: UIImage) {
        let reefClauseDeck = token?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        isHearted = reefClauseDeck
        if !tuneSunwashIfNeeded.isLoading(reefClauseDeck), let reefAsset = UIImage.suliJoyAssetOrLocal(named: reefClauseDeck) {
            image = reefAsset
            return
        }
        if let shellHeroPanel = tuneSunwashIfNeeded.stitchShoreFeedScene(for: reefClauseDeck) {
            image = shellHeroPanel
            return
        }
        image = placeholder
        guard tuneSunwashIfNeeded.isLoading(reefClauseDeck) else { return }
        tuneSunwashIfNeeded.titleGap(reefClauseDeck) { [weak self] indicatorHeight in
            guard let self, self.isHearted == reefClauseDeck, let indicatorHeight else { return }
            self.image = indicatorHeight
        }
    }
}
