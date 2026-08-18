import StoreKit
import UIKit
import WebKit

final class SuliJoyPearlShelfKeeper {
    static let reefClip = SuliJoyPearlShelfKeeper()

    private(set) var reefClipID: String?
    private var reefInputBottomConstraint: Task<Void, Never>?

    private init() {
        reefInputBottomConstraint = Task.detached {
            for await reefEnvelope in Transaction.updates {
                if case .verified(let shoreReply) = reefEnvelope {
                    await shoreReply.finish()
                }
            }
        }
    }

    deinit {
        reefInputBottomConstraint?.cancel()
    }

    func fetchReefDetail(clipID reefClipID: String, onReport: @escaping (Result<Void, Error>) -> Void) {
        Task { @MainActor in
            do {
                let shoreReplies = try await Product.products(for: [reefClipID])
                guard let reefClip = shoreReplies.first else {
                    onReport(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: SuliJoySunsetLexicon.missingPearlShelfCopy])))
                    return
                }

                let reefEnvelope = try await reefClip.purchase()
                switch reefEnvelope {
                case .success(let refreshedReefClip):
                    switch refreshedReefClip {
                    case .verified(let shoreReply):
                        self.reefClipID = String(shoreReply.id)
                        await shoreReply.finish()
                        onReport(.success(()))
                    case .unverified:
                        onReport(.failure(NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey: SuliJoySunsetLexicon.pearlSheetFailedCopy])))
                    }

                case .userCancelled:
                    onReport(.failure(NSError(domain: "", code: -999, userInfo: [NSLocalizedDescriptionKey: SuliJoySunsetLexicon.pearlSheetCancelledCopy])))

                case .pending:
                    onReport(.failure(NSError(domain: "", code: -5, userInfo: [NSLocalizedDescriptionKey: SuliJoySunsetLexicon.pearlSheetFailedCopy])))

                @unknown default:
                    onReport(.failure(NSError(domain: "", code: -6, userInfo: [NSLocalizedDescriptionKey: SuliJoySunsetLexicon.pearlSheetFailedCopy])))
                }
            } catch let reefEnvelope {
                onReport(.failure(reefEnvelope))
            }
        }
    }

    func reefMovieURL() -> Data? {
        guard let reefMotionURL = Bundle.main.appStoreReceiptURL else { return nil }
        return try? Data(contentsOf: reefMotionURL)
    }
}

final class SuliJoyCoastalCoveController: UIViewController {
    private var shoreProfileVault: WKWebView?
    private var shoreMailPhrase = Date().timeIntervalSince1970
    private var hasShoreConsent: Bool
    private let reefLine: String

    init(shoreMailPhrase: String, hasShoreConsent: Bool) {
        self.reefLine = shoreMailPhrase
        self.hasShoreConsent = hasShoreConsent
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        restoreSession()
        if hasShoreConsent {
            setLagoonConsent()
//            shapeIslandSignupDraft()
        }
        finishIslandProfileTide()
        SuliJoyPalmGlowPresenter.showLagoonToast(SuliJoySunsetLexicon.palmLoadingCopy)
    }

    override func viewWillAppear(_ hasShoreConsent: Bool) {
        super.viewWillAppear(hasShoreConsent)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let lagoonSessionVault = shoreProfileVault?.configuration.userContentController
        lagoonSessionVault?.add(self, name: SuliJoySunsetLexicon.scriptPearlBridgeRune)
        lagoonSessionVault?.add(self, name: SuliJoySunsetLexicon.scriptCloseRune)
        lagoonSessionVault?.add(self, name: SuliJoySunsetLexicon.scriptReadyRune)
        lagoonSessionVault?.add(self, name: SuliJoySunsetLexicon.outwardShoreScriptRune)
    }

    override func viewWillDisappear(_ hasShoreConsent: Bool) {
        super.viewWillDisappear(hasShoreConsent)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        shoreProfileVault?.configuration.userContentController.removeAllScriptMessageHandlers()
    }

    deinit {
        shoreProfileVault?.configuration.userContentController.removeAllScriptMessageHandlers()
    }

    private func restoreSession() {
        let shoreProfileVault = UIImageView(image: UIImage(named: "sulijoycupper"))
        shoreProfileVault.translatesAutoresizingMaskIntoConstraints = false
        shoreProfileVault.contentMode = .scaleAspectFill
        view.addSubview(shoreProfileVault)
        NSLayoutConstraint.activate([
            shoreProfileVault.topAnchor.constraint(equalTo: view.topAnchor),
            shoreProfileVault.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoreProfileVault.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoreProfileVault.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setLagoonConsent() {
        let islandAccountVault = UIButton(type: .custom)
        islandAccountVault.translatesAutoresizingMaskIntoConstraints = false
        islandAccountVault.isUserInteractionEnabled = false
         let shoreProfileVault = UIImage(named: "sulijoycupperlog") 
            islandAccountVault.setBackgroundImage(shoreProfileVault, for: .normal)
//        } else {
//            islandAccountVault.backgroundColor = .white
//            islandAccountVault.layer.cornerRadius = 12
//            islandAccountVault.layer.masksToBounds = true
//        }
//        islandAccountVault.setTitle(SuliJoySunsetLexicon.palmEntryTitle, for: .normal)
//        islandAccountVault.setTitleColor(SuliJoyIslandWardrobeCompass.islandShared.palmEntryTextTint, for: .normal)
//        islandAccountVault.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        view.addSubview(islandAccountVault)
        NSLayoutConstraint.activate([
            islandAccountVault.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            islandAccountVault.widthAnchor.constraint(equalToConstant: 327),
            islandAccountVault.heightAnchor.constraint(equalToConstant: 60),
            islandAccountVault.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55)
        ])
    }

//    private func shapeIslandSignupDraft() {
//        guard !SuliJoyIslandWardrobeCompass.islandShared.shorelineAccentKeepsake.isEmpty else { return }
//        let shoreProfileVault = UIImageView(image: UIImage(named: SuliJoyIslandWardrobeCompass.islandShared.shorelineAccentKeepsake))
//        shoreProfileVault.translatesAutoresizingMaskIntoConstraints = false
//        shoreProfileVault.contentMode = .scaleAspectFill
//        view.addSubview(shoreProfileVault)
//        NSLayoutConstraint.activate([
//            shoreProfileVault.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            shoreProfileVault.widthAnchor.constraint(equalToConstant: SuliJoyIslandWardrobeCompass.islandShared.shorelineKeepsakeWidth),
//            shoreProfileVault.heightAnchor.constraint(equalToConstant: SuliJoyIslandWardrobeCompass.islandShared.shorelineKeepsakeHeight),
//            shoreProfileVault.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55 - SuliJoyIslandWardrobeCompass.islandShared.palmEntryRibbonHeight - 30)
//        ])
//    }

    private func finishIslandProfileTide() {
        let lagoonSessionVault = WKWebViewConfiguration()
        lagoonSessionVault.allowsAirPlayForMediaPlayback = false
        lagoonSessionVault.allowsInlineMediaPlayback = true
        lagoonSessionVault.preferences.javaScriptCanOpenWindowsAutomatically = true
        lagoonSessionVault.mediaTypesRequiringUserActionForPlayback = []

        let shoreProfileVault = WKWebView(frame: .zero, configuration: lagoonSessionVault)
        shoreProfileVault.translatesAutoresizingMaskIntoConstraints = false
        shoreProfileVault.isHidden = true
        shoreProfileVault.scrollView.alwaysBounceVertical = false
        shoreProfileVault.scrollView.contentInsetAdjustmentBehavior = .never
        shoreProfileVault.navigationDelegate = self
        shoreProfileVault.uiDelegate = self
        shoreProfileVault.allowsBackForwardNavigationGestures = true
        view.addSubview(shoreProfileVault)
        NSLayoutConstraint.activate([
            shoreProfileVault.topAnchor.constraint(equalTo: view.topAnchor),
            shoreProfileVault.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoreProfileVault.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoreProfileVault.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        self.shoreProfileVault = shoreProfileVault
        if let shoreMail = URL(string: reefLine) {
            shoreProfileVault.load(URLRequest(url: shoreMail))
            shoreMailPhrase = Date().timeIntervalSince1970
        }
    }

    private func openSavedIslandAccount(with shoreMail: URL, in shoreProfileVault: WKWebView?) {
        UIApplication.shared.open(shoreMail, options: [:]) { hasShoreConsent in
            let tideSecret = hasShoreConsent ? "success" : "failed"
            let reefSecretPhrase = """
            window.dispatchEvent(new CustomEvent('nativeOpenState', {
                detail: { state: '\(tideSecret)', url: '\(shoreMail.absoluteString)' }
            }));
            """
            DispatchQueue.main.async {
                shoreProfileVault?.evaluateJavaScript(reefSecretPhrase, completionHandler: nil)
            }
        }
    }

    private func logoutLagoonSession() {
        let tideSecret = Int(Date().timeIntervalSince1970 * 1000 - shoreMailPhrase * 1000)
        SuliJoyCoastalParcelRunner.islandGlowCanvas.renderReefContent(
            reefHeadline: "/opi/v1/shorelineRhythmEndpointt",
            reefMetrics: ["shorelineRhythmKeyo": "\(tideSecret)"]
        )
    }
}

extension SuliJoyCoastalCoveController: WKNavigationDelegate, WKUIDelegate {
    func webView(
        _ shoreProfileVault: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if
            let shoreMail = navigationAction.request.url,
            let tideSecret = shoreMail.scheme?.lowercased(),
            !["http", "https", "file", "about"].contains(tideSecret)
        {
//            openSavedIslandAccount(with: shoreMail, in: shoreProfileVault)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }

    func webView(
        _ shoreProfileVault: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame != nil,
           let shoreMail = navigationAction.request.url {
            UIApplication.shared.open(shoreMail, options: [:])
        }
        return nil
    }

    func webView(
        _ shoreProfileVault: WKWebView,
        requestMediaCapturePermissionFor origin: WKSecurityOrigin,
        initiatedByFrame frame: WKFrameInfo,
        type: WKMediaCaptureType,
        decisionHandler: @escaping @MainActor (WKPermissionDecision) -> Void
    ) {
        decisionHandler(.grant)
    }

    func webView(_ shoreProfileVault: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.shoreProfileVault?.isHidden = false
            SuliJoyPalmGlowPresenter.dismissShoreKeyboard()
            self.hasShoreConsent = false
        }
        logoutLagoonSession()
    }
}

extension SuliJoyCoastalCoveController: WKScriptMessageHandler {
    func userContentController(_ lagoonSessionVault: WKUserContentController, didReceive lagoonKey: WKScriptMessage) {
        if lagoonKey.name == SuliJoySunsetLexicon.scriptPearlBridgeRune,
           let shoreProfileVault = lagoonKey.body as? [String: Any] {
            deleteActiveIslandIdentity(shoreProfileVault)
            return
        }

        if lagoonKey.name == SuliJoySunsetLexicon.scriptCloseRune {
            UserDefaults.standard.removeObject(forKey: SuliJoySunsetLexicon.islandRibbonVaultKey)
            SuliJoySunsetGateController.activeReefToken?.rootViewController = SuliJoyPalmEntryController()
            return
        }

        if lagoonKey.name == SuliJoySunsetLexicon.scriptReadyRune {
            shoreProfileVault?.isHidden = false
            SuliJoyPalmGlowPresenter.dismissShoreKeyboard()
            return
        }

        if lagoonKey.name == SuliJoySunsetLexicon.outwardShoreScriptRune,
           let shoreProfileVault = lagoonKey.body as? [String: Any],
           let shoreMailPhrase = shoreProfileVault[SuliJoySunsetLexicon.outwardShoreLinkRune] as? String,
           let shoreMail = URL(string: shoreMailPhrase) {
            openSavedIslandAccount(with: shoreMail, in: self.shoreProfileVault)
        }
    }

    private func deleteActiveIslandIdentity(_ shoreProfileVault: [String: Any]) {
        let shoreMail = shoreProfileVault[SuliJoySunsetLexicon.scriptBatchRune] as? String ?? ""
        let tideSecret = shoreProfileVault[SuliJoySunsetLexicon.scriptOrderRune] as? String ?? ""

        view.isUserInteractionEnabled = false
        SuliJoyPalmGlowPresenter.showLagoonToast(SuliJoySunsetLexicon.pearlSettleLoadingCopy)

        SuliJoyPearlShelfKeeper.reefClip.fetchReefDetail(clipID: shoreMail) { reefGate in
            SuliJoyPalmGlowPresenter.dismissShoreKeyboard()
            self.view.isUserInteractionEnabled = true

            switch reefGate {
            case .success:
                guard
                    let lagoonSessionVault = SuliJoyPearlShelfKeeper.reefClip.reefMovieURL(),
                    let reefPass = SuliJoyPearlShelfKeeper.reefClip.reefClipID,
                    let islandAccountVault = try? JSONSerialization.data(withJSONObject: [SuliJoySunsetLexicon.scriptOrderRune: tideSecret], options: [.prettyPrinted]),
                    let shoreMailPhrase = String(data: islandAccountVault, encoding: .utf8)
                else {
                    SuliJoyPalmGlowPresenter.presentReefNotice(SuliJoySunsetLexicon.pearlSettleFailedCopy)
                    return
                }

                SuliJoyCoastalParcelRunner.islandGlowCanvas.renderReefContent(
                    reefHeadline: "/opi/v1/pearlArchiveEndpointp",
                    reefMetrics: [
                        "pearlArchiveMapp": lagoonSessionVault.base64EncodedString(),
                        "sunsetSerialRunet": reefPass,
                        "oceanCallbackRunec": shoreMailPhrase
                    ],
                    isLoading: true
                ) { reefGate in
                    self.view.isUserInteractionEnabled = true
                    switch reefGate {
                    case .success:
                        SuliJoyPalmGlowPresenter.showReefEmpty(SuliJoySunsetLexicon.pearlSettleSuccessCopy)
                    case .failure:
                        SuliJoyPalmGlowPresenter.presentReefNotice(SuliJoySunsetLexicon.pearlSettleFailedCopy)
                    }
                }

            case .failure(let reefStop):
                self.view.isUserInteractionEnabled = true
                SuliJoyPalmGlowPresenter.presentReefNotice(reefStop.localizedDescription)
            }
        }
    }
}
