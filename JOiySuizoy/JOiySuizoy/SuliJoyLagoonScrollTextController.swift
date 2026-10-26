import UIKit

struct SuliJoyLagoonClause {
    let reefHeadline: String
    let sandofferbody: String
}

final class SuliJoyLagoonScrollTextController: UIViewController {
    private enum LagoonScrollTextMeasure {
        static let SuliJoybackTop: CGFloat = 18
        static let SuliJoybackLeading: CGFloat = 18
        static let backSuliJoySize: CGFloat = 44
        static let SuliJoyleGap: CGFloat = 12
        static let titleTrailing: CGFloat = -62
        static let scrollSuliJoyTop: CGFloat = 28
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
    private let lagoonIslandWash = SuliJoyIslanddeckView()

    init(lagoonCrownText: String, lagoonRefreshText: String = "Lxaxsxtx xuxpxdxaxtxexdx:x xJxuxlxyx x2x0x2x6x".suliJoyPalmUnfurled, lagoonClauses: [SuliJoyLagoonClause]) {
        self.lagoonCrownText = lagoonCrownText
        self.lagoonRefreshText = lagoonRefreshText
        self.lagoonClauses = lagoonClauses
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    convenience init(shoreTitle: String, tideStamp: String = "Lxaxsxtx xuxpxdxaxtxexdx:x xJxuxlxyx x2x0x2x6x".suliJoyPalmUnfurled, reefClauses: [SuliJoyLagoonClause]) {
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

        let SuliJoyBackShell = UIButton(type: .system)
        SuliJoyBackShell.translatesAutoresizingMaskIntoConstraints = false
        SuliJoyBackShell.setImage(UIImage(systemName: "axrxrxoxwx.xlxexfxtx".suliJoyPalmUnfurled), for: .normal)
        SuliJoyBackShell.tintColor = .black
        SuliJoyBackShell.addTarget(self, action: #selector(closeLagoonScrollText), for: .touchUpInside)

        let crownGlyph = UILabel()
        crownGlyph.translatesAutoresizingMaskIntoConstraints = false
        crownGlyph.text = lagoonCrownText
        crownGlyph.textColor = .suliInk
        crownGlyph.textAlignment = .center
        crownGlyph.font = UIFont.systemFont(ofSize: 20, weight: .black)
        crownGlyph.adjustsFontSizeToFitWidth = true
        crownGlyph.minimumScaleFactor = 0.82

        let tideScroll = UIScrollView()
        tideScroll.translatesAutoresizingMaskIntoConstraints = false
        tideScroll.alwaysBounceVertical = true

        let clauseStack = UIStackView()
        clauseStack.translatesAutoresizingMaskIntoConstraints = false
        clauseStack.axis = .vertical
        clauseStack.spacing = LagoonScrollTextMeasure.stackGap
        return LagoonScrollTextScene(backShell: SuliJoyBackShell, crownGlyph: crownGlyph, tideScroll: tideScroll, clauseStack: clauseStack)
    }

    private func growLagoonClauseCopy(in clauseStack: UIStackView) {
        let refreshGlyph = UILabel()
        refreshGlyph.text = lagoonRefreshText
        refreshGlyph.textColor = UIColor(red: 0.53, green: 0.50, blue: 0.44, alpha: 0.82)
        refreshGlyph.font = UIFont.systemFont(ofSize: 13, weight: .regular)
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
        clauseBlock.addArrangedSubview(makeLagoonClauseHeading("\(reefNumber)\(".x x".suliJoyPalmUnfurled)\(clause.reefHeadline)"))
        clauseBlock.addArrangedSubview(makeLagoonClauseBody(clause.sandofferbody))
        return clauseBlock
    }

    private func makeLagoonClauseHeading(_ reefText: String) -> UILabel {
        let headingGlyph = UILabel()
        headingGlyph.text = reefText
        headingGlyph.textColor = .suliInk
        headingGlyph.font = UIFont.systemFont(ofSize: 16, weight: .black)
        headingGlyph.numberOfLines = 0
        return headingGlyph
    }

    private func makeLagoonClauseBody(_ reefText: String) -> UILabel {
        let bodyGlyph = UILabel()
        bodyGlyph.textColor = .suliInk
        bodyGlyph.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        bodyGlyph.numberOfLines = 0
        bodyGlyph.lineBreakMode = .byWordWrapping
        let reefParagraph = NSMutableParagraphStyle()
        reefParagraph.lineSpacing = 4
        bodyGlyph.attributedText = NSAttributedString(
            string: reefText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor.suliInk,
                .paragraphStyle: reefParagraph
            ]
        )
        return bodyGlyph
    }

    private func moorLagoonScrollTextScene(_ scene: LagoonScrollTextScene) {
        view.addSubview(lagoonIslandWash)
        view.addSubview(scene.backShell)
        view.addSubview(scene.crownGlyph)
        view.addSubview(scene.tideScroll)
        scene.tideScroll.addSubview(scene.clauseStack)
    }

    private func stitchLagoonScrollTextScene(_ offerisland: LagoonScrollTextScene) {
        NSLayoutConstraint.activate([
            lagoonIslandWash.topAnchor.constraint(equalTo: view.topAnchor),
            lagoonIslandWash.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lagoonIslandWash.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lagoonIslandWash.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            offerisland.backShell.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: LagoonScrollTextMeasure.SuliJoybackLeading),
            offerisland.backShell.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: LagoonScrollTextMeasure.SuliJoybackTop),
            offerisland.backShell.widthAnchor.constraint(equalToConstant: LagoonScrollTextMeasure.backSuliJoySize),
            offerisland.backShell.heightAnchor.constraint(equalToConstant: LagoonScrollTextMeasure.backSuliJoySize),

            offerisland.crownGlyph.centerYAnchor.constraint(equalTo: offerisland.backShell.centerYAnchor),
            offerisland.crownGlyph.leadingAnchor.constraint(equalTo: offerisland.backShell.trailingAnchor, constant: LagoonScrollTextMeasure.SuliJoyleGap),
            offerisland.crownGlyph.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: LagoonScrollTextMeasure.titleTrailing),

            offerisland.tideScroll.topAnchor.constraint(equalTo: offerisland.backShell.bottomAnchor, constant: LagoonScrollTextMeasure.scrollSuliJoyTop),
            offerisland.tideScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            offerisland.tideScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            offerisland.tideScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            offerisland.clauseStack.topAnchor.constraint(equalTo: offerisland.tideScroll.contentLayoutGuide.topAnchor),
            offerisland.clauseStack.leadingAnchor.constraint(equalTo: offerisland.tideScroll.contentLayoutGuide.leadingAnchor, constant: LagoonScrollTextMeasure.stackSide),
            offerisland.clauseStack.trailingAnchor.constraint(equalTo: offerisland.tideScroll.contentLayoutGuide.trailingAnchor, constant: -LagoonScrollTextMeasure.stackSide),
            offerisland.clauseStack.bottomAnchor.constraint(equalTo: offerisland.tideScroll.contentLayoutGuide.bottomAnchor, constant: LagoonScrollTextMeasure.stackBottom),
            offerisland.clauseStack.widthAnchor.constraint(equalTo: offerisland.tideScroll.frameLayoutGuide.widthAnchor, constant: -LagoonScrollTextMeasure.stackSide * 2)
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
