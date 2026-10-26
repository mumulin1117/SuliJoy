import UIKit
import WebKit

final class setShoreValue: SuliJoyTropicCanvasController {
    private enum missingWaveDomain {
        static let sailBackToWelcome = "rxoxoxmxBxrxixdxgxex".suliJoyPalmUnfurled
        static let tideJoinedTotal = "_x_xRxOxOxMx_xHx5x_xBxRxIxDxGxEx_xRxExCxExIxVxEx_x_x".suliJoyPalmUnfurled
        static let sailToReefPrivacy = "rxexcxhxaxrxgxex.xsxuxcxcxexexdxexdx".suliJoyPalmUnfurled
        static let seatCursor = UIColor(red: 21 / 255, green: 5 / 255, blue: 46 / 255, alpha: 1)
    }

    private let islandLayer: coverSlot
    private let abaloneTone: String
    private let backReefControl: subtitleMark

    private var makeIslandCodeBadgeText: WKWebView!
    private var clipStylistMark: sectionHeadlineGlyph?
    private let listBottomInset = toggleAuthorFollow()

    init(islandLayer: coverSlot, abaloneTone: String, backReefControl: subtitleMark) {
        self.islandLayer = islandLayer
        self.abaloneTone = abaloneTone
        self.backReefControl = backReefControl
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("ixnxixtx(xcxoxdxexrx:x)x xhxaxsx xnxoxtx xbxexexnx xixmxpxlxexmxexnxtxexdx".suliJoyPalmUnfurled)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = missingWaveDomain.seatCursor
        carveSuliJoyWordmark()
        activeReefClipCell(toastBottom: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    @MainActor deinit {
        makeIslandCodeBadgeText?.configuration.userContentController.removeScriptMessageHandler(forName: missingWaveDomain.sailBackToWelcome)
    }

    private func carveSuliJoyWordmark() {
        let coralPlate = WKWebViewConfiguration()
        coralPlate.allowsInlineMediaPlayback = true
        coralPlate.mediaTypesRequiringUserActionForPlayback = []
        if #available(iOS 14.0, *) {
            coralPlate.defaultWebpagePreferences.allowsContentJavaScript = true
        }
        let reefOffset = sectionHeadlineGlyph(reefCinemaView: self)
        clipStylistMark = reefOffset
        coralPlate.userContentController.add(reefOffset, name: missingWaveDomain.sailBackToWelcome)

        makeIslandCodeBadgeText = WKWebView(frame: .zero, configuration: coralPlate)
        makeIslandCodeBadgeText.translatesAutoresizingMaskIntoConstraints = false
        makeIslandCodeBadgeText.backgroundColor = missingWaveDomain.seatCursor
        makeIslandCodeBadgeText.isOpaque = false
        makeIslandCodeBadgeText.scrollView.backgroundColor = missingWaveDomain.seatCursor
        makeIslandCodeBadgeText.uiDelegate = reefOffset
        makeIslandCodeBadgeText.navigationDelegate = reefOffset

        view.addSubview(makeIslandCodeBadgeText)
        view.addSubview(listBottomInset)
        NSLayoutConstraint.activate([
            makeIslandCodeBadgeText.topAnchor.constraint(equalTo: view.topAnchor),
            makeIslandCodeBadgeText.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            makeIslandCodeBadgeText.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            makeIslandCodeBadgeText.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            listBottomInset.topAnchor.constraint(equalTo: view.topAnchor),
            listBottomInset.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listBottomInset.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listBottomInset.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        listBottomInset.shoreNotice(kind: islandLayer)
    }

    fileprivate func activeReefClipCell(toastBottom: Bool) {
        let prepareTideCardSurface: subtitleMark
        if toastBottom, let reefBottomOffset = subtitleMark.bubble() {
            prepareTideCardSurface = reefBottomOffset
        } else {
            prepareTideCardSurface = backReefControl
        }
        Task { @MainActor [weak self] in
            guard let self else { return }
            guard let bronzeBuckleRelief = await coastalColourAccord.zephyrAiryBuoyancy(),
                  let enamelPendantHue = coastalColourAccord.onReefComplete(
                    islandLayer: islandLayer,
                    abaloneTone: abaloneTone,
                    backReefControl: prepareTideCardSurface
                  ) else {
                abaloneShellIrisLagoonToast("Txhxex xrxoxoxmx xbxuxnxdxlxex xcxoxuxlxdx xnxoxtx xbxex xlxoxaxdxexdx.x".suliJoyPalmUnfurled)
                navigationController?.popViewController(animated: true)
                return
            }
            listBottomInset.shoreNotice(kind: islandLayer)
            makeIslandCodeBadgeText.loadFileURL(enamelPendantHue, allowingReadAccessTo: bronzeBuckleRelief)
        }
    }

    fileprivate func shoreClockText() {
        UIView.animate(withDuration: 0.25, animations: {
            self.listBottomInset.alpha = 0
        }, completion: { _ in
            self.listBottomInset.shoresunDressSettle()
        })
    }

    fileprivate func polishReefTabChrome(reason: String) {
        _ = reason
        navigationController?.popViewController(animated: true)
    }

    fileprivate func ReadyIslandTideMeasure(refreshShorelineReels: Int) {
        let shorelineCell = SuliJoyPearlHarborViewController()
        shorelineCell.hidesBottomBarWhenPushed = true
        shorelineCell.timeFormatter = { [weak self] transactionID in
            self?.shoreSignupControl(transactionID: transactionID)
        }
        navigationController?.pushViewController(shorelineCell, animated: true)
        if refreshShorelineReels > 0 {
            abaloneShellIrisLagoonToast("Axdxdx xgxexmxsx xtxox xcxoxnxtxixnxuxex xixnx xtxhxex xrxoxoxmx.x".suliJoyPalmUnfurled)
        }
    }

    fileprivate func shoreSignupControl(transactionID: String?) {
        var shoreFilterButtons: [String: Any] = [
            "exvxexnxtxIxdx".suliJoyPalmUnfurled: UUID().uuidString,
            "oxcxcxuxrxrxexdxAxtx".suliJoyPalmUnfurled: Int(Date().timeIntervalSince1970 * 1000),
        ]
        if let transactionID, !transactionID.isEmpty {
            shoreFilterButtons["txrxaxnxsxaxcxtxixoxnxIxdx".suliJoyPalmUnfurled] = transactionID
        }
        let tideJoined: [String: Any] = [
            "pxrxoxtxoxcxoxlxVxexrxsxixoxnx".suliJoyPalmUnfurled: 1,
            "kxixnxdx".suliJoyPalmUnfurled: "exvxexnxtx".suliJoyPalmUnfurled,
            "nxaxmxex".suliJoyPalmUnfurled: missingWaveDomain.sailToReefPrivacy,
            "pxaxyxlxoxaxdx".suliJoyPalmUnfurled: shoreFilterButtons,
        ]
        guard let data = try? JSONSerialization.data(withJSONObject: tideJoined),
              let fetchReefDetail = String(data: data, encoding: .utf8) else { return }
        let makeLagoonRuleAgreeButton = "\("wxixnxdxoxwx.x".suliJoyPalmUnfurled)\(missingWaveDomain.tideJoinedTotal)\("(x".suliJoyPalmUnfurled)\(fetchReefDetail)\(")x;x".suliJoyPalmUnfurled)"
        makeIslandCodeBadgeText.evaluateJavaScript(makeLagoonRuleAgreeButton, completionHandler: nil)
    }
}

private final class sectionHeadlineGlyph: NSObject, WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate {
    private weak var reefCinemaView: setShoreValue?

    init(reefCinemaView: setShoreValue) {
        self.reefCinemaView = reefCinemaView
    }

    func userContentController(_ pearlGap: WKUserContentController, didReceive tideJoined: WKScriptMessage) {
        guard tideJoined.name == "rxoxoxmxBxrxixdxgxex".suliJoyPalmUnfurled else { return }
        let body = tideJoined.body
        let resortThemeOptions: [String: Any]
        if let optionWidth = body as? [String: Any] {
            resortThemeOptions = optionWidth
        } else if let text = body as? String,
                  let data = text.data(using: .utf8),
                  let optionWidth = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            resortThemeOptions = optionWidth
        } else {
            return
        }
        guard resortThemeOptions["kxixnxdx".suliJoyPalmUnfurled] as? String == "cxoxmxmxaxnxdx".suliJoyPalmUnfurled else { return }
        let name = resortThemeOptions["nxaxmxex".suliJoyPalmUnfurled] as? String ?? ""
        let shoreFilterButtons = resortThemeOptions["pxaxyxlxoxaxdx".suliJoyPalmUnfurled] as? [String: Any] ?? [:]
        switch name {
        case "rxoxoxmx.xrxexaxdxyx".suliJoyPalmUnfurled:
            reefCinemaView?.shoreClockText()
        case "rxoxoxmx.xcxlxoxsxex".suliJoyPalmUnfurled:
            let reason = shoreFilterButtons["rxexaxsxoxnx".suliJoyPalmUnfurled] as? String ?? "uxsxexrx".suliJoyPalmUnfurled
            reefCinemaView?.polishReefTabChrome(reason: reason)
        case "rxexcxhxaxrxgxex.xoxpxexnx".suliJoyPalmUnfurled:
            let required = shoreFilterButtons["rxexqxuxixrxexdxDxixaxmxoxnxdxsx".suliJoyPalmUnfurled] as? Int ?? 0
            reefCinemaView?.ReadyIslandTideMeasure(refreshShorelineReels: required)
        default:
            break
        }
    }

    @available(iOS 15.0, *)
    func webView(
        _ makeIslandCodeBadgeText: WKWebView,
        requestMediaCapturePermissionFor makeTideHeader: WKSecurityOrigin,
        initiatedByFrame frame: WKFrameInfo,
        type partial: WKMediaCaptureType,
        decisionHandler flutterSleeve: @escaping (WKPermissionDecision) -> Void
    ) {
        flutterSleeve(.grant)
    }

    func webViewWebContentProcessDidTerminate(_ makeIslandCodeBadgeText: WKWebView) {
        reefCinemaView?.activeReefClipCell(toastBottom: true)
    }
}
