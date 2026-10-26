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
            let reefAssetToken = isLagoonConsentMarked ? "sxuxlxixjxoxyx_xaxuxtxhx_xcxhxexcxkx_xaxcxtxixvxex".suliJoyPalmUnfurled : "sxuxlxixjxoxyx_xaxuxtxhx_xcxhxexcxkx_xixdxlxex".suliJoyPalmUnfurled
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
        reefConsentEndNote.text = ".x".suliJoyPalmUnfurled
        [reefConsentLeadNote, reefConsentJoinNote, reefConsentEndNote].forEach {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = UIColor.black.withAlphaComponent(0.62)
        }
        tintConsentLink(shoreTermsButton, reefHeadline: "<xTxexrxmxsx xoxfx xSxexrxvxixcxex>x".suliJoyPalmUnfurled)
        tintConsentLink(shorePrivacyButton, reefHeadline: "<xPxrxixvxaxcxyx xPxoxlxixcxyx>x".suliJoyPalmUnfurled)
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
        shoreControl.setImage(UIImage(systemName: "axrxrxoxwx.xlxexfxtx".suliJoyPalmUnfurled), for: .normal)
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
        consentRibbon.onShoreTermsOpen = { [weak self] in self?.presentShorePolicyScroll(reefHeadline: "Txexrxmxsx xoxfx xSxexrxvxixcxex".suliJoyPalmUnfurled, sections: SuliJoyPolicyCopy.terms) }
        consentRibbon.onReefPrivacyOpen = { [weak self] in self?.presentShorePolicyScroll(reefHeadline: "Pxrxixvxaxcxyx xPxoxlxixcxyx".suliJoyPalmUnfurled, sections: SuliJoyPolicyCopy.privacy) }
    }

    func refreshConsentRibbonBinding(_ consentRibbon: SuliJoyLagoonConsentRibbon) {
        bindLagoonConsentRibbon(consentRibbon)
    }

    func presentReefNotice(_ reefNote: String) {
        presentSuliJoyCoastalNotice(reefHeadline: "SxuxlxixJxoxyx".suliJoyPalmUnfurled, reefNote: reefNote)
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
            self?.presentShorePolicyScroll(reefHeadline: "Txexrxmxsx xoxfx xSxexrxvxixcxex".suliJoyPalmUnfurled, sections: SuliJoyPolicyCopy.terms, presenter: reefRuleSheet)
        }
        reefRuleSheet.onShorelinePrivacyRoute = { [weak self, weak reefRuleSheet] in
            self?.presentShorePolicyScroll(reefHeadline: "Pxrxixvxaxcxyx xPxoxlxixcxyx".suliJoyPalmUnfurled, sections: SuliJoyPolicyCopy.privacy, presenter: reefRuleSheet)
        }
        present(reefRuleSheet, animated: true)
    }

    func presentShorePolicyScroll(reefHeadline: String, sections: [SuliJoyLagoonClause], presenter: UIViewController? = nil) {
        let reefClauseDeck = SuliJoyLagoonScrollTextController(shoreTitle: reefHeadline, reefClauses: sections)
        (presenter ?? self).present(reefClauseDeck, animated: true)
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
    static let eulaSheet = "Wxexlxcxoxmxex xtxox xSxuxlxixJxoxyx.x xSxuxlxixJxoxyx xixsx xax xcxoxaxsxtxaxlx xfxaxsxhxixoxnx xcxoxmxmxuxnxixtxyx xfxoxrx xixsxlxaxnxdx xoxuxtxfxixtxsx,x xrxexsxoxrxtx xlxoxoxkxsx,x xaxcxtxixvxixtxyx xixnxsxpxixrxaxtxixoxnx,x xsxhxoxrxtx xvxixdxexoxsx,x xaxnxdx xAxIx-xaxsxsxixsxtxexdx xsxtxyxlxex xixdxexaxsx.x\nx\nxTxox xkxexexpx xtxhxex xaxpxpx xsxaxfxex,x xtxhxex xfxoxlxlxoxwxixnxgx xcxoxnxtxexnxtx xaxnxdx xbxexhxaxvxixoxrx xaxrxex xnxoxtx xaxlxlxoxwxexdx:x\nx\nxSxuxlxixJxoxyx xhxaxsx xnxox xtxoxlxexrxaxnxcxex xfxoxrx xoxbxjxexcxtxixoxnxaxbxlxex xcxoxnxtxexnxtx xoxrx xaxbxuxsxixvxex xuxsxexrxsx.x xUxsxexrxsx xcxaxnx xfxlxaxgx xoxbxjxexcxtxixoxnxaxbxlxex xcxoxnxtxexnxtx xaxnxdx xbxlxoxcxkx xaxbxuxsxixvxex xuxsxexrxsx xfxrxoxmx xtxhxex xsxaxfxextxyx xmxexnxux xsxhxoxwxnx xoxnx xpxoxsxtxsx,x xaxcxtxixvxixtxixexsx,x xsxhxoxrxtxsx,x xcxoxmxmxexnxtxsx,x xaxnxdx xpxrxoxfxixlxexsx.x\nx\nx1x.x xCxhxixlxdx xsxexxxuxaxlx xaxbxuxsxex xmxaxtxexrxixaxlx,x xsxexxxuxaxlx xexxxpxlxoxixtxaxtxixoxnx xoxfx xmxixnxoxrxsx,x xgxrxoxoxmxixnxgx,x xoxrx xaxnxyx xcxoxnxtxexnxtx xtxhxaxtx xhxaxrxmxsx xcxhxixlxdxrxexnx.x\nx\nx2x.x xNxuxdxixtxyx,x xpxoxrxnxoxgxrxaxpxhxyx,x xsxexxxuxaxlx xsxexrxvxixcxexsx,x xgxrxaxpxhxixcx xvxixoxlxexnxcxex,x xhxaxtxex,x xbxuxlxlxyxixnxgx,x xtxhxrxexaxtxsx,x xsxtxaxlxkxixnxgx,x xhxaxrxaxsxsxmxexnxtx,x xoxrx xcxoxnxtxexnxtx xtxhxaxtx xpxrxoxmxoxtxexsx xsxexlxfx-xhxaxrxmx.x\nx\nx3x.x xFxaxkxex,x xdxexcxexpxtxixvxex,x xixlxlxexgxaxlx,x xixnxfxrxixnxgxixnxgx,x xoxrx xhxaxrxmxfxuxlx xcxoxnxtxexnxtx,x xixnxcxlxuxdxixnxgx xixmxpxexrxsxoxnxaxtxixoxnx,x xsxcxaxmxsx,x xsxtxoxlxexnx xpxhxoxtxoxsx,x xaxnxdx xuxnxsxaxfxex xfxaxsxhxixoxnx xoxrx xbxoxdxyx-xixmxaxgxex xcxlxaxixmxsx.x\nx\nxUxsxexrxsx xmxuxsxtx xsxaxtxixsxfxyx xtxhxex xmxixnxixmxuxmx xaxgxex xrxexqxuxixrxexdx xbxyx xaxpxpxlxixcxaxbxlxex xlxaxwx xaxnxdx xmxuxsxtx xbxex xlxexgxaxlxlxyx xaxlxlxoxwxexdx xtxox xuxsxex xtxhxixsx xaxpxpx xixnx xtxhxexixrx xrxexgxixoxnx.x xSxuxlxixJxoxyx xmxaxyx xrxexvxixexwx,x xrxexsxtxrxixcxtx,x xrxexmxoxvxex,x xrxexpxoxrxtx,x xoxrx xpxexrxmxaxnxexnxtxlxyx xbxaxnx xcxoxnxtxexnxtx xaxnxdx xaxcxcxoxuxnxtxsx xtxhxaxtx xvxixoxlxaxtxex xtxhxexsxex xrxuxlxexsx.x\nx\nxBxyx xtxaxpxpxixnxgx xIx xaxgxrxexex,x xyxoxux xaxcxcxexpxtx xtxhxex xTxexrxmxsx xoxfx xUxsxex xaxnxdx xPxrxixvxaxcxyx xPxoxlxixcxyx.x".suliJoyPalmUnfurled

    static let terms: [SuliJoyLagoonClause] = [
        SuliJoyLagoonClause(
            reefHeadline: "Axcxcxexpxtxaxnxcxex".suliJoyPalmUnfurled,
            sandofferbody: "Bxyx xcxrxexaxtxixnxgx xaxnx xaxcxcxoxuxnxtx xoxrx xuxsxixnxgx xSxuxlxixJxoxyx,x xyxoxux xaxgxrxexex xtxox xtxhxexsxex xTxexrxmxsx xaxnxdx xoxuxrx xPxrxixvxaxcxyx xPxoxlxixcxyx.x xIxfx xyxoxux xdxox xnxoxtx xaxgxrxexex,x xpxlxexaxsxex xdxox xnxoxtx xuxsxex xtxhxex xaxpxpx.x".suliJoyPalmUnfurled
        ),
        SuliJoyLagoonClause(
            reefHeadline: "SxuxlxixJxoxyx xSxexrxvxixcxexsx".suliJoyPalmUnfurled,
            sandofferbody: "SxuxlxixJxoxyx xpxrxoxvxixdxexsx xax xbxexaxcxhx xaxnxdx xixsxlxaxnxdx xsxtxyxlxex xexxxpxexrxixexnxcxex xtxhxaxtx xmxaxyx xixnxcxlxuxdxex xlxoxgxixnx,x xpxrxoxfxixlxexsx,x xAxIx xoxuxtxfxixtx xexnxtxrxyx xpxoxixnxtxsx,x xaxcxtxixvxixtxyx xlxixsxtxsx,x xcxoxmxmxuxnxixtxyx xpxoxsxtxsx,x xsxhxoxrxtx xvxixdxexoxsx,x xaxnxdx xax xpxexrxsxoxnxaxlx xcxexnxtxexrx.x xTxhxixsx xbxuxixlxdx xuxsxexsx xsxixmxuxlxaxtxexdx xsxexrxvxixcxexsx xtxox xcxrxexaxtxex xax xrxexaxlx xaxpxpx-xlxixkxex xexxxpxexrxixexnxcxex xaxnxdx xdxoxexsx xnxoxtx xcxoxnxnxexcxtx xtxox xax xcxoxmxmxexrxcxixaxlx xbxaxcxkxexnxdx.x".suliJoyPalmUnfurled
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Exlxixgxixbxixlxixtxyx".suliJoyPalmUnfurled,
            sandofferbody: "Yxoxux xmxuxsxtx xsxaxtxixsxfxyx xtxhxex xmxixnxixmxuxmx xaxgxex xrxexqxuxixrxexdx xbxyx xaxpxpxlxixcxaxbxlxex xlxaxwx xaxnxdx xbxex xlxexgxaxlxlxyx xaxlxlxoxwxexdx xtxox xuxsxex xsxoxcxixaxlx xaxnxdx xfxaxsxhxixoxnx-xsxhxaxrxixnxgx xsxexrxvxixcxexsx xixnx xyxoxuxrx xjxuxrxixsxdxixcxtxixoxnx.x xYxoxux xmxaxyx xnxoxtx xuxsxex xaxnxoxtxhxexrx xpxexrxsxoxnx'xsx xixdxexnxtxixtxyx,x xexmxaxixlx,x xpxhxoxtxoxsx,x xoxrx xpxrxoxfxixlxex xdxextxaxixlxsx xwxixtxhxoxuxtx xpxexrxmxixsxsxixoxnx.x".suliJoyPalmUnfurled
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Yxoxuxrx xCxoxnxtxexnxtx".suliJoyPalmUnfurled,
            sandofferbody: "Yxoxux xkxexexpx xoxwxnxexrxsxhxixpx xoxfx xtxhxex xoxuxtxfxixtx xpxhxoxtxoxsx,x xsxtxyxlxex xnxoxtxexsx,x xvxixdxexoxsx,x xpxrxoxfxixlxex xaxvxaxtxaxrx,x xbxixox,x xaxnxdx xcxoxmxmxexnxtxsx xyxoxux xcxrxexaxtxex.x xBxyx xpxoxsxtxixnxgx xoxrx xsxaxvxixnxgx xcxoxnxtxexnxtx xixnx xSxuxlxixJxoxyx,x xyxoxux xaxlxlxoxwx xtxhxex xaxpxpx xtxox xhxoxsxtx,x xdxixsxpxlxaxyx,x xoxrxgxaxnxixzxex,x xaxnxdx xsxixmxuxlxaxtxex xdxexlxixvxexrxyx xoxfx xtxhxaxtx xcxoxnxtxexnxtx xwxixtxhxixnx xtxhxex xexxxpxexrxixexnxcxex xyxoxux xcxhxoxoxsxex.x".suliJoyPalmUnfurled
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Cxoxmxmxuxnxixtxyx xSxaxfxextxyx".suliJoyPalmUnfurled,
            sandofferbody: "SxuxlxixJxoxyx xhxaxsx xnxox xtxoxlxexrxaxnxcxex xfxoxrx xoxbxjxexcxtxixoxnxaxbxlxex xcxoxnxtxexnxtx xoxrx xaxbxuxsxixvxex xuxsxexrxsx.x xDxox xnxoxtx xpxoxsxtx xixlxlxexgxaxlx,x xhxaxtxexfxuxlx,x xhxaxrxaxsxsxixnxgx,x xbxuxlxlxyxixnxgx,x xsxexxxuxaxlxlxyx xexxxpxlxixcxixtx,x xvxixoxlxexnxtx,x xdxexcxexpxtxixvxex,x xixnxfxrxixnxgxixnxgx,x xoxrx xcxhxixlxdx-xhxaxrxmx xcxoxnxtxexnxtx.x xSxuxlxixJxoxyx xmxaxyx xrxexmxoxvxex xcxoxnxtxexnxtx,x xlxixmxixtx xfxexaxtxuxrxexsx,x xsxuxsxpxexnxdx xaxcxcxoxuxnxtxsx,x xoxrx xpxexrxmxaxnxexnxtxlxyx xbxaxnx xuxsxexrxsx xwxhxox xvxixoxlxaxtxex xtxhxexsxex xrxuxlxexsx.x".suliJoyPalmUnfurled
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Rxexpxoxrxtxsx,x xBxlxoxcxkxixnxgx x&x xMxoxdxexrxaxtxixoxnx".suliJoyPalmUnfurled,
            sandofferbody: "SxuxlxixJxoxyx xixsx xdxexsxixgxnxexdx xaxrxoxuxnxdx xuxsxexrx-xmxaxnxaxgxexdx xsxaxfxextxyx xcxoxnxtxrxoxlxsx.x xUxsxexrxsx xcxaxnx xrxexpxoxrxtx xoxbxjxexcxtxixoxnxaxbxlxex xcxoxnxtxexnxtx xaxnxdx xbxlxoxcxkx xaxbxuxsxixvxex xuxsxexrxsx xfxrxoxmx xpxoxsxtxsx,x xaxcxtxixvxixtxixexsx,x xsxhxoxrxtxsx,x xcxoxmxmxexnxtxsx,x xaxnxdx xpxrxoxfxixlxexsx.x xRxexpxoxrxtxsx xmxaxyx xbxex xrxexvxixexwxexdx xfxoxrx xpxoxlxixcxyx xexnxfxoxrxcxexmxexnxtx.x xBxlxoxcxkxixnxgx xsxhxoxuxlxdx xpxrxexvxexnxtx xuxnxwxaxnxtxexdx xixnxtxexrxaxcxtxixoxnx xwxhxexrxex xtxhxex xfxexaxtxuxrxex xixsx xaxvxaxixlxaxbxlxex.x".suliJoyPalmUnfurled
        ),
        SuliJoyLagoonClause(
            reefHeadline: "AxIx xSxtxyxlxex xAxsxsxixsxtxaxnxtx".suliJoyPalmUnfurled,
            sandofferbody: "AxIx xoxuxtxfxixtx xsxuxgxgxexsxtxixoxnxsx xaxrxex xfxoxrx xixnxsxpxixrxaxtxixoxnx xoxnxlxyx.x xTxhxexyx xaxrxex xnxoxtx xpxrxoxfxexsxsxixoxnxaxlx,x xmxexdxixcxaxlx,x xfxixnxaxnxcxixaxlx,x xoxrx xsxaxfxextxyx xaxdxvxixcxex.x xYxoxux xaxrxex xrxexsxpxoxnxsxixbxlxex xfxoxrx xdxexcxixdxixnxgx xwxhxextxhxexrx xax xsxtxyxlxex,x xpxrxoxdxuxcxtx xixdxexax,x xoxrx xaxcxtxixvxixtxyx xixsx xaxpxpxrxoxpxrxixaxtxex xfxoxrx xyxoxux.x".suliJoyPalmUnfurled
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Axcxcxoxuxnxtx x&x xTxexrxmxixnxaxtxixoxnx".suliJoyPalmUnfurled,
            sandofferbody: "Yxoxux xmxaxyx xlxoxgx xoxuxtx xaxtx xaxnxyx xtxixmxex.x xSxuxlxixJxoxyx xmxaxyx xrxexsxtxrxixcxtx xoxrx xtxexrxmxixnxaxtxex xaxcxcxexsxsx xfxoxrx xvxixoxlxaxtxixoxnxsx xoxfx xtxhxexsxex xTxexrxmxsx,x xsxaxfxextxyx xrxuxlxexsx,x xoxrx xaxpxpxlxixcxaxbxlxex xlxaxwx.x xSxoxmxex xpxrxoxvxixsxixoxnxsx xsxuxrxvxixvxex xtxexrxmxixnxaxtxixoxnx xwxhxexrxex xnxexexdxexdx xfxoxrx xsxaxfxextxyx,x xlxexgxaxlx,x xaxnxdx xoxpxexrxaxtxixoxnxaxlx xrxexaxsxoxnxsx.x".suliJoyPalmUnfurled
        )
    ]

    static let privacy: [SuliJoyLagoonClause] = [
        SuliJoyLagoonClause(
            reefHeadline: "Dxexvxixcxex xDxaxtxax xMxoxdxexlx".suliJoyPalmUnfurled,
            sandofferbody: "Txhxixsx xixmxpxlxexmxexnxtxaxtxixoxnx xsxtxoxrxexsx xlxoxgxixnx xsxtxaxtxex,x xrxexgxixsxtxexrxexdx xaxcxcxoxuxnxtx xrxexcxoxrxdxsx,x xExUxLxAx xaxgxrxexexmxexnxtx xsxtxaxtxex,x xpxrxoxfxixlxex xdxextxaxixlxsx,x xsxtxyxlxex xtxaxgxsx,x xaxnxdx xsxexlxexcxtxexdx xaxvxaxtxaxrx xrxexfxexrxexnxcxexsx xoxnx xtxhxixsx xdxexvxixcxex xtxox xsxixmxuxlxaxtxex xrxexaxlx xsxexrxvxixcxex xbxexhxaxvxixoxrx.x".suliJoyPalmUnfurled
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Ixnxfxoxrxmxaxtxixoxnx xYxoxux xPxrxoxvxixdxex".suliJoyPalmUnfurled,
            sandofferbody: "SxuxlxixJxoxyx xmxaxyx xsxtxoxrxex xtxhxex xexmxaxixlx,x xpxaxsxsxwxoxrxdx xuxsxexdx xfxoxrx xsxixgxnx-xixnx,x xnxixcxkxnxaxmxex,x xaxvxaxtxaxrx,x xbxixox,x xaxnxdx xsxtxyxlxex xpxrxexfxexrxexnxcxexsx xyxoxux xexnxtxexrx.x xTxhxex xfxixxxexdx xtxexsxtx xaxcxcxoxuxnxtx xexxxixsxtxsx xoxnxlxyx xfxoxrx xdxexvxexlxoxpxmxexnxtx xvxaxlxixdxaxtxixoxnx.x".suliJoyPalmUnfurled
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Cxaxmxexrxax x&x xPxhxoxtxox xLxixbxrxaxrxyx".suliJoyPalmUnfurled,
            sandofferbody: "Cxaxmxexrxax xaxnxdx xpxhxoxtxox xlxixbxrxaxrxyx xaxcxcxexsxsx xaxrxex xrxexqxuxexsxtxexdx xoxnxlxyx xwxhxexnx xyxoxux xcxhxoxoxsxex xtxox xtxaxkxex xoxrx xsxexlxexcxtx xax xpxrxoxfxixlxex xaxvxaxtxaxrx.x xIxfx xyxoxuxrx xdxexvxixcxex xhxaxsx xnxox xcxaxmxexrxax xaxvxaxixlxaxbxlxex,x xtxhxex xTxaxkxex xPxhxoxtxox xoxpxtxixoxnx xixsx xhxixdxdxexnx.x".suliJoyPalmUnfurled
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Nxox x xBxaxcxkxexnxdx".suliJoyPalmUnfurled,
            sandofferbody: "Txhxixsx xbxuxixlxdx xdxoxexsx xnxoxtx xuxsxex xFxixrxexbxaxsxex,x xSxuxpxaxbxaxsxex,x xoxrx xax xcxoxmxmxexrxcxixaxlx xsxexrxvxexrx.x xSxixmxuxlxaxtxexdx xrxexqxuxexsxtx xexnxvxexlxoxpxexsx xixnxcxlxuxdxex xcxoxdxex,x xnxoxtxex,x xtxrxaxcxex xIxDx,x xsxexrxvxexrx xtxixmxex,x xaxnxdx xrxexsxpxoxnxsxex xdxaxtxax.x".suliJoyPalmUnfurled
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Sxexsxsxixoxnx xRxexsxtxoxrxex".suliJoyPalmUnfurled,
            sandofferbody: "SxuxlxixJxoxyx xrxexsxtxoxrxexsx xlxoxgxixnx xsxtxaxtxex xaxfxtxexrx xrxexsxtxaxrxtx xsxox xtxhxex xaxpxpx xcxaxnx xbxexhxaxvxex xlxixkxex xax xrxexaxlx xsxixgxnxexdx-xixnx xexxxpxexrxixexnxcxex.x xLxoxgxgxixnxgx xoxuxtx xcxlxexaxrxsx xtxhxex xaxcxtxixvxex xsxexsxsxixoxnx xoxnxlxyx xaxnxdx xdxoxexsx xnxoxtx xdxexlxextxex xrxexgxixsxtxexrxexdx xaxcxcxoxuxnxtxsx.x".suliJoyPalmUnfurled
        ),
        SuliJoyLagoonClause(
            reefHeadline: "Sxaxfxextxyx xAxcxtxixoxnxsx".suliJoyPalmUnfurled,
            sandofferbody: "Fxuxtxuxrxex xrxexpxoxrxtxixnxgx,x xbxlxoxcxkxixnxgx,x xmxoxdxexrxaxtxixoxnx,x xaxnxdx xaxcxcxoxuxnxtx-xsxaxfxextxyx xfxexaxtxuxrxexsx xmxaxyx xsxtxoxrxex xdxexvxixcxex xrxexcxoxrxdxsx xnxexexdxexdx xtxox xsxhxoxwx xtxhxex xuxsxexrx xixnxtxexrxfxaxcxex xaxnxdx xexnxfxoxrxcxex xuxsxexrx xcxhxoxixcxexsx xixnx xtxhxixsx xsxixmxuxlxaxtxexdx xexnxvxixrxoxnxmxexnxtx.x".suliJoyPalmUnfurled
        )
    ]
}
