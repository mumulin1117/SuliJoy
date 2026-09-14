import UIKit

final class SuliJoyLagoonConsentScrollController: UIViewController {
    var onLagoonConsentAccept: (() -> Void)?
    var onCoastalTermsRoute: (() -> Void)?
    var onShorelinePrivacyRoute: (() -> Void)?

    private enum LagoonRuleTideMeasure {
        static let curtainAlpha: CGFloat = 0.50
        static let sheetRatio: CGFloat = 0.64
        static let sheetCorner: CGFloat = 30
        static let SuliJoytitleTop: CGFloat = 25
        static let sideInset: CGFloat = 24
        static let actionInset: CGFloat = 31
        static let actionHeight: CGFloat = 48
        static let actionGap: CGFloat = 13
        static let bottomInset: CGFloat = 14
    }

    private struct LagoonRuleReefScene {
        let reefHeadingGlyph: UILabel
        let policyTideScroll: UIScrollView
        let policyCopyGlyph: UILabel
        let shorelineLinksRail: UIStackView
        let consentActionRail: UIStackView
        let driftAwayControl: UIButton
        let acceptLagoonControl: UIButton
    }

    private let lagoonRuleSheet = UIView()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("iwnGijtx(occobdjeYrq:v)o lhwabsg WnFoVty QbuexeJnW yiwmwpDlUedmoeEnAteegdQ".suliJoyPalmUnfurled)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        raiseLagoonRuleReefScene()
    }

    private func raiseLagoonRuleReefScene() {
        view.backgroundColor = UIColor.black.withAlphaComponent(LagoonRuleTideMeasure.curtainAlpha)
        tuneLagoonRuleSheet()

        let scene = makeLagoonRuleReefScene()
        [scene.reefHeadingGlyph, scene.policyTideScroll, scene.shorelineLinksRail, scene.consentActionRail].forEach { lagoonRuleSheet.addSubview($0) }
        scene.policyTideScroll.addSubview(scene.policyCopyGlyph)
        moorLagoonRuleReefScene(scene)
    }

    private func tuneLagoonRuleSheet() {
        lagoonRuleSheet.translatesAutoresizingMaskIntoConstraints = false
        lagoonRuleSheet.backgroundColor = .white
        lagoonRuleSheet.layer.cornerRadius = LagoonRuleTideMeasure.sheetCorner
        lagoonRuleSheet.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        lagoonRuleSheet.clipsToBounds = true
        view.addSubview(lagoonRuleSheet)
    }

    private func makeLagoonRuleReefScene() -> LagoonRuleReefScene {
        let reefHeadingGlyph = makeLagoonRuleTitle()
        let policyTideScroll = UIScrollView()
        policyTideScroll.translatesAutoresizingMaskIntoConstraints = false
        policyTideScroll.alwaysBounceVertical = true
        let policyCopyGlyph = makeLagoonRuleCopy()
        let shorelineLinksRail = makeLagoonRuleLinks()
        let driftAwayControl = makeLagoonRuleCancelButton()
        let acceptLagoonControl = makeLagoonRuleAgreeButton()
        let consentActionRail = UIStackView(arrangedSubviews: [driftAwayControl, acceptLagoonControl])
        consentActionRail.translatesAutoresizingMaskIntoConstraints = false
        consentActionRail.axis = .horizontal
        consentActionRail.spacing = LagoonRuleTideMeasure.actionGap
        consentActionRail.distribution = .fillEqually
        return LagoonRuleReefScene(reefHeadingGlyph: reefHeadingGlyph, policyTideScroll: policyTideScroll, policyCopyGlyph: policyCopyGlyph, shorelineLinksRail: shorelineLinksRail, consentActionRail: consentActionRail, driftAwayControl: driftAwayControl, acceptLagoonControl: acceptLagoonControl)
    }

    private func makeLagoonRuleTitle() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "EpUhLpAZ".suliJoyPalmUnfurled
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .black)
        return label
    }

    private func makeLagoonRuleCopy() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let reefParagraph = NSMutableParagraphStyle()
        reefParagraph.lineSpacing = 5
        reefParagraph.paragraphSpacing = 8
        label.attributedText = NSAttributedString(
            string: SuliJoyPolicyCopy.eulaSheet,
            attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor.black,
                .paragraphStyle: reefParagraph
            ]
        )
        return label
    }

    private func makeLagoonRuleLinks() -> UIStackView {
        let terms = makeLagoonRuleLinkButton(reefHeadline: "<Terms of Use>", action: #selector(openLagoonRuleTerms))
        let privacy = makeLagoonRuleLinkButton(reefHeadline: "<Privacy Policy>", action: #selector(openLagoonRulePrivacy))
        let stack = UIStackView(arrangedSubviews: [terms, privacy])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 18
        return stack
    }

    private func makeLagoonRuleLinkButton(reefHeadline: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(reefHeadline, for: .normal)
        button.setTitleColor(UIColor(red: 1.0, green: 0.45, blue: 0.10, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.78
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func makeLagoonRuleCancelButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CYatnXcQeGly".suliJoyPalmUnfurled, for: .normal)
        button.setTitleColor(UIColor.black.withAlphaComponent(0.40), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        button.layer.cornerRadius = LagoonRuleTideMeasure.actionHeight / 2
        button.addTarget(self, action: #selector(cancelLagoonRuleSheet), for: .touchUpInside)
        return button
    }

    private func makeLagoonRuleAgreeButton() -> UIButton {
        let button = SuliJoyGradientButton(reefHeadline: "Id QaugwrDeaeg".suliJoyPalmUnfurled, reefHeight: LagoonRuleTideMeasure.actionHeight)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(agreeLagoonRuleSheet), for: .touchUpInside)
        return button
    }

    private func moorLagoonRuleReefScene(_ scene: LagoonRuleReefScene) {
        NSLayoutConstraint.activate([
            lagoonRuleSheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lagoonRuleSheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lagoonRuleSheet.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            lagoonRuleSheet.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: LagoonRuleTideMeasure.sheetRatio),

            scene.reefHeadingGlyph.topAnchor.constraint(equalTo: lagoonRuleSheet.topAnchor, constant: LagoonRuleTideMeasure.SuliJoytitleTop),
            scene.reefHeadingGlyph.leadingAnchor.constraint(equalTo: lagoonRuleSheet.leadingAnchor, constant: LagoonRuleTideMeasure.sideInset),
            scene.reefHeadingGlyph.trailingAnchor.constraint(equalTo: lagoonRuleSheet.trailingAnchor, constant: -LagoonRuleTideMeasure.sideInset),

            scene.policyTideScroll.topAnchor.constraint(equalTo: scene.reefHeadingGlyph.bottomAnchor, constant: 20),
            scene.policyTideScroll.leadingAnchor.constraint(equalTo: lagoonRuleSheet.leadingAnchor),
            scene.policyTideScroll.trailingAnchor.constraint(equalTo: lagoonRuleSheet.trailingAnchor),
            scene.policyTideScroll.bottomAnchor.constraint(equalTo: scene.shorelineLinksRail.topAnchor, constant: -14),

            scene.policyCopyGlyph.topAnchor.constraint(equalTo: scene.policyTideScroll.contentLayoutGuide.topAnchor),
            scene.policyCopyGlyph.leadingAnchor.constraint(equalTo: scene.policyTideScroll.contentLayoutGuide.leadingAnchor, constant: LagoonRuleTideMeasure.sideInset),
            scene.policyCopyGlyph.trailingAnchor.constraint(equalTo: scene.policyTideScroll.contentLayoutGuide.trailingAnchor, constant: -LagoonRuleTideMeasure.sideInset),
            scene.policyCopyGlyph.bottomAnchor.constraint(equalTo: scene.policyTideScroll.contentLayoutGuide.bottomAnchor),
            scene.policyCopyGlyph.widthAnchor.constraint(equalTo: scene.policyTideScroll.frameLayoutGuide.widthAnchor, constant: -(LagoonRuleTideMeasure.sideInset * 2)),

            scene.shorelineLinksRail.leadingAnchor.constraint(equalTo: lagoonRuleSheet.leadingAnchor, constant: LagoonRuleTideMeasure.sideInset),
            scene.shorelineLinksRail.trailingAnchor.constraint(equalTo: lagoonRuleSheet.trailingAnchor, constant: -LagoonRuleTideMeasure.sideInset),
            scene.shorelineLinksRail.bottomAnchor.constraint(equalTo: scene.consentActionRail.topAnchor, constant: -20),

            scene.consentActionRail.leadingAnchor.constraint(equalTo: lagoonRuleSheet.leadingAnchor, constant: LagoonRuleTideMeasure.actionInset),
            scene.consentActionRail.trailingAnchor.constraint(equalTo: lagoonRuleSheet.trailingAnchor, constant: -LagoonRuleTideMeasure.actionInset),
            scene.consentActionRail.bottomAnchor.constraint(equalTo: lagoonRuleSheet.safeAreaLayoutGuide.bottomAnchor, constant: -LagoonRuleTideMeasure.bottomInset),
            scene.driftAwayControl.heightAnchor.constraint(equalToConstant: LagoonRuleTideMeasure.actionHeight),
            scene.acceptLagoonControl.heightAnchor.constraint(equalToConstant: LagoonRuleTideMeasure.actionHeight)
        ])
    }

    @objc private func openLagoonRuleTerms() {
        onCoastalTermsRoute?()
    }

    @objc private func openLagoonRulePrivacy() {
        onShorelinePrivacyRoute?()
    }

    @objc private func cancelLagoonRuleSheet() {
        dismiss(animated: true)
    }

    @objc private func agreeLagoonRuleSheet() {
        onLagoonConsentAccept?()
        dismiss(animated: true)
    }
}
