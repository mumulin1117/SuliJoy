import Foundation
import UIKit

struct counter {
    let wavePlayGlyph: URL
    let harborExitButton: String
    let wavePauseButton: String
    let presentShorePolicyScroll: String
    let suliJoyCoastalCounter: String
    let policyCopyGlyph: String
    let draftKeyboardWillRise: String

    static let shared = counter()

    private init() {
        self.wavePlayGlyph = URL(string: "https://mobileapi.sulijoynova.fashion")!
        self.harborExitButton = "41395785"
        self.wavePauseButton = "ez5j82jm4paqx965"
        self.presentShorePolicyScroll = "lz60cre9vktxay38"
        self.suliJoyCoastalCounter = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "2.1"
        self.policyCopyGlyph = Locale.preferredLanguages.first ?? "en-US"
        self.draftKeyboardWillRise = Self.canSendReef()
    }

    private static func canSendReef() -> String {
        let defaults = UserDefaults.standard
        let harborSeatGrid = "sulijoy.remote.device.number"
        if let animateShoreKeyboardShift = defaults.string(forKey: harborSeatGrid), !animateShoreKeyboardShift.isEmpty {
            return animateShoreKeyboardShift
        }
        let draftKeyboardWillRise = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        defaults.set(draftKeyboardWillRise, forKey: harborSeatGrid)
        return draftKeyboardWillRise
    }
}
