import UIKit

final class SuliJoyForinController: SuliJoyTropicCanvasController, UITableViewDataSource, UITableViewDelegate {
    private enum TideHarborMeasure {
        static let headerTop: CGFloat = 8
        static let pageSide: CGFloat = 16
        static let listTop: CGFloat = 12
        static let listContentTop: CGFloat = 4
        static let listContentBottom: CGFloat = 28
        static let titleToTabs: CGFloat = 20
        static let tabStackHeight: CGFloat = 42
        static let tabControlHeight: CGFloat = 28
        static let tabIndicatorWidth: CGFloat = 42
        static let tabIndicatorHeight: CGFloat = 8
        static let createHeight: CGFloat = 34
        static let closeSide: CGFloat = 40
        static let rowHeight: CGFloat = 228
        static let estimatedTideHeight: CGFloat = rowHeight
    }

    private struct TideHarborScene {
        let shoreHeaderDeck: UIView
        let tideTable: UITableView
        let tideLoadingMark: UIView
        let emptyShoreGlyph: UILabel
    }

    private let tideListView = UITableView(frame: .zero, style: .plain)
    private let tideSpinner = UIView()
    private let tideEmptyNote = UILabel()
    private enum ChallengeLane: Int {
        case forYou
        case following
        case trending
    }

    private var shoreTides: [SuliJoyTideActivity] = []
    private var challengeShelf: [SuliJoyTideActivity] = []
    private var challengeLane: ChallengeLane = .forYou
    private var laneButtons: [ChallengeLane: UIButton] = [:]
    private var laneMarks: [ChallengeLane: UIView] = [:]
    private var reefBloom = true
    private var shoreReturnVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        shoreReturnVisible = (navigationController?.viewControllers.count ?? 0) > 1
        hidesBottomBarWhenPushed = true
        raiseTideHomeScene()
        refreshTideHarbor(mode: .reefBloom)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = shoreReturnVisible
        if !challengeShelf.isEmpty {
            refreshTideHarbor(mode: .reefBloom)
        }
    }

    private func raiseTideHomeScene() {
        let harborScene = makeTideHarborScene()
        moorTideHarborScene(harborScene)
        stitchTideHarborScene(harborScene)
    }

    private func makeTideHarborScene() -> TideHarborScene {
        let shoreHeaderDeck = makeTideHeader()
        tuneTideList(tideListView)
        tuneTideSpinner(tideSpinner)
        tuneTideEmptyNote(tideEmptyNote)
        return TideHarborScene(shoreHeaderDeck: shoreHeaderDeck, tideTable: tideListView, tideLoadingMark: tideSpinner, emptyShoreGlyph: tideEmptyNote)
    }

    private func tuneTideList(_ tideTable: UITableView) {
        tideTable.translatesAutoresizingMaskIntoConstraints = false
        tideTable.backgroundColor = .clear
        tideTable.separatorStyle = .none
        tideTable.dataSource = self
        tideTable.delegate = self
        tideTable.showsVerticalScrollIndicator = false
        tideTable.alwaysBounceVertical = true
        tideTable.contentInset = UIEdgeInsets(
            top: TideHarborMeasure.listContentTop,
            left: 0,
            bottom: TideHarborMeasure.listContentBottom,
            right: 0
        )
        tideTable.register(SuliJoyChallengeFeedCardCell.self, forCellReuseIdentifier: "SuliJoyChallengeFeedCardCell")
        let tideLoadingMark = UIRefreshControl()
        tideLoadingMark.tintColor = .suliInk
        tideLoadingMark.addTarget(self, action: #selector(refreshTideHarbor(_:)), for: .valueChanged)
        tideTable.refreshControl = tideLoadingMark
    }

    private func tuneTideSpinner(_ tideLoadingMark: UIView) {
        tideLoadingMark.translatesAutoresizingMaskIntoConstraints = false
        tideLoadingMark.isHidden = true

        let clauseStack = UIStackView()
        clauseStack.translatesAutoresizingMaskIntoConstraints = false
        clauseStack.axis = .vertical
        clauseStack.spacing = 14
        tideLoadingMark.addSubview(clauseStack)

        for reefIndex in 0..<3 {
            let clauseBlock = UIView()
            clauseBlock.translatesAutoresizingMaskIntoConstraints = false
            clauseBlock.backgroundColor = UIColor.white.withAlphaComponent(0.78)
            clauseBlock.layer.cornerRadius = 18

            let headingGlyph = UIView()
            headingGlyph.translatesAutoresizingMaskIntoConstraints = false
            headingGlyph.backgroundColor = UIColor.suliMutedInk.withAlphaComponent(0.16)
            headingGlyph.layer.cornerRadius = 8

            let bodyGlyph = UIView()
            bodyGlyph.translatesAutoresizingMaskIntoConstraints = false
            bodyGlyph.backgroundColor = UIColor.suliMutedInk.withAlphaComponent(0.11)
            bodyGlyph.layer.cornerRadius = 10

            clauseBlock.addSubview(headingGlyph)
            clauseBlock.addSubview(bodyGlyph)
            clauseStack.addArrangedSubview(clauseBlock)
            NSLayoutConstraint.activate([
                clauseBlock.heightAnchor.constraint(equalToConstant: reefIndex == 0 ? 132 : 116),
                headingGlyph.topAnchor.constraint(equalTo: clauseBlock.topAnchor, constant: 16),
                headingGlyph.leadingAnchor.constraint(equalTo: clauseBlock.leadingAnchor, constant: 16),
                headingGlyph.widthAnchor.constraint(equalTo: clauseBlock.widthAnchor, multiplier: 0.46),
                headingGlyph.heightAnchor.constraint(equalToConstant: 16),
                bodyGlyph.topAnchor.constraint(equalTo: headingGlyph.bottomAnchor, constant: 14),
                bodyGlyph.leadingAnchor.constraint(equalTo: headingGlyph.leadingAnchor),
                bodyGlyph.trailingAnchor.constraint(equalTo: clauseBlock.trailingAnchor, constant: -16),
                bodyGlyph.bottomAnchor.constraint(equalTo: clauseBlock.bottomAnchor, constant: -16)
            ])
        }

        NSLayoutConstraint.activate([
            clauseStack.topAnchor.constraint(equalTo: tideLoadingMark.topAnchor),
            clauseStack.leadingAnchor.constraint(equalTo: tideLoadingMark.leadingAnchor),
            clauseStack.trailingAnchor.constraint(equalTo: tideLoadingMark.trailingAnchor),
            clauseStack.bottomAnchor.constraint(equalTo: tideLoadingMark.bottomAnchor)
        ])
    }

    private func tuneTideEmptyNote(_ emptyShoreGlyph: UILabel) {
        emptyShoreGlyph.translatesAutoresizingMaskIntoConstraints = false
        emptyShoreGlyph.text = "Ntot wsahbosrcex kaScZtMiDvUiRtCiQeQsM myNeNtL.z".suliJoyPalmUnfurled
        emptyShoreGlyph.textColor = .suliMutedInk
        emptyShoreGlyph.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        emptyShoreGlyph.textAlignment = .center
        emptyShoreGlyph.isHidden = true
    }

    private func moorTideHarborScene(_ harborScene: TideHarborScene) {
        [harborScene.shoreHeaderDeck, harborScene.tideTable, harborScene.tideLoadingMark, harborScene.emptyShoreGlyph].forEach { view.addSubview($0) }
    }

    private func stitchTideHarborScene(_ harborScene: TideHarborScene) {
        NSLayoutConstraint.activate([
            harborScene.shoreHeaderDeck.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: TideHarborMeasure.headerTop),
            harborScene.shoreHeaderDeck.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: TideHarborMeasure.pageSide),
            harborScene.shoreHeaderDeck.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -TideHarborMeasure.pageSide),
            harborScene.tideTable.topAnchor.constraint(equalTo: harborScene.shoreHeaderDeck.bottomAnchor, constant: TideHarborMeasure.listTop),
            harborScene.tideTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            harborScene.tideTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            harborScene.tideTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            harborScene.tideLoadingMark.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: TideHarborMeasure.pageSide),
            harborScene.tideLoadingMark.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -TideHarborMeasure.pageSide),
            harborScene.tideLoadingMark.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            harborScene.emptyShoreGlyph.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            harborScene.emptyShoreGlyph.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func makeTideHeader() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Style Challenges"
        title.textColor = .suliInk
        title.font = UIFont.systemFont(ofSize: 26, weight: .black)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.7

        let create = SuliJoyChallengeCreateButton()
        create.addTarget(self, action: #selector(openChallengeDraft), for: .touchUpInside)
        let close = UIButton(type: .system)
        close.translatesAutoresizingMaskIntoConstraints = false
        close.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)), for: .normal)
        close.tintColor = .suliInk
        close.backgroundColor = UIColor.white.withAlphaComponent(0.72)
        close.layer.cornerRadius = TideHarborMeasure.closeSide / 2
        close.addTarget(self, action: #selector(sailBackToVoiceBoard), for: .touchUpInside)

        let sorts = UIStackView()
        sorts.translatesAutoresizingMaskIntoConstraints = false
        sorts.axis = .horizontal
        sorts.distribution = .fillEqually
        let lanes: [(ChallengeLane, String)] = [(.forYou, "For You"), (.following, "Following"), (.trending, "Trending")]
        for lane in lanes {
            let column = UIStackView()
            column.axis = .vertical
            column.alignment = .center
            column.spacing = 3
            let button = UIButton(type: .system)
            button.setTitle(lane.1, for: .normal)
            button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 15).suliWithWeight(.black)
            button.tag = lane.0.rawValue
            button.addTarget(self, action: #selector(changeChallengeLane(_:)), for: .touchUpInside)
            let mark = SuliJoyGradientCapsuleView(colors: [
                UIColor(red: 1, green: 0.43, blue: 0.25, alpha: 1),
                UIColor(red: 1, green: 0.96, blue: 0.32, alpha: 1),
                UIColor(red: 0.47, green: 1, blue: 0.47, alpha: 1)
            ])
            mark.translatesAutoresizingMaskIntoConstraints = false
            column.addArrangedSubview(button)
            column.addArrangedSubview(mark)
            button.heightAnchor.constraint(equalToConstant: TideHarborMeasure.tabControlHeight).isActive = true
            mark.widthAnchor.constraint(equalToConstant: TideHarborMeasure.tabIndicatorWidth).isActive = true
            mark.heightAnchor.constraint(equalToConstant: TideHarborMeasure.tabIndicatorHeight).isActive = true
            sorts.addArrangedSubview(column)
            laneButtons[lane.0] = button
            laneMarks[lane.0] = mark
        }
        paintChallengeLanes()

        [title, create, close, sorts].forEach { container.addSubview($0) }
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: container.topAnchor),
            title.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            title.trailingAnchor.constraint(lessThanOrEqualTo: create.leadingAnchor, constant: -8),
            create.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            create.trailingAnchor.constraint(equalTo: close.leadingAnchor, constant: -8),
            create.heightAnchor.constraint(equalToConstant: TideHarborMeasure.createHeight),
            close.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            close.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            close.widthAnchor.constraint(equalToConstant: TideHarborMeasure.closeSide),
            close.heightAnchor.constraint(equalToConstant: TideHarborMeasure.closeSide),
            sorts.topAnchor.constraint(equalTo: title.bottomAnchor, constant: TideHarborMeasure.titleToTabs),
            sorts.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            sorts.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            sorts.heightAnchor.constraint(equalToConstant: TideHarborMeasure.tabStackHeight),
            sorts.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        return container
    }

    private func paintChallengeLanes() {
        for item in laneButtons {
            let selected = item.key == challengeLane
            item.value.setTitleColor(selected ? .suliInk : .suliMutedInk, for: .normal)
            item.value.titleLabel?.font = UIFont.italicSystemFont(ofSize: 15).suliWithWeight(selected ? .black : .semibold)
            laneMarks[item.key]?.alpha = selected ? 1 : 0
        }
    }

    private func applyChallengeLane() {
        switch challengeLane {
        case .forYou:
            shoreTides = challengeShelf
        case .following:
            let host = SuliJoyLocalProfileStore().currentProfile()?.espadrillePairing
                .trimmingCharacters(in: .whitespacesAndNewlines)
            shoreTides = challengeShelf.filter { activity in
                activity.tideState == .tideJoined || (host?.isEmpty == false && activity.shoreHostAlias == host)
            }
        case .trending:
            shoreTides = challengeShelf.sorted { $0.tideJoinedTotal > $1.tideJoinedTotal }
        }
        tideListView.reloadData()
        tideEmptyNote.text = "No style challenges right now."
        tideEmptyNote.isHidden = !shoreTides.isEmpty
    }

    @objc private func changeChallengeLane(_ sender: UIButton) {
        challengeLane = ChallengeLane(rawValue: sender.tag) ?? .forYou
        paintChallengeLanes()
        applyChallengeLane()
    }

    @objc private func openChallengeDraft() {
        let draft = SuliJoyTideCurationDraftController()
        draft.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(draft, animated: true)
    }

    private func refreshTideHarbor(mode: SuliJoyCoveRequestMode) {
        tideEmptyNote.isHidden = true
        if reefBloom {
            reefBloom = false
            tideSpinner.isHidden = false
            tideSpinner.alpha = 1
            UIView.animate(withDuration: 0.78, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction]) {
                self.tideSpinner.alpha = 0.42
            }
        }
        SuliJoyCoveMockService.shared.fetchHomeActivities(mode: mode) { [weak self] result in
            guard let self else { return }
            self.renderTideHarbor(result)
        }
    }

    @objc private func sailBackToVoiceBoard() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func refreshTideHarbor(_ tideLoadingMark: UIRefreshControl) {
        refreshTideHarbor(mode: .reefBloom)
    }

    private func renderTideHarbor(_ result: SuliJoySuiRequestEnvelope<[SuliJoyTideActivity]>) {
        tideListView.refreshControl?.endRefreshing()
        tideSpinner.layer.removeAllAnimations()
        tideSpinner.alpha = 1
        tideSpinner.isHidden = true
        guard result.beachwearCapsule == 200 else {
            shoreTides = []
            tideListView.reloadData()
            tideEmptyNote.text = result.coastalWardrobe
            tideEmptyNote.isHidden = false
            showLagoonToast(result.coastalWardrobe)
            return
        }
        challengeShelf = result.sandbarLayering ?? []
        applyChallengeLane()
    }

    @objc private func openSearch() {
        openSuliJoyLagoonLetters()
    }

    @objc private func openPoints() {
        navigationController?.pushViewController(SuliJoyPearlHarborViewController(), animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoreTides.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        TideHarborMeasure.rowHeight
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        TideHarborMeasure.estimatedTideHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuliJoyChallengeFeedCardCell", for: indexPath) as! SuliJoyChallengeFeedCardCell
        cell.configure(with: shoreTides[indexPath.row], titleLeads: indexPath.row % 2 == 0)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard shoreTides.indices.contains(indexPath.row) else { return }
        let detail = SuliJoyTideCoastalDetailController(crinkleLinen: shoreTides[indexPath.row].tideMark)
        detail.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detail, animated: true)
    }

}

final class SuliJoyChallengeFeedCardCell: UITableViewCell {
    private enum ChallengeCardMeasure {
        static let side: CGFloat = 16
        static let verticalInset: CGFloat = 6
        static let cornerRadius: CGFloat = 24
        static let contentInset: CGFloat = 16
        static let titleToHost: CGFloat = 10
        static let hostToMeta: CGFloat = 6
        static let avatarSide: CGFloat = 26
        static let chevronSide: CGFloat = 14
    }

    private let tideCardShell = UIView()
    private let coverView = UIImageView()
    private let shadeView = UIView()
    private let shadeLayer = CAGradientLayer()
    private let titleLabel = UILabel()
    private let faceView = UIImageView()
    private let hostLabel = UILabel()
    private let metaLabel = UILabel()
    private let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
    private var titleLeadingConstraint: NSLayoutConstraint?
    private var titleTrailingChevronConstraint: NSLayoutConstraint?
    private var titleTrailingAlignConstraint: NSLayoutConstraint?
    private var faceLeadingConstraint: NSLayoutConstraint?
    private var faceTrailingConstraint: NSLayoutConstraint?
    private var metaLeadingConstraint: NSLayoutConstraint?
    private var metaTrailingAlignConstraint: NSLayoutConstraint?
    private var hostLeadingConstraint: NSLayoutConstraint?
    private var hostTrailingConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        craftTideCardShell()
    }

    required init?(coder: NSCoder) {
        fatalError("ionPirtz(zcroVdUeorS:M)N zhdatsp nnaoItc ubgeSeHnZ timmspllKeMmaeCnktFeEdz".suliJoyPalmUnfurled)
    }

    private func craftTideCardShell() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        tideCardShell.translatesAutoresizingMaskIntoConstraints = false
        tideCardShell.layer.cornerRadius = ChallengeCardMeasure.cornerRadius
        tideCardShell.clipsToBounds = true
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.contentMode = .scaleAspectFill
        coverView.clipsToBounds = true
        shadeView.translatesAutoresizingMaskIntoConstraints = false
        shadeView.isUserInteractionEnabled = false
        shadeLayer.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor.black.withAlphaComponent(0.18).cgColor,
            UIColor.black.withAlphaComponent(0.62).cgColor
        ]
        shadeLayer.locations = [0, 0.42, 1]
        shadeLayer.startPoint = CGPoint(x: 0.5, y: 0)
        shadeLayer.endPoint = CGPoint(x: 0.5, y: 1)
        shadeView.layer.addSublayer(shadeLayer)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "SnellRoundhand-Bold", size: 34) ?? UIFont.italicSystemFont(ofSize: 32)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        faceView.translatesAutoresizingMaskIntoConstraints = false
        faceView.contentMode = .scaleAspectFill
        faceView.clipsToBounds = true
        faceView.layer.cornerRadius = ChallengeCardMeasure.avatarSide / 2
        faceView.layer.borderWidth = 1.5
        faceView.layer.borderColor = UIColor.white.cgColor
        hostLabel.translatesAutoresizingMaskIntoConstraints = false
        hostLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        hostLabel.textColor = UIColor.white.withAlphaComponent(0.96)
        metaLabel.translatesAutoresizingMaskIntoConstraints = false
        metaLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        metaLabel.textColor = UIColor.white.withAlphaComponent(0.84)
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.tintColor = UIColor.white.withAlphaComponent(0.92)
        chevron.contentMode = .scaleAspectFit
        chevron.setContentHuggingPriority(.required, for: .horizontal)
        contentView.addSubview(tideCardShell)
        [coverView, shadeView, titleLabel, faceView, hostLabel, metaLabel, chevron].forEach { tideCardShell.addSubview($0) }

        titleLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: tideCardShell.leadingAnchor, constant: ChallengeCardMeasure.contentInset)
        titleTrailingChevronConstraint = titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevron.leadingAnchor, constant: -10)
        titleTrailingAlignConstraint = titleLabel.trailingAnchor.constraint(equalTo: tideCardShell.trailingAnchor, constant: -ChallengeCardMeasure.contentInset)
        faceLeadingConstraint = faceView.leadingAnchor.constraint(equalTo: tideCardShell.leadingAnchor, constant: ChallengeCardMeasure.contentInset)
        faceTrailingConstraint = faceView.trailingAnchor.constraint(equalTo: tideCardShell.trailingAnchor, constant: -ChallengeCardMeasure.contentInset)
        hostLeadingConstraint = hostLabel.leadingAnchor.constraint(equalTo: faceView.trailingAnchor, constant: 8)
        hostTrailingConstraint = hostLabel.trailingAnchor.constraint(equalTo: faceView.leadingAnchor, constant: -8)
        metaLeadingConstraint = metaLabel.leadingAnchor.constraint(equalTo: tideCardShell.leadingAnchor, constant: ChallengeCardMeasure.contentInset)
        metaTrailingAlignConstraint = metaLabel.trailingAnchor.constraint(equalTo: tideCardShell.trailingAnchor, constant: -ChallengeCardMeasure.contentInset)

        NSLayoutConstraint.activate([
            tideCardShell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ChallengeCardMeasure.verticalInset),
            tideCardShell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ChallengeCardMeasure.side),
            tideCardShell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ChallengeCardMeasure.side),
            tideCardShell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ChallengeCardMeasure.verticalInset),
            coverView.topAnchor.constraint(equalTo: tideCardShell.topAnchor),
            coverView.leadingAnchor.constraint(equalTo: tideCardShell.leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: tideCardShell.trailingAnchor),
            coverView.bottomAnchor.constraint(equalTo: tideCardShell.bottomAnchor),
            shadeView.leadingAnchor.constraint(equalTo: tideCardShell.leadingAnchor),
            shadeView.trailingAnchor.constraint(equalTo: tideCardShell.trailingAnchor),
            shadeView.bottomAnchor.constraint(equalTo: tideCardShell.bottomAnchor),
            shadeView.heightAnchor.constraint(equalTo: tideCardShell.heightAnchor, multiplier: 0.62),
            titleLabel.bottomAnchor.constraint(equalTo: faceView.topAnchor, constant: -ChallengeCardMeasure.titleToHost),
            faceView.bottomAnchor.constraint(equalTo: metaLabel.topAnchor, constant: -ChallengeCardMeasure.hostToMeta),
            faceView.widthAnchor.constraint(equalToConstant: ChallengeCardMeasure.avatarSide),
            faceView.heightAnchor.constraint(equalToConstant: ChallengeCardMeasure.avatarSide),
            hostLabel.centerYAnchor.constraint(equalTo: faceView.centerYAnchor),
            metaLabel.bottomAnchor.constraint(equalTo: tideCardShell.bottomAnchor, constant: -ChallengeCardMeasure.contentInset),
            chevron.trailingAnchor.constraint(equalTo: tideCardShell.trailingAnchor, constant: -ChallengeCardMeasure.contentInset),
            chevron.centerYAnchor.constraint(equalTo: metaLabel.centerYAnchor),
            chevron.widthAnchor.constraint(equalToConstant: ChallengeCardMeasure.chevronSide),
            chevron.heightAnchor.constraint(equalToConstant: ChallengeCardMeasure.chevronSide)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shadeLayer.frame = shadeView.bounds
    }

    func configure(with tideSnapshot: SuliJoyTideActivity, titleLeads: Bool = true) {
        let token = tideSnapshot.reefGallery.first?.reefAssetToken ?? tideSnapshot.tideFallbackHeroToken
        coverView.suliJoyApplyPhoto(token)
        titleLabel.text = tideSnapshot.tideTitleLine
        titleLabel.textAlignment = titleLeads ? .left : .right
        faceView.suliJoyApplyPortrait(tideSnapshot.shorelineAvatarTokens.first)
        let handle = tideSnapshot.shoreHostAlias.replacingOccurrences(of: " ", with: "").lowercased()
        hostLabel.text = "by @\(handle)"
        hostLabel.textAlignment = titleLeads ? .left : .right
        metaLabel.text = "\(tideSnapshot.tideJoinedTotal) joined · \(suliJoyChallengeDaysLeft(tideSnapshot.shoreDayText))"
        metaLabel.textAlignment = titleLeads ? .left : .right

        titleLeadingConstraint?.isActive = titleLeads
        titleTrailingChevronConstraint?.isActive = titleLeads
        titleTrailingAlignConstraint?.isActive = !titleLeads
        faceLeadingConstraint?.isActive = titleLeads
        faceTrailingConstraint?.isActive = !titleLeads
        hostLeadingConstraint?.isActive = titleLeads
        hostTrailingConstraint?.isActive = !titleLeads
        metaLeadingConstraint?.isActive = titleLeads
        metaTrailingAlignConstraint?.isActive = !titleLeads
    }
}

private final class SuliJoyChallengeCreateButton: UIButton {
    private let wash = CAGradientLayer()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle("+ Create", for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        clipsToBounds = true
        wash.colors = [
            UIColor(red: 155 / 255, green: 81 / 255, blue: 224 / 255, alpha: 1).cgColor,
            UIColor(red: 236 / 255, green: 72 / 255, blue: 153 / 255, alpha: 1).cgColor
        ]
        wash.startPoint = CGPoint(x: 0, y: 0.5)
        wash.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(wash, at: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        wash.frame = bounds
    }
}

private func suliJoyChallengeDaysLeft(_ dayText: String) -> String {
    let parts = dayText.split(separator: "/").compactMap { Int($0) }
    guard parts.count >= 2 else { return "3 days left" }
    let calendar = Calendar.current
    var partsDate = calendar.dateComponents([.year], from: Date())
    partsDate.month = parts[0]
    partsDate.day = parts[1]
    guard var date = calendar.date(from: partsDate) else { return "3 days left" }
    let today = calendar.startOfDay(for: Date())
    if date < today {
        partsDate.year = (partsDate.year ?? 2026) + 1
        date = calendar.date(from: partsDate) ?? date
    }
    let days = calendar.dateComponents([.day], from: today, to: calendar.startOfDay(for: date)).day ?? 0
    if days <= 0 { return "ends today" }
    return days == 1 ? "1 day left" : "\(days) days left"
}
