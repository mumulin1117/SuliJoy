import CommonCrypto
import Foundation
import Security
import UIKit

struct SuliJoyGinCipher {
    private let reefKeyData: Data
    private let reefSeedData: Data

    init?() {
        guard
            let keyData = SuliJoyGinConfiguration.shared.reefCipherKey.data(using: .utf8),
            let seedData = SuliJoyGinConfiguration.shared.reefCipherSeed.data(using: .utf8)
        else { return nil }
        reefKeyData = keyData
        reefSeedData = seedData
    }

    func reefWrap(_ plainText: String) -> String? {
        guard let shoreBytes = plainText.data(using: .utf8) else { return nil }
        return reefTransform(shoreBytes, action: kCCEncrypt)?.suliJoyGinHexRibbon()
    }

    func reefUnwrap(hexText: String) -> String? {
        guard let shellBytes = Data(suliJoyGinHexRibbon: hexText) else { return nil }
        return reefTransform(shellBytes, action: kCCDecrypt).flatMap { String(data: $0, encoding: .utf8) }
    }

    private func reefTransform(_ inletBytes: Data, action: Int) -> Data? {
        let reefBufferCount = inletBytes.count + kCCBlockSizeAES128
        var reefOutput = Data(count: reefBufferCount)
        var reefMoved: size_t = 0

        let status = reefOutput.withUnsafeMutableBytes { outputBytes in
            inletBytes.withUnsafeBytes { sourceBytes in
                reefSeedData.withUnsafeBytes { seedBytes in
                    reefKeyData.withUnsafeBytes { keyBytes in
                        CCCrypt(
                            CCOperation(action),
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress,
                            reefKeyData.count,
                            seedBytes.baseAddress,
                            sourceBytes.baseAddress,
                            inletBytes.count,
                            outputBytes.baseAddress,
                            reefBufferCount,
                            &reefMoved
                        )
                    }
                }
            }
        }

        guard status == kCCSuccess else { return nil }
        reefOutput.removeSubrange(reefMoved..<reefOutput.count)
        return reefOutput
    }
}

enum SuliJoyGinKeychain {
    private static var reefServiceName: String {
        (Bundle.main.bundleIdentifier ?? "com.sulijoy.share") + ".sulijoyGin"
    }

    private static var reefDeviceAccount: String {
        reefServiceName + SuliJoyGinGlyph.deviceTail
    }

    private static var reefEntryAccount: String {
        reefServiceName + SuliJoyGinGlyph.secretTail
    }

    static func reefDeviceRibbon() -> String {
        if let existingRibbon = reefLoad(account: reefDeviceAccount) {
            return existingRibbon
        }
        let freshRibbon = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        reefSave(freshRibbon, account: reefDeviceAccount)
        return freshRibbon
    }

    static func reefSaveEntrySecret(_ secret: String) {
        reefSave(secret, account: reefEntryAccount)
    }

    static func reefEntrySecret() -> String? {
        reefLoad(account: reefEntryAccount)
    }

    private static func reefLoad(account: String) -> String? {
        let request: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: reefServiceName,
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

    private static func reefSave(_ value: String, account: String) {
        reefDelete(account: account)
        guard let payload = value.data(using: .utf8) else { return }
        let request: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: reefServiceName,
            kSecAttrAccount as String: account,
            kSecValueData as String: payload,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        SecItemAdd(request as CFDictionary, nil)
    }

    private static func reefDelete(account: String) {
        let request: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: reefServiceName,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(request as CFDictionary)
    }
}

extension Data {
    func suliJoyGinHexRibbon() -> String {
        map { String(format: SuliJoyGinGlyph.shortBytePair, $0) }.joined()
    }

    init?(suliJoyGinHexRibbon hexText: String) {
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
    var suliJoyGinVersionRibbon: String {
        object(forInfoDictionaryKey: SuliJoyGinGlyph.bundleVersion) as? String ?? ""
    }
}

final class SuliJoyGinNetworkReef {
    static let shared = SuliJoyGinNetworkReef()

    private init() {}

    func reefPost(
        path: String,
        params: [String: Any],
        receiptMode: Bool = false,
        done: @escaping (Result<[String: Any]?, Error>) -> Void = { _ in }
    ) {
        guard let reefURL = URL(string: SuliJoyGinConfiguration.shared.reefBaseEndpoint + path) else {
            done(.failure(NSError(domain: SuliJoyGinGlyph.urlError, code: 400)))
            return
        }

        guard
            let jsonText = Self.reefJSONText(from: params),
            let cipher = SuliJoyGinCipher(),
            let wrappedText = cipher.reefWrap(jsonText),
            let payload = wrappedText.data(using: .utf8)
        else { return }

        var request = URLRequest(url: reefURL)
        request.httpMethod = SuliJoyGinGlyph.postMethod
        request.httpBody = payload
        request.timeoutInterval = 15
        request.setValue(SuliJoyGinGlyph.jsonMime, forHTTPHeaderField: SuliJoyGinGlyph.contentHeader)
        request.setValue(SuliJoyGinConfiguration.shared.reefAppIdentity, forHTTPHeaderField: SuliJoyGinGlyph.identityHeader)
        request.setValue(Bundle.main.suliJoyGinVersionRibbon, forHTTPHeaderField: SuliJoyGinGlyph.versionHeader)
        request.setValue(SuliJoyGinKeychain.reefDeviceRibbon(), forHTTPHeaderField: SuliJoyGinGlyph.deviceHeader)
        request.setValue(Locale.current.languageCode ?? "", forHTTPHeaderField: SuliJoyGinGlyph.languageHeader)
        request.setValue(UserDefaults.standard.string(forKey: SuliJoyGinGlyph.sessionVault) ?? "", forHTTPHeaderField: SuliJoyGinGlyph.sessionHeader)
        request.setValue(UserDefaults.standard.string(forKey: SuliJoyGinGlyph.pushVault) ?? "", forHTTPHeaderField: SuliJoyGinGlyph.pushHeader)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                DispatchQueue.main.async { done(.failure(error)) }
                return
            }
            guard let data else {
                DispatchQueue.main.async {
                    done(.failure(NSError(domain: SuliJoyGinGlyph.noData, code: 1000)))
                }
                return
            }
            self.reefDecode(data: data, receiptMode: receiptMode, done: done)
        }.resume()
    }

    private func reefDecode(
        data: Data,
        receiptMode: Bool,
        done: @escaping (Result<[String: Any]?, Error>) -> Void
    ) {
        do {
            guard let envelope = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                throw NSError(domain: SuliJoyGinGlyph.badJson, code: 1001)
            }

            if receiptMode {
                guard
                    let code = envelope[SuliJoyGinGlyph.code] as? String,
                    code == SuliJoyGinGlyph.okCode
                else {
                    DispatchQueue.main.async {
                        done(.failure(NSError(domain: SuliJoyGinGlyph.storeError, code: 1001)))
                    }
                    return
                }
                DispatchQueue.main.async { done(.success([:])) }
                return
            }

            guard
                let code = envelope[SuliJoyGinGlyph.code] as? String,
                code == SuliJoyGinGlyph.okCode,
                let wrappedResult = envelope[SuliJoyGinGlyph.result] as? String
            else {
                throw NSError(
                    domain: envelope[SuliJoyGinGlyph.serverText] as? String ?? SuliJoyGinGlyph.fallbackBack,
                    code: 1002
                )
            }

            guard
                let cipher = SuliJoyGinCipher(),
                let resultText = cipher.reefUnwrap(hexText: wrappedResult),
                let resultData = resultText.data(using: .utf8),
                let result = try JSONSerialization.jsonObject(with: resultData) as? [String: Any]
            else {
                throw NSError(domain: SuliJoyGinGlyph.cipherBack, code: 1003)
            }
            DispatchQueue.main.async { done(.success(result)) }
        } catch {
            DispatchQueue.main.async { done(.failure(error)) }
        }
    }

    static func reefJSONText(from dict: [String: Any]) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: dict) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
