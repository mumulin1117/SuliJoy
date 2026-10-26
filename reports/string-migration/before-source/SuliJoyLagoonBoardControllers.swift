import UIKit

private enum missingWaveCode {
    static let pageSide: CGFloat = 16
    static let headerTop: CGFloat = 8
    static let shorelineTitle: CGFloat = 44
    static let listBottom: CGFloat = 116
}

private enum SuliJoyReefLaunchEntryCard {
    case listTop
    case startWaveTicker
    case sendShoreBreeze
}

final class makeLagoonBackReefControl: UIView {
    let portraitData = SuliJoyShellGemPillButton(shellWidth: 92, shellHeight: 40)
    let baseLikes = UIButton(type: .custom)
    private var tapSandCancel = false

    fileprivate init(style: SuliJoyReefLaunchEntryCard) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        let tideIndicatorWidth = tideRefresh(style)
        tapSandCancel = true
        let shorelineTitle = missingWaveCode.shorelineTitle
        baseLikes.translatesAutoresizingMaskIntoConstraints = false
        baseLikes.backgroundColor = .white
        baseLikes.layer.cornerRadius = shorelineTitle / 2
        baseLikes.layer.shadowColor = UIColor.black.withAlphaComponent(0.06).cgColor
        baseLikes.layer.shadowOpacity = 1
        baseLikes.layer.shadowRadius = 8
        baseLikes.layer.shadowOffset = CGSize(width: 0, height: 3)
        baseLikes.setImage(UIImage(named: "sulijoy_cove_search_mark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        baseLikes.imageView?.contentMode = .scaleAspectFit
        baseLikes.accessibilityLabel = "Chat"
        addSubview(tideIndicatorWidth)
        addSubview(portraitData)
        addSubview(baseLikes)
        NSLayoutConstraint.activate([
            tideIndicatorWidth.leadingAnchor.constraint(equalTo: leadingAnchor),
            tideIndicatorWidth.centerYAnchor.constraint(equalTo: centerYAnchor),
            tideIndicatorWidth.trailingAnchor.constraint(lessThanOrEqualTo: portraitData.leadingAnchor, constant: -8),
            baseLikes.trailingAnchor.constraint(equalTo: trailingAnchor),
            baseLikes.centerYAnchor.constraint(equalTo: centerYAnchor),
            baseLikes.widthAnchor.constraint(equalToConstant: shorelineTitle),
            baseLikes.heightAnchor.constraint(equalToConstant: shorelineTitle),
            portraitData.trailingAnchor.constraint(equalTo: baseLikes.leadingAnchor, constant: -10),
            portraitData.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard tapSandCancel else { return }
        baseLikes.layer.shadowPath = UIBezierPath(ovalIn: baseLikes.bounds).cgPath
    }

    func aquaGradient() {
        portraitData.setShellGemTally(SuliJoyShellPearlStore.shared.currentPearlBalance())
    }

    private func tideRefresh(_ style: SuliJoyReefLaunchEntryCard) -> UIView {
        switch style {
        case .listTop:
            let logo = UIImageView(image: UIImage(named: "sulijoyHaidao"))
            logo.translatesAutoresizingMaskIntoConstraints = false
            logo.contentMode = .scaleAspectFit
            logo.heightAnchor.constraint(equalToConstant: 44).isActive = true
            logo.widthAnchor.constraint(equalToConstant: 148).isActive = true
            return logo
        case .startWaveTicker:
            let logo = UIImageView(image: UIImage(named: "sulijoy_live_board_title")?.withRenderingMode(.alwaysOriginal))
            logo.translatesAutoresizingMaskIntoConstraints = false
            logo.contentMode = .scaleAspectFit
            logo.heightAnchor.constraint(equalToConstant: 40).isActive = true
            logo.widthAnchor.constraint(equalTo: logo.heightAnchor, multiplier: 348.0 / 80.0).isActive = true
            return logo
        case .sendShoreBreeze:
            return mutedEnvelope(shorelineNextControl: "film.fill", title: "Community")
        }
    }

    private func mutedEnvelope(shorelineNextControl: String, title: String) -> UIView {
        let harvestShorelineReelScene = UIView()
        harvestShorelineReelScene.translatesAutoresizingMaskIntoConstraints = false
        harvestShorelineReelScene.backgroundColor = UIColor.white.withAlphaComponent(0.92)
        harvestShorelineReelScene.layer.cornerRadius = 22
        let icon = UIImageView(image: UIImage(systemName: shorelineNextControl))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = .suliInk
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        label.textColor = .suliInk
        harvestShorelineReelScene.addSubview(icon)
        harvestShorelineReelScene.addSubview(label)
        NSLayoutConstraint.activate([
            harvestShorelineReelScene.heightAnchor.constraint(equalToConstant: 44),
            icon.leadingAnchor.constraint(equalTo: harvestShorelineReelScene.leadingAnchor, constant: 14),
            icon.centerYAnchor.constraint(equalTo: harvestShorelineReelScene.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 18),
            icon.heightAnchor.constraint(equalToConstant: 18),
            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: harvestShorelineReelScene.trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: harvestShorelineReelScene.centerYAnchor)
        ])
        return harvestShorelineReelScene
    }
}

final class resortThemeControls: UIView, UIScrollViewDelegate {
    let scrollView = UIScrollView()
    private(set) var fetchActivityDetail = 0
    var reefDetailController: ((Int) -> Void)?
    var reefText: ((CGFloat) -> Void)?
    private var waveTicker: [UIView] = []
    private var reefTap = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func onLagoonFollowTap(_ waveTicker: [UIView]) {
        self.waveTicker.forEach { $0.removeFromSuperview() }
        self.waveTicker = waveTicker
        waveTicker.forEach { page in
            page.translatesAutoresizingMaskIntoConstraints = true
            page.autoresizingMask = []
            scrollView.addSubview(page)
        }
        setNeedsLayout()
    }

    func coverReefPicks(page index: Int, animated: Bool) {
        let shorelineBubbles = max(0, min(waveTicker.count - 1, index))
        fetchActivityDetail = shorelineBubbles
        let width = bounds.width
        guard width > 0 else { return }
        reefTap = true
        scrollView.setContentOffset(CGPoint(x: width * CGFloat(shorelineBubbles), y: 0), animated: animated)
        if !animated {
            reefTap = false
            reefText?(CGFloat(shorelineBubbles))
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.width
        let loadPublishedTideShelf = bounds.height
        guard width > 1, loadPublishedTideShelf > 1, !waveTicker.isEmpty else { return }
        scrollView.contentSize = CGSize(width: width * CGFloat(waveTicker.count), height: loadPublishedTideShelf)
        for (index, page) in waveTicker.enumerated() {
            page.frame = CGRect(x: width * CGFloat(index), y: 0, width: width, height: loadPublishedTideShelf)
        }
        if !scrollView.isDragging, !scrollView.isDecelerating, !reefTap {
            scrollView.contentOffset = CGPoint(x: width * CGFloat(fetchActivityDetail), y: 0)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = bounds.width
        guard width > 1 else { return }
        let replaceShorelineReel = scrollView.contentOffset.x / width
        reefText?(replaceShorelineReel)
        let portraitImage = max(0, min(waveTicker.count - 1, Int(round(replaceShorelineReel))))
        guard portraitImage != fetchActivityDetail, !reefTap else { return }
        fetchActivityDetail = portraitImage
        reefDetailController?(portraitImage)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        reefCaptionLabel()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate tuneReefCardShell: Bool) {
        if !tuneReefCardShell { reefCaptionLabel() }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        reefTap = false
        reefCaptionLabel()
    }

    private func reefCaptionLabel() {
        let width = bounds.width
        guard width > 1, !waveTicker.isEmpty else { return }
        let portraitImage = max(0, min(waveTicker.count - 1, Int(round(scrollView.contentOffset.x / width))))
        let syncClipReefFollowState = portraitImage != fetchActivityDetail
        fetchActivityDetail = portraitImage
        reefText?(CGFloat(portraitImage))
        if syncClipReefFollowState { reefDetailController?(portraitImage) }
    }
}

final class subreefHeadline: SuliJoyTropicCanvasController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let makeIslandStyleTags = makeLagoonBackReefControl(style: .listTop)
    private let stylistLagoonRow = resortThemeControls()
    private let profileEnvelope: [testerIslander] = [.islandAlias, .anchorReefCinema, .backgroundView]
    private var shoreMailInput: [testerIslander: UIButton] = [:]
    private var pearlGridView: [testerIslander: UIView] = [:]
    private var gemSparkView: [UICollectionView] = []
    private var suliJoyPalmUnfurled: [UILabel] = []
    private var shorelineTile: [makeCurationChoiceRail] = []
    private var coveFollowingTotal: [[shorelineWheel]] = [[], [], []]
    private var nextTideMark: testerIslander = .islandAlias

    override func viewDidLoad() {
        super.viewDidLoad()
        makeIslandStyleTags.portraitData.addTarget(self, action: #selector(openPearlHarbor), for: .touchUpInside)
        makeIslandStyleTags.baseLikes.addTarget(self, action: #selector(openPearlHarborFromShoreDialog), for: .touchUpInside)
        let reefReplyAlert = suliJoyCoastalWeight()
        let islandStylistAvatarAssetName = tapShellHeart()
        nameShellTap()
        [makeIslandStyleTags, reefReplyAlert, islandStylistAvatarAssetName, stylistLagoonRow].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            makeIslandStyleTags.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: missingWaveCode.headerTop),
            makeIslandStyleTags.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: missingWaveCode.pageSide),
            makeIslandStyleTags.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -missingWaveCode.pageSide),
            reefReplyAlert.topAnchor.constraint(equalTo: makeIslandStyleTags.bottomAnchor, constant: 14),
            reefReplyAlert.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            reefReplyAlert.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            reefReplyAlert.heightAnchor.constraint(equalTo: reefReplyAlert.widthAnchor, multiplier: 168.0 / 750.0),
            islandStylistAvatarAssetName.topAnchor.constraint(equalTo: reefReplyAlert.bottomAnchor, constant: 16),
            islandStylistAvatarAssetName.leadingAnchor.constraint(equalTo: makeIslandStyleTags.leadingAnchor),
            islandStylistAvatarAssetName.trailingAnchor.constraint(equalTo: makeIslandStyleTags.trailingAnchor),
            islandStylistAvatarAssetName.heightAnchor.constraint(equalToConstant: 36),
            stylistLagoonRow.topAnchor.constraint(equalTo: islandStylistAvatarAssetName.bottomAnchor, constant: 8),
            stylistLagoonRow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stylistLagoonRow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stylistLagoonRow.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        settlePearlHarbor()
        profileEnvelope.enumerated().forEach { foldDraftKeyboard($0.offset) }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        makeIslandStyleTags.aquaGradient()
    }

    private func nameShellTap() {
        stylistLagoonRow.translatesAutoresizingMaskIntoConstraints = false
        var waveTicker: [UIView] = []
        for index in profileEnvelope.indices {
            let page = UIView()
            let flow = UICollectionViewFlowLayout()
            flow.minimumInteritemSpacing = 12
            flow.minimumLineSpacing = 12
            let shelfWidth = UICollectionView(frame: .zero, collectionViewLayout: flow)
            shelfWidth.translatesAutoresizingMaskIntoConstraints = false
            shelfWidth.backgroundColor = .clear
            shelfWidth.dataSource = self
            shelfWidth.delegate = self
            shelfWidth.tag = index
            shelfWidth.alwaysBounceVertical = true
            shelfWidth.contentInset = UIEdgeInsets(top: 4, left: 16, bottom: missingWaveCode.listBottom, right: 16)
            shelfWidth.register(discoverDrop.self, forCellWithReuseIdentifier: "SuliJoyLagoonVoiceTileCell")
            let reefEntryStack = UIRefreshControl()
            reefEntryStack.tag = index
            reefEntryStack.addTarget(self, action: #selector(makeLagoonEntryShell(_:)), for: .valueChanged)
            shelfWidth.refreshControl = reefEntryStack

            let emptyNote = UILabel()
            emptyNote.translatesAutoresizingMaskIntoConstraints = false
            emptyNote.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            emptyNote.textColor = .suliMutedInk
            emptyNote.textAlignment = .center
            emptyNote.numberOfLines = 0
            emptyNote.isHidden = true

            let shoreTimeGlyph = makeCurationChoiceRail()

            page.addSubview(shelfWidth)
            page.addSubview(emptyNote)
            page.addSubview(shoreTimeGlyph)
            NSLayoutConstraint.activate([
                shelfWidth.topAnchor.constraint(equalTo: page.topAnchor),
                shelfWidth.leadingAnchor.constraint(equalTo: page.leadingAnchor),
                shelfWidth.trailingAnchor.constraint(equalTo: page.trailingAnchor),
                shelfWidth.bottomAnchor.constraint(equalTo: page.bottomAnchor),
                emptyNote.centerXAnchor.constraint(equalTo: page.centerXAnchor),
                emptyNote.centerYAnchor.constraint(equalTo: page.centerYAnchor),
                emptyNote.leadingAnchor.constraint(equalTo: page.leadingAnchor, constant: 32),
                emptyNote.trailingAnchor.constraint(equalTo: page.trailingAnchor, constant: -32),
                shoreTimeGlyph.topAnchor.constraint(equalTo: page.topAnchor, constant: 4),
                shoreTimeGlyph.leadingAnchor.constraint(equalTo: page.leadingAnchor, constant: 16),
                shoreTimeGlyph.trailingAnchor.constraint(equalTo: page.trailingAnchor, constant: -16)
            ])
            gemSparkView.append(shelfWidth)
            suliJoyPalmUnfurled.append(emptyNote)
            shorelineTile.append(shoreTimeGlyph)
            waveTicker.append(page)
        }
        stylistLagoonRow.onLagoonFollowTap(waveTicker)
        stylistLagoonRow.reefDetailController = { [weak self] index in
            guard let self else { return }
            self.nextTideMark = self.profileEnvelope[index]
            self.settlePearlHarbor()
        }
    }

    private func suliJoyCoastalWeight() -> UIControl {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .clear
        card.addTarget(self, action: #selector(nameGlyphTop), for: .touchUpInside)
        card.accessibilityLabel = "Create a look. Pass it on."
        card.isAccessibilityElement = true

        let reefToken = UIImageView(image: UIImage(named: "sulijoy_home_activity_entry"))
        reefToken.translatesAutoresizingMaskIntoConstraints = false
        reefToken.contentMode = .scaleAspectFit
        reefToken.isUserInteractionEnabled = false
        card.addSubview(reefToken)
        NSLayoutConstraint.activate([
            reefToken.topAnchor.constraint(equalTo: card.topAnchor),
            reefToken.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            reefToken.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            reefToken.bottomAnchor.constraint(equalTo: card.bottomAnchor)
        ])
        return card
    }

    private func tapShellHeart() -> UIView {
        let row = UIStackView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.distribution = .fillEqually
        let profileEnvelope: [(testerIslander, String)] = [
            (.islandAlias, "Island Vibes"),
            (.anchorReefCinema, "Style Talk"),
            (.backgroundView, "Meet & Mingle")
        ]
        for item in profileEnvelope {
            let clipPortraitToken = UIStackView()
            clipPortraitToken.axis = .vertical
            clipPortraitToken.alignment = .center
            clipPortraitToken.spacing = 4
            let button = UIButton(type: .system)
            button.setTitle(item.1, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.7
            button.tag = delta(item.0)
            button.addTarget(self, action: #selector(profileReefHeight(_:)), for: .touchUpInside)
            let tideIndicatorWidth = SuliJoyGradientCapsuleView(colors: [
                UIColor(red: 1, green: 0.45, blue: 0.28, alpha: 1),
                UIColor(red: 1, green: 0.92, blue: 0.28, alpha: 1),
                UIColor(red: 0.45, green: 0.95, blue: 0.45, alpha: 1)
            ])
            tideIndicatorWidth.translatesAutoresizingMaskIntoConstraints = false
            clipPortraitToken.addArrangedSubview(button)
            clipPortraitToken.addArrangedSubview(tideIndicatorWidth)
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 24),
                tideIndicatorWidth.widthAnchor.constraint(equalToConstant: 28),
                tideIndicatorWidth.heightAnchor.constraint(equalToConstant: 5)
            ])
            row.addArrangedSubview(clipPortraitToken)
            shoreMailInput[item.0] = button
            pearlGridView[item.0] = tideIndicatorWidth
        }
        return row
    }

    private func delta(_ nextTideMark: testerIslander) -> Int {
        switch nextTideMark {
        case .islandAlias: return 0
        case .anchorReefCinema: return 1
        case .backgroundView: return 2
        }
    }

    private func gridTop(_ rendered: Int) -> testerIslander {
        switch rendered {
        case 1: return .anchorReefCinema
        case 2: return .backgroundView
        default: return .islandAlias
        }
    }

    private func settlePearlHarbor() {
        for item in shoreMailInput {
            let reefPack = item.key == nextTideMark
            item.value.setTitleColor(reefPack ? .suliInk : .suliMutedInk, for: .normal)
            pearlGridView[item.key]?.alpha = reefPack ? 1 : 0
        }
    }

    @objc private func profileReefHeight(_ sender: UIButton) {
        let stitchPearlHarborScene = gridTop(sender.tag)
        guard stitchPearlHarborScene != nextTideMark else { return }
        nextTideMark = stitchPearlHarborScene
        settlePearlHarbor()
        stylistLagoonRow.coverReefPicks(page: sender.tag, animated: true)
    }

    @objc private func makeLagoonEntryShell(_ sender: UIRefreshControl) {
        foldDraftKeyboard(sender.tag)
    }

    private func foldDraftKeyboard(_ index: Int) {
        guard profileEnvelope.indices.contains(index) else { return }
        let islandTabRoot = profileEnvelope[index]
        if coveFollowingTotal[index].isEmpty {
            shorelineTile[index].weaveShellCovePage(true)
            suliJoyPalmUnfurled[index].isHidden = true
        }
        suliJoyPalmRankingaccount.shared.shoreMailMark(nextTideMark: islandTabRoot) { [weak self] result in
            guard let self else { return }
            self.shorelineTile[index].weaveShellCovePage(false)
            self.gemSparkView[index].refreshControl?.endRefreshing()
            guard result.beachwearCapsule == 200 else {
                self.coveFollowingTotal[index] = []
                self.gemSparkView[index].reloadData()
                self.suliJoyPalmUnfurled[index].text = result.coastalWardrobe
                self.suliJoyPalmUnfurled[index].isHidden = false
                if self.stylistLagoonRow.fetchActivityDetail == index {
                    self.showLagoonToast(result.coastalWardrobe)
                }
                return
            }
            self.coveFollowingTotal[index] = result.sandbarLayering ?? []
            self.gemSparkView[index].reloadData()
            self.suliJoyPalmUnfurled[index].text = "No voice rooms right now."
            self.suliJoyPalmUnfurled[index].isHidden = !self.coveFollowingTotal[index].isEmpty
        }
    }

    @objc private func openPearlHarbor() {
        tallyStack(SuliJoyPearlHarborViewController())
    }

    @objc private func openPearlHarborFromShoreDialog() {
        openSuliJoyLagoonLetters()
    }

    @objc private func nameGlyphTop() {
        tallyStack(SuliJoyForinController())
    }

    private func tallyStack(_ page: UIViewController) {
        page.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(page, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        coveFollowingTotal[collectionView.tag].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuliJoyLagoonVoiceTileCell", for: indexPath) as! discoverDrop
        cell.suliJoyCoastalState(coveFollowingTotal[collectionView.tag][indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout harborPrimaryControl: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right - 12) / 2)
        return CGSize(width: max(width, 120), height: max(width, 120) * 1.28)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let completeLagoonExit = coveFollowingTotal[collectionView.tag][indexPath.item]
        sunlit.coveSection(kind: .raiseReefCommentFlag, abaloneTone: completeLagoonExit.abaloneTone, from: self)
    }
}

final class gatherReefLaunchCrown: SuliJoyTropicCanvasController, UITableViewDataSource, UITableViewDelegate {
    private enum headlineTop {
        case ringPath
        case suliJoyShellClipPublished
        case bottomInset
    }

    private let makeIslandStyleTags = makeLagoonBackReefControl(style: .startWaveTicker)
    private let stylistLagoonRow = resortThemeControls()
    private let preferredStyle = UIStackView()
    private var installReefMotionTap: [String: UILabel] = [:]
    private var reefEmptyLabel: [headlineTop: UIButton] = [:]
    private var growLagoonClauseCopy: [headlineTop: UIView] = [:]
    private var returnToIslandCove: [UITableView] = []
    private var tuneHarborHintLabel: [UILabel] = []
    private var tideConfirmButton: [LagoonLetterMeasure] = []
    private let heroPanel: [headlineTop] = [.ringPath, .suliJoyShellClipPublished, .bottomInset]
    private var harborScene: [coverImageView] = []
    private var prepareShellGemPillShell: headlineTop = .ringPath
    private let ShoreMomentCellMetric = ["Chill & Chat", "Style & Beauty", "Lifestyle"]

    override func viewDidLoad() {
        super.viewDidLoad()
        makeIslandStyleTags.portraitData.addTarget(self, action: #selector(openPearlHarbor), for: .touchUpInside)
        makeIslandStyleTags.baseLikes.addTarget(self, action: #selector(openPearlHarborFromShoreDialog), for: .touchUpInside)
        lagoonSeatCursor()
        let pearlBalanceButton = harborMoreControl()
        changeFilter()
        [makeIslandStyleTags, preferredStyle, pearlBalanceButton, stylistLagoonRow].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            makeIslandStyleTags.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: missingWaveCode.headerTop),
            makeIslandStyleTags.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: missingWaveCode.pageSide),
            makeIslandStyleTags.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -missingWaveCode.pageSide),
            preferredStyle.topAnchor.constraint(equalTo: makeIslandStyleTags.bottomAnchor, constant: 14),
            preferredStyle.leadingAnchor.constraint(equalTo: makeIslandStyleTags.leadingAnchor),
            preferredStyle.trailingAnchor.constraint(equalTo: makeIslandStyleTags.trailingAnchor),
            pearlBalanceButton.topAnchor.constraint(equalTo: preferredStyle.bottomAnchor, constant: 16),
            pearlBalanceButton.leadingAnchor.constraint(equalTo: makeIslandStyleTags.leadingAnchor),
            pearlBalanceButton.trailingAnchor.constraint(equalTo: makeIslandStyleTags.trailingAnchor),
            pearlBalanceButton.heightAnchor.constraint(equalToConstant: 34),
            stylistLagoonRow.topAnchor.constraint(equalTo: pearlBalanceButton.bottomAnchor, constant: 8),
            stylistLagoonRow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stylistLagoonRow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stylistLagoonRow.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        forgeCoralRemovalAction()
        shoreInputDock()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        makeIslandStyleTags.aquaGradient()
    }

    private func lagoonSeatCursor() {
        preferredStyle.translatesAutoresizingMaskIntoConstraints = false
        preferredStyle.axis = .horizontal
        preferredStyle.spacing = 12
        preferredStyle.distribution = .fillEqually
        let reefControl = [
            "sulijoy_live_category_chill",
            "sulijoy_live_category_style",
            "sulijoy_live_category_lifestyle"
        ]
        for (index, name) in ShoreMomentCellMetric.enumerated() {
            let lagoonSeatMarkbighcard = UIControl()
            lagoonSeatMarkbighcard.translatesAutoresizingMaskIntoConstraints = false
            lagoonSeatMarkbighcard.layer.cornerRadius = 18
            lagoonSeatMarkbighcard.clipsToBounds = true
            lagoonSeatMarkbighcard.tag = index
            lagoonSeatMarkbighcard.addTarget(self, action: #selector(refreshConsentRibbonBinding(_:)), for: .touchUpInside)

            let reefToken = UIImageView(image: UIImage(named: reefControl[index])?.withRenderingMode(.alwaysOriginal))
            reefToken.translatesAutoresizingMaskIntoConstraints = false
            reefToken.contentMode = .scaleAspectFill
            reefToken.isUserInteractionEnabled = false

            let lagoonSeatMarkbigh = UILabel()
            lagoonSeatMarkbigh.translatesAutoresizingMaskIntoConstraints = false
            lagoonSeatMarkbigh.text = name
            lagoonSeatMarkbigh.font = UIFont.systemFont(ofSize: 13, weight: .black)
            lagoonSeatMarkbigh.textColor = .white
            lagoonSeatMarkbigh.numberOfLines = 2

            let tuneMomentDetailInput = UIView()
            tuneMomentDetailInput.translatesAutoresizingMaskIntoConstraints = false
            tuneMomentDetailInput.backgroundColor = UIColor.white.withAlphaComponent(0.28)
            tuneMomentDetailInput.layer.cornerRadius = 9
            tuneMomentDetailInput.clipsToBounds = true
            tuneMomentDetailInput.isUserInteractionEnabled = false

            let shorelineClip = UIImageView(image: UIImage(systemName: "waveform"))
            shorelineClip.translatesAutoresizingMaskIntoConstraints = false
            shorelineClip.tintColor = .white
            shorelineClip.contentMode = .scaleAspectFit

            let lagoonSeatMarkbighcount = UILabel()
            lagoonSeatMarkbighcount.translatesAutoresizingMaskIntoConstraints = false
            lagoonSeatMarkbighcount.text = "0"
            lagoonSeatMarkbighcount.font = UIFont.systemFont(ofSize: 11, weight: .bold)
            lagoonSeatMarkbighcount.textColor = .white

            lagoonSeatMarkbighcard.addSubview(reefToken)
            lagoonSeatMarkbighcard.addSubview(lagoonSeatMarkbigh)
            lagoonSeatMarkbighcard.addSubview(tuneMomentDetailInput)
            tuneMomentDetailInput.addSubview(shorelineClip)
            tuneMomentDetailInput.addSubview(lagoonSeatMarkbighcount)
            NSLayoutConstraint.activate([
                reefToken.topAnchor.constraint(equalTo: lagoonSeatMarkbighcard.topAnchor),
                reefToken.leadingAnchor.constraint(equalTo: lagoonSeatMarkbighcard.leadingAnchor),
                reefToken.trailingAnchor.constraint(equalTo: lagoonSeatMarkbighcard.trailingAnchor),
                reefToken.bottomAnchor.constraint(equalTo: lagoonSeatMarkbighcard.bottomAnchor),
                lagoonSeatMarkbighcard.heightAnchor.constraint(equalTo: lagoonSeatMarkbighcard.widthAnchor, multiplier: 164.0 / 222.0),
                lagoonSeatMarkbigh.topAnchor.constraint(equalTo: lagoonSeatMarkbighcard.topAnchor, constant: 10),
                lagoonSeatMarkbigh.leadingAnchor.constraint(equalTo: lagoonSeatMarkbighcard.leadingAnchor, constant: 10),
                lagoonSeatMarkbigh.trailingAnchor.constraint(equalTo: lagoonSeatMarkbighcard.trailingAnchor, constant: -6),
                tuneMomentDetailInput.leadingAnchor.constraint(equalTo: lagoonSeatMarkbigh.leadingAnchor),
                tuneMomentDetailInput.topAnchor.constraint(equalTo: lagoonSeatMarkbigh.bottomAnchor, constant: 6),
                tuneMomentDetailInput.heightAnchor.constraint(equalToConstant: 18),
                shorelineClip.leadingAnchor.constraint(equalTo: tuneMomentDetailInput.leadingAnchor, constant: 6),
                shorelineClip.centerYAnchor.constraint(equalTo: tuneMomentDetailInput.centerYAnchor),
                shorelineClip.widthAnchor.constraint(equalToConstant: 12),
                shorelineClip.heightAnchor.constraint(equalToConstant: 10),
                lagoonSeatMarkbighcount.leadingAnchor.constraint(equalTo: shorelineClip.trailingAnchor, constant: 3),
                lagoonSeatMarkbighcount.trailingAnchor.constraint(equalTo: tuneMomentDetailInput.trailingAnchor, constant: -6),
                lagoonSeatMarkbighcount.centerYAnchor.constraint(equalTo: tuneMomentDetailInput.centerYAnchor)
            ])
            preferredStyle.addArrangedSubview(lagoonSeatMarkbighcard)
            installReefMotionTap[name] = lagoonSeatMarkbighcount
        }
    }

    private func harborMoreControl() -> UIView {
        let row = UIStackView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.distribution = .fillEqually
        let heroPanel: [(headlineTop, String)] = [(.ringPath, "For You"), (.suliJoyShellClipPublished, "Following"), (.bottomInset, "Trending")]
        for item in heroPanel {
            let clipPortraitToken = UIStackView()
            clipPortraitToken.axis = .vertical
            clipPortraitToken.alignment = .center
            clipPortraitToken.spacing = 3
            let button = UIButton(type: .system)
            button.setTitle(item.1, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
            button.addTarget(self, action: #selector(shelfIndex(_:)), for: .touchUpInside)
            button.tag = item.0 == .ringPath ? 0 : item.0 == .suliJoyShellClipPublished ? 1 : 2
            let tideIndicatorWidth = SuliJoyGradientCapsuleView(colors: [
                UIColor(red: 1, green: 0.45, blue: 0.28, alpha: 1),
                UIColor(red: 0.55, green: 0.95, blue: 0.4, alpha: 1)
            ])
            tideIndicatorWidth.translatesAutoresizingMaskIntoConstraints = false
            clipPortraitToken.addArrangedSubview(button)
            clipPortraitToken.addArrangedSubview(tideIndicatorWidth)
            NSLayoutConstraint.activate([
                tideIndicatorWidth.widthAnchor.constraint(equalToConstant: 26),
                tideIndicatorWidth.heightAnchor.constraint(equalToConstant: 5)
            ])
            row.addArrangedSubview(clipPortraitToken)
            reefEmptyLabel[item.0] = button
            growLagoonClauseCopy[item.0] = tideIndicatorWidth
        }
        return row
    }

    private func forgeCoralRemovalAction() {
        for item in reefEmptyLabel {
            item.value.setTitleColor(item.key == prepareShellGemPillShell ? .suliInk : .suliMutedInk, for: .normal)
            growLagoonClauseCopy[item.key]?.alpha = item.key == prepareShellGemPillShell ? 1 : 0
        }
    }

    private func isShoreScrollItemVisible(for prepareShellGemPillShell: headlineTop) -> [coverImageView] {
        switch prepareShellGemPillShell {
        case .ringPath:
            return harborScene
        case .suliJoyShellClipPublished:
            return harborScene.filter(\.presentSuliJoyHarborGuardMenu)
        case .bottomInset:
            return harborScene.sorted { $0.applyLagoonSummary > $1.applyLagoonSummary }
        }
    }

    @objc private func refreshConsentRibbonBinding(_ sender: UIControl) {
        let name = ShoreMomentCellMetric[sender.tag]
        let page = markShellSide(title: name, reefStackFloor: harborScene)
        page.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(page, animated: true)
    }

    @objc private func shelfIndex(_ sender: UIButton) {
        let stitchPearlHarborScene = heroPanel[sender.tag]
        guard stitchPearlHarborScene != prepareShellGemPillShell else { return }
        prepareShellGemPillShell = stitchPearlHarborScene
        forgeCoralRemovalAction()
        stylistLagoonRow.coverReefPicks(page: sender.tag, animated: true)
    }

    private func changeFilter() {
        stylistLagoonRow.translatesAutoresizingMaskIntoConstraints = false
        var waveTicker: [UIView] = []
        for index in heroPanel.indices {
            let page = UIView()
            let commitReadyIslandExit = UITableView(frame: .zero, style: .plain)
            commitReadyIslandExit.translatesAutoresizingMaskIntoConstraints = false
            commitReadyIslandExit.backgroundColor = .clear
            commitReadyIslandExit.separatorStyle = .none
            commitReadyIslandExit.dataSource = self
            commitReadyIslandExit.delegate = self
            commitReadyIslandExit.tag = index
            commitReadyIslandExit.rowHeight = 118
            commitReadyIslandExit.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: missingWaveCode.listBottom, right: 0)
            commitReadyIslandExit.register(titleInput.self, forCellReuseIdentifier: "SuliJoyLagoonLiveRowCell")
            let reefEntryStack = UIRefreshControl()
            reefEntryStack.addTarget(self, action: #selector(shoreInputDock), for: .valueChanged)
            commitReadyIslandExit.refreshControl = reefEntryStack

            let emptyNote = UILabel()
            emptyNote.translatesAutoresizingMaskIntoConstraints = false
            emptyNote.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            emptyNote.textColor = .suliMutedInk
            emptyNote.textAlignment = .center
            emptyNote.numberOfLines = 0
            emptyNote.isHidden = true

            let shoreTimeGlyph = LagoonLetterMeasure()

            page.addSubview(commitReadyIslandExit)
            page.addSubview(emptyNote)
            page.addSubview(shoreTimeGlyph)
            NSLayoutConstraint.activate([
                commitReadyIslandExit.topAnchor.constraint(equalTo: page.topAnchor),
                commitReadyIslandExit.leadingAnchor.constraint(equalTo: page.leadingAnchor),
                commitReadyIslandExit.trailingAnchor.constraint(equalTo: page.trailingAnchor),
                commitReadyIslandExit.bottomAnchor.constraint(equalTo: page.bottomAnchor),
                emptyNote.centerXAnchor.constraint(equalTo: page.centerXAnchor),
                emptyNote.topAnchor.constraint(equalTo: page.topAnchor, constant: 36),
                emptyNote.leadingAnchor.constraint(equalTo: page.leadingAnchor, constant: 32),
                emptyNote.trailingAnchor.constraint(equalTo: page.trailingAnchor, constant: -32),
                shoreTimeGlyph.topAnchor.constraint(equalTo: page.topAnchor, constant: 4),
                shoreTimeGlyph.leadingAnchor.constraint(equalTo: page.leadingAnchor, constant: 16),
                shoreTimeGlyph.trailingAnchor.constraint(equalTo: page.trailingAnchor, constant: -16)
            ])
            returnToIslandCove.append(commitReadyIslandExit)
            tuneHarborHintLabel.append(emptyNote)
            tideConfirmButton.append(shoreTimeGlyph)
            waveTicker.append(page)
        }
        stylistLagoonRow.onLagoonFollowTap(waveTicker)
        stylistLagoonRow.reefDetailController = { [weak self] index in
            guard let self else { return }
            self.prepareShellGemPillShell = self.heroPanel[index]
            self.forgeCoralRemovalAction()
        }
    }

    @objc private func shoreInputDock() {
        if harborScene.isEmpty {
            tideConfirmButton.forEach { $0.weaveShellCovePage(true) }
            tuneHarborHintLabel.forEach { $0.isHidden = true }
        }
        suliJoyPalmRankingaccount.shared.makeIslandAccount { [weak self] result in
            guard let self else { return }
            self.tideConfirmButton.forEach { $0.weaveShellCovePage(false) }
            self.returnToIslandCove.forEach { $0.refreshControl?.endRefreshing() }
            guard result.beachwearCapsule == 200, let activeCoveSection = result.sandbarLayering else {
                self.harborScene = []
                self.returnToIslandCove.forEach { $0.reloadData() }
                self.makeResortVerticalStack(tideJoined: result.coastalWardrobe)
                self.showLagoonToast(result.coastalWardrobe)
                return
            }
            self.harborScene = activeCoveSection.isShoreScrollItemVisible
            let gradient = "\(activeCoveSection.isFollowingAuthor)"
            self.installReefMotionTap.values.forEach { $0.text = gradient }
            self.returnToIslandCove.forEach { $0.reloadData() }
            self.makeResortVerticalStack(tideJoined: "No live rooms right now.")
        }
    }

    private func makeResortVerticalStack(tideJoined: String) {
        for (index, note) in tuneHarborHintLabel.enumerated() {
            let isShoreScrollItemVisible = isShoreScrollItemVisible(for: heroPanel[index])
            note.text = tideJoined
            note.isHidden = !isShoreScrollItemVisible.isEmpty
        }
    }

    @objc private func openPearlHarbor() {
        let page = SuliJoyPearlHarborViewController()
        page.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(page, animated: true)
    }

    @objc private func openPearlHarborFromShoreDialog() {
        openSuliJoyLagoonLetters()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isShoreScrollItemVisible(for: heroPanel[tableView.tag]).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuliJoyLagoonLiveRowCell", for: indexPath) as! titleInput
        cell.backLead(isShoreScrollItemVisible(for: heroPanel[tableView.tag])[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let completeLagoonExit = isShoreScrollItemVisible(for: heroPanel[tableView.tag])[indexPath.row]
        sunlit.coveSection(kind: .moorShoreProfileReefScene, abaloneTone: completeLagoonExit.abaloneTone, from: self)
    }
}

final class markShellSide: SuliJoyTropicCanvasController, UITableViewDataSource, UITableViewDelegate {
    private let stylistTile: String
    private let reefStackFloor: [coverImageView]
    private let coastalChic = UITableView(frame: .zero, style: .plain)
    private let emptyNote = UILabel()
    private var harborScene: [coverImageView] = []

    init(title: String, reefStackFloor: [coverImageView]) {
        stylistTile = title
        self.reefStackFloor = reefStackFloor
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let header = suliJoyReefAssetOrSandPath()
        reefPhotoPicks()
        titleGlyph()
        [header, coastalChic, emptyNote].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            header.heightAnchor.constraint(equalToConstant: 44),
            coastalChic.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12),
            coastalChic.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coastalChic.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coastalChic.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyNote.centerXAnchor.constraint(equalTo: coastalChic.centerXAnchor),
            emptyNote.topAnchor.constraint(equalTo: coastalChic.topAnchor, constant: 36),
            emptyNote.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyNote.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        sunControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    private func suliJoyReefAssetOrSandPath() -> UIView {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        let presentShorePortraitPicker = UIButton(type: .system)
        presentShorePortraitPicker.translatesAutoresizingMaskIntoConstraints = false
        presentShorePortraitPicker.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        presentShorePortraitPicker.tintColor = .suliInk
        presentShorePortraitPicker.addTarget(self, action: #selector(flipLagoonConsent), for: .touchUpInside)
        let lagoonSeatMarkbighf = UILabel()
        lagoonSeatMarkbighf.translatesAutoresizingMaskIntoConstraints = false
        lagoonSeatMarkbighf.text = stylistTile
        lagoonSeatMarkbighf.font = UIFont.systemFont(ofSize: 22, weight: .black)
        lagoonSeatMarkbighf.textColor = .suliInk
        lagoonSeatMarkbighf.textAlignment = .center
        lagoonSeatMarkbighf.adjustsFontSizeToFitWidth = true
        lagoonSeatMarkbighf.minimumScaleFactor = 0.7
        header.addSubview(presentShorePortraitPicker)
        header.addSubview(lagoonSeatMarkbighf)
        NSLayoutConstraint.activate([
            presentShorePortraitPicker.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            presentShorePortraitPicker.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            presentShorePortraitPicker.widthAnchor.constraint(equalToConstant: 44),
            presentShorePortraitPicker.heightAnchor.constraint(equalToConstant: 44),
            lagoonSeatMarkbighf.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            lagoonSeatMarkbighf.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            lagoonSeatMarkbighf.leadingAnchor.constraint(greaterThanOrEqualTo: presentShorePortraitPicker.trailingAnchor, constant: 12),
            lagoonSeatMarkbighf.trailingAnchor.constraint(lessThanOrEqualTo: header.trailingAnchor, constant: -56)
        ])
        return header
    }

    private func reefPhotoPicks() {
        coastalChic.translatesAutoresizingMaskIntoConstraints = false
        coastalChic.backgroundColor = .clear
        coastalChic.separatorStyle = .none
        coastalChic.dataSource = self
        coastalChic.delegate = self
        coastalChic.rowHeight = 118
        coastalChic.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 28, right: 0)
        coastalChic.register(titleInput.self, forCellReuseIdentifier: "SuliJoyLagoonLiveRowCell")
        let reefEntryStack = UIRefreshControl()
        reefEntryStack.addTarget(self, action: #selector(sunControl), for: .valueChanged)
        coastalChic.refreshControl = reefEntryStack
    }

    private func titleGlyph() {
        emptyNote.translatesAutoresizingMaskIntoConstraints = false
        emptyNote.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        emptyNote.textColor = .suliMutedInk
        emptyNote.textAlignment = .center
        emptyNote.numberOfLines = 0
        emptyNote.isHidden = true
    }

    @objc private func sunControl() {
        harborScene = Array(reefStackFloor.shuffled().prefix(3))
        coastalChic.reloadData()
        coastalChic.refreshControl?.endRefreshing()
        emptyNote.text = "No live rooms right now."
        emptyNote.isHidden = !harborScene.isEmpty
    }

    @objc private func flipLagoonConsent() {
        navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        harborScene.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuliJoyLagoonLiveRowCell", for: indexPath) as! titleInput
        cell.backLead(harborScene[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let completeLagoonExit = harborScene[indexPath.row]
        sunlit.coveSection(kind: .moorShoreProfileReefScene, abaloneTone: completeLagoonExit.abaloneTone, from: self)
    }
}

final class reefPass: SuliJoyTropicCanvasController {
    private let makeIslandStyleTags = makeLagoonBackReefControl(style: .sendShoreBreeze)
    private let originalReefTabMark = UIButton(type: .system)
    private let reefTransaction = UIButton(type: .system)
    private let refreshCoveTable = SuliJoyGradientCapsuleView(colors: [
        UIColor(red: 1, green: 0.72, blue: 0.35, alpha: 1),
        UIColor(red: 0.72, green: 0.95, blue: 0.45, alpha: 1)
    ])
    private let visitor = SuliJoyShoortController()
    private let breezyLeftLook = suliJoyShorelineIntent()
    private let stylistLagoonRow = resortThemeControls()
    private var bindLagoonConsentRibbon = true
    private var shoreTextCard: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        makeIslandStyleTags.portraitData.addTarget(self, action: #selector(openPearlHarbor), for: .touchUpInside)
        makeIslandStyleTags.baseLikes.addTarget(self, action: #selector(openPearlHarborFromShoreDialog), for: .touchUpInside)
        let badgeName = crownHarbor()
        stylistLagoonRow.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(makeIslandStyleTags)
        view.addSubview(badgeName)
        view.addSubview(stylistLagoonRow)
        NSLayoutConstraint.activate([
            makeIslandStyleTags.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: missingWaveCode.headerTop),
            makeIslandStyleTags.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: missingWaveCode.pageSide),
            makeIslandStyleTags.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -missingWaveCode.pageSide),
            badgeName.topAnchor.constraint(equalTo: makeIslandStyleTags.bottomAnchor, constant: 12),
            badgeName.leadingAnchor.constraint(equalTo: makeIslandStyleTags.leadingAnchor),
            badgeName.trailingAnchor.constraint(equalTo: makeIslandStyleTags.trailingAnchor),
            badgeName.heightAnchor.constraint(equalToConstant: 48),
            stylistLagoonRow.topAnchor.constraint(equalTo: badgeName.bottomAnchor, constant: 6),
            stylistLagoonRow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stylistLagoonRow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stylistLagoonRow.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        visitor.reefConsentJoinNote = true
        breezyLeftLook.actionTop = true
        let tideActivities = UIView()
        let toggleReefClipMotion = UIView()
        ReefTabCoveBlueprint(visitor, in: tideActivities)
        ReefTabCoveBlueprint(breezyLeftLook, in: toggleReefClipMotion)
        stylistLagoonRow.onLagoonFollowTap([tideActivities, toggleReefClipMotion])
        stylistLagoonRow.reefDetailController = { [weak self] index in
            self?.bindLagoonConsentRibbon = index == 0
            self?.reefStem()
        }
        stylistLagoonRow.reefText = { [weak self] replaceShorelineReel in
            self?.gatherPearlShelves(replaceShorelineReel: replaceShorelineReel)
        }
        reefStem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        makeIslandStyleTags.aquaGradient()
    }

    private func crownHarbor() -> UIView {
        let openSavedIslandAccount = UIView()
        openSavedIslandAccount.translatesAutoresizingMaskIntoConstraints = false
        openSavedIslandAccount.backgroundColor = UIColor.white.withAlphaComponent(0.92)
        openSavedIslandAccount.layer.cornerRadius = 24
        refreshCoveTable.translatesAutoresizingMaskIntoConstraints = false
        originalReefTabMark.translatesAutoresizingMaskIntoConstraints = false
        reefTransaction.translatesAutoresizingMaskIntoConstraints = false
        originalReefTabMark.setTitle("Post", for: .normal)
        reefTransaction.setTitle("Shorts", for: .normal)
        originalReefTabMark.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        reefTransaction.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        originalReefTabMark.addTarget(self, action: #selector(coverPicker), for: .touchUpInside)
        reefTransaction.addTarget(self, action: #selector(arrangeIslandArrivalScene), for: .touchUpInside)
        openSavedIslandAccount.addSubview(refreshCoveTable)
        openSavedIslandAccount.addSubview(originalReefTabMark)
        openSavedIslandAccount.addSubview(reefTransaction)
        shoreTextCard = refreshCoveTable.leadingAnchor.constraint(equalTo: openSavedIslandAccount.leadingAnchor, constant: 4)
        NSLayoutConstraint.activate([
            shoreTextCard!,
            refreshCoveTable.centerYAnchor.constraint(equalTo: openSavedIslandAccount.centerYAnchor),
            refreshCoveTable.heightAnchor.constraint(equalToConstant: 40),
            refreshCoveTable.widthAnchor.constraint(equalTo: openSavedIslandAccount.widthAnchor, multiplier: 0.5, constant: -6),
            originalReefTabMark.leadingAnchor.constraint(equalTo: openSavedIslandAccount.leadingAnchor),
            originalReefTabMark.topAnchor.constraint(equalTo: openSavedIslandAccount.topAnchor),
            originalReefTabMark.bottomAnchor.constraint(equalTo: openSavedIslandAccount.bottomAnchor),
            originalReefTabMark.widthAnchor.constraint(equalTo: openSavedIslandAccount.widthAnchor, multiplier: 0.5),
            reefTransaction.trailingAnchor.constraint(equalTo: openSavedIslandAccount.trailingAnchor),
            reefTransaction.topAnchor.constraint(equalTo: openSavedIslandAccount.topAnchor),
            reefTransaction.bottomAnchor.constraint(equalTo: openSavedIslandAccount.bottomAnchor),
            reefTransaction.widthAnchor.constraint(equalTo: openSavedIslandAccount.widthAnchor, multiplier: 0.5)
        ])
        return openSavedIslandAccount
    }

    private func ReefTabCoveBlueprint(_ pulseWaveNow: UIViewController, in shouldStartResonance: UIView) {
        addChild(pulseWaveNow)
        pulseWaveNow.view.translatesAutoresizingMaskIntoConstraints = false
        shouldStartResonance.addSubview(pulseWaveNow.view)
        NSLayoutConstraint.activate([
            pulseWaveNow.view.topAnchor.constraint(equalTo: shouldStartResonance.topAnchor),
            pulseWaveNow.view.leadingAnchor.constraint(equalTo: shouldStartResonance.leadingAnchor),
            pulseWaveNow.view.trailingAnchor.constraint(equalTo: shouldStartResonance.trailingAnchor),
            pulseWaveNow.view.bottomAnchor.constraint(equalTo: shouldStartResonance.bottomAnchor)
        ])
        pulseWaveNow.didMove(toParent: self)
    }

    private func reefStem() {
        originalReefTabMark.setTitleColor(bindLagoonConsentRibbon ? .suliInk : .suliMutedInk, for: .normal)
        reefTransaction.setTitleColor(bindLagoonConsentRibbon ? .suliMutedInk : .suliInk, for: .normal)
    }

    private func gatherPearlShelves(replaceShorelineReel: CGFloat) {
        let width = originalReefTabMark.superview?.bounds.width ?? 0
        let onReefIssue = max(width / 2 - 4, 0)
        shoreTextCard?.constant = 4 + min(max(replaceShorelineReel, 0), 1) * onReefIssue
        originalReefTabMark.superview?.layoutIfNeeded()
    }

    @objc private func coverPicker() {
        guard !bindLagoonConsentRibbon else { return }
        bindLagoonConsentRibbon = true
        reefStem()
        stylistLagoonRow.coverReefPicks(page: 0, animated: true)
    }

    @objc private func arrangeIslandArrivalScene() {
        guard bindLagoonConsentRibbon else { return }
        bindLagoonConsentRibbon = false
        reefStem()
        stylistLagoonRow.coverReefPicks(page: 1, animated: true)
    }

    @objc private func openPearlHarbor() {
        let page = SuliJoyPearlHarborViewController()
        page.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(page, animated: true)
    }

    @objc private func openPearlHarborFromShoreDialog() {
        openSuliJoyLagoonLetters()
    }
}

private final class validateSignupDraft: UIView {
    private let dayFormatter = 7
    private var coconutCream: [UIView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard coconutCream.isEmpty, bounds.width > 0, bounds.height > 0 else { return }
        let reefDraft: CGFloat = 2
        let clause = (bounds.width - reefDraft * CGFloat(dayFormatter - 1)) / CGFloat(dayFormatter)
        let reefReplyTally = bounds.height * 0.32
        for index in 0..<dayFormatter {
            let fetchIslandProfileSummary = UIView()
            fetchIslandProfileSummary.backgroundColor = .white
            fetchIslandProfileSummary.layer.cornerRadius = 2
            fetchIslandProfileSummary.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            let makeLagoonEntryReefScene = CGFloat(index) * (clause + reefDraft)
            fetchIslandProfileSummary.frame = CGRect(x: makeLagoonEntryReefScene, y: bounds.height - reefReplyTally, width: clause, height: reefReplyTally)
            addSubview(fetchIslandProfileSummary)
            coconutCream.append(fetchIslandProfileSummary)
        }
        assetSnapshot()
    }

    func assetSnapshot() {
        guard !coconutCream.isEmpty else { return }
        let palmThread: [[CGFloat]] = [
            [0.28, 0.92, 0.46, 1, 0.38],
            [0.72, 0.34, 1, 0.5, 0.82],
            [0.4, 1, 0.55, 0.3, 0.88],
            [1, 0.42, 0.78, 0.36, 0.95],
            [0.5, 0.86, 0.32, 1, 0.58],
            [0.9, 0.38, 0.7, 1, 0.44],
            [0.33, 0.8, 1, 0.48, 0.66]
        ]
        for (index, fetchIslandProfileSummary) in coconutCream.enumerated() {
            guard fetchIslandProfileSummary.layer.animation(forKey: "voiceMeter") == nil else { continue }
            let tuneMomentImageWavePill = CAKeyframeAnimation(keyPath: "transform.scale.y")
            tuneMomentImageWavePill.values = palmThread[index % palmThread.count]
            tuneMomentImageWavePill.keyTimes = [0, 0.25, 0.5, 0.75, 1]
            tuneMomentImageWavePill.duration = 0.72 + Double(index % 3) * 0.14
            tuneMomentImageWavePill.repeatCount = .infinity
            tuneMomentImageWavePill.autoreverses = true
            tuneMomentImageWavePill.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            tuneMomentImageWavePill.isRemovedOnCompletion = false
            fetchIslandProfileSummary.layer.add(tuneMomentImageWavePill, forKey: "voiceMeter")
        }
    }

    func defaults() {
        coconutCream.forEach { $0.layer.removeAnimation(forKey: "voiceMeter") }
    }
}

private final class discoverDrop: UICollectionViewCell {
    private let breezyFit = UIImageView()
    private let polishShellCache = UIView()
    private let crinkleLinen = UIImageView()
    private let hostName = UILabel()
    private let reefInputBottomConstraint = UIView()
    private let contentTop = UIImageView()
    private let pearlAmount = UILabel()
    private let chooseShoreReason = UIView()
    private let shellCargo = UIStackView()
    private let SuliJoybackTop = UILabel()
    private let shoreSearchControl = validateSignupDraft()
    private let reefPrompt = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 18
        contentView.clipsToBounds = true

        breezyFit.translatesAutoresizingMaskIntoConstraints = false
        breezyFit.contentMode = .scaleAspectFill

        let veil = UIColor.black.withAlphaComponent(0.42)
        polishShellCache.translatesAutoresizingMaskIntoConstraints = false
        polishShellCache.backgroundColor = veil
        polishShellCache.layer.cornerRadius = 13
        polishShellCache.clipsToBounds = true

        crinkleLinen.translatesAutoresizingMaskIntoConstraints = false
        crinkleLinen.contentMode = .scaleAspectFill
        crinkleLinen.clipsToBounds = true
        crinkleLinen.layer.cornerRadius = 9

        hostName.translatesAutoresizingMaskIntoConstraints = false
        hostName.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        hostName.textColor = .white
        hostName.lineBreakMode = .byTruncatingTail

        reefInputBottomConstraint.translatesAutoresizingMaskIntoConstraints = false
        reefInputBottomConstraint.backgroundColor = UIColor(red: 0.49, green: 0.32, blue: 0.98, alpha: 1)
        reefInputBottomConstraint.layer.cornerRadius = 13
        reefInputBottomConstraint.clipsToBounds = true

        contentTop.translatesAutoresizingMaskIntoConstraints = false
        contentTop.image = UIImage(named: "sulijoy_voice_heat")?.withRenderingMode(.alwaysOriginal)
        contentTop.contentMode = .scaleAspectFit

        pearlAmount.translatesAutoresizingMaskIntoConstraints = false
        pearlAmount.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        pearlAmount.textColor = .white

        chooseShoreReason.translatesAutoresizingMaskIntoConstraints = false
        chooseShoreReason.backgroundColor = veil
        chooseShoreReason.layer.cornerRadius = 14
        chooseShoreReason.clipsToBounds = true

        shellCargo.translatesAutoresizingMaskIntoConstraints = false
        shellCargo.axis = .horizontal
        shellCargo.spacing = -8

        SuliJoybackTop.translatesAutoresizingMaskIntoConstraints = false
        SuliJoybackTop.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        SuliJoybackTop.textColor = .white

        shoreSearchControl.translatesAutoresizingMaskIntoConstraints = false

        reefPrompt.translatesAutoresizingMaskIntoConstraints = false
        reefPrompt.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        reefPrompt.textColor = .white
        reefPrompt.numberOfLines = 2

        contentView.addSubview(breezyFit)
        contentView.addSubview(polishShellCache)
        polishShellCache.addSubview(crinkleLinen)
        polishShellCache.addSubview(hostName)
        contentView.addSubview(reefInputBottomConstraint)
        reefInputBottomConstraint.addSubview(contentTop)
        reefInputBottomConstraint.addSubview(pearlAmount)
        contentView.addSubview(chooseShoreReason)
        chooseShoreReason.addSubview(shellCargo)
        chooseShoreReason.addSubview(SuliJoybackTop)
        contentView.addSubview(shoreSearchControl)
        contentView.addSubview(reefPrompt)

        polishShellCache.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        hostName.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        reefInputBottomConstraint.setContentCompressionResistancePriority(.required, for: .horizontal)
        reefInputBottomConstraint.setContentHuggingPriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            breezyFit.topAnchor.constraint(equalTo: contentView.topAnchor),
            breezyFit.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            breezyFit.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            breezyFit.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            polishShellCache.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            polishShellCache.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            polishShellCache.trailingAnchor.constraint(lessThanOrEqualTo: reefInputBottomConstraint.leadingAnchor, constant: -6),
            polishShellCache.heightAnchor.constraint(equalToConstant: 26),
            crinkleLinen.leadingAnchor.constraint(equalTo: polishShellCache.leadingAnchor, constant: 4),
            crinkleLinen.centerYAnchor.constraint(equalTo: polishShellCache.centerYAnchor),
            crinkleLinen.widthAnchor.constraint(equalToConstant: 18),
            crinkleLinen.heightAnchor.constraint(equalToConstant: 18),
            hostName.leadingAnchor.constraint(equalTo: crinkleLinen.trailingAnchor, constant: 5),
            hostName.trailingAnchor.constraint(equalTo: polishShellCache.trailingAnchor, constant: -8),
            hostName.centerYAnchor.constraint(equalTo: polishShellCache.centerYAnchor),
            reefInputBottomConstraint.topAnchor.constraint(equalTo: polishShellCache.topAnchor),
            reefInputBottomConstraint.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            reefInputBottomConstraint.heightAnchor.constraint(equalToConstant: 26),
            contentTop.leadingAnchor.constraint(equalTo: reefInputBottomConstraint.leadingAnchor, constant: 8),
            contentTop.centerYAnchor.constraint(equalTo: reefInputBottomConstraint.centerYAnchor),
            contentTop.widthAnchor.constraint(equalToConstant: 10),
            contentTop.heightAnchor.constraint(equalToConstant: 13),
            pearlAmount.leadingAnchor.constraint(equalTo: contentTop.trailingAnchor, constant: 3),
            pearlAmount.trailingAnchor.constraint(equalTo: reefInputBottomConstraint.trailingAnchor, constant: -8),
            pearlAmount.centerYAnchor.constraint(equalTo: reefInputBottomConstraint.centerYAnchor),
            reefPrompt.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            reefPrompt.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            reefPrompt.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            chooseShoreReason.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            chooseShoreReason.trailingAnchor.constraint(lessThanOrEqualTo: shoreSearchControl.leadingAnchor, constant: -6),
            chooseShoreReason.bottomAnchor.constraint(equalTo: reefPrompt.topAnchor, constant: -6),
            chooseShoreReason.heightAnchor.constraint(equalToConstant: 28),
            shoreSearchControl.centerYAnchor.constraint(equalTo: chooseShoreReason.centerYAnchor, constant: -7),
            shoreSearchControl.trailingAnchor.constraint(equalTo: reefPrompt.trailingAnchor),
            shoreSearchControl.widthAnchor.constraint(equalToConstant: 25),
            shoreSearchControl.heightAnchor.constraint(equalToConstant: 40),
            shellCargo.leadingAnchor.constraint(equalTo: chooseShoreReason.leadingAnchor, constant: 4),
            shellCargo.centerYAnchor.constraint(equalTo: chooseShoreReason.centerYAnchor),
            shellCargo.heightAnchor.constraint(equalToConstant: 22),
            SuliJoybackTop.leadingAnchor.constraint(equalTo: shellCargo.trailingAnchor, constant: 6),
            SuliJoybackTop.trailingAnchor.constraint(equalTo: chooseShoreReason.trailingAnchor, constant: -8),
            SuliJoybackTop.centerYAnchor.constraint(equalTo: chooseShoreReason.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        shellCargo.arrangedSubviews.forEach {
            shellCargo.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        shoreSearchControl.defaults()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window == nil {
            shoreSearchControl.defaults()
        } else {
            shoreSearchControl.assetSnapshot()
        }
    }

    func suliJoyCoastalState(_ card: shorelineWheel) {
        breezyFit.shoreCell(card.reefDefaults)
        crinkleLinen.actionRow(card.tuneCoveCapsuleShell)
        hostName.text = card.hostName
        pearlAmount.text = "\(card.suliJoyShoreMomentPublished)"
        reefPrompt.text = card.summary
        let reefKeysWillRise = Array(card.completed.prefix(2))
        let dividerSide = reefKeysWillRise.isEmpty ? [""] : reefKeysWillRise
        for token in dividerSide {
            let reefKey = UIImageView()
            reefKey.actionRow(token)
            reefKey.translatesAutoresizingMaskIntoConstraints = false
            reefKey.contentMode = .scaleAspectFill
            reefKey.clipsToBounds = true
            reefKey.layer.cornerRadius = 11
            reefKey.layer.borderWidth = 1
            reefKey.layer.borderColor = UIColor.white.cgColor
            shellCargo.addArrangedSubview(reefKey)
            reefKey.widthAnchor.constraint(equalToConstant: 22).isActive = true
            reefKey.heightAnchor.constraint(equalToConstant: 22).isActive = true
        }
        SuliJoybackTop.text = "+\(max(card.islandHost, dividerSide.count))"
        shoreSearchControl.assetSnapshot()
    }
}

private final class chosenShoreTime: UILabel {
    var horizontalInset: CGFloat = 0

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: horizontalInset, dy: 0))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + horizontalInset * 2, height: size.height)
    }
}

private final class titleInput: UITableViewCell {
    private let card = UIView()
    private let sendReefComment = UIView()
    private let reefStop = CAGradientLayer()
    private let waveOnlyDurationGlyph = UIImageView()
    private let tuneMarkShell = UIImageView()
    private let stitchShorelineReelCove = UILabel()
    private let subtitleLabel = UILabel()
    private var reefPosterFrame: NSLayoutConstraint?
    private let reefInputBottomConstraint = UIView()
    private let contentTop = UIImageView()
    private let pearlAmount = UILabel()
    private let lagoonFaceRail = UIStackView()
    private let acceptLagoonControl = UIStackView()
    private let shorelineMailBadge = chosenShoreTime()
    private let assets = chosenShoreTime()
    private let shellCargo = UIStackView()
    private let shoreBottomTether = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 24

        sendReefComment.translatesAutoresizingMaskIntoConstraints = false
        reefStop.colors = [
            UIColor(red: 1, green: 0.45, blue: 0.28, alpha: 1).cgColor,
            UIColor(red: 0.55, green: 0.95, blue: 0.4, alpha: 1).cgColor
        ]
        reefStop.startPoint = CGPoint(x: 0, y: 0.5)
        reefStop.endPoint = CGPoint(x: 1, y: 0.5)
        sendReefComment.layer.addSublayer(reefStop)
        waveOnlyDurationGlyph.translatesAutoresizingMaskIntoConstraints = false
        waveOnlyDurationGlyph.contentMode = .scaleAspectFill
        waveOnlyDurationGlyph.clipsToBounds = true
        waveOnlyDurationGlyph.layer.cornerRadius = 28
        waveOnlyDurationGlyph.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)

        tuneMarkShell.translatesAutoresizingMaskIntoConstraints = false
        tuneMarkShell.image = UIImage(named: "sulijoy_live_badge")?.withRenderingMode(.alwaysOriginal)
        tuneMarkShell.contentMode = .scaleAspectFit

        stitchShorelineReelCove.translatesAutoresizingMaskIntoConstraints = false
        stitchShorelineReelCove.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        stitchShorelineReelCove.textColor = .suliInk
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = .suliMutedInk

        reefInputBottomConstraint.translatesAutoresizingMaskIntoConstraints = false
        reefInputBottomConstraint.backgroundColor = UIColor.black.withAlphaComponent(0.08)
        reefInputBottomConstraint.layer.cornerRadius = 11
        reefInputBottomConstraint.clipsToBounds = true
        contentTop.translatesAutoresizingMaskIntoConstraints = false
        contentTop.image = UIImage(named: "sulijoy_live_heat")?.withRenderingMode(.alwaysOriginal)
        contentTop.contentMode = .scaleAspectFit
        pearlAmount.translatesAutoresizingMaskIntoConstraints = false
        pearlAmount.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        pearlAmount.textColor = UIColor(red: 1, green: 0.45, blue: 0.2, alpha: 1)

        lagoonFaceRail.translatesAutoresizingMaskIntoConstraints = false
        lagoonFaceRail.axis = .horizontal
        lagoonFaceRail.spacing = 6
        lagoonFaceRail.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        acceptLagoonControl.translatesAutoresizingMaskIntoConstraints = false
        acceptLagoonControl.axis = .horizontal
        acceptLagoonControl.alignment = .center
        acceptLagoonControl.spacing = 8
        for rendered in [shorelineMailBadge, assets] {
            rendered.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
            rendered.textColor = UIColor(red: 0.95, green: 0.45, blue: 0.55, alpha: 1)
            rendered.backgroundColor = UIColor(red: 1, green: 0.93, blue: 0.94, alpha: 1)
            rendered.layer.cornerRadius = 10
            rendered.clipsToBounds = true
            rendered.horizontalInset = 4
            rendered.setContentHuggingPriority(.required, for: .horizontal)
            rendered.setContentCompressionResistancePriority(.required, for: .horizontal)
            lagoonFaceRail.addArrangedSubview(rendered)
        }

        shellCargo.translatesAutoresizingMaskIntoConstraints = false
        shellCargo.axis = .horizontal
        shellCargo.spacing = -8
        shellCargo.setContentHuggingPriority(.required, for: .horizontal)

        shoreBottomTether.translatesAutoresizingMaskIntoConstraints = false
        shoreBottomTether.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        shoreBottomTether.textColor = .white
        shoreBottomTether.backgroundColor = UIColor.suliInk.withAlphaComponent(0.88)
        shoreBottomTether.layer.cornerRadius = 11
        shoreBottomTether.clipsToBounds = true
        shoreBottomTether.textAlignment = .center
        shoreBottomTether.setContentHuggingPriority(.required, for: .horizontal)

        contentView.addSubview(card)
        card.addSubview(sendReefComment)
        card.addSubview(waveOnlyDurationGlyph)
        card.addSubview(tuneMarkShell)
        card.addSubview(stitchShorelineReelCove)
        card.addSubview(subtitleLabel)
        card.addSubview(reefInputBottomConstraint)
        reefInputBottomConstraint.addSubview(contentTop)
        reefInputBottomConstraint.addSubview(pearlAmount)
        card.addSubview(acceptLagoonControl)
        let lagoonGuestID = UIView()
        lagoonGuestID.translatesAutoresizingMaskIntoConstraints = false
        lagoonGuestID.setContentHuggingPriority(.defaultLow, for: .horizontal)
        lagoonGuestID.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        lagoonFaceRail.setContentHuggingPriority(.required, for: .horizontal)
        acceptLagoonControl.addArrangedSubview(lagoonFaceRail)
        acceptLagoonControl.addArrangedSubview(lagoonGuestID)
        acceptLagoonControl.addArrangedSubview(shellCargo)
        acceptLagoonControl.addArrangedSubview(shoreBottomTether)

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            sendReefComment.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            sendReefComment.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            sendReefComment.widthAnchor.constraint(equalToConstant: 64),
            sendReefComment.heightAnchor.constraint(equalToConstant: 64),
            waveOnlyDurationGlyph.centerXAnchor.constraint(equalTo: sendReefComment.centerXAnchor),
            waveOnlyDurationGlyph.centerYAnchor.constraint(equalTo: sendReefComment.centerYAnchor),
            waveOnlyDurationGlyph.widthAnchor.constraint(equalToConstant: 56),
            waveOnlyDurationGlyph.heightAnchor.constraint(equalToConstant: 56),
            tuneMarkShell.centerXAnchor.constraint(equalTo: sendReefComment.centerXAnchor),
            tuneMarkShell.bottomAnchor.constraint(equalTo: sendReefComment.bottomAnchor, constant: 6),
            tuneMarkShell.widthAnchor.constraint(equalToConstant: 52),
            tuneMarkShell.heightAnchor.constraint(equalToConstant: 18),
            stitchShorelineReelCove.leadingAnchor.constraint(equalTo: sendReefComment.trailingAnchor, constant: 12),
            stitchShorelineReelCove.topAnchor.constraint(equalTo: sendReefComment.topAnchor, constant: 2),
            stitchShorelineReelCove.trailingAnchor.constraint(lessThanOrEqualTo: reefInputBottomConstraint.leadingAnchor, constant: -8),
            subtitleLabel.leadingAnchor.constraint(equalTo: stitchShorelineReelCove.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: stitchShorelineReelCove.bottomAnchor, constant: 2),
            subtitleLabel.trailingAnchor.constraint(equalTo: stitchShorelineReelCove.trailingAnchor),
            reefInputBottomConstraint.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            reefInputBottomConstraint.centerYAnchor.constraint(equalTo: stitchShorelineReelCove.centerYAnchor),
            reefInputBottomConstraint.heightAnchor.constraint(equalToConstant: 22),
            contentTop.leadingAnchor.constraint(equalTo: reefInputBottomConstraint.leadingAnchor, constant: 6),
            contentTop.centerYAnchor.constraint(equalTo: reefInputBottomConstraint.centerYAnchor),
            contentTop.widthAnchor.constraint(equalToConstant: 10),
            contentTop.heightAnchor.constraint(equalToConstant: 13),
            pearlAmount.leadingAnchor.constraint(equalTo: contentTop.trailingAnchor, constant: 3),
            pearlAmount.trailingAnchor.constraint(equalTo: reefInputBottomConstraint.trailingAnchor, constant: -8),
            pearlAmount.centerYAnchor.constraint(equalTo: reefInputBottomConstraint.centerYAnchor),
            acceptLagoonControl.leadingAnchor.constraint(equalTo: stitchShorelineReelCove.leadingAnchor),
            acceptLagoonControl.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            acceptLagoonControl.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            acceptLagoonControl.heightAnchor.constraint(equalToConstant: 22),
            lagoonFaceRail.heightAnchor.constraint(equalToConstant: 20),
            shellCargo.heightAnchor.constraint(equalToConstant: 22),
            shoreBottomTether.heightAnchor.constraint(equalToConstant: 22),
            shoreBottomTether.widthAnchor.constraint(greaterThanOrEqualToConstant: 34)
        ])
        let islanderID = subtitleLabel.heightAnchor.constraint(equalToConstant: 0)
        islanderID.priority = .required
        reefPosterFrame = islanderID
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let hasShoreMomentContent = sendReefComment.bounds.height / 2
        sendReefComment.layer.cornerRadius = hasShoreMomentContent
        reefStop.cornerRadius = hasShoreMomentContent
        reefStop.frame = sendReefComment.bounds
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window == nil {
            chooseShorePortrait()
        } else {
            shellTotalLabel()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        chooseShorePortrait()
        shellCargo.isHidden = false
        shellCargo.arrangedSubviews.forEach {
            shellCargo.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    func backLead(_ card: coverImageView) {
        waveOnlyDurationGlyph.actionRow(card.resetWaveRecording)
        stitchShorelineReelCove.text = card.title
        let islandAccountVault = !card.subtitle.isEmpty
        subtitleLabel.text = card.subtitle
        subtitleLabel.isHidden = !islandAccountVault
        reefPosterFrame?.isActive = !islandAccountVault
        pearlAmount.text = "\(max(card.suliJoyShoreMomentPublished, 0))"
        let shorelineDraftLine = card.clipReef
        shorelineMailBadge.text = shorelineDraftLine.first ?? ""
        shorelineMailBadge.isHidden = shorelineDraftLine.isEmpty
        assets.isHidden = shorelineDraftLine.count < 2
        assets.text = shorelineDraftLine.count > 1 ? shorelineDraftLine[1] : ""
        shoreBottomTether.text = " +\(max(card.applyLagoonSummary, 0)) "
        let reefKeysWillRise = card.tideScrollCanvas.prefix(3)
        if reefKeysWillRise.isEmpty {
            shellCargo.isHidden = true
        } else {
            shellCargo.isHidden = false
            for token in reefKeysWillRise {
                let reefKey = UIImageView()
                reefKey.actionRow(token)
                reefKey.translatesAutoresizingMaskIntoConstraints = false
                reefKey.contentMode = .scaleAspectFill
                reefKey.clipsToBounds = true
                reefKey.layer.cornerRadius = 11
                reefKey.layer.borderWidth = 1
                reefKey.layer.borderColor = UIColor.white.cgColor
                shellCargo.addArrangedSubview(reefKey)
                reefKey.widthAnchor.constraint(equalToConstant: 22).isActive = true
                reefKey.heightAnchor.constraint(equalToConstant: 22).isActive = true
            }
        }
        shellTotalLabel()
    }

    private func shellTotalLabel() {
        let suliJoyCoastalCapsule = "suliJoyLiveHaloScale"
        let tideCell = "suliJoyLiveHaloGlow"
        guard sendReefComment.layer.animation(forKey: suliJoyCoastalCapsule) == nil else { return }
        let tapped = CABasicAnimation(keyPath: "transform.scale")
        tapped.fromValue = 0.96
        tapped.toValue = 1.08
        tapped.duration = 1.15
        tapped.autoreverses = true
        tapped.repeatCount = .infinity
        tapped.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        tapped.isRemovedOnCompletion = false
        sendReefComment.layer.add(tapped, forKey: suliJoyCoastalCapsule)

        let crownSide = CABasicAnimation(keyPath: "opacity")
        crownSide.fromValue = 1
        crownSide.toValue = 0.62
        crownSide.duration = 1.15
        crownSide.autoreverses = true
        crownSide.repeatCount = .infinity
        crownSide.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        crownSide.isRemovedOnCompletion = false
        sendReefComment.layer.add(crownSide, forKey: tideCell)
    }

    private func chooseShorePortrait() {
        sendReefComment.layer.removeAnimation(forKey: "suliJoyLiveHaloScale")
        sendReefComment.layer.removeAnimation(forKey: "suliJoyLiveHaloGlow")
        sendReefComment.layer.transform = CATransform3DIdentity
        sendReefComment.layer.opacity = 1
    }
}
