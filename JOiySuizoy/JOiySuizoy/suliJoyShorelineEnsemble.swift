import UIKit

final class suliJoyShorelineEnsemble: SuliJoyReefEntryCanvasController {
    private let shoreConsentRibbon = SuliJoyLagoonConsentRibbon()
    private enum ArrivalMetric {
        static let eulaPause: TimeInterval = 0.35
        static let ruleTop: CGFloat = 18
        static let ruleSide: CGFloat = -16
        static let wordmarkSize: CGFloat = 30
        static let taglineSize: CGFloat = 18
        static let collageTop: CGFloat = 26
        static let actionTop: CGFloat = 32
        static let actionInset: CGFloat = 22
        static let actionHeight: CGFloat = 50
        static let ribbonTop: CGFloat = 42
        static let ribbonSide: CGFloat = 24
        static let ribbonBottom: CGFloat = -22
        static let imageCorner: CGFloat = 20
    }

    private struct ArrivalScenePack {
        let ruleCapsule: UIButton
        let wordmark: UILabel
        let tagline: UILabel
        let collage: UIView
        let actionRow: UIStackView
        let entryControl: UIButton
        let consentRibbon: SuliJoyLagoonConsentRibbon
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        arrangeIslandArrivalScene()
        refreshConsentRibbonBinding(shoreConsentRibbon)
        DispatchQueue.main.asyncAfter(deadline: .now() + ArrivalMetric.eulaPause) { [weak self] in
            guard let islandHost = self, !SuliJoyLagoonGateService.shared.restoreSession().hasAgreedEULA else { return }
            islandHost.presentLagoonRuleSheet()
        }
    }

    override func refreshConsentRibbonState() {
        shoreConsentRibbon.isLagoonConsentMarked = SuliJoyLagoonGateService.shared.restoreSession().hasAgreedEULA
    }

    private func arrangeIslandArrivalScene() {
        let arrivalScene = harvestArrivalScenePack()
        moorArrivalScene(arrivalScene)
        stitchArrivalScene(arrivalScene)
    }

    private func harvestArrivalScenePack() -> ArrivalScenePack {
        let coastalRuleCapsule = forgeLagoonRuleCapsule()
        let suliJoyWordmark = carveSuliJoyWordmark("SULIJOY", size: ArrivalMetric.wordmarkSize)
        let islandStyleTagline = makeIslandTagline()
        let resortCollage = craftResortLayeredLook()
        let lagoonEntryControl = makeLagoonEntryControl()
        let shoreSignupControl = makeShoreSignupControl()
        let tideActionRow = makeTideActionRow(with: lagoonEntryControl, and: shoreSignupControl)

        return ArrivalScenePack(
            ruleCapsule: coastalRuleCapsule,
            wordmark: suliJoyWordmark,
            tagline: islandStyleTagline,
            collage: resortCollage,
            actionRow: tideActionRow,
            entryControl: lagoonEntryControl,
            consentRibbon: shoreConsentRibbon
        )
    }

    private func moorArrivalScene(_ scene: ArrivalScenePack) {
        [
            scene.ruleCapsule,
            scene.wordmark,
            scene.tagline,
            scene.collage,
            scene.actionRow,
            scene.consentRibbon
        ].forEach(contentView.addSubview)
    }

    private func stitchArrivalScene(_ scene: ArrivalScenePack) {
        NSLayoutConstraint.activate([
            scene.ruleCapsule.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: ArrivalMetric.ruleTop),
            scene.ruleCapsule.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: ArrivalMetric.ruleSide),
            scene.wordmark.topAnchor.constraint(equalTo: scene.ruleCapsule.bottomAnchor, constant: 2),
            scene.wordmark.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            scene.tagline.topAnchor.constraint(equalTo: scene.wordmark.bottomAnchor, constant: 2),
            scene.tagline.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            scene.collage.topAnchor.constraint(equalTo: scene.tagline.bottomAnchor, constant: ArrivalMetric.collageTop),
            scene.collage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            scene.collage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            scene.collage.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.98),
            scene.actionRow.topAnchor.constraint(equalTo: scene.collage.bottomAnchor, constant: ArrivalMetric.actionTop),
            scene.actionRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ArrivalMetric.actionInset),
            scene.actionRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ArrivalMetric.actionInset),
            scene.entryControl.heightAnchor.constraint(equalToConstant: ArrivalMetric.actionHeight),
            scene.consentRibbon.topAnchor.constraint(equalTo: scene.actionRow.bottomAnchor, constant: ArrivalMetric.ribbonTop),
            scene.consentRibbon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ArrivalMetric.ribbonSide),
            scene.consentRibbon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ArrivalMetric.ribbonSide),
            scene.consentRibbon.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: ArrivalMetric.ribbonBottom)
        ])
    }

    private func makeIslandTagline() -> UILabel {
        let islandStyleTagline = UILabel()
        islandStyleTagline.translatesAutoresizingMaskIntoConstraints = false
        islandStyleTagline.text = "Show your island style."
        islandStyleTagline.textColor = .suliInk
        islandStyleTagline.font = UIFont.italicSystemFont(ofSize: ArrivalMetric.taglineSize)
        islandStyleTagline.textAlignment = .center
        return islandStyleTagline
    }

    private func makeLagoonEntryControl() -> UIButton {
        let lagoonEntryControl = UIButton(type: .system)
        lagoonEntryControl.translatesAutoresizingMaskIntoConstraints = false
        lagoonEntryControl.setTitle("Login", for: .normal)
        lagoonEntryControl.setTitleColor(.white, for: .normal)
        lagoonEntryControl.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .black)
        lagoonEntryControl.backgroundColor = .suliInk
        lagoonEntryControl.layer.cornerRadius = ArrivalMetric.actionHeight / 2
        lagoonEntryControl.addTarget(self, action: #selector(sailToLagoonEntry), for: .touchUpInside)
        return lagoonEntryControl
    }

    private func makeShoreSignupControl() -> SuliJoyGradientButton {
        let shoreSignupControl = SuliJoyGradientButton(reefHeadline: "Sign in", bordered: true)
        shoreSignupControl.addTarget(self, action: #selector(sailToShoreSignup), for: .touchUpInside)
        plantShoreMailBadge(on: shoreSignupControl)
        return shoreSignupControl
    }

    private func plantShoreMailBadge(on shoreSignupControl: UIControl) {
        let shorelineMailBadge = UIImageView(image: UIImage(named: "sulijoy_auth_mail_badge"))
        shorelineMailBadge.translatesAutoresizingMaskIntoConstraints = false
        shoreSignupControl.addSubview(shorelineMailBadge)
        NSLayoutConstraint.activate([
            shorelineMailBadge.widthAnchor.constraint(equalToConstant: 20),
            shorelineMailBadge.heightAnchor.constraint(equalToConstant: 20),
            shorelineMailBadge.centerYAnchor.constraint(equalTo: shoreSignupControl.centerYAnchor),
            shorelineMailBadge.leadingAnchor.constraint(equalTo: shoreSignupControl.leadingAnchor, constant: 30)
        ])
    }

    private func makeTideActionRow(with lagoonEntryControl: UIView, and shoreSignupControl: UIView) -> UIStackView {
        let tideActionRow = UIStackView(arrangedSubviews: [lagoonEntryControl, shoreSignupControl])
        tideActionRow.translatesAutoresizingMaskIntoConstraints = false
        tideActionRow.axis = .horizontal
        tideActionRow.spacing = ArrivalMetric.actionInset
        tideActionRow.distribution = .fillEqually
        return tideActionRow
    }

    private func craftResortLayeredLook() -> UIView {
        let resortFrame = UIView()
        resortFrame.translatesAutoresizingMaskIntoConstraints = false
        let breezyLeftLook = islandLookFrame(named: "sulijoy_auth_hero_left")
        let sunriseRightLook = islandLookFrame(named: "sulijoy_auth_hero_right")
        let palmFrontLook = islandLookFrame(named: "sulijoy_auth_hero_front")
        breezyLeftLook.transform = CGAffineTransform(rotationAngle: -0.18)
        sunriseRightLook.transform = CGAffineTransform(rotationAngle: 0.10)
        [breezyLeftLook, sunriseRightLook, palmFrontLook].forEach { resortFrame.addSubview($0) }
        stitchResortCollage(resortFrame, left: breezyLeftLook, right: sunriseRightLook, front: palmFrontLook)
        return resortFrame
    }

    private func stitchResortCollage(_ resortFrame: UIView, left breezyLeftLook: UIView, right sunriseRightLook: UIView, front palmFrontLook: UIView) {
        NSLayoutConstraint.activate([
            breezyLeftLook.leadingAnchor.constraint(equalTo: resortFrame.leadingAnchor, constant: -28),
            breezyLeftLook.topAnchor.constraint(equalTo: resortFrame.topAnchor, constant: 20),
            breezyLeftLook.widthAnchor.constraint(equalTo: resortFrame.widthAnchor, multiplier: 0.62),
            breezyLeftLook.heightAnchor.constraint(equalTo: resortFrame.heightAnchor, multiplier: 0.86),
            sunriseRightLook.trailingAnchor.constraint(equalTo: resortFrame.trailingAnchor, constant: 26),
            sunriseRightLook.topAnchor.constraint(equalTo: resortFrame.topAnchor, constant: 58),
            sunriseRightLook.widthAnchor.constraint(equalTo: resortFrame.widthAnchor, multiplier: 0.60),
            sunriseRightLook.heightAnchor.constraint(equalTo: resortFrame.heightAnchor, multiplier: 0.78),
            palmFrontLook.centerXAnchor.constraint(equalTo: resortFrame.centerXAnchor),
            palmFrontLook.bottomAnchor.constraint(equalTo: resortFrame.bottomAnchor),
            palmFrontLook.widthAnchor.constraint(equalTo: resortFrame.widthAnchor, multiplier: 0.74),
            palmFrontLook.heightAnchor.constraint(equalTo: resortFrame.heightAnchor, multiplier: 0.84)
        ])
    }

    private func islandLookFrame(named assetName: String) -> UIImageView {
        let resortImageView = UIImageView(image: UIImage(named: assetName))
        resortImageView.translatesAutoresizingMaskIntoConstraints = false
        polishIslandLookFrame(resortImageView)
        return resortImageView
    }

    private func polishIslandLookFrame(_ resortImageView: UIImageView) {
        resortImageView.contentMode = .scaleAspectFill
        resortImageView.clipsToBounds = true
        resortImageView.layer.cornerRadius = ArrivalMetric.imageCorner
        resortImageView.layer.shadowColor = UIColor.black.cgColor
        resortImageView.layer.shadowOpacity = 0.18
        resortImageView.layer.shadowOffset = CGSize(width: 0, height: 12)
        resortImageView.layer.shadowRadius = 20
    }

    @objc private func sailToLagoonEntry() {
        navigationController?.pushViewController(SuliJoyShellPearlStorecontroller(), animated: true)
    }

    @objc private func sailToShoreSignup() {
        navigationController?.pushViewController(suliJoyShorelineAesthetic(), animated: true)
    }
}
