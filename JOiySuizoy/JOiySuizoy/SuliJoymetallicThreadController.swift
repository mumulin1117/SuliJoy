import UIKit

final class SuliJoymetallicThreadController: SuliJoyTropicCanvasController {
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        assembleShareNowDock()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            tabBarController?.tabBar.isHidden = false
        }
    }

    private func assembleShareNowDock() {
        let close = UIButton(type: .custom)
        close.translatesAutoresizingMaskIntoConstraints = false
        close.setImage(UIImage(named: "sulijoy_share_close")?.withRenderingMode(.alwaysOriginal), for: .normal)
        close.imageView?.contentMode = .scaleAspectFit
        close.accessibilityLabel = "Close"
        close.addTarget(self, action: #selector(sailBackToTabs), for: .touchUpInside)

        let title = UIImageView(image: UIImage(named: "sulijoy_share_title")?.withRenderingMode(.alwaysOriginal))
        title.translatesAutoresizingMaskIntoConstraints = false
        title.contentMode = .scaleAspectFit
        title.accessibilityLabel = "Share Now"

        let banner = UIImageView(image: UIImage(named: "sulijoy_share_banner")?
            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), resizingMode: .stretch))
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.contentMode = .scaleToFill
        banner.setContentHuggingPriority(.defaultLow, for: .horizontal)
        banner.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        let caption = UILabel()
        caption.translatesAutoresizingMaskIntoConstraints = false
        caption.text = "Want to Create Events, post, or film?"
        caption.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        caption.textColor = .suliInk
        caption.adjustsFontSizeToFitWidth = true
        caption.minimumScaleFactor = 0.75
        caption.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        banner.addSubview(caption)

        let goLive = makeShareCard(named: "sulijoy_share_go_live", label: "Go Live", action: #selector(openGoLive))
        let startRoom = makeShareCard(named: "sulijoy_share_start_room", label: "Start a Room", action: #selector(openStartRoom))
        let postMoment = makeShareCard(named: "sulijoy_share_post_moment", label: "Post Moment", action: #selector(openShoreMomentMaker))
        let shorts = makeShareCard(named: "sulijoy_share_shorts", label: "Shorts Video", action: #selector(openReefClipMaker))

        let topRow = UIStackView(arrangedSubviews: [goLive, startRoom])
        let bottomRow = UIStackView(arrangedSubviews: [postMoment, shorts])
        [topRow, bottomRow].forEach {
            $0.axis = .horizontal
            $0.spacing = 14
            $0.distribution = .fillEqually
        }
        let grid = UIStackView(arrangedSubviews: [topRow, bottomRow])
        grid.translatesAutoresizingMaskIntoConstraints = false
        grid.axis = .vertical
        grid.spacing = 14

        [close, title, banner, grid].forEach { view.addSubview($0) }
        let gridCenter = grid.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 52)
        gridCenter.priority = .defaultHigh
        NSLayoutConstraint.activate([
            close.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            close.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            close.widthAnchor.constraint(equalToConstant: 32),
            close.heightAnchor.constraint(equalToConstant: 32),

            title.topAnchor.constraint(equalTo: close.bottomAnchor, constant: 18),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            title.heightAnchor.constraint(equalToConstant: 28),
            title.widthAnchor.constraint(equalTo: title.heightAnchor, multiplier: 410.0 / 52.0),
            title.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -22),

            banner.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 14),
            banner.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            banner.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -22),
            banner.heightAnchor.constraint(equalToConstant: 32),
            caption.leadingAnchor.constraint(equalTo: banner.leadingAnchor, constant: 12),
            caption.trailingAnchor.constraint(equalTo: banner.trailingAnchor, constant: -12),
            caption.centerYAnchor.constraint(equalTo: banner.centerYAnchor),

            grid.topAnchor.constraint(greaterThanOrEqualTo: banner.bottomAnchor, constant: 28),
            grid.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            grid.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            grid.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            gridCenter,
            goLive.heightAnchor.constraint(equalTo: goLive.widthAnchor, multiplier: 224.0 / 328.0)
        ])
    }

    private func makeShareCard(named assetName: String, label: String, action: Selector) -> UIButton {
        let card = UIButton(type: .custom)
        card.translatesAutoresizingMaskIntoConstraints = false
        card.setImage(UIImage(named: assetName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        card.imageView?.contentMode = .scaleAspectFit
        card.contentHorizontalAlignment = .fill
        card.contentVerticalAlignment = .fill
        card.accessibilityLabel = label
        card.addTarget(self, action: action, for: .touchUpInside)
        return card
    }

    @objc private func sailBackToTabs() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func openGoLive() {
        showLocalPlaceholder(reefHeadline: "Go Live", subreefHeadline: "Live setup will open here.")
    }

    @objc private func openStartRoom() {
        showLocalPlaceholder(reefHeadline: "Start a Room", subreefHeadline: "Room setup will open here.")
    }

    @objc private func openShoreMomentMaker() {
        let page = SuliJoysequinedGlimmerController()
        page.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(page, animated: true)
    }

    @objc private func openReefClipMaker() {
        let page = SuliJoyReefMotionTideController()
        page.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(page, animated: true)
    }
}
