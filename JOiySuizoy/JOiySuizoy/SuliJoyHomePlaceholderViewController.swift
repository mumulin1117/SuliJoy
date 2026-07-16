import UIKit

final class SuliJoyHomePlaceholderViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let background = SuliJoyIslandBackgroundView()
        background.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(background)

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "SuliJoy"
        title.textColor = .suliInk
        title.font = UIFont.systemFont(ofSize: 34, weight: .black)
        title.textAlignment = .center

        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.text = "Your island style space is ready."
        subtitle.textColor = .suliMutedInk
        subtitle.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        subtitle.textAlignment = .center
        subtitle.numberOfLines = 0

        let logout = UIButton(type: .system)
        logout.translatesAutoresizingMaskIntoConstraints = false
        logout.setTitle("Log out", for: .normal)
        logout.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        logout.setTitleColor(.suliInk, for: .normal)
        logout.addTarget(self, action: #selector(logoutNow), for: .touchUpInside)

        view.addSubview(title)
        view.addSubview(subtitle)
        view.addSubview(logout)
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -34),
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            subtitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            subtitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            logout.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 28),
            logout.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func logoutNow() {
        SuliJoyLocalAuthService.shared.logout()
        let welcome = UINavigationController(rootViewController: SuliJoyWelcomeViewController())
        welcome.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController = welcome
    }
}
