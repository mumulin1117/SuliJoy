import UIKit

final class SuliJoyChallengeShareLookController: SuliJoyTropicCanvasController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    private enum ShareLookMeasure {
        static let pageSide: CGFloat = 20
        static let navTop: CGFloat = 8
        static let navHeight: CGFloat = 44
        static let photoTop: CGFloat = 16
        static let photoCorner: CGFloat = 28
        static let photoAspect: CGFloat = 1.12
        static let captionTitleTop: CGFloat = 24
        static let captionFieldTop: CGFloat = 10
        static let captionFieldHeight: CGFloat = 56
        static let captionFieldCorner: CGFloat = 12
        static let shareBottom: CGFloat = 30
        static let shareHeight: CGFloat = 56
    }

    var onChallengeJoined: ((SuliJoyTideActivity) -> Void)?

    private let challengeTideMark: String
    private let shoreScroll = UIScrollView()
    private let reefDeck = UIView()
    private let photoCard = UIControl()
    private let photoPreview = UIImageView()
    private let editPhotoPill = UIControl()
    private let captionTitle = UILabel()
    private let captionField = UITextField()
    private let shareLookButton = SuliJoyGradientButton(reefHeadline: "Share Look", reefHeight: ShareLookMeasure.shareHeight)
    private var pickedPhoto: UIImage?
    private var reefMediaPick: SuliJoyReefLocalMediaPick?

    init(challengeTideMark: String) {
        self.challengeTideMark = challengeTideMark
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        raiseShareLookScene()
        registerShareLookKeyboardObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    @MainActor deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func raiseShareLookScene() {
        shoreScroll.translatesAutoresizingMaskIntoConstraints = false
        shoreScroll.showsVerticalScrollIndicator = false
        shoreScroll.keyboardDismissMode = .interactive
        shoreScroll.backgroundColor = .clear
        reefDeck.translatesAutoresizingMaskIntoConstraints = false
        reefDeck.backgroundColor = .clear

        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)), for: .normal)
        back.tintColor = .suliInk
        back.addTarget(self, action: #selector(driftBackFromShareLook), for: .touchUpInside)

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Share Your Look"
        title.font = UIFont.systemFont(ofSize: 18, weight: .black)
        title.textColor = .suliInk
        title.textAlignment = .center

        photoCard.translatesAutoresizingMaskIntoConstraints = false
        photoCard.backgroundColor = UIColor(red: 0.98, green: 0.86, blue: 0.62, alpha: 1)
        photoCard.layer.cornerRadius = ShareLookMeasure.photoCorner
        photoCard.clipsToBounds = true
        photoCard.addTarget(self, action: #selector(openPhotoPicker), for: .touchUpInside)

        photoPreview.translatesAutoresizingMaskIntoConstraints = false
        photoPreview.contentMode = .scaleAspectFill
        photoPreview.clipsToBounds = true
        photoPreview.image = SuliJoyImagePlaceholder.photo

        editPhotoPill.translatesAutoresizingMaskIntoConstraints = false
        editPhotoPill.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        editPhotoPill.layer.cornerRadius = 20
        editPhotoPill.layer.borderWidth = 1
        editPhotoPill.layer.borderColor = UIColor.white.withAlphaComponent(0.85).cgColor
        editPhotoPill.addTarget(self, action: #selector(openPhotoPicker), for: .touchUpInside)

        let cameraGlyph = UIImageView(image: UIImage(systemName: "camera.fill"))
        cameraGlyph.translatesAutoresizingMaskIntoConstraints = false
        cameraGlyph.tintColor = .white
        cameraGlyph.contentMode = .scaleAspectFit
        let editLabel = UILabel()
        editLabel.translatesAutoresizingMaskIntoConstraints = false
        editLabel.text = "Edit Photo"
        editLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        editLabel.textColor = .white
        editPhotoPill.addSubview(cameraGlyph)
        editPhotoPill.addSubview(editLabel)

        captionTitle.translatesAutoresizingMaskIntoConstraints = false
        captionTitle.text = "Write a caption"
        captionTitle.font = UIFont.systemFont(ofSize: 18, weight: .black)
        captionTitle.textColor = .suliInk

        captionField.translatesAutoresizingMaskIntoConstraints = false
        captionField.placeholder = "Blue skies, island vibes"
        captionField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        captionField.textColor = .suliInk
        captionField.backgroundColor = .white
        captionField.layer.cornerRadius = ShareLookMeasure.captionFieldCorner
        captionField.delegate = self
        captionField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        captionField.leftViewMode = .always
        captionField.attributedPlaceholder = NSAttributedString(
            string: "Blue skies, island vibes",
            attributes: [
                .foregroundColor: UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1),
                .font: UIFont.systemFont(ofSize: 16, weight: .regular)
            ]
        )

        shareLookButton.translatesAutoresizingMaskIntoConstraints = false
        shareLookButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .black)
        shareLookButton.addTarget(self, action: #selector(shareLookForChallenge), for: .touchUpInside)

        view.addSubview(shoreScroll)
        view.addSubview(shareLookButton)
        shoreScroll.addSubview(reefDeck)
        reefDeck.addSubview(back)
        reefDeck.addSubview(title)
        reefDeck.addSubview(photoCard)
        photoCard.addSubview(photoPreview)
        photoCard.addSubview(editPhotoPill)

        NSLayoutConstraint.activate([
            shareLookButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ShareLookMeasure.pageSide),
            shareLookButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ShareLookMeasure.pageSide),
            shareLookButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ShareLookMeasure.shareBottom),

            shoreScroll.topAnchor.constraint(equalTo: view.topAnchor),
            shoreScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoreScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoreScroll.bottomAnchor.constraint(equalTo: shareLookButton.topAnchor, constant: -12),

            reefDeck.topAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.topAnchor),
            reefDeck.leadingAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.leadingAnchor),
            reefDeck.trailingAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.trailingAnchor),
            reefDeck.bottomAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.bottomAnchor),
            reefDeck.widthAnchor.constraint(equalTo: shoreScroll.frameLayoutGuide.widthAnchor),

            back.topAnchor.constraint(equalTo: reefDeck.safeAreaLayoutGuide.topAnchor, constant: ShareLookMeasure.navTop),
            back.leadingAnchor.constraint(equalTo: reefDeck.leadingAnchor, constant: ShareLookMeasure.pageSide),
            back.widthAnchor.constraint(equalToConstant: ShareLookMeasure.navHeight),
            back.heightAnchor.constraint(equalToConstant: ShareLookMeasure.navHeight),

            title.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: reefDeck.centerXAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: back.trailingAnchor, constant: 8),

            photoCard.topAnchor.constraint(equalTo: back.bottomAnchor, constant: ShareLookMeasure.photoTop),
            photoCard.leadingAnchor.constraint(equalTo: reefDeck.leadingAnchor, constant: ShareLookMeasure.pageSide),
            photoCard.trailingAnchor.constraint(equalTo: reefDeck.trailingAnchor, constant: -ShareLookMeasure.pageSide),
            photoCard.heightAnchor.constraint(equalTo: photoCard.widthAnchor, multiplier: ShareLookMeasure.photoAspect),

            photoPreview.topAnchor.constraint(equalTo: photoCard.topAnchor),
            photoPreview.leadingAnchor.constraint(equalTo: photoCard.leadingAnchor),
            photoPreview.trailingAnchor.constraint(equalTo: photoCard.trailingAnchor),
            photoPreview.bottomAnchor.constraint(equalTo: photoCard.bottomAnchor),

            editPhotoPill.centerXAnchor.constraint(equalTo: photoCard.centerXAnchor),
            editPhotoPill.bottomAnchor.constraint(equalTo: photoCard.bottomAnchor, constant: -16),
            editPhotoPill.heightAnchor.constraint(equalToConstant: 40),

            cameraGlyph.leadingAnchor.constraint(equalTo: editPhotoPill.leadingAnchor, constant: 14),
            cameraGlyph.centerYAnchor.constraint(equalTo: editPhotoPill.centerYAnchor),
            cameraGlyph.widthAnchor.constraint(equalToConstant: 16),
            cameraGlyph.heightAnchor.constraint(equalToConstant: 14),

            editLabel.leadingAnchor.constraint(equalTo: cameraGlyph.trailingAnchor, constant: 6),
            editLabel.trailingAnchor.constraint(equalTo: editPhotoPill.trailingAnchor, constant: -14),
            editLabel.centerYAnchor.constraint(equalTo: editPhotoPill.centerYAnchor)
        ])

        reefDeck.addSubview(captionTitle)
        reefDeck.addSubview(captionField)
        NSLayoutConstraint.activate([
            captionTitle.topAnchor.constraint(equalTo: photoCard.bottomAnchor, constant: ShareLookMeasure.captionTitleTop),
            captionTitle.leadingAnchor.constraint(equalTo: photoCard.leadingAnchor),
            captionTitle.trailingAnchor.constraint(equalTo: photoCard.trailingAnchor),

            captionField.topAnchor.constraint(equalTo: captionTitle.bottomAnchor, constant: ShareLookMeasure.captionFieldTop),
            captionField.leadingAnchor.constraint(equalTo: photoCard.leadingAnchor),
            captionField.trailingAnchor.constraint(equalTo: photoCard.trailingAnchor),
            captionField.heightAnchor.constraint(equalToConstant: ShareLookMeasure.captionFieldHeight),
            captionField.bottomAnchor.constraint(equalTo: reefDeck.bottomAnchor, constant: -20)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(foldShareLookKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func openPhotoPicker() {
        foldShareLookKeyboard()
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sheet.addAction(UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
                self?.presentPhotoPicker(source: .camera)
            })
        }
        sheet.addAction(UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.presentPhotoPicker(source: .photoLibrary)
        })
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.popoverPresentationController?.sourceView = photoCard
        sheet.popoverPresentationController?.sourceRect = photoCard.bounds
        present(sheet, animated: true)
    }

    private func presentPhotoPicker(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage) else { return }
        pickedPhoto = image
        photoPreview.image = image
        reefMediaPick = saveShareLookPhoto(image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    private func saveShareLookPhoto(_ image: UIImage) -> SuliJoyReefLocalMediaPick? {
        guard let data = image.jpegData(compressionQuality: 0.86) else { return nil }
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("SuliJoyPostMedia", isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let url = directory.appendingPathComponent("challenge_look_\(UUID().uuidString).jpg")
        do {
            try data.write(to: url, options: .atomic)
            return SuliJoyReefLocalMediaPick(reefSandboxPath: url.path, hibiscusShade: "Challenge look")
        } catch {
            return nil
        }
    }

    @objc private func shareLookForChallenge() {
        foldShareLookKeyboard()
        guard let reefMediaPick else {
            showLagoonToast("Please add a photo for your look.")
            return
        }
        let caption = (captionField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !caption.isEmpty else {
            showLagoonToast("Please write a caption.")
            return
        }
        let draft = SuliJoyShoreDraftMoment(
            islandCaptionLine: caption,
            reefPicks: [reefMediaPick],
            waveDraft: nil
        )
        shareLookButton.isLoading = true
        SuliJoyCoveMockService.shared.publishShoreMoment(draft: draft) { [weak self] publishEnvelope in
            guard let self else { return }
            guard publishEnvelope.beachwearCapsule == 200 else {
                self.shareLookButton.isLoading = false
                self.showLagoonToast(publishEnvelope.coastalWardrobe)
                return
            }
            SuliJoyCoveMockService.shared.joinActivity(tideID: self.challengeTideMark) { joinEnvelope in
                self.shareLookButton.isLoading = false
                guard joinEnvelope.beachwearCapsule == 200, let joined = joinEnvelope.sandbarLayering else {
                    self.showLagoonToast(joinEnvelope.coastalWardrobe)
                    return
                }
                NotificationCenter.default.post(name: .suliJoyShoreMomentPublished, object: publishEnvelope.sandbarLayering)
                self.onChallengeJoined?(joined)
                self.showLagoonToast("Look shared — challenge joined!")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    @objc private func driftBackFromShareLook() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func foldShareLookKeyboard() {
        view.endEditing(true)
    }

    private func registerShareLookKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(shareLookKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shareLookKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func shareLookKeyboardWillShow(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let inset = frame.height - view.safeAreaInsets.bottom + 12
        shoreScroll.contentInset.bottom = inset
        shoreScroll.verticalScrollIndicatorInsets.bottom = inset
    }

    @objc private func shareLookKeyboardWillHide(_ note: Notification) {
        shoreScroll.contentInset.bottom = 0
        shoreScroll.verticalScrollIndicatorInsets.bottom = 0
    }
}
