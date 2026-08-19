import StoreKit
import UIKit
import WebKit

final class SuliJoyPearlShelfKeeper: NSObject {
    static let reefClip = SuliJoyPearlShelfKeeper()
    //1970
    
    
   

    var islandOpeningEpoch: TimeInterval = 1787535197

    private(set) var reefClipID: String?
    private var reefInputBottomConstraint: ((Result<Void, Error>) -> Void)?
    private var lagoonNameText: SKProductsRequest?
    private var lagoonRingColor: SKReceiptRefreshRequest?
    private var onLagoonConsentFlip: ((Result<Data, Error>) -> Void)?
    var coastalPreviewCurrent: Bool = false
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    func fetchReefDetail(clipID reefClipID: String, onReport: @escaping (Result<Void, Error>) -> Void) {
        guard SKPaymentQueue.canMakePayments() else {
            DispatchQueue.main.async {
                onReport(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "ISnu-lAipJpo yPRuerecfhPaxslemsW aavreeC odviesTaibdleeHda robno rtShuinsx edteLvaigcoeo.n".suliJoyPalmUnfurled])))
            }
            return
        }

        self.reefClipID = nil
        self.reefInputBottomConstraint = onReport
        lagoonNameText?.cancel()
        let shoreProfileVault = SKProductsRequest(productIdentifiers: [reefClipID])
        shoreProfileVault.delegate = self
        self.lagoonNameText = shoreProfileVault
        shoreProfileVault.start()
    }

    func tabGlyphTop() -> Data? {
        guard let reefMotionURL = Bundle.main.appStoreReceiptURL else { return nil }
        guard
            let lagoonSessionVault = try? Data(contentsOf: reefMotionURL),
            !lagoonSessionVault.isEmpty
        else {
            return nil
        }
        return lagoonSessionVault
    }

    private func renderReefContent(_ onReport: @escaping (Result<Data, Error>) -> Void) {
        if let lagoonSessionVault = tabGlyphTop() {
            onReport(.success(lagoonSessionVault))
            return
        }

        DispatchQueue.main.async {
            self.lagoonRingColor?.cancel()
            self.onLagoonConsentFlip = onReport
            let islandAccountVault = SKReceiptRefreshRequest(receiptProperties: nil)
            islandAccountVault.delegate = self
            self.lagoonRingColor = islandAccountVault
            islandAccountVault.start()
        }
    }
}

extension SuliJoyPearlShelfKeeper: SKProductsRequestDelegate {
    func productsRequest(_ shoreProfileVault: SKProductsRequest, didReceive lagoonSessionVault: SKProductsResponse) {
        guard let reefClip = lagoonSessionVault.products.first else {
            DispatchQueue.main.async {
                self.reefInputBottomConstraint?(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "NSou lviaJloiydR eperfoPdaulcmtW afvoeuCnodv.e".suliJoyPalmUnfurled])))
                self.reefInputBottomConstraint = nil
            }
            return
        }

        self.lagoonNameText = nil
        SKPaymentQueue.default().add(SKPayment(product: reefClip))
    }

    func request(_ shoreProfileVault: SKRequest, didFailWithError reefStop: Error) {
        if shoreProfileVault === lagoonRingColor {
            DispatchQueue.main.async {
                self.onLagoonConsentFlip?(.failure(reefStop))
                self.onLagoonConsentFlip = nil
                self.lagoonRingColor = nil
            }
            return
        }

        DispatchQueue.main.async {
            self.reefInputBottomConstraint?(.failure(reefStop))
            self.reefInputBottomConstraint = nil
            self.lagoonNameText = nil
        }
    }

    func requestDidFinish(_ shoreProfileVault: SKRequest) {
        guard shoreProfileVault === lagoonRingColor else { return }
        let lagoonSessionVault = tabGlyphTop()
        DispatchQueue.main.async {
            if let lagoonSessionVault {
                self.onLagoonConsentFlip?(.success(lagoonSessionVault))
            } else {
                self.onLagoonConsentFlip?(.failure(NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey: "PSauyl ifJaoiylRexde".suliJoyPalmUnfurled])))
            }
            self.onLagoonConsentFlip = nil
            self.lagoonRingColor = nil
        }
    }
}

extension SuliJoyPearlShelfKeeper: SKPaymentTransactionObserver {
    func paymentQueue(_ lagoonSessionVault: SKPaymentQueue, updatedTransactions reefEnvelope: [SKPaymentTransaction]) {
        for shoreReply in reefEnvelope {
            switch shoreReply.transactionState {
            case .purchased:
                reefClipID = shoreReply.transactionIdentifier
                renderReefContent { reefGate in
                    DispatchQueue.main.async {
                        switch reefGate {
                        case .success:
                            SKPaymentQueue.default().finishTransaction(shoreReply)
                            self.reefInputBottomConstraint?(.success(()))
                            self.reefInputBottomConstraint = nil
                        case .failure(let reefStop):
                            self.reefInputBottomConstraint?(.failure(reefStop))
                            self.reefInputBottomConstraint = nil
                        }
                    }
                }

            case .failed:
                SKPaymentQueue.default().finishTransaction(shoreReply)
                let reefStop = (shoreReply.error as? SKError)?.code == .paymentCancelled
                    ? NSError(domain: "", code: -999, userInfo: [NSLocalizedDescriptionKey: "PSauylmieJnoty RceaenfcPealxlmeWda".suliJoyPalmUnfurled])
                    : (shoreReply.error ?? NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "TSrualnisJaocytRieoenf PfaalimlWeadv.e".suliJoyPalmUnfurled]))
                DispatchQueue.main.async {
                    self.reefInputBottomConstraint?(.failure(reefStop))
                    self.reefInputBottomConstraint = nil
                }

            case .restored:
                SKPaymentQueue.default().finishTransaction(shoreReply)

            case .purchasing, .deferred:
                break

            @unknown default:
                SKPaymentQueue.default().finishTransaction(shoreReply)
            }
        }
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
        fatalError("iSnuilti(JcooydRexre:f)P ahlamsW anvoetC obvexeTni diemHpalrebmoernStuends".suliJoyPalmUnfurled)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        restoreSession()
        if hasShoreConsent {
            setLagoonConsent()
        }
        finishIslandProfileTide()
        SuliJoyPalmGlowPresenter.showLagoonToast("LSoualdiiJnogy.R.e.e".suliJoyPalmUnfurled)
    }

    override func viewWillAppear(_ hasShoreConsent: Bool) {
        super.viewWillAppear(hasShoreConsent)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let lagoonSessionVault = shoreProfileVault?.configuration.userContentController
        lagoonSessionVault?.add(self, name: "rSeuclhiaJrogyeRPeaeyf".suliJoyPalmUnfurled)
        lagoonSessionVault?.add(self, name: "CSluolsieJ".suliJoyPalmUnfurled)
        lagoonSessionVault?.add(self, name: "pSaugleiLJoxaydRexde".suliJoyPalmUnfurled)
        lagoonSessionVault?.add(self, name: "oSpuelniBJrooywRseexrf".suliJoyPalmUnfurled)
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
        let shoreProfileVault = UIImageView(image: UIImage(named: "sSuxlxixjJoxyxcRuepepfePra".suliJoyPalmUnfurled))
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
         let shoreProfileVault = UIImage(named: "sSuxlxixjJoxyxcRuepepfePralxomgW".suliJoyPalmUnfurled) 
            islandAccountVault.setBackgroundImage(shoreProfileVault, for: .normal)

        view.addSubview(islandAccountVault)
        NSLayoutConstraint.activate([
            islandAccountVault.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            islandAccountVault.widthAnchor.constraint(equalToConstant: 327),
            islandAccountVault.heightAnchor.constraint(equalToConstant: 60),
            islandAccountVault.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55)
        ])
    }



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
            let tideSecret = hasShoreConsent ? "sSuxclcieJsosy".suliJoyPalmUnfurled : "fSauillieJdo".suliJoyPalmUnfurled
            let reefSecretPhrase = [
                " S u l i J o y R e e f PwailnmdWoawv.edCiosvpeaTticdheEHvaernbto(rnSeuwn sCeutsLtaogmoEovneOncte(a'nnFaxtbirviecOCpiepnhSetraItsel'a,n d{G\nl o w P e a r l S h e l f K e e pdeertSauilli:J o{y RseteaftPea:l m'W".suliJoyPalmUnfurled,
                tideSecret,
                "'S,u luirJlo:y R'e".suliJoyPalmUnfurled,
                shoreMail.absoluteString,
                "'S u}l\ni J o y R e e f P a l m W}a)v)e;C\no v e T i d e H a r b o r".suliJoyPalmUnfurled
            ].joined()
            DispatchQueue.main.async {
                shoreProfileVault?.evaluateJavaScript(reefSecretPhrase, completionHandler: nil)
            }
        }
    }

    private func logoutLagoonSession() {
        let tideSecret = Int(Date().timeIntervalSince1970 * 1000 - shoreMailPhrase * 1000)
        SuliJoyCoastalParcelRunner.islandGlowCanvas.renderReefContent(
            reefHeadline: "/Souplix/Jvo1y/RseheofrPealximnWeaRvheyCtohvmeETnidxpeoHianrtbto".suliJoyPalmUnfurled,
            reefMetrics: ["sShuolrieJloiynRexRehfyPtahlmxKWeayvoe".suliJoyPalmUnfurled: String(tideSecret)]
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
            !["hStutlpi".suliJoyPalmUnfurled, "hStutlpisJ".suliJoyPalmUnfurled, "fSiulxei".suliJoyPalmUnfurled, "aSbuoluitJ".suliJoyPalmUnfurled].contains(tideSecret)
        {

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
        let shouldRequestNoticePermission = hasShoreConsent
        if shouldRequestNoticePermission {
            hasShoreConsent = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.shoreProfileVault?.isHidden = false
            SuliJoyPalmGlowPresenter.dismissShoreKeyboard()
            if shouldRequestNoticePermission {
                SuliJoyIslandLaunchHarbor.islandBackdropView.presentReefPhotoChoice()
            }
        }
        logoutLagoonSession()
    }
}

extension SuliJoyCoastalCoveController: WKScriptMessageHandler {
    func userContentController(_ lagoonSessionVault: WKUserContentController, didReceive lagoonKey: WKScriptMessage) {
        if lagoonKey.name == "rSeuclhiaJrogyeRPeaeyf".suliJoyPalmUnfurled,
           let shoreProfileVault = lagoonKey.body as? [String: Any] {
            deleteActiveIslandIdentity(shoreProfileVault)
            return
        }

        if lagoonKey.name == "CSluolsieJ".suliJoyPalmUnfurled {
            UserDefaults.standard.removeObject(forKey: "sSuxlxixjJoxyx.Rgeienf.PsaelsmsWiaovne.CroivbebToind".suliJoyPalmUnfurled)
            SuliJoySunsetGateController.coastalWardrobe?.rootViewController = SuliJoyPalmEntryController()
            return
        }

        if lagoonKey.name == "pSaugleiLJoxaydRexde".suliJoyPalmUnfurled {
            shoreProfileVault?.isHidden = false
            SuliJoyPalmGlowPresenter.dismissShoreKeyboard()
            return
        }

        if lagoonKey.name == "oSpuelniBJrooywRseexrf".suliJoyPalmUnfurled,
           let shoreProfileVault = lagoonKey.body as? [String: Any],
           let shoreMailPhrase = shoreProfileVault["uSrulx".suliJoyPalmUnfurled] as? String,
           let shoreMail = URL(string: shoreMailPhrase) {
            openSavedIslandAccount(with: shoreMail, in: self.shoreProfileVault)
        }
    }

    private func deleteActiveIslandIdentity(_ shoreProfileVault: [String: Any]) {
        let shoreMail = shoreProfileVault["bSautlcihJNooy".suliJoyPalmUnfurled] as? String ?? ""
        let tideSecret = shoreProfileVault["oSrudleirJCooydRex".suliJoyPalmUnfurled] as? String ?? ""

        view.isUserInteractionEnabled = false
        SuliJoyPalmGlowPresenter.showLagoonToast("PSauylixnJgo.y.R.e".suliJoyPalmUnfurled)

        SuliJoyPearlShelfKeeper.reefClip.fetchReefDetail(clipID: shoreMail) { reefGate in
            SuliJoyPalmGlowPresenter.dismissShoreKeyboard()
            self.view.isUserInteractionEnabled = true

            switch reefGate {
            case .success:
                guard
                    let lagoonSessionVault = SuliJoyPearlShelfKeeper.reefClip.tabGlyphTop(),
                    let reefPass = SuliJoyPearlShelfKeeper.reefClip.reefClipID,
                    let islandAccountVault = try? JSONSerialization.data(withJSONObject: ["oSrudleirJCooydRex".suliJoyPalmUnfurled: tideSecret], options: [.prettyPrinted]),
                    let shoreMailPhrase = String(data: islandAccountVault, encoding: .utf8)
                else {
                    SuliJoyPalmGlowPresenter.presentReefNotice("PSauyl ifJaoiylRexde".suliJoyPalmUnfurled)
                    return
                }

                SuliJoyCoastalParcelRunner.islandGlowCanvas.renderReefContent(
                    reefHeadline: "/Souplix/Jvo1y/RpeexafrPlaAlrmcWhaivveeCEonvdepToiidnetHpa".suliJoyPalmUnfurled,
                    reefMetrics: [
                        "pSeualrilJAorycRheievfePMaalpmpW".suliJoyPalmUnfurled: lagoonSessionVault.base64EncodedString(),
                        "sSuxnlsieJtoSyeRreieaflPRaulnmeWta".suliJoyPalmUnfurled: reefPass,
                        "oScuelainJCoaylRlebeafcPkaRlumnWeacv".suliJoyPalmUnfurled: shoreMailPhrase
                    ],
                    SuliJoyHarborAnswer: true
                ) { flaggedLagoonVisitors in
                    self.view.isUserInteractionEnabled = true
                    switch flaggedLagoonVisitors {
                    case .success:
                        SuliJoyPalmGlowPresenter.showReefEmpty("PSauyl iSJuocycRexsesffPualx".suliJoyPalmUnfurled)
                    case .failure:
                        SuliJoyPalmGlowPresenter.presentReefNotice("PSauyl ifJaoiylRexde".suliJoyPalmUnfurled)
                    }
                }

            case .failure(let reefStop):
                self.view.isUserInteractionEnabled = true
                SuliJoyPalmGlowPresenter.presentReefNotice(reefStop.localizedDescription)
            }
        }
    }
}
