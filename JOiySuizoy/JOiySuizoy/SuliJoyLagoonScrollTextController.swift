import UIKit

struct SuliJoyLagoonClause {
    let reefHeadline: String
    let body: String
}

final class SuliJoyLagoonScrollTextController: UIViewController {
    private enum LagoonScrollTextMeasure {
        static let SuliJoybackTop: CGFloat = 18
        static let SuliJoybackLeading: CGFloat = 18
        static let backSize: CGFloat = 44
        static let titleGap: CGFloat = 12
        static let titleTrailing: CGFloat = -62
        static let scrollTop: CGFloat = 28
        static let stackSide: CGFloat = 30
        static let stackBottom: CGFloat = -30
        static let stackGap: CGFloat = 22
        static let sectionGap: CGFloat = 10
    }

    private struct LagoonScrollTextScene {
        let backShell: UIButton
        let crownGlyph: UILabel
        let tideScroll: UIScrollView
        let clauseStack: UIStackView
    }

    private let lagoonCrownText: String
    private let lagoonRefreshText: String
    private let lagoonClauses: [SuliJoyLagoonClause]
    private let lagoonIslandWash = SuliJoyIslandBackgroundView()

    init(lagoonCrownText: String, lagoonRefreshText: String = "Last updated: July 2026", lagoonClauses: [SuliJoyLagoonClause]) {
        self.lagoonCrownText = lagoonCrownText
        self.lagoonRefreshText = lagoonRefreshText
        self.lagoonClauses = lagoonClauses
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    convenience init(shoreTitle: String, tideStamp: String = "Last updated: July 2026", reefClauses: [SuliJoyLagoonClause]) {
        self.init(lagoonCrownText: shoreTitle, lagoonRefreshText: tideStamp, lagoonClauses: reefClauses)
    }

    required init?(coder: NSCoder) {
        fatalError("iDnwivtr(ocpoFdqeRru:q)F phNaRsL fnKoKtA UbFeNeMnG DiemvprlxemmXeYnrtUeJdG".suliJoyPalmUnfurled)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        assembleLagoonScrollText()
    }

    private func assembleLagoonScrollText() {
        let coveScene = harvestLagoonScrollTextScene()
        moorLagoonScrollTextScene(coveScene)
        growLagoonClauseCopy(in: coveScene.clauseStack)
        stitchLagoonScrollTextScene(coveScene)
    }

    private func harvestLagoonScrollTextScene() -> LagoonScrollTextScene {
        lagoonIslandWash.translatesAutoresizingMaskIntoConstraints = false

        let reefBackShell = UIButton(type: .system)
        reefBackShell.translatesAutoresizingMaskIntoConstraints = false
        reefBackShell.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        reefBackShell.tintColor = .black
        reefBackShell.addTarget(self, action: #selector(closeLagoonScrollText), for: .touchUpInside)

        let crownGlyph = UILabel()
        crownGlyph.translatesAutoresizingMaskIntoConstraints = false
        crownGlyph.text = lagoonCrownText
        crownGlyph.textColor = .suliInk
        crownGlyph.textAlignment = .center
        crownGlyph.font = UIFont.systemFont(ofSize: 32, weight: .black)
        crownGlyph.adjustsFontSizeToFitWidth = true
        crownGlyph.minimumScaleFactor = 0.82

        let tideScroll = UIScrollView()
        tideScroll.translatesAutoresizingMaskIntoConstraints = false
        tideScroll.alwaysBounceVertical = true

        let clauseStack = UIStackView()
        clauseStack.translatesAutoresizingMaskIntoConstraints = false
        clauseStack.axis = .vertical
        clauseStack.spacing = LagoonScrollTextMeasure.stackGap
        return LagoonScrollTextScene(backShell: reefBackShell, crownGlyph: crownGlyph, tideScroll: tideScroll, clauseStack: clauseStack)
    }

    private func growLagoonClauseCopy(in clauseStack: UIStackView) {
        let refreshGlyph = UILabel()
        refreshGlyph.text = lagoonRefreshText
        refreshGlyph.textColor = .suliMutedInk
        refreshGlyph.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        refreshGlyph.numberOfLines = 0
        clauseStack.addArrangedSubview(refreshGlyph)

        for (reefIndex, clause) in lagoonClauses.enumerated() {
            clauseStack.addArrangedSubview(makeLagoonClauseBlock(clause, reefNumber: reefIndex + 1))
        }
    }

    private func makeLagoonClauseBlock(_ clause: SuliJoyLagoonClause, reefNumber: Int) -> UIStackView {
        let clauseBlock = UIStackView()
        clauseBlock.axis = .vertical
        clauseBlock.spacing = LagoonScrollTextMeasure.sectionGap
        clauseBlock.addArrangedSubview(makeLagoonClauseHeading("\(reefNumber). \(clause.reefHeadline)"))
        clauseBlock.addArrangedSubview(makeLagoonClauseBody(clause.body))
        return clauseBlock
    }

    private func makeLagoonClauseHeading(_ reefText: String) -> UILabel {
        let headingGlyph = UILabel()
        headingGlyph.text = reefText
        headingGlyph.textColor = .suliInk
        headingGlyph.font = UIFont.systemFont(ofSize: 24, weight: .black)
        headingGlyph.numberOfLines = 0
        return headingGlyph
    }

    private func makeLagoonClauseBody(_ reefText: String) -> UILabel {
        let bodyGlyph = UILabel()
        bodyGlyph.text = reefText
        bodyGlyph.textColor = .suliInk
        bodyGlyph.font = UIFont.systemFont(ofSize: 21, weight: .regular)
        bodyGlyph.numberOfLines = 0
        bodyGlyph.lineBreakMode = .byWordWrapping
        return bodyGlyph
    }

    private func moorLagoonScrollTextScene(_ scene: LagoonScrollTextScene) {
        view.addSubview(lagoonIslandWash)
        view.addSubview(scene.backShell)
        view.addSubview(scene.crownGlyph)
        view.addSubview(scene.tideScroll)
        scene.tideScroll.addSubview(scene.clauseStack)
    }

    private func stitchLagoonScrollTextScene(_ scene: LagoonScrollTextScene) {
        NSLayoutConstraint.activate([
            lagoonIslandWash.topAnchor.constraint(equalTo: view.topAnchor),
            lagoonIslandWash.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lagoonIslandWash.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lagoonIslandWash.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            scene.backShell.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LagoonScrollTextMeasure.SuliJoybackLeading),
            scene.backShell.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: LagoonScrollTextMeasure.SuliJoybackTop),
            scene.backShell.widthAnchor.constraint(equalToConstant: LagoonScrollTextMeasure.backSize),
            scene.backShell.heightAnchor.constraint(equalToConstant: LagoonScrollTextMeasure.backSize),

            scene.crownGlyph.centerYAnchor.constraint(equalTo: scene.backShell.centerYAnchor),
            scene.crownGlyph.leadingAnchor.constraint(equalTo: scene.backShell.trailingAnchor, constant: LagoonScrollTextMeasure.titleGap),
            scene.crownGlyph.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: LagoonScrollTextMeasure.titleTrailing),

            scene.tideScroll.topAnchor.constraint(equalTo: scene.backShell.bottomAnchor, constant: LagoonScrollTextMeasure.scrollTop),
            scene.tideScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scene.tideScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scene.tideScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            scene.clauseStack.topAnchor.constraint(equalTo: scene.tideScroll.contentLayoutGuide.topAnchor),
            scene.clauseStack.leadingAnchor.constraint(equalTo: scene.tideScroll.contentLayoutGuide.leadingAnchor, constant: LagoonScrollTextMeasure.stackSide),
            scene.clauseStack.trailingAnchor.constraint(equalTo: scene.tideScroll.contentLayoutGuide.trailingAnchor, constant: -LagoonScrollTextMeasure.stackSide),
            scene.clauseStack.bottomAnchor.constraint(equalTo: scene.tideScroll.contentLayoutGuide.bottomAnchor, constant: LagoonScrollTextMeasure.stackBottom),
            scene.clauseStack.widthAnchor.constraint(equalTo: scene.tideScroll.frameLayoutGuide.widthAnchor, constant: -LagoonScrollTextMeasure.stackSide * 2)
        ])
    }

    @objc private func closeLagoonScrollText() {
        if let navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
