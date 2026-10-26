import UIKit

final class SuliJoymetallicThreadController: SuliJoyTropicCanvasController {
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        ribbonTop()
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

    private func ribbonTop() {
        let titleDrop = UIButton(type: .custom)
        titleDrop.translatesAutoresizingMaskIntoConstraints = false
        titleDrop.setImage(UIImage(named: "sulijoy_share_close")?.withRenderingMode(.alwaysOriginal), for: .normal)
        titleDrop.imageView?.contentMode = .scaleAspectFit
        titleDrop.accessibilityLabel = "Close"
        titleDrop.addTarget(self, action: #selector(sailBackToTabs), for: .touchUpInside)

        let lagoonSeatMarkbigh = UIImageView(image: UIImage(named: "sulijoy_share_title")?.withRenderingMode(.alwaysOriginal))
        lagoonSeatMarkbigh.translatesAutoresizingMaskIntoConstraints = false
        lagoonSeatMarkbigh.contentMode = .scaleAspectFit
        lagoonSeatMarkbigh.accessibilityLabel = "Share Now"

        let reefReplyAlert = UIImageView(image: UIImage(named: "sulijoy_share_banner")?
            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), resizingMode: .stretch))
        reefReplyAlert.translatesAutoresizingMaskIntoConstraints = false
        reefReplyAlert.contentMode = .scaleToFill
        reefReplyAlert.setContentHuggingPriority(.defaultLow, for: .horizontal)
        reefReplyAlert.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        let caption = UILabel()
        caption.translatesAutoresizingMaskIntoConstraints = false
        caption.text = "Want to Create Events, post, or film?"
        caption.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        caption.textColor = .suliInk
        caption.adjustsFontSizeToFitWidth = true
        caption.minimumScaleFactor = 0.75
        caption.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        reefReplyAlert.addSubview(caption)

        let consentActionRail = reefTallies(named: "sulijoy_share_go_live", label: "Go Live", action: #selector(reefPath))
        let fieldStack = reefTallies(named: "sulijoy_share_start_room", label: "Start a Room", action: #selector(overlap))
        let saveReefMotionToSandbox = reefTallies(named: "sulijoy_share_post_moment", label: "Post Moment", action: #selector(openShoreMomentMaker))
        let shorts = reefTallies(named: "sulijoy_share_shorts", label: "Shorts Video", action: #selector(openReefClipMaker))

        let flag = UIStackView(arrangedSubviews: [consentActionRail, fieldStack])
        let acceptLagoonControl = UIStackView(arrangedSubviews: [saveReefMotionToSandbox, shorts])
        [flag, acceptLagoonControl].forEach {
            $0.axis = .horizontal
            $0.spacing = 14
            $0.distribution = .fillEqually
        }
        let reefNumber = UIStackView(arrangedSubviews: [flag, acceptLagoonControl])
        reefNumber.translatesAutoresizingMaskIntoConstraints = false
        reefNumber.axis = .vertical
        reefNumber.spacing = 14

        [titleDrop, lagoonSeatMarkbigh, reefReplyAlert, reefNumber].forEach { view.addSubview($0) }
        let totalTop = reefNumber.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 52)
        totalTop.priority = .defaultHigh
        NSLayoutConstraint.activate([
            titleDrop.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            titleDrop.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            titleDrop.widthAnchor.constraint(equalToConstant: 32),
            titleDrop.heightAnchor.constraint(equalToConstant: 32),

            lagoonSeatMarkbigh.topAnchor.constraint(equalTo: titleDrop.bottomAnchor, constant: 18),
            lagoonSeatMarkbigh.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            lagoonSeatMarkbigh.heightAnchor.constraint(equalToConstant: 28),
            lagoonSeatMarkbigh.widthAnchor.constraint(equalTo: lagoonSeatMarkbigh.heightAnchor, multiplier: 410.0 / 52.0),
            lagoonSeatMarkbigh.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -22),

            reefReplyAlert.topAnchor.constraint(equalTo: lagoonSeatMarkbigh.bottomAnchor, constant: 14),
            reefReplyAlert.leadingAnchor.constraint(equalTo: lagoonSeatMarkbigh.leadingAnchor),
            reefReplyAlert.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -22),
            reefReplyAlert.heightAnchor.constraint(equalToConstant: 32),
            caption.leadingAnchor.constraint(equalTo: reefReplyAlert.leadingAnchor, constant: 12),
            caption.trailingAnchor.constraint(equalTo: reefReplyAlert.trailingAnchor, constant: -12),
            caption.centerYAnchor.constraint(equalTo: reefReplyAlert.centerYAnchor),

            reefNumber.topAnchor.constraint(greaterThanOrEqualTo: reefReplyAlert.bottomAnchor, constant: 28),
            reefNumber.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            reefNumber.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            reefNumber.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            totalTop,
            consentActionRail.heightAnchor.constraint(equalTo: consentActionRail.widthAnchor, multiplier: 224.0 / 328.0)
        ])
    }

    private func reefTallies(named assembleShoreProfileReef: String, label: String, action: Selector) -> UIButton {
        let card = UIButton(type: .custom)
        card.translatesAutoresizingMaskIntoConstraints = false
        card.setImage(UIImage(named: assembleShoreProfileReef)?.withRenderingMode(.alwaysOriginal), for: .normal)
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

    @objc private func reefPath() {
        let page = coralMood()
        page.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(page, animated: true)
    }

    @objc private func overlap() {
        let page = typeWrap()
        page.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(page, animated: true)
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
