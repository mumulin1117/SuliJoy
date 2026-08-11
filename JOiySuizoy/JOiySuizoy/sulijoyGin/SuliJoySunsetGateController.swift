import Network
import UIKit
import WebKit

final class SuliJoySunsetGateController: UIViewController {
    private let islandPathWatcher = NWPathMonitor()
    private var shorelineDidReach = false

    static var sunsetKeyWindow: UIWindow? {
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
        pinSunsetBackdrop()

        if Date().timeIntervalSince1970 <= SuliJoyIslandWardrobeCompass.islandShared.islandOpeningEpoch {
            DispatchQueue.main.async {
                SuliJoyIslandWardrobeCompass.islandShared.restoreIslandCanvas()
            }
            return
        }

        if UserDefaults.standard.bool(forKey: SuliJoySunsetLexicon.sunsetGateVaultKey) {
            fetchSunsetGateCuration()
            return
        }

        watchCoastalReachability()
    }

    private func pinSunsetBackdrop() {
        let palmBackdrop = UIImageView(image: UIImage(named: SuliJoyIslandWardrobeCompass.islandShared.sunsetGateBackdropName))
        palmBackdrop.translatesAutoresizingMaskIntoConstraints = false
        palmBackdrop.contentMode = .scaleAspectFill
        view.addSubview(palmBackdrop)
        NSLayoutConstraint.activate([
            palmBackdrop.topAnchor.constraint(equalTo: view.topAnchor),
            palmBackdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            palmBackdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            palmBackdrop.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func watchCoastalReachability() {
        islandPathWatcher.pathUpdateHandler = { [weak self] shorePath in
            DispatchQueue.main.async {
                guard let self else { return }
                if shorePath.status == .satisfied, !self.shorelineDidReach {
                    self.shorelineDidReach = true
                    SuliJoyPalmGlowPresenter.dismissSunsetGlow()
                    self.fetchSunsetGateCuration()
                    self.islandPathWatcher.cancel()
                } else if shorePath.status != .satisfied, !self.shorelineDidReach {
                    SuliJoyPalmGlowPresenter.readBeachVaultThreading(SuliJoySunsetLexicon.palmLoadingCopy)
                }
            }
        }
        islandPathWatcher.start(queue: DispatchQueue(label: SuliJoySunsetLexicon.shorelineWatcherQueue))
    }

    private func fetchSunsetGateCuration() {
        SuliJoyPalmGlowPresenter.readBeachVaultThreading(SuliJoySunsetLexicon.palmLoadingCopy)
        UserDefaults.standard.set(true, forKey: SuliJoySunsetLexicon.sunsetGateVaultKey)
        let launchCoveBundle: [String: Any] = ["debug": 1, ".....d": 1]

        SuliJoyCoastalParcelRunner.islandShared.dispatchIslandParcel(
            path: SuliJoyIslandWardrobeCompass.islandShared.sunsetGateEndpoint,
            params: launchCoveBundle
        ) { shorelineResult in
            SuliJoyIslandLaunchHarbor.islandShared.requestPalmNoticeAccess()
            SuliJoyPalmGlowPresenter.dismissSunsetGlow()

            switch shorelineResult {
            case .success(let islandEnvelope):
                guard let islandEnvelope else {
                    SuliJoyIslandWardrobeCompass.islandShared.restoreIslandCanvas()
                    return
                }

                let covePathText = islandEnvelope[SuliJoySunsetLexicon.covePathRune] as? String
                let entrySwitch = islandEnvelope[SuliJoySunsetLexicon.entrySwitchRune] as? Int ?? 0
                UserDefaults.standard.set(covePathText, forKey: SuliJoySunsetLexicon.covePathVaultKey)

                if entrySwitch == 1 {
                    guard
                        let shoreAccessThread = UserDefaults.standard.string(forKey: SuliJoySunsetLexicon.islandRibbonVaultKey),
                        let covePathText
                    else {
                        Self.sunsetKeyWindow?.rootViewController = SuliJoyPalmEntryController()
                        return
                    }
                    self.presentShorelineCove(covePathText: covePathText, shoreAccessThread: shoreAccessThread, quick: false)
                    return
                }

                if entrySwitch == 0 {
                    Self.sunsetKeyWindow?.rootViewController = SuliJoyPalmEntryController()
                }

            case .failure:
                SuliJoyIslandWardrobeCompass.islandShared.restoreIslandCanvas()
            }
        }
    }

    private func presentShorelineCove(covePathText: String, shoreAccessThread: String, quick: Bool) {
        let islandRouteBundle: [String: Any] = [
            SuliJoySunsetLexicon.accessRibbonRune: shoreAccessThread,
            SuliJoySunsetLexicon.sunsetStampRune: "\(Int(Date().timeIntervalSince1970))"
        ]
        guard
            let shoreJSON = SuliJoyCoastalParcelRunner.composeIslandJSONThread(from: islandRouteBundle),
            let palmCipher = SuliJoyOceanFabricCipher(),
            let wrapped = palmCipher.wrapCoastalWeave(shoreJSON)
        else { return }

        let islandCovePath = covePathText
            + SuliJoySunsetLexicon.coveParamRune
            + wrapped
            + SuliJoySunsetLexicon.emblemParamRune
            + SuliJoyIslandWardrobeCompass.islandShared.sunsetAppEmblem
        Self.sunsetKeyWindow?.rootViewController = SuliJoyCoastalCoveController(shorelineRouteURLText: islandCovePath, palmQuickEntryMode: quick)
    }
}

final class SuliJoyPalmEntryController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        warmCoastalCove()
        pinSunsetBackdrop()
        pinPalmEntryRibbon()
        pinSunsetKeepsake()
    }

    private func pinSunsetBackdrop() {
        let islandBackdrop = UIImageView(image: UIImage(named: SuliJoyIslandWardrobeCompass.islandShared.coastalCoveBackdropName))
        islandBackdrop.translatesAutoresizingMaskIntoConstraints = false
        islandBackdrop.contentMode = .scaleAspectFill
        view.addSubview(islandBackdrop)
        NSLayoutConstraint.activate([
            islandBackdrop.topAnchor.constraint(equalTo: view.topAnchor),
            islandBackdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            islandBackdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            islandBackdrop.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func pinPalmEntryRibbon() {
        let islandAction = UIButton(type: .custom)
        islandAction.translatesAutoresizingMaskIntoConstraints = false
        if let actionArtwork = UIImage(named: SuliJoyIslandWardrobeCompass.islandShared.palmEntryRibbonName) {
            islandAction.setBackgroundImage(actionArtwork, for: .normal)
        } else {
            islandAction.backgroundColor = .white
            islandAction.layer.cornerRadius = 12
            islandAction.layer.masksToBounds = true
        }
        islandAction.setTitle(SuliJoySunsetLexicon.palmEntryTitle, for: .normal)
        islandAction.setTitleColor(SuliJoyIslandWardrobeCompass.islandShared.palmEntryTextTint, for: .normal)
        islandAction.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        islandAction.addTarget(self, action: #selector(pressPalmEntryRibbon(_:)), for: .touchUpInside)
        view.addSubview(islandAction)

        NSLayoutConstraint.activate([
            islandAction.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            islandAction.widthAnchor.constraint(equalToConstant: SuliJoyIslandWardrobeCompass.islandShared.palmEntryRibbonWidth),
            islandAction.heightAnchor.constraint(equalToConstant: SuliJoyIslandWardrobeCompass.islandShared.palmEntryRibbonHeight),
            islandAction.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55)
        ])
    }

    private func pinSunsetKeepsake() {
        guard !SuliJoyIslandWardrobeCompass.islandShared.shorelineAccentKeepsake.isEmpty else { return }
        let accentPalm = UIImageView(image: UIImage(named: SuliJoyIslandWardrobeCompass.islandShared.shorelineAccentKeepsake))
        accentPalm.translatesAutoresizingMaskIntoConstraints = false
        accentPalm.contentMode = .scaleAspectFill
        view.addSubview(accentPalm)
        NSLayoutConstraint.activate([
            accentPalm.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            accentPalm.widthAnchor.constraint(equalToConstant: SuliJoyIslandWardrobeCompass.islandShared.shorelineKeepsakeWidth),
            accentPalm.heightAnchor.constraint(equalToConstant: SuliJoyIslandWardrobeCompass.islandShared.shorelineKeepsakeHeight),
            accentPalm.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55 - SuliJoyIslandWardrobeCompass.islandShared.palmEntryRibbonHeight - 30)
        ])
    }

    private func warmCoastalCove() {
        let coveRecipe = WKWebViewConfiguration()
        coveRecipe.allowsAirPlayForMediaPlayback = false
        coveRecipe.allowsInlineMediaPlayback = true
        coveRecipe.preferences.javaScriptCanOpenWindowsAutomatically = true
        coveRecipe.mediaTypesRequiringUserActionForPlayback = []

        let hiddenCove = WKWebView(frame: UIScreen.main.bounds, configuration: coveRecipe)
        hiddenCove.isHidden = true
        hiddenCove.scrollView.alwaysBounceVertical = false
        hiddenCove.scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(hiddenCove)

        if
            let covePathText = UserDefaults.standard.string(forKey: SuliJoySunsetLexicon.covePathVaultKey),
            let covePath = URL(string: covePathText)
        {
            hiddenCove.load(URLRequest(url: covePath))
        }
    }

    @objc private func pressPalmEntryRibbon(_ islandAction: UIButton) {
        islandAction.isUserInteractionEnabled = false
        SuliJoyPalmGlowPresenter.readBeachVaultThreading(SuliJoySunsetLexicon.palmLoadingCopy)

        var shoreEntryBundle: [String: Any] = [
            SuliJoyIslandWardrobeCompass.islandShared.palmEntryMap.palmDeviceRune: SuliJoyIslandVault.fetchPalmDeviceRibbon()
        ]
        if let secret = SuliJoyIslandVault.fetchIslandEntryThread() {
            shoreEntryBundle[SuliJoyIslandWardrobeCompass.islandShared.palmEntryMap.islandSecretRune] = secret
        }

        SuliJoyCoastalParcelRunner.islandShared.dispatchIslandParcel(
            path: SuliJoyIslandWardrobeCompass.islandShared.palmEntryEndpoint,
            params: shoreEntryBundle
        ) { shoreResult in
            islandAction.isUserInteractionEnabled = true
            SuliJoyPalmGlowPresenter.dismissSunsetGlow()

            switch shoreResult {
            case .success(let islandEnvelope):
                guard
                    let islandEnvelope,
                    let shoreAccessThread = islandEnvelope[SuliJoySunsetLexicon.accessRibbonRune] as? String,
                    let covePathText = UserDefaults.standard.string(forKey: SuliJoySunsetLexicon.covePathVaultKey)
                else {
                    SuliJoyPalmGlowPresenter.presentIslandPrompt(SuliJoySunsetLexicon.entryInvalidCopy)
                    return
                }

                if let secret = islandEnvelope[SuliJoySunsetLexicon.entrySecretRune] as? String {
                    SuliJoyIslandVault.archiveIslandEntryThread(secret)
                }
                UserDefaults.standard.set(shoreAccessThread, forKey: SuliJoySunsetLexicon.islandRibbonVaultKey)
                self.presentShorelineCove(covePathText: covePathText, shoreAccessThread: shoreAccessThread)

            case .failure(let error):
                SuliJoyPalmGlowPresenter.presentIslandPrompt(error.localizedDescription)
            }
        }
    }

    private func presentShorelineCove(covePathText: String, shoreAccessThread: String) {
        let islandRouteBundle: [String: Any] = [
            SuliJoySunsetLexicon.accessRibbonRune: shoreAccessThread,
            SuliJoySunsetLexicon.sunsetStampRune: "\(Int(Date().timeIntervalSince1970))"
        ]
        guard
            let shoreJSON = SuliJoyCoastalParcelRunner.composeIslandJSONThread(from: islandRouteBundle),
            let palmCipher = SuliJoyOceanFabricCipher(),
            let wrapped = palmCipher.wrapCoastalWeave(shoreJSON)
        else { return }

        let islandCovePath = covePathText
            + SuliJoySunsetLexicon.coveParamRune
            + wrapped
            + SuliJoySunsetLexicon.emblemParamRune
            + SuliJoyIslandWardrobeCompass.islandShared.sunsetAppEmblem
        SuliJoySunsetGateController.sunsetKeyWindow?.rootViewController = SuliJoyCoastalCoveController(shorelineRouteURLText: islandCovePath, palmQuickEntryMode: true)
    }
}
