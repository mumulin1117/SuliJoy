import Foundation
import UIKit

struct SuliJoyLagoonRemoteConfiguration {
    let baseURL: URL
    let appIdentifier: String
    let encryptionKey: String
    let encryptionIV: String
    let appVersion: String
    let language: String
    let deviceNumber: String

    static let shared = SuliJoyLagoonRemoteConfiguration()

    private init() {
        self.baseURL = URL(string: "https://app.d9venk431vi8tyj0ubz5.shop")!
        self.appIdentifier = "3672382372"
        self.encryptionKey = "BiTgTTDWAKTsAdSS"
        self.encryptionIV = "NoiJNEre3eAQbpRD"
        self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "2.1"
        self.language = Locale.preferredLanguages.first ?? "en-US"
        self.deviceNumber = Self.makeDeviceNumber()
    }

    private static func makeDeviceNumber() -> String {
        let defaults = UserDefaults.standard
        let storageKey = "sulijoy.remote.device.number"
        if let savedNumber = defaults.string(forKey: storageKey), !savedNumber.isEmpty {
            return savedNumber
        }
        let deviceNumber = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        defaults.set(deviceNumber, forKey: storageKey)
        return deviceNumber
    }
}
