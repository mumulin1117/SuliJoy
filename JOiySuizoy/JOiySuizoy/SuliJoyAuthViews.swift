import UIKit

extension UIColor {
    static let suliInk = UIColor(red: 33 / 255, green: 26 / 255, blue: 6 / 255, alpha: 1)
    static let suliMutedInk = UIColor(red: 33 / 255, green: 26 / 255, blue: 6 / 255, alpha: 0.62)
}

final class SuliJoyIslandBackgroundView: UIView {
    private let peach = CAGradientLayer()
    private let glow = CAGradientLayer()
    private let base = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        layer.addSublayer(base)
        layer.addSublayer(peach)
        layer.addSublayer(glow)
        base.colors = [
            UIColor(red: 1, green: 0.94, blue: 0.90, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.91, blue: 0.55, alpha: 1).cgColor,
            UIColor(red: 0.88, green: 1, blue: 0.80, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.95, blue: 0.94, alpha: 1).cgColor
        ]
        base.startPoint = CGPoint(x: 0.1, y: 0)
        base.endPoint = CGPoint(x: 0.9, y: 1)
        peach.colors = [
            UIColor(red: 1, green: 0.82, blue: 0.58, alpha: 0.85).cgColor,
            UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor
        ]
        peach.startPoint = CGPoint(x: 0.2, y: 0)
        peach.endPoint = CGPoint(x: 0.55, y: 0.45)
        glow.colors = [
            UIColor(red: 1, green: 0.74, blue: 0.15, alpha: 0).cgColor,
            UIColor(red: 1, green: 0.74, blue: 0.15, alpha: 0.95).cgColor
        ]
        glow.startPoint = CGPoint(x: 0.5, y: 0.25)
        glow.endPoint = CGPoint(x: 0.5, y: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        base.frame = bounds
        peach.frame = bounds
        glow.frame = bounds
    }
}

final class SuliJoyGradientButton: UIButton {
    private let gradientLayer = CAGradientLayer()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private var normalTitle: String?

    var isLoading: Bool = false {
        didSet {
            isEnabled = !isLoading
            spinner.isHidden = !isLoading
            if isLoading {
                normalTitle = title(for: .normal)
                setTitle("", for: .normal)
                spinner.startAnimating()
            } else {
                if let normalTitle {
                    setTitle(normalTitle, for: .normal)
                }
                spinner.stopAnimating()
            }
        }
    }

    init(title: String, bordered: Bool = false) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.suliInk, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .black)
        layer.cornerRadius = 25
        layer.masksToBounds = true
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        gradientLayer.colors = [
            UIColor(red: 1, green: 0.64, blue: 0.36, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.96, blue: 0.33, alpha: 1).cgColor,
            UIColor(red: 0.70, green: 1, blue: 0.71, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
        if bordered {
            layer.borderColor = UIColor.black.cgColor
            layer.borderWidth = 2
        }
        spinner.hidesWhenStopped = true
        spinner.color = .suliInk
        spinner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        layer.cornerRadius = bounds.height / 2
    }
}

final class SuliJoyAuthTextField: UITextField {
    init(placeholder: String, secure: Bool = false) {
        super.init(frame: .zero)
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class SuliJoyAgreementView: UIView {
    let checkbox = UIButton(type: .system)
    let termsButton = UIButton(type: .system)
    let privacyButton = UIButton(type: .system)
    private let prefixLabel = UILabel()
    private let andLabel = UILabel()
    private let dotLabel = UILabel()
    var onToggle: (() -> Void)?
    var onTerms: (() -> Void)?
    var onPrivacy: (() -> Void)?

    var isAgreed: Bool = false {
        didSet {
            let assetName = isAgreed ? "sulijoy_auth_check_active" : "sulijoy_auth_check_idle"
            checkbox.setImage(UIImage(named: assetName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.addTarget(self, action: #selector(toggleAgreement), for: .touchUpInside)
        checkbox.imageView?.contentMode = .scaleAspectFit
        prefixLabel.text = "By continuing you agree to"
        andLabel.text = " and "
        dotLabel.text = "."
        [prefixLabel, andLabel, dotLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 13)
            $0.textColor = UIColor.black.withAlphaComponent(0.62)
        }
        configureLink(termsButton, title: "<Terms of Service>")
        configureLink(privacyButton, title: "<Privacy Policy>")
        termsButton.addTarget(self, action: #selector(openTerms), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(openPrivacy), for: .touchUpInside)

        let lineOne = UIStackView(arrangedSubviews: [prefixLabel, termsButton])
        lineOne.axis = .horizontal
        lineOne.alignment = .firstBaseline
        let lineTwo = UIStackView(arrangedSubviews: [andLabel, privacyButton, dotLabel, UIView()])
        lineTwo.axis = .horizontal
        lineTwo.alignment = .firstBaseline
        let textStack = UIStackView(arrangedSubviews: [lineOne, lineTwo])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(checkbox)
        addSubview(textStack)
        NSLayoutConstraint.activate([
            checkbox.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkbox.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            checkbox.widthAnchor.constraint(equalToConstant: 28),
            checkbox.heightAnchor.constraint(equalToConstant: 28),
            textStack.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 8),
            textStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            textStack.topAnchor.constraint(equalTo: topAnchor),
            textStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        isAgreed = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLink(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.setTitleColor(UIColor.black.withAlphaComponent(0.62), for: .normal)
    }

    @objc private func toggleAgreement() {
        onToggle?()
    }

    @objc private func openTerms() {
        onTerms?()
    }

    @objc private func openPrivacy() {
        onPrivacy?()
    }
}

class SuliJoyAuthBaseViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let backgroundView = SuliJoyIslandBackgroundView()
    private weak var activeInput: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBaseLayout()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupBaseLayout() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }

    func makeTitle(_ text: String, size: CGFloat = 36) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = .suliInk
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: size, weight: .black)
        label.transform = CGAffineTransform(a: 1, b: 0, c: -0.12, d: 1, tx: 0, ty: 0)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.10
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 6
        return label
    }

    func makeBackButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        return button
    }

    func makeEULAButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("EULA", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.30)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(openEULA), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 62),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
        return button
    }

    func makeFieldBlock(title: String, field: UITextField) -> UIStackView {
        let label = UILabel()
        label.text = title
        label.textColor = .suliInk
        label.font = UIFont.systemFont(ofSize: 17, weight: .black)
        label.transform = CGAffineTransform(a: 1, b: 0, c: -0.12, d: 1, tx: 0, ty: 0)
        field.delegate = self
        let stack = UIStackView(arrangedSubviews: [label, field])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }

    func updateAgreement(_ agreement: SuliJoyAgreementView) {
        agreement.isAgreed = SuliJoyLocalAuthService.shared.restoreSession().hasAgreedEULA
        agreement.onToggle = {
            let next = !agreement.isAgreed
            SuliJoyLocalAuthService.shared.setEULAAgreed(next)
            agreement.isAgreed = next
        }
        agreement.onTerms = { [weak self] in self?.showPolicy(title: "Terms of Service", sections: SuliJoyPolicyCopy.terms) }
        agreement.onPrivacy = { [weak self] in self?.showPolicy(title: "Privacy Policy", sections: SuliJoyPolicyCopy.privacy) }
    }

    func showAlert(_ message: String) {
        presentSuliJoyNotice(title: "SuliJoy", message: message)
    }

    func simulateRequest(_ button: SuliJoyGradientButton, action: @escaping () -> Void) {
        button.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            button.isLoading = false
            action()
        }
    }

    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc func openEULA() {
        let controller = SuliJoyEULAViewController()
        controller.onAgree = { [weak self] in
            SuliJoyLocalAuthService.shared.setEULAAgreed(true)
            self?.refreshAgreementState()
        }
        controller.onTerms = { [weak self, weak controller] in
            self?.showPolicy(title: "Terms of Service", sections: SuliJoyPolicyCopy.terms, presenter: controller)
        }
        controller.onPrivacy = { [weak self, weak controller] in
            self?.showPolicy(title: "Privacy Policy", sections: SuliJoyPolicyCopy.privacy, presenter: controller)
        }
        present(controller, animated: true)
    }

    func showPolicy(title: String, sections: [SuliJoyPolicySection], presenter: UIViewController? = nil) {
        let controller = SuliJoyPolicyViewController(titleText: title, sections: sections)
        (presenter ?? self).present(controller, animated: true)
    }

    func refreshAgreementState() {}

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func keyboardWillShow(_ note: Notification) {
        guard
            let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        let keyboardInView = view.convert(frame, from: nil)
        let overlap = max(0, view.bounds.maxY - keyboardInView.minY)
        scrollView.contentInset.bottom = overlap + 20
        scrollView.verticalScrollIndicatorInsets.bottom = overlap + 20
        if let activeInput {
            let rect = activeInput.convert(activeInput.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect.insetBy(dx: 0, dy: -24), animated: true)
        }
    }

    @objc private func keyboardWillHide(_ note: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeInput = textField
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        activeInput = textView
    }
}

enum SuliJoyPolicyCopy {
    static let eulaSheet = """
    Welcome to SuliJoy. SuliJoy is a coastal fashion community for island outfits, resort looks, activity inspiration, short videos, and AI-assisted style ideas.

    To keep the app safe, the following content and behavior are not allowed:

    1. Child sexual abuse material, sexual exploitation of minors, grooming, or any content that harms children.

    2. Nudity, pornography, sexual services, graphic violence, hate, bullying, threats, stalking, harassment, or content that promotes self-harm.

    3. Fake, deceptive, illegal, infringing, or harmful content, including impersonation, scams, stolen photos, and unsafe fashion or body-image claims.

    Users must meet the minimum age required by applicable law and must be legally allowed to use this app where they live. SuliJoy may review, restrict, remove, report, or permanently ban content and accounts that violate these rules.

    By tapping I agree, you accept the Terms of Use and Privacy Policy.
    """

    static let terms: [SuliJoyPolicySection] = [
        SuliJoyPolicySection(
            title: "Acceptance",
            body: "By creating an account or using SuliJoy, you agree to these Terms and our Privacy Policy. If you do not agree, please do not use the app."
        ),
        SuliJoyPolicySection(
            title: "SuliJoy Services",
            body: "SuliJoy provides a beach and island style experience that may include login, profiles, AI outfit entry points, activity lists, community posts, short videos, and a personal center. This build uses simulated services to create a real app-like experience and does not connect to a live commercial backend."
        ),
        SuliJoyPolicySection(
            title: "Eligibility",
            body: "You must meet the minimum age required by applicable law and be legally allowed to use social and fashion-sharing services in your jurisdiction. You may not use another person's identity, email, photos, or profile details without permission."
        ),
        SuliJoyPolicySection(
            title: "Your Content",
            body: "You keep ownership of the outfit photos, style notes, videos, profile avatar, bio, and comments you create. By posting or saving content in SuliJoy, you allow the app to host, display, organize, and simulate delivery of that content within the experience you choose."
        ),
        SuliJoyPolicySection(
            title: "Community Safety",
            body: "Do not post illegal, hateful, harassing, bullying, sexually explicit, violent, deceptive, infringing, or child-harm content. SuliJoy may remove content, limit features, suspend accounts, or permanently ban users who violate these rules."
        ),
        SuliJoyPolicySection(
            title: "Reports, Blocking & Moderation",
            body: "SuliJoy is designed around user-managed safety controls, including reporting and blocking. Reports may be reviewed for policy enforcement. Blocking should prevent unwanted interaction where the feature is available."
        ),
        SuliJoyPolicySection(
            title: "AI Style Assistant",
            body: "AI outfit suggestions are for inspiration only. They are not professional, medical, financial, or safety advice. You are responsible for deciding whether a style, product idea, or activity is appropriate for you."
        ),
        SuliJoyPolicySection(
            title: "Account & Termination",
            body: "You may log out at any time. SuliJoy may restrict or terminate access for violations of these Terms, safety rules, or applicable law. Some provisions survive termination where needed for safety, legal, and operational reasons."
        )
    ]

    static let privacy: [SuliJoyPolicySection] = [
        SuliJoyPolicySection(
            title: "Device Data Model",
            body: "This implementation stores login state, registered account records, EULA agreement state, profile details, style tags, and selected avatar references on this device to simulate real service behavior."
        ),
        SuliJoyPolicySection(
            title: "Information You Provide",
            body: "SuliJoy may store the email, password used for sign-in, nickname, avatar, bio, and style preferences you enter. The fixed test account exists only for development validation."
        ),
        SuliJoyPolicySection(
            title: "Camera & Photo Library",
            body: "Camera and photo library access are requested only when you choose to take or select a profile avatar. If your device has no camera available, the Take Photo option is hidden."
        ),
        SuliJoyPolicySection(
            title: "No Live Backend",
            body: "This build does not use Firebase, Supabase, or a commercial server. Simulated request envelopes include code, message, trace ID, server time, and response data."
        ),
        SuliJoyPolicySection(
            title: "Session Restore",
            body: "SuliJoy restores login state after restart so the app can behave like a real signed-in experience. Logging out clears the active session only and does not delete registered accounts."
        ),
        SuliJoyPolicySection(
            title: "Safety Actions",
            body: "Future reporting, blocking, moderation, and account-safety features may store device records needed to show the user interface and enforce user choices in this simulated environment."
        )
    ]
}
