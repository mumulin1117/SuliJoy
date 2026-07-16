import AVFoundation
import UIKit

final class SuliJoyShortsViewController: SuliJoyBaseIslandViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let loadingView = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()
    private let coinButton = SuliJoyCoinPillButton()
    private var clips: [SuliJoyShellClip] = []
    private weak var playingCell: SuliJoyShortsClipCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        fetchClips()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        coinButton.setBalance(SuliJoyShellWalletStore.shared.currentBalance())
        if !clips.isEmpty {
            fetchClips()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseCurrentClip()
    }

    private func buildUI() {
        let header = makeHeader()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 118, right: 0)
        tableView.register(SuliJoyShortsClipCell.self, forCellReuseIdentifier: "SuliJoyShortsClipCell")

        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.hidesWhenStopped = true
        loadingView.color = .suliInk

        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "No island shorts yet."
        emptyLabel.textColor = .suliMutedInk
        emptyLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true

        [header, tableView, loadingView, emptyLabel].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            header.heightAnchor.constraint(equalToConstant: 52),

            tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func makeHeader() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let titlePill = SuliJoyGradientCapsuleView(colors: [
            UIColor.white.withAlphaComponent(0.02),
            UIColor.white
        ])
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "💖 Shorts"
        titleLabel.textColor = .suliInk
        titleLabel.font = UIFont.italicSystemFont(ofSize: 28).suliWithWeight(.black)

        let search = SuliJoyPillIconButton(assetName: "sulijoy_cove_search_mark")
        search.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
        coinButton.addTarget(self, action: #selector(openWallet), for: .touchUpInside)

        [titlePill, titleLabel, coinButton, search].forEach { container.addSubview($0) }
        NSLayoutConstraint.activate([
            titlePill.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titlePill.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            titlePill.widthAnchor.constraint(equalToConstant: 148),
            titlePill.heightAnchor.constraint(equalToConstant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: titlePill.leadingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: titlePill.centerYAnchor),

            search.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            search.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            search.widthAnchor.constraint(equalToConstant: 44),
            coinButton.trailingAnchor.constraint(equalTo: search.leadingAnchor, constant: -12),
            coinButton.centerYAnchor.constraint(equalTo: search.centerYAnchor)
        ])
        return container
    }

    private func fetchClips() {
        emptyLabel.isHidden = true
        loadingView.startAnimating()
        SuliJoyCoveMockService.shared.fetchShellClips { [weak self] result in
            guard let self else { return }
            self.loadingView.stopAnimating()
            guard result.code == 200 else {
                self.showToast(result.message)
                self.emptyLabel.text = result.message
                self.emptyLabel.isHidden = false
                return
            }
            self.clips = result.data ?? []
            self.emptyLabel.isHidden = !self.clips.isEmpty
            self.tableView.reloadData()
        }
    }

    @objc private func openWallet() {
        navigationController?.pushViewController(SuliJoyWalletViewController(), animated: true)
    }

    @objc private func openSearch() {
        openSuliJoyMessages()
    }

    private func updateClip(_ clip: SuliJoyShellClip) {
        guard let index = clips.firstIndex(where: { $0.clipID == clip.clipID }) else { return }
        clips[index] = clip
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }

    private func pauseCurrentClip() {
        playingCell?.pausePlayback()
        playingCell = nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clips.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        515
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuliJoyShortsClipCell", for: indexPath) as! SuliJoyShortsClipCell
        let clip = clips[indexPath.row]
        cell.configure(with: clip)
        cell.onPlay = { [weak self, weak cell] clipID in
            guard let self, let cell else { return }
            if self.playingCell !== cell {
                self.pauseCurrentClip()
            }
            if cell.togglePlayback() {
                self.playingCell = cell.isClipPlaying ? cell : nil
            } else {
                self.playingCell = nil
                self.showToast("Video unavailable.")
            }
        }
        cell.onFollow = { [weak self] clipID in
            SuliJoyCoveMockService.shared.toggleShellClipFollow(clipID: clipID) { result in
                if let updated = result.data {
                    self?.updateClip(updated)
                }
                self?.showToast(result.message)
            }
        }
        cell.onLike = { [weak self] clipID in
            SuliJoyCoveMockService.shared.toggleShellClipLike(clipID: clipID) { result in
                if let updated = result.data {
                    self?.updateClip(updated)
                } else {
                    self?.showToast(result.message)
                }
            }
        }
        cell.onComment = { [weak self] clipID in
            self?.presentCommentInput(clipID: clipID)
        }
        cell.onReport = { [weak self, weak cell] clipID in
            self?.presentReportSheet(clipID: clipID, sourceView: cell?.reportSourceView)
        }
        cell.onAuthor = { [weak self] creatorName in
            self?.openVisitor(displayName: creatorName)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let clipCell = cell as? SuliJoyShortsClipCell, playingCell === clipCell {
            pauseCurrentClip()
        } else {
            (cell as? SuliJoyShortsClipCell)?.pausePlayback()
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pauseCurrentClip()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pauseCurrentClip()
        let detail = SuliJoyClipDetailViewController(clipID: clips[indexPath.row].clipID)
        detail.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detail, animated: true)
    }

    private func presentCommentInput(clipID: String) {
        let alert = UIAlertController(title: "Comment", message: nil, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Comment something"
            field.autocapitalizationType = .sentences
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Send", style: .default) { [weak self, weak alert] _ in
            let text = alert?.textFields?.first?.text ?? ""
            SuliJoyCoveMockService.shared.addShellClipComment(clipID: clipID, text: text) { result in
                guard let self else { return }
                if let updated = result.data {
                    self.updateClip(updated)
                }
                self.showToast(result.message)
            }
        })
        present(alert, animated: true)
    }

    private func presentReportSheet(clipID: String, sourceView: UIView?) {
        guard let clip = clips.first(where: { $0.clipID == clipID }) else { return }
        presentSuliJoyModerationMenu { [weak self] in
            self?.presentSuliJoyReportSheet(target: .shellClip(clipID: clipID))
        } block: { [weak self] in
            let visitorID = SuliJoyLagoonVisitor.visitorID(for: clip.creator.displayName)
            SuliJoyCoveMockService.shared.blockLagoonVisitor(visitorID: visitorID) { result in
                self?.showToast(result.message)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.fetchClips()
            }
        }
    }

    private func openVisitor(displayName: String) {
        let visitor = SuliJoyIslandVisitorProfileViewController(displayName: displayName)
        navigationController?.pushViewController(visitor, animated: true)
    }
}

final class SuliJoyShortsClipCell: UITableViewCell {
    var onPlay: ((String) -> Void)?
    var onFollow: ((String) -> Void)?
    var onLike: ((String) -> Void)?
    var onComment: ((String) -> Void)?
    var onReport: ((String) -> Void)?
    var onAuthor: ((String) -> Void)?

    var reportSourceView: UIView { reportButton }
    var isClipPlaying: Bool { player != nil }

    private let card = UIView()
    private let avatarView = UIImageView()
    private let followButton = UIButton(type: .custom)
    private let nameLabel = UILabel()
    private let captionLabel = UILabel()
    private let reportButton = UIButton(type: .system)
    private let videoContainer = UIView()
    private let thumbnailView = UIImageView()
    private let playButton = UIButton(type: .custom)
    private let likeButton = UIButton(type: .system)
    private let commentButton = UIButton(type: .system)
    private let likeCountLabel = UILabel()
    private let commentCountLabel = UILabel()
    private let commentInput = UIControl()
    private let commentPlaceholder = UILabel()
    private let sendView = UIImageView()
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var clip: SuliJoyShellClip?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        pausePlayback()
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        thumbnailView.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = videoContainer.bounds
    }

    private func buildUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 22
        card.clipsToBounds = true
        contentView.addSubview(card)

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 19
        avatarView.isUserInteractionEnabled = true
        avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(authorNow)))

        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.setImage(UIImage(named: "sulijoy_feed_follow_plus")?.withRenderingMode(.alwaysOriginal), for: .normal)
        followButton.imageView?.contentMode = .scaleAspectFit
        followButton.addTarget(self, action: #selector(followNow), for: .touchUpInside)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 22, weight: .black)
        nameLabel.textColor = .suliInk
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(authorNow)))

        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        captionLabel.textColor = .suliInk
        captionLabel.numberOfLines = 2

        reportButton.translatesAutoresizingMaskIntoConstraints = false
        reportButton.setImage(UIImage(systemName: "exclamationmark.triangle"), for: .normal)
        reportButton.tintColor = UIColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 1)
        reportButton.addTarget(self, action: #selector(reportNow), for: .touchUpInside)

        videoContainer.translatesAutoresizingMaskIntoConstraints = false
        videoContainer.backgroundColor = UIColor(red: 1, green: 0.90, blue: 0.78, alpha: 1)
        videoContainer.layer.cornerRadius = 18
        videoContainer.clipsToBounds = true

        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailView.contentMode = .scaleAspectFill
        thumbnailView.clipsToBounds = true

        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.backgroundColor = UIColor.black.withAlphaComponent(0.20)
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.borderWidth = 4
        playButton.layer.cornerRadius = 34
        playButton.tintColor = .white
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.addTarget(self, action: #selector(playNow), for: .touchUpInside)

        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(named: "sulijoy_feed_like_idle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.addTarget(self, action: #selector(likeNow), for: .touchUpInside)

        commentButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.setImage(UIImage(named: "sulijoy_feed_comment_mark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        commentButton.addTarget(self, action: #selector(commentNow), for: .touchUpInside)

        [likeCountLabel, commentCountLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
            $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            $0.textAlignment = .center
        }

        commentInput.translatesAutoresizingMaskIntoConstraints = false
        commentInput.backgroundColor = .white
        commentInput.layer.cornerRadius = 17
        commentInput.layer.borderWidth = 1
        commentInput.layer.borderColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1).cgColor
        commentInput.addTarget(self, action: #selector(commentNow), for: .touchUpInside)

        commentPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        commentPlaceholder.text = "Comment something"
        commentPlaceholder.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1)
        commentPlaceholder.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        sendView.translatesAutoresizingMaskIntoConstraints = false
        sendView.image = UIImage(named: "sulijoy_feed_comment_send_mark") ?? UIImage(named: "sulijoy_feed_send_mark")
        sendView.contentMode = .scaleAspectFit

        videoContainer.addSubview(thumbnailView)
        videoContainer.addSubview(playButton)
        commentInput.addSubview(commentPlaceholder)
        commentInput.addSubview(sendView)
        [avatarView, followButton, nameLabel, captionLabel, reportButton, videoContainer, likeButton, likeCountLabel, commentButton, commentCountLabel, commentInput].forEach {
            card.addSubview($0)
        }

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            avatarView.topAnchor.constraint(equalTo: card.topAnchor, constant: 24),
            avatarView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            avatarView.widthAnchor.constraint(equalToConstant: 38),
            avatarView.heightAnchor.constraint(equalToConstant: 38),

            followButton.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            followButton.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: -2),
            followButton.widthAnchor.constraint(equalToConstant: 44),
            followButton.heightAnchor.constraint(equalToConstant: 30),

            nameLabel.topAnchor.constraint(equalTo: avatarView.topAnchor, constant: 2),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 18),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: reportButton.leadingAnchor, constant: -12),

            captionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            captionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            captionLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -28),

            reportButton.topAnchor.constraint(equalTo: card.topAnchor, constant: 22),
            reportButton.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            reportButton.widthAnchor.constraint(equalToConstant: 30),
            reportButton.heightAnchor.constraint(equalToConstant: 30),

            videoContainer.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 16),
            videoContainer.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            videoContainer.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            videoContainer.heightAnchor.constraint(equalTo: videoContainer.widthAnchor),
            thumbnailView.topAnchor.constraint(equalTo: videoContainer.topAnchor),
            thumbnailView.leadingAnchor.constraint(equalTo: videoContainer.leadingAnchor),
            thumbnailView.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor),
            thumbnailView.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor),
            playButton.centerXAnchor.constraint(equalTo: videoContainer.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: videoContainer.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 68),
            playButton.heightAnchor.constraint(equalToConstant: 68),

            likeButton.topAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: 12),
            likeButton.leadingAnchor.constraint(equalTo: videoContainer.leadingAnchor, constant: 8),
            likeButton.widthAnchor.constraint(equalToConstant: 32),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            likeCountLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: -2),
            likeCountLabel.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor),

            commentButton.topAnchor.constraint(equalTo: likeButton.topAnchor),
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 34),
            commentButton.widthAnchor.constraint(equalToConstant: 32),
            commentButton.heightAnchor.constraint(equalToConstant: 30),
            commentCountLabel.topAnchor.constraint(equalTo: commentButton.bottomAnchor, constant: -2),
            commentCountLabel.centerXAnchor.constraint(equalTo: commentButton.centerXAnchor),

            commentInput.topAnchor.constraint(equalTo: videoContainer.bottomAnchor, constant: 14),
            commentInput.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 28),
            commentInput.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor, constant: -4),
            commentInput.heightAnchor.constraint(equalToConstant: 38),
            commentInput.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -18),
            commentPlaceholder.leadingAnchor.constraint(equalTo: commentInput.leadingAnchor, constant: 14),
            commentPlaceholder.centerYAnchor.constraint(equalTo: commentInput.centerYAnchor),
            sendView.trailingAnchor.constraint(equalTo: commentInput.trailingAnchor, constant: -14),
            sendView.centerYAnchor.constraint(equalTo: commentInput.centerYAnchor),
            sendView.widthAnchor.constraint(equalToConstant: 18),
            sendView.heightAnchor.constraint(equalToConstant: 18),
            commentPlaceholder.trailingAnchor.constraint(lessThanOrEqualTo: sendView.leadingAnchor, constant: -8)
        ])
    }

    func configure(with clip: SuliJoyShellClip) {
        self.clip = clip
        avatarView.image = UIImage.suliJoyAssetOrLocal(named: clip.creator.avatarAssetName)
        nameLabel.text = clip.creator.displayName
        captionLabel.text = clip.caption
        likeCountLabel.text = "\(clip.likeCount)"
        commentCountLabel.text = "\(clip.commentCount)"
        likeButton.setImage(UIImage(named: clip.isLiked ? "sulijoy_feed_like_active" : "sulijoy_feed_like_idle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        followButton.alpha = clip.isFollowed ? 0.55 : 1
        reportButton.tintColor = clip.isReportedLocally ? UIColor(red: 1, green: 0.42, blue: 0.38, alpha: 1) : UIColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 1)
        thumbnailView.image = UIImage.suliJoyAssetOrLocal(named: clip.media.fallbackCoverAssetName ?? "")
        playButton.alpha = 1
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        generateThumbnail(for: clip)
    }

    @discardableResult
    func togglePlayback() -> Bool {
        guard let clip else { return false }
        if player != nil {
            pausePlayback()
            return true
        }
        guard let url = Self.videoURL(for: clip.media.localVideoFileName) else { return false }
        let player = AVPlayer(url: url)
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        layer.frame = videoContainer.bounds
        videoContainer.layer.insertSublayer(layer, below: playButton.layer)
        self.player = player
        self.playerLayer = layer
        playButton.alpha = 0.28
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        player.play()
        return true
    }

    func pausePlayback() {
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        playButton.alpha = 1
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }

    private func generateThumbnail(for clip: SuliJoyShellClip) {
        guard let url = Self.videoURL(for: clip.media.localVideoFileName) else { return }
        let requestedID = clip.clipID
        DispatchQueue.global(qos: .userInitiated).async {
            let asset = AVURLAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            generator.maximumSize = CGSize(width: 720, height: 720)
            guard let cgImage = try? generator.copyCGImage(at: CMTime(seconds: 0.25, preferredTimescale: 600), actualTime: nil) else {
                return
            }
            let image = UIImage(cgImage: cgImage)
            DispatchQueue.main.async { [weak self] in
                guard self?.clip?.clipID == requestedID else { return }
                self?.thumbnailView.image = image
            }
        }
    }

    private static func videoURL(for fileName: String) -> URL? {
        if FileManager.default.fileExists(atPath: fileName) {
            return URL(fileURLWithPath: fileName)
        }
        return Bundle.main.url(forResource: fileName, withExtension: "mp4", subdirectory: "SuliJoyClips")
            ?? Bundle.main.url(forResource: fileName, withExtension: "mp4")
    }

    @objc private func playNow() {
        guard let clip else { return }
        onPlay?(clip.clipID)
    }

    @objc private func followNow() {
        guard let clip else { return }
        onFollow?(clip.clipID)
    }

    @objc private func likeNow() {
        guard let clip else { return }
        onLike?(clip.clipID)
    }

    @objc private func commentNow() {
        guard let clip else { return }
        onComment?(clip.clipID)
    }

    @objc private func reportNow() {
        guard let clip else { return }
        onReport?(clip.clipID)
    }

    @objc private func authorNow() {
        guard let clip else { return }
        onAuthor?(clip.creator.displayName)
    }
}
