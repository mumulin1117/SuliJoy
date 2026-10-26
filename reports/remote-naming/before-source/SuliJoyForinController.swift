import UIKit

final class SuliJoyForinController: SuliJoyTropicCanvasController, UITableViewDataSource, UITableViewDelegate {
    private enum TideHarborMeasure {
        static let headerTop: CGFloat = 8
        static let pageSide: CGFloat = 16
        static let listTop: CGFloat = 12
        static let listContentTop: CGFloat = 4
        static let listContentBottom: CGFloat = 28
        static let alreadyOwnsIslandMail: CGFloat = 20
        static let deleteCurrentIslandAccount: CGFloat = 42
        static let makeShoreSignupColumn: CGFloat = 28
        static let controllers: CGFloat = 42
        static let moorReefCardScene: CGFloat = 8
        static let makeLagoonEntryButton: CGFloat = 34
        static let reefCopy: CGFloat = 40
        static let stitchTideCardScene: CGFloat = 228
        static let estimatedTideHeight: CGFloat = stitchTideCardScene
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
    private enum shorelineSectionStack: Int {
        case ringPath
        case suliJoyShellClipPublished
        case bottomInset
    }

    private var shoreTides: [SuliJoyTideActivity] = []
    private var occupiedLagoonSeatCount: [SuliJoyTideActivity] = []
    private var raiseHarborFlag: shorelineSectionStack = .ringPath
    private var shoreMailInput: [shorelineSectionStack: UIButton] = [:]
    private var pearlGridView: [shorelineSectionStack: UIView] = [:]
    private var reefBloom = true
    private var reefPhotoSlots = false

    override func viewDidLoad() {
        super.viewDidLoad()
        reefPhotoSlots = (navigationController?.viewControllers.count ?? 0) > 1
        hidesBottomBarWhenPushed = true
        raiseTideHomeScene()
        refreshTideHarbor(mode: .reefBloom)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = reefPhotoSlots
        if !occupiedLagoonSeatCount.isEmpty {
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
        tideTable.register(shoreBriefMeter.self, forCellReuseIdentifier: "SxuxlxixJxoxyxCxhxaxlxlxexnxgxexFxexexdxCxaxrxdxCxexlxlx".suliJoyPalmUnfurled)
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
        let elsewhoMistVeil = UIView()
        elsewhoMistVeil.translatesAutoresizingMaskIntoConstraints = false

        let pinwhoMistVeil = UILabel()
        pinwhoMistVeil.translatesAutoresizingMaskIntoConstraints = false
        pinwhoMistVeil.text = "Sxtxyxlxex xCxhxaxlxlxexnxgxexsx".suliJoyPalmUnfurled
        pinwhoMistVeil.textColor = .suliInk
        pinwhoMistVeil.font = UIFont.systemFont(ofSize: 26, weight: .black)
        pinwhoMistVeil.adjustsFontSizeToFitWidth = true
        pinwhoMistVeil.minimumScaleFactor = 0.7

        let pearlShelves = SuliJoyGuestMomentPreviewCard()
        pearlShelves.addTarget(self, action: #selector(coveScene), for: .touchUpInside)
        let titleDrop = UIButton(type: .system)
        titleDrop.translatesAutoresizingMaskIntoConstraints = false
        titleDrop.setImage(UIImage(systemName: "xxmxaxrxkx".suliJoyPalmUnfurled, withConfiguration: UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)), for: .normal)
        titleDrop.tintColor = .suliInk
        titleDrop.backgroundColor = UIColor.white.withAlphaComponent(0.72)
        titleDrop.layer.cornerRadius = TideHarborMeasure.reefCopy / 2
        titleDrop.addTarget(self, action: #selector(forgeReefReturnControl), for: .touchUpInside)

        let heroPanel = UIStackView()
        heroPanel.translatesAutoresizingMaskIntoConstraints = false
        heroPanel.axis = .horizontal
        heroPanel.distribution = .fillEqually
        let profileEnvelope: [(shorelineSectionStack, String)] = [(.ringPath, "Fxoxrx xYxoxux".suliJoyPalmUnfurled), (.suliJoyShellClipPublished, "Fxoxlxlxoxwxixnxgx".suliJoyPalmUnfurled), (.bottomInset, "Txrxexnxdxixnxgx".suliJoyPalmUnfurled)]
        for nextTideMark in profileEnvelope {
            let clipPortraitToken = UIStackView()
            clipPortraitToken.axis = .vertical
            clipPortraitToken.alignment = .center
            clipPortraitToken.spacing = 3
            let button = UIButton(type: .system)
            button.setTitle(nextTideMark.1, for: .normal)
            button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 15).suliWithWeight(.black)
            button.tag = nextTideMark.0.rawValue
            button.addTarget(self, action: #selector(fetchShellClips(_:)), for: .touchUpInside)
            let tideIndicatorWidth = SuliJoyGradientCapsuleView(colors: [
                UIColor(red: 1, green: 0.43, blue: 0.25, alpha: 1),
                UIColor(red: 1, green: 0.96, blue: 0.32, alpha: 1),
                UIColor(red: 0.47, green: 1, blue: 0.47, alpha: 1)
            ])
            tideIndicatorWidth.translatesAutoresizingMaskIntoConstraints = false
            clipPortraitToken.addArrangedSubview(button)
            clipPortraitToken.addArrangedSubview(tideIndicatorWidth)
            button.heightAnchor.constraint(equalToConstant: TideHarborMeasure.makeShoreSignupColumn).isActive = true
            tideIndicatorWidth.widthAnchor.constraint(equalToConstant: TideHarborMeasure.controllers).isActive = true
            tideIndicatorWidth.heightAnchor.constraint(equalToConstant: TideHarborMeasure.moorReefCardScene).isActive = true
            heroPanel.addArrangedSubview(clipPortraitToken)
            shoreMailInput[nextTideMark.0] = button
            pearlGridView[nextTideMark.0] = tideIndicatorWidth
        }
        portraitSheet()

        [pinwhoMistVeil, pearlShelves, titleDrop, heroPanel].forEach { elsewhoMistVeil.addSubview($0) }
        NSLayoutConstraint.activate([
            pinwhoMistVeil.topAnchor.constraint(equalTo: elsewhoMistVeil.topAnchor),
            pinwhoMistVeil.leadingAnchor.constraint(equalTo: elsewhoMistVeil.leadingAnchor),
            pinwhoMistVeil.trailingAnchor.constraint(lessThanOrEqualTo: pearlShelves.leadingAnchor, constant: -8),
            pearlShelves.centerYAnchor.constraint(equalTo: pinwhoMistVeil.centerYAnchor),
            pearlShelves.trailingAnchor.constraint(equalTo: titleDrop.leadingAnchor, constant: -8),
            pearlShelves.heightAnchor.constraint(equalToConstant: TideHarborMeasure.makeLagoonEntryButton),
            titleDrop.centerYAnchor.constraint(equalTo: pinwhoMistVeil.centerYAnchor),
            titleDrop.trailingAnchor.constraint(equalTo: elsewhoMistVeil.trailingAnchor),
            titleDrop.widthAnchor.constraint(equalToConstant: TideHarborMeasure.reefCopy),
            titleDrop.heightAnchor.constraint(equalToConstant: TideHarborMeasure.reefCopy),
            heroPanel.topAnchor.constraint(equalTo: pinwhoMistVeil.bottomAnchor, constant: TideHarborMeasure.alreadyOwnsIslandMail),
            heroPanel.leadingAnchor.constraint(equalTo: elsewhoMistVeil.leadingAnchor),
            heroPanel.trailingAnchor.constraint(equalTo: elsewhoMistVeil.trailingAnchor),
            heroPanel.heightAnchor.constraint(equalToConstant: TideHarborMeasure.deleteCurrentIslandAccount),
            heroPanel.bottomAnchor.constraint(equalTo: elsewhoMistVeil.bottomAnchor)
        ])
        return elsewhoMistVeil
    }

    private func portraitSheet() {
        for item in shoreMailInput {
            let selected = item.key == raiseHarborFlag
            item.value.setTitleColor(selected ? .suliInk : .suliMutedInk, for: .normal)
            item.value.titleLabel?.font = UIFont.italicSystemFont(ofSize: 15).suliWithWeight(selected ? .black : .semibold)
            pearlGridView[item.key]?.alpha = selected ? 1 : 0
        }
    }

    private func suliJoyCoastalModeration() {
        switch raiseHarborFlag {
        case .ringPath:
            shoreTides = occupiedLagoonSeatCount
        case .suliJoyShellClipPublished:
            let motionPulseButton = SuliJoyLocalProfileStore().currentProfile()?.espadrillePairing
                .trimmingCharacters(in: .whitespacesAndNewlines)
            shoreTides = occupiedLagoonSeatCount.filter { activity in
                activity.tideState == .tideJoined || (motionPulseButton?.isEmpty == false && activity.shoreHostAlias == motionPulseButton)
            }
        case .bottomInset:
            shoreTides = occupiedLagoonSeatCount.sorted { $0.tideJoinedTotal > $1.tideJoinedTotal }
        }
        tideListView.reloadData()
        tideEmptyNote.text = "Nxox xsxtxyxlxex xcxhxaxlxlxexnxgxexsx xrxixgxhxtx xnxoxwx.x".suliJoyPalmUnfurled
        tideEmptyNote.isHidden = !shoreTides.isEmpty
    }

    @objc private func fetchShellClips(_ sender: UIButton) {
        raiseHarborFlag = shorelineSectionStack(rawValue: sender.tag) ?? .ringPath
        portraitSheet()
        suliJoyCoastalModeration()
    }

    @objc private func coveScene() {
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

    @objc private func forgeReefReturnControl() {
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
        occupiedLagoonSeatCount = result.sandbarLayering ?? []
        suliJoyCoastalModeration()
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
        TideHarborMeasure.stitchTideCardScene
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        TideHarborMeasure.estimatedTideHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SxuxlxixJxoxyxCxhxaxlxlxexnxgxexFxexexdxCxaxrxdxCxexlxlx".suliJoyPalmUnfurled, for: indexPath) as! shoreBriefMeter
        cell.configure(with: shoreTides[indexPath.row], shellWidth: indexPath.row % 2 == 0)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard shoreTides.indices.contains(indexPath.row) else { return }
        let detail = SuliJoyTideCoastalDetailController(crinkleLinen: shoreTides[indexPath.row].tideMark)
        detail.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detail, animated: true)
    }

}

final class shoreBriefMeter: UITableViewCell {
    private enum tuneLagoonLetterCanvas {
        static let coastalRuleCapsule: CGFloat = 16
        static let reefCancelTap: CGFloat = 6
        static let lagoonAnswer: CGFloat = 24
        static let launchOptions: CGFloat = 16
        static let ShellWardrobeMeasure: CGFloat = 10
        static let onLagoonConsentAccept: CGFloat = 6
        static let imageWaveRhythmView: CGFloat = 26
        static let shorePrimaryControl: CGFloat = 14
    }

    private let tideCardShell = UIView()
    private let breezyFit = UIImageView()
    private let lagoonCrownText = UIView()
    private let tideActivity = CAGradientLayer()
    private let stitchShorelineReelCove = UILabel()
    private let tapReefMotion = UIImageView()
    private let presentShoreCommentPrompt = UILabel()
    private let tideSessionVault = UILabel()
    private let allAsuliJoyShorelineStoreccounts = UIImageView(image: UIImage(systemName: "cxhxexvxrxoxnx.xrxixgxhxtx".suliJoyPalmUnfurled))
    private var reefCameraView: NSLayoutConstraint?
    private var safeCargo: NSLayoutConstraint?
    private var prepareGradientTideShell: NSLayoutConstraint?
    private var localReefMotionDirectory: NSLayoutConstraint?
    private var lagoonEntryControl: NSLayoutConstraint?
    private var shell: NSLayoutConstraint?
    private var reefPreviewViews: NSLayoutConstraint?
    private var senderName: NSLayoutConstraint?
    private var toastMaxInset: NSLayoutConstraint?

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
        tideCardShell.layer.cornerRadius = tuneLagoonLetterCanvas.lagoonAnswer
        tideCardShell.clipsToBounds = true
        breezyFit.translatesAutoresizingMaskIntoConstraints = false
        breezyFit.contentMode = .scaleAspectFill
        breezyFit.clipsToBounds = true
        lagoonCrownText.translatesAutoresizingMaskIntoConstraints = false
        lagoonCrownText.isUserInteractionEnabled = false
        tideActivity.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor.black.withAlphaComponent(0.18).cgColor,
            UIColor.black.withAlphaComponent(0.62).cgColor
        ]
        tideActivity.locations = [0, 0.42, 1]
        tideActivity.startPoint = CGPoint(x: 0.5, y: 0)
        tideActivity.endPoint = CGPoint(x: 0.5, y: 1)
        lagoonCrownText.layer.addSublayer(tideActivity)
        stitchShorelineReelCove.translatesAutoresizingMaskIntoConstraints = false
        stitchShorelineReelCove.font = UIFont(name: "SxnxexlxlxRxoxuxnxdxhxaxnxdx-xBxoxlxdx".suliJoyPalmUnfurled, size: 34) ?? UIFont.italicSystemFont(ofSize: 32)
        stitchShorelineReelCove.textColor = .white
        stitchShorelineReelCove.numberOfLines = 2
        tapReefMotion.translatesAutoresizingMaskIntoConstraints = false
        tapReefMotion.contentMode = .scaleAspectFill
        tapReefMotion.clipsToBounds = true
        tapReefMotion.layer.cornerRadius = tuneLagoonLetterCanvas.imageWaveRhythmView / 2
        tapReefMotion.layer.borderWidth = 1.5
        tapReefMotion.layer.borderColor = UIColor.white.cgColor
        presentShoreCommentPrompt.translatesAutoresizingMaskIntoConstraints = false
        presentShoreCommentPrompt.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        presentShoreCommentPrompt.textColor = UIColor.white.withAlphaComponent(0.96)
        tideSessionVault.translatesAutoresizingMaskIntoConstraints = false
        tideSessionVault.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        tideSessionVault.textColor = UIColor.white.withAlphaComponent(0.84)
        allAsuliJoyShorelineStoreccounts.translatesAutoresizingMaskIntoConstraints = false
        allAsuliJoyShorelineStoreccounts.tintColor = UIColor.white.withAlphaComponent(0.92)
        allAsuliJoyShorelineStoreccounts.contentMode = .scaleAspectFit
        allAsuliJoyShorelineStoreccounts.setContentHuggingPriority(.required, for: .horizontal)
        contentView.addSubview(tideCardShell)
        [breezyFit, lagoonCrownText, stitchShorelineReelCove, tapReefMotion, presentShoreCommentPrompt, tideSessionVault, allAsuliJoyShorelineStoreccounts].forEach { tideCardShell.addSubview($0) }

        reefCameraView = stitchShorelineReelCove.leadingAnchor.constraint(equalTo: tideCardShell.leadingAnchor, constant: tuneLagoonLetterCanvas.launchOptions)
        safeCargo = stitchShorelineReelCove.trailingAnchor.constraint(lessThanOrEqualTo: allAsuliJoyShorelineStoreccounts.leadingAnchor, constant: -10)
        prepareGradientTideShell = stitchShorelineReelCove.trailingAnchor.constraint(equalTo: tideCardShell.trailingAnchor, constant: -tuneLagoonLetterCanvas.launchOptions)
        localReefMotionDirectory = tapReefMotion.leadingAnchor.constraint(equalTo: tideCardShell.leadingAnchor, constant: tuneLagoonLetterCanvas.launchOptions)
        lagoonEntryControl = tapReefMotion.trailingAnchor.constraint(equalTo: tideCardShell.trailingAnchor, constant: -tuneLagoonLetterCanvas.launchOptions)
        senderName = presentShoreCommentPrompt.leadingAnchor.constraint(equalTo: tapReefMotion.trailingAnchor, constant: 8)
        toastMaxInset = presentShoreCommentPrompt.trailingAnchor.constraint(equalTo: tapReefMotion.leadingAnchor, constant: -8)
        shell = tideSessionVault.leadingAnchor.constraint(equalTo: tideCardShell.leadingAnchor, constant: tuneLagoonLetterCanvas.launchOptions)
        reefPreviewViews = tideSessionVault.trailingAnchor.constraint(equalTo: tideCardShell.trailingAnchor, constant: -tuneLagoonLetterCanvas.launchOptions)

        NSLayoutConstraint.activate([
            tideCardShell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: tuneLagoonLetterCanvas.reefCancelTap),
            tideCardShell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: tuneLagoonLetterCanvas.coastalRuleCapsule),
            tideCardShell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -tuneLagoonLetterCanvas.coastalRuleCapsule),
            tideCardShell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -tuneLagoonLetterCanvas.reefCancelTap),
            breezyFit.topAnchor.constraint(equalTo: tideCardShell.topAnchor),
            breezyFit.leadingAnchor.constraint(equalTo: tideCardShell.leadingAnchor),
            breezyFit.trailingAnchor.constraint(equalTo: tideCardShell.trailingAnchor),
            breezyFit.bottomAnchor.constraint(equalTo: tideCardShell.bottomAnchor),
            lagoonCrownText.leadingAnchor.constraint(equalTo: tideCardShell.leadingAnchor),
            lagoonCrownText.trailingAnchor.constraint(equalTo: tideCardShell.trailingAnchor),
            lagoonCrownText.bottomAnchor.constraint(equalTo: tideCardShell.bottomAnchor),
            lagoonCrownText.heightAnchor.constraint(equalTo: tideCardShell.heightAnchor, multiplier: 0.62),
            stitchShorelineReelCove.bottomAnchor.constraint(equalTo: tapReefMotion.topAnchor, constant: -tuneLagoonLetterCanvas.ShellWardrobeMeasure),
            tapReefMotion.bottomAnchor.constraint(equalTo: tideSessionVault.topAnchor, constant: -tuneLagoonLetterCanvas.onLagoonConsentAccept),
            tapReefMotion.widthAnchor.constraint(equalToConstant: tuneLagoonLetterCanvas.imageWaveRhythmView),
            tapReefMotion.heightAnchor.constraint(equalToConstant: tuneLagoonLetterCanvas.imageWaveRhythmView),
            presentShoreCommentPrompt.centerYAnchor.constraint(equalTo: tapReefMotion.centerYAnchor),
            tideSessionVault.bottomAnchor.constraint(equalTo: tideCardShell.bottomAnchor, constant: -tuneLagoonLetterCanvas.launchOptions),
            allAsuliJoyShorelineStoreccounts.trailingAnchor.constraint(equalTo: tideCardShell.trailingAnchor, constant: -tuneLagoonLetterCanvas.launchOptions),
            allAsuliJoyShorelineStoreccounts.centerYAnchor.constraint(equalTo: tideSessionVault.centerYAnchor),
            allAsuliJoyShorelineStoreccounts.widthAnchor.constraint(equalToConstant: tuneLagoonLetterCanvas.shorePrimaryControl),
            allAsuliJoyShorelineStoreccounts.heightAnchor.constraint(equalToConstant: tuneLagoonLetterCanvas.shorePrimaryControl)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tideActivity.frame = lagoonCrownText.bounds
    }

    func configure(with tideSnapshot: SuliJoyTideActivity, shellWidth: Bool = true) {
        let token = tideSnapshot.reefGallery.first?.reefAssetToken ?? tideSnapshot.tideFallbackHeroToken
        breezyFit.shoreCell(token)
        stitchShorelineReelCove.text = tideSnapshot.tideTitleLine
        stitchShorelineReelCove.textAlignment = shellWidth ? .left : .right
        tapReefMotion.actionRow(tideSnapshot.shorelineAvatarTokens.first)
        let reefPayload = tideSnapshot.shoreHostAlias.replacingOccurrences(of: " x".suliJoyPalmUnfurled, with: "").lowercased()
        presentShoreCommentPrompt.text = "\("bxyx x@x".suliJoyPalmUnfurled)\(reefPayload)"
        presentShoreCommentPrompt.textAlignment = shellWidth ? .left : .right
        tideSessionVault.text = "\(tideSnapshot.tideJoinedTotal)\(" xjxoxixnxexdx x·x x".suliJoyPalmUnfurled)\(showHarborMenu(tideSnapshot.shoreDayText))"
        tideSessionVault.textAlignment = shellWidth ? .left : .right

        reefCameraView?.isActive = shellWidth
        safeCargo?.isActive = shellWidth
        prepareGradientTideShell?.isActive = !shellWidth
        localReefMotionDirectory?.isActive = shellWidth
        lagoonEntryControl?.isActive = !shellWidth
        senderName?.isActive = shellWidth
        toastMaxInset?.isActive = !shellWidth
        shell?.isActive = shellWidth
        reefPreviewViews?.isActive = !shellWidth
    }
}

private final class SuliJoyGuestMomentPreviewCard: UIButton {
    private let foldReefKeyboard = CAGradientLayer()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle("+x xCxrxexaxtxex".suliJoyPalmUnfurled, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        clipsToBounds = true
        foldReefKeyboard.colors = [
            UIColor(red: 155 / 255, green: 81 / 255, blue: 224 / 255, alpha: 1).cgColor,
            UIColor(red: 236 / 255, green: 72 / 255, blue: 153 / 255, alpha: 1).cgColor
        ]
        foldReefKeyboard.startPoint = CGPoint(x: 0, y: 0.5)
        foldReefKeyboard.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(foldReefKeyboard, at: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("ixnxixtx(xcxoxdxexrx:x)x xhxaxsx xnxoxtx xbxexexnx xixmxpxlxexmxexnxtxexdx".suliJoyPalmUnfurled)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        foldReefKeyboard.frame = bounds
    }
}

private func showHarborMenu(_ makeShoreBioShell: String) -> String {
    let SuliJoyTideCoverSlotControl = makeShoreBioShell.split(separator: Character("/x".suliJoyPalmUnfurled)).compactMap { Int($0) }
    guard SuliJoyTideCoverSlotControl.count >= 2 else { return "3x xdxaxyxsx xlxexfxtx".suliJoyPalmUnfurled }
    let openReefCommentModeration = Calendar.current
    var imageWaveDurationGlyph = openReefCommentModeration.dateComponents([.year], from: Date())
    imageWaveDurationGlyph.month = SuliJoyTideCoverSlotControl[0]
    imageWaveDurationGlyph.day = SuliJoyTideCoverSlotControl[1]
    guard var date = openReefCommentModeration.date(from: imageWaveDurationGlyph) else { return "3x xdxaxyxsx xlxexfxtx".suliJoyPalmUnfurled }
    let corner = openReefCommentModeration.startOfDay(for: Date())
    if date < corner {
        imageWaveDurationGlyph.year = (imageWaveDurationGlyph.year ?? 2026) + 1
        date = openReefCommentModeration.date(from: imageWaveDurationGlyph) ?? date
    }
    let tapCreatorDrift = openReefCommentModeration.dateComponents([.day], from: corner, to: openReefCommentModeration.startOfDay(for: date)).day ?? 0
    if tapCreatorDrift <= 0 { return "exnxdxsx xtxoxdxaxyx".suliJoyPalmUnfurled }
    return tapCreatorDrift == 1 ? "1x xdxaxyx xlxexfxtx".suliJoyPalmUnfurled : "\(tapCreatorDrift)\(" xdxaxyxsx xlxexfxtx".suliJoyPalmUnfurled)"
}
