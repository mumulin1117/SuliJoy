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
            window?.rootViewController = Self.lagoonSessionVault()
        }
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let isLagoonConsentMarked = UISceneConfiguration(name: "SuliJoyIslandScene", sessionRole: connectingSceneSession.role)
        isLagoonConsentMarked.delegateClass = SuliJoySceneDelegate.self
        return isLagoonConsentMarked
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SuliJoyIslandLaunchHarbor.islandBackdropView.storeReefImage(deviceToken)
    }

    private static func lagoonSessionVault() -> UIViewController {
        let wardrobeTable = SuliJoyLagoonGateService.shared.restoreSession()
        if wardrobeTable.isLoggedIn, wardrobeTable.currentEmail != nil {
            return SuliJoyMainTabBarController()
        }
        let SuliJoyHarborFlow = UINavigationController(rootViewController: suliJoyShorelineEnsemble())
        SuliJoyHarborFlow.setNavigationBarHidden(true, animated: false)
        return SuliJoyHarborFlow
    }
}
