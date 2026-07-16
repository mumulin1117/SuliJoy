import AVFoundation
import UIKit

private final class SuliJoyWaveAudioPlaybackCenter {
    static let shared = SuliJoyWaveAudioPlaybackCenter()

    private var player: AVAudioPlayer?
    private var playingMomentID: String?

    private init() {}

    func play(note: SuliJoyWaveAudioNote, momentID: String) throws {
        if playingMomentID == momentID, player?.isPlaying == true {
            return
        }
        stopAll()
        guard let url = audioURL(for: note.audioFileName) else {
            throw NSError(domain: "SuliJoyWaveAudioPlaybackCenter", code: 404)
        }
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
        try session.setActive(true)
        let nextPlayer = try AVAudioPlayer(contentsOf: url)
        nextPlayer.prepareToPlay()
        nextPlayer.play()
        player = nextPlayer
        playingMomentID = momentID
    }

    func stop(momentID: String) {
        guard playingMomentID == momentID else { return }
        stopAll()
    }

    func stopAll() {
        player?.stop()
        player = nil
        playingMomentID = nil
    }

    private func audioURL(for fileName: String) -> URL? {
        guard !fileName.isEmpty else { return nil }
        if FileManager.default.fileExists(atPath: fileName) {
            return URL(fileURLWithPath: fileName)
        }
        let url = URL(fileURLWithPath: fileName)
        let base = url.deletingPathExtension().lastPathComponent
        let ext = url.pathExtension.isEmpty ? "mp3" : url.pathExtension
        return Bundle.main.url(forResource: base, withExtension: ext, subdirectory: "SuliJoyAudio")
            ?? Bundle.main.url(forResource: base, withExtension: ext)
    }
}

final class SuliJoyFeedViewController: SuliJoyBaseIslandViewController, UITableViewDataSource, UITableViewDelegate {
    private let scrollHeader = UIView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let loading = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()
    private let stylistRow = UIStackView()
    private var moments: [SuliJoyShoreMoment] = []
    private var selectedFilter: SuliJoyShoreMomentFilter = .recommend
    private var filterButtons: [SuliJoyShoreMomentFilter: UIButton] = [:]
    private var filterIndicators: [SuliJoyShoreMomentFilter: UIView] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAfterLocalPublish), name: .suliJoyShoreMomentPublished, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAfterVisitorChange), name: .suliJoyLagoonVisitorChanged, object: nil)
        loadPage(filter: .recommend)
    }

    @MainActor deinit {
        SuliJoyWaveAudioPlaybackCenter.shared.stopAll()
        NotificationCenter.default.removeObserver(self)
    }

    private func buildUI() {
        let header = buildHeader()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SuliJoyMomentCell.self, forCellReuseIdentifier: "SuliJoyMomentCell")
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 116, right: 0)

        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.hidesWhenStopped = true
        loading.color = .suliInk

        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "No shore moments yet."
        emptyLabel.textColor = .suliMutedInk
        emptyLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
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

        let logo = UILabel()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.text = "📷 Feed"
        logo.textColor = .suliInk
        logo.font = UIFont.systemFont(ofSize: 26, weight: .black)
        logo.backgroundColor = UIColor.white.withAlphaComponent(0.65)
        logo.layer.cornerRadius = 22
        logo.clipsToBounds = true
        logo.textAlignment = .center

        let coin = SuliJoyCoinPillButton()
        coin.addTarget(self, action: #selector(openPoints), for: .touchUpInside)
        let search = SuliJoyPillIconButton(assetName: "sulijoy_cove_search_mark")
        search.widthAnchor.constraint(equalToConstant: 44).isActive = true
        search.addTarget(self, action: #selector(openSearch), for: .touchUpInside)

        let best = UILabel()
        best.translatesAutoresizingMaskIntoConstraints = false
        best.text = "🔥Best Stylist"
        best.font = UIFont.systemFont(ofSize: 23, weight: .black)
        best.textColor = .suliInk

        let stylistScroll = UIScrollView()
        stylistScroll.translatesAutoresizingMaskIntoConstraints = false
        stylistScroll.showsHorizontalScrollIndicator = false
        stylistScroll.alwaysBounceHorizontal = true

        stylistRow.translatesAutoresizingMaskIntoConstraints = false
        stylistRow.axis = .horizontal
        stylistRow.spacing = 12
        stylistRow.distribution = .fill
        stylistScroll.addSubview(stylistRow)
        renderStylists()

        let tabs = UIStackView()
        tabs.translatesAutoresizingMaskIntoConstraints = false
        tabs.axis = .horizontal
        tabs.distribution = .fillEqually
        tabs.spacing = 12
        for filter in SuliJoyShoreMomentFilter.allCases {
            let tabItem = UIStackView()
            tabItem.translatesAutoresizingMaskIntoConstraints = false
            tabItem.axis = .vertical
            tabItem.alignment = .center
            tabItem.spacing = 3

            let button = UIButton(type: .system)
            button.setTitle(filter.rawValue, for: .normal)
            button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 15).suliWithWeight(.black)
            button.setTitleColor(.suliInk, for: .normal)
            button.tag = SuliJoyShoreMomentFilter.allCases.firstIndex(of: filter) ?? 0
            button.addTarget(self, action: #selector(changeFilter(_:)), for: .touchUpInside)

            let indicator = SuliJoyGradientCapsuleView(colors: [
                UIColor(red: 1, green: 0.43, blue: 0.25, alpha: 1),
                UIColor(red: 1, green: 0.96, blue: 0.32, alpha: 1),
                UIColor(red: 0.47, green: 1, blue: 0.47, alpha: 1)
            ])
            indicator.translatesAutoresizingMaskIntoConstraints = false

            tabItem.addArrangedSubview(button)
            tabItem.addArrangedSubview(indicator)
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 28),
                indicator.widthAnchor.constraint(equalToConstant: 42),
                indicator.heightAnchor.constraint(equalToConstant: 8)
            ])
            tabs.addArrangedSubview(tabItem)
            filterButtons[filter] = button
            filterIndicators[filter] = indicator
        }

        [logo, coin, search, best, stylistScroll, tabs].forEach { container.addSubview($0) }
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: container.topAnchor),
            logo.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            logo.widthAnchor.constraint(equalToConstant: 128),
            logo.heightAnchor.constraint(equalToConstant: 44),
            search.topAnchor.constraint(equalTo: logo.topAnchor),
            search.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            coin.centerYAnchor.constraint(equalTo: search.centerYAnchor),
            coin.trailingAnchor.constraint(equalTo: search.leadingAnchor, constant: -12),
            best.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 30),
            best.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stylistScroll.topAnchor.constraint(equalTo: best.bottomAnchor, constant: 14),
            stylistScroll.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stylistScroll.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stylistScroll.heightAnchor.constraint(equalToConstant: 82),
            stylistRow.topAnchor.constraint(equalTo: stylistScroll.contentLayoutGuide.topAnchor),
            stylistRow.leadingAnchor.constraint(equalTo: stylistScroll.contentLayoutGuide.leadingAnchor),
            stylistRow.trailingAnchor.constraint(equalTo: stylistScroll.contentLayoutGuide.trailingAnchor),
            stylistRow.bottomAnchor.constraint(equalTo: stylistScroll.contentLayoutGuide.bottomAnchor),
            stylistRow.heightAnchor.constraint(equalTo: stylistScroll.frameLayoutGuide.heightAnchor),
            tabs.topAnchor.constraint(equalTo: stylistScroll.bottomAnchor, constant: 24),
            tabs.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            tabs.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            tabs.heightAnchor.constraint(equalToConstant: 42),
            tabs.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        updateTabs()
        return container
    }

    private func loadPage(filter: SuliJoyShoreMomentFilter, mode: SuliJoyCoveRequestMode = .success) {
        selectedFilter = filter
        updateTabs()
        loading.startAnimating()
        emptyLabel.isHidden = true
        SuliJoyCoveMockService.shared.fetchShoreMoments(filter: filter, mode: mode) { [weak self] result in
            guard let self else { return }
            self.loading.stopAnimating()
            guard result.code == 200 else {
                self.moments = []
                self.tableView.reloadData()
                self.emptyLabel.text = result.message
                self.emptyLabel.isHidden = false
                self.showToast(result.message)
                return
            }
            self.moments = result.data ?? []
            self.tableView.reloadData()
            self.emptyLabel.text = "No shore moments yet."
            self.emptyLabel.isHidden = !self.moments.isEmpty
        }
    }

    private func updateTabs() {
        for (filter, button) in filterButtons {
            button.alpha = filter == selectedFilter ? 1 : 0.72
            button.setTitleColor(filter == selectedFilter ? .suliInk : .suliMutedInk, for: .normal)
            filterIndicators[filter]?.isHidden = filter != selectedFilter
        }
    }

    @objc private func changeFilter(_ sender: UIButton) {
        let filter = SuliJoyShoreMomentFilter.allCases[sender.tag]
        loadPage(filter: filter)
    }

    @objc private func openSearch() {
        openSuliJoyMessages()
    }

    @objc private func openPoints() {
        showLocalPlaceholder(title: "SuliJoy Points", subtitle: "Gems help unlock island activities and style features.")
    }

    @objc private func reloadAfterLocalPublish() {
        loadPage(filter: .recommend)
    }

    @objc private func reloadAfterVisitorChange() {
        renderStylists()
        loadPage(filter: selectedFilter)
    }

    private func renderStylists() {
        stylistRow.arrangedSubviews.forEach { view in
            stylistRow.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        SuliJoyCoveMockService.shared.fetchLagoonStylists(mode: .success) { [weak self] result in
            guard let self else { return }
            for stylist in result.data ?? [] {
                let card = SuliJoyStylistCard(stylist: stylist)
                card.onTap = { [weak self] in
                    self?.openVisitor(displayName: stylist.displayName)
                }
                card.onFollow = { [weak self] in
                    self?.toggleAuthorFollow(name: stylist.displayName)
                }
                self.stylistRow.addArrangedSubview(card)
                card.widthAnchor.constraint(equalToConstant: 164).isActive = true
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moments.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        360
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuliJoyMomentCell", for: indexPath) as! SuliJoyMomentCell
        let moment = moments[indexPath.row]
        cell.configure(with: moment, isFollowing: SuliJoyCoveMockService.shared.isLagoonFollowing(authorName: moment.authorName))
        cell.onLike = { [weak self] in self?.toggleLike(at: indexPath) }
        cell.onComment = { [weak self] in self?.presentComment(at: indexPath) }
        cell.onAudio = { [weak self] in self?.toggleAudio(at: indexPath) }
        cell.onMore = { [weak self] in self?.presentMore(at: indexPath) }
        cell.onFollow = { [weak self] in
            guard let self, self.moments.indices.contains(indexPath.row) else { return }
            self.toggleAuthorFollow(name: self.moments[indexPath.row].authorName)
        }
        cell.onAuthor = { [weak self] in
            guard let self, self.moments.indices.contains(indexPath.row) else { return }
            self.openVisitor(displayName: self.moments[indexPath.row].authorName)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard moments.indices.contains(indexPath.row) else { return }
        let detail = SuliJoyMomentDetailViewController(moment: moments[indexPath.row])
        navigationController?.pushViewController(detail, animated: true)
    }

    private func toggleLike(at indexPath: IndexPath) {
        guard moments.indices.contains(indexPath.row) else { return }
        SuliJoyCoveMockService.shared.toggleMomentLike(momentID: moments[indexPath.row].momentID) { [weak self] result in
            guard let self, let updated = result.data else { return }
            self.moments[indexPath.row] = updated
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    private func toggleAudio(at indexPath: IndexPath) {
        guard moments.indices.contains(indexPath.row) else { return }
        guard moments[indexPath.row].audioNote.duration > 0 else {
            showToast("No audio attached.")
            return
        }
        SuliJoyCoveMockService.shared.toggleAudioPlayback(momentID: moments[indexPath.row].momentID) { [weak self] result in
            guard let self, let updated = result.data else { return }
            for index in self.moments.indices {
                self.moments[index].audioNote.isPlaying = false
            }
            var rendered = updated
            if updated.audioNote.isPlaying {
                do {
                    try SuliJoyWaveAudioPlaybackCenter.shared.play(note: updated.audioNote, momentID: updated.momentID)
                } catch {
                    rendered.audioNote.isPlaying = false
                    rendered.audioNote.progress = 0
                    self.showToast("Audio unavailable.")
                }
            } else {
                SuliJoyWaveAudioPlaybackCenter.shared.stop(momentID: updated.momentID)
            }
            self.moments[indexPath.row] = rendered
            self.tableView.reloadData()
            if rendered.audioNote.isPlaying || !updated.audioNote.isPlaying {
                self.showToast(result.message)
            }
        }
    }

    private func presentComment(at indexPath: IndexPath) {
        guard moments.indices.contains(indexPath.row) else { return }
        let alert = UIAlertController(title: "Comment", message: moments[indexPath.row].authorName, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Comment something"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Send", style: .default) { [weak self] _ in
            guard let self else { return }
            let text = alert.textFields?.first?.text ?? ""
            SuliJoyCoveMockService.shared.addShoreComment(momentID: self.moments[indexPath.row].momentID, text: text) { result in
                guard let updated = result.data else {
                    self.showToast(result.message)
                    return
                }
                self.moments[indexPath.row] = updated
                self.tableView.reloadRows(at: [indexPath], with: .none)
                self.showToast(result.message)
            }
        })
        present(alert, animated: true)
    }

    private func presentMore(at indexPath: IndexPath) {
        guard moments.indices.contains(indexPath.row) else { return }
        let moment = moments[indexPath.row]
        presentSuliJoyModerationMenu { [weak self] in
            self?.presentSuliJoyReportSheet(target: .moment(momentID: moment.momentID))
        } block: { [weak self] in
            SuliJoyCoveMockService.shared.blockMomentAuthor(momentID: moment.momentID) { result in
                self?.showToast(result.message)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.loadPage(filter: self?.selectedFilter ?? .recommend)
            }
        }
    }

    private func toggleAuthorFollow(name: String) {
        SuliJoyCoveMockService.shared.toggleLagoonFollow(authorName: name) { [weak self] result in
            self?.showToast(result.message)
        }
    }

    private func openVisitor(displayName: String) {
        let visitor = SuliJoyIslandVisitorProfileViewController(displayName: displayName)
        navigationController?.pushViewController(visitor, animated: true)
    }
}

private final class SuliJoyFeedFollowBadgeButton: UIButton {
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 0)
        layer.masksToBounds = true
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(isFollowing: Bool) {
        setTitle(isFollowing ? "✓" : "+", for: .normal)
        gradientLayer.colors = isFollowing ? [
            UIColor(red: 0.91, green: 0.68, blue: 0.48, alpha: 1).cgColor,
            UIColor(red: 0.97, green: 0.76, blue: 0.56, alpha: 1).cgColor
        ] : [
            UIColor(red: 0.54, green: 0.45, blue: 1, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.29, blue: 0.96, alpha: 1).cgColor
        ]
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.cornerRadius = bounds.height / 2
    }
}

final class SuliJoyStylistCard: UIView {
    var onTap: (() -> Void)?
    var onFollow: (() -> Void)?
    private let followBadge = SuliJoyFeedFollowBadgeButton(type: .custom)

    init(stylist: SuliJoyLagoonStylist) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 18
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCard)))

        let avatar = UIImageView(image: UIImage(named: stylist.avatarAssetName))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 25
        avatar.layer.borderColor = UIColor.white.cgColor
        avatar.layer.borderWidth = 2

        followBadge.translatesAutoresizingMaskIntoConstraints = false
        followBadge.render(isFollowing: stylist.isFollowed)
        followBadge.addTarget(self, action: #selector(tapFollow), for: .touchUpInside)

        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = stylist.displayName
        name.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        name.textColor = .suliInk

        let followCount = UILabel()
        followCount.translatesAutoresizingMaskIntoConstraints = false
        followCount.text = "\(stylist.followingCount)"
        followCount.font = UIFont.systemFont(ofSize: 12, weight: .black)
        followCount.textColor = .suliInk
        followCount.textAlignment = .center

        let followText = UILabel()
        followText.translatesAutoresizingMaskIntoConstraints = false
        followText.text = "Follow"
        followText.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        followText.textColor = .suliMutedInk
        followText.textAlignment = .center

        let fansCount = UILabel()
        fansCount.translatesAutoresizingMaskIntoConstraints = false
        fansCount.text = "\(stylist.followerCount)"
        fansCount.font = UIFont.systemFont(ofSize: 12, weight: .black)
        fansCount.textColor = .suliInk
        fansCount.textAlignment = .center

        let fansText = UILabel()
        fansText.translatesAutoresizingMaskIntoConstraints = false
        fansText.text = "Fans"
        fansText.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        fansText.textColor = .suliMutedInk
        fansText.textAlignment = .center

        [avatar, followBadge, name, followCount, followText, fansCount, fansText].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            avatar.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 50),
            avatar.heightAnchor.constraint(equalToConstant: 50),
            followBadge.centerXAnchor.constraint(equalTo: avatar.centerXAnchor, constant: 0),
            followBadge.centerYAnchor.constraint(equalTo: avatar.centerYAnchor, constant: 18),
            followBadge.widthAnchor.constraint(equalToConstant: 42),
            followBadge.heightAnchor.constraint(equalToConstant: 24),
            name.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            followCount.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            followCount.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            followCount.widthAnchor.constraint(equalToConstant: 44),
            followText.topAnchor.constraint(equalTo: followCount.bottomAnchor, constant: 1),
            followText.centerXAnchor.constraint(equalTo: followCount.centerXAnchor),
            followText.widthAnchor.constraint(equalTo: followCount.widthAnchor),
            fansCount.topAnchor.constraint(equalTo: followCount.topAnchor),
            fansCount.leadingAnchor.constraint(equalTo: followCount.trailingAnchor, constant: 6),
            fansCount.widthAnchor.constraint(equalToConstant: 44),
            fansText.topAnchor.constraint(equalTo: fansCount.bottomAnchor, constant: 1),
            fansText.centerXAnchor.constraint(equalTo: fansCount.centerXAnchor),
            fansText.widthAnchor.constraint(equalTo: fansCount.widthAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func tapCard() {
        onTap?()
    }

    @objc private func tapFollow() {
        onFollow?()
    }
}

final class SuliJoyMomentCell: UITableViewCell {
    var onLike: (() -> Void)?
    var onComment: (() -> Void)?
    var onAudio: (() -> Void)?
    var onMore: (() -> Void)?
    var onAuthor: (() -> Void)?
    var onFollow: (() -> Void)?

    private let card = UIView()
    private let avatar = UIImageView()
    private let followBadge = SuliJoyFeedFollowBadgeButton(type: .custom)
    private let nameLabel = UILabel()
    private let timeLabel = UILabel()
    private let more = UIButton(type: .system)
    private let mediaStack = UIStackView()
    private let audioButton = UIButton(type: .system)
    private let audioPlayCircle = UIView()
    private let audioPlayIcon = UIImageView()
    private let audioText = UILabel()
    private let audioProgress = UIProgressView(progressViewStyle: .default)
    private let audioDurationLabel = UILabel()
    private let bodyLabel = UILabel()
    private let likeButton = UIButton(type: .system)
    private let commentButton = UIButton(type: .system)
    private let publishButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onLike = nil
        onComment = nil
        onAudio = nil
        onMore = nil
        onAuthor = nil
        onFollow = nil
    }

    private func buildUI() {
        selectionStyle = .none
        backgroundColor = .clear
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 24

        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 24
        followBadge.translatesAutoresizingMaskIntoConstraints = false
        avatar.isUserInteractionEnabled = true
        nameLabel.isUserInteractionEnabled = true
        [avatar, nameLabel].forEach {
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(authorNow)))
        }
        followBadge.addTarget(self, action: #selector(followNow), for: .touchUpInside)
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nameLabel.textColor = .suliInk
        timeLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        timeLabel.textColor = UIColor.gray
        more.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        more.tintColor = UIColor.gray
        more.addTarget(self, action: #selector(moreNow), for: .touchUpInside)

        mediaStack.axis = .horizontal
        mediaStack.spacing = 8
        mediaStack.distribution = .fillEqually

        audioButton.translatesAutoresizingMaskIntoConstraints = false
        
        let audioGradient = UIImage(named: "sulijoy_feed_detail_bottom_gradient")
        audioButton.setBackgroundImage(audioGradient, for: .normal)
       
        audioButton.addTarget(self, action: #selector(audioNow), for: .touchUpInside)

        audioPlayCircle.translatesAutoresizingMaskIntoConstraints = false
        audioPlayCircle.backgroundColor = UIColor.white.withAlphaComponent(0.92)
        audioPlayCircle.layer.cornerRadius = 15
        audioPlayCircle.isUserInteractionEnabled = false
        audioPlayIcon.translatesAutoresizingMaskIntoConstraints = false
        audioPlayIcon.tintColor = .suliInk
        audioPlayIcon.contentMode = .scaleAspectFit
        audioPlayCircle.addSubview(audioPlayIcon)

        audioText.translatesAutoresizingMaskIntoConstraints = false
        audioText.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        audioText.textColor = .suliInk
        audioProgress.translatesAutoresizingMaskIntoConstraints = false
        audioProgress.tintColor = UIColor(red: 1, green: 0.47, blue: 0.31, alpha: 1)
        audioProgress.trackTintColor = UIColor.suliInk.withAlphaComponent(0.18)
        audioDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        audioDurationLabel.font = UIFont.systemFont(ofSize: 14, weight: .black)
        audioDurationLabel.textColor = .suliInk
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        bodyLabel.textColor = .suliInk
        bodyLabel.numberOfLines = 2
        likeButton.tintColor = UIColor.gray
        likeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        likeButton.addTarget(self, action: #selector(likeNow), for: .touchUpInside)
        commentButton.setImage(UIImage(named: "sulijoy_feed_comment_mark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        commentButton.addTarget(self, action: #selector(commentNow), for: .touchUpInside)
        publishButton.setImage(UIImage(named: "sulijoy_feed_comment_send_mark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        publishButton.imageView?.contentMode = .scaleAspectFit
        publishButton.addTarget(self, action: #selector(commentNow), for: .touchUpInside)

        [card].forEach { contentView.addSubview($0) }
        [avatar, followBadge, nameLabel, timeLabel, more, mediaStack, audioButton, likeButton, commentButton, publishButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview($0)
        }
        [audioPlayCircle, audioText, audioProgress, audioDurationLabel, bodyLabel].forEach {
            audioButton.addSubview($0)
        }
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            avatar.topAnchor.constraint(equalTo: card.topAnchor, constant: 18),
            avatar.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            avatar.widthAnchor.constraint(equalToConstant: 48),
            avatar.heightAnchor.constraint(equalToConstant: 48),
            followBadge.centerXAnchor.constraint(equalTo: avatar.centerXAnchor),
            followBadge.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: -8),
            followBadge.widthAnchor.constraint(equalToConstant: 46),
            followBadge.heightAnchor.constraint(equalToConstant: 26),
            nameLabel.topAnchor.constraint(equalTo: avatar.topAnchor, constant: 3),
            nameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            more.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            more.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -22),
            more.widthAnchor.constraint(equalToConstant: 36),
            more.heightAnchor.constraint(equalToConstant: 36),
            mediaStack.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 16),
            mediaStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            mediaStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            mediaStack.heightAnchor.constraint(equalTo: mediaStack.widthAnchor, multiplier: 0.31),
            audioButton.topAnchor.constraint(equalTo: mediaStack.bottomAnchor, constant: 14),
            audioButton.leadingAnchor.constraint(equalTo: mediaStack.leadingAnchor),
            audioButton.trailingAnchor.constraint(equalTo: mediaStack.trailingAnchor),
            audioButton.heightAnchor.constraint(equalToConstant: 100),
            audioPlayCircle.leadingAnchor.constraint(equalTo: audioButton.leadingAnchor, constant: 18),
            audioPlayCircle.topAnchor.constraint(equalTo: audioButton.topAnchor, constant: 16),
            audioPlayCircle.widthAnchor.constraint(equalToConstant: 30),
            audioPlayCircle.heightAnchor.constraint(equalToConstant: 30),
            audioPlayIcon.centerXAnchor.constraint(equalTo: audioPlayCircle.centerXAnchor),
            audioPlayIcon.centerYAnchor.constraint(equalTo: audioPlayCircle.centerYAnchor),
            audioPlayIcon.widthAnchor.constraint(equalToConstant: 14),
            audioPlayIcon.heightAnchor.constraint(equalToConstant: 14),
            audioText.leadingAnchor.constraint(equalTo: audioPlayCircle.trailingAnchor, constant: 14),
            audioText.centerYAnchor.constraint(equalTo: audioPlayCircle.centerYAnchor),
            audioProgress.leadingAnchor.constraint(equalTo: audioText.trailingAnchor, constant: 12),
            audioProgress.centerYAnchor.constraint(equalTo: audioText.centerYAnchor),
            audioProgress.trailingAnchor.constraint(equalTo: audioDurationLabel.leadingAnchor, constant: -12),
            audioDurationLabel.centerYAnchor.constraint(equalTo: audioPlayCircle.centerYAnchor),
            audioDurationLabel.trailingAnchor.constraint(equalTo: audioButton.trailingAnchor, constant: -20),
            bodyLabel.topAnchor.constraint(equalTo: audioPlayCircle.bottomAnchor, constant: 12),
            bodyLabel.leadingAnchor.constraint(equalTo: audioButton.leadingAnchor, constant: 20),
            bodyLabel.trailingAnchor.constraint(equalTo: audioButton.trailingAnchor, constant: -20),
            likeButton.topAnchor.constraint(equalTo: audioButton.bottomAnchor, constant: 18),
            likeButton.leadingAnchor.constraint(equalTo: mediaStack.leadingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 72),
            commentButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 4),
            commentButton.widthAnchor.constraint(equalToConstant: 72),
            publishButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            publishButton.trailingAnchor.constraint(equalTo: mediaStack.trailingAnchor, constant: -6),
            publishButton.widthAnchor.constraint(equalToConstant: 18),
            publishButton.heightAnchor.constraint(equalToConstant: 18),
            publishButton.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -30)
        ])
    }

    func configure(with moment: SuliJoyShoreMoment, isFollowing: Bool) {
        avatar.image = UIImage.suliJoyAssetOrLocal(named: moment.authorAvatarAssetName)
        followBadge.render(isFollowing: isFollowing)
        nameLabel.text = moment.authorName
        timeLabel.text = "\(moment.authorHandle) · \(moment.timeAgo)"
        bodyLabel.text = moment.body
        audioText.text = moment.audioNote.isPlaying ? "Playing" : "Island outfit audio"
        audioDurationLabel.text = "\(moment.audioNote.duration)s"
        audioPlayIcon.image = UIImage(systemName: moment.audioNote.isPlaying ? "pause.fill" : "play.fill")
        audioProgress.progress = moment.audioNote.progress

        let likeImage = UIImage(named: moment.isLiked ? "sulijoy_feed_like_active" : "sulijoy_feed_like_idle")?.withRenderingMode(.alwaysOriginal)
        likeButton.setImage(likeImage, for: .normal)
        likeButton.setTitle(" \(moment.likeCount)", for: .normal)
        likeButton.setTitleColor(UIColor.gray, for: .normal)
        commentButton.setTitle(" \(moment.commentCount)", for: .normal)
        commentButton.setTitleColor(UIColor.gray, for: .normal)

        mediaStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let shownMedia = moment.media.prefix(3)
        mediaStack.isHidden = shownMedia.isEmpty
        for (index, media) in shownMedia.enumerated() {
            let imageView = UIImageView(image: UIImage.suliJoyAssetOrLocal(named: media.assetName))
            imageView.backgroundColor = UIColor(red: 1, green: 0.91, blue: 0.73, alpha: 1)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 9
            mediaStack.addArrangedSubview(imageView)
        }
    }

    @objc private func likeNow() { onLike?() }
    @objc private func commentNow() { onComment?() }
    @objc private func audioNow() { onAudio?() }
    @objc private func moreNow() { onMore?() }
    @objc private func authorNow() { onAuthor?() }
    @objc private func followNow() { onFollow?() }
}

final class SuliJoyMomentDetailViewController: SuliJoyBaseIslandViewController, UITextFieldDelegate {
    private var moment: SuliJoyShoreMoment
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let contentStack = UIStackView()
    private let headerRow = UIView()
    private let backButton = UIButton(type: .system)
    private let avatarView = UIImageView()
    private let authorLabel = UILabel()
    private let followButton = UIButton(type: .system)
    private let reportButton = UIButton(type: .system)
    private let mediaContainer = UIView()
    private let heroImageView = UIImageView()
    private let imageAudioButton = UIButton(type: .system)
    private let imageAudioPlayIcon = UIImageView()
    private let imageAudioWaveLabel = UILabel()
    private let imageAudioDurationLabel = UILabel()
    private let audioOnlyButton = UIButton(type: .system)
    private let audioOnlyCaptionLabel = UILabel()
    private let audioOnlyPlayIcon = UIImageView()
    private let audioOnlyWaveLabel = UILabel()
    private let audioOnlyDurationLabel = UILabel()
    private let bodyLabel = UILabel()
    private let commentsTitleLabel = UILabel()
    private let commentsStack = UIStackView()
    private let bottomInputBar = UIView()
    private let commentField = UITextField()
    private let sendButton = UIButton(type: .system)
    private var bottomInputBottomConstraint: NSLayoutConstraint?
    private var isFollowingAuthor = false

    init(moment: SuliJoyShoreMoment) {
        self.moment = moment
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @MainActor deinit {
        SuliJoyWaveAudioPlaybackCenter.shared.stop(momentID: moment.momentID)
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        registerKeyboardObservers()
        render()
    }

    private func buildUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.showsVerticalScrollIndicator = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 16

        configureHeader()
        configureMediaModeViews()
        configureTextAndComments()
        configureBottomInput()

        view.addSubview(scrollView)
        view.addSubview(bottomInputBar)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentStack)

        [headerRow, mediaContainer, audioOnlyButton, bodyLabel, commentsTitleLabel, commentsStack].forEach {
            contentStack.addArrangedSubview($0)
        }
        contentStack.setCustomSpacing(22, after: headerRow)
        contentStack.setCustomSpacing(14, after: mediaContainer)
        contentStack.setCustomSpacing(14, after: audioOnlyButton)
        contentStack.setCustomSpacing(18, after: bodyLabel)

        bottomInputBottomConstraint = bottomInputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomInputBottomConstraint?.isActive = true

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomInputBar.topAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            contentStack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 14),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22),

            headerRow.heightAnchor.constraint(equalToConstant: 44),
            mediaContainer.heightAnchor.constraint(equalTo: contentStack.widthAnchor, multiplier: 0.72),
            audioOnlyButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 108),

            bottomInputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomInputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomInputBar.heightAnchor.constraint(equalToConstant: 64)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func configureHeader() {
        headerRow.translatesAutoresizingMaskIntoConstraints = false

        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .suliInk
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 18
        avatarView.isUserInteractionEnabled = true
        avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openMomentAuthor)))

        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        authorLabel.textColor = .suliInk
        authorLabel.numberOfLines = 1
        authorLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        authorLabel.isUserInteractionEnabled = true
        authorLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openMomentAuthor)))

        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.setTitleColor(.white, for: .normal)
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .black)
        followButton.layer.cornerRadius = 14
        followButton.clipsToBounds = true
        followButton.backgroundColor = UIColor.purple
        followButton.addTarget(self, action: #selector(toggleFollow), for: .touchUpInside)

        reportButton.translatesAutoresizingMaskIntoConstraints = false
        reportButton.setImage(UIImage(systemName: "flag"), for: .normal)
        reportButton.tintColor = .suliInk
        reportButton.backgroundColor = UIColor.white.withAlphaComponent(0.70)
        reportButton.layer.cornerRadius = 15
        reportButton.accessibilityLabel = "Report moment"
        reportButton.addTarget(self, action: #selector(reportMoment), for: .touchUpInside)

        [backButton, avatarView, authorLabel, followButton, reportButton].forEach { headerRow.addSubview($0) }
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: headerRow.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: headerRow.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),

            avatarView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            avatarView.centerYAnchor.constraint(equalTo: headerRow.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 36),
            avatarView.heightAnchor.constraint(equalToConstant: 36),

            authorLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),
            authorLabel.centerYAnchor.constraint(equalTo: headerRow.centerYAnchor),
            authorLabel.trailingAnchor.constraint(lessThanOrEqualTo: followButton.leadingAnchor, constant: -8),

            followButton.centerYAnchor.constraint(equalTo: headerRow.centerYAnchor),
            followButton.trailingAnchor.constraint(equalTo: reportButton.leadingAnchor, constant: -8),
            followButton.widthAnchor.constraint(equalToConstant: 80),
            followButton.heightAnchor.constraint(equalToConstant: 30),

            reportButton.trailingAnchor.constraint(equalTo: headerRow.trailingAnchor),
            reportButton.centerYAnchor.constraint(equalTo: headerRow.centerYAnchor),
            reportButton.widthAnchor.constraint(equalToConstant: 30),
            reportButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func configureMediaModeViews() {
        mediaContainer.translatesAutoresizingMaskIntoConstraints = false
        mediaContainer.layer.cornerRadius = 18
        mediaContainer.clipsToBounds = true
        mediaContainer.backgroundColor = UIColor(red: 1, green: 0.91, blue: 0.73, alpha: 1)

        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        heroImageView.contentMode = .scaleAspectFill
        heroImageView.clipsToBounds = true
        mediaContainer.addSubview(heroImageView)

        configureImageAudioPill()
        configureAudioOnlyCard()

        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: mediaContainer.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: mediaContainer.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: mediaContainer.trailingAnchor),
            heroImageView.bottomAnchor.constraint(equalTo: mediaContainer.bottomAnchor),

            imageAudioButton.topAnchor.constraint(equalTo: mediaContainer.topAnchor, constant: 12),
            imageAudioButton.leadingAnchor.constraint(equalTo: mediaContainer.leadingAnchor, constant: 12),
            imageAudioButton.widthAnchor.constraint(equalToConstant: 195),
            imageAudioButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    private func configureImageAudioPill() {
        imageAudioButton.translatesAutoresizingMaskIntoConstraints = false
        imageAudioButton.layer.cornerRadius = 17
        imageAudioButton.clipsToBounds = true
        imageAudioButton.setBackgroundImage(UIImage(named: "sulijoy_feed_detail_bottom_gradient"), for: .normal)
        imageAudioButton.addTarget(self, action: #selector(toggleAudio), for: .touchUpInside)

        [imageAudioPlayIcon, imageAudioWaveLabel, imageAudioDurationLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isUserInteractionEnabled = false
            imageAudioButton.addSubview($0)
        }
        imageAudioPlayIcon.tintColor = .suliInk
        imageAudioWaveLabel.textColor = .suliInk
        imageAudioWaveLabel.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .semibold)
        imageAudioDurationLabel.textColor = .suliInk
        imageAudioDurationLabel.font = UIFont.systemFont(ofSize: 13, weight: .black)
        mediaContainer.addSubview(imageAudioButton)

        NSLayoutConstraint.activate([
            imageAudioPlayIcon.leadingAnchor.constraint(equalTo: imageAudioButton.leadingAnchor, constant: 12),
            imageAudioPlayIcon.centerYAnchor.constraint(equalTo: imageAudioButton.centerYAnchor),
            imageAudioPlayIcon.widthAnchor.constraint(equalToConstant: 14),
            imageAudioPlayIcon.heightAnchor.constraint(equalToConstant: 14),
            imageAudioWaveLabel.leadingAnchor.constraint(equalTo: imageAudioPlayIcon.trailingAnchor, constant: 9),
            imageAudioWaveLabel.centerYAnchor.constraint(equalTo: imageAudioButton.centerYAnchor),
            imageAudioDurationLabel.leadingAnchor.constraint(equalTo: imageAudioWaveLabel.trailingAnchor, constant: 10),
            imageAudioDurationLabel.trailingAnchor.constraint(lessThanOrEqualTo: imageAudioButton.trailingAnchor, constant: -12),
            imageAudioDurationLabel.centerYAnchor.constraint(equalTo: imageAudioButton.centerYAnchor)
        ])
    }

    private func configureAudioOnlyCard() {
        audioOnlyButton.translatesAutoresizingMaskIntoConstraints = false
        audioOnlyButton.backgroundColor = .white
        audioOnlyButton.layer.cornerRadius = 8
        audioOnlyButton.layer.borderColor = UIColor(red: 0.26, green: 0.04, blue: 0.29, alpha: 1).cgColor
        audioOnlyButton.layer.borderWidth = 1
        audioOnlyButton.clipsToBounds = true
        audioOnlyButton.addTarget(self, action: #selector(toggleAudio), for: .touchUpInside)

        [audioOnlyCaptionLabel, audioOnlyPlayIcon, audioOnlyWaveLabel, audioOnlyDurationLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isUserInteractionEnabled = false
            audioOnlyButton.addSubview($0)
        }
        audioOnlyCaptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        audioOnlyCaptionLabel.textColor = .suliInk
        audioOnlyCaptionLabel.numberOfLines = 2
        audioOnlyPlayIcon.tintColor = .suliInk
        audioOnlyWaveLabel.textColor = .suliInk
        audioOnlyWaveLabel.font = UIFont.monospacedSystemFont(ofSize: 15, weight: .black)
        audioOnlyDurationLabel.textColor = .suliInk
        audioOnlyDurationLabel.font = UIFont.systemFont(ofSize: 13, weight: .black)

        NSLayoutConstraint.activate([
            audioOnlyCaptionLabel.topAnchor.constraint(equalTo: audioOnlyButton.topAnchor, constant: 16),
            audioOnlyCaptionLabel.leadingAnchor.constraint(equalTo: audioOnlyButton.leadingAnchor, constant: 16),
            audioOnlyCaptionLabel.trailingAnchor.constraint(equalTo: audioOnlyButton.trailingAnchor, constant: -16),
            audioOnlyPlayIcon.leadingAnchor.constraint(equalTo: audioOnlyCaptionLabel.leadingAnchor),
            audioOnlyPlayIcon.topAnchor.constraint(equalTo: audioOnlyCaptionLabel.bottomAnchor, constant: 18),
            audioOnlyPlayIcon.widthAnchor.constraint(equalToConstant: 17),
            audioOnlyPlayIcon.heightAnchor.constraint(equalToConstant: 17),
            audioOnlyWaveLabel.leadingAnchor.constraint(equalTo: audioOnlyPlayIcon.trailingAnchor, constant: 14),
            audioOnlyWaveLabel.centerYAnchor.constraint(equalTo: audioOnlyPlayIcon.centerYAnchor),
            audioOnlyDurationLabel.leadingAnchor.constraint(equalTo: audioOnlyWaveLabel.trailingAnchor, constant: 14),
            audioOnlyDurationLabel.centerYAnchor.constraint(equalTo: audioOnlyPlayIcon.centerYAnchor),
            audioOnlyDurationLabel.trailingAnchor.constraint(lessThanOrEqualTo: audioOnlyButton.trailingAnchor, constant: -16)
        ])
    }

    private func configureTextAndComments() {
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        bodyLabel.textColor = UIColor.black.withAlphaComponent(0.80)
        bodyLabel.numberOfLines = 0

        commentsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        commentsTitleLabel.text = "Comments"
        commentsTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .black)
        commentsTitleLabel.textColor = .suliInk

        commentsStack.translatesAutoresizingMaskIntoConstraints = false
        commentsStack.axis = .vertical
        commentsStack.spacing = 12
    }

    private func configureBottomInput() {
        bottomInputBar.translatesAutoresizingMaskIntoConstraints = false
        bottomInputBar.backgroundColor = .white

        commentField.translatesAutoresizingMaskIntoConstraints = false
        commentField.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        commentField.layer.cornerRadius = 18
        commentField.clipsToBounds = true
        commentField.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        commentField.textColor = .suliInk
        commentField.placeholder = "What do you do on weekends?"
        commentField.returnKeyType = .send
        commentField.delegate = self
        commentField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        commentField.leftViewMode = .always

        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setImage(UIImage(named: "sulijoy_feed_comment_send_mark"), for: .normal)
        sendButton.tintColor = .suliInk
        sendButton.imageView?.contentMode = .scaleAspectFit
        sendButton.imageEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        sendButton.addTarget(self, action: #selector(sendComment), for: .touchUpInside)

        bottomInputBar.addSubview(commentField)
        bottomInputBar.addSubview(sendButton)
        NSLayoutConstraint.activate([
            commentField.leadingAnchor.constraint(equalTo: bottomInputBar.leadingAnchor, constant: 48),
            commentField.centerYAnchor.constraint(equalTo: bottomInputBar.centerYAnchor),
            commentField.heightAnchor.constraint(equalToConstant: 36),
            sendButton.leadingAnchor.constraint(equalTo: commentField.trailingAnchor, constant: 12),
            sendButton.trailingAnchor.constraint(equalTo: bottomInputBar.trailingAnchor, constant: -44),
            sendButton.centerYAnchor.constraint(equalTo: commentField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 36),
            sendButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func render() {
        let hasMedia = !moment.media.isEmpty
        avatarView.image = UIImage.suliJoyAssetOrLocal(named: moment.authorAvatarAssetName)
        authorLabel.text = moment.authorName
        isFollowingAuthor = SuliJoyCoveMockService.shared.isLagoonFollowing(authorName: moment.authorName)
        renderFollow()
        renderAudio()
        mediaContainer.isHidden = !hasMedia
        audioOnlyButton.isHidden = hasMedia
        if let firstMedia = moment.media.first {
            heroImageView.image = UIImage.suliJoyAssetOrLocal(named: firstMedia.assetName)
        }
        audioOnlyCaptionLabel.text = moment.authorStyleLine
        bodyLabel.text = moment.body
        reportButton.tintColor = moment.isReportedLocally ? UIColor(red: 1, green: 0.43, blue: 0.34, alpha: 1) : .suliInk
        renderComments()
    }

    private func renderFollow() {
        followButton.setTitle(isFollowingAuthor ? "Following" : "Follow", for: .normal)
        followButton.alpha = isFollowingAuthor ? 0.72 : 1
    }

    private func renderAudio() {
        let iconName = moment.audioNote.isPlaying ? "pause.fill" : "play.fill"
        [imageAudioPlayIcon, audioOnlyPlayIcon].forEach {
            $0.image = UIImage(systemName: iconName)
        }
        let wave = moment.audioNote.isPlaying ? "||||||||||||" : "|||||| |||||"
        imageAudioWaveLabel.text = wave
        audioOnlyWaveLabel.text = wave
        let duration = "\(moment.audioNote.duration)s"
        imageAudioDurationLabel.text = duration
        audioOnlyDurationLabel.text = duration
    }

    private func renderComments() {
        commentsTitleLabel.text = "Comments"
        commentsStack.arrangedSubviews.forEach { view in
            commentsStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        if moment.comments.isEmpty {
            let empty = UILabel()
            empty.text = "No comments yet."
            empty.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            empty.textColor = .suliMutedInk
            empty.numberOfLines = 0
            commentsStack.addArrangedSubview(empty)
            return
        }
        for comment in moment.comments {
            commentsStack.addArrangedSubview(makeCommentCard(comment))
        }
    }

    private func makeCommentCard(_ comment: SuliJoyShoreComment) -> UIView {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = UIColor.white.withAlphaComponent(0.96)
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.withAlphaComponent(0.03).cgColor
        card.layer.shadowOpacity = 1
        card.layer.shadowRadius = 10
        card.layer.shadowOffset = CGSize(width: 0, height: 6)

        let avatar = UIImageView(image: UIImage(named: comment.commenterAvatarAssetName))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 18

        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = comment.commenterName
        name.font = UIFont.systemFont(ofSize: 14, weight: .black)
        name.textColor = .suliInk

        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = comment.text
        text.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        text.textColor = UIColor.black.withAlphaComponent(0.50)
        text.numberOfLines = 0

        let time = UILabel()
        time.translatesAutoresizingMaskIntoConstraints = false
        time.text = comment.timeAgo
        time.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        time.textColor = UIColor.black.withAlphaComponent(0.30)

        let report = UIButton(type: .system)
        report.translatesAutoresizingMaskIntoConstraints = false
        report.setImage(UIImage(systemName: "exclamationmark.triangle"), for: .normal)
        report.tintColor = UIColor(red: 0.94, green: 0.89, blue: 0.84, alpha: 1)
        report.accessibilityLabel = "Report comment"
        report.addAction(UIAction { [weak self] _ in
            self?.reportComment(comment)
        }, for: .touchUpInside)

        [avatar, name, text, time, report].forEach { card.addSubview($0) }
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(greaterThanOrEqualToConstant: 82),
            avatar.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),
            avatar.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            avatar.widthAnchor.constraint(equalToConstant: 36),
            avatar.heightAnchor.constraint(equalToConstant: 36),
            name.topAnchor.constraint(equalTo: avatar.topAnchor),
            name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10),
            name.trailingAnchor.constraint(lessThanOrEqualTo: report.leadingAnchor, constant: -8),
            text.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 3),
            text.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            text.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -42),
            time.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 3),
            time.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            time.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -14),
            report.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            report.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            report.widthAnchor.constraint(equalToConstant: 24),
            report.heightAnchor.constraint(equalToConstant: 24)
        ])
        return card
    }

    private func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let overlap = max(0, frame.height - view.safeAreaInsets.bottom)
        bottomInputBottomConstraint?.constant = -overlap
        scrollView.contentInset.bottom = 16
        scrollView.scrollIndicatorInsets.bottom = 16
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ note: Notification) {
        bottomInputBottomConstraint?.constant = 0
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendComment()
        return true
    }

    @objc private func toggleFollow() {
        followButton.isEnabled = false
        SuliJoyCoveMockService.shared.toggleLagoonFollow(authorName: moment.authorName) { [weak self] result in
            guard let self else { return }
            self.followButton.isEnabled = true
            self.isFollowingAuthor = result.data ?? self.isFollowingAuthor
            self.renderFollow()
            NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
            self.showToast(result.message)
        }
    }

    @objc private func openMomentAuthor() {
        let visitor = SuliJoyIslandVisitorProfileViewController(displayName: moment.authorName)
        navigationController?.pushViewController(visitor, animated: true)
    }

    @objc private func toggleAudio() {
        guard moment.audioNote.duration > 0 else {
            showToast("No audio attached.")
            return
        }
        SuliJoyCoveMockService.shared.toggleAudioPlayback(momentID: moment.momentID) { [weak self] result in
            guard let self, let updated = result.data else { return }
            var rendered = updated
            if updated.audioNote.isPlaying {
                do {
                    try SuliJoyWaveAudioPlaybackCenter.shared.play(note: updated.audioNote, momentID: updated.momentID)
                } catch {
                    rendered.audioNote.isPlaying = false
                    rendered.audioNote.progress = 0
                    self.showToast("Audio unavailable.")
                }
            } else {
                SuliJoyWaveAudioPlaybackCenter.shared.stop(momentID: updated.momentID)
            }
            self.moment = rendered
            self.renderAudio()
            if rendered.audioNote.isPlaying || !updated.audioNote.isPlaying {
                self.showToast(result.message)
            }
        }
    }

    @objc private func sendComment() {
        let text = commentField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !text.isEmpty else {
            showToast("Please enter a comment.")
            return
        }
        sendButton.isEnabled = false
        SuliJoyCoveMockService.shared.addShoreComment(momentID: moment.momentID, text: text) { [weak self] result in
            guard let self else { return }
            self.sendButton.isEnabled = true
            if let updated = result.data {
                self.moment = updated
                self.commentField.text = nil
                self.renderComments()
                self.scrollCommentsToBottom()
            }
            self.showToast(result.message)
        }
    }

    private func reportComment(_ comment: SuliJoyShoreComment) {
        presentSuliJoyModerationMenu { [weak self] in
            guard let self else { return }
            self.presentSuliJoyReportSheet(target: .shoreComment(momentID: self.moment.momentID, commentID: comment.commentID))
        } block: { [weak self] in
            guard let self else { return }
            SuliJoyCoveMockService.shared.blockMomentAuthor(momentID: self.moment.momentID) { result in
                self.showToast(result.message)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @objc private func reportMoment() {
        presentSuliJoyModerationMenu { [weak self] in
            guard let self else { return }
            self.presentSuliJoyReportSheet(target: .moment(momentID: self.moment.momentID)) { [weak self] in
                self?.moment.isReportedLocally = true
                self?.render()
            }
        } block: { [weak self] in
            guard let self else { return }
            SuliJoyCoveMockService.shared.blockMomentAuthor(momentID: self.moment.momentID) { result in
                self.showToast(result.message)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func scrollCommentsToBottom() {
        view.layoutIfNeeded()
        let bottom = CGPoint(x: 0, y: max(0, scrollView.contentSize.height - scrollView.bounds.height + scrollView.adjustedContentInset.bottom))
        scrollView.setContentOffset(bottom, animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
