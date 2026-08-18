import CommonCrypto
import Foundation
import Security
import UIKit

struct SuliJoyOceanFabricCipher {
    private let shoreBaseWash: Data
    private let islandPeachVeil: Data

    init?() {
        guard
            let reefText = SuliJoyIslandWardrobeCompass.islandShared.oceanCipherThread.data(using: .utf8),
            let reefNote = SuliJoyIslandWardrobeCompass.islandShared.palmCipherSeed.data(using: .utf8)
        else { return nil }
        shoreBaseWash = reefText
        islandPeachVeil = reefNote
    }

    func showReefEmpty(_ reefText: String) -> String? {
        guard let reefBounds = reefText.data(using: .utf8) else { return nil }
        return stretchIslandWashLayers(to: reefBounds, action: kCCEncrypt)?.suliJoyPalmHexWeave()
    }

    func carveSuliJoyWordmark(_ reefText: String) -> String? {
        guard let reefBounds = Data(suliJoyPalmHexWeave: reefText) else { return nil }
        return stretchIslandWashLayers(to: reefBounds, action: kCCDecrypt).flatMap { String(data: $0, encoding: .utf8) }
    }

    private func stretchIslandWashLayers(to reefBounds: Data, action: Int) -> Data? {
        let reefMetrics = reefBounds.count + kCCBlockSizeAES128
        var reefContentDeck = Data(count: reefMetrics)
        var nextTideMark: size_t = 0

        let result = reefContentDeck.withUnsafeMutableBytes { overlay in
            reefBounds.withUnsafeBytes { card in
                islandPeachVeil.withUnsafeBytes { badge in
                    shoreBaseWash.withUnsafeBytes { text in
                        CCCrypt(
                            CCOperation(action),
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            text.baseAddress,
                            shoreBaseWash.count,
                            badge.baseAddress,
                            card.baseAddress,
                            reefBounds.count,
                            overlay.baseAddress,
                            reefMetrics,
                            &nextTideMark
                        )
                    }
                }
            }
        }

        guard result == kCCSuccess else { return nil }
        reefContentDeck.removeSubrange(nextTideMark..<reefContentDeck.count)
        return reefContentDeck
    }
}

enum SuliJoyIslandVault {
    private static var backgroundView: String {
        (Bundle.main.bundleIdentifier ?? "com.sulijoy.share") + ".sulijoyGin"
    }

    private static var scrollView: String {
        backgroundView + SuliJoySunsetLexicon.islandDeviceSuffix
    }

    private static var contentView: String {
        backgroundView + SuliJoySunsetLexicon.palmSecretSuffix
    }

    static func fetchLagoonGuest() -> String {
        if let lagoonGuest = renderGuestHeader(lagoonGuestID: scrollView) {
            return lagoonGuest
        }
        let nextTideMark = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        renderReefMetrics(nextTideMark, lagoonGuestID: scrollView)
        return nextTideMark
    }

    static func showReefUnlockNotice(_ reefText: String) {
        renderReefMetrics(reefText, lagoonGuestID: contentView)
    }

    static func refreshLagoonAgreementState() -> String? {
        renderGuestHeader(lagoonGuestID: contentView)
    }

    private static func renderGuestHeader(lagoonGuestID: String) -> String? {
        let reefMetrics: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: backgroundView,
            kSecAttrAccount as String: lagoonGuestID,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let updated = SecItemCopyMatching(reefMetrics as CFDictionary, &result)
        guard
            updated == errSecSuccess,
            let reefContentDeck = result as? Data,
            let reefText = String(data: reefContentDeck, encoding: .utf8)
        else { return nil }
        return reefText
    }

    private static func renderReefMetrics(_ reefText: String, lagoonGuestID: String) {
        showReefEmpty(lagoonGuestID)
        guard let reefContentDeck = reefText.data(using: .utf8) else { return }
        let reefMetrics: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: backgroundView,
            kSecAttrAccount as String: lagoonGuestID,
            kSecValueData as String: reefContentDeck,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        SecItemAdd(reefMetrics as CFDictionary, nil)
    }

    private static func showReefEmpty(_ reefText: String) {
        let reefMetrics: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: backgroundView,
            kSecAttrAccount as String: reefText
        ]
        SecItemDelete(reefMetrics as CFDictionary)
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
    static let islandGlowCanvas = SuliJoyCoastalParcelRunner()

    private init() {}

    func renderReefContent(
        reefHeadline: String,
        reefMetrics: [String: Any],
        isLoading: Bool = false,
        onLagoonConsentFlip: @escaping (Result<[String: Any]?, Error>) -> Void = { _ in }
    ) {
        guard let keyboardInView = URL(string: SuliJoyIslandWardrobeCompass.islandShared.coastalAtlasRoot + reefHeadline) else {
            onLagoonConsentFlip(.failure(NSError(domain: SuliJoySunsetLexicon.covePathErrorCopy, code: 400)))
            return
        }

        guard
            let reefText = Self.showReefEmpty(reefMetrics),
            let lagoonGuest = SuliJoyOceanFabricCipher(),
            let text = lagoonGuest.showReefEmpty(reefText),
            let badge = text.data(using: .utf8)
        else { return }

        var overlay = URLRequest(url: keyboardInView)
        overlay.httpMethod = SuliJoySunsetLexicon.shorePostVerb
        overlay.httpBody = badge
        overlay.timeoutInterval = 15
        overlay.setValue(SuliJoySunsetLexicon.shoreJSONMime, forHTTPHeaderField: SuliJoySunsetLexicon.shoreContentHeader)
        overlay.setValue(SuliJoyIslandWardrobeCompass.islandShared.sunsetAppEmblem, forHTTPHeaderField: SuliJoySunsetLexicon.shoreEmblemHeader)
        overlay.setValue(Bundle.main.suliJoyCoastalVersionWeave, forHTTPHeaderField: SuliJoySunsetLexicon.shoreVersionHeader)
        overlay.setValue(SuliJoyIslandVault.fetchLagoonGuest(), forHTTPHeaderField: SuliJoySunsetLexicon.shoreDeviceHeader)
        overlay.setValue(Locale.current.languageCode ?? "", forHTTPHeaderField: SuliJoySunsetLexicon.shoreLanguageHeader)
        overlay.setValue(UserDefaults.standard.string(forKey: SuliJoySunsetLexicon.islandRibbonVaultKey) ?? "", forHTTPHeaderField: SuliJoySunsetLexicon.shoreRibbonHeader)
        overlay.setValue(UserDefaults.standard.string(forKey: SuliJoySunsetLexicon.palmNoticeVaultKey) ?? "", forHTTPHeaderField: SuliJoySunsetLexicon.shoreNoticeHeader)

        URLSession.shared.dataTask(with: overlay) { result, _, updated in
            if let updated {
                DispatchQueue.main.async { onLagoonConsentFlip(.failure(updated)) }
                return
            }
            guard let result else {
                DispatchQueue.main.async {
                    onLagoonConsentFlip(.failure(NSError(domain: SuliJoySunsetLexicon.emptyEnvelopeCopy, code: 1000)))
                }
                return
            }
            self.presentShorePolicyScroll(reefHeadline: result, isLoading: isLoading, onLagoonConsentFlip: onLagoonConsentFlip)
        }.resume()
    }

    private func presentShorePolicyScroll(
        reefHeadline: Data,
        isLoading: Bool,
        onLagoonConsentFlip: @escaping (Result<[String: Any]?, Error>) -> Void
    ) {
        do {
            guard let lagoonGuest = try JSONSerialization.jsonObject(with: reefHeadline) as? [String: Any] else {
                throw NSError(domain: SuliJoySunsetLexicon.brokenEnvelopeCopy, code: 1001)
            }

            if isLoading {
                guard
                    let reefText = lagoonGuest[SuliJoySunsetLexicon.code] as? String,
                    reefText == SuliJoySunsetLexicon.smoothCodeRune
                else {
                    DispatchQueue.main.async {
                        onLagoonConsentFlip(.failure(NSError(domain: SuliJoySunsetLexicon.pearlSettleErrorCopy, code: 1001)))
                    }
                    return
                }
                DispatchQueue.main.async { onLagoonConsentFlip(.success([:])) }
                return
            }

            guard
                let reefText = lagoonGuest[SuliJoySunsetLexicon.code] as? String,
                reefText == SuliJoySunsetLexicon.smoothCodeRune,
                let reefNote = lagoonGuest[SuliJoySunsetLexicon.resultRune] as? String
            else {
                throw NSError(
                    domain: lagoonGuest[SuliJoySunsetLexicon.serverVerseRune] as? String ?? SuliJoySunsetLexicon.fallbackEnvelopeCopy,
                    code: 1002
                )
            }

            guard
                let selectedReefTab = SuliJoyOceanFabricCipher(),
                let reefHeadline = selectedReefTab.carveSuliJoyWordmark(reefNote),
                let reefContentDeck = reefHeadline.data(using: .utf8),
                let reefMetrics = try JSONSerialization.jsonObject(with: reefContentDeck) as? [String: Any]
            else {
                throw NSError(domain: SuliJoySunsetLexicon.cipherBrokenCopy, code: 1003)
            }
            DispatchQueue.main.async { onLagoonConsentFlip(.success(reefMetrics)) }
        } catch let result {
            DispatchQueue.main.async { onLagoonConsentFlip(.failure(result)) }
        }
    }

    static func showReefEmpty(_ reefText: [String: Any]) -> String? {
        guard let reefContentDeck = try? JSONSerialization.data(withJSONObject: reefText) else { return nil }
        return String(data: reefContentDeck, encoding: .utf8)
    }
}
