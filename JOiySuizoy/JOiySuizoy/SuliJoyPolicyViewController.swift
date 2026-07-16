import UIKit

struct SuliJoyPolicySection {
    let title: String
    let body: String
}

final class SuliJoyPolicyViewController: UIViewController {
    private let titleText: String
    private let updatedText: String
    private let sections: [SuliJoyPolicySection]
    private let backgroundView = SuliJoyIslandBackgroundView()

    init(titleText: String, updatedText: String = "Last updated: July 2026", sections: [SuliJoyPolicySection]) {
        self.titleText = titleText
        self.updatedText = updatedText
        self.sections = sections
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }

    private func buildUI() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)

        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        back.tintColor = .black
        back.addTarget(self, action: #selector(close), for: .touchUpInside)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = titleText
        titleLabel.textColor = .suliInk
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .black)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.82

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true

        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 22

        let updated = UILabel()
        updated.text = updatedText
        updated.textColor = .suliMutedInk
        updated.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        updated.numberOfLines = 0
        stack.addArrangedSubview(updated)

        for (index, section) in sections.enumerated() {
            let sectionStack = UIStackView()
            sectionStack.axis = .vertical
            sectionStack.spacing = 10

            let heading = UILabel()
            heading.text = "\(index + 1). \(section.title)"
            heading.textColor = .suliInk
            heading.font = UIFont.systemFont(ofSize: 24, weight: .black)
            heading.numberOfLines = 0

            let body = UILabel()
            body.text = section.body
            body.textColor = .suliInk
            body.font = UIFont.systemFont(ofSize: 21, weight: .regular)
            body.numberOfLines = 0
            body.lineBreakMode = .byWordWrapping

            sectionStack.addArrangedSubview(heading)
            sectionStack.addArrangedSubview(body)
            stack.addArrangedSubview(sectionStack)
        }

        view.addSubview(back)
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(stack)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            back.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            back.widthAnchor.constraint(equalToConstant: 44),
            back.heightAnchor.constraint(equalToConstant: 44),

            titleLabel.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: back.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -62),

            scrollView.topAnchor.constraint(equalTo: back.bottomAnchor, constant: 28),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 30),
            stack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -30),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -30),
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -60)
        ])
    }

    @objc private func close() {
        if let navigationController {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
