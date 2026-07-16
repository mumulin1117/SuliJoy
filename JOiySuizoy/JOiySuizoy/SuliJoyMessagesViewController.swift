import UIKit

final class SuliJoyMessagesViewController: SuliJoyBaseIslandViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let emptyCard = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    private func buildUI() {
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .suliInk
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Messages"
        titleLabel.textColor = .suliInk
        titleLabel.font = UIFont.systemFont(ofSize: 29, weight: .black)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.78

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false

        contentView.translatesAutoresizingMaskIntoConstraints = false

        emptyCard.translatesAutoresizingMaskIntoConstraints = false
        emptyCard.backgroundColor = UIColor.white.withAlphaComponent(0.58)
        emptyCard.layer.cornerRadius = 28
        emptyCard.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        emptyCard.layer.shadowOpacity = 1
        emptyCard.layer.shadowRadius = 16
        emptyCard.layer.shadowOffset = CGSize(width: 0, height: 8)

        let mark = UIView()
        mark.translatesAutoresizingMaskIntoConstraints = false
        mark.backgroundColor = UIColor.white.withAlphaComponent(0.86)
        mark.layer.cornerRadius = 34

        let markIcon = UILabel()
        markIcon.translatesAutoresizingMaskIntoConstraints = false
        markIcon.text = "✉"
        markIcon.textAlignment = .center
        markIcon.font = UIFont.systemFont(ofSize: 32, weight: .black)
        markIcon.textColor = UIColor(red: 0.23, green: 0.16, blue: 0.04, alpha: 1)

        let headline = UILabel()
        headline.translatesAutoresizingMaskIntoConstraints = false
        headline.text = "No friend message notifications yet."
        headline.textColor = .suliInk
        headline.font = UIFont.systemFont(ofSize: 20, weight: .black)
        headline.textAlignment = .center
        headline.numberOfLines = 0

        let body = UILabel()
        body.translatesAutoresizingMaskIntoConstraints = false
        body.text = "Mutual-follow chats and island style updates will appear here."
        body.textColor = .suliMutedInk
        body.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        body.textAlignment = .center
        body.numberOfLines = 0

        mark.addSubview(markIcon)
        emptyCard.addSubview(mark)
        emptyCard.addSubview(headline)
        emptyCard.addSubview(body)

        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(emptyCard)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -68),

            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 22),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),

            emptyCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emptyCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            emptyCard.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -36),
            emptyCard.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 36),
            emptyCard.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -36),

            mark.topAnchor.constraint(equalTo: emptyCard.topAnchor, constant: 32),
            mark.centerXAnchor.constraint(equalTo: emptyCard.centerXAnchor),
            mark.widthAnchor.constraint(equalToConstant: 68),
            mark.heightAnchor.constraint(equalToConstant: 68),
            markIcon.centerXAnchor.constraint(equalTo: mark.centerXAnchor),
            markIcon.centerYAnchor.constraint(equalTo: mark.centerYAnchor),

            headline.topAnchor.constraint(equalTo: mark.bottomAnchor, constant: 22),
            headline.leadingAnchor.constraint(equalTo: emptyCard.leadingAnchor, constant: 24),
            headline.trailingAnchor.constraint(equalTo: emptyCard.trailingAnchor, constant: -24),

            body.topAnchor.constraint(equalTo: headline.bottomAnchor, constant: 10),
            body.leadingAnchor.constraint(equalTo: emptyCard.leadingAnchor, constant: 28),
            body.trailingAnchor.constraint(equalTo: emptyCard.trailingAnchor, constant: -28),
            body.bottomAnchor.constraint(equalTo: emptyCard.bottomAnchor, constant: -32)
        ])
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
