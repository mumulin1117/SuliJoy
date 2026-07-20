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

        let root: UIViewController
        let session = SuliJoyLagoonGateService.shared.restoreSession()
        if session.isLoggedIn, session.currentEmail != nil {
            root = SuliJoyMainTabBarController()
        } else {
            let auth = UINavigationController(rootViewController: suliJoyShorelineEnsemble())
            auth.setNavigationBarHidden(true, animated: false)
            root = auth
        }

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = root
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
