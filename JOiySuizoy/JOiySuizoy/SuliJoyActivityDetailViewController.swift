import UIKit

final class SuliJoyActivityDetailViewController: SuliJoyBaseIslandViewController, UIScrollViewDelegate {
    private let tideID: String
    private var activity: SuliJoyTideActivity?
    private var relatedActivities: [SuliJoyTideActivity] = []

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let heroCarouselView = UIScrollView()
    private let heroCarouselContent = UIStackView()
    private let heroPageControl = UIPageControl()
    private let infoCard = UIView()
    private let titleLabel = UILabel()
    private let statusLabel = UILabel()
    private let locationLabel = UILabel()
    private let scheduleLabel = UILabel()
    private let avatarStack = UIStackView()
    private let countLabel = UILabel()
    private let descriptionCard = UIView()
    private let descriptionLabel = UILabel()
    private let relatedCard = UIView()
    private let relatedGrid = UIStackView()
    private let bottomBar = UIView()
    private let ctaButton = SuliJoyGradientButton(title: "Join Event")
    private let reportButton = UIButton(type: .system)
    private let loading = UIActivityIndicatorView(style: .large)

    init(tideID: String) {
        self.tideID = tideID
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInsetAdjustmentBehavior = .never
        buildUI()
        loadActivity()
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

    private func buildUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        heroCarouselView.translatesAutoresizingMaskIntoConstraints = false
        heroCarouselView.isPagingEnabled = true
        heroCarouselView.showsHorizontalScrollIndicator = false
        heroCarouselView.bounces = true
        heroCarouselView.delegate = self
        heroCarouselView.backgroundColor = UIColor(red: 1, green: 0.84, blue: 0.58, alpha: 1)

        heroCarouselContent.translatesAutoresizingMaskIntoConstraints = false
        heroCarouselContent.axis = .horizontal
        heroCarouselContent.spacing = 0
        heroCarouselContent.distribution = .fillEqually

        heroPageControl.translatesAutoresizingMaskIntoConstraints = false
        heroPageControl.currentPageIndicatorTintColor = .white
        heroPageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.48)
        heroPageControl.hidesForSinglePage = true

        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.backgroundColor = UIColor.white.withAlphaComponent(0.42)
        backButton.layer.cornerRadius = 18
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        reportButton.translatesAutoresizingMaskIntoConstraints = false
        reportButton.setImage(UIImage(systemName: "flag.fill"), for: .normal)
        reportButton.tintColor = UIColor(red: 1, green: 0.42, blue: 0.18, alpha: 1)
        reportButton.backgroundColor = UIColor.white.withAlphaComponent(0.70)
        reportButton.layer.cornerRadius = 15
        reportButton.accessibilityLabel = "Report activity"
        reportButton.addTarget(self, action: #selector(reportCurrentActivity), for: .touchUpInside)

        configureCard(infoCard)
        configureCard(descriptionCard)
        configureCard(relatedCard)

        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .black)
        titleLabel.textColor = .suliInk
        titleLabel.numberOfLines = 2

        statusLabel.font = UIFont.italicSystemFont(ofSize: 14).suliWithWeight(.bold)
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 11
        statusLabel.clipsToBounds = true

        [locationLabel, scheduleLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            $0.textColor = .suliInk
            $0.numberOfLines = 1
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        avatarStack.axis = .horizontal
        avatarStack.spacing = -6
        countLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        countLabel.textColor = UIColor(red: 0.64, green: 0.64, blue: 0.64, alpha: 1)

        let infoBlock = UIView()
        infoBlock.translatesAutoresizingMaskIntoConstraints = false
        infoBlock.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        infoBlock.layer.cornerRadius = 8

        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)

        let peopleChevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        peopleChevron.translatesAutoresizingMaskIntoConstraints = false
        peopleChevron.tintColor = .suliInk
        peopleChevron.contentMode = .scaleAspectFit

        [titleLabel, statusLabel, infoBlock, avatarStack, countLabel, peopleChevron].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            infoCard.addSubview($0)
        }
        [locationLabel, separator, scheduleLabel].forEach { infoBlock.addSubview($0) }

        let descTitle = UILabel()
        descTitle.translatesAutoresizingMaskIntoConstraints = false
        descTitle.text = "Event Description"
        descTitle.font = UIFont.systemFont(ofSize: 17, weight: .black)
        descTitle.textColor = .suliInk
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.textColor = UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1)
        descriptionLabel.numberOfLines = 0
        [descTitle, descriptionLabel].forEach { descriptionCard.addSubview($0) }

        let relatedTitle = UILabel()
        relatedTitle.translatesAutoresizingMaskIntoConstraints = false
        relatedTitle.text = "Other activities"
        relatedTitle.font = UIFont.systemFont(ofSize: 17, weight: .black)
        relatedTitle.textColor = .suliInk
        relatedGrid.axis = .vertical
        relatedGrid.spacing = 12
        relatedGrid.translatesAutoresizingMaskIntoConstraints = false
        [relatedTitle, relatedGrid].forEach { relatedCard.addSubview($0) }

        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.backgroundColor = .white
        ctaButton.translatesAutoresizingMaskIntoConstraints = false
        ctaButton.titleLabel?.font = UIFont.italicSystemFont(ofSize: 20).suliWithWeight(.black)
        ctaButton.addTarget(self, action: #selector(primaryAction), for: .touchUpInside)
        bottomBar.addSubview(ctaButton)

        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.color = .suliInk
        loading.hidesWhenStopped = true

        view.addSubview(scrollView)
        view.addSubview(backButton)
        view.addSubview(reportButton)
        view.addSubview(bottomBar)
        view.addSubview(loading)
        scrollView.addSubview(contentView)
        heroCarouselView.addSubview(heroCarouselContent)
        [heroCarouselView, heroPageControl, infoCard, descriptionCard, relatedCard].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            heroCarouselView.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroCarouselView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroCarouselView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            heroCarouselView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.46),
            heroCarouselContent.topAnchor.constraint(equalTo: heroCarouselView.contentLayoutGuide.topAnchor),
            heroCarouselContent.leadingAnchor.constraint(equalTo: heroCarouselView.contentLayoutGuide.leadingAnchor),
            heroCarouselContent.trailingAnchor.constraint(equalTo: heroCarouselView.contentLayoutGuide.trailingAnchor),
            heroCarouselContent.bottomAnchor.constraint(equalTo: heroCarouselView.contentLayoutGuide.bottomAnchor),
            heroCarouselContent.heightAnchor.constraint(equalTo: heroCarouselView.frameLayoutGuide.heightAnchor),
            heroPageControl.centerXAnchor.constraint(equalTo: heroCarouselView.centerXAnchor),
            heroPageControl.bottomAnchor.constraint(equalTo: heroCarouselView.bottomAnchor, constant: -84),

            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            backButton.widthAnchor.constraint(equalToConstant: 36),
            backButton.heightAnchor.constraint(equalToConstant: 36),
            reportButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            reportButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            reportButton.widthAnchor.constraint(equalToConstant: 30),
            reportButton.heightAnchor.constraint(equalToConstant: 30),

            infoCard.topAnchor.constraint(equalTo: heroCarouselView.bottomAnchor, constant: -72),
            infoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            infoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            titleLabel.topAnchor.constraint(equalTo: infoCard.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor, constant: 22),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusLabel.leadingAnchor, constant: -12),
            statusLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor, constant: -14),
            statusLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 82),
            statusLabel.heightAnchor.constraint(equalToConstant: 32),
            infoBlock.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            infoBlock.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            infoBlock.trailingAnchor.constraint(equalTo: statusLabel.trailingAnchor),
            infoBlock.heightAnchor.constraint(equalToConstant: 88),
            locationLabel.topAnchor.constraint(equalTo: infoBlock.topAnchor, constant: 13),
            locationLabel.leadingAnchor.constraint(equalTo: infoBlock.leadingAnchor, constant: 14),
            locationLabel.trailingAnchor.constraint(equalTo: infoBlock.trailingAnchor, constant: -14),
            
            separator.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 12),
            separator.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor, constant: 22),
            separator.trailingAnchor.constraint(equalTo: infoBlock.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            scheduleLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 12),
            scheduleLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            scheduleLabel.trailingAnchor.constraint(equalTo: locationLabel.trailingAnchor),
            avatarStack.topAnchor.constraint(equalTo: infoBlock.bottomAnchor, constant: 16),
            avatarStack.leadingAnchor.constraint(equalTo: infoBlock.leadingAnchor, constant: 12),
            avatarStack.heightAnchor.constraint(equalToConstant: 24),
            countLabel.leadingAnchor.constraint(equalTo: avatarStack.trailingAnchor, constant: 8),
            countLabel.centerYAnchor.constraint(equalTo: avatarStack.centerYAnchor),
            peopleChevron.trailingAnchor.constraint(equalTo: infoBlock.trailingAnchor, constant: -6),
            peopleChevron.centerYAnchor.constraint(equalTo: avatarStack.centerYAnchor),
            peopleChevron.widthAnchor.constraint(equalToConstant: 20),
            peopleChevron.heightAnchor.constraint(equalToConstant: 20),
            infoCard.bottomAnchor.constraint(equalTo: avatarStack.bottomAnchor, constant: 20),

            descriptionCard.topAnchor.constraint(equalTo: infoCard.bottomAnchor, constant: 20),
            descriptionCard.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor),
            descriptionCard.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor),
            descTitle.topAnchor.constraint(equalTo: descriptionCard.topAnchor, constant: 20),
            descTitle.leadingAnchor.constraint(equalTo: descriptionCard.leadingAnchor, constant: 22),
            descTitle.trailingAnchor.constraint(equalTo: descriptionCard.trailingAnchor, constant: -22),
            descriptionLabel.topAnchor.constraint(equalTo: descTitle.bottomAnchor, constant: 14),
            descriptionLabel.leadingAnchor.constraint(equalTo: descTitle.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: descTitle.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionCard.bottomAnchor, constant: -22),

            relatedCard.topAnchor.constraint(equalTo: descriptionCard.bottomAnchor, constant: 22),
            relatedCard.leadingAnchor.constraint(equalTo: infoCard.leadingAnchor),
            relatedCard.trailingAnchor.constraint(equalTo: infoCard.trailingAnchor),
            relatedCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            relatedTitle.topAnchor.constraint(equalTo: relatedCard.topAnchor, constant: 22),
            relatedTitle.leadingAnchor.constraint(equalTo: relatedCard.leadingAnchor, constant: 22),
            relatedTitle.trailingAnchor.constraint(equalTo: relatedCard.trailingAnchor, constant: -22),
            relatedGrid.topAnchor.constraint(equalTo: relatedTitle.bottomAnchor, constant: 16),
            relatedGrid.leadingAnchor.constraint(equalTo: relatedTitle.leadingAnchor),
            relatedGrid.trailingAnchor.constraint(equalTo: relatedTitle.trailingAnchor),
            relatedGrid.bottomAnchor.constraint(equalTo: relatedCard.bottomAnchor, constant: -22),

            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ctaButton.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 12),
            ctaButton.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 30),
            ctaButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -30),
            ctaButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),

            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func configureCard(_ card: UIView) {
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 22
        card.layer.shadowColor = UIColor.black.withAlphaComponent(0.04).cgColor
        card.layer.shadowOpacity = 1
        card.layer.shadowRadius = 16
        card.layer.shadowOffset = CGSize(width: 0, height: 8)
    }

    private func loadActivity() {
        loading.startAnimating()
        SuliJoyCoveMockService.shared.fetchActivityDetail(tideID: tideID) { [weak self] detail in
            guard let self else { return }
            guard detail.code == 200, let activity = detail.data else {
                self.loading.stopAnimating()
                self.showToast(detail.message)
                return
            }
            self.activity = activity
            self.render(activity)
            SuliJoyCoveMockService.shared.fetchRelatedActivities(for: activity.tideID) { related in
                self.loading.stopAnimating()
                self.relatedActivities = related.data ?? []
                self.renderRelated()
            }
        }
    }

    private func render(_ activity: SuliJoyTideActivity) {
        renderHeroCarousel(for: activity)
        titleLabel.text = activity.title
        locationLabel.text = activity.location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "Island Shore · Coastline"
            : activity.location
        scheduleLabel.text = activity.shoreScheduleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "\(activity.dayText) \(activity.meridiem) \(activity.timeText)"
            : activity.shoreScheduleText
        descriptionLabel.text = activity.shoreBrief
        countLabel.text = "\(activity.joinedCount)/\(activity.capacity)"
        renderStatus(activity.status)
        renderAvatars(activity.avatarAssetNames)
        renderCTA(activity)
    }

    private func renderHeroCarousel(for activity: SuliJoyTideActivity) {
        heroCarouselContent.arrangedSubviews.forEach { view in
            heroCarouselContent.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        let mediaAssetNames = activity.media.map(\.assetName).filter { !$0.isEmpty }
        let assetNames = mediaAssetNames.isEmpty ? [activity.detailHeroAssetName] : mediaAssetNames

        for assetName in assetNames {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = UIColor(red: 1, green: 0.84, blue: 0.58, alpha: 1)
            imageView.image = UIImage.suliJoyAssetOrLocal(named: assetName) ?? UIImage.suliJoyAssetOrLocal(named: activity.detailHeroAssetName)
            heroCarouselContent.addArrangedSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalTo: heroCarouselView.frameLayoutGuide.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: heroCarouselView.frameLayoutGuide.heightAnchor)
            ])
        }

        heroPageControl.numberOfPages = assetNames.count
        heroPageControl.currentPage = 0
        heroPageControl.isHidden = assetNames.count <= 1
        heroCarouselView.setContentOffset(.zero, animated: false)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === heroCarouselView else { return }
        let width = scrollView.bounds.width
        guard width > 0 else { return }
        let page = Int(round(scrollView.contentOffset.x / width))
        heroPageControl.currentPage = max(0, min(heroPageControl.numberOfPages - 1, page))
    }

    private func renderStatus(_ status: SuliJoyTideActivityStatus) {
        statusLabel.text = status.rawValue
        switch status {
        case .open, .joined:
            statusLabel.backgroundColor = UIColor(red: 0.88, green: 1, blue: 0.91, alpha: 1)
            statusLabel.textColor = UIColor(red: 0.19, green: 0.82, blue: 0.61, alpha: 1)
        case .closed:
            statusLabel.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            statusLabel.textColor = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1)
        }
    }

    private func renderAvatars(_ assets: [String]) {
        avatarStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for asset in assets.prefix(3) {
            let imageView = UIImageView(image: UIImage(named: asset))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.borderWidth = 1
            avatarStack.addArrangedSubview(imageView)
            imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        }
    }

    private func renderCTA(_ activity: SuliJoyTideActivity) {
        switch activity.status {
        case .open:
            ctaButton.setTitle("Join Event (🔥 \(activity.gemCost))", for: .normal)
            ctaButton.isEnabled = true
            ctaButton.alpha = 1
        case .joined:
            ctaButton.setTitle("Open Event Room", for: .normal)
            ctaButton.isEnabled = true
            ctaButton.alpha = 1
        case .closed:
            ctaButton.setTitle("Open Event Room", for: .normal)
            ctaButton.isEnabled = false
            ctaButton.alpha = 0.45
        }
    }

    private func renderRelated() {
        relatedGrid.arrangedSubviews.forEach { $0.removeFromSuperview() }
        var index = 0
        while index < relatedActivities.count {
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 12
            row.distribution = .fillEqually
            row.translatesAutoresizingMaskIntoConstraints = false
            for activity in relatedActivities[index..<min(index + 2, relatedActivities.count)] {
                let card = SuliJoyRelatedActivityCard(activity: activity)
                card.onTap = { [weak self] tideID in
                    self?.switchActivity(to: tideID)
                }
                row.addArrangedSubview(card)
            }
            if row.arrangedSubviews.count == 1 {
                row.addArrangedSubview(UIView())
            }
            relatedGrid.addArrangedSubview(row)
            index += 2
        }
    }

    private func switchActivity(to newTideID: String) {
        let detail = SuliJoyActivityDetailViewController(tideID: newTideID)
        navigationController?.pushViewController(detail, animated: true)
    }

    @objc private func primaryAction() {
        guard let activity else { return }
        switch activity.status {
        case .open:
            ctaButton.isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                guard let self else { return }
                guard SuliJoyShellWalletStore.shared.currentBalance() >= activity.gemCost else {
                    self.ctaButton.isLoading = false
                    self.showNotEnoughCoinsDialog()
                    return
                }
                SuliJoyCoveMockService.shared.spendCoinsForActivity(tideID: activity.tideID, coinCost: activity.gemCost) { [weak self] wallet in
                    guard let self else { return }
                    guard wallet.code == 200 else {
                        self.ctaButton.isLoading = false
                        self.showNotEnoughCoinsDialog()
                        return
                    }
                    SuliJoyCoveMockService.shared.joinActivity(tideID: activity.tideID) { [weak self] result in
                        guard let self else { return }
                        self.ctaButton.isLoading = false
                        guard result.code == 200, let updated = result.data else {
                            self.showToast(result.message)
                            return
                        }
                        self.activity = updated
                        self.render(updated)
                        self.showToast("Joined.")
                    }
                }
            }
        case .joined:
            let room = SuliJoyTideTalkSpaceViewController(activity: activity)
            navigationController?.pushViewController(room, animated: true)
        case .closed:
            break
        }
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func reportCurrentActivity() {
        guard let activity else { return }
        presentSuliJoyModerationMenu { [weak self] in
            self?.presentSuliJoyReportSheet(target: .tideActivity(tideID: activity.tideID)) { [weak self] in
                self?.activity?.isReportedLocally = true
            }
        } block: { [weak self] in
            let visitorID = SuliJoyLagoonVisitor.visitorID(for: activity.shoreHostName)
            SuliJoyCoveMockService.shared.blockLagoonVisitor(visitorID: visitorID) { result in
                self?.showToast(result.message)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func showNotEnoughCoinsDialog() {
        let overlay = UIControl()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.72)
        overlay.alpha = 0
        overlay.addTarget(self, action: #selector(dismissCoinDialog(_:)), for: .touchUpInside)

        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 30
        card.clipsToBounds = true

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Not enough coins"
        title.font = UIFont.systemFont(ofSize: 28, weight: .black)
        title.textColor = .black
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.72

        let message = UILabel()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.text = "Sorry, you don't have enough coins to pay, please go to recharge"
        message.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        message.textColor = UIColor(red: 0.54, green: 0.54, blue: 0.54, alpha: 1)
        message.textAlignment = .center
        message.numberOfLines = 0

        let buy = SuliJoyGradientButton(title: "Buy")
        buy.translatesAutoresizingMaskIntoConstraints = false
        buy.titleLabel?.font = UIFont.systemFont(ofSize: 23, weight: .black)
        buy.addTarget(self, action: #selector(openWalletFromCoinDialog(_:)), for: .touchUpInside)

        view.addSubview(overlay)
        overlay.addSubview(card)
        [title, message, buy].forEach { card.addSubview($0) }

        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            card.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
            card.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 36),
            card.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: -36),
            title.topAnchor.constraint(equalTo: card.topAnchor, constant: 42),
            title.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 18),
            title.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18),
            message.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 24),
            message.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 34),
            message.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -34),
            buy.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 34),
            buy.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 38),
            buy.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -38),
            buy.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -36)
        ])

        UIView.animate(withDuration: 0.2) {
            overlay.alpha = 1
        }
    }

    @objc private func dismissCoinDialog(_ sender: UIControl) {
        UIView.animate(withDuration: 0.18, animations: {
            sender.alpha = 0
        }, completion: { _ in
            sender.removeFromSuperview()
        })
    }

    @objc private func openWalletFromCoinDialog(_ sender: UIButton) {
        guard let overlay = sender.superview?.superview as? UIControl else { return }
        overlay.removeFromSuperview()
        navigationController?.pushViewController(SuliJoyWalletViewController(), animated: true)
    }
}

private final class SuliJoyRelatedActivityCard: UIControl {
    var onTap: ((String) -> Void)?
    private let activity: SuliJoyTideActivity
    private let imageView = UIImageView()
    private let statusLabel = UILabel()
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    private let titleLabel = UILabel()
    private let avatarStack = UIStackView()
//    private let joinButton = SuliJoyGradientButton(title: "Join Event")

    init(activity: SuliJoyTideActivity) {
        self.activity = activity
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        buildUI()
        render(activity)
        addTarget(self, action: #selector(open), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildUI() {
        layer.cornerRadius = 10
        clipsToBounds = true
        backgroundColor = UIColor(red: 1, green: 0.91, blue: 0.73, alpha: 1)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = UIFont.italicSystemFont(ofSize: 11).suliWithWeight(.bold)
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        statusLabel.backgroundColor = UIColor(red: 0.19, green: 0.82, blue: 0.61, alpha: 1)
        statusLabel.layer.cornerRadius = 8
        statusLabel.clipsToBounds = true

        let info = UIView()
        info.translatesAutoresizingMaskIntoConstraints = false
        info.backgroundColor = .white
        info.layer.cornerRadius = 8
        info.clipsToBounds = true

        dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .black)
        timeLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        timeLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        titleLabel.textColor = .suliInk
        titleLabel.lineBreakMode = .byTruncatingTail
        avatarStack.axis = .horizontal
        avatarStack.spacing = -6
//        joinButton.titleLabel?.font = UIFont.italicSystemFont(ofSize: 11).suliWithWeight(.black)
//        joinButton.isUserInteractionEnabled = false

        [imageView, statusLabel, info].forEach { addSubview($0) }
        [dateLabel, timeLabel, titleLabel, avatarStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            info.addSubview($0)
        }

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 164),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            statusLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            statusLabel.widthAnchor.constraint(equalToConstant: 70),
            statusLabel.heightAnchor.constraint(equalToConstant: 26),
            info.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            info.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            info.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            info.heightAnchor.constraint(equalToConstant: 58),
            dateLabel.leadingAnchor.constraint(equalTo: info.leadingAnchor, constant: 8),
            dateLabel.topAnchor.constraint(equalTo: info.topAnchor, constant: 7),
            timeLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 4),
            timeLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: info.trailingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            avatarStack.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            avatarStack.bottomAnchor.constraint(equalTo: info.bottomAnchor, constant: -7),
            avatarStack.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func render(_ activity: SuliJoyTideActivity) {
        imageView.image = UIImage.suliJoyAssetOrLocal(named: activity.media.first?.assetName ?? "")
        statusLabel.text = activity.status.rawValue
        statusLabel.backgroundColor = activity.status == .closed ? UIColor(white: 0.88, alpha: 1) : UIColor(red: 0.19, green: 0.82, blue: 0.61, alpha: 1)
        dateLabel.text = activity.dayText
        timeLabel.text = "\(activity.meridiem)\n\(activity.timeText)"
        titleLabel.text = activity.title
      
        avatarStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for asset in activity.avatarAssetNames.prefix(3) {
            let avatar = UIImageView(image: UIImage(named: asset))
            avatar.translatesAutoresizingMaskIntoConstraints = false
            avatar.contentMode = .scaleAspectFill
            avatar.clipsToBounds = true
            avatar.layer.cornerRadius = 10
            avatar.layer.borderColor = UIColor.white.cgColor
            avatar.layer.borderWidth = 1
            avatarStack.addArrangedSubview(avatar)
            avatar.widthAnchor.constraint(equalToConstant: 20).isActive = true
            avatar.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
    }

    @objc private func open() {
        onTap?(activity.tideID)
    }
}

private final class SuliJoyTideTalkSpaceViewController: SuliJoyBaseIslandViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    private let activity: SuliJoyTideActivity
    private var talkSpace: SuliJoyTideTalkSpace?
    private var seatButtons: [SuliJoyLagoonVoiceSeatButton] = []

    private let roomBackground = UIImageView()
    private let shadeView = UIView()
    private let header = UIView()
    private let titleLabel = UILabel()
    private let hostLabel = UILabel()
    private let participantStack = UIStackView()
    private let moreButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .custom)
    private let seatGrid = UIStackView()
    private let safetyBar = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let inputBar = UIView()
    private let messageField = UITextField()
    private let sendButton = UIButton(type: .custom)
    private let loading = UIActivityIndicatorView(style: .large)
    private var inputBottomConstraint: NSLayoutConstraint?

    init(activity: SuliJoyTideActivity) {
        self.activity = activity
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        registerKeyboard()
        loadRoom()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    private func buildUI() {
        roomBackground.translatesAutoresizingMaskIntoConstraints = false
        roomBackground.image = UIImage(named: "sulijoy_tide_room_sunset_bg") ?? UIImage.suliJoyAssetOrLocal(named: activity.media.first?.assetName ?? "")
        roomBackground.contentMode = .scaleAspectFill
        roomBackground.clipsToBounds = true

        shadeView.translatesAutoresizingMaskIntoConstraints = false
        shadeView.backgroundColor = UIColor.black.withAlphaComponent(0.28)

        header.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = activity.title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail

        hostLabel.translatesAutoresizingMaskIntoConstraints = false
        hostLabel.text = "Lucie Ray"
        hostLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        hostLabel.textColor = UIColor.white.withAlphaComponent(0.82)

        participantStack.translatesAutoresizingMaskIntoConstraints = false
        participantStack.axis = .horizontal
        participantStack.spacing = -8

        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreButton.tintColor = .white
        moreButton.backgroundColor = UIColor.white.withAlphaComponent(0.18)
        moreButton.layer.cornerRadius = 15
        moreButton.addTarget(self, action: #selector(openMore), for: .touchUpInside)

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "sulijoy_tide_room_close_mark"), for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.addTarget(self, action: #selector(confirmLeave), for: .touchUpInside)

        seatGrid.translatesAutoresizingMaskIntoConstraints = false
        seatGrid.axis = .vertical
        seatGrid.spacing = 14
        seatGrid.distribution = .fillEqually

        safetyBar.translatesAutoresizingMaskIntoConstraints = false
        safetyBar.text = "Be respectful, protect your privacy, and avoid sending offensive or personal content."
        safetyBar.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        safetyBar.textColor = UIColor(red: 1, green: 0.82, blue: 0.54, alpha: 1)
        safetyBar.numberOfLines = 2
        safetyBar.backgroundColor = UIColor.black.withAlphaComponent(0.30)
        safetyBar.layer.cornerRadius = 10
        safetyBar.clipsToBounds = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .interactive
        tableView.register(SuliJoyShoreChatBubbleCell.self, forCellReuseIdentifier: SuliJoyShoreChatBubbleCell.reuseID)
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)

        inputBar.translatesAutoresizingMaskIntoConstraints = false
        inputBar.backgroundColor = UIColor.black.withAlphaComponent(0.42)
        inputBar.layer.cornerRadius = 24
        inputBar.clipsToBounds = true

        let emojiButton = UIButton(type: .system)
        emojiButton.translatesAutoresizingMaskIntoConstraints = false
        emojiButton.setImage(UIImage(systemName: "face.smiling"), for: .normal)
        emojiButton.tintColor = UIColor.white.withAlphaComponent(0.86)

        messageField.translatesAutoresizingMaskIntoConstraints = false
        messageField.placeholder = "Say hi~"
        messageField.textColor = .white
        messageField.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        messageField.delegate = self
        messageField.returnKeyType = .send
        messageField.attributedPlaceholder = NSAttributedString(
            string: "Say hi~",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.56)]
        )

        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setImage(UIImage(named: "sulijoy_feed_send_mark"), for: .normal)
        sendButton.backgroundColor = UIColor(red: 1, green: 0.91, blue: 0.23, alpha: 1)
        sendButton.layer.cornerRadius = 17.5
        sendButton.imageView?.contentMode = .scaleAspectFit
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)

        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.color = .white
        loading.hidesWhenStopped = true

        view.addSubview(roomBackground)
        view.addSubview(shadeView)
        view.addSubview(header)
        view.addSubview(seatGrid)
        view.addSubview(safetyBar)
        view.addSubview(tableView)
        view.addSubview(inputBar)
        view.addSubview(loading)
        [titleLabel, hostLabel, participantStack, moreButton, closeButton].forEach { header.addSubview($0) }
        [emojiButton, messageField, sendButton].forEach { inputBar.addSubview($0) }

        inputBottomConstraint = inputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)

        NSLayoutConstraint.activate([
            roomBackground.topAnchor.constraint(equalTo: view.topAnchor),
            roomBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            roomBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            roomBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            shadeView.topAnchor.constraint(equalTo: view.topAnchor),
            shadeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shadeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shadeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            header.heightAnchor.constraint(equalToConstant: 48),
            titleLabel.topAnchor.constraint(equalTo: header.topAnchor, constant: 3),
            titleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: participantStack.leadingAnchor, constant: -12),
            hostLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            hostLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            hostLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            closeButton.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            closeButton.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            moreButton.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -8),
            moreButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
            moreButton.widthAnchor.constraint(equalToConstant: 30),
            moreButton.heightAnchor.constraint(equalToConstant: 30),
            participantStack.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor, constant: -10),
            participantStack.centerYAnchor.constraint(equalTo: moreButton.centerYAnchor),
            participantStack.heightAnchor.constraint(equalToConstant: 26),

            seatGrid.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 26),
            seatGrid.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            seatGrid.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            seatGrid.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.35),

            safetyBar.topAnchor.constraint(equalTo: seatGrid.bottomAnchor, constant: 16),
            safetyBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            safetyBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            safetyBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 38),

            tableView.topAnchor.constraint(equalTo: safetyBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: inputBar.topAnchor, constant: -8),

            inputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            inputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            inputBar.heightAnchor.constraint(equalToConstant: 48),
            inputBottomConstraint!,
            emojiButton.leadingAnchor.constraint(equalTo: inputBar.leadingAnchor, constant: 14),
            emojiButton.centerYAnchor.constraint(equalTo: inputBar.centerYAnchor),
            emojiButton.widthAnchor.constraint(equalToConstant: 28),
            emojiButton.heightAnchor.constraint(equalToConstant: 28),
            sendButton.trailingAnchor.constraint(equalTo: inputBar.trailingAnchor, constant: -6),
            sendButton.centerYAnchor.constraint(equalTo: inputBar.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 35),
            sendButton.heightAnchor.constraint(equalToConstant: 35),
            messageField.leadingAnchor.constraint(equalTo: emojiButton.trailingAnchor, constant: 8),
            messageField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            messageField.topAnchor.constraint(equalTo: inputBar.topAnchor),
            messageField.bottomAnchor.constraint(equalTo: inputBar.bottomAnchor),

            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func registerKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func loadRoom() {
        loading.startAnimating()
        SuliJoyCoveMockService.shared.fetchTideTalkSpace(tideID: activity.tideID) { [weak self] result in
            guard let self else { return }
            self.loading.stopAnimating()
            guard result.code == 200, let space = result.data else {
                self.showToast(result.message)
                return
            }
            self.talkSpace = space
            self.render(space)
        }
    }

    private func render(_ space: SuliJoyTideTalkSpace) {
        titleLabel.text = space.tideTitle
        hostLabel.text = space.hostName
        renderParticipants(space.participantAvatarAssetNames)
        renderSeats(space.voiceSeats)
        tableView.reloadData()
        scrollMessagesToBottom(animated: false)
    }

    private func renderParticipants(_ assets: [String]) {
        participantStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for asset in assets.prefix(3) {
            let avatar = UIImageView(image: UIImage(named: asset))
            avatar.translatesAutoresizingMaskIntoConstraints = false
            avatar.contentMode = .scaleAspectFill
            avatar.clipsToBounds = true
            avatar.layer.cornerRadius = 13
            avatar.layer.borderColor = UIColor.white.cgColor
            avatar.layer.borderWidth = 1
            participantStack.addArrangedSubview(avatar)
            avatar.widthAnchor.constraint(equalToConstant: 26).isActive = true
            avatar.heightAnchor.constraint(equalToConstant: 26).isActive = true
        }
    }

    private func renderSeats(_ seats: [SuliJoyLagoonVoiceSeat]) {
        seatButtons.removeAll()
        seatGrid.arrangedSubviews.forEach { row in
            seatGrid.removeArrangedSubview(row)
            row.removeFromSuperview()
        }
        var index = 0
        while index < seats.count {
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 10
            row.distribution = .fillEqually
            row.translatesAutoresizingMaskIntoConstraints = false
            for seat in seats[index..<min(index + 3, seats.count)] {
                let button = SuliJoyLagoonVoiceSeatButton()
                button.render(seat)
                button.addTarget(self, action: #selector(handleSeatTap(_:)), for: .touchUpInside)
                row.addArrangedSubview(button)
                seatButtons.append(button)
            }
            seatGrid.addArrangedSubview(row)
            index += 3
        }
    }

    @objc private func handleSeatTap(_ sender: SuliJoyLagoonVoiceSeatButton) {
        guard let seat = sender.seat else { return }
        if seat.isOpen {
            sender.isEnabled = false
            SuliJoyCoveMockService.shared.joinLagoonVoiceSeat(tideID: activity.tideID, seatID: seat.seatID) { [weak self, weak sender] result in
                sender?.isEnabled = true
                guard let self else { return }
                guard result.code == 200, let space = result.data else {
                    self.showToast(result.message)
                    return
                }
                self.talkSpace = space
                self.render(space)
                self.showToast("Seat joined.")
            }
        } else {
            showToast("\(seat.displayName) is on the seat.")
        }
    }

    @objc private func sendMessage() {
        let text = messageField.text ?? ""
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showToast("Please enter a message.")
            return
        }
        sendButton.isEnabled = false
        SuliJoyCoveMockService.shared.sendShoreChat(tideID: activity.tideID, text: text) { [weak self] result in
            guard let self else { return }
            self.sendButton.isEnabled = true
            guard result.code == 200, let space = result.data else {
                self.showToast(result.message)
                return
            }
            self.messageField.text = nil
            self.talkSpace = space
            self.tableView.reloadData()
            self.scrollMessagesToBottom(animated: true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }

    @objc private func openMore() {
        presentSuliJoyModerationMenu { [weak self] in
            guard let self else { return }
            self.presentSuliJoyReportSheet(target: .tideTalkSpace(tideID: self.activity.tideID))
        } block: { [weak self] in
            guard let self else { return }
            let visitorID = SuliJoyLagoonVisitor.visitorID(for: self.activity.shoreHostName)
            SuliJoyCoveMockService.shared.blockLagoonVisitor(visitorID: visitorID) { result in
                self.showToast(result.message)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @objc private func confirmLeave() {
        showLeaveDialog()
    }

    private func showWarningDialog() {
        presentRoomDialog(
            badgeName: "sulijoy_tide_room_warning_badge",
            title: "Warning",
            message: "Be careful. No explicit content or revealing outfits allowed.",
            primaryTitle: "OK",
            secondaryTitle: nil,
            primaryAction: nil
        )
    }

    private func showLeaveDialog() {
        presentRoomDialog(
            badgeName: "sulijoy_tide_room_exit_badge",
            title: nil,
            message: "Do you want to close the room?",
            primaryTitle: "Cancel",
            secondaryTitle: "Close",
            primaryAction: nil,
            secondaryAction: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        )
    }

    private func presentRoomDialog(
        badgeName: String,
        title: String?,
        message: String,
        primaryTitle: String,
        secondaryTitle: String?,
        primaryAction: (() -> Void)?,
        secondaryAction: (() -> Void)? = nil
    ) {
        let overlay = UIControl()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.62)
        overlay.alpha = 0

        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 18
        card.clipsToBounds = true

        let badge = UIImageView(image: UIImage(named: badgeName))
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.contentMode = .scaleAspectFit

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .black)
        titleLabel.textColor = .suliInk
        titleLabel.textAlignment = .center
        titleLabel.isHidden = title == nil

        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        messageLabel.textColor = .suliInk
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        let primary = SuliJoyGradientButton(title: primaryTitle)
        primary.translatesAutoresizingMaskIntoConstraints = false
        primary.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .black)
        primary.addAction(UIAction { [weak overlay] _ in
            overlay?.removeFromSuperview()
            primaryAction?()
        }, for: .touchUpInside)

        let buttonRow = UIStackView()
        buttonRow.translatesAutoresizingMaskIntoConstraints = false
        buttonRow.axis = .horizontal
        buttonRow.spacing = 14
        buttonRow.distribution = .fillEqually

        if let secondaryTitle {
            let secondary = UIButton(type: .system)
            secondary.translatesAutoresizingMaskIntoConstraints = false
            secondary.setTitle(secondaryTitle, for: .normal)
            secondary.setTitleColor(UIColor(white: 0.62, alpha: 1), for: .normal)
            secondary.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .black)
            secondary.backgroundColor = UIColor(white: 0.95, alpha: 1)
            secondary.layer.cornerRadius = 25
            secondary.addAction(UIAction { [weak overlay] _ in
                overlay?.removeFromSuperview()
                secondaryAction?()
            }, for: .touchUpInside)
            buttonRow.addArrangedSubview(primary)
            buttonRow.addArrangedSubview(secondary)
        } else {
            buttonRow.addArrangedSubview(primary)
        }

        view.addSubview(overlay)
        overlay.addSubview(card)
        [badge, titleLabel, messageLabel, buttonRow].forEach { card.addSubview($0) }

        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            card.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
            card.leadingAnchor.constraint(greaterThanOrEqualTo: overlay.leadingAnchor, constant: 42),
            card.trailingAnchor.constraint(lessThanOrEqualTo: overlay.trailingAnchor, constant: -42),
            card.widthAnchor.constraint(lessThanOrEqualToConstant: 310),
            badge.topAnchor.constraint(equalTo: card.topAnchor, constant: 18),
            badge.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            badge.widthAnchor.constraint(equalToConstant: 82),
            badge.heightAnchor.constraint(equalToConstant: 82),
            titleLabel.topAnchor.constraint(equalTo: badge.bottomAnchor, constant: title == nil ? 0 : 4),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18),
            messageLabel.topAnchor.constraint(equalTo: title == nil ? badge.bottomAnchor : titleLabel.bottomAnchor, constant: 12),
            messageLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 22),
            messageLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -22),
            buttonRow.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 22),
            buttonRow.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 28),
            buttonRow.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -28),
            buttonRow.heightAnchor.constraint(equalToConstant: 50),
            buttonRow.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -22)
        ])

        UIView.animate(withDuration: 0.18) {
            overlay.alpha = 1
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func keyboardWillShow(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let converted = view.convert(frame, from: nil)
        let overlap = max(0, view.bounds.maxY - converted.minY)
        inputBottomConstraint?.constant = -overlap + view.safeAreaInsets.bottom - 10
        tableView.contentInset.bottom = overlap + 72
        tableView.scrollIndicatorInsets.bottom = overlap + 72
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        scrollMessagesToBottom(animated: true)
    }

    @objc private func keyboardWillHide(_ note: Notification) {
        inputBottomConstraint?.constant = -10
        tableView.contentInset.bottom = 16
        tableView.scrollIndicatorInsets.bottom = 16
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    private func scrollMessagesToBottom(animated: Bool) {
        let count = talkSpace?.chatBubbles.count ?? 0
        guard count > 0 else { return }
        tableView.scrollToRow(at: IndexPath(row: count - 1, section: 0), at: .bottom, animated: animated)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        talkSpace?.chatBubbles.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: SuliJoyShoreChatBubbleCell.reuseID, for: indexPath) as? SuliJoyShoreChatBubbleCell,
            let bubble = talkSpace?.chatBubbles[indexPath.row]
        else {
            return UITableViewCell()
        }
        cell.render(bubble)
        return cell
    }
}

private final class SuliJoyLagoonVoiceSeatButton: UIControl {
    private let avatarView = UIImageView()
    private let micView = UIImageView()
    private let ownerLabel = UILabel()
    private let nameLabel = UILabel()
    private(set) var seat: SuliJoyLagoonVoiceSeat?

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        buildUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildUI() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 28
        avatarView.layer.borderWidth = 1.5
        avatarView.layer.borderColor = UIColor.white.withAlphaComponent(0.68).cgColor
        avatarView.backgroundColor = UIColor.white.withAlphaComponent(0.16)

        micView.translatesAutoresizingMaskIntoConstraints = false
        micView.image = UIImage(systemName: "mic")
        micView.tintColor = .white
        micView.contentMode = .scaleAspectFit

        ownerLabel.translatesAutoresizingMaskIntoConstraints = false
        ownerLabel.text = "Owner"
        ownerLabel.font = UIFont.systemFont(ofSize: 9, weight: .black)
        ownerLabel.textColor = .white
        ownerLabel.textAlignment = .center
        ownerLabel.backgroundColor = UIColor(red: 1, green: 0.45, blue: 0.25, alpha: 1)
        ownerLabel.layer.cornerRadius = 8
        ownerLabel.clipsToBounds = true

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 1
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.72

        [avatarView, micView, ownerLabel, nameLabel].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: topAnchor),
            avatarView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 56),
            avatarView.heightAnchor.constraint(equalToConstant: 56),
            micView.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            micView.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            micView.widthAnchor.constraint(equalToConstant: 24),
            micView.heightAnchor.constraint(equalToConstant: 24),
            ownerLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor, constant: -2),
            ownerLabel.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 2),
            ownerLabel.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 7),
            ownerLabel.heightAnchor.constraint(equalToConstant: 16),
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func render(_ seat: SuliJoyLagoonVoiceSeat) {
        self.seat = seat
        nameLabel.text = seat.displayName
        ownerLabel.isHidden = !seat.isOwner
        if seat.isOpen {
            avatarView.image = nil
            micView.isHidden = false
            avatarView.backgroundColor = UIColor.black.withAlphaComponent(0.22)
            nameLabel.textColor = UIColor.white.withAlphaComponent(0.86)
        } else {
            avatarView.image = UIImage(named: seat.avatarAssetName ?? "")
            micView.isHidden = true
            avatarView.backgroundColor = UIColor.white.withAlphaComponent(0.16)
            nameLabel.textColor = .white
        }
    }
}

private final class SuliJoyShoreChatBubbleCell: UITableViewCell {
    static let reuseID = "SuliJoyShoreChatBubbleCell"
    private let avatar = UIImageView()
    private let nameLabel = UILabel()
    private let bubbleLabel = UILabel()
    private let bubbleWrap = UIView()
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        buildUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildUI() {
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 14

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        nameLabel.textColor = UIColor.white.withAlphaComponent(0.76)

        bubbleWrap.translatesAutoresizingMaskIntoConstraints = false
        bubbleWrap.backgroundColor = .white
        bubbleWrap.layer.cornerRadius = 8
        bubbleWrap.clipsToBounds = true

        bubbleLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        bubbleLabel.textColor = .suliInk
        bubbleLabel.numberOfLines = 0

        contentView.addSubview(avatar)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bubbleWrap)
        bubbleWrap.addSubview(bubbleLabel)
        leadingConstraint = bubbleWrap.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10)
        trailingConstraint = bubbleWrap.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -54)

        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            avatar.widthAnchor.constraint(equalToConstant: 28),
            avatar.heightAnchor.constraint(equalToConstant: 28),
            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -54),
            bubbleWrap.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            leadingConstraint!,
            trailingConstraint!,
            bubbleWrap.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleLabel.topAnchor.constraint(equalTo: bubbleWrap.topAnchor, constant: 8),
            bubbleLabel.leadingAnchor.constraint(equalTo: bubbleWrap.leadingAnchor, constant: 12),
            bubbleLabel.trailingAnchor.constraint(equalTo: bubbleWrap.trailingAnchor, constant: -12),
            bubbleLabel.bottomAnchor.constraint(equalTo: bubbleWrap.bottomAnchor, constant: -8)
        ])
    }

    func render(_ bubble: SuliJoyShoreChatBubble) {
        avatar.image = UIImage(named: bubble.avatarAssetName ?? "")
        nameLabel.text = bubble.senderName
        bubbleLabel.text = bubble.text
        bubbleWrap.backgroundColor = bubble.isMine ? UIColor(red: 0.84, green: 1, blue: 0.76, alpha: 1) : .white
    }
}
