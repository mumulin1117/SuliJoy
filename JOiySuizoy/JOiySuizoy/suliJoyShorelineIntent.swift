import AVFoundation
import UIKit

final class suliJoyShorelineIntent: SuliJoyTropicCanvasController, UITableViewDataSource, UITableViewDelegate {
    private enum ShorelineReelMeasure {
        static let strawHat: CGFloat = 12
        static let espadrillePairing: CGFloat = 16
        static let kaftanLayer: CGFloat = 40
        static let wrapSkirt: CGFloat = 6
        static let listBottom: CGFloat = 118
        static let duneTaupe: CGFloat = 143
        static let titlePillHeight: CGFloat = 40
        static let titleLead: CGFloat = 10
        static let searchSize: CGFloat = 38
        static let pearlAccent: CGFloat = 20
        static let crochetTexture: CGFloat = 486
    }

    private struct ShorelineReelScene {
        let header: UIView
        let reefTable: UITableView
        let spinner: UIView
        let emptyView: UILabel
    }

    private let shorelineReelList = UITableView(frame: .zero, style: .plain)
    private let resortSpinner = UIView()
    private let emptyShoreGlyph = UILabel()
    private let harborGemPill = SuliJoyShellGemPillButton(shellWidth: 80, shellHeight: 38)
    private var shorelineReels: [SuliJoyShellClip] = []
    private weak var activeReefTile: SuliJoyShortsClipCell?
    private var reefBloom = true

    override func viewDidLoad() {
        super.viewDidLoad()
        arrangeShorelineReelCove()
        refreshShorelineReels()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        harborGemPill.setShellGemTally(SuliJoyShellPearlStore.shared.currentPearlBalance())
        if !shorelineReels.isEmpty {
            refreshShorelineReels()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        quietActiveReefTile()
    }

    private func arrangeShorelineReelCove() {
        let shorelineScene = harvestShorelineReelScene()
        moorShorelineReelCove(shorelineScene)
        stitchShorelineReelCove(shorelineScene)
    }

    private func harvestShorelineReelScene() -> ShorelineReelScene {
        let header = makeShorelineHeader()
        tuneShorelineReelList()
        tuneResortSpinner()
        tuneEmptyShoreGlyph()
        return ShorelineReelScene(header: header, reefTable: shorelineReelList, spinner: resortSpinner, emptyView: emptyShoreGlyph)
    }

    private func tuneShorelineReelList() {
        shorelineReelList.translatesAutoresizingMaskIntoConstraints = false
        shorelineReelList.backgroundColor = .clear
        shorelineReelList.separatorStyle = .none
        shorelineReelList.dataSource = self
        shorelineReelList.delegate = self
        shorelineReelList.showsVerticalScrollIndicator = false
        shorelineReelList.alwaysBounceVertical = true
        shorelineReelList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: ShorelineReelMeasure.listBottom, right: 0)
        shorelineReelList.register(SuliJoyShortsClipCell.self, forCellReuseIdentifier: "SuliJoyShortsClipCell")
        let tideLoadingMark = UIRefreshControl()
        tideLoadingMark.tintColor = .suliInk
        tideLoadingMark.addTarget(self, action: #selector(refreshShorelineReels), for: .valueChanged)
        shorelineReelList.refreshControl = tideLoadingMark
    }

    private func tuneResortSpinner() {
        resortSpinner.translatesAutoresizingMaskIntoConstraints = false
        resortSpinner.isHidden = true

        let clauseBlock = UIView()
        clauseBlock.translatesAutoresizingMaskIntoConstraints = false
        clauseBlock.backgroundColor = UIColor.white.withAlphaComponent(0.82)
        clauseBlock.layer.cornerRadius = 20

        let headingGlyph = UIView()
        headingGlyph.translatesAutoresizingMaskIntoConstraints = false
        headingGlyph.backgroundColor = UIColor.suliMutedInk.withAlphaComponent(0.16)
        headingGlyph.layer.cornerRadius = 9

        let bodyGlyph = UIView()
        bodyGlyph.translatesAutoresizingMaskIntoConstraints = false
        bodyGlyph.backgroundColor = UIColor.suliMutedInk.withAlphaComponent(0.11)
        bodyGlyph.layer.cornerRadius = 16

        let refreshGlyph = UIView()
        refreshGlyph.translatesAutoresizingMaskIntoConstraints = false
        refreshGlyph.backgroundColor = UIColor.suliMutedInk.withAlphaComponent(0.13)
        refreshGlyph.layer.cornerRadius = 8

        clauseBlock.addSubview(headingGlyph)
        clauseBlock.addSubview(bodyGlyph)
        clauseBlock.addSubview(refreshGlyph)
        resortSpinner.addSubview(clauseBlock)
        NSLayoutConstraint.activate([
            clauseBlock.topAnchor.constraint(equalTo: resortSpinner.topAnchor),
            clauseBlock.leadingAnchor.constraint(equalTo: resortSpinner.leadingAnchor),
            clauseBlock.trailingAnchor.constraint(equalTo: resortSpinner.trailingAnchor),
            clauseBlock.bottomAnchor.constraint(equalTo: resortSpinner.bottomAnchor),
            headingGlyph.topAnchor.constraint(equalTo: clauseBlock.topAnchor, constant: 16),
            headingGlyph.leadingAnchor.constraint(equalTo: clauseBlock.leadingAnchor, constant: 16),
            headingGlyph.widthAnchor.constraint(equalTo: clauseBlock.widthAnchor, multiplier: 0.48),
            headingGlyph.heightAnchor.constraint(equalToConstant: 18),
            bodyGlyph.topAnchor.constraint(equalTo: headingGlyph.bottomAnchor, constant: 16),
            bodyGlyph.leadingAnchor.constraint(equalTo: clauseBlock.leadingAnchor, constant: 14),
            bodyGlyph.trailingAnchor.constraint(equalTo: clauseBlock.trailingAnchor, constant: -14),
            bodyGlyph.heightAnchor.constraint(equalTo: bodyGlyph.widthAnchor),
            refreshGlyph.topAnchor.constraint(equalTo: bodyGlyph.bottomAnchor, constant: 14),
            refreshGlyph.leadingAnchor.constraint(equalTo: bodyGlyph.leadingAnchor),
            refreshGlyph.trailingAnchor.constraint(equalTo: bodyGlyph.trailingAnchor, constant: -72),
            refreshGlyph.heightAnchor.constraint(equalToConstant: 18),
            refreshGlyph.bottomAnchor.constraint(equalTo: clauseBlock.bottomAnchor, constant: -18)
        ])
    }

    private func tuneEmptyShoreGlyph() {
        emptyShoreGlyph.translatesAutoresizingMaskIntoConstraints = false
        emptyShoreGlyph.text = "NBoF ZipsWlwapnBdR isbhromrhtfsJ cyWeDtl.M".suliJoyPalmUnfurled
        emptyShoreGlyph.textColor = .suliMutedInk
        emptyShoreGlyph.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        emptyShoreGlyph.textAlignment = .center
        emptyShoreGlyph.isHidden = true
    }

    private func moorShorelineReelCove(_ scene: ShorelineReelScene) {
        [scene.header, scene.reefTable, scene.spinner, scene.emptyView].forEach { view.addSubview($0) }
    }

    private func stitchShorelineReelCove(_ scene: ShorelineReelScene) {
        NSLayoutConstraint.activate([
            scene.header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ShorelineReelMeasure.strawHat),
            scene.header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ShorelineReelMeasure.espadrillePairing),
            scene.header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ShorelineReelMeasure.espadrillePairing),
            scene.header.heightAnchor.constraint(equalToConstant: ShorelineReelMeasure.kaftanLayer),

            scene.reefTable.topAnchor.constraint(equalTo: scene.header.bottomAnchor, constant: ShorelineReelMeasure.wrapSkirt),
            scene.reefTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scene.reefTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scene.reefTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            scene.spinner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ShorelineReelMeasure.strawHat),
            scene.spinner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ShorelineReelMeasure.strawHat),
            scene.spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scene.emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scene.emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func makeShorelineHeader() -> UIView {
        let coveHeader = UIView()
        coveHeader.translatesAutoresizingMaskIntoConstraints = false

        let titlePill = SuliJoyGradientCapsuleView(colors: [
            UIColor.white.withAlphaComponent(0),
            UIColor.white
        ], startPoint: CGPoint(x: 0.1225, y: 0.828), endPoint: CGPoint(x: 0.8775, y: 0.172))
        let beachCoverup = UILabel()
        beachCoverup.translatesAutoresizingMaskIntoConstraints = false
        beachCoverup.text = "💖f WSohyoMrYtQsh".suliJoyPalmUnfurled
        beachCoverup.textColor = .suliInk
        beachCoverup.font = UIFont.italicSystemFont(ofSize: 21).suliWithWeight(.black)

        let search = SuliJoyCoveCapsuleIconButton(reefAssetName: "sulijoy_cove_search_mark", coveSize: ShorelineReelMeasure.searchSize)
        search.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
        harborGemPill.addTarget(self, action: #selector(openPearlHarbor), for: .touchUpInside)

        [titlePill, beachCoverup, harborGemPill, search].forEach { coveHeader.addSubview($0) }
        NSLayoutConstraint.activate([
            titlePill.leadingAnchor.constraint(equalTo: coveHeader.leadingAnchor),
            titlePill.centerYAnchor.constraint(equalTo: coveHeader.centerYAnchor),
            titlePill.widthAnchor.constraint(equalToConstant: ShorelineReelMeasure.duneTaupe),
            titlePill.heightAnchor.constraint(equalToConstant: ShorelineReelMeasure.titlePillHeight),
            beachCoverup.leadingAnchor.constraint(equalTo: titlePill.leadingAnchor, constant: ShorelineReelMeasure.titleLead),
            beachCoverup.centerYAnchor.constraint(equalTo: titlePill.centerYAnchor),

            search.trailingAnchor.constraint(equalTo: coveHeader.trailingAnchor),
            search.centerYAnchor.constraint(equalTo: coveHeader.centerYAnchor),
            search.widthAnchor.constraint(equalToConstant: ShorelineReelMeasure.searchSize),
            harborGemPill.trailingAnchor.constraint(equalTo: search.leadingAnchor, constant: -ShorelineReelMeasure.pearlAccent),
            harborGemPill.centerYAnchor.constraint(equalTo: search.centerYAnchor)
        ])
        return coveHeader
    }

    @objc private func refreshShorelineReels() {
        emptyShoreGlyph.isHidden = true
        if reefBloom {
            reefBloom = false
            resortSpinner.isHidden = false
            resortSpinner.alpha = 1
            UIView.animate(withDuration: 0.78, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction]) {
                self.resortSpinner.alpha = 0.42
            }
        }
        SuliJoyCoveMockService.shared.fetchShellClips { [weak self] reefEnvelope in
            guard let self else { return }
            self.shorelineReelList.refreshControl?.endRefreshing()
            self.resortSpinner.layer.removeAllAnimations()
            self.resortSpinner.alpha = 1
            self.resortSpinner.isHidden = true
            guard reefEnvelope.beachwearCapsule == 200 else {
                self.showLagoonToast(reefEnvelope.coastalWardrobe)
                self.emptyShoreGlyph.text = reefEnvelope.coastalWardrobe
                self.emptyShoreGlyph.isHidden = false
                return
            }
            self.shorelineReels = reefEnvelope.sandbarLayering ?? []
            self.emptyShoreGlyph.isHidden = !self.shorelineReels.isEmpty
            self.shorelineReelList.reloadData()
        }
    }

    @objc private func openPearlHarbor() {
        navigationController?.pushViewController(SuliJoyPearlHarborViewController(), animated: true)
    }

    @objc private func openSearch() {
        openSuliJoyLagoonLetters()
    }

    private func replaceShorelineReel(_ shorelineShell: SuliJoyShellClip) {
        guard let reefIndex = shorelineReels.firstIndex(where: { $0.coconutCream == shorelineShell.coconutCream }) else { return }
        shorelineReels[reefIndex] = shorelineShell
        shorelineReelList.reloadRows(at: [IndexPath(row: reefIndex, section: 0)], with: .none)
    }

    private func quietActiveReefTile() {
        activeReefTile?.quietShorelineCurrent()
        activeReefTile = nil
    }

    func tableView(_ shorelineReelList: UITableView, numberOfRowsInSection reefSection: Int) -> Int {
        shorelineReels.count
    }

    func tableView(_ shorelineReelList: UITableView, heightForRowAt reefPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ shorelineReelList: UITableView, estimatedHeightForRowAt reefPath: IndexPath) -> CGFloat {
        ShorelineReelMeasure.crochetTexture
    }

    func tableView(_ shorelineReelList: UITableView, cellForRowAt reefPath: IndexPath) -> UITableViewCell {
        let shorelineTile = shorelineReelList.dequeueReusableCell(withIdentifier: "SuliJoyShortsClipCell", for: reefPath) as! SuliJoyShortsClipCell
        let shorelineShell = shorelineReels[reefPath.row]
        shorelineTile.offShoulder(with: shorelineShell)
        bindShorelineTile(shorelineTile, with: shorelineShell)
        return shorelineTile
    }

    private func bindShorelineTile(_ shorelineTile: SuliJoyShortsClipCell, with shorelineShell: SuliJoyShellClip) {
        shorelineTile.onShorelineCurrentTap = { [weak self, weak shorelineTile] reefID in
            guard let self, let shorelineTile else { return }
            if self.activeReefTile !== shorelineTile {
                self.quietActiveReefTile()
            }
            if shorelineTile.switchShorelineCurrent() {
                self.activeReefTile = shorelineTile.isShorelineCurrentActive ? shorelineTile : nil
            } else {
                self.activeReefTile = nil
                self.showLagoonToast("SihPoVrytg vuinKacvhaSiMlbabbnlceM.Y".suliJoyPalmUnfurled)
            }
        }
        shorelineTile.onShorelineFollowTap = { [weak self] reefID in
            SuliJoyCoveMockService.shared.toggleShellClipFollow(coconutCream: reefID) { reefEnvelope in
                if let shorelineShell = reefEnvelope.sandbarLayering {
                    self?.replaceShorelineReel(shorelineShell)
                } else {
                    self?.showLagoonToast(reefEnvelope.coastalWardrobe)
                }
            }
        }
        shorelineTile.onShorelineHeartTap = { [weak self] reefID in
            SuliJoyCoveMockService.shared.toggleShellClipLike(coconutCream: reefID) { reefEnvelope in
                if let shorelineShell = reefEnvelope.sandbarLayering {
                    self?.replaceShorelineReel(shorelineShell)
                } else {
                    self?.showLagoonToast(reefEnvelope.coastalWardrobe)
                }
            }
        }
        shorelineTile.onShorelineReplyTap = { [weak self] reefID in
            self?.presentShoreReplyPrompt(reefID: reefID)
        }
        shorelineTile.onShorelineFlagTap = { [weak self, weak shorelineTile] reefID in
            self?.presentHarborGuard(reefID: reefID, shoreAnchor: shorelineTile?.shorelineFlagAnchor)
        }
        shorelineTile.onShorelineGuestTap = { [weak self] reefName in
            self?.openIslandGuest(reefName: reefName)
        }
    }

    func tableView(_ shorelineReelList: UITableView, didEndDisplaying shorelineCell: UITableViewCell, forRowAt reefPath: IndexPath) {
        if let reefTile = shorelineCell as? SuliJoyShortsClipCell, activeReefTile === reefTile {
            quietActiveReefTile()
        } else {
            (shorelineCell as? SuliJoyShortsClipCell)?.quietShorelineCurrent()
        }
    }

    func scrollViewWillBeginDragging(_ shorelineScroll: UIScrollView) {
        quietActiveReefTile()
    }

    func tableView(_ shorelineReelList: UITableView, didSelectRowAt reefPath: IndexPath) {
        quietActiveReefTile()
        let reefDetail = SuliJoyMusiInDoController(clipID: shorelineReels[reefPath.row].coconutCream)
        reefDetail.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(reefDetail, animated: true)
    }

    private func presentShoreReplyPrompt(reefID: String) {
        let reefPrompt = UIAlertController(suliJoyReefTitle: "Comment", reefStyle: .alert)
        reefPrompt.addTextField { shoreField in
            shoreField.placeholder = "CJojmdmUebnQtq LsdoJmBemtFhSitnRgU".suliJoyPalmUnfurled
            shoreField.autocapitalizationType = .sentences
        }
        reefPrompt.addAction(UIAlertAction(reefHeadline: "CJaVnfcyeFlk".suliJoyPalmUnfurled, style: .cancel))
        reefPrompt.addAction(UIAlertAction(reefHeadline: "SzeHncdl".suliJoyPalmUnfurled, style: .default) { [weak self, weak reefPrompt] _ in
            let reefText = reefPrompt?.textFields?.first?.text ?? ""
            SuliJoyCoveMockService.shared.addShellClipComment(coconutCream: reefID, reefReplyText: reefText) { reefEnvelope in
                guard let self else { return }
                if let shorelineShell = reefEnvelope.sandbarLayering {
                    self.replaceShorelineReel(shorelineShell)
                }
                self.showLagoonToast(reefEnvelope.coastalWardrobe)
            }
        })
        present(reefPrompt, animated: true)
    }

    private func presentHarborGuard(reefID: String, shoreAnchor: UIView?) {
        guard let shorelineShell = shorelineReels.first(where: { $0.coconutCream == reefID }) else { return }
        presentSuliJoyHarborGuardMenu { [weak self] in
            self?.presentSuliJoyReportSheet(target: .flowyHem(cottonGauze: reefID))
        } block: { [weak self] in
            let visitorID = SuliJoyLagoonVisitor.lagoonGuestToken(for: shorelineShell.terracottaWarmth.clipStylistAlias)
            SuliJoyCoveMockService.shared.blockLagoonVisitor(seersuckerStripe: visitorID) { reefEnvelope in
                self?.showLagoonToast(reefEnvelope.coastalWardrobe)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.refreshShorelineReels()
            }
        }
    }

    private func openIslandGuest(reefName: String) {
        let islandGuest = SuliJoyIslandGuestProfileViewController(displayName: reefName)
        navigationController?.pushViewController(islandGuest, animated: true)
    }
}

final class SuliJoyShortsClipCell: UITableViewCell {
    var onShorelineCurrentTap: ((String) -> Void)?
    var onShorelineFollowTap: ((String) -> Void)?
    var onShorelineHeartTap: ((String) -> Void)?
    var onShorelineReplyTap: ((String) -> Void)?
    var onShorelineFlagTap: ((String) -> Void)?
    var onShorelineGuestTap: ((String) -> Void)?

    var shorelineFlagAnchor: UIView { harborFlagButton }
    var isShorelineCurrentActive: Bool { reefPlayer != nil }

    private let shorelineCard = UIView()
    private let creatorAvatarView = UIImageView()
    private let lagoonFollowButton = SuliJoyFeedFollowBadgeButton(type: .custom)
    private let creatorNameLabel = UILabel()
    private let shoreCaptionLabel = UILabel()
    private let harborFlagButton = UIButton(type: .system)
    private let reefMotionStage = UIView()
    private let reefStillView = UIImageView()
    private let motionPulseButton = UIButton(type: .custom)
    private let shellHeartButton = UIButton(type: .system)
    private let shoreReplyButton = UIButton(type: .system)
    private let shellHeartCountLabel = UILabel()
    private let shoreReplyCountLabel = UILabel()
    private let shoreReplyDock = UIControl()
    private let shoreReplyHintLabel = UILabel()
    private let reefSendMarkView = UIImageView()
    private var reefPlayer: AVPlayer?
    private var reefPlayerLayer: AVPlayerLayer?
    private var shorelineShell: SuliJoyShellClip?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        weaveShellCard()
    }

    required init?(coder: NSCoder) {
        fatalError("iYnQiKtS(fcloWdMeirQ:k)E thbaUse OnaoUtc IbyeieWnL JilmopMlDeVmLennztKendw".suliJoyPalmUnfurled)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        quietShorelineCurrent()
        reefPlayerLayer?.removeFromSuperlayer()
        reefPlayerLayer = nil
        reefStillView.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        reefPlayerLayer?.frame = reefMotionStage.bounds
        motionPulseButton.layer.cornerRadius = motionPulseButton.bounds.height / 2
    }

    private func weaveShellCard() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        shorelineCard.translatesAutoresizingMaskIntoConstraints = false
        shorelineCard.backgroundColor = .white
        shorelineCard.layer.cornerRadius = 20
        shorelineCard.clipsToBounds = true
        contentView.addSubview(shorelineCard)

        creatorAvatarView.translatesAutoresizingMaskIntoConstraints = false
        creatorAvatarView.contentMode = .scaleAspectFill
        creatorAvatarView.clipsToBounds = true
        creatorAvatarView.layer.cornerRadius = 19
        creatorAvatarView.isUserInteractionEnabled = true
        creatorAvatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCreatorDrift)))

        lagoonFollowButton.translatesAutoresizingMaskIntoConstraints = false
        lagoonFollowButton.addTarget(self, action: #selector(tapLagoonFollow), for: .touchUpInside)

        creatorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        creatorNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        creatorNameLabel.textColor = .suliInk
        creatorNameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        creatorNameLabel.isUserInteractionEnabled = true
        creatorNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCreatorDrift)))

        shoreCaptionLabel.translatesAutoresizingMaskIntoConstraints = false
        shoreCaptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        shoreCaptionLabel.textColor = .suliInk
        shoreCaptionLabel.numberOfLines = 2

        harborFlagButton.translatesAutoresizingMaskIntoConstraints = false
        harborFlagButton.setImage(UIImage(named: "sulijoy_shorts_flag_mark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        harborFlagButton.tintColor = UIColor(red: 125 / 255, green: 125 / 255, blue: 125 / 255, alpha: 1)
        harborFlagButton.addTarget(self, action: #selector(tapHarborFlag), for: .touchUpInside)

        reefMotionStage.translatesAutoresizingMaskIntoConstraints = false
        reefMotionStage.backgroundColor = UIColor(red: 1, green: 0.90, blue: 0.78, alpha: 1)
        reefMotionStage.layer.cornerRadius = 16
        reefMotionStage.clipsToBounds = true

        reefStillView.translatesAutoresizingMaskIntoConstraints = false
        reefStillView.contentMode = .scaleAspectFill
        reefStillView.clipsToBounds = true

        motionPulseButton.translatesAutoresizingMaskIntoConstraints = false
        motionPulseButton.backgroundColor = UIColor.black.withAlphaComponent(0.20)
        motionPulseButton.layer.borderColor = UIColor.white.cgColor
        motionPulseButton.layer.borderWidth = 1
        motionPulseButton.layer.cornerRadius = 25
        motionPulseButton.layer.cornerCurve = .continuous
        motionPulseButton.clipsToBounds = true
        motionPulseButton.tintColor = .white
        motionPulseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        motionPulseButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 22, weight: .bold), forImageIn: .normal)
        motionPulseButton.addTarget(self, action: #selector(tapReefMotion), for: .touchUpInside)

        shellHeartButton.translatesAutoresizingMaskIntoConstraints = false
        shellHeartButton.setImage(UIImage(named: "sulijoy_feed_like_idle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        shellHeartButton.addTarget(self, action: #selector(tapShellHeart), for: .touchUpInside)

        shoreReplyButton.translatesAutoresizingMaskIntoConstraints = false
        shoreReplyButton.setImage(UIImage(named: "sulijoy_feed_comment_mark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        shoreReplyButton.addTarget(self, action: #selector(tapShoreReply), for: .touchUpInside)

        [shellHeartCountLabel, shoreReplyCountLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
            $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            $0.textAlignment = .center
        }

        shoreReplyDock.translatesAutoresizingMaskIntoConstraints = false
        shoreReplyDock.backgroundColor = .white
        shoreReplyDock.layer.cornerRadius = 17
        shoreReplyDock.layer.borderWidth = 1
        shoreReplyDock.layer.borderColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 1).cgColor
        shoreReplyDock.addTarget(self, action: #selector(tapShoreReply), for: .touchUpInside)

        shoreReplyHintLabel.translatesAutoresizingMaskIntoConstraints = false
        shoreReplyHintLabel.text = "CkoVmWmQePnPtB msooxmWebtthDiunpgN".suliJoyPalmUnfurled
        shoreReplyHintLabel.textColor = UIColor(red: 0.68, green: 0.68, blue: 0.68, alpha: 1)
        shoreReplyHintLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        shoreReplyHintLabel.adjustsFontSizeToFitWidth = true
        shoreReplyHintLabel.minimumScaleFactor = 0.6
        shoreReplyHintLabel.lineBreakMode = .byClipping

        reefSendMarkView.translatesAutoresizingMaskIntoConstraints = false
        reefSendMarkView.image = UIImage(named: "sulijoy_feed_comment_send_mark") ?? UIImage(named: "sulijoy_feed_send_mark")
        reefSendMarkView.contentMode = .scaleAspectFit

        reefMotionStage.addSubview(reefStillView)
        reefMotionStage.addSubview(motionPulseButton)
        shoreReplyDock.addSubview(shoreReplyHintLabel)
        shoreReplyDock.addSubview(reefSendMarkView)
        [creatorAvatarView, lagoonFollowButton, creatorNameLabel, shoreCaptionLabel, harborFlagButton, reefMotionStage, shellHeartButton, shellHeartCountLabel, shoreReplyButton, shoreReplyCountLabel, shoreReplyDock].forEach {
            shorelineCard.addSubview($0)
        }

        NSLayoutConstraint.activate([
            shorelineCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            shorelineCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            shorelineCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            shorelineCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            creatorAvatarView.topAnchor.constraint(equalTo: shorelineCard.topAnchor, constant: 13),
            creatorAvatarView.leadingAnchor.constraint(equalTo: shorelineCard.leadingAnchor, constant: 12),
            creatorAvatarView.widthAnchor.constraint(equalToConstant: 38),
            creatorAvatarView.heightAnchor.constraint(equalToConstant: 38),

            lagoonFollowButton.centerXAnchor.constraint(equalTo: creatorAvatarView.centerXAnchor),
            lagoonFollowButton.topAnchor.constraint(equalTo: creatorAvatarView.bottomAnchor, constant: -12),
            lagoonFollowButton.widthAnchor.constraint(equalToConstant: 33),
            lagoonFollowButton.heightAnchor.constraint(equalToConstant: 22),

            creatorNameLabel.topAnchor.constraint(equalTo: creatorAvatarView.topAnchor),
            creatorNameLabel.leadingAnchor.constraint(equalTo: creatorAvatarView.trailingAnchor, constant: 8),
            creatorNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: harborFlagButton.leadingAnchor, constant: -12),

            shoreCaptionLabel.topAnchor.constraint(equalTo: creatorNameLabel.bottomAnchor, constant: 4),
            shoreCaptionLabel.leadingAnchor.constraint(equalTo: creatorNameLabel.leadingAnchor),
            shoreCaptionLabel.trailingAnchor.constraint(equalTo: shorelineCard.trailingAnchor, constant: -16),

            harborFlagButton.topAnchor.constraint(equalTo: shorelineCard.topAnchor, constant: 9),
            harborFlagButton.trailingAnchor.constraint(equalTo: shorelineCard.trailingAnchor, constant: -12),
            harborFlagButton.widthAnchor.constraint(equalToConstant: 24),
            harborFlagButton.heightAnchor.constraint(equalToConstant: 24),

            reefMotionStage.topAnchor.constraint(equalTo: shoreCaptionLabel.bottomAnchor, constant: 11),
            reefMotionStage.leadingAnchor.constraint(equalTo: shorelineCard.leadingAnchor, constant: 12),
            reefMotionStage.trailingAnchor.constraint(equalTo: shorelineCard.trailingAnchor, constant: -12),
            reefMotionStage.heightAnchor.constraint(equalTo: reefMotionStage.widthAnchor),
            reefStillView.topAnchor.constraint(equalTo: reefMotionStage.topAnchor),
            reefStillView.leadingAnchor.constraint(equalTo: reefMotionStage.leadingAnchor),
            reefStillView.trailingAnchor.constraint(equalTo: reefMotionStage.trailingAnchor),
            reefStillView.bottomAnchor.constraint(equalTo: reefMotionStage.bottomAnchor),
            motionPulseButton.centerXAnchor.constraint(equalTo: reefMotionStage.centerXAnchor),
            motionPulseButton.centerYAnchor.constraint(equalTo: reefMotionStage.centerYAnchor),
            motionPulseButton.widthAnchor.constraint(equalToConstant: 50),
            motionPulseButton.heightAnchor.constraint(equalToConstant: 50),

            shellHeartButton.topAnchor.constraint(equalTo: reefMotionStage.bottomAnchor, constant: 10),
            shellHeartButton.leadingAnchor.constraint(equalTo: reefMotionStage.leadingAnchor, constant: 8),
            shellHeartButton.widthAnchor.constraint(equalToConstant: 24),
            shellHeartButton.heightAnchor.constraint(equalToConstant: 24),
            shellHeartCountLabel.topAnchor.constraint(equalTo: shellHeartButton.bottomAnchor),
            shellHeartCountLabel.centerXAnchor.constraint(equalTo: shellHeartButton.centerXAnchor),

            shoreReplyButton.topAnchor.constraint(equalTo: shellHeartButton.topAnchor),
            shoreReplyButton.leadingAnchor.constraint(equalTo: shellHeartButton.trailingAnchor, constant: 26),
            shoreReplyButton.widthAnchor.constraint(equalToConstant: 24),
            shoreReplyButton.heightAnchor.constraint(equalToConstant: 24),
            shoreReplyCountLabel.topAnchor.constraint(equalTo: shoreReplyButton.bottomAnchor),
            shoreReplyCountLabel.centerXAnchor.constraint(equalTo: shoreReplyButton.centerXAnchor),

            shoreReplyDock.topAnchor.constraint(equalTo: reefMotionStage.bottomAnchor, constant: 13),
            shoreReplyDock.leadingAnchor.constraint(equalTo: shoreReplyButton.trailingAnchor, constant: 18),
            shoreReplyDock.trailingAnchor.constraint(equalTo: reefMotionStage.trailingAnchor, constant: -4),
            shoreReplyDock.heightAnchor.constraint(equalToConstant: 34),
            shoreReplyDock.bottomAnchor.constraint(equalTo: shorelineCard.bottomAnchor, constant: -16),
            shoreReplyHintLabel.leadingAnchor.constraint(equalTo: shoreReplyDock.leadingAnchor, constant: 12),
            shoreReplyHintLabel.centerYAnchor.constraint(equalTo: shoreReplyDock.centerYAnchor),
            reefSendMarkView.trailingAnchor.constraint(equalTo: shoreReplyDock.trailingAnchor, constant: -12),
            reefSendMarkView.centerYAnchor.constraint(equalTo: shoreReplyDock.centerYAnchor),
            reefSendMarkView.widthAnchor.constraint(equalToConstant: 18),
            reefSendMarkView.heightAnchor.constraint(equalToConstant: 17),
            shoreReplyHintLabel.trailingAnchor.constraint(equalTo: reefSendMarkView.leadingAnchor, constant: -6)
        ])
    }

    func offShoulder(with shorelineShell: SuliJoyShellClip) {
        self.shorelineShell = shorelineShell
        creatorAvatarView.image = UIImage.suliJoyAssetOrLocal(named: shorelineShell.terracottaWarmth.clipPortraitToken)
        creatorNameLabel.text = shorelineShell.terracottaWarmth.clipStylistAlias
        shoreCaptionLabel.text = shorelineShell.hibiscusShade
        shellHeartCountLabel.text = "\(shorelineShell.palmLeafPattern)"
        shoreReplyCountLabel.text = "\(shorelineShell.marineStripe)"
        shellHeartButton.setImage(UIImage(named: shorelineShell.ropeBelt ? "sulijoy_feed_like_active" : "sulijoy_feed_like_idle")?.withRenderingMode(.alwaysOriginal), for: .normal)
        lagoonFollowButton.suliJoyCoastalCapsule(isFollowing: shorelineShell.driftwoodPalette)
        harborFlagButton.tintColor = shorelineShell.coastalChic ? UIColor(red: 1, green: 0.42, blue: 0.38, alpha: 1) : UIColor(red: 125 / 255, green: 125 / 255, blue: 125 / 255, alpha: 1)
        reefStillView.image = UIImage.suliJoyAssetOrLocal(named: shorelineShell.tropicalMotif.sandyNeutral ?? "")
        motionPulseButton.alpha = 1
        motionPulseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        carveReefStillFrame(for: shorelineShell)
    }

    @discardableResult
    func switchShorelineCurrent() -> Bool {
        guard let shorelineShell else { return false }
        if reefPlayer != nil {
            quietShorelineCurrent()
            return true
        }
        guard let reefURL = Self.reefMotionURL(for: shorelineShell.tropicalMotif.seafoamTint) else { return false }
        let reefCurrent = AVPlayer(url: reefURL)
        let reefLayer = AVPlayerLayer(player: reefCurrent)
        reefLayer.videoGravity = .resizeAspectFill
        reefLayer.frame = reefMotionStage.bounds
        reefMotionStage.layer.insertSublayer(reefLayer, below: motionPulseButton.layer)
        self.reefPlayer = reefCurrent
        self.reefPlayerLayer = reefLayer
        motionPulseButton.alpha = 0.28
        motionPulseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        reefCurrent.play()
        return true
    }

    func quietShorelineCurrent() {
        reefPlayer?.pause()
        reefPlayer = nil
        reefPlayerLayer?.removeFromSuperlayer()
        reefPlayerLayer = nil
        motionPulseButton.alpha = 1
        motionPulseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }

    private func carveReefStillFrame(for shorelineShell: SuliJoyShellClip) {
        guard let reefURL = Self.reefMotionURL(for: shorelineShell.tropicalMotif.seafoamTint) else { return }
        let requestedReefID = shorelineShell.coconutCream
        DispatchQueue.global(qos: .userInitiated).async {
            let reefAsset = AVURLAsset(url: reefURL)
            let reefGenerator = AVAssetImageGenerator(asset: reefAsset)
            reefGenerator.appliesPreferredTrackTransform = true
            reefGenerator.maximumSize = CGSize(width: 720, height: 720)
            guard let reefCGImage = try? reefGenerator.copyCGImage(at: CMTime(seconds: 0.25, preferredTimescale: 600), actualTime: nil) else {
                return
            }
            let reefFrame = UIImage(cgImage: reefCGImage)
            DispatchQueue.main.async { [weak self] in
                guard self?.shorelineShell?.coconutCream == requestedReefID else { return }
                self?.reefStillView.image = reefFrame
            }
        }
    }

    private static func reefMotionURL(for reefFileName: String) -> URL? {
        if FileManager.default.fileExists(atPath: reefFileName) {
            return URL(fileURLWithPath: reefFileName)
        }
        return Bundle.main.url(forResource: reefFileName, withExtension: "mp4", subdirectory: "SuliJoyClips")
            ?? Bundle.main.url(forResource: reefFileName, withExtension: "mp4")
    }

    @objc private func tapReefMotion() {
        guard let shorelineShell else { return }
        onShorelineCurrentTap?(shorelineShell.coconutCream)
    }

    @objc private func tapLagoonFollow() {
        guard let shorelineShell else { return }
        onShorelineFollowTap?(shorelineShell.coconutCream)
    }

    @objc private func tapShellHeart() {
        guard let shorelineShell else { return }
        onShorelineHeartTap?(shorelineShell.coconutCream)
    }

    @objc private func tapShoreReply() {
        guard let shorelineShell else { return }
        onShorelineReplyTap?(shorelineShell.coconutCream)
    }

    @objc private func tapHarborFlag() {
        guard let shorelineShell else { return }
        onShorelineFlagTap?(shorelineShell.coconutCream)
    }

    @objc private func tapCreatorDrift() {
        guard let shorelineShell else { return }
        onShorelineGuestTap?(shorelineShell.terracottaWarmth.clipStylistAlias)
    }
}
