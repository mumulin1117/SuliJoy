import UIKit

final class SuliJoySignupViewController: SuliJoyAuthBaseViewController {
    private let nameField = SuliJoyAuthTextField(placeholder: "Enter your name")
    private let emailField = SuliJoyAuthTextField(placeholder: "Enter email address")
    private let passwordField = SuliJoyAuthTextField(placeholder: "Enter password", secure: true)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
      
    }

    

    private func buildUI() {
        let back = makeBackButton()
        let title = makeTitle("Sign up", size: 36)
        let form = UIView()
        form.translatesAutoresizingMaskIntoConstraints = false
        form.backgroundColor = .white
        form.layer.cornerRadius = 33
        let fields = UIStackView(arrangedSubviews: [
            makeFieldBlock(title: "Name", field: nameField),
            makeFieldBlock(title: "Email", field: emailField),
            makeFieldBlock(title: "Password", field: passwordField)
        ])
        fields.axis = .vertical
        fields.spacing = 34
        fields.translatesAutoresizingMaskIntoConstraints = false
        form.addSubview(fields)
        let next = SuliJoyGradientButton(title: "Next")
        next.translatesAutoresizingMaskIntoConstraints = false
        next.addTarget(self, action: #selector(submitDraft(_:)), for: .touchUpInside)

        [back, title, form, next].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 14),
            back.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            title.topAnchor.constraint(equalTo: back.bottomAnchor, constant: 32),
            title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            form.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 44),
            form.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            form.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            fields.topAnchor.constraint(equalTo: form.topAnchor, constant: 28),
            fields.leadingAnchor.constraint(equalTo: form.leadingAnchor, constant: 32),
            fields.trailingAnchor.constraint(equalTo: form.trailingAnchor, constant: -32),
            fields.bottomAnchor.constraint(equalTo: form.bottomAnchor, constant: -34),
            next.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            next.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            next.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
           
        ])
    }

    @objc private func submitDraft(_ sender: SuliJoyGradientButton) {
        simulateRequest(sender) { [weak self] in
            guard let self else { return }
            let result = SuliJoyLocalAuthService.shared.validateSignupDraft(
                name: self.nameField.text ?? "",
                email: self.emailField.text ?? "",
                password: self.passwordField.text ?? ""
            )
            guard let draft = result.data else {
                self.showAlert(result.message)
                return
            }
            self.navigationController?.pushViewController(SuliJoyProfileSetupViewController(draft: draft), animated: true)
        }
    }
}
