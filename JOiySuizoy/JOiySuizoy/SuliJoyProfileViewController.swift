import UIKit

final class SuliJoyProfileViewController: SuliJoyBaseIslandViewController, UITableViewDataSource, UITableViewDelegate {
    private let service = SuliJoyCoveMockService.shared
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let headerView = UIView()
    private let titlePill = UIView()
    private let titleLabel = UILabel()
    private let coinButton = SuliJoyCoinPillButton()
    private let searchButton = SuliJoyPillIconButton(assetName: "sulijoy_cove_search_mark")
    private let profileCard = UIView()
    private let avatarView = UIImageView()
    private let nameButton = UIButton(type: .system)
    private let islandIDLabel = UILabel()
    private let settingsButton = UIButton(type: .system)
    private let metricStack = UIStackView()
    private let segmentStack = UIStackView()
    private let indicator = SuliJoyGradientCapsuleView(colors: [
        UIColor(red: 1, green: 0.44, blue: 0.28, alpha: 1),
        UIColor(red: 0.96, green: 1.0, blue: 0.30, alpha: 1),
        UIColor(red: 0.40, green: 1.0, blue: 0.64, alpha: 1)
    ])
    private let emptyLabel = UILabel()

    private var selectedSection: SuliJoyMineCoveSection = .feed
    private var summary: SuliJoyIslandProfileSummary?
    private var moments: [SuliJoyShoreMoment] = []
    private var clips: [SuliJoyShellClip] = []
    private var activities: [SuliJoyTideActivity] = []
    private var sectionButtons: [SuliJoyMineCoveSection: UIButton] = [:]
    private var indicatorLeadingConstraint: NSLayoutConstraint?
    private weak var playingShortsCell: SuliJoyShortsClipCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        loadProfile()
        loadSelectedSection()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        coinButton.setBalance(SuliJoyShellWalletStore.shared.currentBalance())
        loadProfile()
        loadSelectedSection()
    }

    private func buildUI() {
        titlePill.translatesAutoresizingMaskIntoConstraints = false
        titlePill.backgroundColor = UIColor.white.withAlphaComponent(0.74)
        titlePill.layer.cornerRadius = 28
        titlePill.clipsToBounds = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "🤩 Profile"
        titleLabel.font = UIFont.italicSystemFont(ofSize: 31).suliWithWeight(.black)
        titleLabel.textColor = .suliInk
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.75
        titlePill.addSubview(titleLabel)

        coinButton.addTarget(self, action: #selector(openWallet), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(openSearch), for: .touchUpInside)

        profileCard.translatesAutoresizingMaskIntoConstraints = false
        profileCard.backgroundColor = UIColor.white.withAlphaComponent(0.64)
        profileCard.layer.cornerRadius = 26
        profileCard.layer.borderWidth = 1.5
        profileCard.layer.borderColor = UIColor(red: 1, green: 0.63, blue: 0.31, alpha: 1).cgColor

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 58
        avatarView.layer.borderWidth = 4
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.image = UIImage(named: "sulijoy_mock_avatar_breeze_01")

        nameButton.translatesAutoresizingMaskIntoConstraints = false
        nameButton.setTitle("David", for: .normal)
        nameButton.setTitleColor(.suliInk, for: .normal)
        nameButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        nameButton.contentHorizontalAlignment = .left
        nameButton.isUserInteractionEnabled = false

        islandIDLabel.translatesAutoresizingMaskIntoConstraints = false
        islandIDLabel.text = "ID  3994920304"
        islandIDLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        islandIDLabel.textColor = .suliMutedInk
        islandIDLabel.textAlignment = .left
        islandIDLabel.adjustsFontSizeToFitWidth = true
        islandIDLabel.minimumScaleFactor = 0.75

        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        settingsButton.tintColor = UIColor(red: 0.20, green: 0.14, blue: 0.03, alpha: 1)
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)

        metricStack.translatesAutoresizingMaskIntoConstraints = false
        metricStack.axis = .horizontal
        metricStack.distribution = .fillEqually
        metricStack.alignment = .center
        metricStack.spacing = 4

        [nameButton, islandIDLabel, settingsButton, metricStack].forEach { profileCard.addSubview($0) }

        segmentStack.translatesAutoresizingMaskIntoConstraints = false
        segmentStack.axis = .horizontal
        segmentStack.distribution = .fillEqually
        segmentStack.alignment = .center
        segmentStack.spacing = 10
        for section in SuliJoyMineCoveSection.allCases {
            let button = UIButton(type: .system)
            button.setTitle(section.rawValue, for: .normal)
            button.setTitleColor(.suliInk, for: .normal)
            button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 24).suliWithWeight(.black)
            button.tag = SuliJoyMineCoveSection.allCases.firstIndex(of: section) ?? 0
            button.addTarget(self, action: #selector(changeSection(_:)), for: .touchUpInside)
            sectionButtons[section] = button
            segmentStack.addArrangedSubview(button)
        }

        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        [titlePill, coinButton, searchButton, profileCard, avatarView, segmentStack, indicator].forEach { headerView.addSubview($0) }

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 520
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 110, right: 0)
        tableView.register(SuliJoyMomentCell.self, forCellReuseIdentifier: "SuliJoyMomentCell")
        tableView.register(SuliJoyShortsClipCell.self, forCellReuseIdentifier: "SuliJoyShortsClipCell")
        tableView.register(SuliJoyActivityCell.self, forCellReuseIdentifier: "SuliJoyActivityCell")
        view.addSubview(tableView)

        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "No profile content yet."
        emptyLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        emptyLabel.textColor = .suliMutedInk
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true
        view.addSubview(emptyLabel)

        indicatorLeadingConstraint = indicator.leadingAnchor.constraint(equalTo: segmentStack.leadingAnchor, constant: 20)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 420),

            titlePill.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 6),
            titlePill.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            titlePill.widthAnchor.constraint(lessThanOrEqualTo: headerView.widthAnchor, multiplier: 0.44),
            titlePill.heightAnchor.constraint(equalToConstant: 56),
            titleLabel.leadingAnchor.constraint(equalTo: titlePill.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: titlePill.trailingAnchor, constant: -14),
            titleLabel.centerYAnchor.constraint(equalTo: titlePill.centerYAnchor),

            coinButton.centerYAnchor.constraint(equalTo: titlePill.centerYAnchor),
            coinButton.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -14),
            searchButton.centerYAnchor.constraint(equalTo: titlePill.centerYAnchor),
            searchButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -24),
            searchButton.widthAnchor.constraint(equalToConstant: 56),

            profileCard.topAnchor.constraint(equalTo: titlePill.bottomAnchor, constant: 50),
            profileCard.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            profileCard.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -24),
            profileCard.heightAnchor.constraint(equalToConstant: 220),

            avatarView.leadingAnchor.constraint(equalTo: profileCard.leadingAnchor, constant: 26),
            avatarView.topAnchor.constraint(equalTo: profileCard.topAnchor, constant: -38),
            avatarView.widthAnchor.constraint(equalToConstant: 116),
            avatarView.heightAnchor.constraint(equalToConstant: 116),

            nameButton.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 20),
            nameButton.topAnchor.constraint(equalTo: profileCard.topAnchor, constant: 34),
            nameButton.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -10),
            islandIDLabel.leadingAnchor.constraint(equalTo: nameButton.leadingAnchor),
            islandIDLabel.topAnchor.constraint(equalTo: nameButton.bottomAnchor, constant: 8),
            islandIDLabel.trailingAnchor.constraint(equalTo: profileCard.trailingAnchor, constant: -12),
            settingsButton.trailingAnchor.constraint(equalTo: profileCard.trailingAnchor, constant: -20),
            settingsButton.topAnchor.constraint(equalTo: profileCard.topAnchor, constant: 28),
            settingsButton.widthAnchor.constraint(equalToConstant: 52),
            settingsButton.heightAnchor.constraint(equalToConstant: 52),

            metricStack.leadingAnchor.constraint(equalTo: profileCard.leadingAnchor, constant: 18),
            metricStack.trailingAnchor.constraint(equalTo: profileCard.trailingAnchor, constant: -18),
            metricStack.bottomAnchor.constraint(equalTo: profileCard.bottomAnchor, constant: -24),
            metricStack.heightAnchor.constraint(equalToConstant: 58),

            segmentStack.topAnchor.constraint(equalTo: profileCard.bottomAnchor, constant: 24),
            segmentStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 22),
            segmentStack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -22),
            segmentStack.heightAnchor.constraint(equalToConstant: 42),
            indicator.topAnchor.constraint(equalTo: segmentStack.bottomAnchor, constant: 3),
            indicator.widthAnchor.constraint(equalToConstant: 44),
            indicator.heightAnchor.constraint(equalToConstant: 10),
            indicatorLeadingConstraint!,

            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 36),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28)
        ])
        updateSectionVisuals(animated: false)
    }

    private func loadProfile() {
        service.fetchIslandProfileSummary { [weak self] result in
            guard let self else { return }
            if let summary = result.data {
                self.summary = summary
                self.apply(summary: summary)
            }
        }
    }

    private func loadSelectedSection() {
        emptyLabel.isHidden = true
        switch selectedSection {
        case .feed:
            service.fetchMineShoreMoments { [weak self] result in
                self?.moments = result.data ?? []
                self?.reloadContent()
            }
        case .shorts:
            service.fetchMineShellClips { [weak self] result in
                self?.clips = result.data ?? []
                self?.reloadContent()
            }
        case .events:
            service.fetchMineTideActivities { [weak self] result in
                self?.activities = result.data ?? []
                self?.reloadContent()
            }
        }
    }

    private func reloadContent() {
        playingShortsCell?.pausePlayback()
        playingShortsCell = nil
        tableView.reloadData()
        emptyLabel.text = emptyText(for: selectedSection)
        emptyLabel.isHidden = numberOfRows() > 0
    }

    private func apply(summary: SuliJoyIslandProfileSummary) {
        avatarView.image = UIImage.suliJoyAssetOrLocal(named: summary.avatarAssetName) ?? UIImage(named: "sulijoy_mock_avatar_breeze_01")
        nameButton.setTitle(summary.displayName, for: .normal)
        islandIDLabel.attributedText = nil
        islandIDLabel.text = "ID  \(summary.islandID)"
        metricStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        summary.metrics.forEach { metric in
            metricStack.addArrangedSubview(metricView(metric))
        }
    }

    private func emptyText(for section: SuliJoyMineCoveSection) -> String {
        switch section {
        case .feed:
            return "No feed moments yet."
        case .shorts:
            return "No shorts yet."
        case .events:
            return "No events yet."
        }
    }

    private func metricView(_ metric: SuliJoyShoreProfileMetric) -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        let value = UILabel()
        value.text = "\(metric.value)"
        value.font = UIFont.systemFont(ofSize: 25, weight: .black)
        value.textColor = .suliInk
        let title = UILabel()
        title.text = metric.title
        title.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        title.textColor = .suliMutedInk
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.75
        stack.addArrangedSubview(value)
        stack.addArrangedSubview(title)
        return stack
    }

    private func islandIDAttributedText(_ id: String) -> NSAttributedString {
        let text = NSMutableAttributedString(
            string: "ID",
            attributes: [
                .font: UIFont.italicSystemFont(ofSize: 14).suliWithWeight(.black),
                .foregroundColor: UIColor.white
            ]
        )
        let attachment = NSTextAttachment()
        attachment.image = capsuleImage(size: CGSize(width: 46, height: 24), text: text.string)
        attachment.bounds = CGRect(x: 0, y: -5, width: 46, height: 24)
        let result = NSMutableAttributedString(attachment: attachment)
        result.append(NSAttributedString(
            string: "  \(id)",
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                .foregroundColor: UIColor.suliMutedInk
            ]
        ))
        return result
    }

    private func capsuleImage(size: CGSize, text: String) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            let rect = CGRect(origin: .zero, size: size)
            UIColor(red: 0.21, green: 0.16, blue: 0.04, alpha: 1).setFill()
            UIBezierPath(roundedRect: rect, cornerRadius: size.height / 2).fill()
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.italicSystemFont(ofSize: 14).suliWithWeight(.black),
                .foregroundColor: UIColor.white
            ]
            let textSize = text.size(withAttributes: attributes)
            text.draw(at: CGPoint(x: (size.width - textSize.width) / 2, y: (size.height - textSize.height) / 2), withAttributes: attributes)
        }
    }

    @objc private func changeSection(_ sender: UIButton) {
        selectedSection = SuliJoyMineCoveSection.allCases[sender.tag]
        updateSectionVisuals(animated: true)
        loadSelectedSection()
    }

    private func updateSectionVisuals(animated: Bool) {
        for (section, button) in sectionButtons {
            button.alpha = section == selectedSection ? 1 : 0.92
        }
        let index = CGFloat(SuliJoyMineCoveSection.allCases.firstIndex(of: selectedSection) ?? 0)
        let segmentWidth = max(1, (view.bounds.width - 44) / 3)
        indicatorLeadingConstraint?.constant = 20 + segmentWidth * index + max(0, (segmentWidth - 44) / 2 - 4)
        let updates = { self.headerView.layoutIfNeeded() }
        animated ? UIView.animate(withDuration: 0.22, animations: updates) : updates()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSectionVisuals(animated: false)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRows()
    }

    private func numberOfRows() -> Int {
        switch selectedSection {
        case .feed: return moments.count
        case .shorts: return clips.count
        case .events: return activities.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedSection {
        case .feed:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SuliJoyMomentCell", for: indexPath) as! SuliJoyMomentCell
            let moment = moments[indexPath.row]
            cell.configure(with: moment, isFollowing: SuliJoyCoveMockService.shared.isLagoonFollowing(authorName: moment.authorName))
            cell.onLike = { [weak self] in self?.toggleMomentLike(moment.momentID) }
            cell.onComment = { [weak self] in self?.openMomentDetail(moment.momentID) }
            cell.onAudio = { [weak self] in self?.toggleMomentAudio(moment.momentID) }
            cell.onMore = { [weak self] in self?.showMomentActions(moment.momentID, sourceView: cell) }
            cell.onFollow = nil
            return cell
        case .shorts:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SuliJoyShortsClipCell", for: indexPath) as! SuliJoyShortsClipCell
            let clip = clips[indexPath.row]
            cell.configure(with: clip)
            cell.onPlay = { [weak self, weak cell] clipID in self?.toggleClipPlayback(clipID: clipID, cell: cell) }
            cell.onFollow = { [weak self] clipID in self?.toggleClipFollow(clipID) }
            cell.onLike = { [weak self] clipID in self?.toggleClipLike(clipID) }
            cell.onComment = { [weak self] clipID in self?.promptClipComment(clipID) }
            cell.onReport = { [weak self, weak cell] clipID in self?.showClipReport(clipID, sourceView: cell?.reportSourceView) }
            return cell
        case .events:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SuliJoyActivityCell", for: indexPath) as! SuliJoyActivityCell
            let activity = activities[indexPath.row]
            cell.configure(with: activity)
            cell.onJoin = { [weak self] in self?.openActivityDetail(activity.tideID) }
            cell.onReport = { [weak self] sourceView in
                self?.reportActivity(activity.tideID, sourceView: sourceView)
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectedSection {
        case .feed:
            openMomentDetail(moments[indexPath.row].momentID)
        case .shorts:
            let detail = SuliJoyClipDetailViewController(clipID: clips[indexPath.row].clipID)
            navigationController?.pushViewController(detail, animated: true)
        case .events:
            openActivityDetail(activities[indexPath.row].tideID)
        }
    }

    private func toggleMomentLike(_ momentID: String) {
        service.toggleMomentLike(momentID: momentID) { [weak self] result in
            guard let self, let moment = result.data, let index = self.moments.firstIndex(where: { $0.momentID == momentID }) else { return }
            self.moments[index] = moment
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }

    private func toggleMomentAudio(_ momentID: String) {
        service.toggleAudioPlayback(momentID: momentID) { [weak self] result in
            guard let self, let moment = result.data else { return }
            if let index = self.moments.firstIndex(where: { $0.momentID == momentID }) {
                self.moments[index] = moment
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
            self.showToast(result.message)
        }
    }

    private func showMomentActions(_ momentID: String, sourceView: UIView) {
        presentSuliJoyModerationMenu { [weak self] in
            self?.presentSuliJoyReportSheet(target: .moment(momentID: momentID))
        } block: { [weak self] in
            SuliJoyCoveMockService.shared.blockMomentAuthor(momentID: momentID) { result in
                self?.showToast(result.message)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.loadProfile()
            }
        }
    }

    private func toggleClipPlayback(clipID: String, cell: SuliJoyShortsClipCell?) {
        guard let cell else { return }
        if playingShortsCell !== cell {
            playingShortsCell?.pausePlayback()
        }
        if cell.togglePlayback() {
            playingShortsCell = cell.isClipPlaying ? cell : nil
        } else {
            showToast("Video unavailable.")
        }
    }

    private func toggleClipFollow(_ clipID: String) {
        service.toggleShellClipFollow(clipID: clipID) { [weak self] result in
            guard let self, let clip = result.data else { return }
            for index in self.clips.indices where self.clips[index].creator.displayName == clip.creator.displayName {
                self.clips[index].isFollowed = clip.isFollowed
            }
            self.tableView.reloadData()
            self.showToast(result.message)
        }
    }

    private func toggleClipLike(_ clipID: String) {
        service.toggleShellClipLike(clipID: clipID) { [weak self] result in
            guard let self, let clip = result.data, let index = self.clips.firstIndex(where: { $0.clipID == clipID }) else { return }
            self.clips[index] = clip
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }

    private func promptClipComment(_ clipID: String) {
        let alert = UIAlertController(title: "Comment", message: nil, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Comment something"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Send", style: .default) { [weak self, weak alert] _ in
            let text = alert?.textFields?.first?.text ?? ""
            self?.service.addShellClipComment(clipID: clipID, text: text) { result in
                guard let self else { return }
                if let clip = result.data, let index = self.clips.firstIndex(where: { $0.clipID == clipID }) {
                    self.clips[index] = clip
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    self.showToast(result.message)
                } else {
                    self.showToast(result.message)
                }
            }
        })
        present(alert, animated: true)
    }

    private func showClipReport(_ clipID: String, sourceView: UIView?) {
        guard let clip = clips.first(where: { $0.clipID == clipID }) else { return }
        presentSuliJoyModerationMenu { [weak self] in
            self?.presentSuliJoyReportSheet(target: .shellClip(clipID: clipID))
        } block: { [weak self] in
            let visitorID = SuliJoyLagoonVisitor.visitorID(for: clip.creator.displayName)
            SuliJoyCoveMockService.shared.blockLagoonVisitor(visitorID: visitorID) { result in
                self?.showToast(result.message)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.loadProfile()
            }
        }
    }

    private func reportActivity(_ tideID: String, sourceView: UIView) {
        guard let activity = activities.first(where: { $0.tideID == tideID }) else { return }
        presentSuliJoyModerationMenu { [weak self] in
            self?.presentSuliJoyReportSheet(target: .tideActivity(tideID: tideID))
        } block: { [weak self] in
            let visitorID = SuliJoyLagoonVisitor.visitorID(for: activity.shoreHostName)
            SuliJoyCoveMockService.shared.blockLagoonVisitor(visitorID: visitorID) { result in
                self?.showToast(result.message)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.loadProfile()
            }
        }
    }

    private func openMomentDetail(_ momentID: String) {
        guard let moment = moments.first(where: { $0.momentID == momentID }) else { return }
        let detail = SuliJoyMomentDetailViewController(moment: moment)
        navigationController?.pushViewController(detail, animated: true)
    }

    private func openActivityDetail(_ tideID: String) {
        let detail = SuliJoyActivityDetailViewController(tideID: tideID)
        navigationController?.pushViewController(detail, animated: true)
    }

    @objc private func openWallet() {
        navigationController?.pushViewController(SuliJoyWalletViewController(), animated: true)
    }

    @objc private func openSearch() {
        openSuliJoyMessages()
    }

    @objc private func openSettings() {
        navigationController?.pushViewController(SuliJoySettingViewController(), animated: true)
    }
}
