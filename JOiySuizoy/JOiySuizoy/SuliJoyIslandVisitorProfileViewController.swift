import UIKit

private enum SuliJoyGuestCoveTab: CaseIterable {
    case dynamic
    case shorts
    case events

    var reefTitle: String {
        switch self {
        case .dynamic:
            return "Dynamic"
        case .shorts:
            return ["Short ", "Vi", "deo"].joined()
        case .events:
            return "Events"
        }
    }
}

final class SuliJoyIslandGuestProfileViewController: SuliJoyTropicCanvasController {
    private let lagoonGuestID: String
    private var lagoonGuest: SuliJoyLagoonVisitor?
    private var selectedReefTab: SuliJoyGuestCoveTab = .shorts
    private var reefMoments: [SuliJoyReefMoment] = []
    private var shellClips: [SuliJoyShellClip] = []
    private var tideActivities: [SuliJoyTideActivity] = []

    private let reefScrollView = UIScrollView()
    private let reefContentView = UIView()
    private let reefStackView = UIStackView()
    private let guestTitleLabel = UILabel()
    private let harborMoreButton = UIButton(type: .system)
    private let guestAvatarView = UIImageView()
    private let lagoonFollowButton = SuliJoyGuestFollowButton()
    private let reefMetricStack = UIStackView()
    private let reefSegmentContainer = UIView()
    private let reefSegmentStack = UIStackView()
    private var reefSegmentButtons: [SuliJoyGuestCoveTab: SuliJoyGuestSegmentButton] = [:]
    private let reefContentStack = UIStackView()
    private let reefEmptyLabel = UILabel()
    private let bottomActionBar = UIStackView()
    private let reefLettersButton = SuliJoyGuestActionButton(reefHeadline: ["Mes", "sage"].joined(), systemName: ["mes", "sage.fill"].joined(), purple: true)
    private let reefMotionButton = SuliJoyGuestActionButton(reefHeadline: ["Vi", "deo"].joined(), systemName: ["vid", "eo.fill"].joined(), purple: false)
    private var reefBottomConstraint: NSLayoutConstraint?

    init(visitorID lagoonGuestID: String) {
        self.lagoonGuestID = lagoonGuestID
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
        reefStackView.translatesAutoresizingMaskIntoConstraints = false
        reefStackView.axis = .vertical
        reefStackView.alignment = .center
        reefStackView.spacing = 20

        guestAvatarView.translatesAutoresizingMaskIntoConstraints = false
        guestAvatarView.contentMode = .scaleAspectFill
        guestAvatarView.clipsToBounds = true
        guestAvatarView.layer.cornerRadius = 72

        lagoonFollowButton.translatesAutoresizingMaskIntoConstraints = false
        lagoonFollowButton.addTarget(self, action: #selector(toggleLagoonFollow), for: .touchUpInside)

        reefMetricStack.translatesAutoresizingMaskIntoConstraints = false
        reefMetricStack.axis = .horizontal
        reefMetricStack.distribution = .fillEqually
        reefMetricStack.alignment = .center

        reefSegmentContainer.translatesAutoresizingMaskIntoConstraints = false
        reefSegmentContainer.backgroundColor = .white
        reefSegmentContainer.layer.cornerRadius = 20
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

        reefContentStack.translatesAutoresizingMaskIntoConstraints = false
        reefContentStack.axis = .vertical
        reefContentStack.spacing = 16
        reefContentStack.alignment = .fill

        reefEmptyLabel.translatesAutoresizingMaskIntoConstraints = false
        reefEmptyLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        reefEmptyLabel.textColor = .suliMutedInk
        reefEmptyLabel.textAlignment = .center
        reefEmptyLabel.numberOfLines = 0

        bottomActionBar.translatesAutoresizingMaskIntoConstraints = false
        bottomActionBar.axis = .horizontal
        bottomActionBar.spacing = 16
        bottomActionBar.distribution = .fillEqually
        bottomActionBar.isHidden = true
        reefLettersButton.addTarget(self, action: #selector(openReefLetters), for: .touchUpInside)
        reefMotionButton.addTarget(self, action: #selector(openReefMotionPreview), for: .touchUpInside)
        bottomActionBar.addArrangedSubview(reefLettersButton)
        bottomActionBar.addArrangedSubview(reefMotionButton)

        [beachwearCapsule, guestTitleLabel, harborMoreButton, reefScrollView, bottomActionBar].forEach { view.addSubview($0) }
        reefScrollView.addSubview(reefContentView)
        reefContentView.addSubview(reefStackView)
        [guestAvatarView, lagoonFollowButton, reefMetricStack, reefSegmentContainer, reefContentStack].forEach { reefStackView.addArrangedSubview($0) }
        reefContentStack.addArrangedSubview(reefEmptyLabel)

        reefBottomConstraint = reefScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        reefBottomConstraint?.isActive = true

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

            reefContentView.topAnchor.constraint(equalTo: reefScrollView.contentLayoutGuide.topAnchor),
            reefContentView.leadingAnchor.constraint(equalTo: reefScrollView.contentLayoutGuide.leadingAnchor),
            reefContentView.trailingAnchor.constraint(equalTo: reefScrollView.contentLayoutGuide.trailingAnchor),
            reefContentView.bottomAnchor.constraint(equalTo: reefScrollView.contentLayoutGuide.bottomAnchor),
            reefContentView.widthAnchor.constraint(equalTo: reefScrollView.frameLayoutGuide.widthAnchor),

            reefStackView.topAnchor.constraint(equalTo: reefContentView.topAnchor, constant: 8),
            reefStackView.leadingAnchor.constraint(equalTo: reefContentView.leadingAnchor, constant: 24),
            reefStackView.trailingAnchor.constraint(equalTo: reefContentView.trailingAnchor, constant: -24),
            reefStackView.bottomAnchor.constraint(equalTo: reefContentView.bottomAnchor, constant: -28),

            guestAvatarView.widthAnchor.constraint(equalToConstant: 144),
            guestAvatarView.heightAnchor.constraint(equalToConstant: 144),
            lagoonFollowButton.widthAnchor.constraint(equalToConstant: 60),
            lagoonFollowButton.heightAnchor.constraint(equalToConstant: 24),
            reefMetricStack.leadingAnchor.constraint(equalTo: reefStackView.leadingAnchor, constant: 18),
            reefMetricStack.trailingAnchor.constraint(equalTo: reefStackView.trailingAnchor, constant: -18),
            reefMetricStack.heightAnchor.constraint(equalToConstant: 52),
            reefSegmentContainer.leadingAnchor.constraint(equalTo: reefStackView.leadingAnchor, constant: 6),
            reefSegmentContainer.trailingAnchor.constraint(equalTo: reefStackView.trailingAnchor, constant: -6),
            reefSegmentContainer.heightAnchor.constraint(equalToConstant: 40),
            reefSegmentStack.topAnchor.constraint(equalTo: reefSegmentContainer.topAnchor, constant: 3),
            reefSegmentStack.leadingAnchor.constraint(equalTo: reefSegmentContainer.leadingAnchor, constant: 3),
            reefSegmentStack.trailingAnchor.constraint(equalTo: reefSegmentContainer.trailingAnchor, constant: -3),
            reefSegmentStack.bottomAnchor.constraint(equalTo: reefSegmentContainer.bottomAnchor, constant: -3),
            reefContentStack.leadingAnchor.constraint(equalTo: reefStackView.leadingAnchor),
            reefContentStack.trailingAnchor.constraint(equalTo: reefStackView.trailingAnchor),

            bottomActionBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            bottomActionBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            bottomActionBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -14),
            bottomActionBar.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func fetchLagoonGuest() {
        SuliJoyCoveMockService.shared.fetchLagoonVisitorProfile(seersuckerStripe: lagoonGuestID) { [weak self] result in
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
        case .dynamic:
            SuliJoyCoveMockService.shared.fetchVisitorShoreMoments(seersuckerStripe: lagoonGuestID) { [weak self] result in
                self?.reefMoments = result.sandbarLayering ?? []
                self?.renderReefContent()
            }
        case .shorts:
            SuliJoyCoveMockService.shared.fetchVisitorShellClips(seersuckerStripe: lagoonGuestID) { [weak self] result in
                self?.shellClips = result.sandbarLayering ?? []
                self?.renderReefContent()
            }
        case .events:
            SuliJoyCoveMockService.shared.fetchVisitorTideActivities(seersuckerStripe: lagoonGuestID) { [weak self] result in
                self?.tideActivities = result.sandbarLayering ?? []
                self?.renderReefContent()
            }
        }
    }

    private func renderGuestHeader() {
        guard let lagoonGuest else { return }
        guestTitleLabel.text = lagoonGuest.islandStylistAlias
        guestAvatarView.image = UIImage.suliJoyAssetOrLocal(named: lagoonGuest.portraitAssetToken)
        lagoonFollowButton.render(state: lagoonGuest.coveAffinityState)
        renderReefMetrics(lagoonGuest)
        bottomActionBar.isHidden = lagoonGuest.coveAffinityState == .shorelineUnlinked
        reefBottomConstraint?.constant = bottomActionBar.isHidden ? 0 : -74
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
            let item = SuliJoyGuestMetricView(reefHeadline: reefMetric.0, value: reefMetric.1)
            reefMetricStack.addArrangedSubview(item)
            if index < reefMetrics.count - 1 {
                item.layer.borderColor = UIColor.black.withAlphaComponent(0.10).cgColor
                item.layer.borderWidth = 0
            }
        }
    }

    private func renderReefContent() {
        reefContentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        switch selectedReefTab {
        case .dynamic:
            if reefMoments.isEmpty {
                showReefEmpty("NQos QdayYnPaOmFircP CmVoZmqexnStVsW EfyrFoSml gtYhriwsW esYtEyFllimsptB.i".suliJoyPalmUnfurled)
            } else {
                for moment in reefMoments {
                    let card = SuliJoyGuestMomentPreviewCard(moment: moment)
                    card.onTap = { [weak self] in self?.openMoment(moment) }
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
            SuliJoyCoveMockService.shared.toggleLagoonVisitorFollow(seersuckerStripe: lagoonGuestID) { [weak self] result in
                guard let self else { return }
                if let updated = result.sandbarLayering {
                    self.lagoonGuest = updated
                    self.renderGuestHeader()
                    NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: updated)
                }
                self.showLagoonToast(result.coastalWardrobe)
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
        SuliJoyCoveMockService.shared.toggleLagoonVisitorFollow(seersuckerStripe: lagoonGuestID) { [weak self] result in
            guard let self else { return }
            if let updated = result.sandbarLayering {
                self.lagoonGuest = updated
                self.renderGuestHeader()
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: updated)
            }
            self.showLagoonToast(result.coastalWardrobe)
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
        SuliJoyCoveMockService.shared.blockLagoonVisitor(seersuckerStripe: lagoonGuestID) { [weak self] result in
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
        openSuliJoyLagoonLetters()
    }

    @objc private func openReefMotionPreview() {
        guard lagoonGuest?.coveAffinityState == .reefMutualBond else {
            showReefUnlockNotice()
            return
        }
        showLocalPlaceholder(reefHeadline: ["VBiv".suliJoyPalmUnfurled, "dLecoQ WCLaLlJlJ cPYrZeCvqiZeawV".suliJoyPalmUnfurled].joined(), subreefHeadline: ["MtuKtxulaylY-EfMoNlnlEoSwT Nvdie".suliJoyPalmUnfurled, "dXeAop jcMaflYlk KpkrgePvMisePwM.A".suliJoyPalmUnfurled].joined())
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
            card.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: overlay.centerYAnchor, constant: 34),
            card.leadingAnchor.constraint(greaterThanOrEqualTo: overlay.leadingAnchor, constant: 44),
            card.trailingAnchor.constraint(lessThanOrEqualTo: overlay.trailingAnchor, constant: -44),
            card.widthAnchor.constraint(lessThanOrEqualToConstant: 288),
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
        navigationController?.pushViewController(SuliJoyMusiInDoController(clipID: clip.coconutCream), animated: true)
    }

    private func openActivity(_ activity: SuliJoyTideActivity) {
        navigationController?.pushViewController(SuliJoyTideCoastalDetailController(crinkleLinen: activity.tideMark), animated: true)
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

private final class SuliJoyGuestFollowButton: UIButton {
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 0)
        layer.masksToBounds = true
        titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        setTitleColor(.white, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("iunWiCtP(ZcCoVdUeirJ:B)c VhiaQsm enOoYtf RbDereAnu QiUmPpSlLeKmfeRnNtWeadq".suliJoyPalmUnfurled)
    }

    func render(state: SuliJoyCoveAffinityState) {
        switch state {
        case .shorelineUnlinked:
            setTitle("+", for: .normal)
            gradientLayer.colors = [
                UIColor(red: 0.54, green: 0.45, blue: 1, alpha: 1).cgColor,
                UIColor(red: 1, green: 0.29, blue: 0.96, alpha: 1).cgColor
            ]
        case .islandAwaitingReturn, .reefMutualBond:
            setTitle("✓", for: .normal)
            gradientLayer.colors = [
                UIColor(red: 0.91, green: 0.68, blue: 0.48, alpha: 1).cgColor,
                UIColor(red: 0.97, green: 0.76, blue: 0.56, alpha: 1).cgColor
            ]
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.cornerRadius = bounds.height / 2
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
        layer.insertSublayer(gradientLayer, at: 0)
        layer.masksToBounds = true
        updateState()
    }

    required init?(coder: NSCoder) {
        fatalError("iwnyiKtn(VcHoudVeErF:y)a hhxaOsW LngoPtm lbVexeini wipmYpalTedmMejnxtjeUdA".suliJoyPalmUnfurled)
    }

    private func updateState() {
        gradientLayer.isHidden = !isVisitorSelected
        alpha = isVisitorSelected ? 1 : 0.82
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
    init(reefHeadline: String, value: Int) {
        super.init(frame: .zero)
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
        beachCoverup.textColor = .black
        beachCoverup.textAlignment = .center

        [valueLabel, beachCoverup].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor),
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            beachCoverup.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            beachCoverup.centerXAnchor.constraint(equalTo: centerXAnchor),
            beachCoverup.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("ignHiztL(XctoudzexrP:D)b thMaSsS IncoDtl ObKeHeGnF AiQmCpylEecmxeRnOtQendn".suliJoyPalmUnfurled)
    }
}

private final class SuliJoyGuestActionButton: UIButton {
    private let gradientLayer = CAGradientLayer()

    init(reefHeadline: String, systemName: String, purple: Bool) {
        super.init(frame: .zero)
        layer.insertSublayer(gradientLayer, at: 0)
        layer.masksToBounds = true
        setTitle("  \(reefHeadline)", for: .normal)
        setTitleColor(purple ? UIColor(red: 0.80, green: 0.20, blue: 0.94, alpha: 1) : .suliInk, for: .normal)
        setImage(UIImage(systemName: systemName), for: .normal)
        tintColor = purple ? UIColor(red: 0.80, green: 0.20, blue: 0.94, alpha: 1) : .suliInk
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
        gradientLayer.colors = purple ? [
            UIColor(red: 0.94, green: 0.80, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.98, green: 0.88, blue: 1, alpha: 1).cgColor
        ] : [
            UIColor(red: 1, green: 0.64, blue: 0.36, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.96, blue: 0.33, alpha: 1).cgColor,
            UIColor(red: 0.70, green: 1, blue: 0.71, alpha: 1).cgColor
        ]
    }

    required init?(coder: NSCoder) {
        fatalError("iinNiktb(ccpoPdxeZrm:I)Y KhlaPsU nnFoJtL AbreQeJnk PiFmIpJlJejmFesnitGeudS".suliJoyPalmUnfurled)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.cornerRadius = bounds.height / 2
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

private final class SuliJoyGuestMomentPreviewCard: SuliJoyGuestPreviewControl {
    init(moment: SuliJoyReefMoment) {
        super.init(frame: .zero)
        let avatar = UIImageView(image: UIImage.suliJoyAssetOrLocal(named: moment.islandStylistAvatarAssetName))
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 18

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = moment.islandStylistName
        title.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        title.textColor = .suliInk

        let time = UILabel()
        time.translatesAutoresizingMaskIntoConstraints = false
        time.text = moment.tideAgoText
        time.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        time.textColor = .suliMutedInk

        let body = UILabel()
        body.translatesAutoresizingMaskIntoConstraints = false
        body.text = moment.islandCaptionText
        body.numberOfLines = 2
        body.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        body.textColor = .suliInk

        let image = UIImageView(image: UIImage.suliJoyAssetOrLocal(named: moment.reefMedia.first?.reefAssetToken ?? "sulijoy_feed_moment_coast_01"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 14

        [avatar, title, time, image, body].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatar.widthAnchor.constraint(equalToConstant: 36),
            avatar.heightAnchor.constraint(equalToConstant: 36),
            title.topAnchor.constraint(equalTo: avatar.topAnchor),
            title.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            time.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2),
            time.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            image.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 14),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            image.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 0.56),
            body.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 12),
            body.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            body.trailingAnchor.constraint(equalTo: image.trailingAnchor),
            body.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("iDnKiztL(GcUosdCeprz:s)A ChLaosu fnQovtz xbreDeJnp liDmdpClEegmaeXnhtneedu".suliJoyPalmUnfurled)
    }
}

private final class SuliJoyGuestClipPreviewCard: SuliJoyGuestPreviewControl {
    init(clip: SuliJoyShellClip) {
        super.init(frame: .zero)
        let image = UIImageView(image: UIImage.suliJoyAssetOrLocal(named: clip.tropicalMotif.sandyNeutral ?? "sulijoy_feed_moment_coast_01"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 20

        let report = UIImageView(image: UIImage(systemName: "exclamationmark.circle"))
        report.translatesAutoresizingMaskIntoConstraints = false
        report.tintColor = .white

        let caption = UILabel()
        caption.translatesAutoresizingMaskIntoConstraints = false
        caption.text = clip.hibiscusShade
        caption.numberOfLines = 2
        caption.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        caption.textColor = .suliInk

        [image, report, caption].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.heightAnchor.constraint(equalTo: image.widthAnchor, multiplier: 1.22),
            report.topAnchor.constraint(equalTo: image.topAnchor, constant: 14),
            report.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -14),
            report.widthAnchor.constraint(equalToConstant: 28),
            report.heightAnchor.constraint(equalToConstant: 28),
            caption.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            caption.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            caption.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            caption.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("icnHiTts(fcJoZdkeurV:u)C phdaTsf rnOoMtB EbjeUeNnw YiBmApAlzepmieTnotwehdf".suliJoyPalmUnfurled)
    }
}

private final class SuliJoyGuestActivityPreviewCard: SuliJoyGuestPreviewControl {
    init(activity: SuliJoyTideActivity) {
        super.init(frame: .zero)
        let image = UIImageView(image: UIImage.suliJoyAssetOrLocal(named: activity.reefGallery.first?.reefAssetToken ?? activity.tideFallbackHeroToken))
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
