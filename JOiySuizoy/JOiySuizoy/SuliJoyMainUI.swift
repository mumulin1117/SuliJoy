import UIKit

extension UIView {
    func suliPinEdges(to guide: UILayoutGuide, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: guide.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -insets.bottom)
        ])
    }

    func suliPinEdges(to view: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
        ])
    }
}

extension UIFont {
    func suliWithWeight(_ weight: UIFont.Weight) -> UIFont {
        UIFont.systemFont(ofSize: pointSize, weight: weight)
    }
}

extension UIImage {
    static func suliJoyAssetOrLocal(named name: String) -> UIImage? {
        if let image = UIImage(named: name) {
            return image
        }
        return UIImage(contentsOfFile: name)
    }
}

extension Notification.Name {
    static let suliJoyShoreMomentPublished = Notification.Name("suliJoyShoreMomentPublished")
    static let suliJoyShellClipPublished = Notification.Name("suliJoyShellClipPublished")
    static let suliJoyLagoonVisitorChanged = Notification.Name("suliJoyLagoonVisitorChanged")
}

final class SuliJoyPillIconButton: UIButton {
    init(assetName: String? = nil, title: String? = nil) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 22
        layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 4)
        heightAnchor.constraint(equalToConstant: 44).isActive = true
        if let title {
            setTitle(title, for: .normal)
            setTitleColor(.suliInk, for: .normal)
            titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
        }
        if let assetName {
            setImage(UIImage(named: assetName)?.withRenderingMode(.alwaysOriginal), for: .normal)
            imageView?.contentMode = .scaleAspectFit
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class SuliJoyCoinPillButton: UIButton {
    private let gradientLayer = CAGradientLayer()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setBalance(SuliJoyShellWalletStore.shared.currentBalance())
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        setImage(UIImage(named: "sulijoy_shell_coin_gem")?.withRenderingMode(.alwaysOriginal), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        layer.cornerRadius = 22
        layer.masksToBounds = true
        heightAnchor.constraint(equalToConstant: 44).isActive = true
        widthAnchor.constraint(equalToConstant: 92).isActive = true
        gradientLayer.colors = [
            UIColor(red: 1, green: 0.45, blue: 0.50, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.75, blue: 0.29, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setBalance(_ balance: Int) {
        setTitle("\(balance)", for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        layer.cornerRadius = bounds.height / 2
    }
}

final class SuliJoyGradientCapsuleView: UIView {
    private let gradientLayer = CAGradientLayer()

    init(colors: [UIColor]) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.colors = colors.map(\.cgColor)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        layer.cornerRadius = min(bounds.height / 2, 20)
    }
}

class SuliJoyBaseIslandViewController: UIViewController {
    let backgroundView = SuliJoyIslandBackgroundView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func showToast(_ message: String) {
        let toast = UIView()
        toast.translatesAutoresizingMaskIntoConstraints = false
        toast.alpha = 0
        toast.backgroundColor = UIColor.white.withAlphaComponent(0.94)
        toast.layer.cornerRadius = 20
        toast.layer.shadowColor = UIColor(red: 1, green: 0.53, blue: 0.22, alpha: 0.34).cgColor
        toast.layer.shadowOpacity = 1
        toast.layer.shadowRadius = 18
        toast.layer.shadowOffset = CGSize(width: 0, height: 8)

        let stripe = CAGradientLayer()
        stripe.colors = [
            UIColor(red: 1, green: 0.64, blue: 0.36, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.96, blue: 0.33, alpha: 1).cgColor,
            UIColor(red: 0.70, green: 1, blue: 0.71, alpha: 1).cgColor
        ]
        stripe.startPoint = CGPoint(x: 0, y: 0.5)
        stripe.endPoint = CGPoint(x: 1, y: 0.5)
        toast.layer.addSublayer(stripe)

        let icon = UIImageView(image: UIImage(named: "sulijoy_shell_coin_gem"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = message
        label.textAlignment = .left
        label.textColor = .suliInk
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0

        toast.addSubview(icon)
        toast.addSubview(label)
        view.addSubview(toast)
        NSLayoutConstraint.activate([
            toast.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            toast.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
            toast.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -88),
            toast.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -48),
            toast.heightAnchor.constraint(greaterThanOrEqualToConstant: 46),

            icon.leadingAnchor.constraint(equalTo: toast.leadingAnchor, constant: 14),
            icon.centerYAnchor.constraint(equalTo: toast.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 22),
            icon.heightAnchor.constraint(equalToConstant: 22),

            label.topAnchor.constraint(equalTo: toast.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: toast.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: toast.bottomAnchor, constant: -12)
        ])
        view.layoutIfNeeded()
        stripe.frame = CGRect(x: 0, y: toast.bounds.height - 4, width: toast.bounds.width, height: 4)
        UIView.animate(withDuration: 0.2) {
            toast.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.45) {
            UIView.animate(withDuration: 0.25, animations: {
                toast.alpha = 0
            }, completion: { _ in
                toast.removeFromSuperview()
            })
        }
    }

    func showLocalPlaceholder(title: String, subtitle: String) {
        navigationController?.pushViewController(SuliJoySimplePlaceholderViewController(title: title, subtitle: subtitle), animated: true)
    }

    func openSuliJoyMessages() {
        let page = SuliJoyMessagesViewController()
        page.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(page, animated: true)
    }
}

extension UIViewController {
    func presentSuliJoyNotice(
        title: String = "SuliJoy",
        message: String,
        primaryTitle: String = "OK",
        primaryAction: (() -> Void)? = nil
    ) {
        let overlay = UIControl()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.46)
        overlay.alpha = 0

        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 28
        card.clipsToBounds = true
        card.layer.shadowColor = UIColor.black.withAlphaComponent(0.16).cgColor
        card.layer.shadowOpacity = 1
        card.layer.shadowRadius = 22
        card.layer.shadowOffset = CGSize(width: 0, height: 12)

        let badgeShell = UIView()
        badgeShell.translatesAutoresizingMaskIntoConstraints = false
        badgeShell.backgroundColor = UIColor(red: 1, green: 0.95, blue: 0.72, alpha: 1)
        badgeShell.layer.cornerRadius = 27
        badgeShell.clipsToBounds = true

        let badge = UIImageView(image: UIImage(named: "sulijoy_shell_coin_gem"))
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.contentMode = .scaleAspectFit

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.textColor = .suliInk
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .black)
        titleLabel.numberOfLines = 0

        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message
        messageLabel.textColor = .suliMutedInk
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        messageLabel.numberOfLines = 0

        let button = SuliJoyGradientButton(title: primaryTitle)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
        button.addAction(UIAction { [weak overlay] _ in
            UIView.animate(withDuration: 0.18, animations: {
                overlay?.alpha = 0
            }, completion: { _ in
                overlay?.removeFromSuperview()
                primaryAction?()
            })
        }, for: .touchUpInside)

        view.addSubview(overlay)
        overlay.addSubview(card)
        badgeShell.addSubview(badge)
        [badgeShell, titleLabel, messageLabel, button].forEach { card.addSubview($0) }

        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            card.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
            card.leadingAnchor.constraint(greaterThanOrEqualTo: overlay.leadingAnchor, constant: 34),
            card.trailingAnchor.constraint(lessThanOrEqualTo: overlay.trailingAnchor, constant: -34),
            card.widthAnchor.constraint(lessThanOrEqualToConstant: 360),

            badgeShell.topAnchor.constraint(equalTo: card.topAnchor, constant: 24),
            badgeShell.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            badgeShell.widthAnchor.constraint(equalToConstant: 54),
            badgeShell.heightAnchor.constraint(equalToConstant: 54),

            badge.centerXAnchor.constraint(equalTo: badgeShell.centerXAnchor),
            badge.centerYAnchor.constraint(equalTo: badgeShell.centerYAnchor),
            badge.widthAnchor.constraint(equalToConstant: 30),
            badge.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.topAnchor.constraint(equalTo: badgeShell.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 28),
            messageLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -28),

            button.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            button.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 30),
            button.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -30),
            button.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -24)
        ])

        card.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
        UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseOut]) {
            overlay.alpha = 1
            card.transform = .identity
        }
    }
}

final class SuliJoySimplePlaceholderViewController: SuliJoyBaseIslandViewController {
    private let pageTitle: String
    private let subtitle: String

    init(title: String, subtitle: String, hideTabBar: Bool = true) {
        self.pageTitle = title
        self.subtitle = subtitle
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = hideTabBar
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.tintColor = .suliInk
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = pageTitle
        title.font = UIFont.systemFont(ofSize: 28, weight: .black)
        title.textColor = .suliInk
        title.textAlignment = .center

        let body = UILabel()
        body.translatesAutoresizingMaskIntoConstraints = false
        body.text = subtitle
        body.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        body.textColor = .suliMutedInk
        body.numberOfLines = 0
        body.textAlignment = .center

        [back, title, body].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            back.widthAnchor.constraint(equalToConstant: 44),
            back.heightAnchor.constraint(equalToConstant: 44),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -32),
            body.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12),
            body.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            body.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36)
        ])
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
