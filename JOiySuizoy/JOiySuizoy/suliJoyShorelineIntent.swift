import AVFoundation
import UIKit

final class suliJoyShorelineIntent: SuliJoyTropicCanvasController, UITableViewDataSource, UITableViewDelegate {
    private enum ShorelineReelMeasure {
        static let strawHat: CGFloat = 8
        static let espadrillePairing: CGFloat = 24
        static let kaftanLayer: CGFloat = 52
        static let wrapSkirt: CGFloat = 10
        static let listBottom: CGFloat = 118
        static let duneTaupe: CGFloat = 148
        static let titlePillHeight: CGFloat = 44
        static let titleLead: CGFloat = 10
        static let searchSize: CGFloat = 44
        static let pearlAccent: CGFloat = 12
        static let crochetTexture: CGFloat = 515
    }

    private struct ShorelineReelScene {
        let header: UIView
        let reefTable: UITableView
        let spinner: UIActivityIndicatorView
        let emptyView: UILabel
    }

    private let shorelineReelList = UITableView(frame: .zero, style: .plain)
    private let resortSpinner = UIActivityIndicatorView(style: .large)
    private let emptyShoreGlyph = UILabel()
    private let harborGemPill = SuliJoyShellGemPillButton()
    private var shorelineReels: [SuliJoyShellClip] = []
    private weak var activeReefTile: SuliJoyShortsClipCell?

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
        shorelineReelList.contentInset = UIEdgeInsets(top: ShorelineReelMeasure.wrapSkirt, left: 0, bottom: ShorelineReelMeasure.listBottom, right: 0)
        shorelineReelList.register(SuliJoyShortsClipCell.self, forCellReuseIdentifier: "SuliJoyShortsClipCell")
    }

    private func tuneResortSpinner() {
        resortSpinner.translatesAutoresizingMaskIntoConstraints = false
        resortSpinner.hidesWhenStopped = true
        resortSpinner.color = .suliInk
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

            scene.spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scene.spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scene.emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scene.emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func makeShorelineHeader() -> UIView {
        let coveHeader = UIView()
        coveHeader.translatesAutoresizingMaskIntoConstraints = false

        let titlePill = SuliJoyGradientCapsuleView(colors: [
            UIColor.white.withAlphaComponent(0.02),
            UIColor.white
        ])
        let beachCoverup = UILabel()
        beachCoverup.translatesAutoresizingMaskIntoConstraints = false
        beachCoverup.text = "💖f WSohyoMrYtQsh".suliJoyPalmUnfurled
        beachCoverup.textColor = .suliInk
        beachCoverup.font = UIFont.italicSystemFont(ofSize: 28).suliWithWeight(.black)

        let search = SuliJoyCoveCapsuleIconButton(reefAssetName: "sulijoy_cove_search_mark")
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

    private func refreshShorelineReels() {
        emptyShoreGlyph.isHidden = true
        resortSpinner.startAnimating()
        SuliJoyCoveMockService.shared.fetchShellClips { [weak self] reefEnvelope in
            guard let self else { return }
            self.resortSpinner.stopAnimating()
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
                }
                self?.showLagoonToast(reefEnvelope.coastalWardrobe)
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
    private let lagoonFollowButton = UIButton(type: .custom)
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
    }

    private func weaveShellCard() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        shorelineCard.translatesAutoresizingMaskIntoConstraints = false
        shorelineCard.backgroundColor = .white
        shorelineCard.layer.cornerRadius = 22
        shorelineCard.clipsToBounds = true
        contentView.addSubview(shorelineCard)

        creatorAvatarView.translatesAutoresizingMaskIntoConstraints = false
        creatorAvatarView.contentMode = .scaleAspectFill
        creatorAvatarView.clipsToBounds = true
        creatorAvatarView.layer.cornerRadius = 19
        creatorAvatarView.isUserInteractionEnabled = true
        creatorAvatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCreatorDrift)))

        lagoonFollowButton.translatesAutoresizingMaskIntoConstraints = false
        lagoonFollowButton.setImage(UIImage(named: "sulijoy_feed_follow_plus")?.withRenderingMode(.alwaysOriginal), for: .normal)
        lagoonFollowButton.imageView?.contentMode = .scaleAspectFit
        lagoonFollowButton.addTarget(self, action: #selector(tapLagoonFollow), for: .touchUpInside)

        creatorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        creatorNameLabel.font = UIFont.systemFont(ofSize: 22, weight: .black)
        creatorNameLabel.textColor = .suliInk
        creatorNameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        creatorNameLabel.isUserInteractionEnabled = true
        creatorNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCreatorDrift)))

        shoreCaptionLabel.translatesAutoresizingMaskIntoConstraints = false
        shoreCaptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        shoreCaptionLabel.textColor = .suliInk
        shoreCaptionLabel.numberOfLines = 2

        harborFlagButton.translatesAutoresizingMaskIntoConstraints = false
        harborFlagButton.setImage(UIImage(systemName: "exclamationmark.triangle"), for: .normal)
        harborFlagButton.tintColor = UIColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 1)
        harborFlagButton.addTarget(self, action: #selector(tapHarborFlag), for: .touchUpInside)

        reefMotionStage.translatesAutoresizingMaskIntoConstraints = false
        reefMotionStage.backgroundColor = UIColor(red: 1, green: 0.90, blue: 0.78, alpha: 1)
        reefMotionStage.layer.cornerRadius = 18
        reefMotionStage.clipsToBounds = true

        reefStillView.translatesAutoresizingMaskIntoConstraints = false
        reefStillView.contentMode = .scaleAspectFill
        reefStillView.clipsToBounds = true

        motionPulseButton.translatesAutoresizingMaskIntoConstraints = false
        motionPulseButton.backgroundColor = UIColor.black.withAlphaComponent(0.20)
        motionPulseButton.layer.borderColor = UIColor.white.cgColor
        motionPulseButton.layer.borderWidth = 4
        motionPulseButton.layer.cornerRadius = 34
        motionPulseButton.tintColor = .white
        motionPulseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
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
        shoreReplyHintLabel.textColor = UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1)
        shoreReplyHintLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)

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
            shorelineCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            shorelineCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            shorelineCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            creatorAvatarView.topAnchor.constraint(equalTo: shorelineCard.topAnchor, constant: 24),
            creatorAvatarView.leadingAnchor.constraint(equalTo: shorelineCard.leadingAnchor, constant: 24),
            creatorAvatarView.widthAnchor.constraint(equalToConstant: 38),
            creatorAvatarView.heightAnchor.constraint(equalToConstant: 38),

            lagoonFollowButton.centerXAnchor.constraint(equalTo: creatorAvatarView.centerXAnchor),
            lagoonFollowButton.topAnchor.constraint(equalTo: creatorAvatarView.bottomAnchor, constant: -2),
            lagoonFollowButton.widthAnchor.constraint(equalToConstant: 44),
            lagoonFollowButton.heightAnchor.constraint(equalToConstant: 30),

            creatorNameLabel.topAnchor.constraint(equalTo: creatorAvatarView.topAnchor, constant: 2),
            creatorNameLabel.leadingAnchor.constraint(equalTo: creatorAvatarView.trailingAnchor, constant: 18),
            creatorNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: harborFlagButton.leadingAnchor, constant: -12),

            shoreCaptionLabel.topAnchor.constraint(equalTo: creatorNameLabel.bottomAnchor, constant: 8),
            shoreCaptionLabel.leadingAnchor.constraint(equalTo: creatorNameLabel.leadingAnchor),
            shoreCaptionLabel.trailingAnchor.constraint(equalTo: shorelineCard.trailingAnchor, constant: -28),

            harborFlagButton.topAnchor.constraint(equalTo: shorelineCard.topAnchor, constant: 22),
            harborFlagButton.trailingAnchor.constraint(equalTo: shorelineCard.trailingAnchor, constant: -24),
            harborFlagButton.widthAnchor.constraint(equalToConstant: 30),
            harborFlagButton.heightAnchor.constraint(equalToConstant: 30),

            reefMotionStage.topAnchor.constraint(equalTo: shoreCaptionLabel.bottomAnchor, constant: 16),
            reefMotionStage.leadingAnchor.constraint(equalTo: shorelineCard.leadingAnchor, constant: 24),
            reefMotionStage.trailingAnchor.constraint(equalTo: shorelineCard.trailingAnchor, constant: -24),
            reefMotionStage.heightAnchor.constraint(equalTo: reefMotionStage.widthAnchor),
            reefStillView.topAnchor.constraint(equalTo: reefMotionStage.topAnchor),
            reefStillView.leadingAnchor.constraint(equalTo: reefMotionStage.leadingAnchor),
            reefStillView.trailingAnchor.constraint(equalTo: reefMotionStage.trailingAnchor),
            reefStillView.bottomAnchor.constraint(equalTo: reefMotionStage.bottomAnchor),
            motionPulseButton.centerXAnchor.constraint(equalTo: reefMotionStage.centerXAnchor),
            motionPulseButton.centerYAnchor.constraint(equalTo: reefMotionStage.centerYAnchor),
            motionPulseButton.widthAnchor.constraint(equalToConstant: 68),
            motionPulseButton.heightAnchor.constraint(equalToConstant: 68),

            shellHeartButton.topAnchor.constraint(equalTo: reefMotionStage.bottomAnchor, constant: 12),
            shellHeartButton.leadingAnchor.constraint(equalTo: reefMotionStage.leadingAnchor, constant: 8),
            shellHeartButton.widthAnchor.constraint(equalToConstant: 32),
            shellHeartButton.heightAnchor.constraint(equalToConstant: 30),
            shellHeartCountLabel.topAnchor.constraint(equalTo: shellHeartButton.bottomAnchor, constant: -2),
            shellHeartCountLabel.centerXAnchor.constraint(equalTo: shellHeartButton.centerXAnchor),

            shoreReplyButton.topAnchor.constraint(equalTo: shellHeartButton.topAnchor),
            shoreReplyButton.leadingAnchor.constraint(equalTo: shellHeartButton.trailingAnchor, constant: 34),
            shoreReplyButton.widthAnchor.constraint(equalToConstant: 32),
            shoreReplyButton.heightAnchor.constraint(equalToConstant: 30),
            shoreReplyCountLabel.topAnchor.constraint(equalTo: shoreReplyButton.bottomAnchor, constant: -2),
            shoreReplyCountLabel.centerXAnchor.constraint(equalTo: shoreReplyButton.centerXAnchor),

            shoreReplyDock.topAnchor.constraint(equalTo: reefMotionStage.bottomAnchor, constant: 14),
            shoreReplyDock.leadingAnchor.constraint(equalTo: shoreReplyButton.trailingAnchor, constant: 28),
            shoreReplyDock.trailingAnchor.constraint(equalTo: reefMotionStage.trailingAnchor, constant: -4),
            shoreReplyDock.heightAnchor.constraint(equalToConstant: 38),
            shoreReplyDock.bottomAnchor.constraint(equalTo: shorelineCard.bottomAnchor, constant: -18),
            shoreReplyHintLabel.leadingAnchor.constraint(equalTo: shoreReplyDock.leadingAnchor, constant: 14),
            shoreReplyHintLabel.centerYAnchor.constraint(equalTo: shoreReplyDock.centerYAnchor),
            reefSendMarkView.trailingAnchor.constraint(equalTo: shoreReplyDock.trailingAnchor, constant: -14),
            reefSendMarkView.centerYAnchor.constraint(equalTo: shoreReplyDock.centerYAnchor),
            reefSendMarkView.widthAnchor.constraint(equalToConstant: 18),
            reefSendMarkView.heightAnchor.constraint(equalToConstant: 18),
            shoreReplyHintLabel.trailingAnchor.constraint(lessThanOrEqualTo: reefSendMarkView.leadingAnchor, constant: -8)
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
        lagoonFollowButton.alpha = shorelineShell.driftwoodPalette ? 0.55 : 1
        harborFlagButton.tintColor = shorelineShell.coastalChic ? UIColor(red: 1, green: 0.42, blue: 0.38, alpha: 1) : UIColor(red: 0.50, green: 0.50, blue: 0.50, alpha: 1)
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
        reefLayer.setValue("resizeAspectFill", forKey: ["vid", "eoGravity"].joined())
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
