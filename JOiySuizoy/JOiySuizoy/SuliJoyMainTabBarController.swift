import UIKit

final class SuliJoyMainTabBarController: UITabBarController, UITabBarControllerDelegate {
    private enum ReefTabTideSlot: Int {
        case home = 0
        case feed = 1
        case publish = 2
        case shorts = 3
        case profile = 4
    }

    private struct ReefTabCoveBlueprint {
        let slot: ReefTabTideSlot
        let idleMark: String?
        let activeMark: String?
        let makeRoot: () -> UIViewController
    }

    private enum ReefTabChromeMeasure {
        static let publishBubbleSide: CGFloat = 66
        static let publishBubbleRise: CGFloat = -20
        static let publishCenterLift: CGFloat = 15
        static let tabGlyphTop: CGFloat = 8
        static let tabGlyphBottom: CGFloat = -8
        static let shadowRadius: CGFloat = 12
        static let shadowLift: CGFloat = -4
    }

    private lazy var reefPublishPearlButton: UIButton = {
        let bubble = UIButton(type: .custom)
        bubble.translatesAutoresizingMaskIntoConstraints = false
        bubble.setImage(UIImage(named: "sulijoy_tab_publish_active")?.withRenderingMode(.alwaysOriginal), for: .normal)
        bubble.backgroundColor = .clear
        bubble.imageView?.contentMode = .scaleAspectFit
        bubble.addTarget(self, action: #selector(openPublishLagoonEntry), for: .touchUpInside)
        return bubble
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        assembleReefTabShell()
        polishReefTabChrome()
        anchorReefPublishPearl()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reefPublishPearlButton.layer.cornerRadius = reefPublishPearlButton.bounds.height / 2
        reefPublishPearlButton.center = CGPoint(
            x: tabBar.bounds.midX,
            y: tabBar.bounds.minY + ReefTabChromeMeasure.publishCenterLift
        )
    }

    private func assembleReefTabShell() {
        viewControllers = makeReefTabBlueprints()
            .sorted { $0.slot.rawValue < $1.slot.rawValue }
            .map { makeReefTabNavigation(from: $0) }
    }

    private func makeReefTabBlueprints() -> [ReefTabCoveBlueprint] {
        [
            ReefTabCoveBlueprint(
                slot: .home,
                idleMark: "sulijoy_tab_home_idle",
                activeMark: "sulijoy_tab_home_active",
                makeRoot: { SuliJoyHomeViewController() }
            ),
            ReefTabCoveBlueprint(
                slot: .feed,
                idleMark: "sulijoy_tab_feed_idle",
                activeMark: "sulijoy_tab_feed_active",
                makeRoot: { SuliJoyFeedViewController() }
            ),
            ReefTabCoveBlueprint(
                slot: .publish,
                idleMark: nil,
                activeMark: nil,
                makeRoot: {
                    SuliJoySimplePlaceholderViewController(
                        title: "Create Shore Look",
                        subtitle: "Publishing tools will appear here.",
                        hideTabBar: false
                    )
                }
            ),
            ReefTabCoveBlueprint(
                slot: .shorts,
                idleMark: "sulijoy_tab_dacaner_idle",
                activeMark: "sulijoy_tab_adcaner_active",
                makeRoot: { suliJoyShorelineIntent() }
            ),
            ReefTabCoveBlueprint(
                slot: .profile,
                idleMark: "sulijoy_tab_profile_idle",
                activeMark: "sulijoy_tab_profile_active",
                makeRoot: { SuliJoyLagoonProfileCoveController() }
            )
        ]
    }

    private func makeReefTabNavigation(from blueprint: ReefTabCoveBlueprint) -> UINavigationController {
        let reefNavigation = UINavigationController(rootViewController: blueprint.makeRoot())
        reefNavigation.setNavigationBarHidden(true, animated: false)
        reefNavigation.tabBarItem = UITabBarItem(
            title: nil,
            image: originalReefTabMark(named: blueprint.idleMark),
            selectedImage: originalReefTabMark(named: blueprint.activeMark)
        )
        return reefNavigation
    }

    private func originalReefTabMark(named reefAssetToken: String?) -> UIImage? {
        guard let reefAssetToken else { return nil }
        return UIImage(named: reefAssetToken)?.withRenderingMode(.alwaysOriginal)
    }

    private func polishReefTabChrome() {
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        tabBar.tintColor = .suliInk
        tabBar.unselectedItemTintColor = UIColor(red: 0.63, green: 0.62, blue: 0.58, alpha: 1)
        tabBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.shadowRadius = ReefTabChromeMeasure.shadowRadius
        tabBar.layer.shadowOffset = CGSize(width: 0, height: ReefTabChromeMeasure.shadowLift)
        tabBar.itemPositioning = .fill
        tabBar.items?.forEach { item in
            item.imageInsets = UIEdgeInsets(
                top: ReefTabChromeMeasure.tabGlyphTop,
                left: 0,
                bottom: ReefTabChromeMeasure.tabGlyphBottom,
                right: 0
            )
        }
    }

    private func anchorReefPublishPearl() {
        tabBar.addSubview(reefPublishPearlButton)
        NSLayoutConstraint.activate([
            reefPublishPearlButton.widthAnchor.constraint(equalToConstant: ReefTabChromeMeasure.publishBubbleSide),
            reefPublishPearlButton.heightAnchor.constraint(equalToConstant: ReefTabChromeMeasure.publishBubbleSide),
            reefPublishPearlButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            reefPublishPearlButton.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: ReefTabChromeMeasure.publishBubbleRise)
        ])
    }

    @objc private func openPublishLagoonEntry() {
        let publishLagoon = SuliJoyReefLaunchEntryController()
        publishLagoon.hidesBottomBarWhenPushed = true
        (selectedViewController as? UINavigationController)?.pushViewController(publishLagoon, animated: true)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = viewControllers?.firstIndex(of: viewController), index == ReefTabTideSlot.publish.rawValue {
            openPublishLagoonEntry()
            return false
        }
        return true
    }
}

final class SuliJoyMineLiteViewController: SuliJoyTropicCanvasController {
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

        let logout = SuliJoyGradientButton(reefHeadline: "Log out")
        logout.translatesAutoresizingMaskIntoConstraints = false
        logout.addTarget(self, action: #selector(leaveMineLiteLagoon), for: .touchUpInside)

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

    @objc private func leaveMineLiteLagoon() {
        SuliJoyLagoonGateService.shared.logout()
        let welcome = UINavigationController(rootViewController: suliJoyShorelineEnsemble())
        welcome.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController = welcome
    }
}
