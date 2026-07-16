import UIKit

final class SuliJoyLoginViewController: SuliJoyAuthBaseViewController {
    private let emailField = SuliJoyAuthTextField(placeholder: "Enter email address")
    private let passwordField = SuliJoyAuthTextField(placeholder: "Enter password", secure: true)
//    private let agreement = SuliJoyAgreementView()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
       
    }

   

    private func buildUI() {
        let back = makeBackButton()
        let eula = makeEULAButton()
        let title = makeTitle("LOGIN", size: 36)
        let form = UIView()
        form.translatesAutoresizingMaskIntoConstraints = false
        form.backgroundColor = .white
        form.layer.cornerRadius = 33

        let emailBlock = makeFieldBlock(title: "Email", field: emailField)
        let passwordBlock = makeFieldBlock(title: "Password", field: passwordField)
        let fields = UIStackView(arrangedSubviews: [emailBlock, passwordBlock])
        fields.axis = .vertical
        fields.spacing = 34
        fields.translatesAutoresizingMaskIntoConstraints = false
        form.addSubview(fields)

        let login = SuliJoyGradientButton(title: "LOGIN")
        login.translatesAutoresizingMaskIntoConstraints = false
        login.addTarget(self, action: #selector(submitLogin(_:)), for: .touchUpInside)

        [back, eula, title, form, login].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 14),
            back.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            eula.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            eula.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            title.topAnchor.constraint(equalTo: back.bottomAnchor, constant: 92),
            title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            form.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 54),
            form.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            form.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            fields.topAnchor.constraint(equalTo: form.topAnchor, constant: 28),
            fields.leadingAnchor.constraint(equalTo: form.leadingAnchor, constant: 32),
            fields.trailingAnchor.constraint(equalTo: form.trailingAnchor, constant: -32),
            fields.bottomAnchor.constraint(equalTo: form.bottomAnchor, constant: -34),
            login.topAnchor.constraint(equalTo: form.bottomAnchor, constant: 57),
            login.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            login.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
           
        ])
    }

    @objc private func submitLogin(_ sender: SuliJoyGradientButton) {
        simulateRequest(sender) { [weak self] in
            guard let self else { return }
            let result = SuliJoyLocalAuthService.shared.login(
                email: self.emailField.text ?? "",
                password: self.passwordField.text ?? ""
            )
            guard result.code == 200 else {
                self.showAlert(result.message)
                return
            }
            self.showHome()
        }
    }

    private func showHome() {
        let home = SuliJoyMainTabBarController()
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController = home
    }
}
