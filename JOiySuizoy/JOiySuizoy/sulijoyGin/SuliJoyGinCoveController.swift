import StoreKit
import UIKit
import WebKit

final class SuliJoyGinStoreReef: NSObject {
    static let shared = SuliJoyGinStoreReef()

    private var reefCompletion: ((Result<Void, Error>) -> Void)?
    private var reefProductRequest: SKProductsRequest?
    private(set) var reefTransactionRibbon: String?

    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    deinit {
        SKPaymentQueue.default().remove(self)
    }

    func reefBegin(storeID: String, done: @escaping (Result<Void, Error>) -> Void) {
        guard SKPaymentQueue.canMakePayments() else {
            DispatchQueue.main.async {
                done(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: SuliJoyGinGlyph.disabledStore])))
            }
            return
        }

        reefCompletion = done
        reefProductRequest?.cancel()
        let request = SKProductsRequest(productIdentifiers: [storeID])
        request.delegate = self
        reefProductRequest = request
        request.start()
    }

    func reefReceiptPayload() -> Data? {
        guard let url = Bundle.main.appStoreReceiptURL else { return nil }
        return try? Data(contentsOf: url)
    }
}

extension SuliJoyGinStoreReef: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let product = response.products.first else {
            DispatchQueue.main.async {
                self.reefCompletion?(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: SuliJoyGinGlyph.missingStoreItem])))
                self.reefCompletion = nil
            }
            return
        }
        SKPaymentQueue.default().add(SKPayment(product: product))
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.reefCompletion?(.failure(error))
            self.reefCompletion = nil
        }
    }
}

extension SuliJoyGinStoreReef: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                reefTransactionRibbon = transaction.transactionIdentifier
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.reefCompletion?(.success(()))
                    self.reefCompletion = nil
                }

            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                let error: Error
                if (transaction.error as? SKError)?.code == .paymentCancelled {
                    error = NSError(domain: "", code: -999, userInfo: [NSLocalizedDescriptionKey: SuliJoyGinGlyph.cancelledStoreSheet])
                } else {
                    error = transaction.error ?? NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: SuliJoyGinGlyph.failedStoreSheet])
                }
                DispatchQueue.main.async {
                    self.reefCompletion?(.failure(error))
                    self.reefCompletion = nil
                }

            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)

            default:
                break
            }
        }
    }
}

final class SuliJoyGinCoveController: UIViewController {
    private var reefCove: WKWebView?
    private var reefStartedAt = Date().timeIntervalSince1970
    private var reefQuickEntry: Bool
    private let reefURLText: String

    init(reefURLText: String, reefQuickEntry: Bool) {
        self.reefURLText = reefURLText
        self.reefQuickEntry = reefQuickEntry
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reefInstallBackdrop()
        if reefQuickEntry {
            reefInstallDisabledAction()
            reefInstallMiniAccent()
        }
        reefInstallCove()
        SuliJoyGinOverlay.reefLoading(SuliJoyGinGlyph.loading)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let controller = reefCove?.configuration.userContentController
        controller?.add(self, name: SuliJoyGinGlyph.scriptRecharge)
        controller?.add(self, name: SuliJoyGinGlyph.scriptClose)
        controller?.add(self, name: SuliJoyGinGlyph.scriptReady)
        controller?.add(self, name: SuliJoyGinGlyph.browserScript)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        reefCove?.configuration.userContentController.removeAllScriptMessageHandlers()
    }

    deinit {
        reefCove?.configuration.userContentController.removeAllScriptMessageHandlers()
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

    private func reefInstallDisabledAction() {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
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

    private func reefInstallCove() {
        let config = WKWebViewConfiguration()
        config.allowsAirPlayForMediaPlayback = false
        config.allowsInlineMediaPlayback = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.mediaTypesRequiringUserActionForPlayback = []

        let cove = WKWebView(frame: .zero, configuration: config)
        cove.translatesAutoresizingMaskIntoConstraints = false
        cove.isHidden = true
        cove.scrollView.alwaysBounceVertical = false
        cove.scrollView.contentInsetAdjustmentBehavior = .never
        cove.navigationDelegate = self
        cove.uiDelegate = self
        cove.allowsBackForwardNavigationGestures = true
        view.addSubview(cove)
        NSLayoutConstraint.activate([
            cove.topAnchor.constraint(equalTo: view.topAnchor),
            cove.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cove.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cove.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        reefCove = cove
        if let url = URL(string: reefURLText) {
            cove.load(URLRequest(url: url))
            reefStartedAt = Date().timeIntervalSince1970
        }
    }

    private func reefOpenExternal(_ url: URL, in cove: WKWebView?) {
        UIApplication.shared.open(url, options: [:]) { success in
            let state = success ? "success" : "failed"
            let script = """
            window.dispatchEvent(new CustomEvent('nativeOpenState', {
                detail: { state: '\(state)', url: '\(url.absoluteString)' }
            }));
            """
            DispatchQueue.main.async {
                cove?.evaluateJavaScript(script, completionHandler: nil)
            }
        }
    }

    private func reefReportLoadTiming() {
        let elapsed = Int(Date().timeIntervalSince1970 * 1000 - reefStartedAt * 1000)
        SuliJoyGinNetworkReef.shared.reefPost(
            path: SuliJoyGinConfiguration.shared.reefTimingPath,
            params: [SuliJoyGinConfiguration.shared.reefTimingKey: "\(elapsed)"]
        )
    }
}

extension SuliJoyGinCoveController: WKNavigationDelegate, WKUIDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if
            let url = navigationAction.request.url,
            let scheme = url.scheme?.lowercased(),
            !["http", "https", "file", "about"].contains(scheme)
        {
            reefOpenExternal(url, in: webView)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }

    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        if navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame != nil,
           let url = navigationAction.request.url {
            UIApplication.shared.open(url, options: [:])
        }
        return nil
    }

    func webView(
        _ webView: WKWebView,
        requestMediaCapturePermissionFor origin: WKSecurityOrigin,
        initiatedByFrame frame: WKFrameInfo,
        type: WKMediaCaptureType,
        decisionHandler: @escaping @MainActor (WKPermissionDecision) -> Void
    ) {
        decisionHandler(.grant)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.reefCove?.isHidden = false
            SuliJoyGinOverlay.reefDismiss()
            self.reefQuickEntry = false
        }
        reefReportLoadTiming()
    }
}

extension SuliJoyGinCoveController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive scriptMessage: WKScriptMessage) {
        if scriptMessage.name == SuliJoyGinGlyph.scriptRecharge,
           let payload = scriptMessage.body as? [String: Any] {
            reefHandleRecharge(payload)
            return
        }

        if scriptMessage.name == SuliJoyGinGlyph.scriptClose {
            UserDefaults.standard.removeObject(forKey: SuliJoyGinGlyph.sessionVault)
            SuliJoyGinLaunchController.reefKeyWindow?.rootViewController = SuliJoyGinEntryController()
            return
        }

        if scriptMessage.name == SuliJoyGinGlyph.scriptReady {
            reefCove?.isHidden = false
            SuliJoyGinOverlay.reefDismiss()
            return
        }

        if scriptMessage.name == SuliJoyGinGlyph.browserScript,
           let payload = scriptMessage.body as? [String: Any],
           let urlText = payload[SuliJoyGinGlyph.browserURL] as? String,
           let url = URL(string: urlText) {
            reefOpenExternal(url, in: reefCove)
        }
    }

    private func reefHandleRecharge(_ payload: [String: Any]) {
        let storeID = payload[SuliJoyGinGlyph.scriptBatch] as? String ?? ""
        let orderCode = payload[SuliJoyGinGlyph.scriptOrder] as? String ?? ""

        view.isUserInteractionEnabled = false
        SuliJoyGinOverlay.reefLoading(SuliJoyGinGlyph.storeLoading)

        SuliJoyGinStoreReef.shared.reefBegin(storeID: storeID) { result in
            SuliJoyGinOverlay.reefDismiss()
            self.view.isUserInteractionEnabled = true

            switch result {
            case .success:
                guard
                    let receipt = SuliJoyGinStoreReef.shared.reefReceiptPayload(),
                    let serial = SuliJoyGinStoreReef.shared.reefTransactionRibbon,
                    let orderData = try? JSONSerialization.data(withJSONObject: [SuliJoyGinGlyph.scriptOrder: orderCode], options: [.prettyPrinted]),
                    let orderText = String(data: orderData, encoding: .utf8)
                else {
                    SuliJoyGinOverlay.reefNotice(SuliJoyGinGlyph.storeFailed)
                    return
                }

                SuliJoyGinNetworkReef.shared.reefPost(
                    path: SuliJoyGinConfiguration.shared.reefReceiptPath,
                    params: [
                        SuliJoyGinConfiguration.shared.reefReceiptKeys.payloadKey: receipt.base64EncodedString(),
                        SuliJoyGinConfiguration.shared.reefReceiptKeys.serialKey: serial,
                        SuliJoyGinConfiguration.shared.reefReceiptKeys.callbackKey: orderText
                    ],
                    receiptMode: true
                ) { result in
                    self.view.isUserInteractionEnabled = true
                    switch result {
                    case .success:
                        SuliJoyGinOverlay.reefSuccess(SuliJoyGinGlyph.storeSuccess)
                    case .failure:
                        SuliJoyGinOverlay.reefNotice(SuliJoyGinGlyph.storeFailed)
                    }
                }

            case .failure(let error):
                self.view.isUserInteractionEnabled = true
                SuliJoyGinOverlay.reefNotice(error.localizedDescription)
            }
        }
    }
}
