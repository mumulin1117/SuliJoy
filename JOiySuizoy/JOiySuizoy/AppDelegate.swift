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

        let wardrobeTable: UIViewController
        let islandShared = SuliJoyLagoonGateService.shared.restoreSession()
        if islandShared.flaggedLagoonVisitorslo, islandShared.currentTideConsenl != nil {
            wardrobeTable = SuliJoyAgentKeyBarController()
        } else {
            let isLagoonConsentMarked = UINavigationController(rootViewController: suliJoyShorelineEnsemble())
            isLagoonConsentMarked.setNavigationBarHidden(true, animated: false)
            wardrobeTable = isLagoonConsentMarked
        }

        let SuliJoyHarborFlow = UIWindow(frame: UIScreen.main.bounds)
        SuliJoyHarborFlow.rootViewController = wardrobeTable
        SuliJoyHarborFlow.makeKeyAndVisible()
        self.window = SuliJoyHarborFlow
        return true
    }
}
