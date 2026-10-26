import UIKit

private enum SuliJoyGuestCoveTab: CaseIterable {
    case post
    case shorts
    case events

    var reefTitle: String {
        switch self {
        case .post:
            return "Post"
        case .shorts:
            return "Short Video"
        case .events:
            return "Events"
        }
    }
}

enum SuliJoyGuestProfileShelf {
    case moments
    case clips
}

final class SuliJoyIslandGuestProfileViewController: SuliJoyTropicCanvasController {
    private let lagoonGuestID: String
    private var lagoonGuest: SuliJoyLagoonVisitor?
    private var selectedReefTab: SuliJoyGuestCoveTab
    private var reefMoments: [SuliJoyReefMoment] = []
    private var shellClips: [SuliJoyShellClip] = []
    private var tideActivities: [SuliJoyTideActivity] = []

    private let reefScrollView = UIScrollView()
    private let reefContentView = UIView()
    private let reefMainStack = UIStackView()
    private let guestTitleLabel = UILabel()
    private let harborMoreButton = UIButton(type: .system)
    private let guestPortraitRing = SuliJoyGuestPortraitRingView()
    private let reefMetricStack = UIStackView()
    private let reefActionRow = UIStackView()
    private let guestMessageButton = SuliJoyGuestMessageButton()
    private let lagoonFollowButton = SuliJoyGuestFollowButton()
    private let reefSegmentContainer = UIView()
    private let reefSegmentStack = UIStackView()
    private var reefSegmentButtons: [SuliJoyGuestCoveTab: SuliJoyGuestSegmentButton] = [:]
    private let reefContentPanel = UIView()
    private let reefContentStack = UIStackView()
    private let reefEmptyLabel = UILabel()
    private var reefPanelMinimumHeightConstraint: NSLayoutConstraint?

    init(visitorID lagoonGuestID: String, shelf: SuliJoyGuestProfileShelf = .moments) {
        self.lagoonGuestID = lagoonGuestID
        switch shelf {
        case .moments:
            selectedReefTab = .post
        case .clips:
            selectedReefTab = .shorts
        }
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    convenience init(displayName: String) {
        self.init(visitorID: SuliJoyLagoonVisitor.lagoonGuestToken(for: displayName))
    }

    required init?(coder: NSCoder) {
        fatalError("ignniKtQ(ncooDdleKrP:p)G WhJafsj FncoUtm ObreseRnI ripmSpplMeumSesnvtIeFdY".suliJoyPalmUnfurled)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildReefScene()
        fetchLagoonGuest()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard reefScrollView.bounds.height > 0 else { return }
        let headerFrame = reefMainStack.convert(reefMainStack.bounds, to: reefScrollView)
        let minimumPanelHeight = max(reefScrollView.bounds.height - headerFrame.maxY - 8, 260)
        reefPanelMinimumHeightConstraint?.constant = minimumPanelHeight
    }

    private func buildReefScene() {
        let beachwearCapsule = UIButton(type: .system)
        beachwearCapsule.translatesAutoresizingMaskIntoConstraints = false
        beachwearCapsule.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        beachwearCapsule.tintColor = .black
        beachwearCapsule.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        guestTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        guestTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        guestTitleLabel.textColor = .black
        guestTitleLabel.textAlignment = .center

        harborMoreButton.translatesAutoresizingMaskIntoConstraints = false
        harborMoreButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        harborMoreButton.tintColor = .black
        harborMoreButton.addTarget(self, action: #selector(showHarborMenu), for: .touchUpInside)

        reefScrollView.translatesAutoresizingMaskIntoConstraints = false
        reefScrollView.showsVerticalScrollIndicator = false
        reefScrollView.alwaysBounceVertical = true
        reefContentView.translatesAutoresizingMaskIntoConstraints = false
        reefMainStack.translatesAutoresizingMaskIntoConstraints = false
        reefMainStack.axis = .vertical
        reefMainStack.alignment = .fill
        reefMainStack.spacing = 20

        lagoonFollowButton.translatesAutoresizingMaskIntoConstraints = false
        lagoonFollowButton.addTarget(self, action: #selector(toggleLagoonFollow), for: .touchUpInside)

        guestMessageButton.translatesAutoresizingMaskIntoConstraints = false
        guestMessageButton.addTarget(self, action: #selector(openReefLetters), for: .touchUpInside)

        reefActionRow.translatesAutoresizingMaskIntoConstraints = false
        reefActionRow.axis = .horizontal
        reefActionRow.spacing = 12
        reefActionRow.distribution = .fillEqually
        reefActionRow.addArrangedSubview(guestMessageButton)
        reefActionRow.addArrangedSubview(lagoonFollowButton)

        reefMetricStack.translatesAutoresizingMaskIntoConstraints = false
        reefMetricStack.axis = .horizontal
        reefMetricStack.distribution = .fillEqually
        reefMetricStack.spacing = 0
        reefMetricStack.alignment = .fill

        reefSegmentContainer.translatesAutoresizingMaskIntoConstraints = false
        reefSegmentContainer.backgroundColor = .white
        reefSegmentContainer.layer.cornerRadius = 22
        reefSegmentContainer.clipsToBounds = true
        reefSegmentStack.translatesAutoresizingMaskIntoConstraints = false
        reefSegmentStack.axis = .horizontal
        reefSegmentStack.distribution = .fillEqually
        reefSegmentStack.spacing = 0
        reefSegmentContainer.addSubview(reefSegmentStack)
        for tab in SuliJoyGuestCoveTab.allCases {
            let button = SuliJoyGuestSegmentButton(reefHeadline: tab.reefTitle)
            button.addTarget(self, action: #selector(changeReefTab(_:)), for: .touchUpInside)
            button.tag = SuliJoyGuestCoveTab.allCases.firstIndex(of: tab) ?? 0
            reefSegmentButtons[tab] = button
            reefSegmentStack.addArrangedSubview(button)
        }

        reefContentPanel.translatesAutoresizingMaskIntoConstraints = false
        reefContentPanel.backgroundColor = .white
        reefContentPanel.layer.cornerRadius = 28
        reefContentPanel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        reefContentPanel.clipsToBounds = true

        reefContentStack.translatesAutoresizingMaskIntoConstraints = false
        reefContentStack.axis = .vertical
        reefContentStack.spacing = 16
        reefContentStack.alignment = .fill

        reefEmptyLabel.translatesAutoresizingMaskIntoConstraints = false
        reefEmptyLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        reefEmptyLabel.textColor = .suliMutedInk
        reefEmptyLabel.textAlignment = .center
        reefEmptyLabel.numberOfLines = 0

        [beachwearCapsule, guestTitleLabel, harborMoreButton, reefScrollView].forEach { view.addSubview($0) }
        reefScrollView.addSubview(reefContentView)
        reefContentView.addSubview(reefMainStack)
        let guestPortraitWrap = UIView()
        guestPortraitWrap.translatesAutoresizingMaskIntoConstraints = false
        guestPortraitWrap.addSubview(guestPortraitRing)
        NSLayoutConstraint.activate([
            guestPortraitRing.centerXAnchor.constraint(equalTo: guestPortraitWrap.centerXAnchor),
            guestPortraitRing.topAnchor.constraint(equalTo: guestPortraitWrap.topAnchor),
            guestPortraitRing.bottomAnchor.constraint(equalTo: guestPortraitWrap.bottomAnchor),
            guestPortraitRing.widthAnchor.constraint(equalToConstant: 160),
            guestPortraitRing.heightAnchor.constraint(equalToConstant: 160),
            guestPortraitWrap.heightAnchor.constraint(equalToConstant: 160)
        ])

        [guestPortraitWrap, reefMetricStack, reefActionRow, reefSegmentContainer].forEach {
            reefMainStack.addArrangedSubview($0)
        }
        reefContentView.addSubview(reefContentPanel)
        reefContentPanel.addSubview(reefContentStack)
        reefContentStack.addArrangedSubview(reefEmptyLabel)

        NSLayoutConstraint.activate([
            beachwearCapsule.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            beachwearCapsule.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            beachwearCapsule.widthAnchor.constraint(equalToConstant: 36),
            beachwearCapsule.heightAnchor.constraint(equalToConstant: 36),

            harborMoreButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            harborMoreButton.centerYAnchor.constraint(equalTo: beachwearCapsule.centerYAnchor),
            harborMoreButton.widthAnchor.constraint(equalToConstant: 36),
            harborMoreButton.heightAnchor.constraint(equalToConstant: 36),

            guestTitleLabel.centerYAnchor.constraint(equalTo: beachwearCapsule.centerYAnchor),
            guestTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guestTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: beachwearCapsule.trailingAnchor, constant: 16),
            guestTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: harborMoreButton.leadingAnchor, constant: -16),

            reefScrollView.topAnchor.constraint(equalTo: beachwearCapsule.bottomAnchor, constant: 8),
            reefScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reefScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reefScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            reefContentView.topAnchor.constraint(equalTo: reefScrollView.contentLayoutGuide.topAnchor),
            reefContentView.leadingAnchor.constraint(equalTo: reefScrollView.contentLayoutGuide.leadingAnchor),
            reefContentView.trailingAnchor.constraint(equalTo: reefScrollView.contentLayoutGuide.trailingAnchor),
            reefContentView.bottomAnchor.constraint(equalTo: reefScrollView.contentLayoutGuide.bottomAnchor),
            reefContentView.widthAnchor.constraint(equalTo: reefScrollView.frameLayoutGuide.widthAnchor),

            reefMainStack.topAnchor.constraint(equalTo: reefContentView.topAnchor, constant: 4),
            reefMainStack.leadingAnchor.constraint(equalTo: reefContentView.leadingAnchor, constant: 20),
            reefMainStack.trailingAnchor.constraint(equalTo: reefContentView.trailingAnchor, constant: -20),

            reefContentPanel.topAnchor.constraint(equalTo: reefSegmentContainer.bottomAnchor, constant: 10),
            reefContentPanel.leadingAnchor.constraint(equalTo: reefContentView.leadingAnchor),
            reefContentPanel.trailingAnchor.constraint(equalTo: reefContentView.trailingAnchor),
            reefContentPanel.bottomAnchor.constraint(equalTo: reefContentView.bottomAnchor),

            reefActionRow.heightAnchor.constraint(equalToConstant: 48),
            reefMetricStack.heightAnchor.constraint(equalToConstant: 52),
            reefSegmentContainer.heightAnchor.constraint(equalToConstant: 44),
            reefSegmentStack.topAnchor.constraint(equalTo: reefSegmentContainer.topAnchor, constant: 3),
            reefSegmentStack.leadingAnchor.constraint(equalTo: reefSegmentContainer.leadingAnchor, constant: 3),
            reefSegmentStack.trailingAnchor.constraint(equalTo: reefSegmentContainer.trailingAnchor, constant: -3),
            reefSegmentStack.bottomAnchor.constraint(equalTo: reefSegmentContainer.bottomAnchor, constant: -3),

            reefContentStack.topAnchor.constraint(equalTo: reefContentPanel.topAnchor, constant: 12),
            reefContentStack.leadingAnchor.constraint(equalTo: reefContentPanel.leadingAnchor),
            reefContentStack.trailingAnchor.constraint(equalTo: reefContentPanel.trailingAnchor),
            reefContentStack.bottomAnchor.constraint(equalTo: reefContentPanel.bottomAnchor, constant: -24)
        ])
        reefPanelMinimumHeightConstraint = reefContentPanel.heightAnchor.constraint(greaterThanOrEqualToConstant: 320)
        reefPanelMinimumHeightConstraint?.isActive = true
        updateReefSegments()
    }

    private func fetchLagoonGuest() {
        SuliJoyLagoonProfileRemoteService.shared.fetchLagoonVisitorProfile(seersuckerStripe: lagoonGuestID) { [weak self] result in
            guard let self else { return }
            guard let reefGuest = result.sandbarLayering else {
                self.showLagoonToast(result.coastalWardrobe)
                return
            }
            self.lagoonGuest = reefGuest
            self.renderGuestHeader()
            self.fetchReefContent()
        }
    }

    private func fetchReefContent() {
        switch selectedReefTab {
        case .post:
            SuliJoyLagoonProfileRemoteService.shared.fetchVisitorShoreMoments(seersuckerStripe: lagoonGuestID) { [weak self] result in
                self?.reefMoments = result.sandbarLayering ?? []
                self?.renderReefContent()
            }
        case .shorts:
            SuliJoyLagoonProfileRemoteService.shared.fetchVisitorShellClips(seersuckerStripe: lagoonGuestID) { [weak self] result in
                self?.shellClips = result.sandbarLayering ?? []
                self?.renderReefContent()
            }
        case .events:
            SuliJoyLagoonProfileRemoteService.shared.fetchVisitorTideActivities(seersuckerStripe: lagoonGuestID) { [weak self] result in
                self?.tideActivities = result.sandbarLayering ?? []
                self?.renderReefContent()
            }
        }
    }

    private func renderGuestHeader() {
        guard let lagoonGuest else { return }
        guestTitleLabel.text = lagoonGuest.islandStylistAlias
        guestPortraitRing.portraitView.suliJoyApplyPortrait(lagoonGuest.portraitAssetToken)
        guestPortraitRing.liveBadge.isHidden = true
        lagoonFollowButton.render(state: lagoonGuest.coveAffinityState)
        renderReefMetrics(lagoonGuest)
        updateReefSegments()
    }

    private func renderReefMetrics(_ lagoonGuest: SuliJoyLagoonVisitor) {
        reefMetricStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let reefMetrics = [
            ("Likes", lagoonGuest.shorelineHeartTotal),
            ("Followers", lagoonGuest.reefFollowerTotal),
            ("Following", lagoonGuest.coveFollowingTotal)
        ]
        for (index, reefMetric) in reefMetrics.enumerated() {
            let item = SuliJoyGuestMetricView(
                reefHeadline: reefMetric.0,
                value: reefMetric.1,
                showsTrailingDivider: index < reefMetrics.count - 1
            )
            reefMetricStack.addArrangedSubview(item)
        }
    }

    private func renderReefContent() {
        reefContentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        switch selectedReefTab {
        case .post:
            if reefMoments.isEmpty {
                showReefEmpty("NQos QdayYnPaOmFircP CmVoZmqexnStVsW EfyrFoSml gtYhriwsW esYtEyFllimsptB.i".suliJoyPalmUnfurled)
            } else {
                let hostFollowing = lagoonGuest.map {
                    $0.coveAffinityState != .shorelineUnlinked
                } ?? false
                for moment in reefMoments {
                    let card = SuliJoyGuestMomentFeedCard(moment: moment, hostIsFollowing: hostFollowing)
                    card.onOpenMoment = { [weak self] in self?.openMoment(moment) }
                    card.onHeartTap = { [weak self] in self?.openMoment(moment) }
                    card.onReplyTap = { [weak self] in self?.openMoment(moment) }
                    reefContentStack.addArrangedSubview(card)
                }
            }
        case .shorts:
            if shellClips.isEmpty {
                showReefEmpty(["NooJ wsVhqotrste VvmiY".suliJoyPalmUnfurled, "daeOocsQ YfjrEoGmD gtbhOipsW bsrtgyBlAiRsSte.w".suliJoyPalmUnfurled].joined())
            } else {
                for clip in shellClips {
                    let card = SuliJoyGuestClipPreviewCard(clip: clip)
                    card.onTap = { [weak self] in self?.openClip(clip) }
                    reefContentStack.addArrangedSubview(card)
                }
            }
        case .events:
            if tideActivities.isEmpty {
                showReefEmpty("NMoV heFvFeMnftGsR HfqrAoymb RtNhUicsz MsctpyklRiQsCtk HyReRti.y".suliJoyPalmUnfurled)
            } else {
                for activity in tideActivities {
                    let card = SuliJoyGuestActivityPreviewCard(activity: activity)
                    card.onTap = { [weak self] in self?.openActivity(activity) }
                    reefContentStack.addArrangedSubview(card)
                }
            }
        }
    }

    private func showReefEmpty(_ reefText: String) {
        reefEmptyLabel.text = reefText
        reefContentStack.addArrangedSubview(reefEmptyLabel)
        NSLayoutConstraint.activate([
            reefEmptyLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
    }

    private func updateReefSegments() {
        for (tab, button) in reefSegmentButtons {
            button.isVisitorSelected = tab == selectedReefTab
        }
    }

    @objc private func changeReefTab(_ sender: UIButton) {
        selectedReefTab = SuliJoyGuestCoveTab.allCases[sender.tag]
        updateReefSegments()
        fetchReefContent()
    }

    @objc private func toggleLagoonFollow() {
        guard let lagoonGuest else { return }
        if lagoonGuest.coveAffinityState == .shorelineUnlinked {
            SuliJoyLagoonProfileRemoteService.shared.toggleLagoonVisitorFollow(seersuckerStripe: lagoonGuestID) { [weak self] result in
                guard let self else { return }
                if let updated = result.sandbarLayering {
                    self.lagoonGuest = updated
                    self.renderGuestHeader()
                    NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: updated)
                } else if result.beachwearCapsule != 200, !result.coastalWardrobe.isEmpty {
                    self.showLagoonToast(result.coastalWardrobe)
                }
            }
        } else {
            let sheet = UIAlertController(reefHeadline: lagoonGuest.islandStylistAlias, ingokio: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(reefHeadline: "UtnhfpoYlDlzoswl".suliJoyPalmUnfurled, style: .destructive) { [weak self] _ in
                self?.unfollowLagoonGuest()
            })
            sheet.addAction(UIAlertAction(reefHeadline: "CsaznRcceilO".suliJoyPalmUnfurled, style: .cancel))
            present(sheet, animated: true)
        }
    }

    private func unfollowLagoonGuest() {
        SuliJoyLagoonProfileRemoteService.shared.toggleLagoonVisitorFollow(seersuckerStripe: lagoonGuestID) { [weak self] result in
            guard let self else { return }
            if let updated = result.sandbarLayering {
                self.lagoonGuest = updated
                self.renderGuestHeader()
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: updated)
            } else if result.beachwearCapsule != 200, !result.coastalWardrobe.isEmpty {
                self.showLagoonToast(result.coastalWardrobe)
            }
        }
    }

    @objc private func showHarborMenu() {
        presentSuliJoyHarborGuardMenu { [weak self] in
            guard let self else { return }
            self.presentSuliJoyReportSheet(target: .softDrape(seersuckerStripe: self.lagoonGuestID))
        } block: { [weak self] in
            self?.blockLagoonGuest()
        }
    }

    private func blockLagoonGuest() {
        SuliJoyLagoonProfileRemoteService.shared.blockLagoonVisitor(seersuckerStripe: lagoonGuestID) { [weak self] result in
            guard let self else { return }
            self.showLagoonToast(result.coastalWardrobe)
            NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: self.lagoonGuest)
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc private func openReefLetters() {
        guard lagoonGuest?.coveAffinityState == .reefMutualBond else {
            showReefUnlockNotice()
            return
        }
        SuliJoyLagoonProfileRemoteService.shared.openLetterThread(userID: lagoonGuestID, fallbackName: lagoonGuest?.islandStylistAlias ?? "") { [weak self] result in
            guard let self else { return }
            guard let thread = result.sandbarLayering, !thread.conversationID.isEmpty else {
                self.showLagoonToast(result.coastalWardrobe.isEmpty ? "Messages open after you follow each other." : result.coastalWardrobe)
                return
            }
            let detail = SuliJoyLagoonLetterDetailController(thread: thread)
            self.navigationController?.pushViewController(detail, animated: true)
        }
    }

    private func showReefUnlockNotice() {
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
        text.text = ["CMhwaHtv uaunfdE lvpiu".suliJoyPalmUnfurled, "deo will unlock once\nthey follow you back."].joined()
        text.textColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1)
        text.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        text.numberOfLines = 0
        text.textAlignment = .center

        let ok = SuliJoyGradientButton(reefHeadline: "OvKE".suliJoyPalmUnfurled)
        ok.translatesAutoresizingMaskIntoConstraints = false
        ok.addTarget(self, action: #selector(dismissReefUnlockNotice(_:)), for: .touchUpInside)

        view.addSubview(overlay)
        overlay.addSubview(card)
        [badge, text, ok].forEach { card.addSubview($0) }
        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            card.centerYAnchor.constraint(equalTo: overlay.centerYAnchor, constant: 34),
            card.leadingAnchor.constraint(equalTo: overlay.leadingAnchor, constant: 44),
            card.trailingAnchor.constraint(equalTo: overlay.trailingAnchor, constant: -44),
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

    @objc private func dismissReefUnlockNotice(_ sender: UIButton) {
        guard let overlay = sender.superview?.superview else { return }
        UIView.animate(withDuration: 0.18, animations: {
            overlay.alpha = 0
        }, completion: { _ in
            overlay.removeFromSuperview()
        })
    }

    private func openMoment(_ moment: SuliJoyReefMoment) {
        navigationController?.pushViewController(SuliJoyShoreMomentReefController(moment: moment), animated: true)
    }

    private func openClip(_ clip: SuliJoyShellClip) {
        navigationController?.pushViewController(SuliJoyMusiInDoController(clip: clip), animated: true)
    }

    private func openActivity(_ activity: SuliJoyTideActivity) {
        navigationController?.pushViewController(SuliJoyTideCoastalDetailController(crinkleLinen: activity.tideMark), animated: true)
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

private final class SuliJoyGuestPortraitRingView: UIView {
    private let ringLayer = CAGradientLayer()
    let portraitView = UIImageView()
    let liveBadge = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        ringLayer.colors = [
            UIColor(red: 1, green: 0.45, blue: 0.22, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.84, blue: 0.28, alpha: 1).cgColor,
            UIColor(red: 0.98, green: 0.38, blue: 0.42, alpha: 1).cgColor
        ]
        ringLayer.startPoint = CGPoint(x: 0, y: 0)
        ringLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(ringLayer)

        portraitView.translatesAutoresizingMaskIntoConstraints = false
        portraitView.contentMode = .scaleAspectFill
        portraitView.clipsToBounds = true
        portraitView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)
        addSubview(portraitView)

        liveBadge.translatesAutoresizingMaskIntoConstraints = false
        liveBadge.image = UIImage(named: "sulijoy_live_badge")?.withRenderingMode(.alwaysOriginal)
        liveBadge.contentMode = .scaleAspectFit
        liveBadge.isHidden = true
        addSubview(liveBadge)

        NSLayoutConstraint.activate([
            portraitView.centerXAnchor.constraint(equalTo: centerXAnchor),
            portraitView.centerYAnchor.constraint(equalTo: centerYAnchor),
            portraitView.widthAnchor.constraint(equalToConstant: 144),
            portraitView.heightAnchor.constraint(equalToConstant: 144),
            liveBadge.centerXAnchor.constraint(equalTo: centerXAnchor),
            liveBadge.bottomAnchor.constraint(equalTo: portraitView.bottomAnchor, constant: 6),
            liveBadge.widthAnchor.constraint(equalToConstant: 56),
            liveBadge.heightAnchor.constraint(equalToConstant: 22)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("iunWiCtP(ZcCoVdUeirJ:B)c VhiaQsm enOoYtf RbDereAnu QiUmPpSlLeKmfeRnNtWeadq".suliJoyPalmUnfurled)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        ringLayer.frame = bounds
        ringLayer.cornerRadius = bounds.width / 2
        portraitView.layer.cornerRadius = portraitView.bounds.width / 2
    }
}

private final class SuliJoyGuestMessageButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        layer.cornerRadius = 14
        layer.cornerCurve = .continuous
        setTitle("Message", for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        contentHorizontalAlignment = .center
        if let mark = UIImage(named: "sulijoy_home_chat_mark")?.withRenderingMode(.alwaysOriginal) {
            setImage(mark, for: .normal)
        } else {
            setImage(UIImage(systemName: "heart.text.clipboard.fill"), for: .normal)
            tintColor = .white
        }
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        imageView?.contentMode = .scaleAspectFit
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageView else { return }
        let iconSide: CGFloat = 22
        imageView.bounds = CGRect(x: 0, y: 0, width: iconSide, height: iconSide)
        let titleWidth = titleLabel?.intrinsicContentSize.width ?? 0
        let spacing: CGFloat = 8
        let contentWidth = iconSide + spacing + titleWidth
        let startX = (bounds.width - contentWidth) / 2
        imageView.frame.origin = CGPoint(x: startX, y: (bounds.height - iconSide) / 2)
        titleLabel?.frame.origin = CGPoint(x: startX + iconSide + spacing, y: titleLabel?.frame.origin.y ?? 0)
    }

    required init?(coder: NSCoder) {
        fatalError("iunWiCtP(ZcCoVdUeirJ:B)c VhiaQsm enOoYtf RbDereAnu QiUmPpSlLeKmfeRnNtWeadq".suliJoyPalmUnfurled)
    }
}

private final class SuliJoyGuestFollowButton: UIButton {
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 0)
        layer.masksToBounds = true
        layer.cornerRadius = 14
        layer.cornerCurve = .continuous
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        setTitleColor(.white, for: .normal)
        contentHorizontalAlignment = .center
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }

    required init?(coder: NSCoder) {
        fatalError("iunWiCtP(ZcCoVdUeirJ:B)c VhiaQsm enOoYtf RbDereAnu QiUmPpSlLeKmfeRnNtWeadq".suliJoyPalmUnfurled)
    }

    func render(state: SuliJoyCoveAffinityState) {
        switch state {
        case .shorelineUnlinked:
            setTitle("+ Follow", for: .normal)
            setImage(nil, for: .normal)
            tintColor = .white
            gradientLayer.colors = [
                UIColor(red: 0.54, green: 0.38, blue: 1, alpha: 1).cgColor,
                UIColor(red: 0.35, green: 0.78, blue: 1, alpha: 1).cgColor
            ]
        case .islandAwaitingReturn, .reefMutualBond:
            setTitle("Following", for: .normal)
            setImage(nil, for: .normal)
            tintColor = .white
            gradientLayer.colors = [
                UIColor(red: 0.98, green: 0.72, blue: 0.52, alpha: 1).cgColor,
                UIColor(red: 1, green: 0.82, blue: 0.62, alpha: 1).cgColor
            ]
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 14
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
    }
}

private final class SuliJoyGuestSegmentButton: UIButton {
    private let gradientLayer = CAGradientLayer()

    var isVisitorSelected = false {
        didSet { updateState() }
    }

    init(reefHeadline: String) {
        super.init(frame: .zero)
        setTitle(reefHeadline, for: .normal)
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.72
        titleLabel?.lineBreakMode = .byClipping
        contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        layer.insertSublayer(gradientLayer, at: 0)
        layer.masksToBounds = true
        updateState()
    }

    required init?(coder: NSCoder) {
        fatalError("iwnyiKtn(VcHoudVeErF:y)a hhxaOsW LngoPtm lbVexeini wipmYpalTedmMejnxtjeUdA".suliJoyPalmUnfurled)
    }

    private func updateState() {
        gradientLayer.isHidden = !isVisitorSelected
        setTitleColor(isVisitorSelected ? .black : UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1), for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: isVisitorSelected ? .bold : .medium)
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

private final class SuliJoyGuestMetricView: UIView {
    init(reefHeadline: String, value: Int, showsTrailingDivider: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.text = "\(value)"
        valueLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        valueLabel.textColor = .black
        valueLabel.textAlignment = .center

        let beachCoverup = UILabel()
        beachCoverup.translatesAutoresizingMaskIntoConstraints = false
        beachCoverup.text = reefHeadline
        beachCoverup.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        beachCoverup.textColor = UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 1)
        beachCoverup.textAlignment = .center
        beachCoverup.adjustsFontSizeToFitWidth = true
        beachCoverup.minimumScaleFactor = 0.85

        [valueLabel, beachCoverup].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            beachCoverup.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            beachCoverup.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            beachCoverup.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            beachCoverup.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        if showsTrailingDivider {
            let divider = UIView()
            divider.translatesAutoresizingMaskIntoConstraints = false
            divider.backgroundColor = UIColor.black.withAlphaComponent(0.10)
            addSubview(divider)
            NSLayoutConstraint.activate([
                divider.trailingAnchor.constraint(equalTo: trailingAnchor),
                divider.centerYAnchor.constraint(equalTo: centerYAnchor),
                divider.widthAnchor.constraint(equalToConstant: 1),
                divider.heightAnchor.constraint(equalToConstant: 28)
            ])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("ignHiztL(XctoudzexrP:D)b thMaSsS IncoDtl ObKeHeGnF AiQmCpylEecmxeRnOtQendn".suliJoyPalmUnfurled)
    }
}

private class SuliJoyGuestPreviewControl: UIControl {
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
        fatalError("iVnlibtG(ecCokdtetrH:e)E ThCaBsO xntoXtL vbueneXnV jiCmPpVljeZmheTnrtoeUdQ".suliJoyPalmUnfurled)
    }

    @objc private func tapped() { onTap?() }
}

private final class SuliJoyGuestMomentFeedCard: UIView {
    var onOpenMoment: (() -> Void)?
    var onHeartTap: (() -> Void)?
    var onReplyTap: (() -> Void)?

    private let diaryCell = suliJoyCoastalDiary(style: .default, reuseIdentifier: nil)
    private var heightConstraint: NSLayoutConstraint?

    init(moment: SuliJoyReefMoment, hostIsFollowing: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        diaryCell.configure(with: moment, isFollowing: hostIsFollowing)
        diaryCell.onHarborMoreTap = { [weak self] in self?.onOpenMoment?() }
        diaryCell.onHeartTap = { [weak self] in self?.onHeartTap?() }
        diaryCell.onReplyTap = { [weak self] in self?.onReplyTap?() }
        diaryCell.onStylistTap = { [weak self] in self?.onOpenMoment?() }
        diaryCell.onWaveTap = { [weak self] in self?.onOpenMoment?() }
        diaryCell.contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(diaryCell.contentView)
        heightConstraint = heightAnchor.constraint(equalToConstant: 320)
        heightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            diaryCell.contentView.topAnchor.constraint(equalTo: topAnchor),
            diaryCell.contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            diaryCell.contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            diaryCell.contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("iDnKiztL(GcUosdCeprz:s)A ChLaosu fnQovtz xbreDeJnp liDmdpClEegmaeXnhtneedu".suliJoyPalmUnfurled)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.width > 0 else { return }
        diaryCell.bounds = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        diaryCell.contentView.bounds = diaryCell.bounds
        diaryCell.setNeedsLayout()
        diaryCell.layoutIfNeeded()
        let fitted = diaryCell.contentView.systemLayoutSizeFitting(
            CGSize(width: bounds.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        if abs((heightConstraint?.constant ?? 0) - fitted) > 1 {
            heightConstraint?.constant = max(fitted, 200)
        }
    }
}

private final class SuliJoyGuestClipPreviewCard: SuliJoyGuestPreviewControl {
    init(clip: SuliJoyShellClip) {
        super.init(frame: .zero)
        backgroundColor = .clear
        layer.cornerRadius = 24

        let image = UIImageView()
        image.suliJoyApplyPhoto(clip.tropicalMotif.sandyNeutral)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 24
        image.isUserInteractionEnabled = false

        let playMark = UIImageView(image: UIImage(systemName: "play.circle.fill"))
        playMark.translatesAutoresizingMaskIntoConstraints = false
        playMark.tintColor = .white
        playMark.contentMode = .scaleAspectFit

        let reportHost = UIView()
        reportHost.translatesAutoresizingMaskIntoConstraints = false
        reportHost.backgroundColor = UIColor.white.withAlphaComponent(0.92)
        reportHost.layer.cornerRadius = 14
        let report = UIImageView(image: UIImage(systemName: "exclamationmark"))
        report.translatesAutoresizingMaskIntoConstraints = false
        report.tintColor = .black
        reportHost.addSubview(report)

        [image, playMark, reportHost].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1.18),
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            playMark.centerXAnchor.constraint(equalTo: image.centerXAnchor),
            playMark.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            playMark.widthAnchor.constraint(equalToConstant: 56),
            playMark.heightAnchor.constraint(equalToConstant: 56),
            reportHost.topAnchor.constraint(equalTo: image.topAnchor, constant: 12),
            reportHost.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -12),
            reportHost.widthAnchor.constraint(equalToConstant: 28),
            reportHost.heightAnchor.constraint(equalToConstant: 28),
            report.centerXAnchor.constraint(equalTo: reportHost.centerXAnchor),
            report.centerYAnchor.constraint(equalTo: reportHost.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("icnHiTts(fcJoZdkeurV:u)C phdaTsf rnOoMtB EbjeUeNnw YiBmApAlzepmieTnotwehdf".suliJoyPalmUnfurled)
    }
}

private final class SuliJoyGuestActivityPreviewCard: SuliJoyGuestPreviewControl {
    init(activity: SuliJoyTideActivity) {
        super.init(frame: .zero)
        let image = UIImageView()
        image.suliJoyApplyPhoto(activity.reefGallery.first?.reefAssetToken ?? activity.tideFallbackHeroToken)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 16

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = activity.tideTitleLine
        title.font = UIFont.systemFont(ofSize: 16, weight: .black)
        title.textColor = .suliInk
        title.numberOfLines = 1

        let meta = UILabel()
        meta.translatesAutoresizingMaskIntoConstraints = false
        meta.text = "\(activity.shoreSpotLine)\n\(activity.tideScheduleLine)"
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
        fatalError("ifnaifty(hcEoPdaevrZ:V)K jhjaQsV fnnoVta WbZeOeNnH VigmwpglseSmqeNnwtHeYdJ".suliJoyPalmUnfurled)
    }
}
