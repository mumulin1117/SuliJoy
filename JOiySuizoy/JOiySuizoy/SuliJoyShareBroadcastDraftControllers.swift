import UIKit

// MARK: - Go Live

final class SuliJoyGoLiveDraftController: SuliJoyTropicCanvasController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    private enum GoLiveMeasure {
        static let pageSide: CGFloat = 20
        static let navHeight: CGFloat = 44
        static let coverHeight: CGFloat = 188
        static let coverCorner: CGFloat = 22
        static let fieldHeight: CGFloat = 52
        static let fieldCorner: CGFloat = 16
        static let publishHeight: CGFloat = 54
        static let publishBottom: CGFloat = 8
        static let sectionSpacing: CGFloat = 18
    }

    private let shoreScroll = UIScrollView()
    private let reefDeck = UIView()
    private let coverPreview = UIImageView()
    private let coverPromptStack = UIStackView()
    private let titleField = UITextField()
    private let categoryWrap = UIStackView()
    private let categoryEmptyNote = UILabel()
    private let liveTypeWrap = UIStackView()
    private let publishButton = SuliJoyGradientButton(reefHeadline: "Go Live", reefHeight: GoLiveMeasure.publishHeight)
    private let loadingMark = UIActivityIndicatorView(style: .medium)

    private var coverSandboxPath: String?
    private var setup = SuliJoyLagoonLiveHostSetup(categoryChoices: [], liveTypes: [], locales: [], contentReminderText: "")
    private var selectedCategory: String?
    private var selectedLiveTypeCode = ""
    private var categoryButtons: [UIButton] = []
    private var liveTypeButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        assembleGoLiveScene()
        registerGoLiveKeyboardObservers()
        loadGoLiveSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    @MainActor deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func assembleGoLiveScene() {
        shoreScroll.translatesAutoresizingMaskIntoConstraints = false
        shoreScroll.keyboardDismissMode = .interactive
        shoreScroll.showsVerticalScrollIndicator = false
        reefDeck.translatesAutoresizingMaskIntoConstraints = false

        let nav = makeGoLiveNav(title: "Go Live")
        let coverCard = makeCoverCard(action: #selector(chooseGoLiveCover))
        let form = UIStackView()
        form.translatesAutoresizingMaskIntoConstraints = false
        form.axis = .vertical
        form.spacing = GoLiveMeasure.sectionSpacing

        configureTitleField()
        categoryWrap.axis = .vertical
        categoryWrap.spacing = 10
        categoryEmptyNote.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        categoryEmptyNote.textColor = .suliMutedInk
        categoryEmptyNote.numberOfLines = 0
        categoryEmptyNote.isHidden = true
        liveTypeWrap.axis = .vertical
        liveTypeWrap.spacing = 10

        publishButton.translatesAutoresizingMaskIntoConstraints = false
        publishButton.addTarget(self, action: #selector(submitGoLive), for: .touchUpInside)

        loadingMark.translatesAutoresizingMaskIntoConstraints = false
        loadingMark.hidesWhenStopped = true

        form.addArrangedSubview(makeSectionHeading("Live title"))
        form.addArrangedSubview(titleField)
        form.addArrangedSubview(makeSectionHeading("Category"))
        form.addArrangedSubview(categoryEmptyNote)
        form.addArrangedSubview(categoryWrap)
        form.addArrangedSubview(makeSectionHeading("Live type"))
        form.addArrangedSubview(liveTypeWrap)

        titleField.heightAnchor.constraint(equalToConstant: GoLiveMeasure.fieldHeight).isActive = true

        view.addSubview(shoreScroll)
        view.addSubview(publishButton)
        view.addSubview(loadingMark)
        shoreScroll.addSubview(reefDeck)
        [nav, coverCard, form].forEach { reefDeck.addSubview($0) }

        NSLayoutConstraint.activate([
            publishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: GoLiveMeasure.pageSide),
            publishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -GoLiveMeasure.pageSide),
            publishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -GoLiveMeasure.publishBottom),

            shoreScroll.topAnchor.constraint(equalTo: view.topAnchor),
            shoreScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoreScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoreScroll.bottomAnchor.constraint(equalTo: publishButton.topAnchor, constant: -12),

            reefDeck.topAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.topAnchor),
            reefDeck.leadingAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.leadingAnchor),
            reefDeck.trailingAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.trailingAnchor),
            reefDeck.bottomAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.bottomAnchor),
            reefDeck.widthAnchor.constraint(equalTo: shoreScroll.frameLayoutGuide.widthAnchor),

            nav.topAnchor.constraint(equalTo: reefDeck.safeAreaLayoutGuide.topAnchor, constant: 8),
            nav.leadingAnchor.constraint(equalTo: reefDeck.leadingAnchor, constant: GoLiveMeasure.pageSide),
            nav.trailingAnchor.constraint(equalTo: reefDeck.trailingAnchor, constant: -GoLiveMeasure.pageSide),
            nav.heightAnchor.constraint(equalToConstant: GoLiveMeasure.navHeight),

            coverCard.topAnchor.constraint(equalTo: nav.bottomAnchor, constant: 16),
            coverCard.leadingAnchor.constraint(equalTo: reefDeck.leadingAnchor, constant: GoLiveMeasure.pageSide),
            coverCard.trailingAnchor.constraint(equalTo: reefDeck.trailingAnchor, constant: -GoLiveMeasure.pageSide),
            coverCard.heightAnchor.constraint(equalToConstant: GoLiveMeasure.coverHeight),

            form.topAnchor.constraint(equalTo: coverCard.bottomAnchor, constant: 22),
            form.leadingAnchor.constraint(equalTo: coverCard.leadingAnchor),
            form.trailingAnchor.constraint(equalTo: coverCard.trailingAnchor),
            form.bottomAnchor.constraint(equalTo: reefDeck.bottomAnchor, constant: -24),

            loadingMark.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingMark.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(foldGoLiveKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func makeGoLiveNav(title: String) -> UIView {
        let nav = UIView()
        nav.translatesAutoresizingMaskIntoConstraints = false
        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)), for: .normal)
        back.tintColor = .suliInk
        back.addTarget(self, action: #selector(driftBackFromGoLive), for: .touchUpInside)
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = UIFont.systemFont(ofSize: 18, weight: .black)
        label.textColor = .suliInk
        label.textAlignment = .center
        nav.addSubview(back)
        nav.addSubview(label)
        NSLayoutConstraint.activate([
            back.leadingAnchor.constraint(equalTo: nav.leadingAnchor),
            back.centerYAnchor.constraint(equalTo: nav.centerYAnchor),
            back.widthAnchor.constraint(equalToConstant: 40),
            back.heightAnchor.constraint(equalToConstant: 40),
            label.centerXAnchor.constraint(equalTo: nav.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: nav.centerYAnchor)
        ])
        return nav
    }

    private func makeCoverCard(action: Selector) -> UIControl {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = UIColor(red: 0.98, green: 0.86, blue: 0.62, alpha: 1)
        card.layer.cornerRadius = GoLiveMeasure.coverCorner
        card.clipsToBounds = true
        card.addTarget(self, action: action, for: .touchUpInside)
        coverPreview.translatesAutoresizingMaskIntoConstraints = false
        coverPreview.contentMode = .scaleAspectFill
        coverPreview.clipsToBounds = true
        let camera = UIImageView(image: UIImage(systemName: "camera.fill"))
        camera.tintColor = .white
        camera.contentMode = .scaleAspectFit
        let prompt = UILabel()
        prompt.text = "Add a live cover"
        prompt.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        prompt.textColor = .white
        coverPromptStack.axis = .vertical
        coverPromptStack.alignment = .center
        coverPromptStack.spacing = 8
        coverPromptStack.translatesAutoresizingMaskIntoConstraints = false
        coverPromptStack.isUserInteractionEnabled = false
        coverPromptStack.addArrangedSubview(camera)
        coverPromptStack.addArrangedSubview(prompt)
        card.addSubview(coverPreview)
        card.addSubview(coverPromptStack)
        NSLayoutConstraint.activate([
            coverPreview.topAnchor.constraint(equalTo: card.topAnchor),
            coverPreview.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            coverPreview.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            coverPreview.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            coverPromptStack.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            coverPromptStack.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            camera.widthAnchor.constraint(equalToConstant: 28),
            camera.heightAnchor.constraint(equalToConstant: 24)
        ])
        return card
    }

    private func configureTitleField() {
        titleField.translatesAutoresizingMaskIntoConstraints = false
        titleField.placeholder = "Share your beach style live"
        titleField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleField.textColor = .suliInk
        titleField.backgroundColor = .white
        titleField.layer.cornerRadius = GoLiveMeasure.fieldCorner
        titleField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        titleField.leftViewMode = .always
        titleField.delegate = self
        titleField.returnKeyType = .done
    }

    private func makeSectionHeading(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18, weight: .black)
        label.textColor = .suliInk
        return label
    }

    private func loadGoLiveSetup() {
        loadingMark.startAnimating()
        publishButton.isEnabled = false
        SuliJoyLagoonProfileRemoteService.shared.fetchLiveHostSetup { [weak self] envelope in
            guard let self else { return }
            self.loadingMark.stopAnimating()
            self.publishButton.isEnabled = true
            guard envelope.beachwearCapsule == 200, let setup = envelope.sandbarLayering else {
                self.showLagoonToast(envelope.coastalWardrobe)
                self.applyGoLiveFallbackSetup(message: envelope.coastalWardrobe)
                return
            }
            self.setup = setup
            self.selectedCategory = self.goLiveCategoryChoices(from: setup).first?.submitValue
            self.selectedLiveTypeCode = self.mergedGoLiveTypes(from: setup).first?.code ?? "VIDEO"
            self.rebuildGoLiveChips()
        }
    }

    private func applyGoLiveFallbackSetup(message: String? = nil) {
        let cached = SuliJoyGoLiveCatalog.publishCategories.map {
            SuliJoyLagoonLiveCategoryChoice(submitValue: $0, displayTitle: $0)
        }
        setup = SuliJoyLagoonLiveHostSetup(
            categoryChoices: cached,
            liveTypes: [],
            locales: [],
            contentReminderText: "I agree to follow community live guidelines."
        )
        selectedCategory = cached.first?.submitValue
        selectedLiveTypeCode = SuliJoyGoLiveCatalog.defaultLiveTypes.first?.code ?? "VIDEO"
        rebuildGoLiveChips()
        if let message, !message.isEmpty {
            showLagoonToast(message)
        }
    }

    private func goLiveCategoryChoices(from setup: SuliJoyLagoonLiveHostSetup) -> [SuliJoyLagoonLiveCategoryChoice] {
        setup.categoryChoices.filter { !$0.submitValue.isEmpty || !$0.displayTitle.isEmpty }
    }

    private func mergedGoLiveTypes(from setup: SuliJoyLagoonLiveHostSetup) -> [(code: String, title: String)] {
        let remote = setup.liveTypes.map { pair in
            (code: pair.code, title: displayLiveTypeTitle(code: pair.code, fallback: pair.title))
        }
        if !remote.isEmpty { return remote }
        return SuliJoyGoLiveCatalog.defaultLiveTypes
    }

    private func displayLiveTypeTitle(code: String, fallback: String) -> String {
        switch code.uppercased() {
        case "VIDEO": return "Style cam"
        case "AUDIO": return "Voice chat"
        default: return fallback.isEmpty ? code : fallback
        }
    }

    private func rebuildGoLiveChips() {
        categoryWrap.arrangedSubviews.forEach { $0.removeFromSuperview() }
        liveTypeWrap.arrangedSubviews.forEach { $0.removeFromSuperview() }
        categoryButtons = []
        liveTypeButtons = []

        let categories = goLiveCategoryChoices(from: setup)
        categoryEmptyNote.isHidden = !categories.isEmpty
        categoryEmptyNote.text = categories.isEmpty
            ? "Categories are loading from the live host options. Check your connection and reopen Go Live."
            : nil
        let categoryOptions = categories.map {
            SuliJoyShareDraftChipOption(displayTitle: $0.displayTitle, apiValue: $0.submitValue)
        }
        if selectedCategory == nil
            || !categories.contains(where: { $0.submitValue.caseInsensitiveCompare(selectedCategory ?? "") == .orderedSame }) {
            selectedCategory = categories.first?.submitValue
        }
        if !categoryOptions.isEmpty {
            categoryWrap.addArrangedSubview(
                SuliJoyShareDraftChipRow.makeFlow(
                    options: categoryOptions,
                    selectedValue: selectedCategory ?? categories.first?.submitValue ?? "",
                    storage: &categoryButtons,
                    target: self,
                    action: #selector(selectGoLiveCategory(_:))
                )
            )
        }

        let types = mergedGoLiveTypes(from: setup)
        if !types.contains(where: { $0.code == selectedLiveTypeCode }) {
            selectedLiveTypeCode = types.first?.code ?? "VIDEO"
        }
        let typeOptions = types.map { SuliJoyShareDraftChipOption(displayTitle: $0.title, apiValue: $0.code) }
        liveTypeWrap.addArrangedSubview(
            SuliJoyShareDraftChipRow.makeFlow(
                options: typeOptions,
                selectedValue: selectedLiveTypeCode,
                storage: &liveTypeButtons,
                target: self,
                action: #selector(selectGoLiveType(_:))
            )
        )
    }

    @objc private func selectGoLiveCategory(_ sender: UIButton) {
        selectedCategory = sender.accessibilityIdentifier ?? sender.title(for: .normal)
        SuliJoyShareDraftChipRow.paint(buttons: categoryButtons, selected: sender)
    }

    @objc private func selectGoLiveType(_ sender: UIButton) {
        selectedLiveTypeCode = sender.accessibilityIdentifier ?? sender.title(for: .normal) ?? selectedLiveTypeCode
        SuliJoyShareDraftChipRow.paint(buttons: liveTypeButtons, selected: sender)
    }

    @objc private func chooseGoLiveCover() {
        foldGoLiveKeyboard()
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sheet.addAction(UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
                self?.presentCoverPicker(source: .camera)
            })
        }
        sheet.addAction(UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.presentCoverPicker(source: .photoLibrary)
        })
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.popoverPresentationController?.sourceView = coverPreview
        sheet.popoverPresentationController?.sourceRect = coverPreview.bounds
        present(sheet, animated: true)
    }

    private func presentCoverPicker(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            showLagoonToast("Source unavailable.")
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.mediaTypes = ["public.image"]
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        guard let image, let path = SuliJoyShareDraftMediaStore.persistJPEG(image) else {
            showLagoonToast("Could not save cover photo.")
            return
        }
        coverSandboxPath = path
        coverPreview.image = image
        coverPromptStack.isHidden = true
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    @objc private func submitGoLive() {
        foldGoLiveKeyboard()
        guard let coverSandboxPath else {
            showLagoonToast("Add a live cover photo.")
            return
        }
        let allowed = goLiveCategoryChoices(from: setup)
        guard let picked = selectedCategory,
              let category = allowed.first(where: { $0.submitValue.caseInsensitiveCompare(picked) == .orderedSame }) else {
            showLagoonToast("Select a category from the list.")
            return
        }
        let draft = SuliJoyGoLiveDraft(
            coverSandboxPath: coverSandboxPath,
            liveTitle: titleField.text ?? "",
            category: category.submitValue,
            liveType: selectedLiveTypeCode,
            contentReminderAccepted: true
        )
        publishButton.isLoading = true
        publishButton.isEnabled = false
        SuliJoyLagoonProfileRemoteService.shared.publishLiveBroadcast(draft: draft) { [weak self] envelope in
            guard let self else { return }
            self.publishButton.isLoading = false
            self.publishButton.isEnabled = true
            guard envelope.beachwearCapsule == 200, let session = envelope.sandbarLayering else {
                self.showLagoonToast(envelope.coastalWardrobe)
                return
            }
            self.showLagoonToast(envelope.coastalWardrobe)
            let roomID = String(session.roomID)
            self.navigationController?.popViewController(animated: false)
            if let host = self.navigationController?.topViewController {
                SuliJoyRoomShellNavigator.openRoom(kind: .live, roomID: roomID, from: host, animated: true)
            }
        }
    }

    private func registerGoLiveKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(goLiveKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goLiveKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func goLiveKeyboardWillShow(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let inset = frame.height - view.safeAreaInsets.bottom + 18
        shoreScroll.contentInset.bottom = inset
        shoreScroll.verticalScrollIndicatorInsets.bottom = inset
    }

    @objc private func goLiveKeyboardWillHide(_ note: Notification) {
        shoreScroll.contentInset.bottom = 0
        shoreScroll.verticalScrollIndicatorInsets.bottom = 0
    }

    @objc private func foldGoLiveKeyboard() {
        view.endEditing(true)
    }

    @objc private func driftBackFromGoLive() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Voice room

final class SuliJoyVoiceRoomDraftController: SuliJoyTropicCanvasController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    private enum VoiceRoomMeasure {
        static let pageSide: CGFloat = 20
        static let navHeight: CGFloat = 44
        static let coverHeight: CGFloat = 188
        static let coverCorner: CGFloat = 22
        static let fieldHeight: CGFloat = 52
        static let fieldCorner: CGFloat = 16
        static let greetingMinHeight: CGFloat = 96
        static let publishHeight: CGFloat = 54
        static let publishBottom: CGFloat = 8
        static let sectionSpacing: CGFloat = 18
    }

    private let shoreScroll = UIScrollView()
    private let reefDeck = UIView()
    private let coverPreview = UIImageView()
    private let coverPromptStack = UIStackView()
    private let nameField = UITextField()
    private let greetingView = UITextView()
    private let greetingPlaceholder = UILabel()
    private let gateNote = UILabel()
    private let templateWrap = UIStackView()
    private let vibeHeading = UILabel()
    private let tagWrap = UIStackView()
    private let publishButton = SuliJoyGradientButton(reefHeadline: "Start Room", reefHeight: VoiceRoomMeasure.publishHeight)
    private let loadingMark = UIActivityIndicatorView(style: .medium)

    private var coverSandboxPath: String?
    private var setup = SuliJoyLagoonVoiceRoomSetup(
        canCreateRoom: true,
        createRoomLevel: 0,
        roomTagChoices: [],
        templates: [],
        languages: []
    )
    private var selectedTemplateID = 1
    private var selectedVibeSubmitValue: String?
    private var templateButtons: [UIButton] = []
    private var tagButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        assembleVoiceRoomScene()
        registerVoiceRoomKeyboardObservers()
        loadVoiceRoomSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    @MainActor deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func assembleVoiceRoomScene() {
        shoreScroll.translatesAutoresizingMaskIntoConstraints = false
        shoreScroll.keyboardDismissMode = .interactive
        shoreScroll.showsVerticalScrollIndicator = false
        reefDeck.translatesAutoresizingMaskIntoConstraints = false

        let nav = makeVoiceNav()
        let coverCard = makeVoiceCoverCard()
        let form = UIStackView()
        form.translatesAutoresizingMaskIntoConstraints = false
        form.axis = .vertical
        form.spacing = VoiceRoomMeasure.sectionSpacing

        gateNote.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        gateNote.textColor = UIColor(red: 0.72, green: 0.38, blue: 0.12, alpha: 1)
        gateNote.numberOfLines = 0
        gateNote.isHidden = true

        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.placeholder = "Name your voice room"
        nameField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameField.backgroundColor = .white
        nameField.layer.cornerRadius = VoiceRoomMeasure.fieldCorner
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        nameField.leftViewMode = .always
        nameField.delegate = self

        greetingView.translatesAutoresizingMaskIntoConstraints = false
        greetingView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        greetingView.textColor = .suliInk
        greetingView.backgroundColor = .white
        greetingView.layer.cornerRadius = VoiceRoomMeasure.fieldCorner
        greetingView.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        greetingView.delegate = self

        greetingPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        greetingPlaceholder.text = "Tell listeners what this room is about"
        greetingPlaceholder.font = greetingView.font
        greetingPlaceholder.textColor = UIColor(red: 0.72, green: 0.71, blue: 0.70, alpha: 1)

        templateWrap.axis = .vertical
        templateWrap.spacing = 10
        tagWrap.axis = .vertical
        tagWrap.spacing = 10

        publishButton.translatesAutoresizingMaskIntoConstraints = false
        publishButton.addTarget(self, action: #selector(submitVoiceRoom), for: .touchUpInside)
        loadingMark.translatesAutoresizingMaskIntoConstraints = false
        loadingMark.hidesWhenStopped = true

        form.addArrangedSubview(gateNote)
        form.addArrangedSubview(makeVoiceHeading("Room name"))
        form.addArrangedSubview(nameField)
        form.addArrangedSubview(makeVoiceHeading("Greeting"))
        form.addArrangedSubview(greetingView)
        form.addArrangedSubview(makeVoiceHeading("Room layout"))
        form.addArrangedSubview(templateWrap)
        vibeHeading.text = "Room vibe"
        vibeHeading.font = UIFont.systemFont(ofSize: 18, weight: .black)
        vibeHeading.textColor = .suliInk
        vibeHeading.isHidden = true
        tagWrap.isHidden = true
        form.addArrangedSubview(vibeHeading)
        form.addArrangedSubview(tagWrap)

        nameField.heightAnchor.constraint(equalToConstant: VoiceRoomMeasure.fieldHeight).isActive = true
        greetingView.heightAnchor.constraint(greaterThanOrEqualToConstant: VoiceRoomMeasure.greetingMinHeight).isActive = true

        view.addSubview(shoreScroll)
        view.addSubview(publishButton)
        view.addSubview(loadingMark)
        shoreScroll.addSubview(reefDeck)
        reefDeck.addSubview(greetingPlaceholder)
        [nav, coverCard, form].forEach { reefDeck.addSubview($0) }

        NSLayoutConstraint.activate([
            publishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: VoiceRoomMeasure.pageSide),
            publishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -VoiceRoomMeasure.pageSide),
            publishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -VoiceRoomMeasure.publishBottom),

            shoreScroll.topAnchor.constraint(equalTo: view.topAnchor),
            shoreScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoreScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoreScroll.bottomAnchor.constraint(equalTo: publishButton.topAnchor, constant: -12),

            reefDeck.topAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.topAnchor),
            reefDeck.leadingAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.leadingAnchor),
            reefDeck.trailingAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.trailingAnchor),
            reefDeck.bottomAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.bottomAnchor),
            reefDeck.widthAnchor.constraint(equalTo: shoreScroll.frameLayoutGuide.widthAnchor),

            nav.topAnchor.constraint(equalTo: reefDeck.safeAreaLayoutGuide.topAnchor, constant: 8),
            nav.leadingAnchor.constraint(equalTo: reefDeck.leadingAnchor, constant: VoiceRoomMeasure.pageSide),
            nav.trailingAnchor.constraint(equalTo: reefDeck.trailingAnchor, constant: -VoiceRoomMeasure.pageSide),
            nav.heightAnchor.constraint(equalToConstant: VoiceRoomMeasure.navHeight),

            coverCard.topAnchor.constraint(equalTo: nav.bottomAnchor, constant: 16),
            coverCard.leadingAnchor.constraint(equalTo: reefDeck.leadingAnchor, constant: VoiceRoomMeasure.pageSide),
            coverCard.trailingAnchor.constraint(equalTo: reefDeck.trailingAnchor, constant: -VoiceRoomMeasure.pageSide),
            coverCard.heightAnchor.constraint(equalToConstant: VoiceRoomMeasure.coverHeight),

            form.topAnchor.constraint(equalTo: coverCard.bottomAnchor, constant: 22),
            form.leadingAnchor.constraint(equalTo: coverCard.leadingAnchor),
            form.trailingAnchor.constraint(equalTo: coverCard.trailingAnchor),
            form.bottomAnchor.constraint(equalTo: reefDeck.bottomAnchor, constant: -24),

            greetingPlaceholder.topAnchor.constraint(equalTo: greetingView.topAnchor, constant: 14),
            greetingPlaceholder.leadingAnchor.constraint(equalTo: greetingView.leadingAnchor, constant: 16),

            loadingMark.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingMark.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(foldVoiceRoomKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func makeVoiceNav() -> UIView {
        let nav = UIView()
        nav.translatesAutoresizingMaskIntoConstraints = false
        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)), for: .normal)
        back.tintColor = .suliInk
        back.addTarget(self, action: #selector(driftBackFromVoiceRoom), for: .touchUpInside)
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Start a Room"
        label.font = UIFont.systemFont(ofSize: 18, weight: .black)
        label.textColor = .suliInk
        label.textAlignment = .center
        nav.addSubview(back)
        nav.addSubview(label)
        NSLayoutConstraint.activate([
            back.leadingAnchor.constraint(equalTo: nav.leadingAnchor),
            back.centerYAnchor.constraint(equalTo: nav.centerYAnchor),
            back.widthAnchor.constraint(equalToConstant: 40),
            back.heightAnchor.constraint(equalToConstant: 40),
            label.centerXAnchor.constraint(equalTo: nav.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: nav.centerYAnchor)
        ])
        return nav
    }

    private func makeVoiceCoverCard() -> UIControl {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = UIColor(red: 0.98, green: 0.86, blue: 0.62, alpha: 1)
        card.layer.cornerRadius = VoiceRoomMeasure.coverCorner
        card.clipsToBounds = true
        card.addTarget(self, action: #selector(chooseVoiceCover), for: .touchUpInside)
        coverPreview.translatesAutoresizingMaskIntoConstraints = false
        coverPreview.contentMode = .scaleAspectFill
        coverPreview.clipsToBounds = true
        let camera = UIImageView(image: UIImage(systemName: "camera.fill"))
        camera.tintColor = .white
        let prompt = UILabel()
        prompt.text = "Add a room cover"
        prompt.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        prompt.textColor = .white
        coverPromptStack.axis = .vertical
        coverPromptStack.alignment = .center
        coverPromptStack.spacing = 8
        coverPromptStack.translatesAutoresizingMaskIntoConstraints = false
        coverPromptStack.isUserInteractionEnabled = false
        coverPromptStack.addArrangedSubview(camera)
        coverPromptStack.addArrangedSubview(prompt)
        card.addSubview(coverPreview)
        card.addSubview(coverPromptStack)
        NSLayoutConstraint.activate([
            coverPreview.topAnchor.constraint(equalTo: card.topAnchor),
            coverPreview.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            coverPreview.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            coverPreview.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            coverPromptStack.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            coverPromptStack.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])
        return card
    }

    private func makeVoiceHeading(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18, weight: .black)
        label.textColor = .suliInk
        return label
    }

    private func loadVoiceRoomSetup() {
        loadingMark.startAnimating()
        publishButton.isEnabled = false
        SuliJoyLagoonProfileRemoteService.shared.fetchVoiceRoomSetup { [weak self] envelope in
            guard let self else { return }
            self.loadingMark.stopAnimating()
            self.publishButton.isEnabled = true
            guard envelope.beachwearCapsule == 200, let setup = envelope.sandbarLayering else {
                self.showLagoonToast(envelope.coastalWardrobe)
                self.applyVoiceRoomFallbackSetup(message: envelope.coastalWardrobe)
                return
            }
            self.setup = setup
            self.selectedTemplateID = self.voiceLayouts(from: setup).first?.id ?? 0
            self.selectedVibeSubmitValue = self.voiceTagChoices(from: setup).first?.submitValue
            if !setup.canCreateRoom {
                self.gateNote.isHidden = false
                self.gateNote.text = "Reach Lv\(setup.createRoomLevel) to create a voice room. You can still preview the form."
            } else {
                self.gateNote.isHidden = true
            }
            self.rebuildVoiceRoomChips()
        }
    }

    private func applyVoiceRoomFallbackSetup(message: String? = nil) {
        setup = SuliJoyLagoonVoiceRoomSetup(
            canCreateRoom: true,
            createRoomLevel: 0,
            roomTagChoices: [],
            templates: [],
            languages: []
        )
        selectedTemplateID = 0
        selectedVibeSubmitValue = nil
        gateNote.isHidden = false
        gateNote.text = message ?? "Could not load room options. Check your connection and try again."
        rebuildVoiceRoomChips()
    }

    private func voiceLayouts(from setup: SuliJoyLagoonVoiceRoomSetup) -> [(id: Int, title: String)] {
        setup.templates.map { ($0.id, displayVoiceLayoutTitle(id: $0.id, fallback: $0.title)) }
    }

    private func displayVoiceLayoutTitle(id: Int, fallback: String) -> String {
        switch id {
        case 1: return fallback.isEmpty ? "Classic circle" : fallback
        case 2: return fallback.isEmpty ? "Coastal lounge" : fallback
        default: return fallback.isEmpty ? "Room layout \(id)" : fallback
        }
    }

    private func voiceTagChoices(from setup: SuliJoyLagoonVoiceRoomSetup) -> [SuliJoyLagoonVoiceRoomTagChoice] {
        setup.roomTagChoices.filter { !$0.displayTitle.isEmpty || !$0.submitValue.isEmpty }
    }

    private func rebuildVoiceRoomChips() {
        templateWrap.arrangedSubviews.forEach { $0.removeFromSuperview() }
        tagWrap.arrangedSubviews.forEach { $0.removeFromSuperview() }
        templateButtons = []
        tagButtons = []

        let layouts = voiceLayouts(from: setup)
        if !layouts.contains(where: { $0.id == selectedTemplateID }) {
            selectedTemplateID = layouts.first?.id ?? 0
        }
        let layoutOptions = layouts.map {
            SuliJoyShareDraftChipOption(displayTitle: $0.title, apiValue: String($0.id))
        }
        templateWrap.addArrangedSubview(
            SuliJoyShareDraftChipRow.makeFlow(
                options: layoutOptions,
                selectedValue: String(selectedTemplateID),
                storage: &templateButtons,
                target: self,
                action: #selector(selectVoiceTemplate(_:))
            )
        )

        let vibes = voiceTagChoices(from: setup)
        let showVibes = false
        vibeHeading.isHidden = !showVibes || vibes.isEmpty
        tagWrap.isHidden = !showVibes || vibes.isEmpty
        guard showVibes, !vibes.isEmpty else { return }

        if selectedVibeSubmitValue == nil
            || !vibes.contains(where: { $0.submitValue == selectedVibeSubmitValue }) {
            selectedVibeSubmitValue = vibes.first?.submitValue
        }
        let vibeOptions = vibes.map {
            SuliJoyShareDraftChipOption(displayTitle: $0.displayTitle, apiValue: $0.submitValue)
        }
        tagWrap.addArrangedSubview(
            SuliJoyShareDraftChipRow.makeFlow(
                options: vibeOptions,
                selectedValue: selectedVibeSubmitValue ?? "",
                storage: &tagButtons,
                target: self,
                action: #selector(selectVoiceVibe(_:))
            )
        )
    }

    @objc private func selectVoiceTemplate(_ sender: UIButton) {
        if let idLine = sender.accessibilityIdentifier, let id = Int(idLine) {
            selectedTemplateID = id
        }
        SuliJoyShareDraftChipRow.paint(buttons: templateButtons, selected: sender)
    }

    @objc private func selectVoiceVibe(_ sender: UIButton) {
        selectedVibeSubmitValue = sender.accessibilityIdentifier
        SuliJoyShareDraftChipRow.paint(buttons: tagButtons, selected: sender)
    }

    func textViewDidChange(_ textView: UITextView) {
        greetingPlaceholder.isHidden = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    @objc private func chooseVoiceCover() {
        foldVoiceRoomKeyboard()
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sheet.addAction(UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
                self?.presentVoiceCoverPicker(source: .camera)
            })
        }
        sheet.addAction(UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.presentVoiceCoverPicker(source: .photoLibrary)
        })
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.popoverPresentationController?.sourceView = coverPreview
        present(sheet, animated: true)
    }

    private func presentVoiceCoverPicker(source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.mediaTypes = ["public.image"]
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        guard let image, let path = SuliJoyShareDraftMediaStore.persistJPEG(image) else {
            showLagoonToast("Could not save cover photo.")
            return
        }
        coverSandboxPath = path
        coverPreview.image = image
        coverPromptStack.isHidden = true
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    @objc private func submitVoiceRoom() {
        foldVoiceRoomKeyboard()
        guard let coverSandboxPath else {
            showLagoonToast("Add a room cover photo.")
            return
        }
        let layouts = voiceLayouts(from: setup)
        guard let layout = layouts.first(where: { $0.id == selectedTemplateID }), selectedTemplateID > 0 else {
            showLagoonToast("Select a room layout from the list.")
            return
        }
        let draft = SuliJoyVoiceRoomDraft(
            coverSandboxPath: coverSandboxPath,
            roomName: nameField.text ?? "",
            greetingMessage: greetingView.text ?? "",
            roomTempID: layout.id
        )
        publishButton.isLoading = true
        publishButton.isEnabled = false
        SuliJoyLagoonProfileRemoteService.shared.publishVoiceRoom(draft: draft) { [weak self] envelope in
            guard let self else { return }
            self.publishButton.isLoading = false
            self.publishButton.isEnabled = true
            guard envelope.beachwearCapsule == 200, let room = envelope.sandbarLayering else {
                self.showLagoonToast(envelope.coastalWardrobe)
                return
            }
            self.showLagoonToast(envelope.coastalWardrobe)
            let roomID = String(room.roomID)
            self.navigationController?.popViewController(animated: false)
            if let host = self.navigationController?.topViewController {
                SuliJoyRoomShellNavigator.openRoom(kind: .voice, roomID: roomID, from: host, animated: true)
            }
        }
    }

    private func registerVoiceRoomKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(voiceRoomKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(voiceRoomKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func voiceRoomKeyboardWillShow(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let inset = frame.height - view.safeAreaInsets.bottom + 18
        shoreScroll.contentInset.bottom = inset
        shoreScroll.verticalScrollIndicatorInsets.bottom = inset
    }

    @objc private func voiceRoomKeyboardWillHide(_ note: Notification) {
        shoreScroll.contentInset.bottom = 0
        shoreScroll.verticalScrollIndicatorInsets.bottom = 0
    }

    @objc private func foldVoiceRoomKeyboard() {
        view.endEditing(true)
    }

    @objc private func driftBackFromVoiceRoom() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Shared helpers

private enum SuliJoyShareDraftMediaStore {
    static func persistJPEG(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.86) else { return nil }
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("SuliJoyBroadcastMedia", isDirectory: true)
        guard let directory else { return nil }
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let fileURL = directory.appendingPathComponent("cover-\(UUID().uuidString).jpg")
        do {
            try data.write(to: fileURL, options: .atomic)
            return fileURL.path
        } catch {
            return nil
        }
    }
}

private struct SuliJoyShareDraftChipOption {
    let displayTitle: String
    let apiValue: String
}

private enum SuliJoyShareDraftChipRow {
    static let horizontalTextInset: CGFloat = 8

    static func makeFlow(
        options: [SuliJoyShareDraftChipOption],
        selectedValue: String,
        storage: inout [UIButton],
        target: Any?,
        action: Selector
    ) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        var x: CGFloat = 0
        var y: CGFloat = 0
        let rowSpacing: CGFloat = 10
        let chipSpacing: CGFloat = 10
        let maxWidth = UIScreen.main.bounds.width - 40
        var rowHeight: CGFloat = 0
        storage = []

        for option in options where !option.displayTitle.isEmpty {
            let chip = SuliJoyShareDraftChip(horizontalInset: horizontalTextInset)
            chip.setTitle(option.displayTitle, for: .normal)
            chip.accessibilityIdentifier = option.apiValue
            chip.addTarget(target, action: action, for: .touchUpInside)
            chip.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(chip)
            storage.append(chip)

            let chipSize = chip.intrinsicContentSize
            if x > 0, x + chipSize.width > maxWidth {
                x = 0
                y += rowHeight + rowSpacing
                rowHeight = 0
            }
            NSLayoutConstraint.activate([
                chip.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: x),
                chip.topAnchor.constraint(equalTo: container.topAnchor, constant: y),
            ])
            x += chipSize.width + chipSpacing
            rowHeight = max(rowHeight, chipSize.height)
            let selected = option.apiValue == selectedValue
            chip.setSelectedChip(selected)
        }

        let totalHeight = y + rowHeight
        container.heightAnchor.constraint(equalToConstant: max(totalHeight, 36)).isActive = true
        if let selectedChip = storage.first(where: { $0.accessibilityIdentifier == selectedValue }) {
            paint(buttons: storage, selected: selectedChip)
        }
        return container
    }

    static func make(
        titles: [String],
        selected: String,
        storage: inout [UIButton],
        target: Any?,
        action: Selector,
        allowsEmptySelection: Bool = false
    ) -> UIView {
        var row = 0
        var column = 0
        let grid = UIStackView()
        grid.axis = .vertical
        grid.spacing = 10
        var currentRow = makeHorizontalRow()
        grid.addArrangedSubview(currentRow)
        for title in titles where !title.isEmpty {
            let chip = SuliJoyShareDraftChip()
            chip.setTitle(title, for: .normal)
            chip.addTarget(target, action: action, for: .touchUpInside)
            storage.append(chip)
            let selectedMatch = !allowsEmptySelection && (title == selected)
            chip.setSelectedChip(selectedMatch)
            if column >= 2 {
                currentRow = makeHorizontalRow()
                grid.addArrangedSubview(currentRow)
                column = 0
                row += 1
            }
            currentRow.addArrangedSubview(chip)
            column += 1
        }
        if !allowsEmptySelection, let match = storage.first(where: { $0.title(for: .normal) == selected }) {
            paint(buttons: storage, selected: match)
        }
        return grid
    }

    static func makeHorizontalRow() -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 10
        row.distribution = .fillProportionally
        return row
    }

    static func paint(buttons: [UIButton], selected: UIButton?) {
        buttons.forEach { button in
            (button as? SuliJoyShareDraftChip)?.setSelectedChip(button === selected)
        }
    }
}

private final class SuliJoyShareDraftChip: UIButton {
    private let gradientRing = CAGradientLayer()
    private let innerShell = UIView()
    private let horizontalInset: CGFloat

    init(horizontalInset: CGFloat = SuliJoyShareDraftChipRow.horizontalTextInset) {
        self.horizontalInset = horizontalInset
        super.init(frame: .zero)
        titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        contentEdgeInsets = UIEdgeInsets(top: 8, left: horizontalInset, bottom: 8, right: horizontalInset)
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        gradientRing.colors = [
            UIColor(red: 0.58, green: 0.36, blue: 0.98, alpha: 1).cgColor,
            UIColor(red: 0.98, green: 0.45, blue: 0.72, alpha: 1).cgColor
        ]
        gradientRing.startPoint = CGPoint(x: 0, y: 0.5)
        gradientRing.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientRing, at: 0)
        innerShell.backgroundColor = .white
        innerShell.isUserInteractionEnabled = false
        insertSubview(innerShell, at: 0)
        setTitleColor(.suliInk, for: .normal)
        setSelectedChip(false)
    }

    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 44)) ?? .zero
        return CGSize(
            width: labelSize.width + horizontalInset * 2,
            height: max(36, labelSize.height + 16)
        )
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
