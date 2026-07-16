import UIKit

final class SuliJoyPublishEntryViewController: SuliJoyBaseIslandViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        configureLayout()
    }

    private func configureLayout() {
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .suliInk
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Publish"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .black)
        titleLabel.textColor = .suliInk
        titleLabel.textAlignment = .center

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        contentView.addSubview(stackView)

        [backButton, titleLabel].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -74),

            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -24)
        ])

        let moment = SuliJoyPublishEntryCard(
            symbolName: "photo.on.rectangle.angled",
            title: "Post Moment",
            subtitle: "Share outfit photos and voice notes.",
            style: .soft
        )
        moment.addTarget(self, action: #selector(openMoment), for: .touchUpInside)

        let event = SuliJoyPublishEntryCard(
            symbolName: "calendar.badge.plus",
            title: "Create Event",
            subtitle: "Host a coastal style meetup.",
            style: .gradient
        )
        event.addTarget(self, action: #selector(openEvent), for: .touchUpInside)

        let clip = SuliJoyPublishEntryCard(
            symbolName: "video.fill",
            title: "Post Clip",
            subtitle: "Upload a short island style video.",
            style: .soft
        )
        clip.addTarget(self, action: #selector(openClip), for: .touchUpInside)

        [moment, event, clip].forEach { stackView.addArrangedSubview($0) }
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func openMoment() {
        navigationController?.pushViewController(SuliJoyPostMomentViewController(), animated: true)
    }

    @objc private func openEvent() {
        navigationController?.pushViewController(SuliJoyCreateEventViewController(), animated: true)
    }

    @objc private func openClip() {
        navigationController?.pushViewController(SuliJoyPostClipViewController(), animated: true)
    }
}

private final class SuliJoyPublishEntryCard: UIControl {
    enum CardStyle {
        case soft
        case gradient
    }

    private let gradientLayer = CAGradientLayer()
    private let iconCircle = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let arrowView = UIImageView(image: UIImage(systemName: "chevron.right"))
    private let cardStyle: CardStyle

    init(symbolName: String, title: String, subtitle: String, style: CardStyle) {
        self.cardStyle = style
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 28
        layer.masksToBounds = true
        backgroundColor = .white.withAlphaComponent(style == .soft ? 0.86 : 1)
        if style == .gradient {
            gradientLayer.colors = [
                UIColor(red: 1, green: 0.58, blue: 0.35, alpha: 1).cgColor,
                UIColor(red: 1, green: 0.91, blue: 0.36, alpha: 1).cgColor,
                UIColor(red: 0.71, green: 1, blue: 0.70, alpha: 1).cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            layer.insertSublayer(gradientLayer, at: 0)
        }

        iconCircle.translatesAutoresizingMaskIntoConstraints = false
        iconCircle.backgroundColor = style == .gradient ? .white.withAlphaComponent(0.92) : UIColor(red: 0.78, green: 0.31, blue: 1, alpha: 0.16)
        iconCircle.layer.cornerRadius = 26
        iconCircle.isUserInteractionEnabled = false

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = UIImage(systemName: symbolName)
        iconView.tintColor = style == .gradient ? .suliInk : UIColor(red: 0.70, green: 0.20, blue: 0.95, alpha: 1)
        iconView.contentMode = .scaleAspectFit
        iconView.isUserInteractionEnabled = false

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .black)
        titleLabel.textColor = .suliInk
        titleLabel.isUserInteractionEnabled = false

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textColor = .suliMutedInk
        subtitleLabel.numberOfLines = 2
        subtitleLabel.isUserInteractionEnabled = false

        arrowView.translatesAutoresizingMaskIntoConstraints = false
        arrowView.tintColor = .suliInk.withAlphaComponent(0.5)
        arrowView.contentMode = .scaleAspectFit
        arrowView.isUserInteractionEnabled = false

        addSubview(iconCircle)
        iconCircle.addSubview(iconView)
        [titleLabel, subtitleLabel, arrowView].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 118),

            iconCircle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            iconCircle.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconCircle.widthAnchor.constraint(equalToConstant: 52),
            iconCircle.heightAnchor.constraint(equalToConstant: 52),

            iconView.centerXAnchor.constraint(equalTo: iconCircle.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconCircle.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 26),
            iconView.heightAnchor.constraint(equalToConstant: 26),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: iconCircle.trailingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: -10),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -22),

            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            arrowView.widthAnchor.constraint(equalToConstant: 18),
            arrowView.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.16) {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
                self.alpha = self.isHighlighted ? 0.82 : 1
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
