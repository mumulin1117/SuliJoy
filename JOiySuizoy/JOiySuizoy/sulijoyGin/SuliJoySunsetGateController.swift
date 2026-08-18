import Network
import UIKit
import WebKit

final class SuliJoySunsetGateController: UIViewController {
    private let waveTicker = NWPathMonitor()
    private var harborShelfReady = false

    static var activeReefToken: UIWindow? {
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
        prepareIslandBackdropReef()

        if Date().timeIntervalSince1970 <= SuliJoyIslandWardrobeCompass.islandShared.islandOpeningEpoch {
            DispatchQueue.main.async {
                SuliJoyIslandWardrobeCompass.islandShared.restoreIslandCanvas()
            }
            return
        }

        if UserDefaults.standard.bool(forKey: SuliJoySunsetLexicon.sunsetGateVaultKey) {
            gatherPearlShelves()
            return
        }

        bindShoreKeyboardTides()
    }

    private func prepareIslandBackdropReef() {
        let islandBackdropView = UIImageView(image: UIImage(named: "launchSuliJoy"))
        islandBackdropView.translatesAutoresizingMaskIntoConstraints = false
        islandBackdropView.contentMode = .scaleAspectFill
        view.addSubview(islandBackdropView)
        NSLayoutConstraint.activate([
            islandBackdropView.topAnchor.constraint(equalTo: view.topAnchor),
            islandBackdropView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            islandBackdropView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            islandBackdropView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func bindShoreKeyboardTides() {
        waveTicker.pathUpdateHandler = { [weak self] shoreGrid in
            DispatchQueue.main.async {
                guard let self else { return }
                if shoreGrid.status == .satisfied, !self.harborShelfReady {
                    self.harborShelfReady = true
                    SuliJoyPalmGlowPresenter.dismissShoreKeyboard()
                    self.gatherPearlShelves()
                    self.waveTicker.cancel()
                } else if shoreGrid.status != .satisfied, !self.harborShelfReady {
                    SuliJoyPalmGlowPresenter.showLagoonToast(SuliJoySunsetLexicon.palmLoadingCopy)
                }
            }
        }
        waveTicker.start(queue: DispatchQueue(label: SuliJoySunsetLexicon.shorelineWatcherQueue))
    }

    private func gatherPearlShelves() {
        SuliJoyPalmGlowPresenter.showLagoonToast(SuliJoySunsetLexicon.palmLoadingCopy)
        UserDefaults.standard.set(true, forKey: SuliJoySunsetLexicon.sunsetGateVaultKey)
        let reefMetrics: [String: Any] = ["SuliJoyCoastalg": 1, "SuliJoyCoastald": 1]

        SuliJoyCoastalParcelRunner.islandGlowCanvas.renderReefContent(
            reefHeadline: "/opi/v1/sunsetGateEndpointo",
            reefMetrics: reefMetrics
        ) { harborAnswer in
            SuliJoyIslandLaunchHarbor.islandBackdropView.presentReefPhotoChoice()
            SuliJoyPalmGlowPresenter.dismissShoreKeyboard()

            switch harborAnswer {
            case .success(let result):
                guard let result else {
                    SuliJoyIslandWardrobeCompass.islandShared.restoreIslandCanvas()
                    return
                }

                let reefHeadline = result[SuliJoySunsetLexicon.covePathRune] as? String
                let activePhotoIndex = result[SuliJoySunsetLexicon.entrySwitchRune] as? Int ?? 0
                UserDefaults.standard.set(reefHeadline, forKey: SuliJoySunsetLexicon.covePathVaultKey)

                if activePhotoIndex == 1 {
                    guard
                        let reefText = UserDefaults.standard.string(forKey: SuliJoySunsetLexicon.islandRibbonVaultKey),
                        let reefHeadline
                    else {
                        Self.activeReefToken?.rootViewController = SuliJoyPalmEntryController()
                        return
                    }
                    self.showLocalPlaceholder(reefHeadline: reefHeadline, subreefHeadline: reefText, hideTabBar: false)
                    return
                }

                if activePhotoIndex == 0 {
                    Self.activeReefToken?.rootViewController = SuliJoyPalmEntryController()
                }

            case .failure:
                SuliJoyIslandWardrobeCompass.islandShared.restoreIslandCanvas()
            }
        }
    }

    private func showLocalPlaceholder(reefHeadline: String, subreefHeadline: String, hideTabBar: Bool) {
        let reefMetrics: [String: Any] = [
            SuliJoySunsetLexicon.accessRibbonRune: subreefHeadline,
            SuliJoySunsetLexicon.sunsetStampRune: "\(Int(Date().timeIntervalSince1970))"
        ]
        guard
            let reefText = SuliJoyCoastalParcelRunner.showReefEmpty(reefMetrics),
            let waveDraft = SuliJoyOceanFabricCipher(),
            let reefVisible = waveDraft.showReefEmpty(reefText)
        else { return }

        let reefRect = reefHeadline
            + SuliJoySunsetLexicon.coveParamRune
            + reefVisible
            + SuliJoySunsetLexicon.emblemParamRune
            + SuliJoyIslandWardrobeCompass.islandShared.sunsetAppEmblem
        Self.activeReefToken?.rootViewController = SuliJoyCoastalCoveController(shoreMailPhrase: reefRect, hasShoreConsent: hideTabBar)
    }
}

final class SuliJoyPalmEntryController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tuneWaveRow()
        prepareIslandBackdropReef()
        tuneTideConfirm()
//        tuneCrownRow()
    }

    private func prepareIslandBackdropReef() {
        let islandBackdropView = UIImageView(image: UIImage(named: "sulijoycupper"))
        islandBackdropView.translatesAutoresizingMaskIntoConstraints = false
        islandBackdropView.contentMode = .scaleAspectFill
        view.addSubview(islandBackdropView)
        NSLayoutConstraint.activate([
            islandBackdropView.topAnchor.constraint(equalTo: view.topAnchor),
            islandBackdropView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            islandBackdropView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            islandBackdropView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func tuneTideConfirm() {
        let shorePrimaryButton = UIButton(type: .custom)
        shorePrimaryButton.translatesAutoresizingMaskIntoConstraints = false
      let reefImage = UIImage(named: "sulijoycupperlog") 
            shorePrimaryButton.setBackgroundImage(reefImage, for: .normal)
//        } else {
//            shorePrimaryButton.backgroundColor = .white
//            shorePrimaryButton.layer.cornerRadius = 12
//            shorePrimaryButton.layer.masksToBounds = true
//        }
//        shorePrimaryButton.setTitle(SuliJoySunsetLexicon.palmEntryTitle, for: .normal)
//        shorePrimaryButton.setTitleColor(SuliJoyIslandWardrobeCompass.islandShared.palmEntryTextTint, for: .normal)
//        shorePrimaryButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        shorePrimaryButton.addTarget(self, action: #selector(confirmShoreMoment(_:)), for: .touchUpInside)
        view.addSubview(shorePrimaryButton)

        NSLayoutConstraint.activate([
            shorePrimaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shorePrimaryButton.widthAnchor.constraint(equalToConstant: 327),
            shorePrimaryButton.heightAnchor.constraint(equalToConstant: 60),
            shorePrimaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55)
        ])
    }

//    private func tuneCrownRow() {
//        guard !SuliJoyIslandWardrobeCompass.islandShared.shorelineAccentKeepsake.isEmpty else { return }
//        let pearlBadgeMark = UIImageView(image: UIImage(named: SuliJoyIslandWardrobeCompass.islandShared.shorelineAccentKeepsake))
//        pearlBadgeMark.translatesAutoresizingMaskIntoConstraints = false
//        pearlBadgeMark.contentMode = .scaleAspectFill
//        view.addSubview(pearlBadgeMark)
//        NSLayoutConstraint.activate([
//            pearlBadgeMark.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            pearlBadgeMark.widthAnchor.constraint(equalToConstant: SuliJoyIslandWardrobeCompass.islandShared.shorelineKeepsakeWidth),
//            pearlBadgeMark.heightAnchor.constraint(equalToConstant: SuliJoyIslandWardrobeCompass.islandShared.shorelineKeepsakeHeight),
//            pearlBadgeMark.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55 - SuliJoyIslandWardrobeCompass.islandShared.palmEntryRibbonHeight - 30)
//        ])
//    }

    private func tuneWaveRow() {
        let reefPicker = WKWebViewConfiguration()
        reefPicker.allowsAirPlayForMediaPlayback = false
        reefPicker.allowsInlineMediaPlayback = true
        reefPicker.preferences.javaScriptCanOpenWindowsAutomatically = true
        reefPicker.mediaTypesRequiringUserActionForPlayback = []

        let shoreScroll = WKWebView(frame: UIScreen.main.bounds, configuration: reefPicker)
        shoreScroll.isHidden = true
        shoreScroll.scrollView.alwaysBounceVertical = false
        shoreScroll.scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(shoreScroll)

        if
            let reefHeadline = UserDefaults.standard.string(forKey: SuliJoySunsetLexicon.covePathVaultKey),
            let reefURL = URL(string: reefHeadline)
        {
            shoreScroll.load(URLRequest(url: reefURL))
        }
    }

    @objc private func confirmShoreMoment(_ shorePrimaryButton: UIButton) {
        shorePrimaryButton.isUserInteractionEnabled = false
        SuliJoyPalmGlowPresenter.showLagoonToast(SuliJoySunsetLexicon.palmLoadingCopy)

        var reefMetrics: [String: Any] = [
            "palmEntryMapn": SuliJoyIslandVault.fetchLagoonGuest()
        ]
        if let reefText = SuliJoyIslandVault.refreshLagoonAgreementState() {
            reefMetrics["islandSecretRuned"] = reefText
        }

        SuliJoyCoastalParcelRunner.islandGlowCanvas.renderReefContent(
            reefHeadline: "/opi/v1/palmEntryEndpointl",
            reefMetrics: reefMetrics
        ) { result in
            shorePrimaryButton.isUserInteractionEnabled = true
            SuliJoyPalmGlowPresenter.dismissShoreKeyboard()

            switch result {
            case .success(let lagoonGuest):
                guard
                    let lagoonGuest,
                    let reefLine = lagoonGuest[SuliJoySunsetLexicon.accessRibbonRune] as? String,
                    let reefHeadline = UserDefaults.standard.string(forKey: SuliJoySunsetLexicon.covePathVaultKey)
                else {
                    SuliJoyPalmGlowPresenter.presentReefNotice(SuliJoySunsetLexicon.entryInvalidCopy)
                    return
                }

                if let reefText = lagoonGuest[SuliJoySunsetLexicon.entrySecretRune] as? String {
                    SuliJoyIslandVault.showReefUnlockNotice(reefText)
                }
                UserDefaults.standard.set(reefLine, forKey: SuliJoySunsetLexicon.islandRibbonVaultKey)
                self.showLocalPlaceholder(reefHeadline: reefHeadline, subreefHeadline: reefLine)

            case .failure(let error):
                SuliJoyPalmGlowPresenter.presentReefNotice(error.localizedDescription)
            }
        }
    }

    private func showLocalPlaceholder(reefHeadline: String, subreefHeadline: String) {
        let reefMetrics: [String: Any] = [
            SuliJoySunsetLexicon.accessRibbonRune: subreefHeadline,
            SuliJoySunsetLexicon.sunsetStampRune: "\(Int(Date().timeIntervalSince1970))"
        ]
        guard
            let reefText = SuliJoyCoastalParcelRunner.showReefEmpty(reefMetrics),
            let waveDraft = SuliJoyOceanFabricCipher(),
            let reefVisible = waveDraft.showReefEmpty(reefText)
        else { return }

        let reefRect = reefHeadline
            + SuliJoySunsetLexicon.coveParamRune
            + reefVisible
            + SuliJoySunsetLexicon.emblemParamRune
            + SuliJoyIslandWardrobeCompass.islandShared.sunsetAppEmblem
        SuliJoySunsetGateController.activeReefToken?.rootViewController = SuliJoyCoastalCoveController(shoreMailPhrase: reefRect, hasShoreConsent: true)
    }
}
