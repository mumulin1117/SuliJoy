import UIKit

final class SuliJoySettingViewController: SuliJoyBaseIslandViewController {
    private let service = SuliJoyCoveMockService.shared
    private let authService = SuliJoyLocalAuthService.shared
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let logoutButton = SuliJoyGradientButton(title: "Log out")
    private var overlayView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        buildUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    private func buildUI() {
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .suliInk
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Setting"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .suliInk
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .black)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false

        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 0
        contentStack.layer.cornerRadius = 16
        contentStack.clipsToBounds = true
        contentStack.backgroundColor = UIColor.white.withAlphaComponent(0.36)

        let rows: [(String, String, Selector)] = [
            ("User Agreement", "doc.text.fill", #selector(openTerms)),
            ("Privacy", "lock.doc.fill", #selector(openPrivacy)),
            ("Clear the cache", "sparkles", #selector(clearCache)),
            ("Blocked List", "person.crop.circle.badge.xmark", #selector(openBlockedList)),
            ("Delete Account", "person.crop.circle.badge.minus", #selector(confirmDeleteAccount))
        ]
        rows.enumerated().forEach { index, row in
            let item = SuliJoySettingRow(title: row.0, symbolName: row.1)
            item.addTarget(self, action: row.2, for: .touchUpInside)
            contentStack.addArrangedSubview(item)
            if index < rows.count - 1 {
                contentStack.addArrangedSubview(SuliJoySettingSeparator())
            }
        }

        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        logoutButton.tintColor = .suliInk
        logoutButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        logoutButton.addTarget(self, action: #selector(confirmLogout), for: .touchUpInside)

        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        view.addSubview(logoutButton)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),

            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 12),

            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),

            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 22),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -24),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -24),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 280)
        ])
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func openTerms() {
        navigationController?.pushViewController(SuliJoyPolicyViewController(titleText: "Terms of Service", sections: SuliJoyPolicyCopy.terms), animated: true)
    }

    @objc private func openPrivacy() {
        navigationController?.pushViewController(SuliJoyPolicyViewController(titleText: "Privacy Policy", sections: SuliJoyPolicyCopy.privacy), animated: true)
    }

    @objc private func clearCache() {
        service.clearSuliJoyLocalCache { [weak self] result in
            self?.showToast(result.message)
        }
    }

    @objc private func openBlockedList() {
        navigationController?.pushViewController(SuliJoyBlockedListViewController(), animated: true)
    }

    @objc private func confirmDeleteAccount() {
        let overlay = makeOverlay()
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 18
        card.clipsToBounds = true

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Delete account"
        title.textAlignment = .center
        title.textColor = .suliInk
        title.font = UIFont.systemFont(ofSize: 17, weight: .black)

        let message = UILabel()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.text = "Deleting the account will clear the account data. Are you sure to delete?"
        message.textAlignment = .center
        message.textColor = .suliMutedInk
        message.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        message.numberOfLines = 0

        let cancel = SuliJoyGradientButton(title: "Cancel")
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(self, action: #selector(dismissOverlay), for: .touchUpInside)

        let delete = UIButton(type: .system)
        delete.translatesAutoresizingMaskIntoConstraints = false
        delete.setTitle("Delete", for: .normal)
        delete.setTitleColor(UIColor.suliMutedInk.withAlphaComponent(0.68), for: .normal)
        delete.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .black)
        delete.backgroundColor = UIColor(white: 0.94, alpha: 1)
        delete.layer.cornerRadius = 23
        delete.addTarget(self, action: #selector(deleteAccountNow), for: .touchUpInside)

        [title, message, cancel, delete].forEach { card.addSubview($0) }
        overlay.addSubview(card)
        view.addSubview(overlay)
        pinOverlay(overlay)
        overlayView = overlay

        NSLayoutConstraint.activate([
            card.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
            card.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 42),
            card.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: -42),

            title.topAnchor.constraint(equalTo: card.topAnchor, constant: 22),
            title.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 18),
            title.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18),

            message.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            message.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 28),
            message.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -28),

            cancel.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 18),
            cancel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            cancel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),

            delete.topAnchor.constraint(equalTo: cancel.bottomAnchor, constant: 12),
            delete.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            delete.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            delete.heightAnchor.constraint(equalToConstant: 46),
            delete.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -18)
        ])
    }

    @objc private func confirmLogout() {
        let overlay = makeOverlay()
        let sheet = UIView()
        sheet.translatesAutoresizingMaskIntoConstraints = false
        sheet.backgroundColor = .clear

        let logout = UIButton(type: .system)
        logout.translatesAutoresizingMaskIntoConstraints = false
        logout.setTitle("Log out", for: .normal)
        logout.setTitleColor(.suliMutedInk, for: .normal)
        logout.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        logout.backgroundColor = .white
        logout.layer.cornerRadius = 24
        logout.addTarget(self, action: #selector(logoutNow), for: .touchUpInside)

        let cancel = SuliJoyGradientButton(title: "Cancel")
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.addTarget(self, action: #selector(dismissOverlay), for: .touchUpInside)

        sheet.addSubview(logout)
        sheet.addSubview(cancel)
        overlay.addSubview(sheet)
        view.addSubview(overlay)
        pinOverlay(overlay)
        overlayView = overlay

        NSLayoutConstraint.activate([
            sheet.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 30),
            sheet.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: -30),
            sheet.bottomAnchor.constraint(equalTo: overlay.safeAreaLayoutGuide.bottomAnchor, constant: -22),

            logout.topAnchor.constraint(equalTo: sheet.topAnchor),
            logout.leadingAnchor.constraint(equalTo: sheet.leadingAnchor),
            logout.trailingAnchor.constraint(equalTo: sheet.trailingAnchor),
            logout.heightAnchor.constraint(equalToConstant: 48),

            cancel.topAnchor.constraint(equalTo: logout.bottomAnchor, constant: 12),
            cancel.leadingAnchor.constraint(equalTo: sheet.leadingAnchor),
            cancel.trailingAnchor.constraint(equalTo: sheet.trailingAnchor),
            cancel.heightAnchor.constraint(equalToConstant: 50),
            cancel.bottomAnchor.constraint(equalTo: sheet.bottomAnchor)
        ])
    }

    private func makeOverlay() -> UIView {
        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.46)
        overlay.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissOverlay))
        tap.cancelsTouchesInView = false
        overlay.addGestureRecognizer(tap)
        UIView.animate(withDuration: 0.18) {
            overlay.alpha = 1
        }
        return overlay
    }

    private func pinOverlay(_ overlay: UIView) {
        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func dismissOverlay() {
        overlayView?.removeFromSuperview()
        overlayView = nil
    }

    @objc private func logoutNow() {
        authService.logoutLagoonSession()
        dismissOverlay()
        returnToWelcome()
    }

    @objc private func deleteAccountNow() {
        _ = authService.deleteCurrentIslandAccount()
        dismissOverlay()
        returnToWelcome()
    }

    private func returnToWelcome() {
        let welcome = UINavigationController(rootViewController: SuliJoyWelcomeViewController())
        welcome.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController = welcome
    }
}

private final class SuliJoySettingRow: UIButton {
    private let iconView = UIImageView()
    private let titleTextLabel = UILabel()
    private let arrowView = UIImageView(image: UIImage(systemName: "chevron.right"))

    init(title: String, symbolName: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.white.withAlphaComponent(0.08)

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = UIImage(systemName: symbolName)
        iconView.tintColor = .suliInk
        iconView.contentMode = .scaleAspectFit

        titleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextLabel.text = title
        titleTextLabel.textColor = .suliInk
        titleTextLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

        arrowView.translatesAutoresizingMaskIntoConstraints = false
        arrowView.tintColor = .suliInk
        arrowView.contentMode = .scaleAspectFit

        [iconView, titleTextLabel, arrowView].forEach {
            $0.isUserInteractionEnabled = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 54),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 21),
            iconView.heightAnchor.constraint(equalToConstant: 21),

            titleTextLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: arrowView.leadingAnchor, constant: -10),

            arrowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowView.widthAnchor.constraint(equalToConstant: 14),
            arrowView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.58 : 1
        }
    }
}

private final class SuliJoySettingSeparator: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.suliMutedInk.withAlphaComponent(0.12)
        heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class SuliJoyBlockedListViewController: SuliJoyBaseIslandViewController {
    private let service = SuliJoyCoveMockService.shared
    private let stackView = UIStackView()
    private let emptyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        buildUI()
        loadBlockedVisitors()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    private func buildUI() {
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = .suliInk
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Blocked List"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .suliInk
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .black)

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12

        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "No blocked island stylists yet."
        emptyLabel.textColor = .suliMutedInk
        emptyLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0

        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),

            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),

            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 22),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }

    private func loadBlockedVisitors() {
        service.fetchBlockedLagoonVisitors { [weak self] result in
            guard let self else { return }
            let visitors = result.data ?? []
            self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            self.emptyLabel.isHidden = !visitors.isEmpty
            visitors.forEach { self.stackView.addArrangedSubview(self.row(for: $0)) }
        }
    }

    private func row(for visitor: SuliJoyLagoonVisitor) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.backgroundColor = UIColor.white.withAlphaComponent(0.66)
        row.layer.cornerRadius = 16
        row.clipsToBounds = true

        let avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.image = UIImage.suliJoyAssetOrLocal(named: visitor.avatarAssetName) ?? UIImage(named: "sulijoy_mock_avatar_breeze_01")
        avatar.contentMode = .scaleAspectFill
        avatar.layer.cornerRadius = 24
        avatar.clipsToBounds = true

        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = visitor.displayName
        name.textColor = .suliInk
        name.font = UIFont.systemFont(ofSize: 16, weight: .black)

        let status = UILabel()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.text = "Blocked"
        status.textColor = .suliMutedInk
        status.font = UIFont.systemFont(ofSize: 13, weight: .semibold)

        [avatar, name, status].forEach { row.addSubview($0) }
        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: 74),
            avatar.leadingAnchor.constraint(equalTo: row.leadingAnchor, constant: 14),
            avatar.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 48),
            avatar.heightAnchor.constraint(equalToConstant: 48),

            name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 14),
            name.trailingAnchor.constraint(equalTo: row.trailingAnchor, constant: -16),
            name.topAnchor.constraint(equalTo: row.topAnchor, constant: 16),

            status.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            status.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            status.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 4)
        ])
        return row
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
