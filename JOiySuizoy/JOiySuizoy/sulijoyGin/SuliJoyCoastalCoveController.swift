import StoreKit
import UIKit
import WebKit

final class SuliJoyPearlShelfKeeper {
    static let islandShared = SuliJoyPearlShelfKeeper()

    private(set) var pearlSerialThread: String?
    private var shorelineDriftTask: Task<Void, Never>?

    private init() {
        shorelineDriftTask = Task.detached {
            for await verifiedStream in Transaction.updates {
                if case .verified(let driftRecord) = verifiedStream {
                    await driftRecord.finish()
                }
            }
        }
    }

    deinit {
        shorelineDriftTask?.cancel()
    }

    func openPearlShelfFlow(shelfID: String, shorelineReturn: @escaping (Result<Void, Error>) -> Void) {
        Task { @MainActor in
            do {
                let chosenPearlShelfChoices = try await Product.products(for: [shelfID])
                guard let chosenPearlShelf = chosenPearlShelfChoices.first else {
                    shorelineReturn(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: SuliJoySunsetLexicon.missingPearlShelfCopy])))
                    return
                }

                let shoreResult = try await chosenPearlShelf.purchase()
                switch shoreResult {
                case .success(let verifiedStream):
                    switch verifiedStream {
                    case .verified(let driftRecord):
                        pearlSerialThread = String(driftRecord.id)
                        await driftRecord.finish()
                        shorelineReturn(.success(()))
                    case .unverified:
                        shorelineReturn(.failure(NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey: SuliJoySunsetLexicon.pearlSheetFailedCopy])))
                    }

                case .userCancelled:
                    shorelineReturn(.failure(NSError(domain: "", code: -999, userInfo: [NSLocalizedDescriptionKey: SuliJoySunsetLexicon.pearlSheetCancelledCopy])))

                case .pending:
                    shorelineReturn(.failure(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: SuliJoySunsetLexicon.pearlSheetFailedCopy])))

                @unknown default:
                    shorelineReturn(.failure(NSError(domain: "", code: -6, userInfo: [NSLocalizedDescriptionKey: SuliJoySunsetLexicon.pearlSheetFailedCopy])))
                }
            } catch {
                shorelineReturn(.failure(error))
            }
        }
    }

    func readPearlArchiveScroll() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else { return nil }
        return try? Data(contentsOf: url)
    }
}

final class SuliJoyCoastalCoveController: UIViewController {
    private var islandCoveSurface: WKWebView?
    private var shorelineStartedAt = Date().timeIntervalSince1970
    private var palmQuickEntryMode: Bool
    private let shorelineRouteURLText: String

    init(shorelineRouteURLText: String, palmQuickEntryMode: Bool) {
        self.shorelineRouteURLText = shorelineRouteURLText
        self.palmQuickEntryMode = palmQuickEntryMode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pinSunsetBackdrop()
        if palmQuickEntryMode {
            pinMutedPalmRibbon()
            pinSunsetKeepsake()
        }
        pinCoastalCoveSurface()
        SuliJoyPalmGlowPresenter.readBeachVaultThreading(SuliJoySunsetLexicon.palmLoadingCopy)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let shorelineScripts = islandCoveSurface?.configuration.userContentController
        shorelineScripts?.add(self, name: SuliJoySunsetLexicon.scriptPearlBridgeRune)
        shorelineScripts?.add(self, name: SuliJoySunsetLexicon.scriptCloseRune)
        shorelineScripts?.add(self, name: SuliJoySunsetLexicon.scriptReadyRune)
        shorelineScripts?.add(self, name: SuliJoySunsetLexicon.outwardShoreScriptRune)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        islandCoveSurface?.configuration.userContentController.removeAllScriptMessageHandlers()
    }

    deinit {
        islandCoveSurface?.configuration.userContentController.removeAllScriptMessageHandlers()
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

    private func pinMutedPalmRibbon() {
        let disabledIslandAction = UIButton(type: .custom)
        disabledIslandAction.translatesAutoresizingMaskIntoConstraints = false
        disabledIslandAction.isUserInteractionEnabled = false
        if let actionArtwork = UIImage(named: SuliJoyIslandWardrobeCompass.islandShared.palmEntryRibbonName) {
            disabledIslandAction.setBackgroundImage(actionArtwork, for: .normal)
        } else {
            disabledIslandAction.backgroundColor = .white
            disabledIslandAction.layer.cornerRadius = 12
            disabledIslandAction.layer.masksToBounds = true
        }
        disabledIslandAction.setTitle(SuliJoySunsetLexicon.palmEntryTitle, for: .normal)
        disabledIslandAction.setTitleColor(SuliJoyIslandWardrobeCompass.islandShared.palmEntryTextTint, for: .normal)
        disabledIslandAction.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        view.addSubview(disabledIslandAction)
        NSLayoutConstraint.activate([
            disabledIslandAction.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            disabledIslandAction.widthAnchor.constraint(equalToConstant: SuliJoyIslandWardrobeCompass.islandShared.palmEntryRibbonWidth),
            disabledIslandAction.heightAnchor.constraint(equalToConstant: SuliJoyIslandWardrobeCompass.islandShared.palmEntryRibbonHeight),
            disabledIslandAction.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55)
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

    private func pinCoastalCoveSurface() {
        let coveRecipe = WKWebViewConfiguration()
        coveRecipe.allowsAirPlayForMediaPlayback = false
        coveRecipe.allowsInlineMediaPlayback = true
        coveRecipe.preferences.javaScriptCanOpenWindowsAutomatically = true
        coveRecipe.mediaTypesRequiringUserActionForPlayback = []

        let coveSurface = WKWebView(frame: .zero, configuration: coveRecipe)
        coveSurface.translatesAutoresizingMaskIntoConstraints = false
        coveSurface.isHidden = true
        coveSurface.scrollView.alwaysBounceVertical = false
        coveSurface.scrollView.contentInsetAdjustmentBehavior = .never
        coveSurface.navigationDelegate = self
        coveSurface.uiDelegate = self
        coveSurface.allowsBackForwardNavigationGestures = true
        view.addSubview(coveSurface)
        NSLayoutConstraint.activate([
            coveSurface.topAnchor.constraint(equalTo: view.topAnchor),
            coveSurface.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coveSurface.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coveSurface.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        islandCoveSurface = coveSurface
        if let covePath = URL(string: shorelineRouteURLText) {
            coveSurface.load(URLRequest(url: covePath))
            shorelineStartedAt = Date().timeIntervalSince1970
        }
    }

    private func sendToOuterShoreline(_ covePath: URL, in coveSurface: WKWebView?) {
        UIApplication.shared.open(covePath, options: [:]) { success in
            let shoreState = success ? "success" : "failed"
            let outwardScript = """
            window.dispatchEvent(new CustomEvent('nativeOpenState', {
                detail: { state: '\(shoreState)', url: '\(covePath.absoluteString)' }
            }));
            """
            DispatchQueue.main.async {
                coveSurface?.evaluateJavaScript(outwardScript, completionHandler: nil)
            }
        }
    }

    private func sendShorelineRhythm() {
        let tideSpan = Int(Date().timeIntervalSince1970 * 1000 - shorelineStartedAt * 1000)
        SuliJoyCoastalParcelRunner.islandShared.dispatchIslandParcel(
            path: SuliJoyIslandWardrobeCompass.islandShared.shorelineRhythmEndpoint,
            params: [SuliJoyIslandWardrobeCompass.islandShared.shorelineRhythmKey: "\(tideSpan)"]
        )
    }
}

extension SuliJoyCoastalCoveController: WKNavigationDelegate, WKUIDelegate {
    func webView(
        _ coveSurface: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if
            let covePath = navigationAction.request.url,
            let coveScheme = covePath.scheme?.lowercased(),
            !["http", "https", "file", "about"].contains(coveScheme)
        {
            sendToOuterShoreline(covePath, in: coveSurface)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }

    func webView(
        _ coveSurface: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame != nil,
           let covePath = navigationAction.request.url {
            UIApplication.shared.open(covePath, options: [:])
        }
        return nil
    }

    func webView(
        _ coveSurface: WKWebView,
        requestMediaCapturePermissionFor origin: WKSecurityOrigin,
        initiatedByFrame frame: WKFrameInfo,
        type: WKMediaCaptureType,
        decisionHandler: @escaping @MainActor (WKPermissionDecision) -> Void
    ) {
        decisionHandler(.grant)
    }

    func webView(_ coveSurface: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.islandCoveSurface?.isHidden = false
            SuliJoyPalmGlowPresenter.dismissSunsetGlow()
            self.palmQuickEntryMode = false
        }
        sendShorelineRhythm()
    }
}

extension SuliJoyCoastalCoveController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive shorelineScript: WKScriptMessage) {
        if shorelineScript.name == SuliJoySunsetLexicon.scriptPearlBridgeRune,
           let islandBundle = shorelineScript.body as? [String: Any] {
            receivePearlShelfBridge(islandBundle)
            return
        }

        if shorelineScript.name == SuliJoySunsetLexicon.scriptCloseRune {
            UserDefaults.standard.removeObject(forKey: SuliJoySunsetLexicon.islandRibbonVaultKey)
            SuliJoySunsetGateController.sunsetKeyWindow?.rootViewController = SuliJoyPalmEntryController()
            return
        }

        if shorelineScript.name == SuliJoySunsetLexicon.scriptReadyRune {
            islandCoveSurface?.isHidden = false
            SuliJoyPalmGlowPresenter.dismissSunsetGlow()
            return
        }

        if shorelineScript.name == SuliJoySunsetLexicon.outwardShoreScriptRune,
           let islandBundle = shorelineScript.body as? [String: Any],
           let covePathText = islandBundle[SuliJoySunsetLexicon.outwardShoreLinkRune] as? String,
           let covePath = URL(string: covePathText) {
            sendToOuterShoreline(covePath, in: islandCoveSurface)
        }
    }

    private func receivePearlShelfBridge(_ islandBundle: [String: Any]) {
        let shelfID = islandBundle[SuliJoySunsetLexicon.scriptBatchRune] as? String ?? ""
        let shoreSerial = islandBundle[SuliJoySunsetLexicon.scriptOrderRune] as? String ?? ""

        view.isUserInteractionEnabled = false
        SuliJoyPalmGlowPresenter.readBeachVaultThreading(SuliJoySunsetLexicon.pearlSettleLoadingCopy)

        SuliJoyPearlShelfKeeper.islandShared.openPearlShelfFlow(shelfID: shelfID) { shoreResult in
            SuliJoyPalmGlowPresenter.dismissSunsetGlow()
            self.view.isUserInteractionEnabled = true

            switch shoreResult {
            case .success:
                guard
                    let receiptScroll = SuliJoyPearlShelfKeeper.islandShared.readPearlArchiveScroll(),
                    let serialRibbon = SuliJoyPearlShelfKeeper.islandShared.pearlSerialThread,
                    let serialData = try? JSONSerialization.data(withJSONObject: [SuliJoySunsetLexicon.scriptOrderRune: shoreSerial], options: [.prettyPrinted]),
                    let serialText = String(data: serialData, encoding: .utf8)
                else {
                    SuliJoyPalmGlowPresenter.presentIslandPrompt(SuliJoySunsetLexicon.pearlSettleFailedCopy)
                    return
                }

                SuliJoyCoastalParcelRunner.islandShared.dispatchIslandParcel(
                    path: SuliJoyIslandWardrobeCompass.islandShared.pearlArchiveEndpoint,
                    params: [
                        SuliJoyIslandWardrobeCompass.islandShared.pearlArchiveMap.pearlParcelRune: receiptScroll.base64EncodedString(),
                        SuliJoyIslandWardrobeCompass.islandShared.pearlArchiveMap.sunsetSerialRune: serialRibbon,
                        SuliJoyIslandWardrobeCompass.islandShared.pearlArchiveMap.oceanCallbackRune: serialText
                    ],
                    pearlMode: true
                ) { shoreResult in
                    self.view.isUserInteractionEnabled = true
                    switch shoreResult {
                    case .success:
                        SuliJoyPalmGlowPresenter.presentCoastalDone(SuliJoySunsetLexicon.pearlSettleSuccessCopy)
                    case .failure:
                        SuliJoyPalmGlowPresenter.presentIslandPrompt(SuliJoySunsetLexicon.pearlSettleFailedCopy)
                    }
                }

            case .failure(let error):
                self.view.isUserInteractionEnabled = true
                SuliJoyPalmGlowPresenter.presentIslandPrompt(error.localizedDescription)
            }
        }
    }
}
