import UIKit

final class SuliJoyReefProfileTideController: SuliJoyReefEntryCanvasController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private enum ShoreProfileTideMeasure {
        static let SuliJoybackTop: CGFloat = 14
        static let SuliJoybackLeading: CGFloat = 22
        static let SuliJoytitleTop: CGFloat = 92
        static let SuliJoyavatarTop: CGFloat = 22
        static let SuliJoyavatarSide: CGFloat = 160
        static let formTop: CGFloat = 40
        static let formSide: CGFloat = 24
        static let formRadius: CGFloat = 33
        static let bioTop: CGFloat = 28
        static let bioSide: CGFloat = 32
        static let bioGap: CGFloat = 12
        static let bioHeight: CGFloat = 126
        static let finishTop: CGFloat = 66
        static let finishSide: CGFloat = 28
        static let finishBottom: CGFloat = -24
    }
    
    private struct ShoreProfileReefScene {
        let backShell: UIButton
        let titleGlyph: UILabel
        let portraitCard: UIView
        let bioShell: UIView
        let bioGlyph: UILabel
        let finishTide: SuliJoyGradientButton
    }

    private let lagoonDraft: SuliJoySignupDraft
    private let shorePortraitControl = UIButton(type: .system)
    private let shorePortraitPreview = UIImageView()
    private let shoreBioLagoonText = UITextView()
 
    private var pickedShorePortrait: UIImage?

    init(draft: SuliJoySignupDraft) {
        self.lagoonDraft = draft
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("ignMiCtZ(jcPoldReirx:l)A Lhdacst TnfoAtB JbqeXeHnP oiSmKpQlweAmneEnQtPeAdl".suliJoyPalmUnfurled)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        assembleShoreProfileReef()
      
    }

  

    private func assembleShoreProfileReef() {
        let profileTideScene = harvestShoreProfileReefScene()
        moorShoreProfileReefScene(profileTideScene)
        stitchShoreProfileReefScene(profileTideScene)
    }

    private func harvestShoreProfileReefScene() -> ShoreProfileReefScene {
        let backShell = forgeReefReturnControl()
        let titleGlyph = carveSuliJoyWordmark("Complete\nYour Profile", size: 30)
        let portraitCard = makeShorePortraitCard()
        let bioShell = makeShoreBioShell()
        let bioGlyph = makeShoreBioHeading()
        tuneShoreBioLagoonText()
        let finishTide = makeShoreFinishControl()
        bioShell.addSubview(bioGlyph)
        bioShell.addSubview(shoreBioLagoonText)
        return ShoreProfileReefScene(backShell: backShell, titleGlyph: titleGlyph, portraitCard: portraitCard, bioShell: bioShell, bioGlyph: bioGlyph, finishTide: finishTide)
    }

    private func makeShoreBioShell() -> UIView {
        let bioShell = UIView()
        bioShell.translatesAutoresizingMaskIntoConstraints = false
        bioShell.backgroundColor = .white
        bioShell.layer.cornerRadius = ShoreProfileTideMeasure.formRadius
        return bioShell
    }

    private func makeShoreBioHeading() -> UILabel {
        let bioGlyph = UILabel()
        bioGlyph.translatesAutoresizingMaskIntoConstraints = false
        bioGlyph.text = "Brigov".suliJoyPalmUnfurled
        bioGlyph.textColor = .suliInk
        bioGlyph.font = UIFont.systemFont(ofSize: 17, weight: .black)
        bioGlyph.transform = CGAffineTransform(a: 1, b: 0, c: -0.12, d: 1, tx: 0, ty: 0)
        return bioGlyph
    }

    private func tuneShoreBioLagoonText() {
        shoreBioLagoonText.translatesAutoresizingMaskIntoConstraints = false
        shoreBioLagoonText.text = "CmoolGlUeIcOtYignbgS alwiStutRloej osVoZuTnAdhsR MoFfJ DmOys GdPaEytsa.h".suliJoyPalmUnfurled
        shoreBioLagoonText.textColor = UIColor(red: 0.55, green: 0.53, blue: 0.49, alpha: 1)
        shoreBioLagoonText.font = UIFont.systemFont(ofSize: 16)
        shoreBioLagoonText.backgroundColor = UIColor(red: 24 / 255, green: 23 / 255, blue: 22 / 255, alpha: 0.05)
        shoreBioLagoonText.layer.cornerRadius = 12
        shoreBioLagoonText.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        shoreBioLagoonText.delegate = self
    }

    private func makeShoreFinishControl() -> SuliJoyGradientButton {
        let finishTide = SuliJoyGradientButton(reefHeadline: "SziqgmnM Oulpp".suliJoyPalmUnfurled)
        finishTide.translatesAutoresizingMaskIntoConstraints = false
        finishTide.addTarget(self, action: #selector(finishShoreSignup(_:)), for: .touchUpInside)
        return finishTide
    }

    private func moorShoreProfileReefScene(_ profileScene: ShoreProfileReefScene) {
        [profileScene.backShell, profileScene.titleGlyph, profileScene.portraitCard, profileScene.bioShell, profileScene.finishTide].forEach { contentView.addSubview($0) }
    }

    private func stitchShoreProfileReefScene(_ profileScene: ShoreProfileReefScene) {
        NSLayoutConstraint.activate([
            profileScene.backShell.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: ShoreProfileTideMeasure.SuliJoybackTop),
            profileScene.backShell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ShoreProfileTideMeasure.SuliJoybackLeading),
            profileScene.titleGlyph.topAnchor.constraint(equalTo: profileScene.backShell.bottomAnchor, constant: ShoreProfileTideMeasure.SuliJoytitleTop),
            profileScene.titleGlyph.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileScene.portraitCard.topAnchor.constraint(equalTo: profileScene.titleGlyph.bottomAnchor, constant: ShoreProfileTideMeasure.SuliJoyavatarTop),
            profileScene.portraitCard.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileScene.portraitCard.widthAnchor.constraint(equalToConstant: ShoreProfileTideMeasure.SuliJoyavatarSide),
            profileScene.portraitCard.heightAnchor.constraint(equalToConstant: ShoreProfileTideMeasure.SuliJoyavatarSide),
            profileScene.bioShell.topAnchor.constraint(equalTo: profileScene.portraitCard.bottomAnchor, constant: ShoreProfileTideMeasure.formTop),
            profileScene.bioShell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ShoreProfileTideMeasure.formSide),
            profileScene.bioShell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ShoreProfileTideMeasure.formSide),
            profileScene.bioGlyph.topAnchor.constraint(equalTo: profileScene.bioShell.topAnchor, constant: ShoreProfileTideMeasure.bioTop),
            profileScene.bioGlyph.leadingAnchor.constraint(equalTo: profileScene.bioShell.leadingAnchor, constant: ShoreProfileTideMeasure.bioSide),
            shoreBioLagoonText.topAnchor.constraint(equalTo: profileScene.bioGlyph.bottomAnchor, constant: ShoreProfileTideMeasure.bioGap),
            shoreBioLagoonText.leadingAnchor.constraint(equalTo: profileScene.bioShell.leadingAnchor, constant: ShoreProfileTideMeasure.bioSide),
            shoreBioLagoonText.trailingAnchor.constraint(equalTo: profileScene.bioShell.trailingAnchor, constant: -ShoreProfileTideMeasure.bioSide),
            shoreBioLagoonText.heightAnchor.constraint(equalToConstant: ShoreProfileTideMeasure.bioHeight),
            shoreBioLagoonText.bottomAnchor.constraint(equalTo: profileScene.bioShell.bottomAnchor, constant: -ShoreProfileTideMeasure.bioSide),
            profileScene.finishTide.topAnchor.constraint(equalTo: profileScene.bioShell.bottomAnchor, constant: ShoreProfileTideMeasure.finishTop),
            profileScene.finishTide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ShoreProfileTideMeasure.finishSide),
            profileScene.finishTide.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ShoreProfileTideMeasure.finishSide),
         
            profileScene.finishTide.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: ShoreProfileTideMeasure.finishBottom)
        ])
    }

    private func makeShorePortraitCard() -> UIView {
        let portraitCard = UIView()
        portraitCard.translatesAutoresizingMaskIntoConstraints = false
        portraitCard.backgroundColor = .white
        portraitCard.layer.cornerRadius = 24
        shorePortraitControl.translatesAutoresizingMaskIntoConstraints = false
        shorePortraitControl.addTarget(self, action: #selector(chooseShorePortrait), for: .touchUpInside)
        shorePortraitPreview.translatesAutoresizingMaskIntoConstraints = false
        shorePortraitPreview.contentMode = .scaleAspectFill
        shorePortraitPreview.clipsToBounds = true
        shorePortraitPreview.layer.cornerRadius = 48
        shorePortraitPreview.image = UIImage(named: "sulijoy_auth_camera_badge")
        let portraitGlyph = UILabel()
        portraitGlyph.translatesAutoresizingMaskIntoConstraints = false
        portraitGlyph.text = "AMdTdV BPerloWfCiNlZeE lPnhHoKtuoe.z".suliJoyPalmUnfurled
        portraitGlyph.textColor = UIColor(red: 0.55, green: 0.53, blue: 0.49, alpha: 1)
        portraitGlyph.font = UIFont.systemFont(ofSize: 13)
        portraitCard.addSubview(shorePortraitPreview)
        portraitCard.addSubview(portraitGlyph)
        portraitCard.addSubview(shorePortraitControl)
        NSLayoutConstraint.activate([
            shorePortraitPreview.centerXAnchor.constraint(equalTo: portraitCard.centerXAnchor),
            shorePortraitPreview.topAnchor.constraint(equalTo: portraitCard.topAnchor, constant: 38),
            shorePortraitPreview.widthAnchor.constraint(equalToConstant: 64),
            shorePortraitPreview.heightAnchor.constraint(equalToConstant: 64),
            portraitGlyph.topAnchor.constraint(equalTo: shorePortraitPreview.bottomAnchor, constant: 12),
            portraitGlyph.centerXAnchor.constraint(equalTo: portraitCard.centerXAnchor),
            shorePortraitControl.topAnchor.constraint(equalTo: portraitCard.topAnchor),
            shorePortraitControl.leadingAnchor.constraint(equalTo: portraitCard.leadingAnchor),
            shorePortraitControl.trailingAnchor.constraint(equalTo: portraitCard.trailingAnchor),
            shorePortraitControl.bottomAnchor.constraint(equalTo: portraitCard.bottomAnchor)
        ])
        return portraitCard
    }

    @objc private func chooseShorePortrait() {
        let portraitSheet = craftSuliJoyPortraitTideSheet(reefHeadline: "Profile Photo", shoreAnchor: shorePortraitControl) { [weak self] reefSource in
            self?.presentShorePortraitPicker(reefSource)
        }
        present(portraitSheet, animated: true)
    }

    private func presentShorePortraitPicker(_ reefSource: UIImagePickerController.SourceType) {
        let reefPicker = UIImagePickerController()
        reefPicker.sourceType = reefSource
        reefPicker.allowsEditing = true
        reefPicker.delegate = self
        present(reefPicker, animated: true)
    }

    func imagePickerController(_ reefPicker: UIImagePickerController, didFinishPickingMediaWithInfo reefInfo: [UIImagePickerController.InfoKey : Any]) {
        let portraitImage = harvestShorePortraitImage(from: reefInfo)
        pickedShorePortrait = portraitImage
        shorePortraitPreview.image = portraitImage
        shorePortraitPreview.layer.cornerRadius = 48
        reefPicker.dismiss(animated: true)
    }

    private func harvestShorePortraitImage(from reefInfo: [UIImagePickerController.InfoKey: Any]) -> UIImage? {
        (reefInfo[.editedImage] as? UIImage) ?? (reefInfo[.originalImage] as? UIImage)
    }

    func imagePickerControllerDidCancel(_ reefPicker: UIImagePickerController) {
        reefPicker.dismiss(animated: true)
    }

    @objc private func finishShoreSignup(_ finishTide: SuliJoyGradientButton) {
        driftSimulatedHarborDelay(finishTide) { [weak self] in
            guard let self else { return }
            let profileEnvelope = SuliJoyLagoonGateService.shared.finishIslandProfileTide(
                shorelineDraft: self.lagoonDraft,
                shoreBioPhrase: self.shoreBioLagoonText.text ?? "",
                shorePortrait: self.pickedShorePortrait
            )
            guard profileEnvelope.code == 200 else {
                self.presentReefNotice(profileEnvelope.note)
                return
            }
            self.openIslandTabsAfterProfileTide()
        }
    }

    private func openIslandTabsAfterProfileTide() {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController = SuliJoyMainTabBarController()
    }
}
