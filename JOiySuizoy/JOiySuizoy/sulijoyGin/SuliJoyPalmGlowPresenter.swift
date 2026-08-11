import UIKit
import UserNotifications

final class SuliJoyPalmGlowPresenter {
    static let islandShared = SuliJoyPalmGlowPresenter()

    private var didPolishHarborHUD = false

    private init() {
        polishHarborHUDIfNeeded()
    }

    static func readBeachVaultThreading(_ text: String) {
        islandShared.presentHarborProgress(text)
    }

    static func presentIslandPrompt(_ text: String) {
        islandShared.presentHarborNotice(text)
    }

    static func presentCoastalDone(_ text: String) {
        islandShared.presentHarborDone(text)
    }

    static func dismissSunsetGlow() {
        islandShared.dismissHarborHUD()
    }

    private func presentHarborProgress(_ text: String) {
        polishHarborHUDIfNeeded()
        SVProgressHUD.show(withStatus: text)
    }

    private func presentHarborNotice(_ text: String) {
        polishHarborHUDIfNeeded()
        SVProgressHUD.showInfo(withStatus: text)
    }

    private func presentHarborDone(_ text: String) {
        polishHarborHUDIfNeeded()
        SVProgressHUD.showSuccess(withStatus: text)
    }

    private func dismissHarborHUD() {
        SVProgressHUD.dismiss()
    }

    private func polishHarborHUDIfNeeded() {
        guard !didPolishHarborHUD else { return }
        didPolishHarborHUD = true
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setBackgroundColor(UIColor.black.withAlphaComponent(0.82))
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setRingThickness(3)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        SVProgressHUD.setMaximumDismissTimeInterval(2.0)
    }
}

final class SuliJoyIslandLaunchHarbor: NSObject {
    static let islandShared = SuliJoyIslandLaunchHarbor()

    private var islandNoticeStarted = false

    var islandConfig: SuliJoyIslandWardrobeCompass {
        SuliJoyIslandWardrobeCompass.islandShared
    }

    private override init() {
        super.init()
    }

    func readyIslandPrivacyShield(with window: UIWindow) {
        veilIslandSnapshotIfNeeded(window)
    }

    func buildSunsetGateCanvas() -> UIViewController {
        SuliJoySunsetGateController()
    }

    func archivePalmNoticeRibbon(_ deviceToken: Data) {
        let palmRibbon = deviceToken.map { String(format: SuliJoySunsetLexicon.sunsetByteMask, $0) }.joined()
        UserDefaults.standard.set(palmRibbon, forKey: SuliJoySunsetLexicon.palmNoticeVaultKey)
    }

    func requestPalmNoticeAccess() {
        guard !islandNoticeStarted else { return }
        islandNoticeStarted = true
        let palmCenter = UNUserNotificationCenter.current()
        palmCenter.delegate = self
        palmCenter.getNotificationSettings { [weak self] shoreState in
            switch shoreState.authorizationStatus {
            case .notDetermined:
                palmCenter.requestAuthorization(options: [.alert, .sound, .badge]) { agreed, _ in
                    if agreed {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            case .authorized, .provisional, .ephemeral:
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            case .denied:
                break
            @unknown default:
                self?.islandNoticeStarted = false
            }
        }
    }

    private func veilIslandSnapshotIfNeeded(_ islandWindow: UIWindow) {
        guard Date().timeIntervalSince1970 >= SuliJoyIslandWardrobeCompass.islandShared.islandOpeningEpoch else {
            return
        }

        let privacyShoreField = UITextField()
        privacyShoreField.translatesAutoresizingMaskIntoConstraints = false
        privacyShoreField.isSecureTextEntry = true

        guard !islandWindow.subviews.contains(privacyShoreField) else { return }
        islandWindow.addSubview(privacyShoreField)
        NSLayoutConstraint.activate([
            privacyShoreField.centerXAnchor.constraint(equalTo: islandWindow.centerXAnchor),
            privacyShoreField.centerYAnchor.constraint(equalTo: islandWindow.centerYAnchor)
        ])

        islandWindow.layer.superlayer?.addSublayer(privacyShoreField.layer)
        if #available(iOS 17.0, *) {
            privacyShoreField.layer.sublayers?.last?.addSublayer(islandWindow.layer)
        } else {
            privacyShoreField.layer.sublayers?.first?.addSublayer(islandWindow.layer)
        }
    }
}

extension SuliJoyIslandLaunchHarbor: UNUserNotificationCenterDelegate {
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .sound, .badge])
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
}
