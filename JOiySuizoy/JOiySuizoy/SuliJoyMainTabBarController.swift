import UIKit

final class SuliJoyMainTabBarController: UITabBarController, UITabBarControllerDelegate {
    private let publishButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        configureTabs()
        configureTabBar()
        configurePublishButton()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        publishButton.layer.cornerRadius = publishButton.bounds.height / 2
        publishButton.center = CGPoint(x: tabBar.bounds.midX, y: tabBar.bounds.minY + 15)
    }

    private func configureTabs() {
        let home = UINavigationController(rootViewController: SuliJoyHomeViewController())
        home.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "sulijoy_tab_home_idle")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "sulijoy_tab_home_active")?.withRenderingMode(.alwaysOriginal)
        )

        let feed = UINavigationController(rootViewController: SuliJoyFeedViewController())
        feed.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "sulijoy_tab_feed_idle")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "sulijoy_tab_feed_active")?.withRenderingMode(.alwaysOriginal)
        )

        let publish = UINavigationController(rootViewController: SuliJoySimplePlaceholderViewController(title: "Create Shore Look", subtitle: "Publishing tools will appear here.", hideTabBar: false))
        publish.tabBarItem = UITabBarItem(title: nil, image: nil, selectedImage: nil)

        let video = UINavigationController(rootViewController: SuliJoyShortsViewController())
        video.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "sulijoy_tab_video_idle")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "sulijoy_tab_video_active")?.withRenderingMode(.alwaysOriginal)
        )

        let mine = UINavigationController(rootViewController: SuliJoyProfileViewController())
        mine.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "sulijoy_tab_profile_idle")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "sulijoy_tab_profile_active")?.withRenderingMode(.alwaysOriginal)
        )

        [home, feed, publish, video, mine].forEach { $0.setNavigationBarHidden(true, animated: false) }
        viewControllers = [home, feed, publish, video, mine]
    }

    private func configureTabBar() {
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        tabBar.tintColor = .suliInk
        tabBar.unselectedItemTintColor = UIColor(red: 0.63, green: 0.62, blue: 0.58, alpha: 1)
        tabBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.shadowRadius = 12
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -4)
        tabBar.itemPositioning = .fill
        tabBar.items?.forEach { item in
            item.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        }
    }

    private func configurePublishButton() {
        publishButton.translatesAutoresizingMaskIntoConstraints = false
        publishButton.setImage(UIImage(named: "sulijoy_tab_publish_active")?.withRenderingMode(.alwaysOriginal), for: .normal)
        publishButton.backgroundColor = .clear
        publishButton.imageView?.contentMode = .scaleAspectFit
        publishButton.addTarget(self, action: #selector(openPublish), for: .touchUpInside)
        tabBar.addSubview(publishButton)
        NSLayoutConstraint.activate([
            publishButton.widthAnchor.constraint(equalToConstant: 66),
            publishButton.heightAnchor.constraint(equalToConstant: 66),
            publishButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            publishButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -20)
        ])
    }

    @objc private func openPublish() {
        let page = SuliJoyPublishEntryViewController()
        page.hidesBottomBarWhenPushed = true
        let selectedNav = selectedViewController as? UINavigationController
        selectedNav?.pushViewController(page, animated: true)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = viewControllers?.firstIndex(of: viewController), index == 2 {
            openPublish()
            return false
        }
        return true
    }
}

final class SuliJoyMineLiteViewController: SuliJoyBaseIslandViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "My Island"
        title.font = UIFont.systemFont(ofSize: 30, weight: .black)
        title.textColor = .suliInk

        let profile = SuliJoyLocalProfileStore().currentProfile()
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.text = profile?.nickname ?? "Your SuliJoy style profile"
        subtitle.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        subtitle.textColor = .suliMutedInk

        let logout = SuliJoyGradientButton(title: "Log out")
        logout.translatesAutoresizingMaskIntoConstraints = false
        logout.addTarget(self, action: #selector(logoutNow), for: .touchUpInside)

        [title, subtitle, logout].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 72),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            subtitle.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            subtitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            logout.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            logout.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            logout.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -96)
        ])
    }

    @objc private func logoutNow() {
        SuliJoyLocalAuthService.shared.logout()
        let welcome = UINavigationController(rootViewController: SuliJoyWelcomeViewController())
        welcome.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController = welcome
    }
}
