import UIKit

final class SuliJoyTideCurationDraftController: SuliJoyTropicCanvasController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    private enum ChallengeDraftMeasure {
        static let pageSide: CGFloat = 20
        static let navTop: CGFloat = 8
        static let navHeight: CGFloat = 44
        static let coverTop: CGFloat = 16
        static let coverCorner: CGFloat = 22
        static let coverHeight: CGFloat = 188
        static let formTop: CGFloat = 22
        static let sectionSpacing: CGFloat = 18
        static let sectionTitleSize: CGFloat = 18
        static let titleFieldHeight: CGFloat = 52
        static let titleFieldCorner: CGFloat = 16
        static let publishHeight: CGFloat = 54
        static let publishBottom: CGFloat = 8
    }

    private let shoreDraftScrollCanvas = UIScrollView()
    private let shoreDraftDeck = UIView()
    private let shoreDraftNavRail = UIView()
    private let styleTitleField = UITextField()
    private let shorePublishControl = SuliJoyGradientButton(reefHeadline: "Create Challenge", reefHeight: ChallengeDraftMeasure.publishHeight)

    private let coverPreview = UIImageView()
    private let coverPromptStack = UIStackView()
    private var coverReefPicks: [SuliJoyReefEventPhotoPick] = []
    private var styleSignalButtons: [UIButton] = []
    private var durationButtons: [UIButton] = []
    private var selectedStyleSignal = "Blue"
    private var selectedDuration = "23h"

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        raiseChallengeDraftScene()
        registerDraftKeyboardObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    @MainActor deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func raiseChallengeDraftScene() {
        shoreDraftScrollCanvas.translatesAutoresizingMaskIntoConstraints = false
        shoreDraftScrollCanvas.keyboardDismissMode = .interactive
        shoreDraftScrollCanvas.showsVerticalScrollIndicator = false
        shoreDraftScrollCanvas.backgroundColor = .clear
        shoreDraftDeck.translatesAutoresizingMaskIntoConstraints = false
        shoreDraftDeck.backgroundColor = .clear

        anchorChallengeNav()

        let coverCard = UIControl()
        coverCard.translatesAutoresizingMaskIntoConstraints = false
        coverCard.backgroundColor = UIColor(red: 0.98, green: 0.86, blue: 0.62, alpha: 1)
        coverCard.layer.cornerRadius = ChallengeDraftMeasure.coverCorner
        coverCard.clipsToBounds = true
        coverCard.addTarget(self, action: #selector(chooseChallengeCover), for: .touchUpInside)

        coverPreview.translatesAutoresizingMaskIntoConstraints = false
        coverPreview.contentMode = .scaleAspectFill
        coverPreview.clipsToBounds = true
        coverPreview.image = SuliJoyImagePlaceholder.photo

        let camera = UIImageView(image: UIImage(systemName: "camera.fill"))
        camera.translatesAutoresizingMaskIntoConstraints = false
        camera.tintColor = .white
        camera.contentMode = .scaleAspectFit
        let coverPrompt = UILabel()
        coverPrompt.text = "Add a cover photo"
        coverPrompt.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        coverPrompt.textColor = .white
        coverPromptStack.axis = .vertical
        coverPromptStack.alignment = .center
        coverPromptStack.spacing = 8
        coverPromptStack.translatesAutoresizingMaskIntoConstraints = false
        coverPromptStack.isUserInteractionEnabled = false
        coverPromptStack.addArrangedSubview(camera)
        coverPromptStack.addArrangedSubview(coverPrompt)
        coverCard.addSubview(coverPreview)
        coverCard.addSubview(coverPromptStack)

        styleTitleField.translatesAutoresizingMaskIntoConstraints = false
        styleTitleField.placeholder = "e.g. A Touch of Blue"
        styleTitleField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        styleTitleField.textColor = .suliInk
        styleTitleField.backgroundColor = .white
        styleTitleField.layer.cornerRadius = ChallengeDraftMeasure.titleFieldCorner
        styleTitleField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        styleTitleField.leftViewMode = .always
        styleTitleField.delegate = self
        styleTitleField.addTarget(self, action: #selector(shoreDraftTextFieldChanged(_:)), for: .editingChanged)
        styleTitleField.attributedPlaceholder = NSAttributedString(
            string: "e.g. A Touch of Blue",
            attributes: [
                .foregroundColor: UIColor(red: 0.72, green: 0.71, blue: 0.70, alpha: 1),
                .font: UIFont.systemFont(ofSize: 16, weight: .medium)
            ]
        )

        let signalWrap = makeChallengeChipRow(
            titles: ["Blue", "Linen", "Floral", "White", "Breezy", "Resort", "Bold"],
            selected: selectedStyleSignal,
            storage: &styleSignalButtons,
            action: #selector(chooseStyleSignal(_:))
        )
        let durationWrap = makeChallengeChipRow(
            titles: ["23h", "3 days", "7 days"],
            selected: selectedDuration,
            storage: &durationButtons,
            action: #selector(chooseChallengeDuration(_:))
        )

        let form = UIStackView()
        form.translatesAutoresizingMaskIntoConstraints = false
        form.axis = .vertical
        form.spacing = ChallengeDraftMeasure.sectionSpacing
        form.addArrangedSubview(makeChallengeHeading("Challenge title"))
        form.addArrangedSubview(styleTitleField)
        form.addArrangedSubview(makeChallengeHeading("Style Signal"))
        form.addArrangedSubview(signalWrap)
        form.addArrangedSubview(makeChallengeHeading("Challenge duration"))
        form.addArrangedSubview(durationWrap)
        styleTitleField.heightAnchor.constraint(equalToConstant: ChallengeDraftMeasure.titleFieldHeight).isActive = true

        shorePublishControl.translatesAutoresizingMaskIntoConstraints = false
        shorePublishControl.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .black)
        shorePublishControl.addTarget(self, action: #selector(publishShorelineDraft), for: .touchUpInside)

        view.addSubview(shoreDraftScrollCanvas)
        view.addSubview(shorePublishControl)
        shoreDraftScrollCanvas.addSubview(shoreDraftDeck)
        [shoreDraftNavRail, coverCard, form].forEach { shoreDraftDeck.addSubview($0) }

        NSLayoutConstraint.activate([
            shorePublishControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ChallengeDraftMeasure.pageSide),
            shorePublishControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ChallengeDraftMeasure.pageSide),
            shorePublishControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ChallengeDraftMeasure.publishBottom),

            shoreDraftScrollCanvas.topAnchor.constraint(equalTo: view.topAnchor),
            shoreDraftScrollCanvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoreDraftScrollCanvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoreDraftScrollCanvas.bottomAnchor.constraint(equalTo: shorePublishControl.topAnchor, constant: -12),

            shoreDraftDeck.topAnchor.constraint(equalTo: shoreDraftScrollCanvas.contentLayoutGuide.topAnchor),
            shoreDraftDeck.leadingAnchor.constraint(equalTo: shoreDraftScrollCanvas.contentLayoutGuide.leadingAnchor),
            shoreDraftDeck.trailingAnchor.constraint(equalTo: shoreDraftScrollCanvas.contentLayoutGuide.trailingAnchor),
            shoreDraftDeck.bottomAnchor.constraint(equalTo: shoreDraftScrollCanvas.contentLayoutGuide.bottomAnchor),
            shoreDraftDeck.widthAnchor.constraint(equalTo: shoreDraftScrollCanvas.frameLayoutGuide.widthAnchor),

            shoreDraftNavRail.topAnchor.constraint(equalTo: shoreDraftDeck.safeAreaLayoutGuide.topAnchor, constant: ChallengeDraftMeasure.navTop),
            shoreDraftNavRail.leadingAnchor.constraint(equalTo: shoreDraftDeck.leadingAnchor, constant: ChallengeDraftMeasure.pageSide),
            shoreDraftNavRail.trailingAnchor.constraint(equalTo: shoreDraftDeck.trailingAnchor, constant: -ChallengeDraftMeasure.pageSide),
            shoreDraftNavRail.heightAnchor.constraint(equalToConstant: ChallengeDraftMeasure.navHeight),

            coverCard.topAnchor.constraint(equalTo: shoreDraftNavRail.bottomAnchor, constant: ChallengeDraftMeasure.coverTop),
            coverCard.leadingAnchor.constraint(equalTo: shoreDraftDeck.leadingAnchor, constant: ChallengeDraftMeasure.pageSide),
            coverCard.trailingAnchor.constraint(equalTo: shoreDraftDeck.trailingAnchor, constant: -ChallengeDraftMeasure.pageSide),
            coverCard.heightAnchor.constraint(equalToConstant: ChallengeDraftMeasure.coverHeight),

            coverPreview.topAnchor.constraint(equalTo: coverCard.topAnchor),
            coverPreview.leadingAnchor.constraint(equalTo: coverCard.leadingAnchor),
            coverPreview.trailingAnchor.constraint(equalTo: coverCard.trailingAnchor),
            coverPreview.bottomAnchor.constraint(equalTo: coverCard.bottomAnchor),

            coverPromptStack.centerXAnchor.constraint(equalTo: coverCard.centerXAnchor),
            coverPromptStack.centerYAnchor.constraint(equalTo: coverCard.centerYAnchor),
            camera.widthAnchor.constraint(equalToConstant: 28),
            camera.heightAnchor.constraint(equalToConstant: 24),

            form.topAnchor.constraint(equalTo: coverCard.bottomAnchor, constant: ChallengeDraftMeasure.formTop),
            form.leadingAnchor.constraint(equalTo: coverCard.leadingAnchor),
            form.trailingAnchor.constraint(equalTo: coverCard.trailingAnchor),
            form.bottomAnchor.constraint(equalTo: shoreDraftDeck.bottomAnchor, constant: -24)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(foldDraftKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func anchorChallengeNav() {
        shoreDraftNavRail.translatesAutoresizingMaskIntoConstraints = false
        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)), for: .normal)
        back.tintColor = .suliInk
        back.addTarget(self, action: #selector(driftBackFromCurationDraft), for: .touchUpInside)
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Create Events"
        title.font = UIFont.systemFont(ofSize: 18, weight: .black)
        title.textColor = .suliInk
        title.textAlignment = .center
        shoreDraftNavRail.addSubview(back)
        shoreDraftNavRail.addSubview(title)
        NSLayoutConstraint.activate([
            back.leadingAnchor.constraint(equalTo: shoreDraftNavRail.leadingAnchor),
            back.centerYAnchor.constraint(equalTo: shoreDraftNavRail.centerYAnchor),
            back.widthAnchor.constraint(equalToConstant: 40),
            back.heightAnchor.constraint(equalToConstant: 40),
            title.centerXAnchor.constraint(equalTo: shoreDraftNavRail.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: shoreDraftNavRail.centerYAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: back.trailingAnchor, constant: 8)
        ])
    }

    private func makeChallengeHeading(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: ChallengeDraftMeasure.sectionTitleSize, weight: .black)
        label.textColor = .suliInk
        return label
    }

    private func makeChallengeChipRow(titles: [String], selected: String, storage: inout [UIButton], action: Selector) -> UIStackView {
        let column = UIStackView()
        column.axis = .vertical
        column.spacing = 10
        column.alignment = .leading
        var row = UIStackView()
        row.axis = .horizontal
        row.spacing = 10
        var width: CGFloat = 0
        let limit = UIScreen.main.bounds.width - ChallengeDraftMeasure.pageSide * 2
        for name in titles {
            let chip = SuliJoyChallengeDraftChip()
            chip.setTitle(name, for: .normal)
            chip.addTarget(self, action: action, for: .touchUpInside)
            paintChallengeChip(chip, selected: name == selected)
            storage.append(chip)
            let chipWidth = max(72, CGFloat(name.count * 9 + 36))
            if width > 0, width + chipWidth > limit {
                column.addArrangedSubview(row)
                row = UIStackView()
                row.axis = .horizontal
                row.spacing = 10
                width = 0
            }
            row.addArrangedSubview(chip)
            width += chipWidth + 10
        }
        if !row.arrangedSubviews.isEmpty {
            column.addArrangedSubview(row)
        }
        return column
    }

    private func paintChallengeChip(_ chip: SuliJoyChallengeDraftChip, selected: Bool) {
        chip.setSelectedChip(selected)
        chip.setTitleColor(selected ? .suliInk : UIColor(red: 0.70, green: 0.69, blue: 0.67, alpha: 1), for: .normal)
    }

    @objc private func chooseChallengeCover() {
        suliJoyCoastalStyle()
    }

    @objc private func chooseStyleSignal(_ sender: UIButton) {
        selectedStyleSignal = sender.title(for: .normal) ?? selectedStyleSignal
        styleSignalButtons.forEach {
            paintChallengeChip($0 as! SuliJoyChallengeDraftChip, selected: $0 === sender)
        }
    }

    @objc private func chooseChallengeDuration(_ sender: UIButton) {
        selectedDuration = sender.title(for: .normal) ?? selectedDuration
        durationButtons.forEach {
            paintChallengeChip($0 as! SuliJoyChallengeDraftChip, selected: $0 === sender)
        }
    }

    private func suliJoyCoastalStyle() {
        foldDraftKeyboard()
        let coverChoiceSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            coverChoiceSheet.addAction(UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
                self?.openCoverImagePicker(source: .camera)
            })
        }
        coverChoiceSheet.addAction(UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.openCoverImagePicker(source: .photoLibrary)
        })
        coverChoiceSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        coverChoiceSheet.popoverPresentationController?.sourceView = coverPreview
        coverChoiceSheet.popoverPresentationController?.sourceRect = coverPreview.bounds
        present(coverChoiceSheet, animated: true)
    }

    private func openCoverImagePicker(source reefSource: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(reefSource) else {
            showLagoonToast("Source unavailable.")
            return
        }
        let coverPicker = UIImagePickerController()
        coverPicker.sourceType = reefSource
        coverPicker.mediaTypes = ["public.image"]
        coverPicker.delegate = self
        coverPicker.allowsEditing = true
        present(coverPicker, animated: true)
    }

    func imagePickerController(_ coverPicker: UIImagePickerController, didFinishPickingMediaWithInfo reefInfo: [UIImagePickerController.InfoKey: Any]) {
        coverPicker.dismiss(animated: true)
        let coverImage = (reefInfo[.editedImage] as? UIImage) ?? (reefInfo[.originalImage] as? UIImage)
        guard let coverImage, let shorelinePath = storeCoverSnapshot(coverImage) else {
            showLagoonToast("Could not save cover photo.")
            return
        }
        coverReefPicks = [SuliJoyReefEventPhotoPick(reefSandboxPath: shorelinePath, hibiscusShade: "Event Cover")]
        coverPreview.image = coverImage
        coverPromptStack.isHidden = true
    }

    func imagePickerControllerDidCancel(_ coverPicker: UIImagePickerController) {
        coverPicker.dismiss(animated: true)
    }

    private func storeCoverSnapshot(_ coverImage: UIImage) -> String? {
        guard let reefData = coverImage.jpegData(compressionQuality: 0.86) else { return nil }
        let shoreDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("SuliJoyEventMedia", isDirectory: true)
        guard let shoreDirectory else { return nil }
        try? FileManager.default.createDirectory(at: shoreDirectory, withIntermediateDirectories: true)
        let shoreFileURL = shoreDirectory.appendingPathComponent("tide_photo_\(UUID().uuidString).jpg")
        do {
            try reefData.write(to: shoreFileURL, options: [.atomic])
            return shoreFileURL.path
        } catch {
            return nil
        }
    }

    @objc private func publishShorelineDraft() {
        foldDraftKeyboard()
        guard !coverReefPicks.isEmpty else {
            showLagoonToast("Please add a cover photo.")
            return
        }
        let shorelineTitle = (styleTitleField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !shorelineTitle.isEmpty else {
            showLagoonToast("Please enter a challenge title.")
            return
        }
        let hours: TimeInterval
        switch selectedDuration {
        case "3 days": hours = 3 * 24
        case "7 days": hours = 7 * 24
        default: hours = 23
        }
        let finish = Date().addingTimeInterval(hours * 3600)
        let tideDraft = SuliJoyTideDraftActivity(
            tideTitleLine: shorelineTitle,
            tideStyleKind: selectedStyleSignal,
            wardrobeThemeLine: selectedStyleSignal,
            shoreBriefLine: "Style Signal: \(selectedStyleSignal) · \(selectedDuration)",
            tideDay: finish,
            tideClock: finish,
            shoreSpotLine: "Island",
            tideCrewLimit: 30,
            pearlNeed: 0,
            reefPhotoPicks: coverReefPicks
        )
        shorePublishControl.isLoading = true
        shorePublishControl.isEnabled = false
        SuliJoyCoveMockService.shared.publishTideActivity(draft: tideDraft) { [weak self] publishEnvelope in
            guard let self else { return }
            self.shorePublishControl.isLoading = false
            self.shorePublishControl.isEnabled = true
            guard publishEnvelope.beachwearCapsule == 200 else {
                self.showLagoonToast(publishEnvelope.coastalWardrobe)
                return
            }
            self.showLagoonToast("Challenge created successfully.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @objc private func shoreDraftTextFieldChanged(_ sender: UITextField) {
        if sender === styleTitleField, let text = sender.text, text.count > 40 {
            sender.text = String(text.prefix(40))
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField === styleTitleField else { return true }
        let current = textField.text ?? ""
        guard let textRange = Range(range, in: current) else { return true }
        return current.replacingCharacters(in: textRange, with: string).count <= 40
    }

    private func registerDraftKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(draftKeyboardWillRise(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(draftKeyboardWillSettle(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func draftKeyboardWillRise(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let inset = frame.height - view.safeAreaInsets.bottom + 18
        shoreDraftScrollCanvas.contentInset.bottom = inset
        shoreDraftScrollCanvas.verticalScrollIndicatorInsets.bottom = inset
    }

    @objc private func draftKeyboardWillSettle(_ note: Notification) {
        shoreDraftScrollCanvas.contentInset.bottom = 0
        shoreDraftScrollCanvas.verticalScrollIndicatorInsets.bottom = 0
    }

    @objc private func foldDraftKeyboard() {
        view.endEditing(true)
    }

    @objc private func driftBackFromCurationDraft() {
        navigationController?.popViewController(animated: true)
    }
}

private final class SuliJoyChallengeDraftChip: UIButton {
    private let gradientRing = CAGradientLayer()
    private let innerShell = UIView()

    init() {
        super.init(frame: .zero)
        titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        gradientRing.colors = [
            UIColor(red: 1, green: 0.55, blue: 0.28, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.92, blue: 0.32, alpha: 1).cgColor,
            UIColor(red: 0.55, green: 0.98, blue: 0.55, alpha: 1).cgColor
        ]
        gradientRing.startPoint = CGPoint(x: 0, y: 0.5)
        gradientRing.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientRing, at: 0)
        innerShell.backgroundColor = .white
        innerShell.isUserInteractionEnabled = false
        insertSubview(innerShell, at: 0)
        setSelectedChip(false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSelectedChip(_ selected: Bool) {
        gradientRing.isHidden = !selected
        layer.borderWidth = selected ? 0 : 1
        layer.borderColor = UIColor(red: 0.90, green: 0.88, blue: 0.84, alpha: 1).cgColor
        backgroundColor = .white
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        gradientRing.frame = bounds
        gradientRing.cornerRadius = bounds.height / 2
        let inset: CGFloat = gradientRing.isHidden ? 0 : 2
        innerShell.frame = bounds.insetBy(dx: inset, dy: inset)
        innerShell.layer.cornerRadius = innerShell.bounds.height / 2
    }
}
