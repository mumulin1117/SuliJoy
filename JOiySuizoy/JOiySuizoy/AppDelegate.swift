//
//  AppDelegate.swift
//  JOiySuizoy
//
//  Created by  on 2026/7/13.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SuliJoyLagoonHarborService.shared.beginPearlHarborRenewalWatch()

        SuliJoyGinConfiguration.shared.reefReturnToIslandRoot = { window in
            window?.rootViewController = Self.suliJoyIslandRoot()
        }
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        SuliJoyGinHub.shared.reefPrepare(with: window)
        window.rootViewController = SuliJoyGinHub.shared.reefLaunchController()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SuliJoyGinHub.shared.reefStorePushRibbon(deviceToken)
    }

    private static func suliJoyIslandRoot() -> UIViewController {
        let session = SuliJoyLagoonGateService.shared.restoreSession()
        if session.isLoggedIn, session.currentEmail != nil {
            return SuliJoyMainTabBarController()
        }
        let auth = UINavigationController(rootViewController: suliJoyShorelineEnsemble())
        auth.setNavigationBarHidden(true, animated: false)
        return auth
    }
}
