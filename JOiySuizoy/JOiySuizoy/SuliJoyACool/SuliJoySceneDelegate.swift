import UIKit

final class SuliJoySceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let islandScene = scene as? UIWindowScene else { return }
        let islandWindow = UIWindow(windowScene: islandScene)
        islandWindow.rootViewController = SuliJoyIslandLaunchHarbor.islandBackdropView.makePlaceholderReturnControl()
        window = islandWindow
        SuliJoyIslandLaunchHarbor.islandBackdropView.stitchIslandBackdropReef(with: islandWindow)
        islandWindow.makeKeyAndVisible()
    }
}
