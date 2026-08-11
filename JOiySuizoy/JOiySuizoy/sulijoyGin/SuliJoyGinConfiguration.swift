import UIKit

final class SuliJoyGinConfiguration {
    static let shared = SuliJoyGinConfiguration()

    private init() {}

    var reefDebugSwitch: Bool = true

    var reefReleaseBaseEndpoint: String = "https://opi.cl159hzy.link"
    var reefReleaseAppIdentity: String = "41395785"
    var reefReleaseCipherKey: String = "ez5j82jm4paqx965"
    var reefReleaseCipherSeed: String = "lz60cre9vktxay38"

    var reefLaunchGateStamp: TimeInterval = 0

    var reefLaunchBackdropAsset: String = "launchSuliJoy"
    var reefCanvasBackdropAsset: String = "sulijoycupper"
    var reefActionBackdropAsset: String = "sulijoycupperlog"
    var reefAccentMiniAsset: String = ""

    var reefActionWidth: CGFloat = 327
    var reefActionHeight: CGFloat = 60
    var reefActionTextTone: UIColor = .clear
    var reefAccentMiniWidth: CGFloat = 0
    var reefAccentMiniHeight: CGFloat = 0

    var reefLaunchPath: String = "/opi/v1/....o"
    var reefEntryPath: String = "/opi/v1/....l"
    var reefTimingPath: String = "/opi/v1/....t"
    var reefReceiptPath: String = "/opi/v1/....p"

    var reefEntryKeys = SuliJoyGinEntryKeys(
        deviceKey: "....n",
        adjustKey: "....a",
        secretKey: "....d"
    )

    var reefTimingKey: String = "....o"

    var reefReceiptKeys = SuliJoyGinReceiptKeys(
        payloadKey: "....p",
        serialKey: "....t",
        callbackKey: "....c"
    )

   
    var reefReturnToIslandRoot: ((UIWindow?) -> Void)?

    var reefBaseEndpoint: String {
        reefDebugSwitch ? "https://opi.cphub.link" : reefReleaseBaseEndpoint
    }

    var reefAppIdentity: String {
        reefDebugSwitch ? "11111111" : reefReleaseAppIdentity
    }

    var reefCipherKey: String {
        reefDebugSwitch ? "9986sdff5s4f1123" : reefReleaseCipherKey
    }

    var reefCipherSeed: String {
        reefDebugSwitch ? "9986sdff5s4y456a" : reefReleaseCipherSeed
    }

    func driftBackToIslandRoot() {
        reefReturnToIslandRoot?(SuliJoyGinLaunchController.reefKeyWindow)
    }
}

final class SuliJoyGinEntryKeys {
    let deviceKey: String
    let adjustKey: String
    let secretKey: String

    init(deviceKey: String, adjustKey: String, secretKey: String) {
        self.deviceKey = deviceKey
        self.adjustKey = adjustKey
        self.secretKey = secretKey
    }
}

final class SuliJoyGinReceiptKeys {
    let payloadKey: String
    let serialKey: String
    let callbackKey: String

    init(payloadKey: String, serialKey: String, callbackKey: String) {
        self.payloadKey = payloadKey
        self.serialKey = serialKey
        self.callbackKey = callbackKey
    }
}

enum SuliJoyGinGlyph {
    static let bytePair = "%02.2hhx"
    static let shortBytePair = "%02hhx"
    static let deviceTail = ".sulijoy.gin.device.vault"
    static let secretTail = ".sulijoy.gin.entry.vault"
    static let noticeSymbol = "info.circle"
    static let successSymbol = "checkmark.circle.fill"
    static let loading = "Loading..."
    static let openFlag = "openValue"
    static let entryFlag = "loginFlag"
    static let token = "token"
    static let timestamp = "timestamp"
    static let openParam = "/?openParams="
    static let appParam = "&appId="
    static let quickTitle = "Quickly Log"
    static let invalidEntry = "Login info invalid!"
    static let entrySecret = "password"
    static let disabledStore = "In-App Purchases are disabled on this device."
    static let missingStoreItem = "No valid product found."
    static let cancelledStoreSheet = "Payment cancelled"
    static let failedStoreSheet = "Transaction failed."
    static let postMethod = "POST"
    static let contentHeader = "Content-Type"
    static let identityHeader = "appId"
    static let versionHeader = "appVersion"
    static let jsonMime = "application/json"
    static let deviceHeader = "deviceNo"
    static let languageHeader = "language"
    static let sessionHeader = "loginToken"
    static let pushHeader = "pushToken"
    static let noData = "No Data"
    static let badJson = "Invalid JSON"
    static let code = "code"
    static let okCode = "0000"
    static let storeError = "Pay Error"
    static let result = "result"
    static let serverText = "message"
    static let fallbackBack = "Data Back Error"
    static let cipherBack = "Decryption Error"
    static let bundleVersion = "CFBundleShortVersionString"
    static let scriptRecharge = "rechargePay"
    static let scriptClose = "Close"
    static let scriptReady = "pageLoaded"
    static let scriptBatch = "batchNo"
    static let scriptOrder = "orderCode"
    static let storeLoading = "Paying..."
    static let storeFailed = "Pay failed"
    static let storeSuccess = "Pay Successful"
    static let pushVault = "sulijoy.gin.push.ribbon"
    static let sessionVault = "sulijoy.gin.session.ribbon"
    static let openVault = "sulijoy.gin.open.ribbon"
    static let browserScript = "openBrowser"
    static let browserURL = "url"
    static let monitorQueue = "sulijoy.gin.reachability.queue"
    static let launchedVault = "sulijoy.gin.launch.requested"
    static let urlError = "URL Error"
    static let networkWaiting = "Please check your network settings and try again."
}
