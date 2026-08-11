//
//  AppDelegate.swift
//  JOiySuizoy
//
//  Created by  on 2026/7/13.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SuliJoyLagoonHarborService.shared.beginPearlHarborRenewalWatch()

        SuliJoyIslandWardrobeCompass.islandShared.islandFallbackCanvas = { window in
            window?.rootViewController = Self.suliJoyIslandRoot()
        }
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let scenePlan = UISceneConfiguration(name: "SuliJoyIslandScene", sessionRole: connectingSceneSession.role)
        scenePlan.delegateClass = SuliJoySceneDelegate.self
        return scenePlan
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SuliJoyIslandLaunchHarbor.islandShared.archivePalmNoticeRibbon(deviceToken)
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
