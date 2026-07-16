import UIKit

final class SuliJoyProfileSetupViewController: SuliJoyAuthBaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let draft: SuliJoySignupDraft
    private let avatarButton = UIButton(type: .system)
    private let avatarImageView = UIImageView()
    private let bioView = UITextView()
 
    private var selectedAvatar: UIImage?

    init(draft: SuliJoySignupDraft) {
        self.draft = draft
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
      
    }

  

    private func buildUI() {
        let back = makeBackButton()
        let title = makeTitle("Complete\nYour Profile", size: 30)
        let avatarCard = makeAvatarCard()
        let form = UIView()
        form.translatesAutoresizingMaskIntoConstraints = false
        form.backgroundColor = .white
        form.layer.cornerRadius = 33
        let bioLabel = UILabel()
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.text = "Bio"
        bioLabel.textColor = .suliInk
        bioLabel.font = UIFont.systemFont(ofSize: 17, weight: .black)
        bioLabel.transform = CGAffineTransform(a: 1, b: 0, c: -0.12, d: 1, tx: 0, ty: 0)
        bioView.translatesAutoresizingMaskIntoConstraints = false
        bioView.text = "Collecting little sounds of my days."
        bioView.textColor = UIColor(red: 0.55, green: 0.53, blue: 0.49, alpha: 1)
        bioView.font = UIFont.systemFont(ofSize: 16)
        bioView.backgroundColor = UIColor(red: 24 / 255, green: 23 / 255, blue: 22 / 255, alpha: 0.05)
        bioView.layer.cornerRadius = 12
        bioView.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        bioView.delegate = self
        form.addSubview(bioLabel)
        form.addSubview(bioView)

        let finish = SuliJoyGradientButton(title: "Sign up")
        finish.translatesAutoresizingMaskIntoConstraints = false
        finish.addTarget(self, action: #selector(finishSignup(_:)), for: .touchUpInside)

        [back, title, avatarCard, form, finish].forEach { contentView.addSubview($0) }
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 14),
            back.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            title.topAnchor.constraint(equalTo: back.bottomAnchor, constant: 92),
            title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarCard.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 22),
            avatarCard.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarCard.widthAnchor.constraint(equalToConstant: 160),
            avatarCard.heightAnchor.constraint(equalToConstant: 160),
            form.topAnchor.constraint(equalTo: avatarCard.bottomAnchor, constant: 40),
            form.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            form.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            bioLabel.topAnchor.constraint(equalTo: form.topAnchor, constant: 28),
            bioLabel.leadingAnchor.constraint(equalTo: form.leadingAnchor, constant: 32),
            bioView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 12),
            bioView.leadingAnchor.constraint(equalTo: form.leadingAnchor, constant: 32),
            bioView.trailingAnchor.constraint(equalTo: form.trailingAnchor, constant: -32),
            bioView.heightAnchor.constraint(equalToConstant: 126),
            bioView.bottomAnchor.constraint(equalTo: form.bottomAnchor, constant: -32),
            finish.topAnchor.constraint(equalTo: form.bottomAnchor, constant: 66),
            finish.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            finish.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -28),
         
            finish.bottomAnchor.constraint(lessThanOrEqualTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    private func makeAvatarCard() -> UIView {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 24
        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        avatarButton.addTarget(self, action: #selector(chooseAvatar), for: .touchUpInside)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 48
        avatarImageView.image = UIImage(named: "sulijoy_auth_camera_badge")
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Add Profile Photo."
        label.textColor = UIColor(red: 0.55, green: 0.53, blue: 0.49, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 13)
        card.addSubview(avatarImageView)
        card.addSubview(label)
        card.addSubview(avatarButton)
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: card.topAnchor, constant: 38),
            avatarImageView.widthAnchor.constraint(equalToConstant: 64),
            avatarImageView.heightAnchor.constraint(equalToConstant: 64),
            label.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            label.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            avatarButton.topAnchor.constraint(equalTo: card.topAnchor),
            avatarButton.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            avatarButton.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            avatarButton.bottomAnchor.constraint(equalTo: card.bottomAnchor)
        ])
        return card
    }

    @objc private func chooseAvatar() {
        let sheet = UIAlertController(title: "Profile Photo", message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sheet.addAction(UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
                self?.presentPicker(.camera)
            })
        }
        sheet.addAction(UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.presentPicker(.photoLibrary)
        })
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        if let popover = sheet.popoverPresentationController {
            popover.sourceView = avatarButton
            popover.sourceRect = avatarButton.bounds
        }
        present(sheet, animated: true)
    }

    private func presentPicker(_ source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        selectedAvatar = image
        avatarImageView.image = image
        avatarImageView.layer.cornerRadius = 48
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    @objc private func finishSignup(_ sender: SuliJoyGradientButton) {
        simulateRequest(sender) { [weak self] in
            guard let self else { return }
            let result = SuliJoyLocalAuthService.shared.completeProfile(
                draft: self.draft,
                bio: self.bioView.text ?? "",
                avatar: self.selectedAvatar
            )
            guard result.code == 200 else {
                self.showAlert(result.message)
                return
            }
            UIApplication.shared.connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .first?
                .rootViewController = SuliJoyMainTabBarController()
        }
    }
}
