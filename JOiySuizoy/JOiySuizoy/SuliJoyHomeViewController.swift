import UIKit

final class SuliJoyHomeViewController: SuliJoyBaseIslandViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let loading = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()
    private let coinButton = SuliJoyCoinPillButton()
    private var activities: [SuliJoyTideActivity] = []
    private var requestMode: SuliJoyCoveRequestMode = .success

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        loadActivities(mode: .success)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        coinButton.setBalance(SuliJoyShellWalletStore.shared.currentBalance())
        if !activities.isEmpty {
            loadActivities(mode: .success)
        }
    }

    private func buildUI() {
        let header = buildHeader()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 116, right: 0)
        tableView.register(SuliJoyActivityCell.self, forCellReuseIdentifier: "SuliJoyActivityCell")

        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.hidesWhenStopped = true
        loading.color = .suliInk

        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "No shore activities yet."
        emptyLabel.textColor = .suliMutedInk
        emptyLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true

        [header, tableView, loading, emptyLabel].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func buildHeader() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let logo = UIImageView.init(image: UIImage.init(named: "sulijoyHaidao"))
       
        logo.translatesAutoresizingMaskIntoConstraints = false
        coinButton.addTarget(self, action: #selector(openPoints), for: .touchUpInside)
        let search = SuliJoyPillIconButton(assetName: "sulijoy_cove_search_mark")
        search.widthAnchor.constraint(equalToConstant: 44).isActive = true
        search.addTarget(self, action: #selector(openSearch), for: .touchUpInside)

//        let banner = UIControl()
//        banner.translatesAutoresizingMaskIntoConstraints = false
//        banner.layer.cornerRadius = 22
//        banner.clipsToBounds = true
//        banner.addTarget(self, action: #selector(openAI), for: .touchUpInside)
//        let gradient = SuliJoyGradientCapsuleView(colors: [
//            UIColor(red: 0.54, green: 0.45, blue: 1, alpha: 1),
//            UIColor(red: 1, green: 0.28, blue: 0.96, alpha: 1)
//        ])
//        let bannerTitle = UILabel()
//        bannerTitle.translatesAutoresizingMaskIntoConstraints = false
//        bannerTitle.text = "AI Island Stylist"
//        bannerTitle.textColor = .white
//        bannerTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
//        let bannerSub = UILabel()
//        bannerSub.translatesAutoresizingMaskIntoConstraints = false
//        bannerSub.text = "Scene-Specific Matching"
//        bannerSub.textColor = UIColor.white.withAlphaComponent(0.78)
//        bannerSub.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        let art = UIImageView(image: UIImage(named: "sulijoy_home_ai_banner_art"))
//        art.translatesAutoresizingMaskIntoConstraints = false
//        art.contentMode = .scaleAspectFit
//        banner.addSubview(gradient)
//        banner.addSubview(bannerTitle)
//        banner.addSubview(bannerSub)
//        banner.addSubview(art)
//        gradient.suliPinEdges(to: banner)

        let discover = UILabel()
        discover.translatesAutoresizingMaskIntoConstraints = false
        discover.text = "👏Discover Events"
        discover.textColor = .suliInk
        discover.font = UIFont.systemFont(ofSize: 22, weight: .black)

        [logo, coinButton, search,  discover].forEach { container.addSubview($0) }
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: container.topAnchor),
            logo.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            logo.widthAnchor.constraint(lessThanOrEqualToConstant: 143),
            logo.heightAnchor.constraint(equalToConstant: 40),
            search.topAnchor.constraint(equalTo: logo.topAnchor),
            search.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            coinButton.centerYAnchor.constraint(equalTo: search.centerYAnchor),
            coinButton.trailingAnchor.constraint(equalTo: search.leadingAnchor, constant: -12),
//            banner.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 28),
//            banner.leadingAnchor.constraint(equalTo: container.leadingAnchor),
//            banner.trailingAnchor.constraint(equalTo: container.trailingAnchor),
//            banner.heightAnchor.constraint(equalToConstant: 86),
//            bannerTitle.leadingAnchor.constraint(equalTo: banner.leadingAnchor, constant: 24),
//            bannerTitle.topAnchor.constraint(equalTo: banner.topAnchor, constant: 18),
//            bannerSub.leadingAnchor.constraint(equalTo: bannerTitle.leadingAnchor),
//            bannerSub.topAnchor.constraint(equalTo: bannerTitle.bottomAnchor, constant: 6),
//            art.trailingAnchor.constraint(equalTo: banner.trailingAnchor, constant: -4),
//            art.bottomAnchor.constraint(equalTo: banner.bottomAnchor, constant: 4),
//            art.widthAnchor.constraint(equalTo: banner.widthAnchor, multiplier: 0.36),
//            art.heightAnchor.constraint(equalToConstant: 100),
            discover.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 28),
            discover.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            discover.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            discover.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        return container
    }

    private func loadActivities(mode: SuliJoyCoveRequestMode) {
        requestMode = mode
        emptyLabel.isHidden = true
        loading.startAnimating()
        SuliJoyCoveMockService.shared.fetchHomeActivities(mode: mode) { [weak self] result in
            guard let self else { return }
            self.loading.stopAnimating()
            guard result.code == 200 else {
                self.activities = []
                self.tableView.reloadData()
                self.emptyLabel.text = result.message
                self.emptyLabel.isHidden = false
                self.showToast(result.message)
                return
            }
            self.activities = result.data ?? []
            self.tableView.reloadData()
            self.emptyLabel.text = "No shore activities yet."
            self.emptyLabel.isHidden = !self.activities.isEmpty
        }
    }

    @objc private func openAI() {
        showLocalPlaceholder(title: "AI Island Stylist", subtitle: "Style matching entrance placeholder.")
    }

    @objc private func openSearch() {
        openSuliJoyMessages()
    }

    @objc private func openPoints() {
        navigationController?.pushViewController(SuliJoyWalletViewController(), animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        activities.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        315
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuliJoyActivityCell", for: indexPath) as! SuliJoyActivityCell
        cell.configure(with: activities[indexPath.row])
        cell.onJoin = { [weak self] in
            self?.joinActivity(at: indexPath)
        }
        cell.onReport = { [weak self] sourceView in
            self?.reportActivity(at: indexPath, sourceView: sourceView)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard activities.indices.contains(indexPath.row) else { return }
        let detail = SuliJoyActivityDetailViewController(tideID: activities[indexPath.row].tideID)
        detail.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detail, animated: true)
    }

    private func joinActivity(at indexPath: IndexPath) {
        guard activities.indices.contains(indexPath.row) else { return }
        let tideID = activities[indexPath.row].tideID
        SuliJoyCoveMockService.shared.joinActivity(tideID: tideID) { [weak self] result in
            guard let self else { return }
            guard result.code == 200, let updated = result.data else {
                self.showToast(result.message)
                return
            }
            self.activities[indexPath.row] = updated
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            self.showToast("Joined.")
        }
    }

    private func reportActivity(at indexPath: IndexPath, sourceView: UIView) {
        guard activities.indices.contains(indexPath.row) else { return }
        let activity = activities[indexPath.row]
        presentSuliJoyModerationMenu { [weak self] in
            self?.presentSuliJoyReportSheet(target: .tideActivity(tideID: activity.tideID))
        } block: { [weak self] in
            let visitorID = SuliJoyLagoonVisitor.visitorID(for: activity.shoreHostName)
            SuliJoyCoveMockService.shared.blockLagoonVisitor(visitorID: visitorID) { result in
                self?.showToast(result.message)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.loadActivities(mode: .success)
            }
        }
    }
}

final class SuliJoyActivityCell: UITableViewCell {
    var onJoin: (() -> Void)?
    var onReport: ((UIView) -> Void)?
    private let card = UIView()
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let summaryLabel = UILabel()
    private let reportButton = UIButton(type: .system)
    private let statusButton = UIButton(type: .system)
    private let imageStack = UIStackView()
    private let avatarStack = UIStackView()
    private let countLabel = UILabel()
    private let joinStack = UIStackView()
    private let joinButton = SuliJoyGradientButton(title: "Join Event")
    private let joinButtonContentStack = UIStackView()
    private let joinButtonTitleLabel = UILabel()
    private let gemIconView = UIImageView(image: UIImage(named: "sulijoy_shell_coin_gem"))
    private let gemCostLabel = UILabel()
    private var imageViews: [UIImageView] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 24
        card.layer.shadowColor = UIColor.black.withAlphaComponent(0.04).cgColor
        card.layer.shadowOpacity = 1
        card.layer.shadowRadius = 16
        card.layer.shadowOffset = CGSize(width: 0, height: 10)

        dateLabel.font = UIFont.systemFont(ofSize: 20, weight: .black)
        dateLabel.textColor = .suliInk
        timeLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        timeLabel.textColor = .suliInk
        timeLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        titleLabel.textColor = .suliInk
        locationLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        locationLabel.textColor = UIColor.gray
        locationLabel.numberOfLines = 1
        summaryLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        summaryLabel.textColor = UIColor(red: 0.38, green: 0.34, blue: 0.26, alpha: 1)
        summaryLabel.numberOfLines = 2
        statusButton.titleLabel?.font = UIFont.italicSystemFont(ofSize: 14)
        statusButton.layer.cornerRadius = 10
        statusButton.isUserInteractionEnabled = false
        reportButton.backgroundColor = UIColor(red: 1, green: 0.94, blue: 0.89, alpha: 1)
        reportButton.layer.cornerRadius = 15
        reportButton.setImage(UIImage(systemName: "flag.fill"), for: .normal)
        reportButton.tintColor = UIColor(red: 1, green: 0.42, blue: 0.18, alpha: 1)
        reportButton.addTarget(self, action: #selector(reportNow), for: .touchUpInside)

        imageStack.axis = .horizontal
        imageStack.spacing = 8
        imageStack.distribution = .fillEqually
        avatarStack.axis = .horizontal
        avatarStack.spacing = -5
        countLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        countLabel.textColor = UIColor.gray
        joinButton.setTitle("", for: .normal)
        joinButton.addTarget(self, action: #selector(joinNow), for: .touchUpInside)

        joinButtonTitleLabel.text = "Join Event"
        joinButtonTitleLabel.font = UIFont.italicSystemFont(ofSize: 13).suliWithWeight(.black)
        joinButtonTitleLabel.textColor = .suliInk
        joinButtonTitleLabel.textAlignment = .center
        joinButtonTitleLabel.adjustsFontSizeToFitWidth = true
        joinButtonTitleLabel.minimumScaleFactor = 0.76

        gemIconView.contentMode = .scaleAspectFit
        gemIconView.translatesAutoresizingMaskIntoConstraints = false
        gemCostLabel.font = UIFont.systemFont(ofSize: 12, weight: .black)
        gemCostLabel.textColor = .suliInk

        let gemRow = UIStackView(arrangedSubviews: [gemIconView, gemCostLabel])
        gemRow.axis = .horizontal
        gemRow.alignment = .center
        gemRow.spacing = 3
        gemRow.translatesAutoresizingMaskIntoConstraints = false

        joinButtonContentStack.axis = .vertical
        joinButtonContentStack.alignment = .center
        joinButtonContentStack.spacing = 1
        joinButtonContentStack.translatesAutoresizingMaskIntoConstraints = false
        joinButtonContentStack.isUserInteractionEnabled = false
        joinButtonContentStack.addArrangedSubview(joinButtonTitleLabel)
        joinButtonContentStack.addArrangedSubview(gemRow)
        joinButton.addSubview(joinButtonContentStack)

        joinStack.axis = .vertical
        joinStack.alignment = .center
        joinStack.translatesAutoresizingMaskIntoConstraints = false
        joinStack.addArrangedSubview(joinButton)

        [card].forEach { contentView.addSubview($0) }
        [dateLabel, timeLabel, reportButton, statusButton, titleLabel, locationLabel, summaryLabel, imageStack, avatarStack, countLabel, joinStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview($0)
        }
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            dateLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            timeLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10),
            timeLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            statusButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            statusButton.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            statusButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 78),
            statusButton.heightAnchor.constraint(equalToConstant: 32),
            reportButton.centerYAnchor.constraint(equalTo: statusButton.centerYAnchor),
            reportButton.trailingAnchor.constraint(equalTo: statusButton.leadingAnchor, constant: -8),
            reportButton.widthAnchor.constraint(equalToConstant: 30),
            reportButton.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            summaryLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            summaryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            summaryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            imageStack.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 14),
            imageStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            imageStack.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            imageStack.heightAnchor.constraint(equalTo: imageStack.widthAnchor, multiplier: 0.29),
            avatarStack.topAnchor.constraint(equalTo: imageStack.bottomAnchor, constant: 18),
            avatarStack.leadingAnchor.constraint(equalTo: imageStack.leadingAnchor),
            avatarStack.heightAnchor.constraint(equalToConstant: 28),
            countLabel.leadingAnchor.constraint(equalTo: avatarStack.trailingAnchor, constant: 10),
            countLabel.centerYAnchor.constraint(equalTo: avatarStack.centerYAnchor),
            countLabel.trailingAnchor.constraint(lessThanOrEqualTo: joinStack.leadingAnchor, constant: -8),
            joinStack.centerYAnchor.constraint(equalTo: avatarStack.centerYAnchor),
            joinStack.trailingAnchor.constraint(equalTo: imageStack.trailingAnchor),
            joinStack.widthAnchor.constraint(equalToConstant: 118),
            joinStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -14),
            joinButton.widthAnchor.constraint(equalTo: joinStack.widthAnchor),
            joinButtonContentStack.centerXAnchor.constraint(equalTo: joinButton.centerXAnchor),
            joinButtonContentStack.centerYAnchor.constraint(equalTo: joinButton.centerYAnchor),
            joinButtonContentStack.leadingAnchor.constraint(greaterThanOrEqualTo: joinButton.leadingAnchor, constant: 10),
            joinButtonContentStack.trailingAnchor.constraint(lessThanOrEqualTo: joinButton.trailingAnchor, constant: -10),
            gemIconView.widthAnchor.constraint(equalToConstant: 14),
            gemIconView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }

    func configure(with activity: SuliJoyTideActivity) {
        dateLabel.text = activity.dayText
        timeLabel.text = "\(activity.meridiem)\n\(activity.timeText)"
        titleLabel.text = activity.title
        locationLabel.text = "●  \(activity.location)"
        summaryLabel.text = activity.summary
        statusButton.setTitle(activity.status.rawValue, for: .normal)
        statusButton.backgroundColor = activity.status == .closed ? UIColor(white: 0.94, alpha: 1) : UIColor(red: 0.91, green: 1, blue: 0.91, alpha: 1)
        statusButton.setTitleColor(activity.status == .closed ? UIColor.lightGray : UIColor(red: 0.19, green: 0.82, blue: 0.61, alpha: 1), for: .normal)
        let buttonTitle: String
        switch activity.status {
        case .joined:
            buttonTitle = "Joined"
        case .closed:
            buttonTitle = "Closed"
        case .open:
            buttonTitle = "Join Event"
        }
        joinButton.setTitle("", for: .normal)
        joinButtonTitleLabel.text = buttonTitle
        joinButton.isEnabled = activity.status == .open
        joinStack.alpha = activity.status == .closed ? 0.45 : 1
        gemCostLabel.text = "\(activity.gemCost)"
        countLabel.text = "\(activity.joinedCount)/\(activity.capacity)"

        imageStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        imageViews = activity.media.prefix(3).map { media in
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor(red: 1, green: 0.91, blue: 0.73, alpha: 1)
            imageView.image = UIImage.suliJoyAssetOrLocal(named: media.assetName)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 9
            imageStack.addArrangedSubview(imageView)
            return imageView
        }

        avatarStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for asset in activity.avatarAssetNames.prefix(3) {
            let imageView = UIImageView(image: UIImage(named: asset))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 14
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.borderWidth = 1
            avatarStack.addArrangedSubview(imageView)
            imageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        }
    }

    @objc private func joinNow() {
        onJoin?()
    }

    @objc private func reportNow() {
        onReport?(reportButton)
    }
}
