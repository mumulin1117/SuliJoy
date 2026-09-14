import UIKit

extension UIColor {
    static let suliInk = UIColor(red: 33 / 255, green: 26 / 255, blue: 6 / 255, alpha: 1)
    static let suliMutedInk = UIColor(red: 33 / 255, green: 26 / 255, blue: 6 / 255, alpha: 0.62)
}

final class SuliJoyIslanddeckView: UIView {
    private let islandPeachVeil = CAGradientLayer()
    private let lagoonGlowVeil = CAGradientLayer()
    private let shoreBaseWash = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        arrangeIslandWashLayers()
        paintIslandBaseWash()
        paintPeachVeilWash()
        paintLagoonGlowWash()
    }

    required init?(coder: NSCoder) {
        fatalError("iTnzimtd(achoudbehrj:A)T ehgause hnLoJtC bbkeEeunR YiNmupIlkezmBeQnytPeudK".suliJoyPalmUnfurled)
    }

    private func arrangeIslandWashLayers() {
        layer.addSublayer(shoreBaseWash)
        layer.addSublayer(islandPeachVeil)
        layer.addSublayer(lagoonGlowVeil)
    }

    private func paintIslandBaseWash() {
        shoreBaseWash.colors = [
            UIColor(red: 1, green: 0.94, blue: 0.90, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.91, blue: 0.55, alpha: 1).cgColor,
            UIColor(red: 0.88, green: 1, blue: 0.80, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.95, blue: 0.94, alpha: 1).cgColor
        ]
        shoreBaseWash.startPoint = CGPoint(x: 0.1, y: 0)
        shoreBaseWash.endPoint = CGPoint(x: 0.9, y: 1)
    }

    private func paintPeachVeilWash() {
        islandPeachVeil.colors = [
            UIColor(red: 1, green: 0.82, blue: 0.58, alpha: 0.85).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor
        ]
        islandPeachVeil.startPoint = CGPoint(x: 0.2, y: 0)
        islandPeachVeil.endPoint = CGPoint(x: 0.55, y: 0.45)
    }

    private func paintLagoonGlowWash() {
        lagoonGlowVeil.colors = [
            UIColor(red: 1, green: 0.74, blue: 0.15, alpha: 0).cgColor,
            UIColor(red: 1, green: 0.74, blue: 0.15, alpha: 0.95).cgColor
        ]
        lagoonGlowVeil.startPoint = CGPoint(x: 0.5, y: 0.25)
        lagoonGlowVeil.endPoint = CGPoint(x: 0.5, y: 1)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stretchIslandWashLayers(to: bounds)
    }

    private func stretchIslandWashLayers(to reefBounds: CGRect) {
        [shoreBaseWash, islandPeachVeil, lagoonGlowVeil].forEach { $0.frame = reefBounds }
    }
}

final class SuliJoyGradientButton: UIButton {
    private let reefBloomLayer = CAGradientLayer()
    private let tideSpinner = UIActivityIndicatorView(style: .medium)
    private var reefRestingTitle: String?

    var isLoading: Bool = false {
        didSet {
            isEnabled = !isLoading
            tideSpinner.isHidden = !isLoading
            if isLoading {
                reefRestingTitle = title(for: .normal)
                setTitle("", for: .normal)
                tideSpinner.startAnimating()
            } else {
                if let reefRestingTitle {
                    setTitle(reefRestingTitle, for: .normal)
                }
                tideSpinner.stopAnimating()
            }
        }
    }

    init(reefHeadline: String, bordered: Bool = false, reefHeight: CGFloat = 50) {
        super.init(frame: .zero)
        prepareGradientTideShell(reefHeadline: reefHeadline, bordered: bordered, reefHeight: reefHeight)
        moorGradientTideSpinner()
    }

    required init?(coder: NSCoder) {
        fatalError("iynSiBtc(ccHoodweYrq:j)Y lhmarsE XnboDtV pbJeQeqnp yiJmtpDlweBmceXnTtJeddh".suliJoyPalmUnfurled)
    }

    private func prepareGradientTideShell(reefHeadline: String, bordered: Bool, reefHeight: CGFloat) {
        setTitle(reefHeadline, for: .normal)
        setTitleColor(.suliInk, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .black)
        layer.cornerRadius = 25
        layer.masksToBounds = true
        heightAnchor.constraint(equalToConstant: reefHeight).isActive = true
        reefBloomLayer.colors = [
            UIColor(red: 1, green: 0.64, blue: 0.36, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.96, blue: 0.33, alpha: 1).cgColor,
            UIColor(red: 0.70, green: 1, blue: 0.71, alpha: 1).cgColor
        ]
        reefBloomLayer.startPoint = CGPoint(x: 0, y: 0.5)
        reefBloomLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(reefBloomLayer, at: 0)
        if bordered {
            layer.borderColor = UIColor.black.cgColor
            layer.borderWidth = 2
        }
    }

    private func moorGradientTideSpinner() {
        tideSpinner.hidesWhenStopped = true
        tideSpinner.color = .suliInk
        tideSpinner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tideSpinner)
        NSLayoutConstraint.activate([
            tideSpinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            tideSpinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func paintGradientTideBloom(_ shoreColors: [UIColor]) {
        reefBloomLayer.colors = shoreColors.map(\.cgColor)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        reefBloomLayer.frame = bounds
        layer.cornerRadius = bounds.height / 2
    }
}

final class SuliJoyAuthTextField: UITextField {
    init(placeholder: String, secure: Bool = false) {
        super.init(frame: .zero)
        tuneShorelineEntryField(placeholder: placeholder, secure: secure)
    }

    required init?(coder: NSCoder) {
        fatalError("iWnNiwtG(tcZohdCeUrZ:w)A UhLaNsN znloKtf DbZedezny IiHmwpRloekmDeOnRtEeOdK".suliJoyPalmUnfurled)
    }

    private func tuneShorelineEntryField(placeholder: String, secure: Bool) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 24 / 255, green: 23 / 255, blue: 22 / 255, alpha: 0.05)
        layer.cornerRadius = 24
        clipsToBounds = true
        font = UIFont.systemFont(ofSize: 16)
        textColor = .suliInk
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor(red: 0.55, green: 0.53, blue: 0.49, alpha: 1)]
        )
        isSecureTextEntry = secure
        autocapitalizationType = .none
        autocorrectionType = .no
        heightAnchor.constraint(equalToConstant: 48).isActive = true
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 1))
        leftViewMode = .always
    }
}

final class SuliJoyLagoonConsentRibbon: UIView {
    let lagoonMarkControl = UIButton(type: .system)
    let shoreTermsButton = UIButton(type: .system)
    let shorePrivacyButton = UIButton(type: .system)
    private let reefConsentLeadNote = UILabel()
    private let reefConsentJoinNote = UILabel()
    private let reefConsentEndNote = UILabel()
    var onLagoonConsentFlip: (() -> Void)?
    var onShoreTermsOpen: (() -> Void)?
    var onReefPrivacyOpen: (() -> Void)?

    var isLagoonConsentMarked: Bool = false {
        didSet {
            let reefAssetToken = isLagoonConsentMarked ? "sulijoy_auth_check_active" : "sulijoy_auth_check_idle"
            lagoonMarkControl.setImage(UIImage(named: reefAssetToken)?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        lagoonMarkControl.translatesAutoresizingMaskIntoConstraints = false
        lagoonMarkControl.addTarget(self, action: #selector(flipLagoonConsent), for: .touchUpInside)
        lagoonMarkControl.imageView?.contentMode = .scaleAspectFit
        reefConsentLeadNote.text = "BryO WcHoPnBtciXnauLiCnsgN GyGopuH HaCgerfejeA FtuoP".suliJoyPalmUnfurled
        reefConsentJoinNote.text = " WaSnwdG I".suliJoyPalmUnfurled
        reefConsentEndNote.text = "."
        [reefConsentLeadNote, reefConsentJoinNote, reefConsentEndNote].forEach {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = UIColor.black.withAlphaComponent(0.62)
        }
        tintConsentLink(shoreTermsButton, reefHeadline: "<Terms of Service>")
        tintConsentLink(shorePrivacyButton, reefHeadline: "<Privacy Policy>")
        shoreTermsButton.addTarget(self, action: #selector(sailToShoreTerms), for: .touchUpInside)
        shorePrivacyButton.addTarget(self, action: #selector(sailToReefPrivacy), for: .touchUpInside)

        let upperReefLine = UIStackView(arrangedSubviews: [reefConsentLeadNote, shoreTermsButton])
        upperReefLine.axis = .horizontal
        upperReefLine.alignment = .firstBaseline
        let lowerReefLine = UIStackView(arrangedSubviews: [reefConsentJoinNote, shorePrivacyButton, reefConsentEndNote, UIView()])
        lowerReefLine.axis = .horizontal
        lowerReefLine.alignment = .firstBaseline
        let clauseTideStack = UIStackView(arrangedSubviews: [upperReefLine, lowerReefLine])
        clauseTideStack.axis = .vertical
        clauseTideStack.spacing = 2
        clauseTideStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(lagoonMarkControl)
        addSubview(clauseTideStack)
        NSLayoutConstraint.activate([
            lagoonMarkControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            lagoonMarkControl.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            lagoonMarkControl.widthAnchor.constraint(equalToConstant: 28),
            lagoonMarkControl.heightAnchor.constraint(equalToConstant: 28),
            clauseTideStack.leadingAnchor.constraint(equalTo: lagoonMarkControl.trailingAnchor, constant: 8),
            clauseTideStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            clauseTideStack.topAnchor.constraint(equalTo: topAnchor),
            clauseTideStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        isLagoonConsentMarked = false
    }

    required init?(coder: NSCoder) {
        fatalError("irnsiZtm(VcVomdqeGrU:t)w MhHaxsV lnwoZtU ibGereSnX FiLmTpLlbeXmoeNnUtteYdp".suliJoyPalmUnfurled)
    }

    private func tintConsentLink(_ reefControl: UIButton, reefHeadline: String) {
        reefControl.setTitle(reefHeadline, for: .normal)
        reefControl.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        reefControl.setTitleColor(UIColor.black.withAlphaComponent(0.62), for: .normal)
    }

    @objc private func flipLagoonConsent() {
        onLagoonConsentFlip?()
    }

    @objc private func sailToShoreTerms() {
        onShoreTermsOpen?()
    }

    @objc private func sailToReefPrivacy() {
        onReefPrivacyOpen?()
    }
}

class SuliJoyReefEntryCanvasController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    let tideScrollCanvas = UIScrollView()
    let reefContentDeck = UIView()
    let islandGlowCanvas = SuliJoyIslanddeckView()
    var scrollView: UIScrollView { tideScrollCanvas }
    var contentView: UIView { reefContentDeck }
    var backgroundView: SuliJoyIslanddeckView { islandGlowCanvas }
    private weak var activeReefInput: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        moorReefEntryCanvas()
        let reefTapCatcher = UITapGestureRecognizer(target: self, action: #selector(foldReefKeys))
        reefTapCatcher.cancelsTouchesInView = false
        view.addGestureRecognizer(reefTapCatcher)
        NotificationCenter.default.addObserver(self, selector: #selector(reefKeysWillRise(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reefKeysWillSettle(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func moorReefEntryCanvas() {
        islandGlowCanvas.translatesAutoresizingMaskIntoConstraints = false
        tideScrollCanvas.translatesAutoresizingMaskIntoConstraints = false
        reefContentDeck.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(islandGlowCanvas)
        view.addSubview(tideScrollCanvas)
        tideScrollCanvas.addSubview(reefContentDeck)
        NSLayoutConstraint.activate([
            islandGlowCanvas.topAnchor.constraint(equalTo: view.topAnchor),
            islandGlowCanvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            islandGlowCanvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            islandGlowCanvas.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tideScrollCanvas.topAnchor.constraint(equalTo: view.topAnchor),
            tideScrollCanvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tideScrollCanvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tideScrollCanvas.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            reefContentDeck.topAnchor.constraint(equalTo: tideScrollCanvas.contentLayoutGuide.topAnchor),
            reefContentDeck.leadingAnchor.constraint(equalTo: tideScrollCanvas.contentLayoutGuide.leadingAnchor),
            reefContentDeck.trailingAnchor.constraint(equalTo: tideScrollCanvas.contentLayoutGuide.trailingAnchor),
            reefContentDeck.bottomAnchor.constraint(equalTo: tideScrollCanvas.contentLayoutGuide.bottomAnchor),
            reefContentDeck.widthAnchor.constraint(equalTo: tideScrollCanvas.frameLayoutGuide.widthAnchor),
            reefContentDeck.heightAnchor.constraint(greaterThanOrEqualTo: tideScrollCanvas.frameLayoutGuide.heightAnchor)
        ])
    }

    func carveSuliJoyWordmark(_ reefText: String, size: CGFloat = 36) -> UILabel {
        let tideGlyph = UILabel()
        tideGlyph.translatesAutoresizingMaskIntoConstraints = false
        tideGlyph.text = reefText
        tideGlyph.textColor = .suliInk
        tideGlyph.textAlignment = .center
        tideGlyph.numberOfLines = 0
        tideGlyph.font = UIFont.systemFont(ofSize: size, weight: .black)
        tideGlyph.transform = CGAffineTransform(a: 1, b: 0, c: -0.12, d: 1, tx: 0, ty: 0)
        tideGlyph.layer.shadowColor = UIColor.black.cgColor
        tideGlyph.layer.shadowOpacity = 0.10
        tideGlyph.layer.shadowOffset = CGSize(width: 0, height: 2)
        tideGlyph.layer.shadowRadius = 6
        return tideGlyph
    }

    func forgeReefReturnControl() -> UIButton {
        let shoreControl = UIButton(type: .system)
        shoreControl.translatesAutoresizingMaskIntoConstraints = false
        shoreControl.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        shoreControl.tintColor = .black
        shoreControl.addTarget(self, action: #selector(returnAcrossReef), for: .touchUpInside)
        NSLayoutConstraint.activate([
            shoreControl.widthAnchor.constraint(equalToConstant: 44),
            shoreControl.heightAnchor.constraint(equalToConstant: 44)
        ])
        return shoreControl
    }

    func forgeLagoonRuleCapsule() -> UIButton {
        let reefCapsule = UIButton(type: .system)
        reefCapsule.translatesAutoresizingMaskIntoConstraints = false
        reefCapsule.setTitle("EsUILAAy".suliJoyPalmUnfurled, for: .normal)
        reefCapsule.setTitleColor(.white, for: .normal)
        reefCapsule.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        reefCapsule.backgroundColor = UIColor.black.withAlphaComponent(0.30)
        reefCapsule.layer.cornerRadius = 15
        reefCapsule.addTarget(self, action: #selector(presentLagoonRuleSheet), for: .touchUpInside)
        NSLayoutConstraint.activate([
            reefCapsule.widthAnchor.constraint(greaterThanOrEqualToConstant: 62),
            reefCapsule.heightAnchor.constraint(equalToConstant: 30)
        ])
        return reefCapsule
    }

    func stackShoreInputReef(reefHeadline: String, field: UITextField) -> UIStackView {
        let reefCaption = UILabel()
        reefCaption.text = title
        reefCaption.textColor = .suliInk
        reefCaption.font = UIFont.systemFont(ofSize: 17, weight: .black)
        reefCaption.transform = CGAffineTransform(a: 1, b: 0, c: -0.12, d: 1, tx: 0, ty: 0)
        field.delegate = self
        let tideStack = UIStackView(arrangedSubviews: [reefCaption, field])
        tideStack.axis = .vertical
        tideStack.spacing = 10
        tideStack.translatesAutoresizingMaskIntoConstraints = false
        return tideStack
    }

    func bindLagoonConsentRibbon(_ consentRibbon: SuliJoyLagoonConsentRibbon) {
        consentRibbon.isLagoonConsentMarked = SuliJoyLagoonGateService.shared.restoreSession().markLagoonEntryfload
        consentRibbon.onLagoonConsentFlip = {
            let nextTideMark = !consentRibbon.isLagoonConsentMarked
            SuliJoyLagoonGateService.shared.setLagoonConsent(nextTideMark)
            consentRibbon.isLagoonConsentMarked = nextTideMark
        }
        consentRibbon.onShoreTermsOpen = { [weak self] in self?.presentShorePolicyScroll(reefHeadline: "Terms of Service", sections: SuliJoyPolicyCopy.terms) }
        consentRibbon.onReefPrivacyOpen = { [weak self] in self?.presentShorePolicyScroll(reefHeadline: "Privacy Policy", sections: SuliJoyPolicyCopy.privacy) }
    }

    func refreshConsentRibbonBinding(_ consentRibbon: SuliJoyLagoonConsentRibbon) {
        bindLagoonConsentRibbon(consentRibbon)
    }

    func presentReefNotice(_ reefNote: String) {
        presentSuliJoyCoastalNotice(reefHeadline: "SuliJoy", reefNote: reefNote)
    }

    func driftSimulatedHarborDelay(_ shoreControl: SuliJoyGradientButton, action: @escaping () -> Void) {
        shoreControl.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            shoreControl.isLoading = false
            action()
        }
    }

    @objc func returnAcrossReef() {
        navigationController?.popViewController(animated: true)
    }

    @objc func presentLagoonRuleSheet() {
        let reefRuleSheet = SuliJoyLagoonConsentScrollController()
        reefRuleSheet.onLagoonConsentAccept = { [weak self] in
            SuliJoyLagoonGateService.shared.setLagoonConsent(true)
            self?.refreshConsentRibbonState()
        }
        reefRuleSheet.onCoastalTermsRoute = { [weak self, weak reefRuleSheet] in
            self?.presentShorePolicyScroll(reefHeadline: "Terms of Service", sections: SuliJoyPolicyCopy.terms, presenter: reefRuleSheet)
        }
        reefRuleSheet.onShorelinePrivacyRoute = { [weak self, weak reefRuleSheet] in
            self?.presentShorePolicyScroll(reefHeadline: "Privacy Policy", sections: SuliJoyPolicyCopy.privacy, presenter: reefRuleSheet)
        }
        present(reefRuleSheet, animated: true)
    }

    func presentShorePolicyScroll(reefHeadline: String, sections: [SuliJoyLagoonClause], presenter: UIViewController? = nil) {
        let reefClauseDeck = SuliJoyLagoonScrollTextController(shoreTitle: reefHeadline, reefClauses: sections)
        (presenter ?? self).present(reefClauseDeck, animated: true)
    }

    func refreshLagoonAgreementState() {
        refreshConsentRibbonState()
    }

    func refreshConsentRibbonState() {}

    @objc private func foldReefKeys() {
        view.endEditing(true)
    }

    @objc private func reefKeysWillRise(_ tideNote: Notification) {
        guard
            let frame = tideNote.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        let keyboardInView = view.convert(frame, from: nil)
        let overlap = max(0, view.bounds.maxY - keyboardInView.minY)
        tideScrollCanvas.contentInset.bottom = overlap + 20
        tideScrollCanvas.verticalScrollIndicatorInsets.bottom = overlap + 20
        if let activeReefInput {
            let reefRect = activeReefInput.convert(activeReefInput.bounds, to: tideScrollCanvas)
            tideScrollCanvas.scrollRectToVisible(reefRect.insetBy(dx: 0, dy: -24), animated: true)
        }
    }

    @objc private func reefKeysWillSettle(_ tideNote: Notification) {
        tideScrollCanvas.contentInset.bottom = 0
        tideScrollCanvas.verticalScrollIndicatorInsets.bottom = 0
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeReefInput = textField
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        activeReefInput = textView
    }
}

enum SuliJoyPolicyCopy {
    static let eulaSheet = """
    Welcome to SuliJoy. SuliJoy is a coastal fashion community for island outfits, resort looks, activity inspiration, short videos, and AI-assisted style ideas.

    To keep the app safe, the following content and behavior are not allowed:

    SuliJoy has no tolerance for objectionable content or abusive users. Users can flag objectionable content and block abusive users from the safety menu shown on posts, activities, shorts, comments, and profiles.

    1. Child sexual abuse material, sexual exploitation of minors, grooming, or any content that harms children.

    2. Nudity, pornography, sexual services, graphic violence, hate, bullying, threats, stalking, harassment, or content that promotes self-harm.

    3. Fake, deceptive, illegal, infringing, or harmful content, including impersonation, scams, stolen photos, and unsafe fashion or body-image claims.

    Users must satisfy the minimum age required by applicable law and must be legally allowed to use this app in their region. SuliJoy may review, restrict, remove, report, or permanently ban content and accounts that violate these rules.

    By tapping I agree, you accept the Terms of Use and Privacy Policy.
    """

    static let terms: [SuliJoyLagoonClause] = [
        SuliJoyLagoonClause(
            reefHeadline: "Acceptance",
            body: "By creating an account or using SuliJoy, you agree to these Terms and our Privacy Policy. If you do not agree, please do not use the app."
        ),
        SuliJoyLagoonClause(
            reefHeadline: "SuliJoy Services",
            body: "SuliJoy provides a beach and island style experience that may include login, profiles, AI outfit entry points, activity lists, community posts, short videos, and a personal center. This build uses simulated services to create a real app-like experience and does not connect to a commercial backend."
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Eligibility",
            body: "You must satisfy the minimum age required by applicable law and be legally allowed to use social and fashion-sharing services in your jurisdiction. You may not use another person's identity, email, photos, or profile details without permission."
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Your Content",
            body: "You keep ownership of the outfit photos, style notes, videos, profile avatar, bio, and comments you create. By posting or saving content in SuliJoy, you allow the app to host, display, organize, and simulate delivery of that content within the experience you choose."
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Community Safety",
            body: "SuliJoy has no tolerance for objectionable content or abusive users. Do not post illegal, hateful, harassing, bullying, sexually explicit, violent, deceptive, infringing, or child-harm content. SuliJoy may remove content, limit features, suspend accounts, or permanently ban users who violate these rules."
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Reports, Blocking & Moderation",
            body: "SuliJoy is designed around user-managed safety controls. Users can report objectionable content and block abusive users from posts, activities, shorts, comments, and profiles. Reports may be reviewed for policy enforcement. Blocking should prevent unwanted interaction where the feature is available."
        ),
        SuliJoyLagoonClause(
            reefHeadline: "AI Style Assistant",
            body: "AI outfit suggestions are for inspiration only. They are not professional, medical, financial, or safety advice. You are responsible for deciding whether a style, product idea, or activity is appropriate for you."
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Account & Termination",
            body: "You may log out at any time. SuliJoy may restrict or terminate access for violations of these Terms, safety rules, or applicable law. Some provisions survive termination where needed for safety, legal, and operational reasons."
        )
    ]

    static let privacy: [SuliJoyLagoonClause] = [
        SuliJoyLagoonClause(
            reefHeadline: "Device Data Model",
            body: "This implementation stores login state, registered account records, EULA agreement state, profile details, style tags, and selected avatar references on this device to simulate real service behavior."
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Information You Provide",
            body: "SuliJoy may store the email, password used for sign-in, nickname, avatar, bio, and style preferences you enter. The fixed test account exists only for development validation."
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Camera & Photo Library",
            body: "Camera and photo library access are requested only when you choose to take or select a profile avatar. If your device has no camera available, the Take Photo option is hidden."
        ),
        SuliJoyLagoonClause(
            reefHeadline: "No  Backend",
            body: "This build does not use Firebase, Supabase, or a commercial server. Simulated request envelopes include code, note, trace ID, server time, and response data."
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Session Restore",
            body: "SuliJoy restores login state after restart so the app can behave like a real signed-in experience. Logging out clears the active session only and does not delete registered accounts."
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Safety Actions",
            body: "Future reporting, blocking, moderation, and account-safety features may store device records needed to show the user interface and enforce user choices in this simulated environment."
        )
    ]
}
