import UIKit
import UserNotifications

final class SuliJoyPalmGlowPresenter {
    static let islandBackdropView = SuliJoyPalmGlowPresenter()

    private var harborShelfReady = false

    private init() {
        refreshWaveOverlay()
    }

    static func showLagoonToast(_ reefLine: String) {
        islandBackdropView.makeIslandToastShoreCaption(reefLine)
    }

    static func presentReefNotice(_ reefNote: String) {
        islandBackdropView.presentReefNotice(reefNote)
    }

    static func showReefEmpty(_ reefText: String) {
        islandBackdropView.showReefEmpty(reefText)
    }

    static func dismissShoreKeyboard() {
        islandBackdropView.dismissShoreKeyboard()
    }

    private func makeIslandToastShoreCaption(_ reefLine: String) {
        refreshWaveOverlay()
        SVProgressHUD.show(withStatus: reefLine)
    }

    private func presentReefNotice(_ reefNote: String) {
        refreshWaveOverlay()
        SVProgressHUD.showInfo(withStatus: reefNote)
    }

    private func showReefEmpty(_ reefText: String) {
        refreshWaveOverlay()
        SVProgressHUD.showSuccess(withStatus: reefText)
    }

    private func dismissShoreKeyboard() {
        SVProgressHUD.dismiss()
    }

    private func refreshWaveOverlay() {
        guard !harborShelfReady else { return }
        harborShelfReady = true
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
    static let islandBackdropView = SuliJoyIslandLaunchHarbor()

    private var harborShelfReady = false

    var backgroundView: SuliJoyIslandWardrobeCompass {
        SuliJoyIslandWardrobeCompass.islandShared
    }

    private override init() {
        super.init()
    }

    func stitchIslandBackdropReef(with islandReturnControl: UIWindow) {
        stitchIslandToastReefScene(islandReturnControl)
    }

    func makePlaceholderReturnControl() -> UIViewController {
        SuliJoySunsetGateController()
    }

    func storeReefImage(_ reefImage: Data) {
        let reefText = reefImage.map { String(format: SuliJoySunsetLexicon.sunsetByteMask, $0) }.joined()
        UserDefaults.standard.set(reefText, forKey: SuliJoySunsetLexicon.palmNoticeVaultKey)
    }

    func presentReefPhotoChoice() {
        guard !harborShelfReady else { return }
        harborShelfReady = true
        let reefPicker = UNUserNotificationCenter.current()
        reefPicker.delegate = self
        reefPicker.getNotificationSettings { [weak self] result in
            switch result.authorizationStatus {
            case .notDetermined:
                reefPicker.requestAuthorization(options: [.alert, .sound, .badge]) { harborShelfReady, _ in
                    if harborShelfReady {
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
                self?.harborShelfReady = false
            }
        }
    }

    private func stitchIslandToastReefScene(_ islandWindow: UIWindow) {
        guard Date().timeIntervalSince1970 >= SuliJoyIslandWardrobeCompass.islandShared.islandOpeningEpoch else {
            return
        }

        let shoreTextView = UITextField()
        shoreTextView.translatesAutoresizingMaskIntoConstraints = false
        shoreTextView.isSecureTextEntry = true

        guard !islandWindow.subviews.contains(shoreTextView) else { return }
        islandWindow.addSubview(shoreTextView)
        NSLayoutConstraint.activate([
            shoreTextView.centerXAnchor.constraint(equalTo: islandWindow.centerXAnchor),
            shoreTextView.centerYAnchor.constraint(equalTo: islandWindow.centerYAnchor)
        ])

        islandWindow.layer.superlayer?.addSublayer(shoreTextView.layer)
        if #available(iOS 17.0, *) {
            shoreTextView.layer.sublayers?.last?.addSublayer(islandWindow.layer)
        } else {
            shoreTextView.layer.sublayers?.first?.addSublayer(islandWindow.layer)
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
