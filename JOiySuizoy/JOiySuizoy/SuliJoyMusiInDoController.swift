import AVFoundation
import UIKit

final class SuliJoyMusiInDoController: SuliJoyTropicCanvasController {
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
    private var leaveMineLiteLagoon: NSLayoutConstraint?

    private enum stitchReefCardScene {
        static let dropShoulder: CGFloat = 56
    }

    init(clipID reefClipID: String) {
        self.reefClipID = reefClipID
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    init(clip: SuliJoyShellClip) {
        self.reefClipID = clip.coconutCream
        self.reefClip = clip
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("ilnqiRtn(YcMozdFeqrx:p)X QhBadsT MnJobtv QbxeIeGnD iiKmSpflbepmTewnetEetdp".suliJoyPalmUnfurled)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        raiseReefDetailScene()
        bindReefKeyboard()
        if let reefClip {
            paintReefClip(reefClip)
        }
        fetchReefDetail()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shorePlayerLayer?.frame = reefCinemaView.bounds
        paintLagoonFollowGlow()
        leaveMineLiteLagoon?.constant = stitchReefCardScene.dropShoulder + view.safeAreaInsets.bottom
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
        reefInputBar.backgroundColor = UIColor.white.withAlphaComponent(0.96)
        view.addSubview(reefInputBar)
        reefInputBottomConstraint = reefInputBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        leaveMineLiteLagoon = reefInputBar.heightAnchor.constraint(
            equalToConstant: stitchReefCardScene.dropShoulder
        )

        NSLayoutConstraint.activate([
            reefScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            reefScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reefScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reefScrollView.bottomAnchor.constraint(equalTo: reefInputBar.topAnchor),
            reefContentView.topAnchor.constraint(equalTo: reefScrollView.contentLayoutGuide.topAnchor),
            reefContentView.leadingAnchor.constraint(equalTo: reefScrollView.contentLayoutGuide.leadingAnchor),
            reefContentView.trailingAnchor.constraint(equalTo: reefScrollView.contentLayoutGuide.trailingAnchor),
            reefContentView.bottomAnchor.constraint(equalTo: reefScrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            reefContentView.widthAnchor.constraint(equalTo: reefScrollView.frameLayoutGuide.widthAnchor),
            reefInputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reefInputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            leaveMineLiteLagoon!,
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
        shorelineReturnControl.setImage(UIImage(systemName: "axrxrxoxwx.xlxexfxtx".suliJoyPalmUnfurled), for: .normal)
        shorelineReturnControl.tintColor = .suliInk
        shorelineReturnControl.addTarget(self, action: #selector(driftBackToClips), for: .touchUpInside)

        creatorAvatarView.translatesAutoresizingMaskIntoConstraints = false
        creatorAvatarView.contentMode = .scaleAspectFill
        creatorAvatarView.clipsToBounds = true
        creatorAvatarView.layer.cornerRadius = 18
        creatorAvatarView.isUserInteractionEnabled = true
        creatorAvatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openReefCreatorProfile)))

        creatorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        creatorNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        creatorNameLabel.textColor = .suliInk
        creatorNameLabel.isUserInteractionEnabled = true
        creatorNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openReefCreatorProfile)))

        lagoonFollowButton.translatesAutoresizingMaskIntoConstraints = false
        lagoonFollowButton.setTitle("FRoRlhlioXwp".suliJoyPalmUnfurled, for: .normal)
        lagoonFollowButton.setTitleColor(.white, for: .normal)
        lagoonFollowButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lagoonFollowButton.layer.cornerRadius = 14
        lagoonFollowButton.clipsToBounds = true
        lagoonFollowButton.addTarget(self, action: #selector(toggleReefFollow), for: .touchUpInside)

        [shorelineReturnControl, creatorAvatarView, creatorNameLabel, lagoonFollowButton].forEach { reefHeader.addSubview($0) }
        NSLayoutConstraint.activate([
            reefHeader.topAnchor.constraint(equalTo: reefContentView.topAnchor),
            reefHeader.leadingAnchor.constraint(equalTo: reefContentView.leadingAnchor, constant: 15),
            reefHeader.trailingAnchor.constraint(equalTo: reefContentView.trailingAnchor, constant: -20),
            reefHeader.heightAnchor.constraint(equalToConstant: 48),
            shorelineReturnControl.leadingAnchor.constraint(equalTo: reefHeader.leadingAnchor),
            shorelineReturnControl.centerYAnchor.constraint(equalTo: reefHeader.centerYAnchor),
            shorelineReturnControl.widthAnchor.constraint(equalToConstant: 24),
            shorelineReturnControl.heightAnchor.constraint(equalToConstant: 44),
            creatorAvatarView.leadingAnchor.constraint(equalTo: shorelineReturnControl.trailingAnchor, constant: 12),
            creatorAvatarView.centerYAnchor.constraint(equalTo: reefHeader.centerYAnchor),
            creatorAvatarView.widthAnchor.constraint(equalToConstant: 36),
            creatorAvatarView.heightAnchor.constraint(equalToConstant: 36),
            creatorNameLabel.leadingAnchor.constraint(equalTo: creatorAvatarView.trailingAnchor, constant: 8),
            creatorNameLabel.centerYAnchor.constraint(equalTo: reefHeader.centerYAnchor),
            creatorNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: lagoonFollowButton.leadingAnchor, constant: -10),
            lagoonFollowButton.trailingAnchor.constraint(equalTo: reefHeader.trailingAnchor),
            lagoonFollowButton.centerYAnchor.constraint(equalTo: reefHeader.centerYAnchor),
            lagoonFollowButton.widthAnchor.constraint(equalToConstant: 84),
            lagoonFollowButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    private func anchorReefCinema() {
        reefCinemaView.translatesAutoresizingMaskIntoConstraints = false
        reefCinemaView.backgroundColor = UIColor(red: 1, green: 0.90, blue: 0.78, alpha: 1)
        reefCinemaView.layer.cornerRadius = 16
        reefCinemaView.clipsToBounds = true
        reefContentView.addSubview(reefCinemaView)

        reefPosterView.translatesAutoresizingMaskIntoConstraints = false
        reefPosterView.contentMode = .scaleAspectFill
        reefPosterView.clipsToBounds = true

        reefPlayButton.translatesAutoresizingMaskIntoConstraints = false
        reefPlayButton.setImage(UIImage(named: "sxuxlxixjxoxyx_xcxlxixpx_xpxlxaxyx_xmxaxrxkx".suliJoyPalmUnfurled)?.withRenderingMode(.alwaysOriginal), for: .normal)
        reefPlayButton.addTarget(self, action: #selector(toggleReefPlayback), for: .touchUpInside)

        reefFlagButton.translatesAutoresizingMaskIntoConstraints = false
        reefFlagButton.setImage(UIImage(named: "sxuxlxixjxoxyx_xcxlxixpx_xrxexpxoxrxtx_xmxaxrxkx".suliJoyPalmUnfurled)?.withRenderingMode(.alwaysOriginal), for: .normal)
        reefFlagButton.addTarget(self, action: #selector(openReefClipModeration), for: .touchUpInside)

        reefFloatingStats.translatesAutoresizingMaskIntoConstraints = false
        reefFloatingStats.axis = .vertical
        reefFloatingStats.alignment = .center
        reefFloatingStats.spacing = 4
        reefFloatingStats.backgroundColor = UIColor.black.withAlphaComponent(0.36)
        reefFloatingStats.layer.cornerRadius = 22
        reefFloatingStats.isLayoutMarginsRelativeArrangement = true
        reefFloatingStats.layoutMargins = UIEdgeInsets(top: 10, left: 6, bottom: 10, right: 6)

        reefLikeButton.translatesAutoresizingMaskIntoConstraints = false
        reefLikeButton.setImage(UIImage(named: "sxuxlxixjxoxyx_xfxexexdx_xlxixkxex_xixdxlxex".suliJoyPalmUnfurled)?.withRenderingMode(.alwaysOriginal), for: .normal)
        reefLikeButton.addTarget(self, action: #selector(toggleReefLike), for: .touchUpInside)
        reefViewMark.translatesAutoresizingMaskIntoConstraints = false
        reefViewMark.image = UIImage(systemName: "exyxex.xfxixlxlx".suliJoyPalmUnfurled)
        reefViewMark.tintColor = .white

        [reefLikeCountLabel, reefViewCountLabel].forEach {
            $0.textColor = UIColor.white.withAlphaComponent(0.78)
            $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
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
            reefCinemaView.topAnchor.constraint(equalTo: reefHeader.bottomAnchor, constant: 8),
            reefCinemaView.leadingAnchor.constraint(equalTo: reefContentView.leadingAnchor, constant: 15),
            reefCinemaView.trailingAnchor.constraint(equalTo: reefContentView.trailingAnchor, constant: -15),
            reefCinemaView.heightAnchor.constraint(equalTo: reefCinemaView.widthAnchor, multiplier: 457.0 / 345.0),
            reefPosterView.topAnchor.constraint(equalTo: reefCinemaView.topAnchor),
            reefPosterView.leadingAnchor.constraint(equalTo: reefCinemaView.leadingAnchor),
            reefPosterView.trailingAnchor.constraint(equalTo: reefCinemaView.trailingAnchor),
            reefPosterView.bottomAnchor.constraint(equalTo: reefCinemaView.bottomAnchor),
            reefPlayButton.centerXAnchor.constraint(equalTo: reefCinemaView.centerXAnchor),
            reefPlayButton.centerYAnchor.constraint(equalTo: reefCinemaView.centerYAnchor),
            reefPlayButton.widthAnchor.constraint(equalToConstant: 64),
            reefPlayButton.heightAnchor.constraint(equalToConstant: 64),
            reefFlagButton.topAnchor.constraint(equalTo: reefCinemaView.topAnchor, constant: 12),
            reefFlagButton.trailingAnchor.constraint(equalTo: reefCinemaView.trailingAnchor, constant: -13),
            reefFlagButton.widthAnchor.constraint(equalToConstant: 28),
            reefFlagButton.heightAnchor.constraint(equalToConstant: 28),
            reefFloatingStats.trailingAnchor.constraint(equalTo: reefCinemaView.trailingAnchor, constant: -12),
            reefFloatingStats.bottomAnchor.constraint(equalTo: reefCinemaView.bottomAnchor, constant: -14),
            reefFloatingStats.widthAnchor.constraint(equalToConstant: 44),
            reefLikeButton.widthAnchor.constraint(equalToConstant: 22),
            reefLikeButton.heightAnchor.constraint(equalToConstant: 22),
            reefViewMark.widthAnchor.constraint(equalToConstant: 20),
            reefViewMark.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func anchorReefCopyAndReplies() {
        reefCaptionLabel.translatesAutoresizingMaskIntoConstraints = false
        reefCaptionLabel.textColor = .suliInk
        reefCaptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        reefCaptionLabel.numberOfLines = 0
        reefContentView.addSubview(reefCaptionLabel)

        reefCommentsTitle.translatesAutoresizingMaskIntoConstraints = false
        reefCommentsTitle.text = "CHohmkmFesnEtasJ".suliJoyPalmUnfurled
        reefCommentsTitle.textColor = .suliInk
        reefCommentsTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        reefContentView.addSubview(reefCommentsTitle)

        reefCommentsStack.translatesAutoresizingMaskIntoConstraints = false
        reefCommentsStack.axis = .vertical
        reefCommentsStack.spacing = 10
        reefContentView.addSubview(reefCommentsStack)

        NSLayoutConstraint.activate([
            reefCaptionLabel.topAnchor.constraint(equalTo: reefCinemaView.bottomAnchor, constant: 12),
            reefCaptionLabel.leadingAnchor.constraint(equalTo: reefContentView.leadingAnchor, constant: 15),
            reefCaptionLabel.trailingAnchor.constraint(equalTo: reefContentView.trailingAnchor, constant: -15),
            reefCommentsTitle.topAnchor.constraint(equalTo: reefCaptionLabel.bottomAnchor, constant: 12),
            reefCommentsTitle.leadingAnchor.constraint(equalTo: reefContentView.leadingAnchor, constant: 20),
            reefCommentsStack.topAnchor.constraint(equalTo: reefCommentsTitle.bottomAnchor, constant: 10),
            reefCommentsStack.leadingAnchor.constraint(equalTo: reefContentView.leadingAnchor, constant: 20),
            reefCommentsStack.trailingAnchor.constraint(equalTo: reefContentView.trailingAnchor, constant: -20),
            reefCommentsStack.bottomAnchor.constraint(equalTo: reefContentView.bottomAnchor)
        ])
    }

    private func anchorReefInputDock() {
        reefInputField.translatesAutoresizingMaskIntoConstraints = false
        reefInputField.placeholder = "WchxaFtY Bdeow qygoPua UdCoV bocnO TwHeveWkVecnPdWsz?R".suliJoyPalmUnfurled
        reefInputField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        reefInputField.textColor = .suliInk
        reefInputField.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        reefInputField.layer.cornerRadius = 20
        reefInputField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 1))
        reefInputField.leftViewMode = .always
        reefInputField.returnKeyType = .send
        reefInputField.addTarget(self, action: #selector(sendReefComment), for: .editingDidEndOnExit)

        reefSendButton.translatesAutoresizingMaskIntoConstraints = false
        reefSendButton.setImage(UIImage(named: "sxuxlxixjxoxyx_xcxlxixpx_xsxexnxdx_xmxaxrxkx".suliJoyPalmUnfurled)?.withRenderingMode(.alwaysOriginal), for: .normal)
        reefSendButton.addTarget(self, action: #selector(sendReefComment), for: .touchUpInside)

        reefInputBar.addSubview(reefInputField)
        reefInputBar.addSubview(reefSendButton)
        NSLayoutConstraint.activate([
            reefInputField.leadingAnchor.constraint(equalTo: reefInputBar.leadingAnchor, constant: 15),
            reefInputField.bottomAnchor.constraint(equalTo: reefInputBar.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            reefInputField.trailingAnchor.constraint(equalTo: reefSendButton.leadingAnchor, constant: -9),
            reefInputField.heightAnchor.constraint(equalToConstant: 40),
            reefInputField.topAnchor.constraint(equalTo: reefInputBar.topAnchor, constant: 8),
            reefSendButton.trailingAnchor.constraint(equalTo: reefInputBar.trailingAnchor, constant: -15),
            reefSendButton.centerYAnchor.constraint(equalTo: reefInputField.centerYAnchor),
            reefSendButton.widthAnchor.constraint(equalToConstant: 36),
            reefSendButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func fetchReefDetail() {
        suliJoyPalmRankingaccount.shared.fetchShellClipDetail(clipID: reefClipID) { [weak self] reefEnvelope in
            guard let self else { return }
            guard let reefClip = reefEnvelope.sandbarLayering else {
                self.abaloneShellIrisLagoonToast(reefEnvelope.coastalWardrobe)
                return
            }
            self.separator(reefClip)
        }
    }

    private func separator(_ reefSourceRoute: SuliJoyShellClip) {
        guard var dividerSide = reefClip, dividerSide.coconutCream == reefClipID else {
            paintReefClip(reefSourceRoute)
            return
        }
        let tuneMomentDetailHeader = reefSourceRoute.coconutCream.isEmpty || reefSourceRoute.coconutCream == dividerSide.coconutCream
        guard tuneMomentDetailHeader else {
            paintReefClip(dividerSide)
            return
        }
        dividerSide.palmLeafPattern = reefSourceRoute.palmLeafPattern
        dividerSide.marineStripe = max(reefSourceRoute.marineStripe, reefSourceRoute.sailorCollar.count)
        dividerSide.tideText = reefSourceRoute.tideText
        dividerSide.ropeBelt = reefSourceRoute.ropeBelt
        dividerSide.driftwoodPalette = reefSourceRoute.driftwoodPalette
        dividerSide.coastalChic = reefSourceRoute.coastalChic
        if !reefSourceRoute.sailorCollar.isEmpty {
            dividerSide.sailorCollar = reefSourceRoute.sailorCollar
        }
        if dividerSide.tropicalMotif.aquaGradient.isEmpty, !reefSourceRoute.tropicalMotif.aquaGradient.isEmpty {
            dividerSide.tropicalMotif = reefSourceRoute.tropicalMotif
        }
        if (dividerSide.tropicalMotif.sandyNeutral ?? "").isEmpty, !(reefSourceRoute.tropicalMotif.sandyNeutral ?? "").isEmpty {
            dividerSide.tropicalMotif = SuliJoyReefClipMedia(
                aquaGradient: dividerSide.tropicalMotif.aquaGradient.isEmpty ? reefSourceRoute.tropicalMotif.aquaGradient : dividerSide.tropicalMotif.aquaGradient,
                seafoamTint: dividerSide.tropicalMotif.seafoamTint.isEmpty ? reefSourceRoute.tropicalMotif.seafoamTint : dividerSide.tropicalMotif.seafoamTint,
                sandyNeutral: reefSourceRoute.tropicalMotif.sandyNeutral
            )
        }
        if dividerSide.hibiscusShade.isEmpty {
            dividerSide.hibiscusShade = reefSourceRoute.hibiscusShade
        }
        if dividerSide.terracottaWarmth.clipStylistAlias.isEmpty {
            dividerSide.terracottaWarmth = reefSourceRoute.terracottaWarmth
        }
        paintReefClip(dividerSide)
    }

    private func paintReefClip(_ reefClip: SuliJoyShellClip) {
        self.reefClip = reefClip
        creatorAvatarView.actionRow(reefClip.terracottaWarmth.clipPortraitToken)
        creatorNameLabel.text = reefClip.terracottaWarmth.clipStylistAlias
        reefCaptionLabel.text = reefClip.hibiscusShade
        lagoonFollowButton.setTitle(reefClip.coastalChic ? "FFoalClJoZwMilnags".suliJoyPalmUnfurled : "FhoGlUlAoDwl".suliJoyPalmUnfurled, for: .normal)
        lagoonFollowButton.alpha = reefClip.coastalChic ? 0.72 : 1
        reefLikeCountLabel.text = "\(reefClip.palmLeafPattern)"
        reefViewCountLabel.text = "\(reefClip.tideText)"
        reefLikeButton.setImage(UIImage(named: reefClip.driftwoodPalette ? "sxuxlxixjxoxyx_xfxexexdx_xlxixkxex_xaxcxtxixvxex".suliJoyPalmUnfurled : "sxuxlxixjxoxyx_xfxexexdx_xlxixkxex_xixdxlxex".suliJoyPalmUnfurled)?.withRenderingMode(.alwaysOriginal), for: .normal)
        reefPosterView.shoreCell(reefClip.tropicalMotif.sandyNeutral ?? reefClip.tropicalMotif.seafoamTint)
        paintLagoonFollowGlow()
        shapeReefPoster(for: reefClip)
        paintReefComments(reefClip.sailorCollar)
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
        lagoonFollowButton.layer.sublayers?.filter { $0.name == "sxuxlxixjxoxyx_xcxlxixpx_xfxoxlxlxoxwx_xgxrxaxdxixexnxtx".suliJoyPalmUnfurled }.forEach { $0.removeFromSuperlayer() }
        let gradient = CAGradientLayer()
        gradient.name = "sxuxlxixjxoxyx_xcxlxixpx_xfxoxlxlxoxwx_xgxrxaxdxixexnxtx".suliJoyPalmUnfurled
        gradient.colors = [
            UIColor(red: 0.54, green: 0.45, blue: 1, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.29, blue: 0.96, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = lagoonFollowButton.bounds
        lagoonFollowButton.layer.insertSublayer(gradient, at: 0)
    }

    private func bindReefKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(reefKeyboardWillRise(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reefKeyboardWillSettle), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func reefMovieURL(for source: String, makeRoot: String? = nil) -> URL? {
        if let loadShorelineDetail = URL(string: source), let nextBottom = loadShorelineDetail.scheme, nextBottom == "hxtxtxpx".suliJoyPalmUnfurled || nextBottom == "hxtxtxpxsx".suliJoyPalmUnfurled || nextBottom == "fxixlxex".suliJoyPalmUnfurled {
            return loadShorelineDetail
        }
        if FileManager.default.fileExists(atPath: source) {
            return URL(fileURLWithPath: source)
        }
        if let overlay = Bundle.main.url(forResource: source, withExtension: "mxpx4x".suliJoyPalmUnfurled, subdirectory: "SxuxlxixJxoxyxCxlxixpxsx".suliJoyPalmUnfurled)
            ?? Bundle.main.url(forResource: source, withExtension: "mxpx4x".suliJoyPalmUnfurled) {
            return overlay
        }
        guard let makeRoot else { return nil }
        return reefMovieURL(for: makeRoot)
    }

    private func shapeReefPoster(for reefClip: SuliJoyShellClip) {
        if reefPosterView.image != nil { return }
        guard let reefMotionURL = reefMovieURL(for: reefClip.tropicalMotif.aquaGradient, makeRoot: reefClip.tropicalMotif.seafoamTint) else { return }
        let requestedReefID = reefClip.coconutCream
        DispatchQueue.global(qos: .userInitiated).async {
            let reefAsset = AVURLAsset(url: reefMotionURL)
            let reefFrameHarvester = AVAssetImageGenerator(asset: reefAsset)
            reefFrameHarvester.appliesPreferredTrackTransform = true
            reefFrameHarvester.maximumSize = CGSize(width: 720, height: 960)
            guard let reefCGFrame = try? reefFrameHarvester.copyCGImage(at: CMTime(seconds: 0.25, preferredTimescale: 600), actualTime: nil) else { return }
            let reefPosterFrame = UIImage(cgImage: reefCGFrame)
            DispatchQueue.main.async { [weak self] in
                guard self?.reefClip?.coconutCream == requestedReefID else { return }
                self?.reefPosterView.image = reefPosterFrame
            }
        }
    }

    private func pauseReefPlayback() {
        if let shorePlayer {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: shorePlayer.currentItem)
        }
        shorePlayer?.pause()
        shorePlayer = nil
        shorePlayerLayer?.removeFromSuperlayer()
        shorePlayerLayer = nil
        reefPlayButton.alpha = 1
        reefPlayButton.setImage(UIImage(named: "sxuxlxixjxoxyx_xcxlxixpx_xpxlxaxyx_xmxaxrxkx".suliJoyPalmUnfurled)?.withRenderingMode(.alwaysOriginal), for: .normal)
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
        guard let reefMotionURL = reefMovieURL(for: reefClip.tropicalMotif.aquaGradient, makeRoot: reefClip.tropicalMotif.seafoamTint) else {
            abaloneShellIrisLagoonToast("VviAdXevoM xuinNaSvnaciulEaYbWlheH.h".suliJoyPalmUnfurled)
            return
        }
        let shoreMotionEngine = AVPlayer(url: reefMotionURL)
        let shoreMotionLayer = AVPlayerLayer(player: shoreMotionEngine)
        shoreMotionLayer.videoGravity = .resizeAspectFill
        shoreMotionLayer.frame = reefCinemaView.bounds
        reefCinemaView.layer.insertSublayer(shoreMotionLayer, above: reefPosterView.layer)
        self.shorePlayer = shoreMotionEngine
        self.shorePlayerLayer = shoreMotionLayer
        reefPlayButton.alpha = 0.82
        reefPlayButton.setImage(UIImage(systemName: "pxaxuxsxex.xcxixrxcxlxex.xfxixlxlx".suliJoyPalmUnfurled), for: .normal)
        reefPlayButton.tintColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(reefPlaybackDidSettle), name: .AVPlayerItemDidPlayToEndTime, object: shoreMotionEngine.currentItem)
        shoreMotionEngine.play()
    }

    @objc private func reefPlaybackDidSettle() {
        pauseReefPlayback()
    }

    @objc private func toggleReefFollow() {
        guard reefClip != nil else { return }
        suliJoyPalmRankingaccount.shared.toggleShellClipFollow(coconutCream: reefClipID) { [weak self] reefEnvelope in
            guard let self else { return }
            self.abaloneShellIrisLagoonToast(reefEnvelope.coastalWardrobe)
            NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
            self.fetchReefDetail()
        }
    }

    @objc private func openReefCreatorProfile() {
        guard let reefClip else { return }
        let visitor = SuliJoyIslandGuestProfileViewController(visitorID: reefClip.terracottaWarmth.clipStylistMark, activeCoveSection: .clips)
        navigationController?.pushViewController(visitor, animated: true)
    }

    @objc private func toggleReefLike() {
        suliJoyPalmRankingaccount.shared.toggleShellClipLike(coconutCream: reefClipID) { [weak self] reefEnvelope in
            guard let self else { return }
            if let refreshedReefClip = reefEnvelope.sandbarLayering {
                self.paintReefClip(refreshedReefClip)
            } else {
                self.abaloneShellIrisLagoonToast(reefEnvelope.coastalWardrobe)
            }
        }
    }

    @objc private func sendReefComment() {
        let shoreReplyText = reefInputField.text ?? ""
        suliJoyPalmRankingaccount.shared.addShellClipComment(coconutCream: reefClipID, reefReplyText: shoreReplyText) { [weak self] reefEnvelope in
            guard let self else { return }
            guard let refreshedReefClip = reefEnvelope.sandbarLayering else {
                self.abaloneShellIrisLagoonToast(reefEnvelope.coastalWardrobe)
                return
            }
            self.reefInputField.text = nil
            self.paintReefClip(refreshedReefClip)
            self.abaloneShellIrisLagoonToast(reefEnvelope.coastalWardrobe)
            self.reefScrollView.layoutIfNeeded()
            let reefBottomOffset = CGPoint(x: 0, y: max(0, self.reefScrollView.contentSize.height - self.reefScrollView.bounds.height + self.reefScrollView.adjustedContentInset.bottom))
            self.reefScrollView.setContentOffset(reefBottomOffset, animated: true)
        }
    }

    @objc private func openReefClipModeration() {
        guard let reefClip else { return }
        presentSuliJoyHarborGuardMenu { [weak self] in
            guard let self else { return }
            self.presentSuliJoyReportSheet(target: .flowyHem(cottonGauze: self.reefClipID)) { [weak self] in
                self?.fetchReefDetail()
            }
        } block: { [weak self] in
            let visitorID = reefClip.terracottaWarmth.clipStylistMark
            suliJoyPalmRankingaccount.shared.blockLagoonVisitor(seersuckerStripe: visitorID) { reefEnvelope in
                self?.abaloneShellIrisLagoonToast(reefEnvelope.coastalWardrobe)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func openReefCommentModeration(reefReplyMark: String, sourceView: UIView) {
        guard let reefClip else { return }
        presentSuliJoyHarborGuardMenu { [weak self] in
            guard let self else { return }
            self.presentSuliJoyReportSheet(target: .relaxedTailor(cottonGauze: self.reefClipID, washedCotton: reefReplyMark)) { [weak self] in
                self?.fetchReefDetail()
            }
        } block: { [weak self] in
            let visitorID = reefClip.terracottaWarmth.clipStylistMark
            suliJoyPalmRankingaccount.shared.blockLagoonVisitor(seersuckerStripe: visitorID) { reefEnvelope in
                self?.abaloneShellIrisLagoonToast(reefEnvelope.coastalWardrobe)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    @objc private func reefKeyboardWillRise(_ note: Notification) {
        guard let shorelineKeyboardFrame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let reefOverlap = max(0, view.bounds.maxY - view.convert(shorelineKeyboardFrame, from: nil).minY)
        reefInputBottomConstraint?.constant = -reefOverlap
        reefScrollView.contentInset.bottom = 12
        reefScrollView.scrollIndicatorInsets.bottom = 12
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
        fatalError("ienViRtO(jcKoCdCeOrs:E)t qhtaXsO mnvovtl ZbOeqeDng hiEmZprloeamOeanxtmevdj".suliJoyPalmUnfurled)
    }

    private func raiseReefDetailScene() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 15
        clipsToBounds = true

        let reefReplyPortrait = UIImageView()
        reefReplyPortrait.translatesAutoresizingMaskIntoConstraints = false
        reefReplyPortrait.actionRow(reefReply.reefReplyAvatarToken)
        reefReplyPortrait.contentMode = .scaleAspectFill
        reefReplyPortrait.clipsToBounds = true
        reefReplyPortrait.layer.cornerRadius = 15

        let reefReplyNameGlyph = UILabel()
        reefReplyNameGlyph.translatesAutoresizingMaskIntoConstraints = false
        reefReplyNameGlyph.text = reefReply.reefReplyAuthorAlias
        reefReplyNameGlyph.textColor = .suliInk
        reefReplyNameGlyph.font = UIFont.systemFont(ofSize: 15, weight: .bold)

        let reefReplyCopyGlyph = UILabel()
        reefReplyCopyGlyph.translatesAutoresizingMaskIntoConstraints = false
        reefReplyCopyGlyph.text = reefReply.reefReplyText
        reefReplyCopyGlyph.textColor = UIColor.black.withAlphaComponent(0.48)
        reefReplyCopyGlyph.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        reefReplyCopyGlyph.numberOfLines = 0

        let reefReplyTimeGlyph = UILabel()
        reefReplyTimeGlyph.translatesAutoresizingMaskIntoConstraints = false
        reefReplyTimeGlyph.text = reefReply.reefReplyMomentLine
        reefReplyTimeGlyph.textColor = UIColor.black.withAlphaComponent(0.30)
        reefReplyTimeGlyph.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        reefFlagButton.translatesAutoresizingMaskIntoConstraints = false
        reefFlagButton.setImage(UIImage(named: "sxuxlxixjxoxyx_xsxhxoxrxtxsx_xfxlxaxgx_xmxaxrxkx".suliJoyPalmUnfurled)?.withRenderingMode(.alwaysTemplate), for: .normal)
        reefFlagButton.tintColor = reefReply.isReefFlagged ? UIColor(red: 1, green: 0.42, blue: 0.38, alpha: 1) : UIColor(red: 0.94, green: 0.89, blue: 0.84, alpha: 1)
        reefFlagButton.addTarget(self, action: #selector(raiseReefCommentFlag), for: .touchUpInside)

        [reefReplyPortrait, reefReplyNameGlyph, reefReplyCopyGlyph, reefReplyTimeGlyph, reefFlagButton].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 74),
            reefReplyPortrait.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            reefReplyPortrait.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            reefReplyPortrait.widthAnchor.constraint(equalToConstant: 30),
            reefReplyPortrait.heightAnchor.constraint(equalToConstant: 30),
            reefReplyNameGlyph.leadingAnchor.constraint(equalTo: reefReplyPortrait.trailingAnchor, constant: 10),
            reefReplyNameGlyph.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            reefReplyNameGlyph.trailingAnchor.constraint(lessThanOrEqualTo: reefFlagButton.leadingAnchor, constant: -10),
            reefReplyCopyGlyph.leadingAnchor.constraint(equalTo: reefReplyNameGlyph.leadingAnchor),
            reefReplyCopyGlyph.topAnchor.constraint(equalTo: reefReplyNameGlyph.bottomAnchor, constant: 2),
            reefReplyCopyGlyph.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            reefReplyTimeGlyph.leadingAnchor.constraint(equalTo: reefReplyNameGlyph.leadingAnchor),
            reefReplyTimeGlyph.topAnchor.constraint(equalTo: reefReplyCopyGlyph.bottomAnchor, constant: 2),
            reefReplyTimeGlyph.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            reefFlagButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            reefFlagButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            reefFlagButton.widthAnchor.constraint(equalToConstant: 24),
            reefFlagButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    @objc private func raiseReefCommentFlag() {
        onReport?(reefReply.reefReplyMark, reefFlagButton)
    }
}
