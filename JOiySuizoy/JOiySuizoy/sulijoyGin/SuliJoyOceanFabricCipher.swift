import CommonCrypto
import Foundation
import Security
import UIKit

struct SuliJoyOceanFabricCipher {
    private let oceanWeaveData: Data
    private let palmAnchorData: Data

    init?() {
        guard
            let keyData = SuliJoyIslandWardrobeCompass.islandShared.oceanCipherThread.data(using: .utf8),
            let seedData = SuliJoyIslandWardrobeCompass.islandShared.palmCipherSeed.data(using: .utf8)
        else { return nil }
        oceanWeaveData = keyData
        palmAnchorData = seedData
    }

    func wrapCoastalWeave(_ plainText: String) -> String? {
        guard let shoreBytes = plainText.data(using: .utf8) else { return nil }
        return stitchCoastalBytes(shoreBytes, action: kCCEncrypt)?.suliJoyPalmHexWeave()
    }

    func unwrapCoastalWeave(hexText: String) -> String? {
        guard let shellBytes = Data(suliJoyPalmHexWeave: hexText) else { return nil }
        return stitchCoastalBytes(shellBytes, action: kCCDecrypt).flatMap { String(data: $0, encoding: .utf8) }
    }

    private func stitchCoastalBytes(_ inletBytes: Data, action: Int) -> Data? {
        let wardrobeBufferCount = inletBytes.count + kCCBlockSizeAES128
        var stitchedOutput = Data(count: wardrobeBufferCount)
        var palmStitchCount: size_t = 0

        let status = stitchedOutput.withUnsafeMutableBytes { outputBytes in
            inletBytes.withUnsafeBytes { sourceBytes in
                palmAnchorData.withUnsafeBytes { seedBytes in
                    oceanWeaveData.withUnsafeBytes { keyBytes in
                        CCCrypt(
                            CCOperation(action),
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress,
                            oceanWeaveData.count,
                            seedBytes.baseAddress,
                            sourceBytes.baseAddress,
                            inletBytes.count,
                            outputBytes.baseAddress,
                            wardrobeBufferCount,
                            &palmStitchCount
                        )
                    }
                }
            }
        }

        guard status == kCCSuccess else { return nil }
        stitchedOutput.removeSubrange(palmStitchCount..<stitchedOutput.count)
        return stitchedOutput
    }
}

enum SuliJoyIslandVault {
    private static var shorelineVaultLabel: String {
        (Bundle.main.bundleIdentifier ?? "com.sulijoy.share") + ".sulijoyGin"
    }

    private static var palmDevicePocket: String {
        shorelineVaultLabel + SuliJoySunsetLexicon.islandDeviceSuffix
    }

    private static var islandEntryPocket: String {
        shorelineVaultLabel + SuliJoySunsetLexicon.palmSecretSuffix
    }

    static func fetchPalmDeviceRibbon() -> String {
        if let existingRibbon = readBeachVaultThread(account: palmDevicePocket) {
            return existingRibbon
        }
        let freshRibbon = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        writeBeachVaultThread(freshRibbon, account: palmDevicePocket)
        return freshRibbon
    }

    static func archiveIslandEntryThread(_ secret: String) {
        writeBeachVaultThread(secret, account: islandEntryPocket)
    }

    static func fetchIslandEntryThread() -> String? {
        readBeachVaultThread(account: islandEntryPocket)
    }

    private static func readBeachVaultThread(account: String) -> String? {
        let request: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: shorelineVaultLabel,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var found: AnyObject?
        let status = SecItemCopyMatching(request as CFDictionary, &found)
        guard
            status == errSecSuccess,
            let payload = found as? Data,
            let decoded = String(data: payload, encoding: .utf8)
        else { return nil }
        return decoded
    }

    private static func writeBeachVaultThread(_ value: String, account: String) {
        removeBeachVaultThread(account: account)
        guard let payload = value.data(using: .utf8) else { return }
        let request: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: shorelineVaultLabel,
            kSecAttrAccount as String: account,
            kSecValueData as String: payload,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        SecItemAdd(request as CFDictionary, nil)
    }

    private static func removeBeachVaultThread(account: String) {
        let request: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: shorelineVaultLabel,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(request as CFDictionary)
    }
}

extension Data {
    func suliJoyPalmHexWeave() -> String {
        map { String(format: SuliJoySunsetLexicon.palmByteMask, $0) }.joined()
    }

    init?(suliJoyPalmHexWeave hexText: String) {
        guard hexText.count.isMultiple(of: 2) else { return nil }
        var assembled = Data()
        assembled.reserveCapacity(hexText.count / 2)
        var cursor = hexText.startIndex
        while cursor < hexText.endIndex {
            let next = hexText.index(cursor, offsetBy: 2)
            guard let byte = UInt8(hexText[cursor..<next], radix: 16) else { return nil }
            assembled.append(byte)
            cursor = next
        }
        self = assembled
    }
}

private extension Bundle {
    var suliJoyCoastalVersionWeave: String {
        object(forInfoDictionaryKey: SuliJoySunsetLexicon.bundleVersionRune) as? String ?? ""
    }
}

final class SuliJoyCoastalParcelRunner {
    static let islandShared = SuliJoyCoastalParcelRunner()

    private init() {}

    func dispatchIslandParcel(
        path: String,
        params: [String: Any],
        pearlMode: Bool = false,
        shorelineReturn: @escaping (Result<[String: Any]?, Error>) -> Void = { _ in }
    ) {
        guard let shorelineRouteURL = URL(string: SuliJoyIslandWardrobeCompass.islandShared.coastalAtlasRoot + path) else {
            shorelineReturn(.failure(NSError(domain: SuliJoySunsetLexicon.covePathErrorCopy, code: 400)))
            return
        }

        guard
            let jsonText = Self.composeIslandJSONThread(from: params),
            let cipher = SuliJoyOceanFabricCipher(),
            let wrappedText = cipher.wrapCoastalWeave(jsonText),
            let payload = wrappedText.data(using: .utf8)
        else { return }

        var request = URLRequest(url: shorelineRouteURL)
        request.httpMethod = SuliJoySunsetLexicon.shorePostVerb
        request.httpBody = payload
        request.timeoutInterval = 15
        request.setValue(SuliJoySunsetLexicon.shoreJSONMime, forHTTPHeaderField: SuliJoySunsetLexicon.shoreContentHeader)
        request.setValue(SuliJoyIslandWardrobeCompass.islandShared.sunsetAppEmblem, forHTTPHeaderField: SuliJoySunsetLexicon.shoreEmblemHeader)
        request.setValue(Bundle.main.suliJoyCoastalVersionWeave, forHTTPHeaderField: SuliJoySunsetLexicon.shoreVersionHeader)
        request.setValue(SuliJoyIslandVault.fetchPalmDeviceRibbon(), forHTTPHeaderField: SuliJoySunsetLexicon.shoreDeviceHeader)
        request.setValue(Locale.current.languageCode ?? "", forHTTPHeaderField: SuliJoySunsetLexicon.shoreLanguageHeader)
        request.setValue(UserDefaults.standard.string(forKey: SuliJoySunsetLexicon.islandRibbonVaultKey) ?? "", forHTTPHeaderField: SuliJoySunsetLexicon.shoreRibbonHeader)
        request.setValue(UserDefaults.standard.string(forKey: SuliJoySunsetLexicon.palmNoticeVaultKey) ?? "", forHTTPHeaderField: SuliJoySunsetLexicon.shoreNoticeHeader)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                DispatchQueue.main.async { shorelineReturn(.failure(error)) }
                return
            }
            guard let data else {
                DispatchQueue.main.async {
                    shorelineReturn(.failure(NSError(domain: SuliJoySunsetLexicon.emptyEnvelopeCopy, code: 1000)))
                }
                return
            }
            self.unfoldShorelinePacket(data: data, pearlMode: pearlMode, shorelineReturn: shorelineReturn)
        }.resume()
    }

    private func unfoldShorelinePacket(
        data: Data,
        pearlMode: Bool,
        shorelineReturn: @escaping (Result<[String: Any]?, Error>) -> Void
    ) {
        do {
            guard let envelope = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                throw NSError(domain: SuliJoySunsetLexicon.brokenEnvelopeCopy, code: 1001)
            }

            if pearlMode {
                guard
                    let code = envelope[SuliJoySunsetLexicon.code] as? String,
                    code == SuliJoySunsetLexicon.smoothCodeRune
                else {
                    DispatchQueue.main.async {
                        shorelineReturn(.failure(NSError(domain: SuliJoySunsetLexicon.pearlSettleErrorCopy, code: 1001)))
                    }
                    return
                }
                DispatchQueue.main.async { shorelineReturn(.success([:])) }
                return
            }

            guard
                let code = envelope[SuliJoySunsetLexicon.code] as? String,
                code == SuliJoySunsetLexicon.smoothCodeRune,
                let wrappedResult = envelope[SuliJoySunsetLexicon.resultRune] as? String
            else {
                throw NSError(
                    domain: envelope[SuliJoySunsetLexicon.serverVerseRune] as? String ?? SuliJoySunsetLexicon.fallbackEnvelopeCopy,
                    code: 1002
                )
            }

            guard
                let cipher = SuliJoyOceanFabricCipher(),
                let resultRuneText = cipher.unwrapCoastalWeave(hexText: wrappedResult),
                let resultRuneData = resultRuneText.data(using: .utf8),
                let resultRune = try JSONSerialization.jsonObject(with: resultRuneData) as? [String: Any]
            else {
                throw NSError(domain: SuliJoySunsetLexicon.cipherBrokenCopy, code: 1003)
            }
            DispatchQueue.main.async { shorelineReturn(.success(resultRune)) }
        } catch {
            DispatchQueue.main.async { shorelineReturn(.failure(error)) }
        }
    }

    static func composeIslandJSONThread(from dict: [String: Any]) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: dict) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
