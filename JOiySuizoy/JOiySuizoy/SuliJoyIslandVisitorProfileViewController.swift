import UIKit

private enum SuliJoyVisitorCoveTab: String, CaseIterable {
    case dynamic = "Dynamic"
    case shorts = "Short Video"
    case events = "Events"
}

final class SuliJoyIslandVisitorProfileViewController: SuliJoyBaseIslandViewController {
    private let visitorID: String
    private var visitor: SuliJoyLagoonVisitor?
    private var selectedTab: SuliJoyVisitorCoveTab = .shorts
    private var moments: [SuliJoyShoreMoment] = []
    private var clips: [SuliJoyShellClip] = []
    private var activities: [SuliJoyTideActivity] = []

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let moreButton = UIButton(type: .system)
    private let avatarView = UIImageView()
    private let followButton = SuliJoyVisitorFollowButton()
    private let metricStack = UIStackView()
    private let segmentContainer = UIView()
    private let segmentStack = UIStackView()
    private var segmentButtons: [SuliJoyVisitorCoveTab: SuliJoyVisitorSegmentButton] = [:]
    private let contentStack = UIStackView()
    private let emptyLabel = UILabel()
    private let bottomActionBar = UIStackView()
    private let messageButton = SuliJoyVisitorActionButton(title: "Message", systemName: "message.fill", purple: true)
    private let videoButton = SuliJoyVisitorActionButton(title: "Video", systemName: "video.fill", purple: false)
    private var scrollBottomConstraint: NSLayoutConstraint?

    init(visitorID: String) {
        self.visitorID = visitorID
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    convenience init(displayName: String) {
        self.init(visitorID: SuliJoyLagoonVisitor.visitorID(for: displayName))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        fetchVisitor()
    }

    private func buildUI() {
        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center

        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreButton.tintColor = .black
        moreButton.addTarget(self, action: #selector(showMore), for: .touchUpInside)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 72

        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.addTarget(self, action: #selector(toggleFollow), for: .touchUpInside)

        metricStack.translatesAutoresizingMaskIntoConstraints = false
        metricStack.axis = .horizontal
        metricStack.distribution = .fillEqually
        metricStack.alignment = .center

        segmentContainer.translatesAutoresizingMaskIntoConstraints = false
        segmentContainer.backgroundColor = .white
        segmentContainer.layer.cornerRadius = 20
        segmentContainer.clipsToBounds = true
        segmentStack.translatesAutoresizingMaskIntoConstraints = false
        segmentStack.axis = .horizontal
        segmentStack.distribution = .fillEqually
        segmentStack.spacing = 0
        segmentContainer.addSubview(segmentStack)
        for tab in SuliJoyVisitorCoveTab.allCases {
            let button = SuliJoyVisitorSegmentButton(title: tab.rawValue)
            button.addTarget(self, action: #selector(changeTab(_:)), for: .touchUpInside)
            button.tag = SuliJoyVisitorCoveTab.allCases.firstIndex(of: tab) ?? 0
            segmentButtons[tab] = button
            segmentStack.addArrangedSubview(button)
        }

        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.alignment = .fill

        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        emptyLabel.textColor = .suliMutedInk
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0

        bottomActionBar.translatesAutoresizingMaskIntoConstraints = false
        bottomActionBar.axis = .horizontal
        bottomActionBar.spacing = 16
        bottomActionBar.distribution = .fillEqually
        bottomActionBar.isHidden = true
        messageButton.addTarget(self, action: #selector(openMessage), for: .touchUpInside)
        videoButton.addTarget(self, action: #selector(openVideo), for: .touchUpInside)
        bottomActionBar.addArrangedSubview(messageButton)
        bottomActionBar.addArrangedSubview(videoButton)

        [backButton, titleLabel, moreButton, scrollView, bottomActionBar].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        [avatarView, followButton, metricStack, segmentContainer, contentStack].forEach { stackView.addArrangedSubview($0) }
        contentStack.addArrangedSubview(emptyLabel)

        scrollBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        scrollBottomConstraint?.isActive = true

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalToConstant: 36),
            backButton.heightAnchor.constraint(equalToConstant: 36),

            moreButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            moreButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 36),
            moreButton.heightAnchor.constraint(equalToConstant: 36),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: moreButton.leadingAnchor, constant: -16),

            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28),

            avatarView.widthAnchor.constraint(equalToConstant: 144),
            avatarView.heightAnchor.constraint(equalToConstant: 144),
            followButton.widthAnchor.constraint(equalToConstant: 60),
            followButton.heightAnchor.constraint(equalToConstant: 24),
            metricStack.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 18),
            metricStack.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -18),
            metricStack.heightAnchor.constraint(equalToConstant: 52),
            segmentContainer.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 6),
            segmentContainer.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -6),
            segmentContainer.heightAnchor.constraint(equalToConstant: 40),
            segmentStack.topAnchor.constraint(equalTo: segmentContainer.topAnchor, constant: 3),
            segmentStack.leadingAnchor.constraint(equalTo: segmentContainer.leadingAnchor, constant: 3),
            segmentStack.trailingAnchor.constraint(equalTo: segmentContainer.trailingAnchor, constant: -3),
            segmentStack.bottomAnchor.constraint(equalTo: segmentContainer.bottomAnchor, constant: -3),
            contentStack.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),

            bottomActionBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            bottomActionBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            bottomActionBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -14),
            bottomActionBar.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func fetchVisitor() {
        SuliJoyCoveMockService.shared.fetchLagoonVisitorProfile(visitorID: visitorID) { [weak self] result in
            guard let self else { return }
            guard let visitor = result.data else {
                self.showToast(result.message)
                return
            }
            self.visitor = visitor
            self.renderHeader()
            self.fetchContent()
        }
    }

    private func fetchContent() {
        switch selectedTab {
        case .dynamic:
            SuliJoyCoveMockService.shared.fetchVisitorShoreMoments(visitorID: visitorID) { [weak self] result in
                self?.moments = result.data ?? []
                self?.renderContent()
            }
        case .shorts:
            SuliJoyCoveMockService.shared.fetchVisitorShellClips(visitorID: visitorID) { [weak self] result in
                self?.clips = result.data ?? []
                self?.renderContent()
            }
        case .events:
            SuliJoyCoveMockService.shared.fetchVisitorTideActivities(visitorID: visitorID) { [weak self] result in
                self?.activities = result.data ?? []
                self?.renderContent()
            }
        }
    }

    private func renderHeader() {
        guard let visitor else { return }
        titleLabel.text = visitor.displayName
        avatarView.image = UIImage.suliJoyAssetOrLocal(named: visitor.avatarAssetName)
        followButton.render(state: visitor.followState)
        renderMetrics(visitor)
        bottomActionBar.isHidden = visitor.followState == .notFollowing
        scrollBottomConstraint?.constant = bottomActionBar.isHidden ? 0 : -74
        updateSegments()
    }

    private func renderMetrics(_ visitor: SuliJoyLagoonVisitor) {
        metricStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let metrics = [
            ("Likes", visitor.likeCount),
            ("Followers", visitor.followerCount),
            ("Following", visitor.followingCount)
        ]
        for (index, metric) in metrics.enumerated() {
            let item = SuliJoyVisitorMetricView(title: metric.0, value: metric.1)
            metricStack.addArrangedSubview(item)
            if index < metrics.count - 1 {
                item.layer.borderColor = UIColor.black.withAlphaComponent(0.10).cgColor
                item.layer.borderWidth = 0
            }
        }
    }

    private func renderContent() {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        switch selectedTab {
        case .dynamic:
            if moments.isEmpty {
                showEmpty("No dynamic moments from this stylist.")
            } else {
                for moment in moments {
                    let card = SuliJoyVisitorMomentPreviewCard(moment: moment)
                    card.onTap = { [weak self] in self?.openMoment(moment) }
                    contentStack.addArrangedSubview(card)
                }
            }
        case .shorts:
            if clips.isEmpty {
                showEmpty("No short videos from this stylist.")
            } else {
                for clip in clips {
                    let card = SuliJoyVisitorClipPreviewCard(clip: clip)
                    card.onTap = { [weak self] in self?.openClip(clip) }
                    contentStack.addArrangedSubview(card)
                }
            }
        case .events:
            if activities.isEmpty {
                showEmpty("No events from this stylist yet.")
            } else {
                for activity in activities {
                    let card = SuliJoyVisitorActivityPreviewCard(activity: activity)
                    card.onTap = { [weak self] in self?.openActivity(activity) }
                    contentStack.addArrangedSubview(card)
                }
            }
        }
    }

    private func showEmpty(_ text: String) {
        emptyLabel.text = text
        contentStack.addArrangedSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
    }

    private func updateSegments() {
        for (tab, button) in segmentButtons {
            button.isVisitorSelected = tab == selectedTab
        }
    }

    @objc private func changeTab(_ sender: UIButton) {
        selectedTab = SuliJoyVisitorCoveTab.allCases[sender.tag]
        updateSegments()
        fetchContent()
    }

    @objc private func toggleFollow() {
        guard let visitor else { return }
        if visitor.followState == .notFollowing {
            SuliJoyCoveMockService.shared.toggleLagoonVisitorFollow(visitorID: visitorID) { [weak self] result in
                guard let self else { return }
                if let updated = result.data {
                    self.visitor = updated
                    self.renderHeader()
                    NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: updated)
                }
                self.showToast(result.message)
            }
        } else {
            let sheet = UIAlertController(title: visitor.displayName, message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "Unfollow", style: .destructive) { [weak self] _ in
                self?.unfollowVisitor()
            })
            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(sheet, animated: true)
        }
    }

    private func unfollowVisitor() {
        SuliJoyCoveMockService.shared.toggleLagoonVisitorFollow(visitorID: visitorID) { [weak self] result in
            guard let self else { return }
            if let updated = result.data {
                self.visitor = updated
                self.renderHeader()
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: updated)
            }
            self.showToast(result.message)
        }
    }

    @objc private func showMore() {
        presentSuliJoyModerationMenu { [weak self] in
            guard let self else { return }
            self.presentSuliJoyReportSheet(target: .lagoonVisitor(visitorID: self.visitorID))
        } block: { [weak self] in
            self?.blockVisitor()
        }
    }

    private func blockVisitor() {
        SuliJoyCoveMockService.shared.blockLagoonVisitor(visitorID: visitorID) { [weak self] result in
            guard let self else { return }
            self.showToast(result.message)
            NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: self.visitor)
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc private func openMessage() {
        guard visitor?.followState == .mutualFollowing else {
            showUnlockNotice()
            return
        }
        openSuliJoyMessages()
    }

    @objc private func openVideo() {
        guard visitor?.followState == .mutualFollowing else {
            showUnlockNotice()
            return
        }
        showLocalPlaceholder(title: "Video Call Preview", subtitle: "Mutual-follow video call preview.")
    }

    private func showUnlockNotice() {
        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        overlay.alpha = 0

        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 24
        card.clipsToBounds = false

        let badge = UIImageView(image: UIImage(named: "sulijoy_visitor_unlock_notice_badge"))
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.contentMode = .scaleAspectFit

        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Chat and video will unlock once\nthey follow you back."
        text.textColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1)
        text.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        text.numberOfLines = 0
        text.textAlignment = .center

        let ok = SuliJoyGradientButton(title: "OK")
        ok.translatesAutoresizingMaskIntoConstraints = false
        ok.addTarget(self, action: #selector(dismissUnlockNotice(_:)), for: .touchUpInside)

        view.addSubview(overlay)
        overlay.addSubview(card)
        [badge, text, ok].forEach { card.addSubview($0) }
        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            card.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: overlay.centerYAnchor, constant: 34),
            card.leadingAnchor.constraint(greaterThanOrEqualTo: overlay.leadingAnchor, constant: 44),
            card.trailingAnchor.constraint(lessThanOrEqualTo: overlay.trailingAnchor, constant: -44),
            card.widthAnchor.constraint(lessThanOrEqualToConstant: 288),
            badge.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            badge.centerYAnchor.constraint(equalTo: card.topAnchor, constant: 10),
            badge.widthAnchor.constraint(equalToConstant: 118),
            badge.heightAnchor.constraint(equalToConstant: 82),
            text.topAnchor.constraint(equalTo: card.topAnchor, constant: 86),
            text.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            text.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            ok.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 24),
            ok.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 34),
            ok.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -34),
            ok.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -24)
        ])
        ok.accessibilityIdentifier = "sulijoy_unlock_notice_ok"
        UIView.animate(withDuration: 0.22) {
            overlay.alpha = 1
        }
    }

    @objc private func dismissUnlockNotice(_ sender: UIButton) {
        guard let overlay = sender.superview?.superview else { return }
        UIView.animate(withDuration: 0.18, animations: {
            overlay.alpha = 0
        }, completion: { _ in
            overlay.removeFromSuperview()
        })
    }

    private func openMoment(_ moment: SuliJoyShoreMoment) {
        navigationController?.pushViewController(SuliJoyMomentDetailViewController(moment: moment), animated: true)
    }

    private func openClip(_ clip: SuliJoyShellClip) {
        navigationController?.pushViewController(SuliJoyClipDetailViewController(clipID: clip.clipID), animated: true)
    }

    private func openActivity(_ activity: SuliJoyTideActivity) {
        navigationController?.pushViewController(SuliJoyActivityDetailViewController(tideID: activity.tideID), animated: true)
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

private final class SuliJoyVisitorFollowButton: UIButton {
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 0)
        layer.masksToBounds = true
        titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        setTitleColor(.white, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(state: SuliJoyCoveFollowState) {
        switch state {
        case .notFollowing:
            setTitle("+", for: .normal)
            gradientLayer.colors = [
                UIColor(red: 0.54, green: 0.45, blue: 1, alpha: 1).cgColor,
                UIColor(red: 1, green: 0.29, blue: 0.96, alpha: 1).cgColor
            ]
        case .followingPending, .mutualFollowing:
            setTitle("✓", for: .normal)
            gradientLayer.colors = [
                UIColor(red: 0.91, green: 0.68, blue: 0.48, alpha: 1).cgColor,
                UIColor(red: 0.97, green: 0.76, blue: 0.56, alpha: 1).cgColor
            ]
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.cornerRadius = bounds.height / 2
    }
}

private final class SuliJoyVisitorSegmentButton: UIButton {
    private let gradientLayer = CAGradientLayer()

    var isVisitorSelected = false {
        didSet { updateState() }
    }

    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        layer.insertSublayer(gradientLayer, at: 0)
        layer.masksToBounds = true
        updateState()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateState() {
        gradientLayer.isHidden = !isVisitorSelected
        alpha = isVisitorSelected ? 1 : 0.82
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = bounds.height / 2
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [
            UIColor(red: 1, green: 0.64, blue: 0.36, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.96, blue: 0.33, alpha: 1).cgColor,
            UIColor(red: 0.70, green: 1, blue: 0.71, alpha: 1).cgColor
        ]
    }
}

private final class SuliJoyVisitorMetricView: UIView {
    init(title: String, value: Int) {
        super.init(frame: .zero)
        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.text = "\(value)"
        valueLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        valueLabel.textColor = .black
        valueLabel.textAlignment = .center

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center

        [valueLabel, titleLabel].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor),
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class SuliJoyVisitorActionButton: UIButton {
    private let gradientLayer = CAGradientLayer()

    init(title: String, systemName: String, purple: Bool) {
        super.init(frame: .zero)
        layer.insertSublayer(gradientLayer, at: 0)
        layer.masksToBounds = true
        setTitle("  \(title)", for: .normal)
        setTitleColor(purple ? UIColor(red: 0.80, green: 0.20, blue: 0.94, alpha: 1) : .suliInk, for: .normal)
        setImage(UIImage(systemName: systemName), for: .normal)
        tintColor = purple ? UIColor(red: 0.80, green: 0.20, blue: 0.94, alpha: 1) : .suliInk
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
        gradientLayer.colors = purple ? [
            UIColor(red: 0.94, green: 0.80, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.98, green: 0.88, blue: 1, alpha: 1).cgColor
        ] : [
            UIColor(red: 1, green: 0.64, blue: 0.36, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.96, blue: 0.33, alpha: 1).cgColor,
            UIColor(red: 0.70, green: 1, blue: 0.71, alpha: 1).cgColor
        ]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.cornerRadius = bounds.height / 2
    }
}

private class SuliJoyVisitorPreviewControl: UIControl {
    var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 20
        clipsToBounds = true
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func tapped() { onTap?() }
}

private final class SuliJoyVisitorMomentPreviewCard: SuliJoyVisitorPreviewControl {
    init(moment: SuliJoyShoreMoment) {
        super.init(frame: .zero)
        let avatar = UIImageView(image: UIImage.suliJoyAssetOrLocal(named: moment.authorAvatarAssetName))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 18

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = moment.authorName
        title.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        title.textColor = .suliInk

        let time = UILabel()
        time.translatesAutoresizingMaskIntoConstraints = false
        time.text = moment.timeAgo
        time.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        time.textColor = .suliMutedInk

        let body = UILabel()
        body.translatesAutoresizingMaskIntoConstraints = false
        body.text = moment.body
        body.numberOfLines = 2
        body.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        body.textColor = .suliInk

        let image = UIImageView(image: UIImage.suliJoyAssetOrLocal(named: moment.media.first?.assetName ?? "sulijoy_feed_moment_coast_01"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 14

        [avatar, title, time, image, body].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatar.widthAnchor.constraint(equalToConstant: 36),
            avatar.heightAnchor.constraint(equalToConstant: 36),
            title.topAnchor.constraint(equalTo: avatar.topAnchor),
            title.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            time.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2),
            time.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            image.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 14),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 0.56),
            body.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 12),
            body.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            body.trailingAnchor.constraint(equalTo: image.trailingAnchor),
            body.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class SuliJoyVisitorClipPreviewCard: SuliJoyVisitorPreviewControl {
    init(clip: SuliJoyShellClip) {
        super.init(frame: .zero)
        let image = UIImageView(image: UIImage.suliJoyAssetOrLocal(named: clip.media.fallbackCoverAssetName ?? "sulijoy_feed_moment_coast_01"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 20

        let report = UIImageView(image: UIImage(systemName: "exclamationmark.circle"))
        report.translatesAutoresizingMaskIntoConstraints = false
        report.tintColor = .white

        let caption = UILabel()
        caption.translatesAutoresizingMaskIntoConstraints = false
        caption.text = clip.caption
        caption.numberOfLines = 2
        caption.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        caption.textColor = .suliInk

        [image, report, caption].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1.22),
            report.topAnchor.constraint(equalTo: image.topAnchor, constant: 14),
            report.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -14),
            report.widthAnchor.constraint(equalToConstant: 28),
            report.heightAnchor.constraint(equalToConstant: 28),
            caption.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            caption.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            caption.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            caption.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class SuliJoyVisitorActivityPreviewCard: SuliJoyVisitorPreviewControl {
    init(activity: SuliJoyTideActivity) {
        super.init(frame: .zero)
        let image = UIImageView(image: UIImage.suliJoyAssetOrLocal(named: activity.media.first?.assetName ?? activity.detailHeroAssetName))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 16

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = activity.title
        title.font = UIFont.systemFont(ofSize: 16, weight: .black)
        title.textColor = .suliInk
        title.numberOfLines = 1

        let meta = UILabel()
        meta.translatesAutoresizingMaskIntoConstraints = false
        meta.text = "\(activity.location)\n\(activity.shoreScheduleText)"
        meta.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        meta.textColor = .suliMutedInk
        meta.numberOfLines = 2

        [image, title, meta].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            image.widthAnchor.constraint(equalToConstant: 108),
            image.heightAnchor.constraint(equalToConstant: 88),
            title.topAnchor.constraint(equalTo: image.topAnchor, constant: 4),
            title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            meta.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            meta.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            meta.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            meta.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12),
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
