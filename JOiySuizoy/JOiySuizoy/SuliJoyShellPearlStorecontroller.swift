import UIKit

final class SuliJoyShellPearlStorecontroller: SuliJoyReefEntryCanvasController {
    private enum LagoonEntryTideMeasure {
        static let SuliJoytopBackInset: CGFloat = 14
        static let sideBackInset: CGFloat = 22
        static let eulaTrailing: CGFloat = -16
        static let titleDrop: CGFloat = 92
        static let titleSize: CGFloat = 36
        static let formDrop: CGFloat = 54
        static let formSide: CGFloat = 24
        static let formCorner: CGFloat = 33
        static let fieldTop: CGFloat = 28
        static let fieldSide: CGFloat = 32
        static let fieldBottom: CGFloat = -34
        static let fieldGap: CGFloat = 34
        static let buttonDrop: CGFloat = 57
        static let buttonSide: CGFloat = 28
    }

    private struct LagoonEntryReefScene {
        let backShell: UIButton
        let eulaCapsule: UIButton
        let titleMark: UILabel
        let formShell: UIView
        let fieldStack: UIStackView
        let submitLagoon: SuliJoyGradientButton
    }

    private let shoreMailInput = SuliJoyAuthTextField(placeholder: "Enter email address")
    private let reefSecretInput = SuliJoyAuthTextField(placeholder: "Enter password", secure: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        raiseLagoonEntryReefScene()
    }

    private func raiseLagoonEntryReefScene() {
        let lagoonEntryScene = makeLagoonEntryReefScene()
        moorLagoonEntryReefScene(lagoonEntryScene)
        stitchLagoonEntryReefScene(lagoonEntryScene)
    }

    private func makeLagoonEntryReefScene() -> LagoonEntryReefScene {
        let formShell = makeLagoonEntryShell()
        let fieldStack = makeLagoonEntryColumn()
        let submitLagoon = makeLagoonEntryButton()
        formShell.addSubview(fieldStack)
        return LagoonEntryReefScene(
            backShell: forgeReefReturnControl(),
            eulaCapsule: forgeLagoonRuleCapsule(),
            titleMark: carveSuliJoyWordmark("LOGIN", size: LagoonEntryTideMeasure.titleSize),
            formShell: formShell,
            fieldStack: fieldStack,
            submitLagoon: submitLagoon
        )
    }

    private func makeLagoonEntryShell() -> UIView {
        let formShell = UIView()
        formShell.translatesAutoresizingMaskIntoConstraints = false
        formShell.backgroundColor = .white
        formShell.layer.cornerRadius = LagoonEntryTideMeasure.formCorner
        return formShell
    }

    private func makeLagoonEntryColumn() -> UIStackView {
        let shoreMailBlock = stackShoreInputReef(reefHeadline: "Email", field: shoreMailInput)
        let reefSecretBlock = stackShoreInputReef(reefHeadline: "Password", field: reefSecretInput)
        let lagoonFieldColumn = UIStackView(arrangedSubviews: [shoreMailBlock, reefSecretBlock])
        lagoonFieldColumn.axis = .vertical
        lagoonFieldColumn.spacing = LagoonEntryTideMeasure.fieldGap
        lagoonFieldColumn.translatesAutoresizingMaskIntoConstraints = false
        return lagoonFieldColumn
    }

    private func makeLagoonEntryButton() -> SuliJoyGradientButton {
        let submitLagoon = SuliJoyGradientButton(reefHeadline: "LOGIN")
        submitLagoon.translatesAutoresizingMaskIntoConstraints = false
        submitLagoon.addTarget(self, action: #selector(commitLagoonEntry(_:)), for: .touchUpInside)
        return submitLagoon
    }

    private func moorLagoonEntryReefScene(_ lagoonScene: LagoonEntryReefScene) {
        [
            lagoonScene.backShell,
            lagoonScene.eulaCapsule,
            lagoonScene.titleMark,
            lagoonScene.formShell,
            lagoonScene.submitLagoon
        ].forEach { contentView.addSubview($0) }
    }

    private func stitchLagoonEntryReefScene(_ lagoonScene: LagoonEntryReefScene) {
        NSLayoutConstraint.activate([
            lagoonScene.backShell.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: LagoonEntryTideMeasure.SuliJoytopBackInset),
            lagoonScene.backShell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LagoonEntryTideMeasure.sideBackInset),
            lagoonScene.eulaCapsule.centerYAnchor.constraint(equalTo: lagoonScene.backShell.centerYAnchor),
            lagoonScene.eulaCapsule.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: LagoonEntryTideMeasure.eulaTrailing),
            lagoonScene.titleMark.topAnchor.constraint(equalTo: lagoonScene.backShell.bottomAnchor, constant: LagoonEntryTideMeasure.titleDrop),
            lagoonScene.titleMark.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lagoonScene.formShell.topAnchor.constraint(equalTo: lagoonScene.titleMark.bottomAnchor, constant: LagoonEntryTideMeasure.formDrop),
            lagoonScene.formShell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LagoonEntryTideMeasure.formSide),
            lagoonScene.formShell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LagoonEntryTideMeasure.formSide),
            lagoonScene.fieldStack.topAnchor.constraint(equalTo: lagoonScene.formShell.topAnchor, constant: LagoonEntryTideMeasure.fieldTop),
            lagoonScene.fieldStack.leadingAnchor.constraint(equalTo: lagoonScene.formShell.leadingAnchor, constant: LagoonEntryTideMeasure.fieldSide),
            lagoonScene.fieldStack.trailingAnchor.constraint(equalTo: lagoonScene.formShell.trailingAnchor, constant: -LagoonEntryTideMeasure.fieldSide),
            lagoonScene.fieldStack.bottomAnchor.constraint(equalTo: lagoonScene.formShell.bottomAnchor, constant: LagoonEntryTideMeasure.fieldBottom),
            lagoonScene.submitLagoon.topAnchor.constraint(equalTo: lagoonScene.formShell.bottomAnchor, constant: LagoonEntryTideMeasure.buttonDrop),
            lagoonScene.submitLagoon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: LagoonEntryTideMeasure.buttonSide),
            lagoonScene.submitLagoon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -LagoonEntryTideMeasure.buttonSide)
        ])
    }

    @objc private func commitLagoonEntry(_ lagoonAction: SuliJoyGradientButton) {
        driftSimulatedHarborDelay(lagoonAction) { [weak self] in
            guard let self else { return }
            let reefGateEnvelope = self.openLagoonEntryEnvelope()
            guard reefGateEnvelope.code == 200 else {
                self.presentReefNotice(reefGateEnvelope.note)
                return
            }
            self.openIslandTabsAfterEntry()
        }
    }

    private func openLagoonEntryEnvelope() -> SuliJoySuiRequestEnvelope<SuliJoyLagoonSession> {
        SuliJoyLagoonGateService.shared.enterIslandLagoon(
            shoreMailPhrase: shoreMailInput.text ?? "",
            reefSecretPhrase: reefSecretInput.text ?? ""
        )
    }

    private func openIslandTabsAfterEntry() {
        let islandTabRoot = SuliJoyMainTabBarController()
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController = islandTabRoot
    }
}
