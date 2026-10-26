import UIKit

private enum SuliJoyGuestCoveTab: CaseIterable {
    case makeShoreBioHeading
    case shorts
    case events

    var reefTitle: String {
        switch self {
        case .makeShoreBioHeading:
            return "Pxoxsxtx".suliJoyPalmUnfurled
        case .shorts:
            return "Sxhxoxrxtx xVxixdxexox".suliJoyPalmUnfurled
        case .events:
            return "Exvxexnxtxsx".suliJoyPalmUnfurled
        }
    }
}

enum audioPlayerDidFinishPlaying {
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
    private let nibBundleOrNil = UIStackView()
    private let guestTitleLabel = UILabel()
    private let harborMoreButton = UIButton(type: .system)
    private let settleReefMotionPublish = shorelineOptionRail()
    private let reefMetricStack = UIStackView()
    private let tideSnapshot = UIStackView()
    private let existingDraft = reefLaunchEntries()
    private let lagoonFollowButton = SuliJoyGuestFollowButton()
    private let reefSegmentContainer = UIView()
    private let reefSegmentStack = UIStackView()
    private var reefSegmentButtons: [SuliJoyGuestCoveTab: SuliJoyGuestSegmentButton] = [:]
    private let harborParticipantRail = UIView()
    private let reefContentStack = UIStackView()
    private let reefEmptyLabel = UILabel()
    private var ringInset: NSLayoutConstraint?

    init(visitorID lagoonGuestID: String, activeCoveSection: audioPlayerDidFinishPlaying = .moments) {
        self.lagoonGuestID = lagoonGuestID
        switch activeCoveSection {
        case .moments:
            selectedReefTab = .makeShoreBioHeading
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
        let secure = nibBundleOrNil.convert(nibBundleOrNil.bounds, to: reefScrollView)
        let shoreOtherTextView = max(reefScrollView.bounds.height - secure.maxY - 8, 260)
        ringInset?.constant = shoreOtherTextView
    }

    private func buildReefScene() {
        let beachwearCapsule = UIButton(type: .system)
        beachwearCapsule.translatesAutoresizingMaskIntoConstraints = false
        beachwearCapsule.setImage(UIImage(systemName: "cxhxexvxrxoxnx.xlxexfxtx".suliJoyPalmUnfurled), for: .normal)
        beachwearCapsule.tintColor = .black
        beachwearCapsule.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        guestTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        guestTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        guestTitleLabel.textColor = .black
        guestTitleLabel.textAlignment = .center

        harborMoreButton.translatesAutoresizingMaskIntoConstraints = false
        harborMoreButton.setImage(UIImage(systemName: "exlxlxixpxsxixsx".suliJoyPalmUnfurled), for: .normal)
        harborMoreButton.tintColor = .black
        harborMoreButton.addTarget(self, action: #selector(showHarborMenu), for: .touchUpInside)

        reefScrollView.translatesAutoresizingMaskIntoConstraints = false
        reefScrollView.showsVerticalScrollIndicator = false
        reefScrollView.alwaysBounceVertical = true
        reefContentView.translatesAutoresizingMaskIntoConstraints = false
        nibBundleOrNil.translatesAutoresizingMaskIntoConstraints = false
        nibBundleOrNil.axis = .vertical
        nibBundleOrNil.alignment = .fill
        nibBundleOrNil.spacing = 20

        lagoonFollowButton.translatesAutoresizingMaskIntoConstraints = false
        lagoonFollowButton.addTarget(self, action: #selector(toggleLagoonFollow), for: .touchUpInside)

        existingDraft.translatesAutoresizingMaskIntoConstraints = false
        existingDraft.addTarget(self, action: #selector(openReefLetters), for: .touchUpInside)

        tideSnapshot.translatesAutoresizingMaskIntoConstraints = false
        tideSnapshot.axis = .horizontal
        tideSnapshot.spacing = 12
        tideSnapshot.distribution = .fillEqually
        tideSnapshot.addArrangedSubview(existingDraft)
        tideSnapshot.addArrangedSubview(lagoonFollowButton)

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

        harborParticipantRail.translatesAutoresizingMaskIntoConstraints = false
        harborParticipantRail.backgroundColor = .white
        harborParticipantRail.layer.cornerRadius = 28
        harborParticipantRail.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        harborParticipantRail.clipsToBounds = true

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
        reefContentView.addSubview(nibBundleOrNil)
        let buildShoreReportReef = UIView()
        buildShoreReportReef.translatesAutoresizingMaskIntoConstraints = false
        buildShoreReportReef.addSubview(settleReefMotionPublish)
        NSLayoutConstraint.activate([
            settleReefMotionPublish.centerXAnchor.constraint(equalTo: buildShoreReportReef.centerXAnchor),
            settleReefMotionPublish.topAnchor.constraint(equalTo: buildShoreReportReef.topAnchor),
            settleReefMotionPublish.bottomAnchor.constraint(equalTo: buildShoreReportReef.bottomAnchor),
            settleReefMotionPublish.widthAnchor.constraint(equalToConstant: 160),
            settleReefMotionPublish.heightAnchor.constraint(equalToConstant: 160),
            buildShoreReportReef.heightAnchor.constraint(equalToConstant: 160)
        ])

        [buildShoreReportReef, reefMetricStack, tideSnapshot, reefSegmentContainer].forEach {
            nibBundleOrNil.addArrangedSubview($0)
        }
        reefContentView.addSubview(harborParticipantRail)
        harborParticipantRail.addSubview(reefContentStack)
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

            nibBundleOrNil.topAnchor.constraint(equalTo: reefContentView.topAnchor, constant: 4),
            nibBundleOrNil.leadingAnchor.constraint(equalTo: reefContentView.leadingAnchor, constant: 20),
            nibBundleOrNil.trailingAnchor.constraint(equalTo: reefContentView.trailingAnchor, constant: -20),

            harborParticipantRail.topAnchor.constraint(equalTo: reefSegmentContainer.bottomAnchor, constant: 10),
            harborParticipantRail.leadingAnchor.constraint(equalTo: reefContentView.leadingAnchor),
            harborParticipantRail.trailingAnchor.constraint(equalTo: reefContentView.trailingAnchor),
            harborParticipantRail.bottomAnchor.constraint(equalTo: reefContentView.bottomAnchor),

            tideSnapshot.heightAnchor.constraint(equalToConstant: 48),
            reefMetricStack.heightAnchor.constraint(equalToConstant: 52),
            reefSegmentContainer.heightAnchor.constraint(equalToConstant: 44),
            reefSegmentStack.topAnchor.constraint(equalTo: reefSegmentContainer.topAnchor, constant: 3),
            reefSegmentStack.leadingAnchor.constraint(equalTo: reefSegmentContainer.leadingAnchor, constant: 3),
            reefSegmentStack.trailingAnchor.constraint(equalTo: reefSegmentContainer.trailingAnchor, constant: -3),
            reefSegmentStack.bottomAnchor.constraint(equalTo: reefSegmentContainer.bottomAnchor, constant: -3),

            reefContentStack.topAnchor.constraint(equalTo: harborParticipantRail.topAnchor, constant: 12),
            reefContentStack.leadingAnchor.constraint(equalTo: harborParticipantRail.leadingAnchor),
            reefContentStack.trailingAnchor.constraint(equalTo: harborParticipantRail.trailingAnchor),
            reefContentStack.bottomAnchor.constraint(equalTo: harborParticipantRail.bottomAnchor, constant: -24)
        ])
        ringInset = harborParticipantRail.heightAnchor.constraint(greaterThanOrEqualToConstant: 320)
        ringInset?.isActive = true
        updateReefSegments()
    }

    private func fetchLagoonGuest() {
        suliJoyPalmRankingaccount.shared.fetchLagoonVisitorProfile(seersuckerStripe: lagoonGuestID) { [weak self] result in
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
        case .makeShoreBioHeading:
            suliJoyPalmRankingaccount.shared.fetchVisitorShoreMoments(seersuckerStripe: lagoonGuestID) { [weak self] result in
                self?.reefMoments = result.sandbarLayering ?? []
                self?.renderReefContent()
            }
        case .shorts:
            suliJoyPalmRankingaccount.shared.fetchVisitorShellClips(seersuckerStripe: lagoonGuestID) { [weak self] result in
                self?.shellClips = result.sandbarLayering ?? []
                self?.renderReefContent()
            }
        case .events:
            suliJoyPalmRankingaccount.shared.fetchVisitorTideActivities(seersuckerStripe: lagoonGuestID) { [weak self] result in
                self?.tideActivities = result.sandbarLayering ?? []
                self?.renderReefContent()
            }
        }
    }

    private func renderGuestHeader() {
        guard let lagoonGuest else { return }
        guestTitleLabel.text = lagoonGuest.islandStylistAlias
        settleReefMotionPublish.waveOnlyDurationGlyph.actionRow(lagoonGuest.portraitAssetToken)
        settleReefMotionPublish.tuneMarkShell.isHidden = true
        lagoonFollowButton.render(state: lagoonGuest.coveAffinityState)
        renderReefMetrics(lagoonGuest)
        updateReefSegments()
    }

    private func renderReefMetrics(_ lagoonGuest: SuliJoyLagoonVisitor) {
        reefMetricStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let reefMetrics = [
            ("Lxixkxexsx".suliJoyPalmUnfurled, lagoonGuest.shorelineHeartTotal),
            ("Fxoxlxlxoxwxexrxsx".suliJoyPalmUnfurled, lagoonGuest.reefFollowerTotal),
            ("Fxoxlxlxoxwxixnxgx".suliJoyPalmUnfurled, lagoonGuest.coveFollowingTotal)
        ]
        for (index, reefMetric) in reefMetrics.enumerated() {
            let item = SuliJoyGuestMetricView(
                reefHeadline: reefMetric.0,
                value: reefMetric.1,
                islandCodeGlyph: index < reefMetrics.count - 1
            )
            reefMetricStack.addArrangedSubview(item)
        }
    }

    private func renderReefContent() {
        reefContentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        switch selectedReefTab {
        case .makeShoreBioHeading:
            if reefMoments.isEmpty {
                showReefEmpty("NQos QdayYnPaOmFircP CmVoZmqexnStVsW EfyrFoSml gtYhriwsW esYtEyFllimsptB.i".suliJoyPalmUnfurled)
            } else {
                let WaveHarborError = lagoonGuest.map {
                    $0.coveAffinityState != .shorelineUnlinked
                } ?? false
                for moment in reefMoments {
                    let card = sizeInput(moment: moment, openReefMotionPicker: WaveHarborError)
                    card.showShoreInlineNote = { [weak self] in self?.openMoment(moment) }
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
            suliJoyPalmRankingaccount.shared.toggleLagoonVisitorFollow(seersuckerStripe: lagoonGuestID) { [weak self] result in
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
        suliJoyPalmRankingaccount.shared.toggleLagoonVisitorFollow(seersuckerStripe: lagoonGuestID) { [weak self] result in
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
        suliJoyPalmRankingaccount.shared.blockLagoonVisitor(seersuckerStripe: lagoonGuestID) { [weak self] result in
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
        suliJoyPalmRankingaccount.shared.shoreDetailScrollCanvas(userID: lagoonGuestID, keyboardWillHide: lagoonGuest?.islandStylistAlias ?? "") { [weak self] result in
            guard let self else { return }
            guard let openShoreMomentDetail = result.sandbarLayering, !openShoreMomentDetail.LagoonRadioShape.isEmpty else {
                self.showLagoonToast(result.coastalWardrobe.isEmpty ? "Mxexsxsxaxgxexsx xoxpxexnx xaxfxtxexrx xyxoxux xfxoxlxlxoxwx xexaxcxhx xoxtxhxexrx.x".suliJoyPalmUnfurled : result.coastalWardrobe)
                return
            }
            let detail = isCover(openShoreMomentDetail: openShoreMomentDetail)
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

        let badge = UIImageView(image: UIImage(named: "sxuxlxixjxoxyx_xvxixsxixtxoxrx_xuxnxlxoxcxkx_xnxoxtxixcxex_xbxaxdxgxex".suliJoyPalmUnfurled))
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.contentMode = .scaleAspectFit

        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = ["CMhwaHtv uaunfdE lvpiu".suliJoyPalmUnfurled, "dxexox xwxixlxlx xuxnxlxoxcxkx xoxnxcxex\nxtxhxexyx xfxoxlxlxoxwx xyxoxux xbxaxcxkx.x".suliJoyPalmUnfurled].joined()
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
        ok.accessibilityIdentifier = "sxuxlxixjxoxyx_xuxnxlxoxcxkx_xnxoxtxixcxex_xoxkx".suliJoyPalmUnfurled
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

private final class shorelineOptionRail: UIView {
    private let chosenResortTheme = CAGradientLayer()
    let waveOnlyDurationGlyph = UIImageView()
    let tuneMarkShell = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        chosenResortTheme.colors = [
            UIColor(red: 1, green: 0.45, blue: 0.22, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.84, blue: 0.28, alpha: 1).cgColor,
            UIColor(red: 0.98, green: 0.38, blue: 0.42, alpha: 1).cgColor
        ]
        chosenResortTheme.startPoint = CGPoint(x: 0, y: 0)
        chosenResortTheme.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(chosenResortTheme)

        waveOnlyDurationGlyph.translatesAutoresizingMaskIntoConstraints = false
        waveOnlyDurationGlyph.contentMode = .scaleAspectFill
        waveOnlyDurationGlyph.clipsToBounds = true
        waveOnlyDurationGlyph.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)
        addSubview(waveOnlyDurationGlyph)

        tuneMarkShell.translatesAutoresizingMaskIntoConstraints = false
        tuneMarkShell.image = UIImage(named: "sxuxlxixjxoxyx_xlxixvxex_xbxaxdxgxex".suliJoyPalmUnfurled)?.withRenderingMode(.alwaysOriginal)
        tuneMarkShell.contentMode = .scaleAspectFit
        tuneMarkShell.isHidden = true
        addSubview(tuneMarkShell)

        NSLayoutConstraint.activate([
            waveOnlyDurationGlyph.centerXAnchor.constraint(equalTo: centerXAnchor),
            waveOnlyDurationGlyph.centerYAnchor.constraint(equalTo: centerYAnchor),
            waveOnlyDurationGlyph.widthAnchor.constraint(equalToConstant: 144),
            waveOnlyDurationGlyph.heightAnchor.constraint(equalToConstant: 144),
            tuneMarkShell.centerXAnchor.constraint(equalTo: centerXAnchor),
            tuneMarkShell.bottomAnchor.constraint(equalTo: waveOnlyDurationGlyph.bottomAnchor, constant: 6),
            tuneMarkShell.widthAnchor.constraint(equalToConstant: 56),
            tuneMarkShell.heightAnchor.constraint(equalToConstant: 22)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("iunWiCtP(ZcCoVdUeirJ:B)c VhiaQsm enOoYtf RbDereAnu QiUmPpSlLeKmfeRnNtWeadq".suliJoyPalmUnfurled)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        chosenResortTheme.frame = bounds
        chosenResortTheme.cornerRadius = bounds.width / 2
        waveOnlyDurationGlyph.layer.cornerRadius = waveOnlyDurationGlyph.bounds.width / 2
    }
}

private final class reefLaunchEntries: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        layer.cornerRadius = 14
        layer.cornerCurve = .continuous
        setTitle("Mxexsxsxaxgxex".suliJoyPalmUnfurled, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        contentHorizontalAlignment = .center
        if let tideIndicatorWidth = UIImage(named: "sxuxlxixjxoxyx_xhxoxmxex_xcxhxaxtx_xmxaxrxkx".suliJoyPalmUnfurled)?.withRenderingMode(.alwaysOriginal) {
            setImage(tideIndicatorWidth, for: .normal)
        } else {
            setImage(UIImage(systemName: "hxexaxrxtx.xtxexxxtx.xcxlxixpxbxoxaxrxdx.xfxixlxlx".suliJoyPalmUnfurled), for: .normal)
            tintColor = .white
        }
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        imageView?.contentMode = .scaleAspectFit
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let nibNameOrNil = imageView else { return }
        let reefReplyPortrait: CGFloat = 22
        nibNameOrNil.bounds = CGRect(x: 0, y: 0, width: reefReplyPortrait, height: reefReplyPortrait)
        let arrangeShoreSignupReefScene = titleLabel?.intrinsicContentSize.width ?? 0
        let spacing: CGFloat = 8
        let shoreFileURL = reefReplyPortrait + spacing + arrangeShoreSignupReefScene
        let resortStack = (bounds.width - shoreFileURL) / 2
        nibNameOrNil.frame.origin = CGPoint(x: resortStack, y: (bounds.height - reefReplyPortrait) / 2)
        titleLabel?.frame.origin = CGPoint(x: resortStack + reefReplyPortrait + spacing, y: titleLabel?.frame.origin.y ?? 0)
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
            setTitle("+x xFxoxlxlxoxwx".suliJoyPalmUnfurled, for: .normal)
            setImage(nil, for: .normal)
            tintColor = .white
            gradientLayer.colors = [
                UIColor(red: 0.54, green: 0.38, blue: 1, alpha: 1).cgColor,
                UIColor(red: 0.35, green: 0.78, blue: 1, alpha: 1).cgColor
            ]
        case .islandAwaitingReturn, .reefMutualBond:
            setTitle("Fxoxlxlxoxwxixnxgx".suliJoyPalmUnfurled, for: .normal)
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
    init(reefHeadline: String, value: Int, islandCodeGlyph: Bool) {
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

        if islandCodeGlyph {
            let buttons = UIView()
            buttons.translatesAutoresizingMaskIntoConstraints = false
            buttons.backgroundColor = UIColor.black.withAlphaComponent(0.10)
            addSubview(buttons)
            NSLayoutConstraint.activate([
                buttons.trailingAnchor.constraint(equalTo: trailingAnchor),
                buttons.centerYAnchor.constraint(equalTo: centerYAnchor),
                buttons.widthAnchor.constraint(equalToConstant: 1),
                buttons.heightAnchor.constraint(equalToConstant: 28)
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

private final class sizeInput: UIView {
    var showShoreInlineNote: (() -> Void)?
    var onHeartTap: (() -> Void)?
    var onReplyTap: (() -> Void)?

    private let voiceSeat = suliJoyCoastalDiary(style: .default, reuseIdentifier: nil)
    private var tunePearlGridView: NSLayoutConstraint?

    init(moment: SuliJoyReefMoment, openReefMotionPicker: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        voiceSeat.configure(with: moment, isFollowing: openReefMotionPicker)
        voiceSeat.onHarborMoreTap = { [weak self] in self?.showShoreInlineNote?() }
        voiceSeat.onHeartTap = { [weak self] in self?.onHeartTap?() }
        voiceSeat.onReplyTap = { [weak self] in self?.onReplyTap?() }
        voiceSeat.onStylistTap = { [weak self] in self?.showShoreInlineNote?() }
        voiceSeat.onWaveTap = { [weak self] in self?.showShoreInlineNote?() }
        voiceSeat.contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(voiceSeat.contentView)
        tunePearlGridView = heightAnchor.constraint(equalToConstant: 320)
        tunePearlGridView?.isActive = true
        NSLayoutConstraint.activate([
            voiceSeat.contentView.topAnchor.constraint(equalTo: topAnchor),
            voiceSeat.contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            voiceSeat.contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            voiceSeat.contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("iDnKiztL(GcUosdCeprz:s)A ChLaosu fnQovtz xbreDeJnp liDmdpClEegmaeXnhtneedu".suliJoyPalmUnfurled)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard bounds.width > 0 else { return }
        voiceSeat.bounds = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        voiceSeat.contentView.bounds = voiceSeat.bounds
        voiceSeat.setNeedsLayout()
        voiceSeat.layoutIfNeeded()
        let password = voiceSeat.contentView.systemLayoutSizeFitting(
            CGSize(width: bounds.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        if abs((tunePearlGridView?.constant ?? 0) - password) > 1 {
            tunePearlGridView?.constant = max(password, 200)
        }
    }
}

private final class SuliJoyGuestClipPreviewCard: SuliJoyGuestPreviewControl {
    init(clip: SuliJoyShellClip) {
        super.init(frame: .zero)
        backgroundColor = .clear
        layer.cornerRadius = 24

        let image = UIImageView()
        image.shoreCell(clip.tropicalMotif.sandyNeutral)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 24
        image.isUserInteractionEnabled = false

        let openShoreModerationMenu = UIImageView(image: UIImage(systemName: "pxlxaxyx.xcxixrxcxlxex.xfxixlxlx".suliJoyPalmUnfurled))
        openShoreModerationMenu.translatesAutoresizingMaskIntoConstraints = false
        openShoreModerationMenu.tintColor = .white
        openShoreModerationMenu.contentMode = .scaleAspectFit

        let lagoonSeatMark = UIView()
        lagoonSeatMark.translatesAutoresizingMaskIntoConstraints = false
        lagoonSeatMark.backgroundColor = UIColor.white.withAlphaComponent(0.92)
        lagoonSeatMark.layer.cornerRadius = 14
        let slulightreport = UIImageView(image: UIImage(systemName: "exxxcxlxaxmxaxtxixoxnxmxaxrxkx".suliJoyPalmUnfurled))
        slulightreport.translatesAutoresizingMaskIntoConstraints = false
        slulightreport.tintColor = .black
        lagoonSeatMark.addSubview(slulightreport)

        [image, openShoreModerationMenu, lagoonSeatMark].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1.18),
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            openShoreModerationMenu.centerXAnchor.constraint(equalTo: image.centerXAnchor),
            openShoreModerationMenu.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            openShoreModerationMenu.widthAnchor.constraint(equalToConstant: 56),
            openShoreModerationMenu.heightAnchor.constraint(equalToConstant: 56),
            lagoonSeatMark.topAnchor.constraint(equalTo: image.topAnchor, constant: 12),
            lagoonSeatMark.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -12),
            lagoonSeatMark.widthAnchor.constraint(equalToConstant: 28),
            lagoonSeatMark.heightAnchor.constraint(equalToConstant: 28),
            slulightreport.centerXAnchor.constraint(equalTo: lagoonSeatMark.centerXAnchor),
            slulightreport.centerYAnchor.constraint(equalTo: lagoonSeatMark.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("icnHiTts(fcJoZdkeurV:u)C phdaTsf rnOoMtB EbjeUeNnw YiBmApAlzepmieTnotwehdf".suliJoyPalmUnfurled)
    }
}

private final class SuliJoyGuestActivityPreviewCard: SuliJoyGuestPreviewControl {
    init(activity: SuliJoyTideActivity) {
        super.init(frame: .zero)
        let lagoonSeatMarkbigh = UIImageView()
        lagoonSeatMarkbigh.shoreCell(activity.reefGallery.first?.reefAssetToken ?? activity.tideFallbackHeroToken)
        lagoonSeatMarkbigh.translatesAutoresizingMaskIntoConstraints = false
        lagoonSeatMarkbigh.contentMode = .scaleAspectFill
        lagoonSeatMarkbigh.clipsToBounds = true
        lagoonSeatMarkbigh.layer.cornerRadius = 16

        let pinwhoMistVeil = UILabel()
        pinwhoMistVeil.translatesAutoresizingMaskIntoConstraints = false
        pinwhoMistVeil.text = activity.tideTitleLine
        pinwhoMistVeil.font = UIFont.systemFont(ofSize: 16, weight: .black)
        pinwhoMistVeil.textColor = .suliInk
        pinwhoMistVeil.numberOfLines = 1

        let sulightareme = UILabel()
        sulightareme.translatesAutoresizingMaskIntoConstraints = false
        sulightareme.text = "\(activity.shoreSpotLine)\("\nx".suliJoyPalmUnfurled)\(activity.tideScheduleLine)"
        sulightareme.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        sulightareme.textColor = .suliMutedInk
        sulightareme.numberOfLines = 2

        [lagoonSeatMarkbigh, pinwhoMistVeil, sulightareme].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            lagoonSeatMarkbigh.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            lagoonSeatMarkbigh.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            lagoonSeatMarkbigh.widthAnchor.constraint(equalToConstant: 108),
            lagoonSeatMarkbigh.heightAnchor.constraint(equalToConstant: 88),
            pinwhoMistVeil.topAnchor.constraint(equalTo: lagoonSeatMarkbigh.topAnchor, constant: 4),
            pinwhoMistVeil.leadingAnchor.constraint(equalTo: lagoonSeatMarkbigh.trailingAnchor, constant: 12),
            pinwhoMistVeil.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            sulightareme.topAnchor.constraint(equalTo: pinwhoMistVeil.bottomAnchor, constant: 10),
            sulightareme.leadingAnchor.constraint(equalTo: pinwhoMistVeil.leadingAnchor),
            sulightareme.trailingAnchor.constraint(equalTo: pinwhoMistVeil.trailingAnchor),
            sulightareme.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12),
            lagoonSeatMarkbigh.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("ifnaifty(hcEoPdaevrZ:V)K jhjaQsV fnnoVta WbZeOeNnH VigmwpglseSmqeNnwtHeYdJ".suliJoyPalmUnfurled)
    }
}
