import UIKit

final class SuliJoyEULAViewController: UIViewController {
    var onAgree: (() -> Void)?
    var onTerms: (() -> Void)?
    var onPrivacy: (() -> Void)?

    private let sheetView = UIView()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }

    private func buildUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.52)

        sheetView.translatesAutoresizingMaskIntoConstraints = false
        sheetView.backgroundColor = .white
        sheetView.layer.cornerRadius = 30
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        sheetView.clipsToBounds = true
        view.addSubview(sheetView)

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "EULA"
        title.textColor = .black
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 30, weight: .black)

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true

        let body = UILabel()
        body.translatesAutoresizingMaskIntoConstraints = false
        body.text = SuliJoyPolicyCopy.eulaSheet
        body.textColor = .black
        body.font = UIFont.systemFont(ofSize: 21, weight: .regular)
        body.numberOfLines = 0
        body.lineBreakMode = .byWordWrapping

        let terms = UIButton(type: .system)
        terms.translatesAutoresizingMaskIntoConstraints = false
        terms.setTitle("<Terms of Use>", for: .normal)
        terms.setTitleColor(UIColor(red: 1.0, green: 0.45, blue: 0.12, alpha: 1), for: .normal)
        terms.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .black)
        terms.titleLabel?.adjustsFontSizeToFitWidth = true
        terms.titleLabel?.minimumScaleFactor = 0.78
        terms.addTarget(self, action: #selector(openTerms), for: .touchUpInside)

        let privacy = UIButton(type: .system)
        privacy.translatesAutoresizingMaskIntoConstraints = false
        privacy.setTitle("<Privacy Policy>", for: .normal)
        privacy.setTitleColor(UIColor(red: 1.0, green: 0.45, blue: 0.12, alpha: 1), for: .normal)
        privacy.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .black)
        privacy.titleLabel?.adjustsFontSizeToFitWidth = true
        privacy.titleLabel?.minimumScaleFactor = 0.78
        privacy.addTarget(self, action: #selector(openPrivacy), for: .touchUpInside)

        let linkStack = UIStackView(arrangedSubviews: [terms, privacy])
        linkStack.translatesAutoresizingMaskIntoConstraints = false
        linkStack.axis = .horizontal
        linkStack.alignment = .center
        linkStack.distribution = .fillEqually
        linkStack.spacing = 18

        let cancel = UIButton(type: .system)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.setTitle("Cancel", for: .normal)
        cancel.setTitleColor(UIColor.black.withAlphaComponent(0.40), for: .normal)
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        cancel.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        cancel.layer.cornerRadius = 28
        cancel.addTarget(self, action: #selector(cancelEULA), for: .touchUpInside)

        let agree = SuliJoyGradientButton(title: "I agree")
        agree.translatesAutoresizingMaskIntoConstraints = false
        agree.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        agree.addTarget(self, action: #selector(agreeEULA), for: .touchUpInside)

        let actionStack = UIStackView(arrangedSubviews: [cancel, agree])
        actionStack.translatesAutoresizingMaskIntoConstraints = false
        actionStack.axis = .horizontal
        actionStack.spacing = 26
        actionStack.distribution = .fillEqually

        sheetView.addSubview(title)
        sheetView.addSubview(scrollView)
        sheetView.addSubview(linkStack)
        sheetView.addSubview(actionStack)
        scrollView.addSubview(body)

        NSLayoutConstraint.activate([
            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.86),

            title.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 38),
            title.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 24),
            title.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -24),

            scrollView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 28),
            scrollView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: linkStack.topAnchor, constant: -16),

            body.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            body.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 24),
            body.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -24),
            body.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            body.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -48),

            linkStack.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 24),
            linkStack.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -24),
            linkStack.bottomAnchor.constraint(equalTo: actionStack.topAnchor, constant: -24),

            actionStack.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 32),
            actionStack.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -32),
            actionStack.bottomAnchor.constraint(equalTo: sheetView.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            cancel.heightAnchor.constraint(equalToConstant: 56),
            agree.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    @objc private func openTerms() {
        onTerms?()
    }

    @objc private func openPrivacy() {
        onPrivacy?()
    }

    @objc private func cancelEULA() {
        dismiss(animated: true)
    }

    @objc private func agreeEULA() {
        onAgree?()
        dismiss(animated: true)
    }
}
