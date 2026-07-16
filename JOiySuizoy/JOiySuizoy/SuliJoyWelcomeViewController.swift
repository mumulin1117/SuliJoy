import UIKit

final class SuliJoyWelcomeViewController: SuliJoyAuthBaseViewController {
    private let agreement = SuliJoyAgreementView()

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
        updateAgreement(agreement)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            guard let self, !SuliJoyLocalAuthService.shared.restoreSession().hasAgreedEULA else { return }
            self.openEULA()
        }
    }

    override func refreshAgreementState() {
        agreement.isAgreed = SuliJoyLocalAuthService.shared.restoreSession().hasAgreedEULA
    }

    private func buildUI() {
        let eula = makeEULAButton()
        let title = makeTitle("SULIJOY", size: 30)
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.text = "Show your island style."
        subtitle.textColor = .suliInk
        subtitle.font = UIFont.italicSystemFont(ofSize: 18)
        subtitle.textAlignment = .center

        let hero = makeHeroView()
        let login = UIButton(type: .system)
        login.translatesAutoresizingMaskIntoConstraints = false
        login.setTitle("Login", for: .normal)
        login.setTitleColor(.white, for: .normal)
        login.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .black)
        login.backgroundColor = .suliInk
        login.layer.cornerRadius = 25
        login.addTarget(self, action: #selector(openLogin), for: .touchUpInside)

        let signup = SuliJoyGradientButton(title: "Sign in", bordered: true)
        signup.addTarget(self, action: #selector(openSignup), for: .touchUpInside)
        let mail = UIImageView(image: UIImage(named: "sulijoy_auth_mail_badge"))
        mail.translatesAutoresizingMaskIntoConstraints = false
        signup.addSubview(mail)
        NSLayoutConstraint.activate([
            mail.widthAnchor.constraint(equalToConstant: 20),
            mail.heightAnchor.constraint(equalToConstant: 20),
            mail.centerYAnchor.constraint(equalTo: signup.centerYAnchor),
            mail.leadingAnchor.constraint(equalTo: signup.leadingAnchor, constant: 30)
        ])

        let buttonStack = UIStackView(arrangedSubviews: [login, signup])
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .horizontal
        buttonStack.spacing = 22
        buttonStack.distribution = .fillEqually

        [eula, title, subtitle, hero, buttonStack, agreement].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            eula.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 18),
            eula.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            title.topAnchor.constraint(equalTo: eula.bottomAnchor, constant: 2),
            title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2),
            subtitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            hero.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 26),
            hero.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            hero.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            hero.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.98),
            buttonStack.topAnchor.constraint(equalTo: hero.bottomAnchor, constant: 32),
            buttonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            buttonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            login.heightAnchor.constraint(equalToConstant: 50),
            agreement.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 42),
            agreement.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            agreement.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            agreement.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -22)
        ])
    }

    private func makeHeroView() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        let left = image(named: "sulijoy_auth_hero_left")
        let right = image(named: "sulijoy_auth_hero_right")
        let front = image(named: "sulijoy_auth_hero_front")
        left.transform = CGAffineTransform(rotationAngle: -0.18)
        right.transform = CGAffineTransform(rotationAngle: 0.10)
        [left, right, front].forEach { container.addSubview($0) }
        NSLayoutConstraint.activate([
            left.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: -28),
            left.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            left.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.62),
            left.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.86),
            right.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 26),
            right.topAnchor.constraint(equalTo: container.topAnchor, constant: 58),
            right.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.60),
            right.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.78),
            front.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            front.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            front.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.74),
            front.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.84)
        ])
        return container
    }

    private func image(named name: String) -> UIImageView {
        let view = UIImageView(image: UIImage(named: name))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.18
        view.layer.shadowOffset = CGSize(width: 0, height: 12)
        view.layer.shadowRadius = 20
        return view
    }

    @objc private func openLogin() {
        navigationController?.pushViewController(SuliJoyLoginViewController(), animated: true)
    }

    @objc private func openSignup() {
        navigationController?.pushViewController(SuliJoySignupViewController(), animated: true)
    }
}
