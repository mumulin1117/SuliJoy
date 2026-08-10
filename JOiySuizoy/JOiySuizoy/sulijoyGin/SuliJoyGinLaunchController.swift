import Network
import UIKit
import WebKit

final class SuliJoyGinLaunchController: UIViewController {
    private let reefMonitor = NWPathMonitor()
    private var reefDidReach = false

    static var reefKeyWindow: UIWindow? {
        if #available(iOS 15.0, *) {
            let windows = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap(\.windows)
            return windows.first(where: \.isKeyWindow) ?? windows.first ?? UIApplication.shared.windows.first(where: \.isKeyWindow)
        }
        return UIApplication.shared.windows.first(where: \.isKeyWindow) ?? UIApplication.shared.windows.first
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reefInstallBackdrop()

        if Date().timeIntervalSince1970 <= SuliJoyGinConfiguration.shared.reefLaunchGateStamp {
            DispatchQueue.main.async {
                SuliJoyGinConfiguration.shared.driftBackToIslandRoot()
            }
            return
        }

        if UserDefaults.standard.bool(forKey: SuliJoyGinGlyph.launchedVault) {
            reefPerformLaunchRequest()
            return
        }

        reefWaitForPath()
    }

    private func reefInstallBackdrop() {
        let imageView = UIImageView(image: UIImage(named: SuliJoyGinConfiguration.shared.reefLaunchBackdropAsset))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func reefWaitForPath() {
        reefMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                guard let self else { return }
                if path.status == .satisfied, !self.reefDidReach {
                    self.reefDidReach = true
                    SuliJoyGinOverlay.reefDismiss()
                    self.reefPerformLaunchRequest()
                    self.reefMonitor.cancel()
                } else if path.status != .satisfied, !self.reefDidReach {
                    SuliJoyGinOverlay.reefLoading(SuliJoyGinGlyph.loading)
                }
            }
        }
        reefMonitor.start(queue: DispatchQueue(label: SuliJoyGinGlyph.monitorQueue))
    }

    private func reefPerformLaunchRequest() {
        SuliJoyGinOverlay.reefLoading(SuliJoyGinGlyph.loading)
        UserDefaults.standard.set(true, forKey: SuliJoyGinGlyph.launchedVault)
        let params: [String: Any] = ["debug": 1, ".....d": 1]

        SuliJoyGinNetworkReef.shared.reefPost(
            path: SuliJoyGinConfiguration.shared.reefLaunchPath,
            params: params
        ) { result in
            SuliJoyGinHub.shared.reefAskNotifications()
            SuliJoyGinOverlay.reefDismiss()

            switch result {
            case .success(let payload):
                guard let payload else {
                    SuliJoyGinConfiguration.shared.driftBackToIslandRoot()
                    return
                }

                let openValue = payload[SuliJoyGinGlyph.openFlag] as? String
                let entryFlag = payload[SuliJoyGinGlyph.entryFlag] as? Int ?? 0
                UserDefaults.standard.set(openValue, forKey: SuliJoyGinGlyph.openVault)

                if entryFlag == 1 {
                    guard
                        let token = UserDefaults.standard.string(forKey: SuliJoyGinGlyph.sessionVault),
                        let openValue
                    else {
                        Self.reefKeyWindow?.rootViewController = SuliJoyGinEntryController()
                        return
                    }
                    self.reefOpenCove(openValue: openValue, token: token, quick: false)
                    return
                }

                if entryFlag == 0 {
                    Self.reefKeyWindow?.rootViewController = SuliJoyGinEntryController()
                }

            case .failure:
                SuliJoyGinConfiguration.shared.driftBackToIslandRoot()
            }
        }
    }

    private func reefOpenCove(openValue: String, token: String, quick: Bool) {
        let params: [String: Any] = [
            SuliJoyGinGlyph.token: token,
            SuliJoyGinGlyph.timestamp: "\(Int(Date().timeIntervalSince1970))"
        ]
        guard
            let json = SuliJoyGinNetworkReef.reefJSONText(from: params),
            let cipher = SuliJoyGinCipher(),
            let wrapped = cipher.reefWrap(json)
        else { return }

        let final = openValue
            + SuliJoyGinGlyph.openParam
            + wrapped
            + SuliJoyGinGlyph.appParam
            + SuliJoyGinConfiguration.shared.reefAppIdentity
        Self.reefKeyWindow?.rootViewController = SuliJoyGinCoveController(reefURLText: final, reefQuickEntry: quick)
    }
}

final class SuliJoyGinEntryController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        reefPreheatCove()
        reefInstallBackdrop()
        reefInstallAction()
        reefInstallMiniAccent()
    }

    private func reefInstallBackdrop() {
        let imageView = UIImageView(image: UIImage(named: SuliJoyGinConfiguration.shared.reefCanvasBackdropAsset))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func reefInstallAction() {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: SuliJoyGinConfiguration.shared.reefActionBackdropAsset) {
            button.setBackgroundImage(image, for: .normal)
        } else {
            button.backgroundColor = .white
            button.layer.cornerRadius = 12
            button.layer.masksToBounds = true
        }
        button.setTitle(SuliJoyGinGlyph.quickTitle, for: .normal)
        button.setTitleColor(SuliJoyGinConfiguration.shared.reefActionTextTone, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(reefTapEntry(_:)), for: .touchUpInside)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: SuliJoyGinConfiguration.shared.reefActionWidth),
            button.heightAnchor.constraint(equalToConstant: SuliJoyGinConfiguration.shared.reefActionHeight),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55)
        ])
    }

    private func reefInstallMiniAccent() {
        guard !SuliJoyGinConfiguration.shared.reefAccentMiniAsset.isEmpty else { return }
        let imageView = UIImageView(image: UIImage(named: SuliJoyGinConfiguration.shared.reefAccentMiniAsset))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: SuliJoyGinConfiguration.shared.reefAccentMiniWidth),
            imageView.heightAnchor.constraint(equalToConstant: SuliJoyGinConfiguration.shared.reefAccentMiniHeight),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55 - SuliJoyGinConfiguration.shared.reefActionHeight - 30)
        ])
    }

    private func reefPreheatCove() {
        let config = WKWebViewConfiguration()
        config.allowsAirPlayForMediaPlayback = false
        config.allowsInlineMediaPlayback = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.mediaTypesRequiringUserActionForPlayback = []

        let hiddenCove = WKWebView(frame: UIScreen.main.bounds, configuration: config)
        hiddenCove.isHidden = true
        hiddenCove.scrollView.alwaysBounceVertical = false
        hiddenCove.scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(hiddenCove)

        if
            let openValue = UserDefaults.standard.string(forKey: SuliJoyGinGlyph.openVault),
            let url = URL(string: openValue)
        {
            hiddenCove.load(URLRequest(url: url))
        }
    }

    @objc private func reefTapEntry(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        SuliJoyGinOverlay.reefLoading(SuliJoyGinGlyph.loading)

        var params: [String: Any] = [
            SuliJoyGinConfiguration.shared.reefEntryKeys.deviceKey: SuliJoyGinKeychain.reefDeviceRibbon()
        ]
        if let secret = SuliJoyGinKeychain.reefEntrySecret() {
            params[SuliJoyGinConfiguration.shared.reefEntryKeys.secretKey] = secret
        }

        SuliJoyGinNetworkReef.shared.reefPost(
            path: SuliJoyGinConfiguration.shared.reefEntryPath,
            params: params
        ) { result in
            sender.isUserInteractionEnabled = true
            SuliJoyGinOverlay.reefDismiss()

            switch result {
            case .success(let payload):
                guard
                    let payload,
                    let token = payload[SuliJoyGinGlyph.token] as? String,
                    let openValue = UserDefaults.standard.string(forKey: SuliJoyGinGlyph.openVault)
                else {
                    SuliJoyGinOverlay.reefNotice(SuliJoyGinGlyph.invalidEntry)
                    return
                }

                if let secret = payload[SuliJoyGinGlyph.entrySecret] as? String {
                    SuliJoyGinKeychain.reefSaveEntrySecret(secret)
                }
                UserDefaults.standard.set(token, forKey: SuliJoyGinGlyph.sessionVault)
                self.reefOpenCove(openValue: openValue, token: token)

            case .failure(let error):
                SuliJoyGinOverlay.reefNotice(error.localizedDescription)
            }
        }
    }

    private func reefOpenCove(openValue: String, token: String) {
        let params: [String: Any] = [
            SuliJoyGinGlyph.token: token,
            SuliJoyGinGlyph.timestamp: "\(Int(Date().timeIntervalSince1970))"
        ]
        guard
            let json = SuliJoyGinNetworkReef.reefJSONText(from: params),
            let cipher = SuliJoyGinCipher(),
            let wrapped = cipher.reefWrap(json)
        else { return }

        let final = openValue
            + SuliJoyGinGlyph.openParam
            + wrapped
            + SuliJoyGinGlyph.appParam
            + SuliJoyGinConfiguration.shared.reefAppIdentity
        SuliJoyGinLaunchController.reefKeyWindow?.rootViewController = SuliJoyGinCoveController(reefURLText: final, reefQuickEntry: true)
    }
}
