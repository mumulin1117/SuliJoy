import UIKit

final class suliJoyShorelineAesthetic: SuliJoyReefEntryCanvasController {
    private enum ShoreSignupTideMeasure {
        static let SuliJoybackTop: CGFloat = 14
        static let backLead: CGFloat = 22
        static let titleDrop: CGFloat = 32
        static let titleSize: CGFloat = 36
        static let formDrop: CGFloat = 44
        static let formSide: CGFloat = 24
        static let formRadius: CGFloat = 33
        static let fieldTop: CGFloat = 28
        static let fieldSide: CGFloat = 32
        static let fieldBottom: CGFloat = -34
        static let fieldGap: CGFloat = 34
        static let nextBottom: CGFloat = -10
        static let nextSide: CGFloat = 28
    }

    private struct ShoreSignupReefScene {
        let returnControl: UIButton
        let titleView: UILabel
        let formShell: UIView
        let fieldColumn: UIStackView
        let nextControl: SuliJoyGradientButton
    }

    private let shoreNameInput = SuliJoyAuthTextField(placeholder: "Enter your name")
    private let shoreMailInput = SuliJoyAuthTextField(placeholder: "Enter email address")
    private let shoreSecretInput = SuliJoyAuthTextField(placeholder: "Enter password", secure: true)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        arrangeShoreSignupReefScene()
      
    }

    

    private func arrangeShoreSignupReefScene() {
        let shoreScene = harvestShoreSignupReefScene()
        moorShoreSignupReefScene(shoreScene)
        stitchShoreSignupReefScene(shoreScene)
    }

    private func harvestShoreSignupReefScene() -> ShoreSignupReefScene {
        let returnControl = forgeReefReturnControl()
        let titleView = carveSuliJoyWordmark("Sign up", size: ShoreSignupTideMeasure.titleSize)
        let formShell = makeShoreSignupShell()
        let fieldColumn = makeShoreSignupColumn()
        let nextControl = makeShoreSignupNextControl()
        return ShoreSignupReefScene(
            returnControl: returnControl,
            titleView: titleView,
            formShell: formShell,
            fieldColumn: fieldColumn,
            nextControl: nextControl
        )
    }

    private func makeShoreSignupShell() -> UIView {
        let shorelineFormShell = UIView()
        shorelineFormShell.translatesAutoresizingMaskIntoConstraints = false
        shorelineFormShell.backgroundColor = .white
        shorelineFormShell.layer.cornerRadius = ShoreSignupTideMeasure.formRadius
        return shorelineFormShell
    }

    private func makeShoreSignupColumn() -> UIStackView {
        let shorelineFieldColumn = UIStackView(arrangedSubviews: [
            stackShoreInputReef(reefHeadline: "Name", field: shoreNameInput),
            stackShoreInputReef(reefHeadline: "Email", field: shoreMailInput),
            stackShoreInputReef(reefHeadline: "Password", field: shoreSecretInput)
        ])
        shorelineFieldColumn.axis = .vertical
        shorelineFieldColumn.spacing = ShoreSignupTideMeasure.fieldGap
        shorelineFieldColumn.translatesAutoresizingMaskIntoConstraints = false
        return shorelineFieldColumn
    }

    private func makeShoreSignupNextControl() -> SuliJoyGradientButton {
        let shorelineNextControl = SuliJoyGradientButton(reefHeadline: "NYedxktb".suliJoyPalmUnfurled)
        shorelineNextControl.translatesAutoresizingMaskIntoConstraints = false
        shorelineNextControl.addTarget(self, action: #selector(commitShoreSignupDraft(_:)), for: .touchUpInside)
        return shorelineNextControl
    }

    private func moorShoreSignupReefScene(_ shorelineScene: ShoreSignupReefScene) {
        shorelineScene.formShell.addSubview(shorelineScene.fieldColumn)
        [shorelineScene.returnControl, shorelineScene.titleView, shorelineScene.formShell, shorelineScene.nextControl].forEach { contentView.addSubview($0) }
    }

    private func stitchShoreSignupReefScene(_ shorelineScene: ShoreSignupReefScene) {
        NSLayoutConstraint.activate([
            shorelineScene.returnControl.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: ShoreSignupTideMeasure.SuliJoybackTop),
            shorelineScene.returnControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ShoreSignupTideMeasure.backLead),
            shorelineScene.titleView.topAnchor.constraint(equalTo: shorelineScene.returnControl.bottomAnchor, constant: ShoreSignupTideMeasure.titleDrop),
            shorelineScene.titleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            shorelineScene.formShell.topAnchor.constraint(equalTo: shorelineScene.titleView.bottomAnchor, constant: ShoreSignupTideMeasure.formDrop),
            shorelineScene.formShell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ShoreSignupTideMeasure.formSide),
            shorelineScene.formShell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ShoreSignupTideMeasure.formSide),
            shorelineScene.fieldColumn.topAnchor.constraint(equalTo: shorelineScene.formShell.topAnchor, constant: ShoreSignupTideMeasure.fieldTop),
            shorelineScene.fieldColumn.leadingAnchor.constraint(equalTo: shorelineScene.formShell.leadingAnchor, constant: ShoreSignupTideMeasure.fieldSide),
            shorelineScene.fieldColumn.trailingAnchor.constraint(equalTo: shorelineScene.formShell.trailingAnchor, constant: -ShoreSignupTideMeasure.fieldSide),
            shorelineScene.fieldColumn.bottomAnchor.constraint(equalTo: shorelineScene.formShell.bottomAnchor, constant: ShoreSignupTideMeasure.fieldBottom),
            shorelineScene.nextControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: ShoreSignupTideMeasure.nextBottom),
            shorelineScene.nextControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ShoreSignupTideMeasure.nextSide),
            shorelineScene.nextControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ShoreSignupTideMeasure.nextSide),
           
        ])
    }

    @objc private func commitShoreSignupDraft(_ shorelineAction: SuliJoyGradientButton) {
        driftSimulatedHarborDelay(shorelineAction) { [weak self] in
            guard let self else { return }
            let draftEnvelope = SuliJoyLagoonGateService.shared.shapeIslandSignupDraft(
                shorelineNamePhrase: self.shoreNameInput.text ?? "",
                shoreMailPhrase: self.shoreMailInput.text ?? "",
                reefSecretPhrase: self.shoreSecretInput.text ?? ""
            )
            guard let shorelineDraft = draftEnvelope.data else {
                self.presentReefNotice(draftEnvelope.note)
                return
            }
            self.navigationController?.pushViewController(SuliJoyReefProfileTideController(draft: shorelineDraft), animated: true)
        }
    }
}
