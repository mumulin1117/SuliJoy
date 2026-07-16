import AVFoundation
import UIKit

final class SuliJoyClipDetailViewController: SuliJoyBaseIslandViewController {
    private let clipID: String
    private var clip: SuliJoyShellClip?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let header = UIView()
    private let avatarView = UIImageView()
    private let nameLabel = UILabel()
    private let followButton = UIButton(type: .custom)
    private let videoView = UIView()
    private let thumbnailView = UIImageView()
    private let playButton = UIButton(type: .custom)
    private let reportButton = UIButton(type: .system)
    private let floatingStats = UIStackView()
    private let likeButton = UIButton(type: .custom)
    private let likeCountLabel = UILabel()
    private let viewIcon = UIImageView()
    private let viewCountLabel = UILabel()
    private let captionLabel = UILabel()
    private let commentsTitle = UILabel()
    private let commentsStack = UIStackView()
    private let inputBar = UIView()
    private let inputField = UITextField()
    private let sendButton = UIButton(type: .custom)
    private var inputBottomConstraint: NSLayoutConstraint?

    init(clipID: String) {
        self.clipID = clipID
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        bindKeyboard()
        fetchDetail()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoView.bounds
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pausePlayback()
    }

    private func buildUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.showsVerticalScrollIndicator = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        inputBar.translatesAutoresizingMaskIntoConstraints = false
        inputBar.backgroundColor = .white
        view.addSubview(inputBar)
        inputBottomConstraint = inputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: inputBar.topAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            inputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputBar.heightAnchor.constraint(equalToConstant: 64),
            inputBottomConstraint!
        ])

        buildHeader()
        buildVideo()
        buildTextAndComments()
        buildInputBar()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tap)
    }

    private func buildHeader() {
        header.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(header)

        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.tintColor = .suliInk
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 18
        avatarView.isUserInteractionEnabled = true
        avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCreatorProfile)))

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .black)
        nameLabel.textColor = .suliInk
        nameLabel.isUserInteractionEnabled = true
        nameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCreatorProfile)))

        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitleColor(.white, for: .normal)
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
        followButton.layer.cornerRadius = 21
        followButton.clipsToBounds = true
        followButton.addTarget(self, action: #selector(toggleFollow), for: .touchUpInside)

        [back, avatarView, nameLabel, followButton].forEach { header.addSubview($0) }
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            header.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            header.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            header.heightAnchor.constraint(equalToConstant: 56),
            back.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            back.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            back.widthAnchor.constraint(equalToConstant: 34),
            back.heightAnchor.constraint(equalToConstant: 34),
            avatarView.leadingAnchor.constraint(equalTo: back.trailingAnchor, constant: 14),
            avatarView.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 36),
            avatarView.heightAnchor.constraint(equalToConstant: 36),
            nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 14),
            nameLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: followButton.leadingAnchor, constant: -10),
            followButton.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            followButton.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            followButton.widthAnchor.constraint(equalToConstant: 92),
            followButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }

    private func buildVideo() {
        videoView.translatesAutoresizingMaskIntoConstraints = false
        videoView.backgroundColor = UIColor(red: 1, green: 0.90, blue: 0.78, alpha: 1)
        videoView.layer.cornerRadius = 18
        videoView.clipsToBounds = true
        contentView.addSubview(videoView)

        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailView.contentMode = .scaleAspectFill
        thumbnailView.clipsToBounds = true

        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.backgroundColor = UIColor.black.withAlphaComponent(0.22)
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.borderWidth = 4
        playButton.layer.cornerRadius = 34
        playButton.tintColor = .white
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)

        reportButton.translatesAutoresizingMaskIntoConstraints = false
        reportButton.tintColor = .white
        reportButton.layer.borderColor = UIColor.white.cgColor
        reportButton.layer.borderWidth = 2
        reportButton.layer.cornerRadius = 14
        reportButton.setImage(UIImage(systemName: "exclamationmark"), for: .normal)
        reportButton.addTarget(self, action: #selector(reportClip), for: .touchUpInside)

        floatingStats.translatesAutoresizingMaskIntoConstraints = false
        floatingStats.axis = .vertical
        floatingStats.alignment = .center
        floatingStats.spacing = 8
        floatingStats.backgroundColor = UIColor.black.withAlphaComponent(0.36)
        floatingStats.layer.cornerRadius = 28
        floatingStats.isLayoutMarginsRelativeArrangement = true
        floatingStats.layoutMargins = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)

        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(named: "sulijoy_feed_like_idle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
        viewIcon.translatesAutoresizingMaskIntoConstraints = false
        viewIcon.image = UIImage(systemName: "eye.fill")
        viewIcon.tintColor = .white

        [likeCountLabel, viewCountLabel].forEach {
            $0.textColor = UIColor.white.withAlphaComponent(0.78)
            $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            $0.textAlignment = .center
        }

        floatingStats.addArrangedSubview(likeButton)
        floatingStats.addArrangedSubview(likeCountLabel)
        floatingStats.addArrangedSubview(viewIcon)
        floatingStats.addArrangedSubview(viewCountLabel)
        videoView.addSubview(thumbnailView)
        videoView.addSubview(playButton)
        videoView.addSubview(reportButton)
        videoView.addSubview(floatingStats)

        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 18),
            videoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            videoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            videoView.heightAnchor.constraint(equalTo: videoView.widthAnchor, multiplier: 1.34),
            thumbnailView.topAnchor.constraint(equalTo: videoView.topAnchor),
            thumbnailView.leadingAnchor.constraint(equalTo: videoView.leadingAnchor),
            thumbnailView.trailingAnchor.constraint(equalTo: videoView.trailingAnchor),
            thumbnailView.bottomAnchor.constraint(equalTo: videoView.bottomAnchor),
            playButton.centerXAnchor.constraint(equalTo: videoView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: videoView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 68),
            playButton.heightAnchor.constraint(equalToConstant: 68),
            reportButton.topAnchor.constraint(equalTo: videoView.topAnchor, constant: 14),
            reportButton.trailingAnchor.constraint(equalTo: videoView.trailingAnchor, constant: -14),
            reportButton.widthAnchor.constraint(equalToConstant: 30),
            reportButton.heightAnchor.constraint(equalToConstant: 30),
            floatingStats.trailingAnchor.constraint(equalTo: videoView.trailingAnchor, constant: -16),
            floatingStats.bottomAnchor.constraint(equalTo: videoView.bottomAnchor, constant: -22),
            floatingStats.widthAnchor.constraint(equalToConstant: 58),
            likeButton.widthAnchor.constraint(equalToConstant: 28),
            likeButton.heightAnchor.constraint(equalToConstant: 28),
            viewIcon.widthAnchor.constraint(equalToConstant: 24),
            viewIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func buildTextAndComments() {
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.textColor = UIColor.black.withAlphaComponent(0.82)
        captionLabel.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        captionLabel.numberOfLines = 0
        contentView.addSubview(captionLabel)

        commentsTitle.translatesAutoresizingMaskIntoConstraints = false
        commentsTitle.text = "Comments"
        commentsTitle.textColor = .suliInk
        commentsTitle.font = UIFont.systemFont(ofSize: 22, weight: .black)
        contentView.addSubview(commentsTitle)

        commentsStack.translatesAutoresizingMaskIntoConstraints = false
        commentsStack.axis = .vertical
        commentsStack.spacing = 14
        contentView.addSubview(commentsStack)

        NSLayoutConstraint.activate([
            captionLabel.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 22),
            captionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            captionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            commentsTitle.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 18),
            commentsTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            commentsStack.topAnchor.constraint(equalTo: commentsTitle.bottomAnchor, constant: 16),
            commentsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            commentsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            commentsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func buildInputBar() {
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.placeholder = "What do you do on weekends?"
        inputField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        inputField.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.98, alpha: 1)
        inputField.layer.cornerRadius = 22
        inputField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 1))
        inputField.leftViewMode = .always
        inputField.returnKeyType = .send
        inputField.addTarget(self, action: #selector(sendComment), for: .editingDidEndOnExit)

        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setImage((UIImage(named: "sulijoy_feed_comment_send_mark") ?? UIImage(named: "sulijoy_feed_send_mark"))?.withRenderingMode(.alwaysOriginal), for: .normal)
        sendButton.addTarget(self, action: #selector(sendComment), for: .touchUpInside)

        inputBar.addSubview(inputField)
        inputBar.addSubview(sendButton)
        NSLayoutConstraint.activate([
            inputField.leadingAnchor.constraint(equalTo: inputBar.leadingAnchor, constant: 30),
            inputField.centerYAnchor.constraint(equalTo: inputBar.centerYAnchor),
            inputField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -18),
            inputField.heightAnchor.constraint(equalToConstant: 44),
            sendButton.trailingAnchor.constraint(equalTo: inputBar.trailingAnchor, constant: -30),
            sendButton.centerYAnchor.constraint(equalTo: inputBar.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 44),
            sendButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func fetchDetail() {
        SuliJoyCoveMockService.shared.fetchShellClipDetail(clipID: clipID) { [weak self] result in
            guard let self else { return }
            guard let clip = result.data else {
                self.showToast(result.message)
                return
            }
            self.apply(clip)
        }
    }

    private func apply(_ clip: SuliJoyShellClip) {
        self.clip = clip
        avatarView.image = UIImage.suliJoyAssetOrLocal(named: clip.creator.avatarAssetName)
        nameLabel.text = clip.creator.displayName
        captionLabel.text = clip.caption
        followButton.setTitle(clip.isFollowed ? "Following" : "Follow", for: .normal)
        followButton.alpha = clip.isFollowed ? 0.72 : 1
        likeCountLabel.text = "\(clip.likeCount)"
        viewCountLabel.text = "\(min(9, clip.likeCount + clip.commentCount))"
        likeButton.setImage(UIImage(named: clip.isLiked ? "sulijoy_feed_like_active" : "sulijoy_feed_like_idle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        thumbnailView.image = UIImage.suliJoyAssetOrLocal(named: clip.media.fallbackCoverAssetName ?? "")
        setFollowGradient()
        generateThumbnail(for: clip)
        renderComments(clip.comments)
    }

    private func renderComments(_ comments: [SuliJoyShellClipComment]) {
        commentsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        comments.forEach { comment in
            let card = SuliJoyClipCommentCard(comment: comment)
            card.onReport = { [weak self] commentID, sourceView in
                self?.reportComment(commentID: commentID, sourceView: sourceView)
            }
            commentsStack.addArrangedSubview(card)
        }
    }

    private func setFollowGradient() {
        followButton.layer.sublayers?.filter { $0.name == "sulijoy_clip_follow_gradient" }.forEach { $0.removeFromSuperlayer() }
        let gradient = CAGradientLayer()
        gradient.name = "sulijoy_clip_follow_gradient"
        gradient.colors = [
            UIColor(red: 0.54, green: 0.45, blue: 1, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.29, blue: 0.96, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = CGRect(x: 0, y: 0, width: 92, height: 42)
        followButton.layer.insertSublayer(gradient, at: 0)
    }

    private func bindKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func videoURL(for fileName: String) -> URL? {
        if FileManager.default.fileExists(atPath: fileName) {
            return URL(fileURLWithPath: fileName)
        }
        return Bundle.main.url(forResource: fileName, withExtension: "mp4", subdirectory: "SuliJoyClips")
            ?? Bundle.main.url(forResource: fileName, withExtension: "mp4")
    }

    private func generateThumbnail(for clip: SuliJoyShellClip) {
        guard let url = videoURL(for: clip.media.localVideoFileName) else { return }
        let requestedID = clip.clipID
        DispatchQueue.global(qos: .userInitiated).async {
            let asset = AVURLAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            generator.maximumSize = CGSize(width: 720, height: 960)
            guard let cgImage = try? generator.copyCGImage(at: CMTime(seconds: 0.25, preferredTimescale: 600), actualTime: nil) else { return }
            let image = UIImage(cgImage: cgImage)
            DispatchQueue.main.async { [weak self] in
                guard self?.clip?.clipID == requestedID else { return }
                self?.thumbnailView.image = image
            }
        }
    }

    private func pausePlayback() {
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        playButton.alpha = 1
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func togglePlayback() {
        guard let clip else { return }
        if player != nil {
            pausePlayback()
            return
        }
        guard let url = videoURL(for: clip.media.localVideoFileName) else {
            showToast("Video unavailable.")
            return
        }
        let player = AVPlayer(url: url)
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        layer.frame = videoView.bounds
        videoView.layer.insertSublayer(layer, above: thumbnailView.layer)
        self.player = player
        self.playerLayer = layer
        playButton.alpha = 0.28
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        player.play()
    }

    @objc private func toggleFollow() {
        guard let clip else { return }
        SuliJoyCoveMockService.shared.toggleShellClipFollow(creatorName: clip.creator.displayName) { [weak self] result in
            guard let self else { return }
            self.showToast(result.message)
            NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
            self.fetchDetail()
        }
    }

    @objc private func openCreatorProfile() {
        guard let clip else { return }
        let visitor = SuliJoyIslandVisitorProfileViewController(displayName: clip.creator.displayName)
        navigationController?.pushViewController(visitor, animated: true)
    }

    @objc private func toggleLike() {
        SuliJoyCoveMockService.shared.toggleShellClipLike(clipID: clipID) { [weak self] result in
            guard let self else { return }
            if let updated = result.data {
                self.apply(updated)
            } else {
                self.showToast(result.message)
            }
        }
    }

    @objc private func sendComment() {
        let text = inputField.text ?? ""
        SuliJoyCoveMockService.shared.addShellClipComment(clipID: clipID, text: text) { [weak self] result in
            guard let self else { return }
            guard let updated = result.data else {
                self.showToast(result.message)
                return
            }
            self.inputField.text = nil
            self.apply(updated)
            self.showToast(result.message)
            self.scrollView.layoutIfNeeded()
            let bottom = CGPoint(x: 0, y: max(0, self.scrollView.contentSize.height - self.scrollView.bounds.height + self.scrollView.adjustedContentInset.bottom))
            self.scrollView.setContentOffset(bottom, animated: true)
        }
    }

    @objc private func reportClip() {
        guard let clip else { return }
        presentSuliJoyModerationMenu { [weak self] in
            guard let self else { return }
            self.presentSuliJoyReportSheet(target: .shellClip(clipID: self.clipID)) { [weak self] in
                self?.fetchDetail()
            }
        } block: { [weak self] in
            let visitorID = SuliJoyLagoonVisitor.visitorID(for: clip.creator.displayName)
            SuliJoyCoveMockService.shared.blockLagoonVisitor(visitorID: visitorID) { result in
                self?.showToast(result.message)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func reportComment(commentID: String, sourceView: UIView) {
        guard let clip else { return }
        presentSuliJoyModerationMenu { [weak self] in
            guard let self else { return }
            self.presentSuliJoyReportSheet(target: .shellClipComment(clipID: self.clipID, commentID: commentID)) { [weak self] in
                self?.fetchDetail()
            }
        } block: { [weak self] in
            let visitorID = SuliJoyLagoonVisitor.visitorID(for: clip.creator.displayName)
            SuliJoyCoveMockService.shared.blockLagoonVisitor(visitorID: visitorID) { result in
                self?.showToast(result.message)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    @objc private func keyboardWillShow(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let overlap = max(0, view.bounds.maxY - view.convert(frame, from: nil).minY)
        inputBottomConstraint?.constant = -overlap + view.safeAreaInsets.bottom
        scrollView.contentInset.bottom = overlap + 18
        scrollView.scrollIndicatorInsets.bottom = overlap + 18
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide() {
        inputBottomConstraint?.constant = 0
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

final class SuliJoyClipCommentCard: UIView {
    var onReport: ((String, UIView) -> Void)?
    private let comment: SuliJoyShellClipComment
    private let reportButton = UIButton(type: .system)

    init(comment: SuliJoyShellClipComment) {
        self.comment = comment
        super.init(frame: .zero)
        buildUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 16
        clipsToBounds = true

        let avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.image = UIImage.suliJoyAssetOrLocal(named: comment.commenterAvatarAssetName)
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 15

        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = comment.commenterName
        name.textColor = .suliInk
        name.font = UIFont.systemFont(ofSize: 16, weight: .black)

        let body = UILabel()
        body.translatesAutoresizingMaskIntoConstraints = false
        body.text = comment.text
        body.textColor = UIColor.black.withAlphaComponent(0.48)
        body.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        body.numberOfLines = 2

        let time = UILabel()
        time.translatesAutoresizingMaskIntoConstraints = false
        time.text = comment.timeAgo
        time.textColor = UIColor.black.withAlphaComponent(0.30)
        time.font = UIFont.systemFont(ofSize: 13, weight: .regular)

        reportButton.translatesAutoresizingMaskIntoConstraints = false
        reportButton.setImage(UIImage(systemName: "exclamationmark.triangle"), for: .normal)
        reportButton.tintColor = comment.isReportedLocally ? UIColor(red: 1, green: 0.42, blue: 0.38, alpha: 1) : UIColor(red: 0.87, green: 0.80, blue: 0.74, alpha: 1)
        reportButton.addTarget(self, action: #selector(reportNow), for: .touchUpInside)

        [avatar, name, body, time, reportButton].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 76),
            avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            avatar.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            avatar.widthAnchor.constraint(equalToConstant: 30),
            avatar.heightAnchor.constraint(equalToConstant: 30),
            name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 14),
            name.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            name.trailingAnchor.constraint(lessThanOrEqualTo: reportButton.leadingAnchor, constant: -10),
            body.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            body.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 2),
            body.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            time.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            time.topAnchor.constraint(equalTo: body.bottomAnchor, constant: 2),
            time.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12),
            reportButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            reportButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            reportButton.widthAnchor.constraint(equalToConstant: 30),
            reportButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc private func reportNow() {
        onReport?(comment.commentID, reportButton)
    }
}
