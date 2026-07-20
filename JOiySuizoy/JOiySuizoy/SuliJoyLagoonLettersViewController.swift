import UIKit

final class SuliJoyLagoonLettersViewController: SuliJoyTropicCanvasController {
    private enum LagoonLetterMeasure {
        static let SuliJoybackTop: CGFloat = 14
        static let SuliJoybackLeading: CGFloat = 24
        static let backSize: CGFloat = 44
        static let titleSize: CGFloat = 29
        static let tideTop: CGFloat = 22
        static let cardSideInset: CGFloat = 24
        static let cardCornerRadius: CGFloat = 28
        static let cardVertical: CGFloat = 36
        static let cardLift: CGFloat = -36
        static let pearlMarkSize: CGFloat = 68
        static let pearlMarkTop: CGFloat = 32
        static let headlineTop: CGFloat = 22
        static let bodyTop: CGFloat = 10
        static let bottomInset: CGFloat = -32
    }

    private struct LagoonLetterScene {
        let backReefControl: UIButton
        let crownTitleLabel: UILabel
        let lagoonLetterScroll: UIScrollView
        let lagoonLetterCanvas: UIView
        let letterCardShell: UIView
        let pearlMarkShell: UIView
        let pearlMarkGlyph: UILabel
        let quietHeadlineLabel: UILabel
        let quietBodyLabel: UILabel
    }

    private let lagoonLetterScroll = UIScrollView()
    private let lagoonLetterCanvas = UIView()
    private let letterCardShell = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        raisePearlLetterCove()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    private func raisePearlLetterCove() {
        let pearlLetterScene = gatherPearlLetterScene()
        dockPearlLetterScene(pearlLetterScene)
        lacePearlLetterLayout(pearlLetterScene)
    }

    private func gatherPearlLetterScene() -> LagoonLetterScene {
        let backReefControl = makeLagoonBackReefControl()
        let crownTitleLabel = makeLagoonLetterTitleLabel()
        tuneLagoonLetterScroll()
        tuneLagoonLetterCanvas()
        tuneLetterCardShell()
        let pearlMarkShell = makePearlMarkShell()
        let pearlMarkGlyph = makePearlMarkGlyph()
        let quietHeadlineLabel = makeQuietHeadlineLabel()
        let quietBodyLabel = makeQuietBodyLabel()

        return LagoonLetterScene(
            backReefControl: backReefControl,
            crownTitleLabel: crownTitleLabel,
            lagoonLetterScroll: lagoonLetterScroll,
            lagoonLetterCanvas: lagoonLetterCanvas,
            letterCardShell: letterCardShell,
            pearlMarkShell: pearlMarkShell,
            pearlMarkGlyph: pearlMarkGlyph,
            quietHeadlineLabel: quietHeadlineLabel,
            quietBodyLabel: quietBodyLabel
        )
    }

    private func makeLagoonBackReefControl() -> UIButton {
        let backReefControl = UIButton(type: .system)
        backReefControl.translatesAutoresizingMaskIntoConstraints = false
        backReefControl.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backReefControl.tintColor = .suliInk
        backReefControl.addTarget(self, action: #selector(driftSuliJoybackTopriorCove), for: .touchUpInside)
        return backReefControl
    }

    private func makeLagoonLetterTitleLabel() -> UILabel {
        let crownTitleLabel = UILabel()
        crownTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        crownTitleLabel.text = "MdezsHsgaQgeecsW".suliJoyPalmUnfurled
        crownTitleLabel.textColor = .suliInk
        crownTitleLabel.font = UIFont.systemFont(ofSize: LagoonLetterMeasure.titleSize, weight: .black)
        crownTitleLabel.textAlignment = .center
        crownTitleLabel.adjustsFontSizeToFitWidth = true
        crownTitleLabel.minimumScaleFactor = 0.78
        return crownTitleLabel
    }

    private func tuneLagoonLetterScroll() {
        lagoonLetterScroll.translatesAutoresizingMaskIntoConstraints = false
        lagoonLetterScroll.alwaysBounceVertical = true
        lagoonLetterScroll.showsVerticalScrollIndicator = false
    }

    private func tuneLagoonLetterCanvas() {
        lagoonLetterCanvas.translatesAutoresizingMaskIntoConstraints = false
    }

    private func tuneLetterCardShell() {
        letterCardShell.translatesAutoresizingMaskIntoConstraints = false
        letterCardShell.backgroundColor = UIColor.white.withAlphaComponent(0.58)
        letterCardShell.layer.cornerRadius = LagoonLetterMeasure.cardCornerRadius
        letterCardShell.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        letterCardShell.layer.shadowOpacity = 1
        letterCardShell.layer.shadowRadius = 16
        letterCardShell.layer.shadowOffset = CGSize(width: 0, height: 8)
    }

    private func makePearlMarkShell() -> UIView {
        let pearlMarkShell = UIView()
        pearlMarkShell.translatesAutoresizingMaskIntoConstraints = false
        pearlMarkShell.backgroundColor = UIColor.white.withAlphaComponent(0.86)
        pearlMarkShell.layer.cornerRadius = LagoonLetterMeasure.pearlMarkSize / 2
        return pearlMarkShell
    }

    private func makePearlMarkGlyph() -> UILabel {
        let pearlMarkGlyph = UILabel()
        pearlMarkGlyph.translatesAutoresizingMaskIntoConstraints = false
        pearlMarkGlyph.text = "✉"
        pearlMarkGlyph.textAlignment = .center
        pearlMarkGlyph.font = UIFont.systemFont(ofSize: 32, weight: .black)
        pearlMarkGlyph.textColor = UIColor(red: 0.23, green: 0.16, blue: 0.04, alpha: 1)
        return pearlMarkGlyph
    }

    private func makeQuietHeadlineLabel() -> UILabel {
        let quietHeadlineLabel = UILabel()
        quietHeadlineLabel.translatesAutoresizingMaskIntoConstraints = false
        quietHeadlineLabel.text = "Nuoy tfvrvineBnydj BmDeTsesLaegpeH qnMoTtLirfYiDcmaLtEiHoGnwsa Pyxeltu.s".suliJoyPalmUnfurled
        quietHeadlineLabel.textColor = .suliInk
        quietHeadlineLabel.font = UIFont.systemFont(ofSize: 20, weight: .black)
        quietHeadlineLabel.textAlignment = .center
        quietHeadlineLabel.numberOfLines = 0
        return quietHeadlineLabel
    }

    private func makeQuietBodyLabel() -> UILabel {
        let quietBodyLabel = UILabel()
        quietBodyLabel.translatesAutoresizingMaskIntoConstraints = false
        quietBodyLabel.text = "MpuVtoufadlW-afQorlJlVotwR pcCheaNtZsw masnUdw KiQsmlAalnpdl msztIyhlQez UuhpudHaetXeksO Twfizlqll PaXpgpXemaGrN whIecrPei.U".suliJoyPalmUnfurled
        quietBodyLabel.textColor = .suliMutedInk
        quietBodyLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        quietBodyLabel.textAlignment = .center
        quietBodyLabel.numberOfLines = 0
        return quietBodyLabel
    }

    private func dockPearlLetterScene(_ scene: LagoonLetterScene) {
        scene.pearlMarkShell.addSubview(scene.pearlMarkGlyph)
        scene.letterCardShell.addSubview(scene.pearlMarkShell)
        scene.letterCardShell.addSubview(scene.quietHeadlineLabel)
        scene.letterCardShell.addSubview(scene.quietBodyLabel)

        view.addSubview(scene.backReefControl)
        view.addSubview(scene.crownTitleLabel)
        view.addSubview(scene.lagoonLetterScroll)
        scene.lagoonLetterScroll.addSubview(scene.lagoonLetterCanvas)
        scene.lagoonLetterCanvas.addSubview(scene.letterCardShell)
    }

    private func lacePearlLetterLayout(_ scene: LagoonLetterScene) {
        NSLayoutConstraint.activate([
            scene.backReefControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: LagoonLetterMeasure.SuliJoybackTop),
            scene.backReefControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LagoonLetterMeasure.SuliJoybackLeading),
            scene.backReefControl.widthAnchor.constraint(equalToConstant: LagoonLetterMeasure.backSize),
            scene.backReefControl.heightAnchor.constraint(equalToConstant: LagoonLetterMeasure.backSize),

            scene.crownTitleLabel.centerYAnchor.constraint(equalTo: scene.backReefControl.centerYAnchor),
            scene.crownTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scene.crownTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: scene.backReefControl.trailingAnchor, constant: 12),
            scene.crownTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -68),

            scene.lagoonLetterScroll.topAnchor.constraint(equalTo: scene.backReefControl.bottomAnchor, constant: LagoonLetterMeasure.tideTop),
            scene.lagoonLetterScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scene.lagoonLetterScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scene.lagoonLetterScroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            scene.lagoonLetterCanvas.topAnchor.constraint(equalTo: scene.lagoonLetterScroll.contentLayoutGuide.topAnchor),
            scene.lagoonLetterCanvas.leadingAnchor.constraint(equalTo: scene.lagoonLetterScroll.contentLayoutGuide.leadingAnchor),
            scene.lagoonLetterCanvas.trailingAnchor.constraint(equalTo: scene.lagoonLetterScroll.contentLayoutGuide.trailingAnchor),
            scene.lagoonLetterCanvas.bottomAnchor.constraint(equalTo: scene.lagoonLetterScroll.contentLayoutGuide.bottomAnchor),
            scene.lagoonLetterCanvas.widthAnchor.constraint(equalTo: scene.lagoonLetterScroll.frameLayoutGuide.widthAnchor),
            scene.lagoonLetterCanvas.heightAnchor.constraint(greaterThanOrEqualTo: scene.lagoonLetterScroll.frameLayoutGuide.heightAnchor),

            scene.letterCardShell.leadingAnchor.constraint(equalTo: scene.lagoonLetterCanvas.leadingAnchor, constant: LagoonLetterMeasure.cardSideInset),
            scene.letterCardShell.trailingAnchor.constraint(equalTo: scene.lagoonLetterCanvas.trailingAnchor, constant: -LagoonLetterMeasure.cardSideInset),
            scene.letterCardShell.centerYAnchor.constraint(equalTo: scene.lagoonLetterCanvas.centerYAnchor, constant: LagoonLetterMeasure.cardLift),
            scene.letterCardShell.topAnchor.constraint(greaterThanOrEqualTo: scene.lagoonLetterCanvas.topAnchor, constant: LagoonLetterMeasure.cardVertical),
            scene.letterCardShell.bottomAnchor.constraint(lessThanOrEqualTo: scene.lagoonLetterCanvas.bottomAnchor, constant: -LagoonLetterMeasure.cardVertical),

            scene.pearlMarkShell.topAnchor.constraint(equalTo: scene.letterCardShell.topAnchor, constant: LagoonLetterMeasure.pearlMarkTop),
            scene.pearlMarkShell.centerXAnchor.constraint(equalTo: scene.letterCardShell.centerXAnchor),
            scene.pearlMarkShell.widthAnchor.constraint(equalToConstant: LagoonLetterMeasure.pearlMarkSize),
            scene.pearlMarkShell.heightAnchor.constraint(equalToConstant: LagoonLetterMeasure.pearlMarkSize),
            scene.pearlMarkGlyph.centerXAnchor.constraint(equalTo: scene.pearlMarkShell.centerXAnchor),
            scene.pearlMarkGlyph.centerYAnchor.constraint(equalTo: scene.pearlMarkShell.centerYAnchor),

            scene.quietHeadlineLabel.topAnchor.constraint(equalTo: scene.pearlMarkShell.bottomAnchor, constant: LagoonLetterMeasure.headlineTop),
            scene.quietHeadlineLabel.leadingAnchor.constraint(equalTo: scene.letterCardShell.leadingAnchor, constant: LagoonLetterMeasure.cardSideInset),
            scene.quietHeadlineLabel.trailingAnchor.constraint(equalTo: scene.letterCardShell.trailingAnchor, constant: -LagoonLetterMeasure.cardSideInset),

            scene.quietBodyLabel.topAnchor.constraint(equalTo: scene.quietHeadlineLabel.bottomAnchor, constant: LagoonLetterMeasure.bodyTop),
            scene.quietBodyLabel.leadingAnchor.constraint(equalTo: scene.letterCardShell.leadingAnchor, constant: 28),
            scene.quietBodyLabel.trailingAnchor.constraint(equalTo: scene.letterCardShell.trailingAnchor, constant: -28),
            scene.quietBodyLabel.bottomAnchor.constraint(equalTo: scene.letterCardShell.bottomAnchor, constant: LagoonLetterMeasure.bottomInset)
        ])
    }

    @objc private func driftSuliJoybackTopriorCove() {
        navigationController?.popViewController(animated: true)
    }
}
