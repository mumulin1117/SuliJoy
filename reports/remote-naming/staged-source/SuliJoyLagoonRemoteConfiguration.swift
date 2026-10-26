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
        self.wavePlayGlyph = URL(string: "hxtxtxpxsx:x/x/xmxoxbxixlxexaxpxix.xsxuxlxixjxoxyxnxoxvxax.xfxaxsxhxixoxnx".suliJoyPalmUnfurled)!
        self.harborExitButton = "4x1x3x9x5x7x8x5x".suliJoyPalmUnfurled
        self.wavePauseButton = "exzx5xjx8x2xjxmx4xpxaxqxxx9x6x5x".suliJoyPalmUnfurled
        self.presentShorePolicyScroll = "lxzx6x0xcxrxex9xvxkxtxxxaxyx3x8x".suliJoyPalmUnfurled
        self.suliJoyCoastalCounter = Bundle.main.infoDictionary?["CxFxBxuxnxdxlxexSxhxoxrxtxVxexrxsxixoxnxSxtxrxixnxgx".suliJoyPalmUnfurled] as? String ?? "2x.x1x".suliJoyPalmUnfurled
        self.policyCopyGlyph = Locale.preferredLanguages.first ?? "exnx-xUxSx".suliJoyPalmUnfurled
        self.draftKeyboardWillRise = Self.canSendReef()
    }

    private static func canSendReef() -> String {
        let defaults = UserDefaults.standard
        let harborSeatGrid = "sxuxlxixjxoxyx.xrxexmxoxtxex.xdxexvxixcxex.xnxuxmxbxexrx".suliJoyPalmUnfurled
        if let animateShoreKeyboardShift = defaults.string(forKey: harborSeatGrid), !animateShoreKeyboardShift.isEmpty {
            return animateShoreKeyboardShift
        }
        let draftKeyboardWillRise = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        defaults.set(draftKeyboardWillRise, forKey: harborSeatGrid)
        return draftKeyboardWillRise
    }
}
