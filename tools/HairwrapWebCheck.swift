import UIKit
import WebKit

enum coastalColourAccord {}

@main
final class HairwrapWebCheck: UIResponder, UIApplicationDelegate, WKNavigationDelegate {
    var window: UIWindow?
    var views: [WKWebView] = []
    var results: [String: Any] = [:]
    var controller = UIViewController()
    let store = WKWebsiteDataStore.nonPersistent()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = controller
        window.makeKeyAndVisible()
        self.window = window
        let rules = #"[{"trigger":{"url-filter":"^https?://"},"action":{"type":"block"}}]"#
        WKContentRuleListStore.default().compileContentRuleList(forIdentifier: "fixture-block-network", encodedContentRuleList: rules) { rules, error in
            guard let rules else { self.save(["error": String(describing: error)]); return }
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let archive = Bundle.main.bundleURL.appendingPathComponent("HairwrapKnotDrape/CoastalWeave.dat")
                    let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("HairwrapKnotDrape")
                    let unpacked = try coastalColourAccord.wardrobeCapsuleEdit(archive, duneRamieFold: cache, equinoxNeutralHarmony: true)
                    DispatchQueue.main.async {
                        self.load(Bundle.main.bundleURL.appendingPathComponent("Baseline"), name: "baseline", rules: rules)
                        self.load(unpacked, name: "packed", rules: rules)
                    }
                } catch { self.save(["error": String(describing: error)]) }
            }
        }
        return true
    }

    func load(_ directory: URL, name: String, rules: WKContentRuleList) {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = store
        configuration.userContentController.add(rules)
        let web = WKWebView(frame: .zero, configuration: configuration)
        web.accessibilityIdentifier = name
        web.navigationDelegate = self
        web.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addSubview(web)
        let first = views.isEmpty
        views.append(web)
        NSLayoutConstraint.activate([
            web.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor),
            web.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor),
            web.heightAnchor.constraint(equalTo: controller.view.heightAnchor, multiplier: 0.5),
            web.topAnchor.constraint(equalTo: first ? controller.view.topAnchor : controller.view.centerYAnchor)
        ])
        let route = directory.appendingPathComponent("index.html").absoluteString + "#/voice/1001?token=fixture&userId=1&appVersion=1&deviceNo=fixture"
        web.loadFileURL(URL(string: route)!, allowingReadAccessTo: directory)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            webView.evaluateJavaScript("JSON.stringify({ready:document.readyState,text:document.body.innerText,bg:getComputedStyle(document.body).backgroundColor,font:getComputedStyle(document.body).fontFamily,fonts:document.fonts.status,images:[...document.images].map(x=>({loaded:x.complete,width:x.naturalWidth}))})") { value, error in
                guard let text = value as? String, let data = text.data(using: .utf8), let result = try? JSONSerialization.jsonObject(with: data) else {
                    self.save(["error": String(describing: error)]); return
                }
                self.results[webView.accessibilityIdentifier!] = result
                if self.results.count == 2 {
                    let a = self.results["baseline"] as! [String: Any]
                    let b = self.results["packed"] as! [String: Any]
                    self.results["equal"] = NSDictionary(dictionary: a).isEqual(to: b)
                    self.results["network_blocked"] = true
                    self.checkStorage()
                }
            }
        }
    }

    func checkStorage() {
        let write = #"localStorage.setItem('hairwrap-fixture','preserved'); return await new Promise((resolve,reject)=>{const r=indexedDB.open('hairwrap-fixture-db',1);r.onupgradeneeded=()=>r.result.createObjectStore('values');r.onerror=()=>reject('unavailable');r.onsuccess=()=>{const db=r.result,t=db.transaction('values','readwrite');t.objectStore('values').put('preserved','key');t.oncomplete=()=>{db.close();resolve(true)};t.onerror=()=>reject('unavailable')}})"#
        let read = #"const local=localStorage.getItem('hairwrap-fixture');const value=await new Promise((resolve,reject)=>{const r=indexedDB.open('hairwrap-fixture-db',1);r.onupgradeneeded=()=>r.result.createObjectStore('values');r.onerror=()=>reject('unavailable');r.onsuccess=()=>{const db=r.result,t=db.transaction('values','readonly'),q=t.objectStore('values').get('key');q.onsuccess=()=>{db.close();resolve(q.result)};q.onerror=()=>reject('unavailable')}});return local==='preserved'&&value==='preserved'"#
        views[0].callAsyncJavaScript(write, arguments: [:], in: nil, in: .page) { result in
            switch result {
            case .success:
                self.views[1].callAsyncJavaScript(read, arguments: [:], in: nil, in: .page) { result in
                    if case .success(let preserved) = result { self.results["storage_preserved"] = preserved as? Bool == true }
                    else { self.results["storage_preserved"] = false }
                    self.save(self.results)
                }
            case .failure:
                self.results["baseline_storage_unavailable"] = true
                self.save(self.results)
            }
        }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        save(["error": error.localizedDescription])
    }

    func save(_ result: [String: Any]) {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("result.json")
        try? JSONSerialization.data(withJSONObject: result, options: [.prettyPrinted, .sortedKeys]).write(to: url, options: .atomic)
    }
}
