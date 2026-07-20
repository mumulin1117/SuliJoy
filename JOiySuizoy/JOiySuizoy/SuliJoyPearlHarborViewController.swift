import UIKit

final class SuliJoyPearlHarborViewController: SuliJoyTropicCanvasController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private enum PearlHarborMetric {
        static let rowGap: CGFloat = 12
        static let lineGap: CGFloat = 14
        static let shelfTop: CGFloat = 16
        static let shelfSide: CGFloat = 18
        static let shelfBottom: CGFloat = 30
        static let returnTop: CGFloat = 8
        static let returnLeading: CGFloat = 18
        static let returnSize: CGFloat = 44
        static let heroTop: CGFloat = 24
        static let heroSide: CGFloat = 24
        static let heroHeight: CGFloat = 136
        static let heroRadius: CGFloat = 26
        static let gemLeading: CGFloat = 26
        static let gemLift: CGFloat = -8
        static let gemScale: CGFloat = 0.72
        static let totalLeading: CGFloat = 18
        static let totalTrailing: CGFloat = -22
        static let totalTop: CGFloat = 50
        static let hintTop: CGFloat = 10
        static let hintSide: CGFloat = 26
        static let gridTop: CGFloat = 4
        static let shelfHeight: CGFloat = 170
        static let shelfMinimumWidth: CGFloat = 92
    }

    private struct PearlHarborScene {
        let returnControl: UIButton
        let titleView: UILabel
        let heroPanel: UIView
        let sunriseWash: UIView
        let gemMark: UIImageView
        let shoreCaption: UILabel
        let hintView: UILabel
        let shelfGrid: UICollectionView
    }

    private let shellTotalLabel = UILabel()
    private let harborHintLabel = UILabel()
    private let pearlGridView: UICollectionView
    private var pearlShelves: [SuliJoyPearlShoreBundle] = SuliJoyPearlHarborBridge.fallbackShelves
    private var harborShelfReady = false
    private var activeReefToken: String?

    init() {
        let pearlFlow = Self.makePearlFlow()
        pearlGridView = UICollectionView(frame: .zero, collectionViewLayout: pearlFlow)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    private static func makePearlFlow() -> UICollectionViewFlowLayout {
        let pearlFlow = UICollectionViewFlowLayout()
        pearlFlow.minimumInteritemSpacing = PearlHarborMetric.rowGap
        pearlFlow.minimumLineSpacing = PearlHarborMetric.lineGap
        pearlFlow.sectionInset = UIEdgeInsets(
            top: PearlHarborMetric.shelfTop,
            left: PearlHarborMetric.shelfSide,
            bottom: PearlHarborMetric.shelfBottom,
            right: PearlHarborMetric.shelfSide
        )
        return pearlFlow
    }

    required init?(coder: NSCoder) {
        fatalError("iJnAivtT(kcRoKdQejrz:k)q lhRaEsu Cnnoqtw ZbkejegnQ minmgpiltevmQeJnmtAeUdV".suliJoyPalmUnfurled)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        arrangePearlHarborScene()
        refreshShellTotal()
        gatherPearlShelves()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshShellTotal()
    }

    private func arrangePearlHarborScene() {
        let harborScene = harvestPearlHarborScene()
        moorPearlHarborScene(harborScene)
        stitchPearlHarborScene(harborScene)
    }

    private func harvestPearlHarborScene() -> PearlHarborScene {
        let coveBackControl = makeCoveBackControl()
        let harborTitle = makeHarborTitle()
        let shellHeroPanel = makeShellHeroPanel()
        let sunriseWash = makeSunriseWash()
        let gemstoneMark = makeGemstoneMark()
        let shoreCaption = makeShoreCaption()
        tuneShellTotalLabel()
        tuneHarborHintLabel()
        tunePearlGridView()
        return PearlHarborScene(
            returnControl: coveBackControl,
            titleView: harborTitle,
            heroPanel: shellHeroPanel,
            sunriseWash: sunriseWash,
            gemMark: gemstoneMark,
            shoreCaption: shoreCaption,
            hintView: harborHintLabel,
            shelfGrid: pearlGridView
        )
    }

    private func makeCoveBackControl() -> UIButton {
        let coveBackControl = UIButton(type: .system)
        coveBackControl.translatesAutoresizingMaskIntoConstraints = false
        coveBackControl.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        coveBackControl.tintColor = .black
        coveBackControl.addTarget(self, action: #selector(returnToIslandCove), for: .touchUpInside)
        return coveBackControl
    }

    private func makeHarborTitle() -> UILabel {
        let harborTitle = UILabel()
        harborTitle.translatesAutoresizingMaskIntoConstraints = false
        harborTitle.text = ["MyyT p".suliJoyPalmUnfurled, "wSajlk".suliJoyPalmUnfurled, "lPeWtb".suliJoyPalmUnfurled].joined()
        harborTitle.font = UIFont.systemFont(ofSize: 30, weight: .black)
        harborTitle.textColor = .black
        harborTitle.textAlignment = .center
        return harborTitle
    }

    private func makeShellHeroPanel() -> UIView {
        let shellHeroPanel = UIView()
        shellHeroPanel.translatesAutoresizingMaskIntoConstraints = false
        shellHeroPanel.layer.cornerRadius = PearlHarborMetric.heroRadius
        shellHeroPanel.clipsToBounds = true
        return shellHeroPanel
    }

    private func makeSunriseWash() -> UIView {
        SuliJoyGradientCapsuleView(colors: [
            UIColor(red: 1, green: 0.36, blue: 0.51, alpha: 1),
            UIColor(red: 1, green: 0.67, blue: 0.35, alpha: 1)
        ])
    }

    private func makeGemstoneMark() -> UIImageView {
        let gemstoneMark = UIImageView(image: UIImage(named: ["sulijoy", "_wal", "let_gem_large"].joined()))
        gemstoneMark.translatesAutoresizingMaskIntoConstraints = false
        gemstoneMark.contentMode = .scaleAspectFit
        return gemstoneMark
    }

    private func makeShoreCaption() -> UILabel {
        let shoreCaption = UILabel()
        shoreCaption.translatesAutoresizingMaskIntoConstraints = false
        shoreCaption.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        shoreCaption.textColor = .white
        return shoreCaption
    }

    private func tuneShellTotalLabel() {
        shellTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        shellTotalLabel.font = UIFont.systemFont(ofSize: 32, weight: .black)
        shellTotalLabel.textColor = .white
        shellTotalLabel.adjustsFontSizeToFitWidth = true
        shellTotalLabel.minimumScaleFactor = 0.55
    }

    private func tuneHarborHintLabel() {
        harborHintLabel.translatesAutoresizingMaskIntoConstraints = false
        harborHintLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        harborHintLabel.textColor = .suliMutedInk
        harborHintLabel.textAlignment = .center
        harborHintLabel.numberOfLines = 0
    }

    private func tunePearlGridView() {
        pearlGridView.translatesAutoresizingMaskIntoConstraints = false
        pearlGridView.backgroundColor = .clear
        pearlGridView.dataSource = self
        pearlGridView.delegate = self
        pearlGridView.alwaysBounceVertical = true
        pearlGridView.register(SuliJoyPearlPackCell.self, forCellWithReuseIdentifier: "SuliJoyPearlPackCell")
    }

    private func moorPearlHarborScene(_ scene: PearlHarborScene) {
        scene.heroPanel.addSubview(scene.sunriseWash)
        scene.heroPanel.addSubview(scene.gemMark)
        scene.heroPanel.addSubview(shellTotalLabel)
        scene.heroPanel.addSubview(scene.shoreCaption)
        scene.sunriseWash.suliPinEdges(to: scene.heroPanel)

        [scene.returnControl, scene.titleView, scene.heroPanel, scene.hintView, scene.shelfGrid].forEach { view.addSubview($0) }
    }

    private func stitchPearlHarborScene(_ scene: PearlHarborScene) {
        NSLayoutConstraint.activate([
            scene.returnControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: PearlHarborMetric.returnTop),
            scene.returnControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PearlHarborMetric.returnLeading),
            scene.returnControl.widthAnchor.constraint(equalToConstant: PearlHarborMetric.returnSize),
            scene.returnControl.heightAnchor.constraint(equalToConstant: PearlHarborMetric.returnSize),
            scene.titleView.centerYAnchor.constraint(equalTo: scene.returnControl.centerYAnchor),
            scene.titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scene.titleView.leadingAnchor.constraint(greaterThanOrEqualTo: scene.returnControl.trailingAnchor, constant: PearlHarborMetric.rowGap),

            scene.heroPanel.topAnchor.constraint(equalTo: scene.returnControl.bottomAnchor, constant: PearlHarborMetric.heroTop),
            scene.heroPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PearlHarborMetric.heroSide),
            scene.heroPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PearlHarborMetric.heroSide),
            scene.heroPanel.heightAnchor.constraint(equalToConstant: PearlHarborMetric.heroHeight),
            scene.gemMark.leadingAnchor.constraint(equalTo: scene.heroPanel.leadingAnchor, constant: PearlHarborMetric.gemLeading),
            scene.gemMark.centerYAnchor.constraint(equalTo: scene.heroPanel.centerYAnchor, constant: PearlHarborMetric.gemLift),
            scene.gemMark.widthAnchor.constraint(equalTo: scene.heroPanel.heightAnchor, multiplier: PearlHarborMetric.gemScale),
            scene.gemMark.heightAnchor.constraint(equalTo: scene.gemMark.widthAnchor),
            shellTotalLabel.leadingAnchor.constraint(equalTo: scene.gemMark.trailingAnchor, constant: PearlHarborMetric.totalLeading),
            shellTotalLabel.trailingAnchor.constraint(equalTo: scene.heroPanel.trailingAnchor, constant: PearlHarborMetric.totalTrailing),
            shellTotalLabel.topAnchor.constraint(equalTo: scene.heroPanel.topAnchor, constant: PearlHarborMetric.totalTop),
            scene.shoreCaption.leadingAnchor.constraint(equalTo: shellTotalLabel.leadingAnchor),
            scene.shoreCaption.topAnchor.constraint(equalTo: shellTotalLabel.bottomAnchor, constant: PearlHarborMetric.returnTop),
            scene.shoreCaption.trailingAnchor.constraint(equalTo: shellTotalLabel.trailingAnchor),

            scene.hintView.topAnchor.constraint(equalTo: scene.heroPanel.bottomAnchor, constant: PearlHarborMetric.hintTop),
            scene.hintView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PearlHarborMetric.hintSide),
            scene.hintView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -PearlHarborMetric.hintSide),

            scene.shelfGrid.topAnchor.constraint(equalTo: scene.hintView.bottomAnchor, constant: PearlHarborMetric.gridTop),
            scene.shelfGrid.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scene.shelfGrid.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scene.shelfGrid.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func refreshShellTotal() {
        shellTotalLabel.text = "\(SuliJoyPearlHarborBridge.currentShellTotal())"
    }

    private func gatherPearlShelves() {
        harborHintLabel.text = "LDokaNdjiVndgN ySltfoBrOeTKkiOtC NpYrNocdeuicOtKsV.S.U.W".suliJoyPalmUnfurled
        Task { [weak self] in
            let harborAnswer = await SuliJoyPearlHarborBridge.gatherShelves()
            guard let self else { return }
            if harborAnswer.code == 200, let shelves = harborAnswer.cargo {
                self.harborShelfReady = true
                self.pearlShelves = shelves
                self.harborHintLabel.text = ""
            } else {
                self.harborShelfReady = false
                self.pearlShelves = SuliJoyPearlHarborBridge.fallbackShelves
                self.harborHintLabel.text = harborAnswer.note
                self.showLagoonToast(harborAnswer.note)
            }
            self.pearlGridView.reloadData()
        }
    }

    func collectionView(_ shoreGrid: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pearlShelves.count
    }

    func collectionView(_ shoreGrid: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pearlCell = shoreGrid.dequeueReusableCell(withReuseIdentifier: "SuliJoyPearlPackCell", for: indexPath) as! SuliJoyPearlPackCell
        let shoreBundle = pearlShelves[indexPath.item]
        tunePearlCell(pearlCell, with: shoreBundle)
        return pearlCell
    }

    private func tunePearlCell(_ pearlCell: SuliJoyPearlPackCell, with shoreBundle: SuliJoyPearlShoreBundle) {
        pearlCell.configure(
            shoreBundle: shoreBundle,
            isEnabled: harborShelfReady && activeReefToken == nil,
            isLoading: activeReefToken == shoreBundle.reefToken
        )
        pearlCell.onSunTap = { [weak self] in
            self?.openPearlHarbor(for: shoreBundle)
        }
    }

    func collectionView(_ shoreGrid: UICollectionView, layout shoreLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gridWidth = shoreGrid.bounds.width
        let usableWidth = gridWidth - 36 - 24
        let shelfWidth = floor(usableWidth / 3)
        return CGSize(width: max(PearlHarborMetric.shelfMinimumWidth, shelfWidth), height: PearlHarborMetric.shelfHeight)
    }

    private func openPearlHarbor(for shoreBundle: SuliJoyPearlShoreBundle) {
        guard harborShelfReady, activeReefToken == nil else { return }
        activeReefToken = shoreBundle.reefToken
        pearlGridView.reloadData()
        Task { [weak self] in
            let harborAnswer = await SuliJoyPearlHarborBridge.openHarbor(for: shoreBundle)
            guard let self else { return }
            self.activeReefToken = nil
            switch harborAnswer.cargo {
            case .settled:
                self.refreshShellTotal()
                self.showLagoonToast("RKercBhRairmgleK EcXohmWpAlTeOtweUdj.r".suliJoyPalmUnfurled)
            case .backedOut:
                self.showLagoonToast(["PmuOrW".suliJoyPalmUnfurled, "cxheahsQee SctaOnBcSeelFleeNdz.b".suliJoyPalmUnfurled].joined())
            case .waiting:
                self.showLagoonToast(["PCuirI".suliJoyPalmUnfurled, "cMhAacsnec zpJeJnJdgiunDgL.u".suliJoyPalmUnfurled].joined())
            case .missing:
                self.showLagoonToast(harborAnswer.note)
            case .none:
                self.showLagoonToast(harborAnswer.note)
            }
            self.pearlGridView.reloadData()
        }
    }

    @objc private func returnToIslandCove() {
        navigationController?.popViewController(animated: true)
    }
}

private final class SuliJoyPearlPackCell: UICollectionViewCell {
    private enum PearlTileMetric {
        static let corner: CGFloat = 20
        static let border: CGFloat = 3
        static let gemTop: CGFloat = 16
        static let gemSize: CGFloat = 24
        static let countTop: CGFloat = 14
        static let countSide: CGFloat = 8
        static let dividerTop: CGFloat = 8
        static let dividerSide: CGFloat = 18
        static let dividerHeight: CGFloat = 1
        static let tideTop: CGFloat = 8
        static let buttonSide: CGFloat = 10
        static let buttonBottom: CGFloat = -10
        static let buttonHeight: CGFloat = 40
    }

    private struct PearlTileScene {
        let gemMark: UIImageView
        let shellText: UILabel
        let reefLine: UIView
        let tideText: UILabel
        let sunControl: SuliJoyGradientButton
    }

    var onSunTap: (() -> Void)?
    private let gemView = UIImageView(image: UIImage(named: ["sulijoy", "_wal", "let_gem_small"].joined()))
    private let shellCountLabel = UILabel()
    private let tideTagLabel = UILabel()
    private let sunBloomButton = SuliJoyGradientButton(reefHeadline: "RWetczhyaCrEgheb".suliJoyPalmUnfurled)

    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangePearlTileScene()
    }

    required init?(coder: NSCoder) {
        fatalError("iPnyiqtE(lcEordNeXrN:m)S BhPaYsz BneoitU ebRejennk tiFmBpzlqeNmdeLnntIetdZ".suliJoyPalmUnfurled)
    }

    private func arrangePearlTileScene() {
        tunePearlTileShell()
        let tileScene = harvestPearlTileScene()
        moorPearlTileScene(tileScene)
        stitchPearlTileScene(tileScene)
    }

    private func tunePearlTileShell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = PearlTileMetric.corner
        contentView.layer.borderWidth = PearlTileMetric.border
        contentView.layer.borderColor = UIColor(red: 1, green: 0.66, blue: 0.41, alpha: 1).cgColor
        contentView.clipsToBounds = true
    }

    private func harvestPearlTileScene() -> PearlTileScene {
        tuneGemView()
        tuneShellCountLabel()
        let shellDivider = makeShellDivider()
        tuneTideTagLabel()
        tuneSunBloomButton()
        return PearlTileScene(
            gemMark: gemView,
            shellText: shellCountLabel,
            reefLine: shellDivider,
            tideText: tideTagLabel,
            sunControl: sunBloomButton
        )
    }

    private func tuneGemView() {
        gemView.translatesAutoresizingMaskIntoConstraints = false
        gemView.contentMode = .scaleAspectFit
    }

    private func tuneShellCountLabel() {
        shellCountLabel.translatesAutoresizingMaskIntoConstraints = false
        shellCountLabel.font = UIFont.systemFont(ofSize: 18, weight: .black)
        shellCountLabel.textColor = UIColor(red: 0.21, green: 0.27, blue: 0.02, alpha: 1)
        shellCountLabel.textAlignment = .center
        shellCountLabel.adjustsFontSizeToFitWidth = true
    }

    private func makeShellDivider() -> UIView {
        let shellDivider = UIView()
        shellDivider.translatesAutoresizingMaskIntoConstraints = false
        shellDivider.backgroundColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1)
        return shellDivider
    }

    private func tuneTideTagLabel() {
        tideTagLabel.translatesAutoresizingMaskIntoConstraints = false
        tideTagLabel.font = UIFont.systemFont(ofSize: 14, weight: .black)
        tideTagLabel.textColor = shellCountLabel.textColor
        tideTagLabel.textAlignment = .center
    }

    private func tuneSunBloomButton() {
        sunBloomButton.translatesAutoresizingMaskIntoConstraints = false
        sunBloomButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        sunBloomButton.addTarget(self, action: #selector(tapSunBloom), for: .touchUpInside)
    }

    private func moorPearlTileScene(_ scene: PearlTileScene) {
        [scene.gemMark, scene.shellText, scene.reefLine, scene.tideText, scene.sunControl].forEach { contentView.addSubview($0) }
    }

    private func stitchPearlTileScene(_ scene: PearlTileScene) {
        NSLayoutConstraint.activate([
            scene.gemMark.topAnchor.constraint(equalTo: contentView.topAnchor, constant: PearlTileMetric.gemTop),
            scene.gemMark.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            scene.gemMark.widthAnchor.constraint(equalToConstant: PearlTileMetric.gemSize),
            scene.gemMark.heightAnchor.constraint(equalToConstant: PearlTileMetric.gemSize),
            scene.shellText.topAnchor.constraint(equalTo: scene.gemMark.bottomAnchor, constant: PearlTileMetric.countTop),
            scene.shellText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: PearlTileMetric.countSide),
            scene.shellText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -PearlTileMetric.countSide),
            scene.reefLine.topAnchor.constraint(equalTo: scene.shellText.bottomAnchor, constant: PearlTileMetric.dividerTop),
            scene.reefLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: PearlTileMetric.dividerSide),
            scene.reefLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -PearlTileMetric.dividerSide),
            scene.reefLine.heightAnchor.constraint(equalToConstant: PearlTileMetric.dividerHeight),
            scene.tideText.topAnchor.constraint(equalTo: scene.reefLine.bottomAnchor, constant: PearlTileMetric.tideTop),
            scene.tideText.leadingAnchor.constraint(equalTo: scene.shellText.leadingAnchor),
            scene.tideText.trailingAnchor.constraint(equalTo: scene.shellText.trailingAnchor),
            scene.sunControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: PearlTileMetric.buttonSide),
            scene.sunControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -PearlTileMetric.buttonSide),
            scene.sunControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: PearlTileMetric.buttonBottom),
            scene.sunControl.heightAnchor.constraint(equalToConstant: PearlTileMetric.buttonHeight)
        ])
    }

    func configure(shoreBundle: SuliJoyPearlShoreBundle, isEnabled: Bool, isLoading: Bool) {
        shellCountLabel.text = shoreBundle.shellText
        tideTagLabel.text = shoreBundle.tideText
        sunBloomButton.isLoading = isLoading
        sunBloomButton.isEnabled = isEnabled && !isLoading
        sunBloomButton.alpha = isEnabled || isLoading ? 1 : 0.45
    }

    @objc private func tapSunBloom() {
        onSunTap?()
    }
}
