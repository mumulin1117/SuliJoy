import UIKit
import WebKit

final class SuliJoyRoomShellWebController: SuliJoyTropicCanvasController {
    private enum ShellBridge {
        static let handlerName = "roomBridge"
        static let receiverName = "__ROOM_H5_BRIDGE_RECEIVE__"
        static let rechargeEvent = "recharge.succeeded"
        static let splashColor = UIColor(red: 21 / 255, green: 5 / 255, blue: 46 / 255, alpha: 1)
    }

    private let roomKind: SuliJoyRoomShellKind
    private let roomID: String
    private let credentials: SuliJoyRoomShellCredentials

    private var webView: WKWebView!
    private var bridgeCoordinator: RoomShellBridgeCoordinator?
    private let splashOverlay = SuliJoyShoreRoomLoadingView()

    init(roomKind: SuliJoyRoomShellKind, roomID: String, credentials: SuliJoyRoomShellCredentials) {
        self.roomKind = roomKind
        self.roomID = roomID
        self.credentials = credentials
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ShellBridge.splashColor
        assembleRoomShellScene()
        loadRoomShellEntry(forceFreshCredentials: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    @MainActor deinit {
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: ShellBridge.handlerName)
    }

    private func assembleRoomShellScene() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        }
        let coordinator = RoomShellBridgeCoordinator(owner: self)
        bridgeCoordinator = coordinator
        configuration.userContentController.add(coordinator, name: ShellBridge.handlerName)

        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = ShellBridge.splashColor
        webView.isOpaque = false
        webView.scrollView.backgroundColor = ShellBridge.splashColor
        webView.uiDelegate = coordinator
        webView.navigationDelegate = coordinator

        view.addSubview(webView)
        view.addSubview(splashOverlay)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            splashOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            splashOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            splashOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            splashOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        splashOverlay.showShore(kind: roomKind)
    }

    fileprivate func loadRoomShellEntry(forceFreshCredentials: Bool) {
        let activeCredentials: SuliJoyRoomShellCredentials
        if forceFreshCredentials, let fresh = SuliJoyRoomShellCredentials.fromCurrentSession() {
            activeCredentials = fresh
        } else {
            activeCredentials = credentials
        }
        guard let dist = SuliJoyRoomShellBundleLocator.distDirectoryURL(),
              let entry = SuliJoyRoomShellBundleLocator.buildEntryURL(
                roomKind: roomKind,
                roomID: roomID,
                credentials: activeCredentials
              ) else {
            showLagoonToast("The room bundle could not be loaded.")
            navigationController?.popViewController(animated: true)
            return
        }
        splashOverlay.showShore(kind: roomKind)
        webView.loadFileURL(entry, allowingReadAccessTo: dist)
    }

    fileprivate func revealRoomShellContent() {
        UIView.animate(withDuration: 0.25, animations: {
            self.splashOverlay.alpha = 0
        }, completion: { _ in
            self.splashOverlay.hideShore()
        })
    }

    fileprivate func closeRoomShell(reason: String) {
        _ = reason
        navigationController?.popViewController(animated: true)
    }

    fileprivate func openRoomShellRecharge(requiredDiamonds: Int) {
        let harbor = SuliJoyPearlHarborViewController()
        harbor.hidesBottomBarWhenPushed = true
        harbor.onShellPurchaseSettled = { [weak self] transactionID in
            self?.notifyRoomShellRechargeSucceeded(transactionID: transactionID)
        }
        navigationController?.pushViewController(harbor, animated: true)
        if requiredDiamonds > 0 {
            showLagoonToast("Add gems to continue in the room.")
        }
    }

    fileprivate func notifyRoomShellRechargeSucceeded(transactionID: String?) {
        var payload: [String: Any] = [
            "eventId": UUID().uuidString,
            "occurredAt": Int(Date().timeIntervalSince1970 * 1000),
        ]
        if let transactionID, !transactionID.isEmpty {
            payload["transactionId"] = transactionID
        }
        let message: [String: Any] = [
            "protocolVersion": 1,
            "kind": "event",
            "name": ShellBridge.rechargeEvent,
            "payload": payload,
        ]
        guard let data = try? JSONSerialization.data(withJSONObject: message),
              let json = String(data: data, encoding: .utf8) else { return }
        let script = "window.\(ShellBridge.receiverName)(\(json));"
        webView.evaluateJavaScript(script, completionHandler: nil)
    }
}

private final class RoomShellBridgeCoordinator: NSObject, WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate {
    private weak var owner: SuliJoyRoomShellWebController?

    init(owner: SuliJoyRoomShellWebController) {
        self.owner = owner
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == "roomBridge" else { return }
        let body = message.body
        let dictionary: [String: Any]
        if let map = body as? [String: Any] {
            dictionary = map
        } else if let text = body as? String,
                  let data = text.data(using: .utf8),
                  let map = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            dictionary = map
        } else {
            return
        }
        guard dictionary["kind"] as? String == "command" else { return }
        let name = dictionary["name"] as? String ?? ""
        let payload = dictionary["payload"] as? [String: Any] ?? [:]
        switch name {
        case "room.ready":
            owner?.revealRoomShellContent()
        case "room.close":
            let reason = payload["reason"] as? String ?? "user"
            owner?.closeRoomShell(reason: reason)
        case "recharge.open":
            let required = payload["requiredDiamonds"] as? Int ?? 0
            owner?.openRoomShellRecharge(requiredDiamonds: required)
        default:
            break
        }
    }

    @available(iOS 15.0, *)
    func webView(
        _ webView: WKWebView,
        requestMediaCapturePermissionFor origin: WKSecurityOrigin,
        initiatedByFrame frame: WKFrameInfo,
        type: WKMediaCaptureType,
        decisionHandler: @escaping (WKPermissionDecision) -> Void
    ) {
        decisionHandler(.grant)
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        owner?.loadRoomShellEntry(forceFreshCredentials: true)
    }
}
