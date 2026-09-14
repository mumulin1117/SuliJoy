import UIKit

final class SuliJoyLagoonProfileCoveController: SuliJoyTropicCanvasController, UITableViewDataSource, UITableViewDelegate {
    private enum LagoonMirrorMeasure {
        static let coveHeaderTop: CGFloat = 0
        static let coveHeaderHeight: CGFloat = 286
        static let crownTop: CGFloat = 12
        static let crownSide: CGFloat = 16
        static let crownHeight: CGFloat = 40
        static let searchShellWidth: CGFloat = 38
        static let profileReefTop: CGFloat = 30
        static let profileReefSide: CGFloat = 12
        static let profileReefHeight: CGFloat = 150
        static let avatarShellSide: CGFloat = 10
        static let avatarShellTop: CGFloat = -19
        static let avatarShellSize: CGFloat = 86
        static let profileGlyphGap: CGFloat = 8
        static let nameGlyphTop: CGFloat = 14
        static let reefSegmentTop: CGFloat = 14
        static let reefSegmentSide: CGFloat = 22
        static let reefSegmentHeight: CGFloat = 28
        static let tideIndicatorWidth: CGFloat = 22
        static let tideIndicatorHeight: CGFloat = 5
    }

    private let mirrorCoveService = SuliJoyCoveMockService.shared
    private let wardrobeTable = UITableView(frame: .zero, style: .plain)
    private let crownHarbor = UIView()
    private let profileCrownPill = SuliJoyGradientCapsuleView(colors: [
        UIColor.white.withAlphaComponent(0),
        UIColor.white
    ], startPoint: CGPoint(x: 0.1225, y: 0.828), endPoint: CGPoint(x: 0.8775, y: 0.172))
    private let profileCrownGlyph = UILabel()
    private let harborGemPill = SuliJoyShellGemPillButton(shellWidth: 80, shellHeight: 38)
    private let shellSearchTap = SuliJoyCoveCapsuleIconButton(reefAssetName: "sulijoy_cove_search_mark", coveSize: 38)
    private let profileReefCard = SuliJoyGradientCapsuleView(colors: [
        UIColor.white,
        UIColor(red: 1, green: 237.0 / 255.0, blue: 178.0 / 255.0, alpha: 1)
    ], startPoint: CGPoint(x: 0.281, y: 0.9495), endPoint: CGPoint(x: 0.719, y: 0.0505))
    private let avatarShellView = UIImageView()
    private let avatarShellBadge = UIImageView()
    private let nameShellTap = UIButton(type: .system)
    private let nameShellArrow = UIImageView()
    private let islandCodeGlyph = UILabel()
    private let reefSettingTap = UIButton(type: .system)
    private let profileTallyStack = UIStackView()
    private let shoreSegmentStack = UIStackView()
    private let tideIndicator = SuliJoyGradientCapsuleView(colors: [
        UIColor(red: 1, green: 0.44, blue: 0.28, alpha: 1),
        UIColor(red: 0.96, green: 1.0, blue: 0.30, alpha: 1),
        UIColor(red: 0.40, green: 1.0, blue: 0.64, alpha: 1)
    ], startPoint: CGPoint(x: 0.25, y: 0.933), endPoint: CGPoint(x: 0.75, y: 0.067))
    private let quietCoveGlyph = UILabel()

    private var activeCoveSection: SuliJoyMineCoveSection = .feed
    private var islandMirrorSnapshot: SuliJoyLagoonProfileSnapshot?
    private var shoreLookShelf: [SuliJoyReefMoment] = []
    private var reefMotionShelf: [SuliJoyShellClip] = []
    private var tidePlanShelf: [SuliJoyTideActivity] = []
    private var sectionShellTaps: [SuliJoyMineCoveSection: UIButton] = [:]
    private var tideIndicatorLead: NSLayoutConstraint?
    private weak var activeReefClipCell: SuliJoyShortsClipCell?
    private var reefReplyVeil: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        weaveLagoonProfileCove()
        refreshLagoonProfile()
        refreshActiveCoveSection()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        harborGemPill.setShellGemTally(SuliJoyShellPearlStore.shared.currentPearlBalance())
        refreshLagoonProfile()
        refreshActiveCoveSection()
    }

    private func weaveLagoonProfileCove() {
        profileCrownPill.translatesAutoresizingMaskIntoConstraints = false
        profileCrownPill.layer.cornerRadius = 20
        profileCrownPill.clipsToBounds = true

        profileCrownGlyph.translatesAutoresizingMaskIntoConstraints = false
        profileCrownGlyph.text = "🤩u GPZrvoVfPiGlNef".suliJoyPalmUnfurled
        profileCrownGlyph.font = UIFont.italicSystemFont(ofSize: 21).suliWithWeight(.black)
        profileCrownGlyph.textColor = .suliInk
        profileCrownGlyph.adjustsFontSizeToFitWidth = true
        profileCrownGlyph.minimumScaleFactor = 0.75
        profileCrownPill.addSubview(profileCrownGlyph)

        harborGemPill.addTarget(self, action: #selector(openPearlHarborCove), for: .touchUpInside)
        shellSearchTap.addTarget(self, action: #selector(openSearchCove), for: .touchUpInside)

        profileReefCard.translatesAutoresizingMaskIntoConstraints = false
        profileReefCard.layer.cornerRadius = 20
        profileReefCard.layer.borderWidth = 1
        profileReefCard.layer.borderColor = UIColor(red: 1, green: 0.63, blue: 0.31, alpha: 1).cgColor

        avatarShellView.translatesAutoresizingMaskIntoConstraints = false
        avatarShellView.contentMode = .scaleAspectFill
        avatarShellView.clipsToBounds = true
        avatarShellView.layer.cornerRadius = 43
        avatarShellView.layer.borderWidth = 3
        avatarShellView.layer.borderColor = UIColor.white.cgColor
        avatarShellView.image = UIImage(named: "sulijoy_mock_avatar_breeze_01")

        avatarShellBadge.translatesAutoresizingMaskIntoConstraints = false
        avatarShellBadge.image = UIImage(named: "sulijoy_profile_edit_badge")
        avatarShellBadge.contentMode = .scaleAspectFit
        avatarShellBadge.isUserInteractionEnabled = true
        avatarShellBadge.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openLagoonMirror)))

        nameShellTap.translatesAutoresizingMaskIntoConstraints = false
        nameShellTap.setTitle("DQauvciOdq".suliJoyPalmUnfurled, for: .normal)
        nameShellTap.setTitleColor(.suliInk, for: .normal)
        nameShellTap.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nameShellTap.contentHorizontalAlignment = .left
        nameShellTap.addTarget(self, action: #selector(openLagoonMirror), for: .touchUpInside)

        nameShellArrow.translatesAutoresizingMaskIntoConstraints = false
        nameShellArrow.image = UIImage(named: "sulijoy_profile_name_arrow")
        nameShellArrow.contentMode = .scaleAspectFit
        nameShellArrow.isUserInteractionEnabled = true
        nameShellArrow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openLagoonMirror)))

        islandCodeGlyph.translatesAutoresizingMaskIntoConstraints = false
        islandCodeGlyph.text = "IIDN i q3P9N9L4U9M2X0G3h0o4H".suliJoyPalmUnfurled
        islandCodeGlyph.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        islandCodeGlyph.textColor = .suliMutedInk
        islandCodeGlyph.textAlignment = .left
        islandCodeGlyph.adjustsFontSizeToFitWidth = true
        islandCodeGlyph.minimumScaleFactor = 0.75

        reefSettingTap.translatesAutoresizingMaskIntoConstraints = false
        reefSettingTap.setImage(UIImage(named: "sulijoy_profile_setting_mark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        reefSettingTap.imageView?.contentMode = .scaleAspectFit
        reefSettingTap.addTarget(self, action: #selector(openSettingCove), for: .touchUpInside)

        profileTallyStack.translatesAutoresizingMaskIntoConstraints = false
        profileTallyStack.axis = .horizontal
        profileTallyStack.distribution = .fillEqually
        profileTallyStack.alignment = .center
        profileTallyStack.spacing = 4

        [nameShellTap, nameShellArrow, islandCodeGlyph, reefSettingTap, profileTallyStack].forEach { profileReefCard.addSubview($0) }

        shoreSegmentStack.translatesAutoresizingMaskIntoConstraints = false
        shoreSegmentStack.axis = .horizontal
        shoreSegmentStack.distribution = .fill
        shoreSegmentStack.alignment = .center
        shoreSegmentStack.spacing = 32
        for section in SuliJoyMineCoveSection.allCases {
            let button = UIButton(type: .system)
            button.setTitle(section.rawValue, for: .normal)
            button.setTitleColor(.suliInk, for: .normal)
            button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 17).suliWithWeight(.black)
            button.tag = SuliJoyMineCoveSection.allCases.firstIndex(of: section) ?? 0
            button.addTarget(self, action: #selector(shiftCoveSection(_:)), for: .touchUpInside)
            sectionShellTaps[section] = button
            shoreSegmentStack.addArrangedSubview(button)
        }

        crownHarbor.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(crownHarbor)
        [profileCrownPill, harborGemPill, shellSearchTap, profileReefCard, avatarShellView, avatarShellBadge, shoreSegmentStack, tideIndicator].forEach { crownHarbor.addSubview($0) }

        wardrobeTable.translatesAutoresizingMaskIntoConstraints = false
        wardrobeTable.backgroundColor = .clear
        wardrobeTable.separatorStyle = .none
        wardrobeTable.showsVerticalScrollIndicator = false
        wardrobeTable.dataSource = self
        wardrobeTable.delegate = self
        wardrobeTable.rowHeight = UITableView.automaticDimension
        wardrobeTable.estimatedRowHeight = 520
        wardrobeTable.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 110, right: 0)
        wardrobeTable.register(suliJoyCoastalDiary.self, forCellReuseIdentifier: "suliJoyCoastalDiary")
        wardrobeTable.register(SuliJoyShortsClipCell.self, forCellReuseIdentifier: "SuliJoyShortsClipCell")
        wardrobeTable.register(SuliJoyTideCardCell.self, forCellReuseIdentifier: "SuliJoyTideCardCell")
        view.addSubview(wardrobeTable)

        quietCoveGlyph.translatesAutoresizingMaskIntoConstraints = false
        quietCoveGlyph.text = "Nuol zprreoXfxiflCeE dcKoOnPtHepnEtb VyGegtc.l".suliJoyPalmUnfurled
        quietCoveGlyph.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        quietCoveGlyph.textColor = .suliMutedInk
        quietCoveGlyph.textAlignment = .center
        quietCoveGlyph.isHidden = true
        view.addSubview(quietCoveGlyph)

        tideIndicatorLead = tideIndicator.leadingAnchor.constraint(equalTo: shoreSegmentStack.leadingAnchor)
        NSLayoutConstraint.activate([
            crownHarbor.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: LagoonMirrorMeasure.coveHeaderTop),
            crownHarbor.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            crownHarbor.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            crownHarbor.heightAnchor.constraint(equalToConstant: LagoonMirrorMeasure.coveHeaderHeight),

            profileCrownPill.topAnchor.constraint(equalTo: crownHarbor.topAnchor, constant: LagoonMirrorMeasure.crownTop),
            profileCrownPill.leadingAnchor.constraint(equalTo: crownHarbor.leadingAnchor, constant: LagoonMirrorMeasure.crownSide),
            profileCrownPill.widthAnchor.constraint(lessThanOrEqualTo: crownHarbor.widthAnchor, multiplier: 0.44),
            profileCrownPill.heightAnchor.constraint(equalToConstant: LagoonMirrorMeasure.crownHeight),
            profileCrownGlyph.leadingAnchor.constraint(equalTo: profileCrownPill.leadingAnchor, constant: 12),
            profileCrownGlyph.trailingAnchor.constraint(equalTo: profileCrownPill.trailingAnchor, constant: -14),
            profileCrownGlyph.centerYAnchor.constraint(equalTo: profileCrownPill.centerYAnchor),

            harborGemPill.centerYAnchor.constraint(equalTo: profileCrownPill.centerYAnchor),
            harborGemPill.trailingAnchor.constraint(equalTo: shellSearchTap.leadingAnchor, constant: -20),
            shellSearchTap.centerYAnchor.constraint(equalTo: profileCrownPill.centerYAnchor),
            shellSearchTap.trailingAnchor.constraint(equalTo: crownHarbor.trailingAnchor, constant: -LagoonMirrorMeasure.crownSide),
            shellSearchTap.widthAnchor.constraint(equalToConstant: LagoonMirrorMeasure.searchShellWidth),

            profileReefCard.topAnchor.constraint(equalTo: profileCrownPill.bottomAnchor, constant: LagoonMirrorMeasure.profileReefTop),
            profileReefCard.leadingAnchor.constraint(equalTo: crownHarbor.leadingAnchor, constant: LagoonMirrorMeasure.profileReefSide),
            profileReefCard.trailingAnchor.constraint(equalTo: crownHarbor.trailingAnchor, constant: -LagoonMirrorMeasure.profileReefSide),
            profileReefCard.heightAnchor.constraint(equalToConstant: LagoonMirrorMeasure.profileReefHeight),

            avatarShellView.leadingAnchor.constraint(equalTo: profileReefCard.leadingAnchor, constant: LagoonMirrorMeasure.avatarShellSide),
            avatarShellView.topAnchor.constraint(equalTo: profileReefCard.topAnchor, constant: LagoonMirrorMeasure.avatarShellTop),
            avatarShellView.widthAnchor.constraint(equalToConstant: LagoonMirrorMeasure.avatarShellSize),
            avatarShellView.heightAnchor.constraint(equalToConstant: LagoonMirrorMeasure.avatarShellSize),

            avatarShellBadge.leadingAnchor.constraint(equalTo: avatarShellView.leadingAnchor, constant: 20),
            avatarShellBadge.topAnchor.constraint(equalTo: avatarShellView.topAnchor, constant: 68),
            avatarShellBadge.widthAnchor.constraint(equalToConstant: 48),
            avatarShellBadge.heightAnchor.constraint(equalToConstant: 24),

            nameShellTap.leadingAnchor.constraint(equalTo: avatarShellView.trailingAnchor, constant: LagoonMirrorMeasure.profileGlyphGap),
            nameShellTap.topAnchor.constraint(equalTo: profileReefCard.topAnchor, constant: LagoonMirrorMeasure.nameGlyphTop),
            nameShellTap.heightAnchor.constraint(equalToConstant: 24),
            nameShellArrow.leadingAnchor.constraint(equalTo: nameShellTap.trailingAnchor, constant: 4),
            nameShellArrow.centerYAnchor.constraint(equalTo: nameShellTap.centerYAnchor),
            nameShellArrow.widthAnchor.constraint(equalToConstant: 12),
            nameShellArrow.heightAnchor.constraint(equalToConstant: 12),
            nameShellArrow.trailingAnchor.constraint(lessThanOrEqualTo: reefSettingTap.leadingAnchor, constant: -8),
            islandCodeGlyph.leadingAnchor.constraint(equalTo: avatarShellView.trailingAnchor, constant: 6),
            islandCodeGlyph.topAnchor.constraint(equalTo: nameShellTap.bottomAnchor, constant: 4),
            islandCodeGlyph.trailingAnchor.constraint(equalTo: profileReefCard.trailingAnchor, constant: -12),
            reefSettingTap.trailingAnchor.constraint(equalTo: profileReefCard.trailingAnchor, constant: -16),
            reefSettingTap.topAnchor.constraint(equalTo: profileReefCard.topAnchor, constant: 11),
            reefSettingTap.widthAnchor.constraint(equalToConstant: 24),
            reefSettingTap.heightAnchor.constraint(equalToConstant: 24),

            profileTallyStack.leadingAnchor.constraint(equalTo: profileReefCard.leadingAnchor, constant: 18),
            profileTallyStack.trailingAnchor.constraint(equalTo: profileReefCard.trailingAnchor, constant: -18),
            profileTallyStack.bottomAnchor.constraint(equalTo: profileReefCard.bottomAnchor, constant: -16),
            profileTallyStack.heightAnchor.constraint(equalToConstant: 48),

            shoreSegmentStack.topAnchor.constraint(equalTo: profileReefCard.bottomAnchor, constant: LagoonMirrorMeasure.reefSegmentTop),
            shoreSegmentStack.leadingAnchor.constraint(equalTo: crownHarbor.leadingAnchor, constant: LagoonMirrorMeasure.reefSegmentSide),
            shoreSegmentStack.trailingAnchor.constraint(lessThanOrEqualTo: crownHarbor.trailingAnchor, constant: -LagoonMirrorMeasure.reefSegmentSide),
            shoreSegmentStack.heightAnchor.constraint(equalToConstant: LagoonMirrorMeasure.reefSegmentHeight),
            tideIndicator.topAnchor.constraint(equalTo: shoreSegmentStack.bottomAnchor, constant: 3),
            tideIndicator.widthAnchor.constraint(equalToConstant: LagoonMirrorMeasure.tideIndicatorWidth),
            tideIndicator.heightAnchor.constraint(equalToConstant: LagoonMirrorMeasure.tideIndicatorHeight),
            tideIndicatorLead!,

            wardrobeTable.topAnchor.constraint(equalTo: crownHarbor.bottomAnchor),
            wardrobeTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wardrobeTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wardrobeTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            quietCoveGlyph.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quietCoveGlyph.topAnchor.constraint(equalTo: wardrobeTable.topAnchor, constant: 36),
            quietCoveGlyph.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            quietCoveGlyph.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28)
        ])
        tuneCoveSectionVisuals(animated: false)
    }

    private func refreshLagoonProfile() {
        mirrorCoveService.fetchIslandProfileSummary { [weak self] mirrorEnvelope in
            guard let self else { return }
            if let lagoonSummary = mirrorEnvelope.sandbarLayering {
                self.islandMirrorSnapshot = lagoonSummary
                self.applyLagoonSummary(islandSnapshot: lagoonSummary)
            }
        }
    }

    private func refreshActiveCoveSection() {
        quietCoveGlyph.isHidden = true
        switch activeCoveSection {
        case .feed:
            fetchProfileShoreMoments()
        case .shorts:
            fetchProfileReefClips()
        case .events:
            fetchProfileTideActivities()
        }
    }

    private func fetchProfileShoreMoments() {
        mirrorCoveService.fetchMineShoreMoments { [weak self] shoreEnvelope in
            self?.shoreLookShelf = shoreEnvelope.sandbarLayering ?? []
            self?.refreshCoveTable()
        }
    }

    private func fetchProfileReefClips() {
        mirrorCoveService.fetchMineShellClips { [weak self] reefEnvelope in
            self?.reefMotionShelf = reefEnvelope.sandbarLayering ?? []
            self?.refreshCoveTable()
        }
    }

    private func fetchProfileTideActivities() {
        mirrorCoveService.fetchMineTideActivities { [weak self] tideEnvelope in
            self?.tidePlanShelf = tideEnvelope.sandbarLayering ?? []
            self?.refreshCoveTable()
        }
    }

    private func refreshCoveTable() {
        activeReefClipCell?.quietShorelineCurrent()
        activeReefClipCell = nil
        wardrobeTable.reloadData()
        quietCoveGlyph.text = quietText(for: activeCoveSection)
        quietCoveGlyph.isHidden = coveRowCount() > 0
    }

    private func applyLagoonSummary(islandSnapshot: SuliJoyLagoonProfileSnapshot) {
        avatarShellView.image = UIImage.suliJoyAssetOrLocal(named: islandSnapshot.lagoonAvatarAssetName) ?? UIImage(named: "sulijoy_mock_avatar_breeze_01")
        nameShellTap.setTitle(islandSnapshot.lagoonNameText, for: .normal)
        islandCodeGlyph.attributedText = makeIslandCodeBadgeText(islandSnapshot.islandTraceText)
        profileTallyStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        islandSnapshot.reefTallies.forEach { shoreTally in
            profileTallyStack.addArrangedSubview(makeTallyReef(shoreTally))
        }
    }

    private func quietText(for coveSection: SuliJoyMineCoveSection) -> String {
        switch coveSection {
        case .feed:
            return "No feed moments yet."
        case .shorts:
            return "No shorts yet."
        case .events:
            return "No events yet."
        }
    }

    private func makeTallyReef(_ shoreTally: SuliJoyReefProfileTally) -> UIView {
        let tallyStack = UIStackView()
        tallyStack.axis = .vertical
        tallyStack.alignment = .center
        tallyStack.spacing = 4
        let reefValueGlyph = UILabel()
        reefValueGlyph.text = "\(shoreTally.reefTotal)"
        reefValueGlyph.font = UIFont.systemFont(ofSize: 17, weight: .black)
        reefValueGlyph.textColor = .suliInk
        let shoreCaptionGlyph = UILabel()
        shoreCaptionGlyph.text = shoreTally.reefLabel
        shoreCaptionGlyph.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        shoreCaptionGlyph.textColor = .suliMutedInk
        shoreCaptionGlyph.adjustsFontSizeToFitWidth = true
        shoreCaptionGlyph.minimumScaleFactor = 0.75
        tallyStack.addArrangedSubview(reefValueGlyph)
        tallyStack.addArrangedSubview(shoreCaptionGlyph)
        return tallyStack
    }

    private func makeIslandCodeBadgeText(_ islandCode: String) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "sulijoy_profile_id_badge")
        attachment.bounds = CGRect(x: 0, y: -3, width: 26, height: 17)
        let result = NSMutableAttributedString(attachment: attachment)
        result.append(NSAttributedString(
            string: "  \(islandCode)",
            attributes: [
                .font: UIFont.systemFont(ofSize: 13, weight: .regular),
                .foregroundColor: UIColor.suliMutedInk
            ]
        ))
        return result
    }

    @objc private func shiftCoveSection(_ shoreTap: UIButton) {
        activeCoveSection = SuliJoyMineCoveSection.allCases[shoreTap.tag]
        tuneCoveSectionVisuals(animated: true)
        refreshActiveCoveSection()
    }

    private func tuneCoveSectionVisuals(animated isAnimated: Bool) {
        for shoreTap in sectionShellTaps.values {
            shoreTap.alpha = 1
            shoreTap.transform = .identity
            shoreTap.titleLabel?.transform = .identity
        }
        crownHarbor.layoutIfNeeded()
        if let shoreTap = sectionShellTaps[activeCoveSection] {
            tideIndicatorLead?.constant = shoreTap.frame.midX - LagoonMirrorMeasure.tideIndicatorWidth / 2
        }
        let tideRefresh = { self.crownHarbor.layoutIfNeeded() }
        isAnimated ? UIView.animate(withDuration: 0.22, animations: tideRefresh) : tideRefresh()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tuneCoveSectionVisuals(animated: false)
    }

    func tableView(_ wardrobeTable: UITableView, numberOfRowsInSection reefSection: Int) -> Int {
        coveRowCount()
    }

    private func coveRowCount() -> Int {
        switch activeCoveSection {
        case .feed: return shoreLookShelf.count
        case .shorts: return reefMotionShelf.count
        case .events: return tidePlanShelf.count
        }
    }

    func tableView(_ wardrobeTable: UITableView, cellForRowAt reefPath: IndexPath) -> UITableViewCell {
        switch activeCoveSection {
        case .feed:
            return makeProfileShoreMomentCell(wardrobeTable, reefPath: reefPath)
        case .shorts:
            return makeProfileReefClipCell(wardrobeTable, reefPath: reefPath)
        case .events:
            return makeProfileTideActivityCell(wardrobeTable, reefPath: reefPath)
        }
    }

    private func makeProfileShoreMomentCell(_ wardrobeTable: UITableView, reefPath: IndexPath) -> UITableViewCell {
        let shoreCell = wardrobeTable.dequeueReusableCell(withIdentifier: "suliJoyCoastalDiary", for: reefPath) as! suliJoyCoastalDiary
        let shoreMoment = shoreLookShelf[reefPath.row]
        shoreCell.configure(with: shoreMoment, isFollowing: SuliJoyCoveMockService.shared.isLagoonFollowing(authorName: shoreMoment.islandStylistName))
        shoreCell.onHeartTap = { [weak self] in self?.toggleShoreMomentHeart(shoreMoment.reefMomentID) }
        shoreCell.onReplyTap = { [weak self] in self?.openShoreMomentDetail(shoreMoment.reefMomentID) }
        shoreCell.onWaveTap = { [weak self] in self?.toggleShoreMomentAudio(shoreMoment.reefMomentID) }
        shoreCell.onHarborMoreTap = { [weak self] in self?.showShoreMomentGuard(shoreMoment.reefMomentID, sourceView: shoreCell) }
        shoreCell.onLagoonFollowTap = nil
        return shoreCell
    }

    private func makeProfileReefClipCell(_ wardrobeTable: UITableView, reefPath: IndexPath) -> UITableViewCell {
        let reefCell = wardrobeTable.dequeueReusableCell(withIdentifier: "SuliJoyShortsClipCell", for: reefPath) as! SuliJoyShortsClipCell
        let reefClip = reefMotionShelf[reefPath.row]
        reefCell.offShoulder(with: reefClip)
        reefCell.onShorelineCurrentTap = { [weak self, weak reefCell] clipID in self?.toggleReefClipMotion(coconutCream: clipID, cell: reefCell) }
        reefCell.onShorelineFollowTap = { [weak self] clipID in self?.toggleReefClipFollow(clipID) }
        reefCell.onShorelineHeartTap = { [weak self] clipID in self?.toggleReefClipHeart(clipID) }
        reefCell.onShorelineReplyTap = { [weak self] clipID in self?.presentReefClipReplyPrompt(clipID) }
        reefCell.onShorelineFlagTap = { [weak self, weak reefCell] clipID in self?.showReefClipGuard(clipID, sourceView: reefCell?.shorelineFlagAnchor) }
        return reefCell
    }

    private func makeProfileTideActivityCell(_ wardrobeTable: UITableView, reefPath: IndexPath) -> UITableViewCell {
        let tideCell = wardrobeTable.dequeueReusableCell(withIdentifier: "SuliJoyTideCardCell", for: reefPath) as! SuliJoyTideCardCell
        let tideActivity = tidePlanShelf[reefPath.row]
        tideCell.configure(with: tideActivity)
        tideCell.onTideJoin = { [weak self] in self?.openTideActivityDetail(tideActivity.tideMark) }
        tideCell.onHarborFlag = { [weak self] sourceView in
            self?.showTideActivityGuard(tideActivity.tideMark, sourceView: sourceView)
        }
        return tideCell
    }

    func tableView(_ wardrobeTable: UITableView, didSelectRowAt reefPath: IndexPath) {
        switch activeCoveSection {
        case .feed:
            openShoreMomentDetail(shoreLookShelf[reefPath.row].reefMomentID)
        case .shorts:
            let reefDetail = SuliJoyMusiInDoController(clipID: reefMotionShelf[reefPath.row].coconutCream)
            navigationController?.pushViewController(reefDetail, animated: true)
        case .events:
            openTideActivityDetail(tidePlanShelf[reefPath.row].tideMark)
        }
    }

    private func toggleShoreMomentHeart(_ momentID: String) {
        mirrorCoveService.toggleMomentLike(sunwashedDenim: momentID) { [weak self] shoreEnvelope in
            guard let self, let shoreMoment = shoreEnvelope.sandbarLayering, let shelfIndex = self.shoreLookShelf.firstIndex(where: { $0.reefMomentID == momentID }) else { return }
            self.shoreLookShelf[shelfIndex] = shoreMoment
            self.wardrobeTable.reloadRows(at: [IndexPath(row: shelfIndex, section: 0)], with: .none)
        }
    }

    private func toggleShoreMomentAudio(_ momentID: String) {
        mirrorCoveService.toggleWavePlayback(sunwashedDenim: momentID) { [weak self] shoreEnvelope in
            guard let self, let shoreMoment = shoreEnvelope.sandbarLayering else { return }
            if let shelfIndex = self.shoreLookShelf.firstIndex(where: { $0.reefMomentID == momentID }) {
                self.shoreLookShelf[shelfIndex] = shoreMoment
                self.wardrobeTable.reloadRows(at: [IndexPath(row: shelfIndex, section: 0)], with: .none)
            }
            self.showLagoonToast(shoreEnvelope.coastalWardrobe)
        }
    }

    private func showShoreMomentGuard(_ momentID: String, sourceView: UIView) {
        presentSuliJoyHarborGuardMenu { [weak self] in
            self?.presentSuliJoyReportSheet(target: .beachBlazer(sunwashedDenim: momentID))
        } block: { [weak self] in
            SuliJoyCoveMockService.shared.blockMomentAuthor(sunwashedDenim: momentID) { guardEnvelope in
                self?.showLagoonToast(guardEnvelope.coastalWardrobe)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.refreshLagoonProfile()
            }
        }
    }

    private func toggleReefClipMotion(coconutCream clipID: String, cell: SuliJoyShortsClipCell?) {
        guard let cell else { return }
        if activeReefClipCell !== cell {
            activeReefClipCell?.quietShorelineCurrent()
        }
        if cell.switchShorelineCurrent() {
            activeReefClipCell = cell.isShorelineCurrentActive ? cell : nil
        } else {
            showLagoonToast("CllQiMpb GuznNaYvlaciplEaSbHlOeU.r".suliJoyPalmUnfurled)
        }
    }

    private func toggleReefClipFollow(_ clipID: String) {
        mirrorCoveService.toggleShellClipFollow(coconutCream: clipID) { [weak self] reefEnvelope in
            guard let self, let reefClip = reefEnvelope.sandbarLayering else { return }
            for shelfIndex in self.reefMotionShelf.indices where self.reefMotionShelf[shelfIndex].terracottaWarmth.clipStylistAlias == reefClip.terracottaWarmth.clipStylistAlias {
                self.reefMotionShelf[shelfIndex].driftwoodPalette = reefClip.driftwoodPalette
            }
            self.wardrobeTable.reloadData()
            self.showLagoonToast(reefEnvelope.coastalWardrobe)
        }
    }

    private func toggleReefClipHeart(_ clipID: String) {
        mirrorCoveService.toggleShellClipLike(coconutCream: clipID) { [weak self] reefEnvelope in
            guard let self, let reefClip = reefEnvelope.sandbarLayering, let shelfIndex = self.reefMotionShelf.firstIndex(where: { $0.coconutCream == clipID }) else { return }
            self.reefMotionShelf[shelfIndex] = reefClip
            self.wardrobeTable.reloadRows(at: [IndexPath(row: shelfIndex, section: 0)], with: .none)
        }
    }

    private func presentReefClipReplyPrompt(_ clipID: String) {
        let veil = UIView()
        veil.translatesAutoresizingMaskIntoConstraints = false
        veil.backgroundColor = UIColor.black.withAlphaComponent(0.38)

        let coralCard = UIView()
        coralCard.translatesAutoresizingMaskIntoConstraints = false
        coralCard.backgroundColor = .white
        coralCard.layer.cornerRadius = 20
        coralCard.clipsToBounds = true

        let headlineGlyph = UILabel()
        headlineGlyph.translatesAutoresizingMaskIntoConstraints = false
        headlineGlyph.text = "CuoumTmdeBnmtq".suliJoyPalmUnfurled
        headlineGlyph.textColor = .suliInk
        headlineGlyph.font = UIFont.systemFont(ofSize: 18, weight: .black)
        headlineGlyph.textAlignment = .center

        let replyField = UITextField()
        replyField.translatesAutoresizingMaskIntoConstraints = false
        replyField.placeholder = "CJoTmmmyexnitR CspoqmeeitdhHiXnIgF".suliJoyPalmUnfurled
        replyField.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        replyField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        replyField.layer.cornerRadius = 18
        replyField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        replyField.leftViewMode = .always

        let cancelTap = UIButton(type: .system)
        cancelTap.translatesAutoresizingMaskIntoConstraints = false
        cancelTap.setTitle("CcabnWcheVlN".suliJoyPalmUnfurled, for: .normal)
        cancelTap.setTitleColor(.suliMutedInk, for: .normal)
        cancelTap.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)

        let sendTap = SuliJoyGradientButton(reefHeadline: "SweLntdQ".suliJoyPalmUnfurled)
        sendTap.translatesAutoresizingMaskIntoConstraints = false

        cancelTap.addAction(UIAction { [weak self] _ in
            self?.dismissReefReplyVeil()
        }, for: .touchUpInside)
        sendTap.addAction(UIAction { [weak self, weak replyField] _ in
            let reefText = replyField?.text ?? ""
            self?.submitReefClipReply(coconutCream: clipID, reefText: reefText)
        }, for: .touchUpInside)

        view.addSubview(veil)
        veil.addSubview(coralCard)
        [headlineGlyph, replyField, cancelTap, sendTap].forEach { coralCard.addSubview($0) }
        reefReplyVeil = veil

        NSLayoutConstraint.activate([
            veil.topAnchor.constraint(equalTo: view.topAnchor),
            veil.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            veil.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            veil.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            coralCard.centerXAnchor.constraint(equalTo: veil.centerXAnchor),
            coralCard.centerYAnchor.constraint(equalTo: veil.centerYAnchor),
            coralCard.leadingAnchor.constraint(equalTo: veil.leadingAnchor, constant: 32),
            coralCard.trailingAnchor.constraint(equalTo: veil.trailingAnchor, constant: -32),

            headlineGlyph.topAnchor.constraint(equalTo: coralCard.topAnchor, constant: 22),
            headlineGlyph.leadingAnchor.constraint(equalTo: coralCard.leadingAnchor, constant: 18),
            headlineGlyph.trailingAnchor.constraint(equalTo: coralCard.trailingAnchor, constant: -18),

            replyField.topAnchor.constraint(equalTo: headlineGlyph.bottomAnchor, constant: 18),
            replyField.leadingAnchor.constraint(equalTo: coralCard.leadingAnchor, constant: 20),
            replyField.trailingAnchor.constraint(equalTo: coralCard.trailingAnchor, constant: -20),
            replyField.heightAnchor.constraint(equalToConstant: 46),

            cancelTap.topAnchor.constraint(equalTo: replyField.bottomAnchor, constant: 16),
            cancelTap.leadingAnchor.constraint(equalTo: coralCard.leadingAnchor, constant: 20),
            cancelTap.bottomAnchor.constraint(equalTo: coralCard.bottomAnchor, constant: -18),
            cancelTap.heightAnchor.constraint(equalToConstant: 44),

            sendTap.topAnchor.constraint(equalTo: cancelTap.topAnchor),
            sendTap.leadingAnchor.constraint(equalTo: cancelTap.trailingAnchor, constant: 12),
            sendTap.trailingAnchor.constraint(equalTo: coralCard.trailingAnchor, constant: -20),
            sendTap.bottomAnchor.constraint(equalTo: cancelTap.bottomAnchor),
            sendTap.widthAnchor.constraint(equalTo: cancelTap.widthAnchor)
        ])
        replyField.becomeFirstResponder()
    }

    private func submitReefClipReply(coconutCream clipID: String, reefText: String) {
        mirrorCoveService.addShellClipComment(coconutCream: clipID, reefReplyText: reefText) { [weak self] reefEnvelope in
            guard let self else { return }
            self.dismissReefReplyVeil()
            if let reefClip = reefEnvelope.sandbarLayering, let reefIndex = self.reefMotionShelf.firstIndex(where: { $0.coconutCream == clipID }) {
                self.reefMotionShelf[reefIndex] = reefClip
                self.wardrobeTable.reloadRows(at: [IndexPath(row: reefIndex, section: 0)], with: .none)
            }
            self.showLagoonToast(reefEnvelope.coastalWardrobe)
        }
    }

    private func dismissReefReplyVeil() {
        reefReplyVeil?.removeFromSuperview()
        reefReplyVeil = nil
    }

    private func showReefClipGuard(_ clipID: String, sourceView: UIView?) {
        guard let reefClip = reefMotionShelf.first(where: { $0.coconutCream == clipID }) else { return }
        presentSuliJoyHarborGuardMenu { [weak self] in
            self?.presentSuliJoyReportSheet(target: .flowyHem(cottonGauze: clipID))
        } block: { [weak self] in
            let visitorID = SuliJoyLagoonVisitor.lagoonGuestToken(for: reefClip.terracottaWarmth.clipStylistAlias)
            SuliJoyCoveMockService.shared.blockLagoonVisitor(seersuckerStripe: visitorID) { guardEnvelope in
                self?.showLagoonToast(guardEnvelope.coastalWardrobe)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.refreshLagoonProfile()
            }
        }
    }

    private func showTideActivityGuard(_ tideID: String, sourceView: UIView) {
        guard let tideActivity = tidePlanShelf.first(where: { $0.tideMark == tideID }) else { return }
        presentSuliJoyHarborGuardMenu { [weak self] in
            self?.presentSuliJoyReportSheet(target: .wideLegLinen(crinkleLinen: tideID))
        } block: { [weak self] in
            let visitorID = SuliJoyLagoonVisitor.lagoonGuestToken(for: tideActivity.shoreHostAlias)
            SuliJoyCoveMockService.shared.blockLagoonVisitor(seersuckerStripe: visitorID) { guardEnvelope in
                self?.showLagoonToast(guardEnvelope.coastalWardrobe)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.refreshLagoonProfile()
            }
        }
    }

    private func openShoreMomentDetail(_ momentID: String) {
        guard let shoreMoment = shoreLookShelf.first(where: { $0.reefMomentID == momentID }) else { return }
        let shoreDetail = SuliJoyShoreMomentReefController(moment: shoreMoment)
        navigationController?.pushViewController(shoreDetail, animated: true)
    }

    private func openTideActivityDetail(_ tideID: String) {
        let tideDetail = SuliJoyTideCoastalDetailController(crinkleLinen: tideID)
        navigationController?.pushViewController(tideDetail, animated: true)
    }

    @objc private func openPearlHarborCove() {
        navigationController?.pushViewController(SuliJoyPearlHarborViewController(), animated: true)
    }

    @objc private func openSearchCove() {
        openSuliJoyLetters()
    }

    @objc private func openSettingCove() {
        navigationController?.pushViewController(SuliJoyShellelasticWaistController(), animated: true)
    }

    @objc private func openLagoonMirror() {
        let lagoonMirror = SuliJoyLagoonMirrorController()
        lagoonMirror.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(lagoonMirror, animated: true)
    }
}
