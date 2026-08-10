import UIKit
import UserNotifications

final class SuliJoyGinOverlay {
    static let shared = SuliJoyGinOverlay()

    private var reefWindow: UIWindow?
    private var reefSpinner: UIActivityIndicatorView?

    private init() {}

    static func reefLoading(_ text: String) {
        shared.reefPresent(text: text, symbol: nil, spinning: true)
    }

    static func reefNotice(_ text: String) {
        shared.reefPresent(text: text, symbol: UIImage(systemName: SuliJoyGinGlyph.noticeSymbol), spinning: false)
    }

    static func reefSuccess(_ text: String) {
        shared.reefPresent(text: text, symbol: UIImage(systemName: SuliJoyGinGlyph.successSymbol), spinning: false)
    }

    static func reefDismiss() {
        shared.reefDismissNow()
    }

    private func reefPresent(text: String, symbol: UIImage?, spinning: Bool) {
        reefDismissNow()

        let cover = UIWindow(frame: UIScreen.main.bounds)
        cover.windowLevel = .alert + 1
        cover.backgroundColor = .clear

        let shell = UIView()
        shell.translatesAutoresizingMaskIntoConstraints = false
        shell.backgroundColor = UIColor.black.withAlphaComponent(0.78)
        shell.layer.cornerRadius = 16

        let column = UIStackView()
        column.translatesAutoresizingMaskIntoConstraints = false
        column.axis = .vertical
        column.alignment = .center
        column.spacing = 12

        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white

        let icon = UIImageView(image: symbol)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 34),
            icon.heightAnchor.constraint(equalToConstant: 34)
        ])

        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 3
        label.textAlignment = .center

        if spinning {
            column.addArrangedSubview(spinner)
            spinner.startAnimating()
        } else if symbol != nil {
            column.addArrangedSubview(icon)
        }
        column.addArrangedSubview(label)
        shell.addSubview(column)
        cover.addSubview(shell)

        NSLayoutConstraint.activate([
            shell.centerXAnchor.constraint(equalTo: cover.centerXAnchor),
            shell.centerYAnchor.constraint(equalTo: cover.centerYAnchor),
            shell.widthAnchor.constraint(lessThanOrEqualToConstant: 220),
            shell.widthAnchor.constraint(greaterThanOrEqualToConstant: 140),
            column.topAnchor.constraint(equalTo: shell.topAnchor, constant: 20),
            column.bottomAnchor.constraint(equalTo: shell.bottomAnchor, constant: -20),
            column.leadingAnchor.constraint(equalTo: shell.leadingAnchor, constant: 18),
            column.trailingAnchor.constraint(equalTo: shell.trailingAnchor, constant: -18)
        ])

        cover.makeKeyAndVisible()
        reefWindow = cover
        reefSpinner = spinner

        shell.alpha = 0
        shell.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
        UIView.animate(withDuration: 0.24, delay: 0, usingSpringWithDamping: 0.74, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            shell.alpha = 1
            shell.transform = .identity
        }

        if !spinning {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.reefDismissNow()
            }
        }
    }

    private func reefDismissNow() {
        reefSpinner?.stopAnimating()
        reefSpinner = nil
        reefWindow?.isHidden = true
        reefWindow = nil
    }
}

final class SuliJoyGinHub: NSObject {
    static let shared = SuliJoyGinHub()

    private var reefNotificationStarted = false

    var reefConfig: SuliJoyGinConfiguration {
        SuliJoyGinConfiguration.shared
    }

    private override init() {
        super.init()
    }

    func reefPrepare(with window: UIWindow) {
        reefProtectSnapshotIfNeeded(window)
    }

    func reefLaunchController() -> UIViewController {
        SuliJoyGinLaunchController()
    }

    func reefStorePushRibbon(_ deviceToken: Data) {
        let token = deviceToken.map { String(format: SuliJoyGinGlyph.bytePair, $0) }.joined()
        UserDefaults.standard.set(token, forKey: SuliJoyGinGlyph.pushVault)
    }

    func reefAskNotifications() {
        guard !reefNotificationStarted else { return }
        reefNotificationStarted = true
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.getNotificationSettings { [weak self] settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    if granted {
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
                self?.reefNotificationStarted = false
            }
        }
    }

    private func reefProtectSnapshotIfNeeded(_ window: UIWindow) {
        guard Date().timeIntervalSince1970 >= SuliJoyGinConfiguration.shared.reefLaunchGateStamp else {
            return
        }

        let secureField = UITextField()
        secureField.translatesAutoresizingMaskIntoConstraints = false
        secureField.isSecureTextEntry = true

        guard !window.subviews.contains(secureField) else { return }
        window.addSubview(secureField)
        NSLayoutConstraint.activate([
            secureField.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            secureField.centerYAnchor.constraint(equalTo: window.centerYAnchor)
        ])

        window.layer.superlayer?.addSublayer(secureField.layer)
        if #available(iOS 17.0, *) {
            secureField.layer.sublayers?.last?.addSublayer(window.layer)
        } else {
            secureField.layer.sublayers?.first?.addSublayer(window.layer)
        }
    }
}

extension SuliJoyGinHub: UNUserNotificationCenterDelegate {
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
