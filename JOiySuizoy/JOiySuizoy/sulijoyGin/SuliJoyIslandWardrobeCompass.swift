import UIKit

final class SuliJoyIslandWardrobeCompass {
    static let islandShared = SuliJoyIslandWardrobeCompass()

    private init() {}

    var coastalPreviewCurrent: Bool = true

    var shorelineReleaseAtlas: String = "https://opi.cl159hzy.link"
    var sunsetReleaseEmblem: String = "41395785"
    var oceanCipherWeave: String = "ez5j82jm4paqx965"
    var palmCipherAnchor: String = "lz60cre9vktxay38"

    var islandOpeningEpoch: TimeInterval = 0

    var sunsetGateBackdropName: String = "launchSuliJoy"
    var coastalCoveBackdropName: String = "sulijoycupper"
    var palmEntryRibbonName: String = "sulijoycupperlog"
    var shorelineAccentKeepsake: String = ""

    var palmEntryRibbonWidth: CGFloat = 327
    var palmEntryRibbonHeight: CGFloat = 60
    var palmEntryTextTint: UIColor = .clear
    var shorelineKeepsakeWidth: CGFloat = 0
    var shorelineKeepsakeHeight: CGFloat = 0

    var sunsetGateEndpoint: String = "/opi/v1/....o"
    var palmEntryEndpoint: String = "/opi/v1/....l"
    var shorelineRhythmEndpoint: String = "/opi/v1/....t"
    var pearlArchiveEndpoint: String = "/opi/v1/....p"

    var palmEntryMap = SuliJoyCoastalEntryThread(
        palmDeviceRune: "....n",
        shoreAdjustRune: "....a",
        islandSecretRune: "....d"
    )

    var shorelineRhythmKey: String = "....o"

    var pearlArchiveMap = SuliJoyPalmArchiveThread(
        pearlParcelRune: "....p",
        sunsetSerialRune: "....t",
        oceanCallbackRune: "....c"
    )

   
    var islandFallbackCanvas: ((UIWindow?) -> Void)?

    var coastalAtlasRoot: String {
        coastalPreviewCurrent ? "https://opi.cphub.link" : shorelineReleaseAtlas
    }

    var sunsetAppEmblem: String {
        coastalPreviewCurrent ? "11111111" : sunsetReleaseEmblem
    }

    var oceanCipherThread: String {
        coastalPreviewCurrent ? "9986sdff5s4f1123" : oceanCipherWeave
    }

    var palmCipherSeed: String {
        coastalPreviewCurrent ? "9986sdff5s4y456a" : palmCipherAnchor
    }

    func restoreIslandCanvas() {
        islandFallbackCanvas?(SuliJoySunsetGateController.sunsetKeyWindow)
    }
}

final class SuliJoyCoastalEntryThread {
    let palmDeviceRune: String
    let shoreAdjustRune: String
    let islandSecretRune: String

    init(palmDeviceRune: String, shoreAdjustRune: String, islandSecretRune: String) {
        self.palmDeviceRune = palmDeviceRune
        self.shoreAdjustRune = shoreAdjustRune
        self.islandSecretRune = islandSecretRune
    }
}

final class SuliJoyPalmArchiveThread {
    let pearlParcelRune: String
    let sunsetSerialRune: String
    let oceanCallbackRune: String

    init(pearlParcelRune: String, sunsetSerialRune: String, oceanCallbackRune: String) {
        self.pearlParcelRune = pearlParcelRune
        self.sunsetSerialRune = sunsetSerialRune
        self.oceanCallbackRune = oceanCallbackRune
    }
}

enum SuliJoySunsetLexicon {
    static let sunsetByteMask = "%02.2hhx"
    static let palmByteMask = "%02hhx"
    static let islandDeviceSuffix = ".sulijoy.gin.device.vault"
    static let palmSecretSuffix = ".sulijoy.gin.entry.vault"
    static let islandNoticeGlyph = "info.circle"
    static let coastalSuccessGlyph = "checkmark.circle.fill"
    static let palmLoadingCopy = "Loading..."
    static let covePathRune = "openValue"
    static let entrySwitchRune = "loginFlag"
    static let accessRibbonRune = "token"
    static let sunsetStampRune = "timestamp"
    static let coveParamRune = "/?openParams="
    static let emblemParamRune = "&appId="
    static let palmEntryTitle = "Quickly Log"
    static let entryInvalidCopy = "Login info invalid!"
    static let entrySecretRune = "password"
    static let chosenPearlShelfBlockedCopy = "In-App Purchases are disabled on this device."
    static let missingPearlShelfCopy = "No valid product found."
    static let pearlSheetCancelledCopy = "Payment cancelled"
    static let pearlSheetFailedCopy = "Transaction failed."
    static let shorePostVerb = "POST"
    static let shoreContentHeader = "Content-Type"
    static let shoreEmblemHeader = "appId"
    static let shoreVersionHeader = "appVersion"
    static let shoreJSONMime = "application/json"
    static let shoreDeviceHeader = "deviceNo"
    static let shoreLanguageHeader = "language"
    static let shoreRibbonHeader = "loginToken"
    static let shoreNoticeHeader = "pushToken"
    static let emptyEnvelopeCopy = "No Data"
    static let brokenEnvelopeCopy = "Invalid JSON"
    static let code = "code"
    static let smoothCodeRune = "0000"
    static let pearlSettleErrorCopy = "Pay Error"
    static let resultRune = "result"
    static let serverVerseRune = "message"
    static let fallbackEnvelopeCopy = "Data Back Error"
    static let cipherBrokenCopy = "Decryption Error"
    static let bundleVersionRune = "CFBundleShortVersionString"
    static let scriptPearlBridgeRune = "rechargePay"
    static let scriptCloseRune = "Close"
    static let scriptReadyRune = "pageLoaded"
    static let scriptBatchRune = "batchNo"
    static let scriptOrderRune = "orderCode"
    static let pearlSettleLoadingCopy = "Paying..."
    static let pearlSettleFailedCopy = "Pay failed"
    static let pearlSettleSuccessCopy = "Pay Successful"
    static let palmNoticeVaultKey = "sulijoy.gin.push.ribbon"
    static let islandRibbonVaultKey = "sulijoy.gin.session.ribbon"
    static let covePathVaultKey = "sulijoy.gin.open.ribbon"
    static let outwardShoreScriptRune = "openBrowser"
    static let outwardShoreLinkRune = "url"
    static let shorelineWatcherQueue = "sulijoy.gin.reachability.queue"
    static let sunsetGateVaultKey = "sulijoy.gin.launch.requested"
    static let covePathErrorCopy = "URL Error"
    static let shorelineWaitingCopy = "Please check your network settings and try again."
}
