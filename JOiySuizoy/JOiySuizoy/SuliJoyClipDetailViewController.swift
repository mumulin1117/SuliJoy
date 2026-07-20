import AVFoundation
import UIKit

final class SuliJoyClipDetailViewController: SuliJoyTropicCanvasController {
    private let reefClipID: String
    private var reefClip: SuliJoyShellClip?
    private var shorePlayer: AVPlayer?
    private var shorePlayerLayer: AVPlayerLayer?

    private let reefScrollView = UIScrollView()
    private let reefContentView = UIView()
    private let reefHeader = UIView()
    private let creatorAvatarView = UIImageView()
    private let creatorNameLabel = UILabel()
    private let lagoonFollowButton = UIButton(type: .custom)
    private let reefCinemaView = UIView()
    private let reefPosterView = UIImageView()
    private let reefPlayButton = UIButton(type: .custom)
    private let reefFlagButton = UIButton(type: .system)
    private let reefFloatingStats = UIStackView()
    private let reefLikeButton = UIButton(type: .custom)
    private let reefLikeCountLabel = UILabel()
    private let reefViewMark = UIImageView()
    private let reefViewCountLabel = UILabel()
    private let reefCaptionLabel = UILabel()
    private let reefCommentsTitle = UILabel()
    private let reefCommentsStack = UIStackView()
    private let reefInputBar = UIView()
    private let reefInputField = UITextField()
    private let reefSendButton = UIButton(type: .custom)
    private var reefInputBottomConstraint: NSLayoutConstraint?

    init(clipID reefClipID: String) {
        self.reefClipID = reefClipID
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        raiseReefDetailScene()
        bindReefKeyboard()
        fetchReefDetail()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shorePlayerLayer?.frame = reefCinemaView.bounds
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseReefPlayback()
    }

    private func raiseReefDetailScene() {
        reefScrollView.translatesAutoresizingMaskIntoConstraints = false
        reefScrollView.keyboardDismissMode = .interactive
        reefScrollView.showsVerticalScrollIndicator = false
        reefContentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reefScrollView)
        reefScrollView.addSubview(reefContentView)

        reefInputBar.translatesAutoresizingMaskIntoConstraints = false
        reefInputBar.backgroundColor = .white
        view.addSubview(reefInputBar)
        reefInputBottomConstraint = reefInputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        NSLayoutConstraint.activate([
            reefScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            reefScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reefScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reefScrollView.bottomAnchor.constraint(equalTo: reefInputBar.topAnchor),
            reefContentView.topAnchor.constraint(equalTo: reefScrollView.contentLayoutGuide.topAnchor),
            reefContentView.leadingAnchor.constraint(equalTo: reefScrollView.contentLayoutGuide.leadingAnchor),
            reefContentView.trailingAnchor.constraint(equalTo: reefScrollView.contentLayoutGuide.trailingAnchor),
            reefContentView.bottomAnchor.constraint(equalTo: reefScrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            reefContentView.widthAnchor.constraint(equalTo: reefScrollView.frameLayoutGuide.widthAnchor),
            reefInputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reefInputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reefInputBar.heightAnchor.constraint(equalToConstant: 64),
            reefInputBottomConstraint!
        ])

        anchorReefHeader()
        anchorReefCinema()
        anchorReefCopyAndReplies()
        anchorReefInputDock()

        let tap = UITapGestureRecognizer(target: self, action: #selector(foldReefKeyboard))
        tap.cancelsTouchesInView = false
        reefScrollView.addGestureRecognizer(tap)
    }

    private func anchorReefHeader() {
        reefHeader.translatesAutoresizingMaskIntoConstraints = false
        reefContentView.addSubview(reefHeader)

        let shorelineReturnControl = UIButton(type: .system)
        shorelineReturnControl.translatesAutoresizingMaskIntoConstraints = false
        shorelineReturnControl.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        shorelineReturnControl.tintColor = .suliInk
        shorelineReturnControl.addTarget(self, action: #selector(driftBackToClips), for: .touchUpInside)

        creatorAvatarView.translatesAutoresizingMaskIntoConstraints = false
        creatorAvatarView.contentMode = .scaleAspectFill
        creatorAvatarView.clipsToBounds = true
        creatorAvatarView.layer.cornerRadius = 18
        creatorAvatarView.isUserInteractionEnabled = true
        creatorAvatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openReefCreatorProfile)))

        creatorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        creatorNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .black)
        creatorNameLabel.textColor = .suliInk
        creatorNameLabel.isUserInteractionEnabled = true
        creatorNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openReefCreatorProfile)))

        lagoonFollowButton.translatesAutoresizingMaskIntoConstraints = false
        lagoonFollowButton.setTitle("Follow", for: .normal)
        lagoonFollowButton.setTitleColor(.white, for: .normal)
        lagoonFollowButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
        lagoonFollowButton.layer.cornerRadius = 21
        lagoonFollowButton.clipsToBounds = true
        lagoonFollowButton.addTarget(self, action: #selector(toggleReefFollow), for: .touchUpInside)

        [shorelineReturnControl, creatorAvatarView, creatorNameLabel, lagoonFollowButton].forEach { reefHeader.addSubview($0) }
        NSLayoutConstraint.activate([
            reefHeader.topAnchor.constraint(equalTo: reefContentView.topAnchor, constant: 8),
            reefHeader.leadingAnchor.constraint(equalTo: reefContentView.leadingAnchor, constant: 20),
            reefHeader.trailingAnchor.constraint(equalTo: reefContentView.trailingAnchor, constant: -20),
            reefHeader.heightAnchor.constraint(equalToConstant: 56),
            shorelineReturnControl.leadingAnchor.constraint(equalTo: reefHeader.leadingAnchor),
            shorelineReturnControl.centerYAnchor.constraint(equalTo: reefHeader.centerYAnchor),
            shorelineReturnControl.widthAnchor.constraint(equalToConstant: 34),
            shorelineReturnControl.heightAnchor.constraint(equalToConstant: 34),
            creatorAvatarView.leadingAnchor.constraint(equalTo: shorelineReturnControl.trailingAnchor, constant: 14),
            creatorAvatarView.centerYAnchor.constraint(equalTo: reefHeader.centerYAnchor),
            creatorAvatarView.widthAnchor.constraint(equalToConstant: 36),
            creatorAvatarView.heightAnchor.constraint(equalToConstant: 36),
            creatorNameLabel.leadingAnchor.constraint(equalTo: creatorAvatarView.trailingAnchor, constant: 14),
            creatorNameLabel.centerYAnchor.constraint(equalTo: reefHeader.centerYAnchor),
            creatorNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: lagoonFollowButton.leadingAnchor, constant: -10),
            lagoonFollowButton.trailingAnchor.constraint(equalTo: reefHeader.trailingAnchor),
            lagoonFollowButton.centerYAnchor.constraint(equalTo: reefHeader.centerYAnchor),
            lagoonFollowButton.widthAnchor.constraint(equalToConstant: 92),
            lagoonFollowButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }

    private func anchorReefCinema() {
        reefCinemaView.translatesAutoresizingMaskIntoConstraints = false
        reefCinemaView.backgroundColor = UIColor(red: 1, green: 0.90, blue: 0.78, alpha: 1)
        reefCinemaView.layer.cornerRadius = 18
        reefCinemaView.clipsToBounds = true
        reefContentView.addSubview(reefCinemaView)

        reefPosterView.translatesAutoresizingMaskIntoConstraints = false
        reefPosterView.contentMode = .scaleAspectFill
        reefPosterView.clipsToBounds = true

        reefPlayButton.translatesAutoresizingMaskIntoConstraints = false
        reefPlayButton.backgroundColor = UIColor.black.withAlphaComponent(0.22)
        reefPlayButton.layer.borderColor = UIColor.white.cgColor
        reefPlayButton.layer.borderWidth = 4
        reefPlayButton.layer.cornerRadius = 34
        reefPlayButton.tintColor = .white
        reefPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        reefPlayButton.addTarget(self, action: #selector(toggleReefPlayback), for: .touchUpInside)

        reefFlagButton.translatesAutoresizingMaskIntoConstraints = false
        reefFlagButton.tintColor = .white
        reefFlagButton.layer.borderColor = UIColor.white.cgColor
        reefFlagButton.layer.borderWidth = 2
        reefFlagButton.layer.cornerRadius = 14
        reefFlagButton.setImage(UIImage(systemName: "exclamationmark"), for: .normal)
        reefFlagButton.addTarget(self, action: #selector(openReefClipModeration), for: .touchUpInside)

        reefFloatingStats.translatesAutoresizingMaskIntoConstraints = false
        reefFloatingStats.axis = .vertical
        reefFloatingStats.alignment = .center
        reefFloatingStats.spacing = 8
        reefFloatingStats.backgroundColor = UIColor.black.withAlphaComponent(0.36)
        reefFloatingStats.layer.cornerRadius = 28
        reefFloatingStats.isLayoutMarginsRelativeArrangement = true
        reefFloatingStats.layoutMargins = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)

        reefLikeButton.translatesAutoresizingMaskIntoConstraints = false
        reefLikeButton.setImage(UIImage(named: "sulijoy_feed_like_idle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        reefLikeButton.addTarget(self, action: #selector(toggleReefLike), for: .touchUpInside)
        reefViewMark.translatesAutoresizingMaskIntoConstraints = false
        reefViewMark.image = UIImage(systemName: "eye.fill")
        reefViewMark.tintColor = .white

        [reefLikeCountLabel, reefViewCountLabel].forEach {
            $0.textColor = UIColor.white.withAlphaComponent(0.78)
            $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            $0.textAlignment = .center
        }

        reefFloatingStats.addArrangedSubview(reefLikeButton)
        reefFloatingStats.addArrangedSubview(reefLikeCountLabel)
        reefFloatingStats.addArrangedSubview(reefViewMark)
        reefFloatingStats.addArrangedSubview(reefViewCountLabel)
        reefCinemaView.addSubview(reefPosterView)
        reefCinemaView.addSubview(reefPlayButton)
        reefCinemaView.addSubview(reefFlagButton)
        reefCinemaView.addSubview(reefFloatingStats)

        NSLayoutConstraint.activate([
            reefCinemaView.topAnchor.constraint(equalTo: reefHeader.bottomAnchor, constant: 18),
            reefCinemaView.leadingAnchor.constraint(equalTo: reefContentView.leadingAnchor, constant: 30),
            reefCinemaView.trailingAnchor.constraint(equalTo: reefContentView.trailingAnchor, constant: -30),
            reefCinemaView.heightAnchor.constraint(equalTo: reefCinemaView.widthAnchor, multiplier: 1.34),
            reefPosterView.topAnchor.constraint(equalTo: reefCinemaView.topAnchor),
            reefPosterView.leadingAnchor.constraint(equalTo: reefCinemaView.leadingAnchor),
            reefPosterView.trailingAnchor.constraint(equalTo: reefCinemaView.trailingAnchor),
            reefPosterView.bottomAnchor.constraint(equalTo: reefCinemaView.bottomAnchor),
            reefPlayButton.centerXAnchor.constraint(equalTo: reefCinemaView.centerXAnchor),
            reefPlayButton.centerYAnchor.constraint(equalTo: reefCinemaView.centerYAnchor),
            reefPlayButton.widthAnchor.constraint(equalToConstant: 68),
            reefPlayButton.heightAnchor.constraint(equalToConstant: 68),
            reefFlagButton.topAnchor.constraint(equalTo: reefCinemaView.topAnchor, constant: 14),
            reefFlagButton.trailingAnchor.constraint(equalTo: reefCinemaView.trailingAnchor, constant: -14),
            reefFlagButton.widthAnchor.constraint(equalToConstant: 30),
            reefFlagButton.heightAnchor.constraint(equalToConstant: 30),
            reefFloatingStats.trailingAnchor.constraint(equalTo: reefCinemaView.trailingAnchor, constant: -16),
            reefFloatingStats.bottomAnchor.constraint(equalTo: reefCinemaView.bottomAnchor, constant: -22),
            reefFloatingStats.widthAnchor.constraint(equalToConstant: 58),
            reefLikeButton.widthAnchor.constraint(equalToConstant: 28),
            reefLikeButton.heightAnchor.constraint(equalToConstant: 28),
            reefViewMark.widthAnchor.constraint(equalToConstant: 24),
            reefViewMark.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func anchorReefCopyAndReplies() {
        reefCaptionLabel.translatesAutoresizingMaskIntoConstraints = false
        reefCaptionLabel.textColor = UIColor.black.withAlphaComponent(0.82)
        reefCaptionLabel.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        reefCaptionLabel.numberOfLines = 0
        reefContentView.addSubview(reefCaptionLabel)

        reefCommentsTitle.translatesAutoresizingMaskIntoConstraints = false
        reefCommentsTitle.text = "Comments"
        reefCommentsTitle.textColor = .suliInk
        reefCommentsTitle.font = UIFont.systemFont(ofSize: 22, weight: .black)
        reefContentView.addSubview(reefCommentsTitle)

        reefCommentsStack.translatesAutoresizingMaskIntoConstraints = false
        reefCommentsStack.axis = .vertical
        reefCommentsStack.spacing = 14
        reefContentView.addSubview(reefCommentsStack)

        NSLayoutConstraint.activate([
            reefCaptionLabel.topAnchor.constraint(equalTo: reefCinemaView.bottomAnchor, constant: 22),
            reefCaptionLabel.leadingAnchor.constraint(equalTo: reefContentView.leadingAnchor, constant: 30),
            reefCaptionLabel.trailingAnchor.constraint(equalTo: reefContentView.trailingAnchor, constant: -30),
            reefCommentsTitle.topAnchor.constraint(equalTo: reefCaptionLabel.bottomAnchor, constant: 18),
            reefCommentsTitle.leadingAnchor.constraint(equalTo: reefContentView.leadingAnchor, constant: 40),
            reefCommentsStack.topAnchor.constraint(equalTo: reefCommentsTitle.bottomAnchor, constant: 16),
            reefCommentsStack.leadingAnchor.constraint(equalTo: reefContentView.leadingAnchor, constant: 40),
            reefCommentsStack.trailingAnchor.constraint(equalTo: reefContentView.trailingAnchor, constant: -40),
            reefCommentsStack.bottomAnchor.constraint(equalTo: reefContentView.bottomAnchor)
        ])
    }

    private func anchorReefInputDock() {
        reefInputField.translatesAutoresizingMaskIntoConstraints = false
        reefInputField.placeholder = "What do you do on weekends?"
        reefInputField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        reefInputField.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 0.98, alpha: 1)
        reefInputField.layer.cornerRadius = 22
        reefInputField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 1))
        reefInputField.leftViewMode = .always
        reefInputField.returnKeyType = .send
        reefInputField.addTarget(self, action: #selector(sendReefComment), for: .editingDidEndOnExit)

        reefSendButton.translatesAutoresizingMaskIntoConstraints = false
        reefSendButton.setImage((UIImage(named: "sulijoy_feed_comment_send_mark") ?? UIImage(named: "sulijoy_feed_send_mark"))?.withRenderingMode(.alwaysOriginal), for: .normal)
        reefSendButton.addTarget(self, action: #selector(sendReefComment), for: .touchUpInside)

        reefInputBar.addSubview(reefInputField)
        reefInputBar.addSubview(reefSendButton)
        NSLayoutConstraint.activate([
            reefInputField.leadingAnchor.constraint(equalTo: reefInputBar.leadingAnchor, constant: 30),
            reefInputField.centerYAnchor.constraint(equalTo: reefInputBar.centerYAnchor),
            reefInputField.trailingAnchor.constraint(equalTo: reefSendButton.leadingAnchor, constant: -18),
            reefInputField.heightAnchor.constraint(equalToConstant: 44),
            reefSendButton.trailingAnchor.constraint(equalTo: reefInputBar.trailingAnchor, constant: -30),
            reefSendButton.centerYAnchor.constraint(equalTo: reefInputBar.centerYAnchor),
            reefSendButton.widthAnchor.constraint(equalToConstant: 44),
            reefSendButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func fetchReefDetail() {
        SuliJoyCoveMockService.shared.fetchShellClipDetail(clipID: reefClipID) { [weak self] reefEnvelope in
            guard let self else { return }
            guard let reefClip = reefEnvelope.data else {
                self.showLagoonToast(reefEnvelope.note)
                return
            }
            self.paintReefClip(reefClip)
        }
    }

    private func paintReefClip(_ reefClip: SuliJoyShellClip) {
        self.reefClip = reefClip
        creatorAvatarView.image = UIImage.suliJoyAssetOrLocal(named: reefClip.creator.clipPortraitToken)
        creatorNameLabel.text = reefClip.creator.clipStylistAlias
        reefCaptionLabel.text = reefClip.reefCaptionLine
        lagoonFollowButton.setTitle(reefClip.isFollowed ? "Following" : "Follow", for: .normal)
        lagoonFollowButton.alpha = reefClip.isFollowed ? 0.72 : 1
        reefLikeCountLabel.text = "\(reefClip.likeCount)"
        reefViewCountLabel.text = "\(min(9, reefClip.likeCount + reefClip.commentCount))"
        reefLikeButton.setImage(UIImage(named: reefClip.isLiked ? "sulijoy_feed_like_active" : "sulijoy_feed_like_idle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        reefPosterView.image = UIImage.suliJoyAssetOrLocal(named: reefClip.media.fallbackCoverAssetName ?? "")
        paintLagoonFollowGlow()
        shapeReefPoster(for: reefClip)
        paintReefComments(reefClip.comments)
    }

    private func paintReefComments(_ shoreReplies: [SuliJoyShellClipComment]) {
        reefCommentsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        shoreReplies.forEach { shoreReply in
            let reefReplyCard = SuliJoyClipCommentCard(comment: shoreReply)
            reefReplyCard.onReport = { [weak self] shoreReplyID, shoreAnchor in
                self?.openReefCommentModeration(reefReplyMark: shoreReplyID, sourceView: shoreAnchor)
            }
            reefCommentsStack.addArrangedSubview(reefReplyCard)
        }
    }

    private func paintLagoonFollowGlow() {
        lagoonFollowButton.layer.sublayers?.filter { $0.name == "sulijoy_clip_follow_gradient" }.forEach { $0.removeFromSuperlayer() }
        let gradient = CAGradientLayer()
        gradient.name = "sulijoy_clip_follow_gradient"
        gradient.colors = [
            UIColor(red: 0.54, green: 0.45, blue: 1, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.29, blue: 0.96, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = CGRect(x: 0, y: 0, width: 92, height: 42)
        lagoonFollowButton.layer.insertSublayer(gradient, at: 0)
    }

    private func bindReefKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(reefKeyboardWillRise(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reefKeyboardWillSettle), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func reefMovieURL(for fileName: String) -> URL? {
        if FileManager.default.fileExists(atPath: fileName) {
            return URL(fileURLWithPath: fileName)
        }
        return Bundle.main.url(forResource: fileName, withExtension: "mp4", subdirectory: "SuliJoyClips")
            ?? Bundle.main.url(forResource: fileName, withExtension: "mp4")
    }

    private func shapeReefPoster(for reefClip: SuliJoyShellClip) {
        guard let reefMotionURL = reefMovieURL(for: reefClip.media.reefMotionFileName) else { return }
        let requestedReefID = reefClip.clipID
        DispatchQueue.global(qos: .userInitiated).async {
            let reefAsset = AVURLAsset(url: reefMotionURL)
            let reefFrameHarvester = AVAssetImageGenerator(asset: reefAsset)
            reefFrameHarvester.appliesPreferredTrackTransform = true
            reefFrameHarvester.maximumSize = CGSize(width: 720, height: 960)
            guard let reefCGFrame = try? reefFrameHarvester.copyCGImage(at: CMTime(seconds: 0.25, preferredTimescale: 600), actualTime: nil) else { return }
            let reefPosterFrame = UIImage(cgImage: reefCGFrame)
            DispatchQueue.main.async { [weak self] in
                guard self?.reefClip?.clipID == requestedReefID else { return }
                self?.reefPosterView.image = reefPosterFrame
            }
        }
    }

    private func pauseReefPlayback() {
        shorePlayer?.pause()
        shorePlayer = nil
        shorePlayerLayer?.removeFromSuperlayer()
        shorePlayerLayer = nil
        reefPlayButton.alpha = 1
        reefPlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }

    @objc private func driftBackToClips() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func foldReefKeyboard() {
        view.endEditing(true)
    }

    @objc private func toggleReefPlayback() {
        guard let reefClip else { return }
        if shorePlayer != nil {
            pauseReefPlayback()
            return
        }
        guard let reefMotionURL = reefMovieURL(for: reefClip.media.reefMotionFileName) else {
            showLagoonToast("Video unavailable.")
            return
        }
        let shoreMotionEngine = AVPlayer(url: reefMotionURL)
        let shoreMotionLayer = AVPlayerLayer(player: shoreMotionEngine)
        shoreMotionLayer.videoGravity = .resizeAspectFill
        shoreMotionLayer.frame = reefCinemaView.bounds
        reefCinemaView.layer.insertSublayer(shoreMotionLayer, above: reefPosterView.layer)
        self.shorePlayer = shoreMotionEngine
        self.shorePlayerLayer = shoreMotionLayer
        reefPlayButton.alpha = 0.28
        reefPlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        shoreMotionEngine.play()
    }

    @objc private func toggleReefFollow() {
        guard let reefClip else { return }
        SuliJoyCoveMockService.shared.toggleShellClipFollow(creatorName: reefClip.creator.clipStylistAlias) { [weak self] reefEnvelope in
            guard let self else { return }
            self.showLagoonToast(reefEnvelope.note)
            NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
            self.fetchReefDetail()
        }
    }

    @objc private func openReefCreatorProfile() {
        guard let reefClip else { return }
        let visitor = SuliJoyIslandGuestProfileViewController(displayName: reefClip.creator.clipStylistAlias)
        navigationController?.pushViewController(visitor, animated: true)
    }

    @objc private func toggleReefLike() {
        SuliJoyCoveMockService.shared.toggleShellClipLike(clipID: reefClipID) { [weak self] reefEnvelope in
            guard let self else { return }
            if let refreshedReefClip = reefEnvelope.data {
                self.paintReefClip(refreshedReefClip)
            } else {
                self.showLagoonToast(reefEnvelope.note)
            }
        }
    }

    @objc private func sendReefComment() {
        let shoreReplyText = reefInputField.text ?? ""
        SuliJoyCoveMockService.shared.addShellClipComment(clipID: reefClipID, reefReplyText: shoreReplyText) { [weak self] reefEnvelope in
            guard let self else { return }
            guard let refreshedReefClip = reefEnvelope.data else {
                self.showLagoonToast(reefEnvelope.note)
                return
            }
            self.reefInputField.text = nil
            self.paintReefClip(refreshedReefClip)
            self.showLagoonToast(reefEnvelope.note)
            self.reefScrollView.layoutIfNeeded()
            let reefBottomOffset = CGPoint(x: 0, y: max(0, self.reefScrollView.contentSize.height - self.reefScrollView.bounds.height + self.reefScrollView.adjustedContentInset.bottom))
            self.reefScrollView.setContentOffset(reefBottomOffset, animated: true)
        }
    }

    @objc private func openReefClipModeration() {
        guard let reefClip else { return }
        presentSuliJoyHarborGuardMenu { [weak self] in
            guard let self else { return }
            self.presentSuliJoyReportSheet(target: .shellClip(clipID: self.reefClipID)) { [weak self] in
                self?.fetchReefDetail()
            }
        } block: { [weak self] in
            let visitorID = SuliJoyLagoonVisitor.visitorID(for: reefClip.creator.clipStylistAlias)
            SuliJoyCoveMockService.shared.blockLagoonVisitor(visitorID: visitorID) { reefEnvelope in
                self?.showLagoonToast(reefEnvelope.note)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func openReefCommentModeration(reefReplyMark: String, sourceView: UIView) {
        guard let reefClip else { return }
        presentSuliJoyHarborGuardMenu { [weak self] in
            guard let self else { return }
            self.presentSuliJoyReportSheet(target: .shellClipComment(clipID: self.reefClipID, commentID: reefReplyMark)) { [weak self] in
                self?.fetchReefDetail()
            }
        } block: { [weak self] in
            let visitorID = SuliJoyLagoonVisitor.visitorID(for: reefClip.creator.clipStylistAlias)
            SuliJoyCoveMockService.shared.blockLagoonVisitor(visitorID: visitorID) { reefEnvelope in
                self?.showLagoonToast(reefEnvelope.note)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    @objc private func reefKeyboardWillRise(_ note: Notification) {
        guard let shorelineKeyboardFrame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let reefOverlap = max(0, view.bounds.maxY - view.convert(shorelineKeyboardFrame, from: nil).minY)
        reefInputBottomConstraint?.constant = -reefOverlap + view.safeAreaInsets.bottom
        reefScrollView.contentInset.bottom = reefOverlap + 18
        reefScrollView.scrollIndicatorInsets.bottom = reefOverlap + 18
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func reefKeyboardWillSettle() {
        reefInputBottomConstraint?.constant = 0
        reefScrollView.contentInset.bottom = 0
        reefScrollView.scrollIndicatorInsets.bottom = 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

final class SuliJoyClipCommentCard: UIView {
    var onReport: ((String, UIView) -> Void)?
    private let reefReply: SuliJoyShellClipComment
    private let reefFlagButton = UIButton(type: .system)

    init(comment: SuliJoyShellClipComment) {
        self.reefReply = comment
        super.init(frame: .zero)
        raiseReefDetailScene()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func raiseReefDetailScene() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 16
        clipsToBounds = true

        let reefReplyPortrait = UIImageView()
        reefReplyPortrait.translatesAutoresizingMaskIntoConstraints = false
        reefReplyPortrait.image = UIImage.suliJoyAssetOrLocal(named: reefReply.reefReplyAvatarToken)
        reefReplyPortrait.contentMode = .scaleAspectFill
        reefReplyPortrait.clipsToBounds = true
        reefReplyPortrait.layer.cornerRadius = 15

        let reefReplyNameGlyph = UILabel()
        reefReplyNameGlyph.translatesAutoresizingMaskIntoConstraints = false
        reefReplyNameGlyph.text = reefReply.reefReplyAuthorAlias
        reefReplyNameGlyph.textColor = .suliInk
        reefReplyNameGlyph.font = UIFont.systemFont(ofSize: 16, weight: .black)

        let reefReplyCopyGlyph = UILabel()
        reefReplyCopyGlyph.translatesAutoresizingMaskIntoConstraints = false
        reefReplyCopyGlyph.text = reefReply.reefReplyText
        reefReplyCopyGlyph.textColor = UIColor.black.withAlphaComponent(0.48)
        reefReplyCopyGlyph.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        reefReplyCopyGlyph.numberOfLines = 2

        let reefReplyTimeGlyph = UILabel()
        reefReplyTimeGlyph.translatesAutoresizingMaskIntoConstraints = false
        reefReplyTimeGlyph.text = reefReply.reefReplyMomentLine
        reefReplyTimeGlyph.textColor = UIColor.black.withAlphaComponent(0.30)
        reefReplyTimeGlyph.font = UIFont.systemFont(ofSize: 13, weight: .regular)

        reefFlagButton.translatesAutoresizingMaskIntoConstraints = false
        reefFlagButton.setImage(UIImage(systemName: "exclamationmark.triangle"), for: .normal)
        reefFlagButton.tintColor = reefReply.isReefFlagged ? UIColor(red: 1, green: 0.42, blue: 0.38, alpha: 1) : UIColor(red: 0.87, green: 0.80, blue: 0.74, alpha: 1)
        reefFlagButton.addTarget(self, action: #selector(raiseReefCommentFlag), for: .touchUpInside)

        [reefReplyPortrait, reefReplyNameGlyph, reefReplyCopyGlyph, reefReplyTimeGlyph, reefFlagButton].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 76),
            reefReplyPortrait.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            reefReplyPortrait.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            reefReplyPortrait.widthAnchor.constraint(equalToConstant: 30),
            reefReplyPortrait.heightAnchor.constraint(equalToConstant: 30),
            reefReplyNameGlyph.leadingAnchor.constraint(equalTo: reefReplyPortrait.trailingAnchor, constant: 14),
            reefReplyNameGlyph.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            reefReplyNameGlyph.trailingAnchor.constraint(lessThanOrEqualTo: reefFlagButton.leadingAnchor, constant: -10),
            reefReplyCopyGlyph.leadingAnchor.constraint(equalTo: reefReplyNameGlyph.leadingAnchor),
            reefReplyCopyGlyph.topAnchor.constraint(equalTo: reefReplyNameGlyph.bottomAnchor, constant: 2),
            reefReplyCopyGlyph.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            reefReplyTimeGlyph.leadingAnchor.constraint(equalTo: reefReplyNameGlyph.leadingAnchor),
            reefReplyTimeGlyph.topAnchor.constraint(equalTo: reefReplyCopyGlyph.bottomAnchor, constant: 2),
            reefReplyTimeGlyph.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12),
            reefFlagButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            reefFlagButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            reefFlagButton.widthAnchor.constraint(equalToConstant: 30),
            reefFlagButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc private func raiseReefCommentFlag() {
        onReport?(reefReply.reefReplyMark, reefFlagButton)
    }
}
