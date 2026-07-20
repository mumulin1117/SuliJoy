import UIKit

final class SuliJoyReefLaunchEntryController: SuliJoyTropicCanvasController {
    private enum ReefLaunchMeasure {
        static let shellSuliJoybackTop: CGFloat = 8
        static let shellBackSide: CGFloat = 18
        static let shellBackSize: CGFloat = 44
        static let tideScrollTop: CGFloat = 20
        static let coralContentTop: CGFloat = 12
        static let coralContentSide: CGFloat = 24
        static let coralContentBottom: CGFloat = -24
        static let entryStackGap: CGFloat = 16
    }

    private struct ReefLaunchEntry {
        let reefMarkName: String
        let shoreHeadline: String
        let tideCaption: String
        let coralMood: SuliJoyReefLaunchEntryCard.CoralMood
        let coveSelector: Selector
    }

    private struct ReefLaunchCrown {
        let shoreBackTap: UIButton
        let titleGlyph: UILabel
    }

    private let tideScroll = UIScrollView()
    private let coralCanvas = UIView()
    private let reefEntryStack = UIStackView()

    private var reefLaunchEntries: [ReefLaunchEntry] {
        [
            ReefLaunchEntry(reefMarkName: "pNhJottkoh.aotnW.frleMcFtjarnmgdlteu.uaknbgHlWerdy".suliJoyPalmUnfurled, shoreHeadline: "PXovsTtu dMZoJmReKnKtD".suliJoyPalmUnfurled, tideCaption: "SZhmaGrweQ yoUuPtKfHiDth gpshgoNtRoXsC KaznCds avsoqiecwet anooytMezsK.D".suliJoyPalmUnfurled, coralMood: .mist, coveSelector: #selector(openShoreMomentMaker)),
            ReefLaunchEntry(reefMarkName: "cwaeloeZnydBaZrw.vbeaKdZgSeh.BpplkuWsa".suliJoyPalmUnfurled, shoreHeadline: "CHrhevagtneA gEwvbexnStH".suliJoyPalmUnfurled, tideCaption: "HzoksHti VaC gcAonaesbttaalB MsRtTyZlweB tgxaUtchaeRrIiBnIgl.V".suliJoyPalmUnfurled, coralMood: .sunlit, coveSelector: #selector(openTideEventMaker)),
            ReefLaunchEntry(reefMarkName: "pvlfamyP.WrVewcAtNaVnhgxlaea.zfZiOlvlr".suliJoyPalmUnfurled, shoreHeadline: "PsozsCtD BCIlMinpC".suliJoyPalmUnfurled, tideCaption: "UZpGlpoPaKdw Jar SsJhVoarzts ZiVselXaEnpdV VsGtMymldeK Ecelrijpb.V".suliJoyPalmUnfurled, coralMood: .mist, coveSelector: #selector(openReefClipMaker))
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        assembleReefLaunchDock()
    }

    private func assembleReefLaunchDock() {
        let launchCrown = gatherReefLaunchCrown()
        tuneReefLaunchScroll()
        tuneReefLaunchStack()
        moorReefLaunchCrown(launchCrown)
        stitchReefLaunchCrown(launchCrown)
        growReefLaunchCards()
    }

    private func gatherReefLaunchCrown() -> ReefLaunchCrown {
        let shoreBackTap = UIButton(type: .system)
        shoreBackTap.translatesAutoresizingMaskIntoConstraints = false
        shoreBackTap.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        shoreBackTap.tintColor = .suliInk
        shoreBackTap.addTarget(self, action: #selector(sailBackToTabs), for: .touchUpInside)

        let titleGlyph = UILabel()
        titleGlyph.translatesAutoresizingMaskIntoConstraints = false
        titleGlyph.text = "PDukbOlbiusehm".suliJoyPalmUnfurled
        titleGlyph.font = UIFont.systemFont(ofSize: 28, weight: .black)
        titleGlyph.textColor = .suliInk
        titleGlyph.textAlignment = .center
        return ReefLaunchCrown(shoreBackTap: shoreBackTap, titleGlyph: titleGlyph)
    }

    private func tuneReefLaunchScroll() {
        tideScroll.translatesAutoresizingMaskIntoConstraints = false
        tideScroll.alwaysBounceVertical = true
        coralCanvas.translatesAutoresizingMaskIntoConstraints = false
    }

    private func tuneReefLaunchStack() {
        reefEntryStack.translatesAutoresizingMaskIntoConstraints = false
        reefEntryStack.axis = .vertical
        reefEntryStack.spacing = ReefLaunchMeasure.entryStackGap
    }

    private func moorReefLaunchCrown(_ launchCrown: ReefLaunchCrown) {
        view.addSubview(tideScroll)
        tideScroll.addSubview(coralCanvas)
        coralCanvas.addSubview(reefEntryStack)

        [launchCrown.shoreBackTap, launchCrown.titleGlyph].forEach { view.addSubview($0) }
    }

    private func stitchReefLaunchCrown(_ launchCrown: ReefLaunchCrown) {
        NSLayoutConstraint.activate([
            launchCrown.shoreBackTap.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ReefLaunchMeasure.shellSuliJoybackTop),
            launchCrown.shoreBackTap.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReefLaunchMeasure.shellBackSide),
            launchCrown.shoreBackTap.widthAnchor.constraint(equalToConstant: ReefLaunchMeasure.shellBackSize),
            launchCrown.shoreBackTap.heightAnchor.constraint(equalToConstant: ReefLaunchMeasure.shellBackSize),

            launchCrown.titleGlyph.centerYAnchor.constraint(equalTo: launchCrown.shoreBackTap.centerYAnchor),
            launchCrown.titleGlyph.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            launchCrown.titleGlyph.leadingAnchor.constraint(greaterThanOrEqualTo: launchCrown.shoreBackTap.trailingAnchor, constant: 12),
            launchCrown.titleGlyph.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -74),

            tideScroll.topAnchor.constraint(equalTo: launchCrown.shoreBackTap.bottomAnchor, constant: ReefLaunchMeasure.tideScrollTop),
            tideScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tideScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tideScroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            coralCanvas.topAnchor.constraint(equalTo: tideScroll.contentLayoutGuide.topAnchor),
            coralCanvas.leadingAnchor.constraint(equalTo: tideScroll.contentLayoutGuide.leadingAnchor),
            coralCanvas.trailingAnchor.constraint(equalTo: tideScroll.contentLayoutGuide.trailingAnchor),
            coralCanvas.bottomAnchor.constraint(equalTo: tideScroll.contentLayoutGuide.bottomAnchor),
            coralCanvas.widthAnchor.constraint(equalTo: tideScroll.frameLayoutGuide.widthAnchor),

            reefEntryStack.topAnchor.constraint(equalTo: coralCanvas.topAnchor, constant: ReefLaunchMeasure.coralContentTop),
            reefEntryStack.leadingAnchor.constraint(equalTo: coralCanvas.leadingAnchor, constant: ReefLaunchMeasure.coralContentSide),
            reefEntryStack.trailingAnchor.constraint(equalTo: coralCanvas.trailingAnchor, constant: -ReefLaunchMeasure.coralContentSide),
            reefEntryStack.bottomAnchor.constraint(lessThanOrEqualTo: coralCanvas.bottomAnchor, constant: ReefLaunchMeasure.coralContentBottom)
        ])
    }

    private func growReefLaunchCards() {
        reefLaunchEntries.forEach { reefEntry in
            let launchCard = SuliJoyReefLaunchEntryCard(reefMarkName: reefEntry.reefMarkName, shoreHeadline: reefEntry.shoreHeadline, tideCaption: reefEntry.tideCaption, coralMood: reefEntry.coralMood)
            launchCard.addTarget(self, action: reefEntry.coveSelector, for: .touchUpInside)
            reefEntryStack.addArrangedSubview(launchCard)
        }
    }

    @objc private func sailBackToTabs() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func openShoreMomentMaker() {
        navigationController?.pushViewController(SuliJoyReefMomentTideController(), animated: true)
    }

    @objc private func openTideEventMaker() {
        navigationController?.pushViewController(SuliJoyTideCurationDraftController(), animated: true)
    }

    @objc private func openReefClipMaker() {
        navigationController?.pushViewController(SuliJoyReefMotionTideController(), animated: true)
    }
}

private final class SuliJoyReefLaunchEntryCard: UIControl {
    enum CoralMood {
        case mist
        case sunlit
    }

    private enum ReefCardMeasure {
        static let coralRadius: CGFloat = 28
        static let cardFloor: CGFloat = 118
        static let markShellSize: CGFloat = 52
        static let markShellSide: CGFloat = 18
        static let reefSymbolSize: CGFloat = 26
        static let headlineTop: CGFloat = 24
        static let captionGap: CGFloat = 14
        static let tideArrowSide: CGFloat = -18
        static let tideArrowSize: CGFloat = 18
    }

    private struct ReefCardScene {
        let markShell: UIView
        let reefMarkGlyph: UIImageView
        let headlineGlyph: UILabel
        let captionGlyph: UILabel
        let tideArrowGlyph: UIImageView
    }

    private let sunwashLayer = CAGradientLayer()
    private let markShell = UIView()
    private let reefMarkGlyph = UIImageView()
    private let headlineGlyph = UILabel()
    private let captionGlyph = UILabel()
    private let tideArrowGlyph = UIImageView(image: UIImage(systemName: "chevron.right"))
    private let coralMood: CoralMood

    init(reefMarkName: String, shoreHeadline: String, tideCaption: String, coralMood: CoralMood) {
        self.coralMood = coralMood
        super.init(frame: .zero)
        assembleReefLaunchCard(reefMarkName: reefMarkName, shoreHeadline: shoreHeadline, tideCaption: tideCaption)
    }

    private func assembleReefLaunchCard(reefMarkName: String, shoreHeadline: String, tideCaption: String) {
        tuneReefCardShell()
        tuneSunwashIfNeeded()
        tuneMarkShell()
        tuneReefMark(reefMarkName)
        tuneHeadline(shoreHeadline)
        tuneCaption(tideCaption)
        tuneTideArrow()
        let reefScene = ReefCardScene(markShell: markShell, reefMarkGlyph: reefMarkGlyph, headlineGlyph: headlineGlyph, captionGlyph: captionGlyph, tideArrowGlyph: tideArrowGlyph)
        moorReefCardScene(reefScene)
        stitchReefCardScene(reefScene)
    }

    private func tuneReefCardShell() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = ReefCardMeasure.coralRadius
        layer.masksToBounds = true
        backgroundColor = .white.withAlphaComponent(coralMood == .mist ? 0.86 : 1)
    }

    private func tuneSunwashIfNeeded() {
        if coralMood == .sunlit {
            sunwashLayer.colors = [
                UIColor(red: 1, green: 0.58, blue: 0.35, alpha: 1).cgColor,
                UIColor(red: 1, green: 0.91, blue: 0.36, alpha: 1).cgColor,
                UIColor(red: 0.71, green: 1, blue: 0.70, alpha: 1).cgColor
            ]
            sunwashLayer.startPoint = CGPoint(x: 0, y: 0.5)
            sunwashLayer.endPoint = CGPoint(x: 1, y: 0.5)
            layer.insertSublayer(sunwashLayer, at: 0)
        }
    }

    private func tuneMarkShell() {
        markShell.translatesAutoresizingMaskIntoConstraints = false
        markShell.backgroundColor = coralMood == .sunlit ? .white.withAlphaComponent(0.92) : UIColor(red: 0.78, green: 0.31, blue: 1, alpha: 0.16)
        markShell.layer.cornerRadius = 26
        markShell.isUserInteractionEnabled = false
    }

    private func tuneReefMark(_ reefMarkName: String) {
        reefMarkGlyph.translatesAutoresizingMaskIntoConstraints = false
        reefMarkGlyph.image = UIImage(systemName: reefMarkName)
        reefMarkGlyph.tintColor = coralMood == .sunlit ? .suliInk : UIColor(red: 0.70, green: 0.20, blue: 0.95, alpha: 1)
        reefMarkGlyph.contentMode = .scaleAspectFit
        reefMarkGlyph.isUserInteractionEnabled = false
    }

    private func tuneHeadline(_ shoreHeadline: String) {
        headlineGlyph.translatesAutoresizingMaskIntoConstraints = false
        headlineGlyph.text = shoreHeadline
        headlineGlyph.font = UIFont.systemFont(ofSize: 22, weight: .black)
        headlineGlyph.textColor = .suliInk
        headlineGlyph.isUserInteractionEnabled = false
    }

    private func tuneCaption(_ tideCaption: String) {
        captionGlyph.translatesAutoresizingMaskIntoConstraints = false
        captionGlyph.text = tideCaption
        captionGlyph.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        captionGlyph.textColor = .suliMutedInk
        captionGlyph.numberOfLines = 2
        captionGlyph.isUserInteractionEnabled = false
    }

    private func tuneTideArrow() {
        tideArrowGlyph.translatesAutoresizingMaskIntoConstraints = false
        tideArrowGlyph.tintColor = .suliInk.withAlphaComponent(0.5)
        tideArrowGlyph.contentMode = .scaleAspectFit
        tideArrowGlyph.isUserInteractionEnabled = false
    }

    private func moorReefCardScene(_ reefScene: ReefCardScene) {
        addSubview(reefScene.markShell)
        reefScene.markShell.addSubview(reefScene.reefMarkGlyph)
        [reefScene.headlineGlyph, reefScene.captionGlyph, reefScene.tideArrowGlyph].forEach { addSubview($0) }
    }

    private func stitchReefCardScene(_ reefScene: ReefCardScene) {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: ReefCardMeasure.cardFloor),

            reefScene.markShell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ReefCardMeasure.markShellSide),
            reefScene.markShell.centerYAnchor.constraint(equalTo: centerYAnchor),
            reefScene.markShell.widthAnchor.constraint(equalToConstant: ReefCardMeasure.markShellSize),
            reefScene.markShell.heightAnchor.constraint(equalToConstant: ReefCardMeasure.markShellSize),

            reefScene.reefMarkGlyph.centerXAnchor.constraint(equalTo: reefScene.markShell.centerXAnchor),
            reefScene.reefMarkGlyph.centerYAnchor.constraint(equalTo: reefScene.markShell.centerYAnchor),
            reefScene.reefMarkGlyph.widthAnchor.constraint(equalToConstant: ReefCardMeasure.reefSymbolSize),
            reefScene.reefMarkGlyph.heightAnchor.constraint(equalToConstant: ReefCardMeasure.reefSymbolSize),

            reefScene.headlineGlyph.topAnchor.constraint(equalTo: topAnchor, constant: ReefCardMeasure.headlineTop),
            reefScene.headlineGlyph.leadingAnchor.constraint(equalTo: reefScene.markShell.trailingAnchor, constant: ReefCardMeasure.captionGap),
            reefScene.headlineGlyph.trailingAnchor.constraint(equalTo: reefScene.tideArrowGlyph.leadingAnchor, constant: -10),

            reefScene.captionGlyph.topAnchor.constraint(equalTo: reefScene.headlineGlyph.bottomAnchor, constant: 6),
            reefScene.captionGlyph.leadingAnchor.constraint(equalTo: reefScene.headlineGlyph.leadingAnchor),
            reefScene.captionGlyph.trailingAnchor.constraint(equalTo: reefScene.headlineGlyph.trailingAnchor),
            reefScene.captionGlyph.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -22),

            reefScene.tideArrowGlyph.centerYAnchor.constraint(equalTo: centerYAnchor),
            reefScene.tideArrowGlyph.trailingAnchor.constraint(equalTo: trailingAnchor, constant: ReefCardMeasure.tideArrowSide),
            reefScene.tideArrowGlyph.widthAnchor.constraint(equalToConstant: ReefCardMeasure.tideArrowSize),
            reefScene.tideArrowGlyph.heightAnchor.constraint(equalToConstant: ReefCardMeasure.tideArrowSize)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("iangiftg(xcqoodieArU:t)B phialsy SnMojtX gbIeueBnp HiymZpNlteJmxevnWtbeFdj".suliJoyPalmUnfurled)
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.16) {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
                self.alpha = self.isHighlighted ? 0.82 : 1
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        sunwashLayer.frame = bounds
    }
}
