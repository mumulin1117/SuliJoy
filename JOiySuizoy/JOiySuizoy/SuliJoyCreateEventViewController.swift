import UIKit

final class SuliJoyCreateEventViewController: SuliJoyBaseIslandViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let navRow = UIView()
    private let photoRow = UIStackView()
    private let titleField = UITextField()
    private let titleCount = UILabel()
    private let descriptionView = UITextView()
    private let descriptionPlaceholder = UILabel()
    private let descriptionCount = UILabel()
    private let dateButton = SuliJoyEventInputButton(placeholder: "Fill in the event date")
    private let timeButton = SuliJoyEventInputButton(placeholder: "Fill in the event time")
    private let locationField = UITextField()
    private let groupSizeField = UITextField()
    private let priceField = UITextField()
    private let publishButton = SuliJoyGradientButton(title: "Publish Event")
    private var photoSlots: [SuliJoyEventPhotoSlotView] = []
    private var photoPicks: [SuliJoyReefEventPhotoPick] = []
    private var photoImages: [UIImage] = []
    private var selectedPhotoIndex = 0
    private var selectedType = "Style Party"
    private var selectedTheme = "Tropical Sunset"
    private var selectedDate: Date?
    private var selectedTime: Date?

    private let typeOptions = ["Style Party", "Photo Walk", "Beach Meetup", "Brunch Social", "Sunset Picnic", "Outdoor Social", "Island Market Tour"]
    private let themeOptions = ["Tropical Sunset", "Coastal Resort", "Ocean Blue & White", "Mediterranean Summer", "Tropical Prints", "Bohemian Island", "Vintage Resort", "Come as You Are"]
    private var typeButtons: [UIButton] = []
    private var themeButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        buildUI()
        registerKeyboardObservers()
        updateCounters()
    }

    @MainActor deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func buildUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.showsVerticalScrollIndicator = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        configureNav()
        configurePhotoSlots()
        let typeWrap = makeChoiceWrap(options: typeOptions, selected: selectedType, buttons: &typeButtons, action: #selector(selectType(_:)))
        let themeWrap = makeChoiceWrap(options: themeOptions, selected: selectedTheme, buttons: &themeButtons, action: #selector(selectTheme(_:)))
        let titleInput = makeTextFieldContainer(field: titleField, placeholder: "Enter the Event name", counter: titleCount)
        let descriptionInput = makeDescriptionContainer()
        let dateTimeStack = makeVerticalStack([dateButton, timeButton], spacing: 12)
        let locationInput = makeTextFieldContainer(field: locationField, placeholder: "Fill in the event location")
        let sizeInput = makeTextFieldContainer(field: groupSizeField, placeholder: "Fill in the number of participants in the event")
        let priceInput = makeTextFieldContainer(field: priceField, placeholder: "Fill in the activity fee")

        dateButton.addTarget(self, action: #selector(openDatePicker), for: .touchUpInside)
        timeButton.addTarget(self, action: #selector(openTimePicker), for: .touchUpInside)
        publishButton.translatesAutoresizingMaskIntoConstraints = false
        publishButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .black)
        publishButton.addTarget(self, action: #selector(publishEvent), for: .touchUpInside)

        let form = UIStackView()
        form.translatesAutoresizingMaskIntoConstraints = false
        form.axis = .vertical
        form.spacing = 18
        form.addArrangedSubview(makeSection(title: "Event Title", required: true, content: titleInput))
        form.addArrangedSubview(makeSection(title: "Event Type", required: false, content: typeWrap))
        form.addArrangedSubview(makeSection(title: "Dress Theme", required: false, content: themeWrap))
        form.addArrangedSubview(makeSection(title: "Event Description", required: true, content: descriptionInput))
        form.addArrangedSubview(makeSection(title: "Event Date/Time", required: true, content: dateTimeStack))
        form.addArrangedSubview(makeSection(title: "Event Location", required: false, content: locationInput))
        form.addArrangedSubview(makeSection(title: "Group Size", required: true, content: sizeInput))
        form.addArrangedSubview(makeSection(title: "Event Price", required: true, content: priceInput))

        [navRow, photoRow, form, publishButton].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),

            navRow.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 12),
            navRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            navRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            navRow.heightAnchor.constraint(equalToConstant: 44),

            photoRow.topAnchor.constraint(equalTo: navRow.bottomAnchor, constant: 26),
            photoRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            photoRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            photoRow.heightAnchor.constraint(equalTo: photoRow.widthAnchor, multiplier: 86.0 / 345.0),

            form.topAnchor.constraint(equalTo: photoRow.bottomAnchor, constant: 28),
            form.leadingAnchor.constraint(equalTo: photoRow.leadingAnchor),
            form.trailingAnchor.constraint(equalTo: photoRow.trailingAnchor),

            publishButton.topAnchor.constraint(equalTo: form.bottomAnchor, constant: 30),
            publishButton.leadingAnchor.constraint(equalTo: photoRow.leadingAnchor),
            publishButton.trailingAnchor.constraint(equalTo: photoRow.trailingAnchor),
            publishButton.heightAnchor.constraint(equalToConstant: 54),
            publishButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -28)
        ])

        [titleField, locationField, groupSizeField, priceField].forEach {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        }
        groupSizeField.keyboardType = .numberPad
        priceField.keyboardType = .numberPad
        descriptionView.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func configureNav() {
        navRow.translatesAutoresizingMaskIntoConstraints = false
        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.tintColor = .suliInk
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Create Events"
        title.font = UIFont.systemFont(ofSize: 25, weight: .black)
        title.textColor = .suliInk
        title.textAlignment = .center
        navRow.addSubview(back)
        navRow.addSubview(title)
        NSLayoutConstraint.activate([
            back.leadingAnchor.constraint(equalTo: navRow.leadingAnchor),
            back.centerYAnchor.constraint(equalTo: navRow.centerYAnchor),
            back.widthAnchor.constraint(equalToConstant: 38),
            back.heightAnchor.constraint(equalToConstant: 38),
            title.centerXAnchor.constraint(equalTo: navRow.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: navRow.centerYAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: back.trailingAnchor, constant: 12)
        ])
    }

    private func configurePhotoSlots() {
        photoRow.translatesAutoresizingMaskIntoConstraints = false
        photoRow.axis = .horizontal
        photoRow.spacing = 8
        photoRow.distribution = .fillEqually
        for index in 0..<3 {
            let slot = SuliJoyEventPhotoSlotView(index: index, isCover: index == 0)
            slot.onTap = { [weak self] slotIndex in
                self?.selectedPhotoIndex = slotIndex
                self?.presentPhotoChoice()
            }
            slot.onRemove = { [weak self] slotIndex in
                self?.removePhoto(at: slotIndex)
            }
            photoSlots.append(slot)
            photoRow.addArrangedSubview(slot)
        }
    }

    private func makeSection(title: String, required: Bool, content: UIView) -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        let label = UILabel()
        label.attributedText = sectionTitle(title, required: required)
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(content)
        return stack
    }

    private func sectionTitle(_ title: String, required: Bool) -> NSAttributedString {
        let result = NSMutableAttributedString(
            string: title,
            attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .black), .foregroundColor: UIColor.suliInk]
        )
        if required {
            result.append(NSAttributedString(
                string: "*",
                attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .black), .foregroundColor: UIColor(red: 0.92, green: 0.11, blue: 0.11, alpha: 1)]
            ))
        }
        return result
    }

    private func makeTextFieldContainer(field: UITextField, placeholder: String, counter: UILabel? = nil) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 14
        container.clipsToBounds = true
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = placeholder
        field.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        field.textColor = .suliInk
        field.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        container.addSubview(field)
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 56),
            field.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            field.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        if let counter {
            counter.translatesAutoresizingMaskIntoConstraints = false
            counter.textColor = UIColor(red: 0.66, green: 0.65, blue: 0.63, alpha: 1)
            counter.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            container.addSubview(counter)
            NSLayoutConstraint.activate([
                field.trailingAnchor.constraint(equalTo: counter.leadingAnchor, constant: -10),
                counter.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18),
                counter.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
        } else {
            field.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20).isActive = true
        }
        return container
    }

    private func makeDescriptionContainer() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 18
        container.clipsToBounds = true
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.backgroundColor = .clear
        descriptionView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        descriptionView.textColor = .suliInk
        descriptionView.textContainerInset = UIEdgeInsets(top: 18, left: 14, bottom: 30, right: 14)
        descriptionPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        descriptionPlaceholder.text = "Describe the activity, dress theme, and\noverall experience."
        descriptionPlaceholder.numberOfLines = 2
        descriptionPlaceholder.textColor = UIColor(red: 0.72, green: 0.71, blue: 0.70, alpha: 1)
        descriptionPlaceholder.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        descriptionCount.translatesAutoresizingMaskIntoConstraints = false
        descriptionCount.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        descriptionCount.textColor = UIColor(red: 0.66, green: 0.65, blue: 0.63, alpha: 1)
        [descriptionView, descriptionPlaceholder, descriptionCount].forEach { container.addSubview($0) }
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 154),
            descriptionView.topAnchor.constraint(equalTo: container.topAnchor),
            descriptionView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            descriptionView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            descriptionPlaceholder.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            descriptionPlaceholder.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 22),
            descriptionPlaceholder.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -22),
            descriptionCount.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18),
            descriptionCount.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14)
        ])
        return container
    }

    private func makeChoiceWrap(options: [String], selected: String, buttons: inout [UIButton], action: Selector) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 10
        container.translatesAutoresizingMaskIntoConstraints = false
        var row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8
        row.alignment = .leading
        container.addArrangedSubview(row)
        var usedWidth: CGFloat = 0
        for option in options {
            let estimated = max(96, CGFloat(option.count * 9 + 30))
            if usedWidth + estimated > 332, !row.arrangedSubviews.isEmpty {
                row = UIStackView()
                row.axis = .horizontal
                row.spacing = 8
                row.alignment = .leading
                container.addArrangedSubview(row)
                usedWidth = 0
            }
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.layer.cornerRadius = 19
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            button.addTarget(self, action: action, for: .touchUpInside)
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: estimated).isActive = true
            row.addArrangedSubview(button)
            buttons.append(button)
            usedWidth += estimated + 8
        }
        refreshChoiceButtons(buttons, selected: selected)
        return container
    }

    private func makeVerticalStack(_ views: [UIView], spacing: CGFloat) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .vertical
        stack.spacing = spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }

    private func refreshChoiceButtons(_ buttons: [UIButton], selected: String) {
        for button in buttons {
            let isSelected = button.title(for: .normal) == selected
            button.backgroundColor = .white
            button.setTitleColor(isSelected ? .suliInk : UIColor(red: 0.70, green: 0.69, blue: 0.67, alpha: 1), for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = isSelected ? UIColor(red: 1, green: 0.35, blue: 0.16, alpha: 1).cgColor : UIColor(red: 0.94, green: 0.92, blue: 0.86, alpha: 1).cgColor
        }
    }

    @objc private func selectType(_ sender: UIButton) {
        selectedType = sender.title(for: .normal) ?? selectedType
        refreshChoiceButtons(typeButtons, selected: selectedType)
    }

    @objc private func selectTheme(_ sender: UIButton) {
        selectedTheme = sender.title(for: .normal) ?? selectedTheme
        refreshChoiceButtons(themeButtons, selected: selectedTheme)
    }

    private func presentPhotoChoice() {
        dismissKeyboard()
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sheet.addAction(UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
                self?.openPicker(source: .camera)
            })
        }
        sheet.addAction(UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.openPicker(source: .photoLibrary)
        })
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        let source: UIView = photoSlots.indices.contains(selectedPhotoIndex) ? photoSlots[selectedPhotoIndex] : self.view
        sheet.popoverPresentationController?.sourceView = source
        sheet.popoverPresentationController?.sourceRect = source.bounds
        present(sheet, animated: true)
    }

    private func openPicker(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            showToast("Source unavailable.")
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
        guard let image, let path = savePhoto(image) else {
            showToast("Photo could not be saved.")
            return
        }
        let pick = SuliJoyReefEventPhotoPick(localPath: path, caption: selectedPhotoIndex == 0 ? "Event cover" : "Event photo")
        if selectedPhotoIndex < photoPicks.count {
            photoPicks[selectedPhotoIndex] = pick
            photoImages[selectedPhotoIndex] = image
        } else if photoPicks.count < 3 {
            photoPicks.append(pick)
            photoImages.append(image)
        }
        refreshPhotoSlots()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    private func removePhoto(at index: Int) {
        guard photoPicks.indices.contains(index) else { return }
        photoPicks.remove(at: index)
        photoImages.remove(at: index)
        refreshPhotoSlots()
    }

    private func refreshPhotoSlots() {
        for index in 0..<photoSlots.count {
            if photoImages.indices.contains(index) {
                photoSlots[index].setImage(photoImages[index])
            } else {
                photoSlots[index].setImage(nil)
            }
        }
    }

    private func savePhoto(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.86) else { return nil }
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("SuliJoyEventMedia", isDirectory: true)
        guard let directory else { return nil }
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let fileURL = directory.appendingPathComponent("tide_photo_\(UUID().uuidString).jpg")
        do {
            try data.write(to: fileURL, options: [.atomic])
            return fileURL.path
        } catch {
            return nil
        }
    }

    @objc private func openDatePicker() {
        presentPicker(mode: .date, title: "Choose event date") { [weak self] date in
            guard let self else { return }
            self.selectedDate = date
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            self.dateButton.setValue(formatter.string(from: date))
        }
    }

    @objc private func openTimePicker() {
        presentPicker(mode: .time, title: "Choose event time") { [weak self] date in
            guard let self else { return }
            self.selectedTime = date
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            self.timeButton.setValue(formatter.string(from: date))
        }
    }

    private func presentPicker(mode: UIDatePicker.Mode, title: String, completion: @escaping (Date) -> Void) {
        dismissKeyboard()
        let alert = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = mode
        picker.preferredDatePickerStyle = .wheels
        if mode == .date {
            picker.minimumDate = Date()
        }
        alert.view.addSubview(picker)
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 12),
            picker.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -12),
            picker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 44),
            picker.heightAnchor.constraint(equalToConstant: 190)
        ])
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Done", style: .default) { _ in completion(picker.date) })
        alert.popoverPresentationController?.sourceView = mode == .date ? dateButton : timeButton
        alert.popoverPresentationController?.sourceRect = (mode == .date ? dateButton : timeButton).bounds
        present(alert, animated: true)
    }

    @objc private func publishEvent() {
        dismissKeyboard()
        guard !photoPicks.isEmpty else { showToast("Please add a cover photo."); return }
        let title = (titleField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { showToast("Please enter an event title."); return }
        let description = descriptionView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !description.isEmpty else { showToast("Please enter an event description."); return }
        guard let selectedDate, let selectedTime else { showToast("Please choose event date and time."); return }
        guard let groupSize = Int(groupSizeField.text ?? ""), groupSize > 0 else {
            showToast("Please enter a valid group size.")
            return
        }
        guard let gemCost = Int(priceField.text ?? ""), gemCost >= 0 else {
            showToast("Please enter a valid event price.")
            return
        }
        let draft = SuliJoyTideDraftActivity(
            title: title,
            eventType: selectedType,
            dressTheme: selectedTheme,
            description: description,
            eventDate: selectedDate,
            eventTime: selectedTime,
            location: locationField.text ?? "",
            groupSize: groupSize,
            gemCost: gemCost,
            photoPicks: photoPicks
        )
        publishButton.isLoading = true
        publishButton.isEnabled = false
        SuliJoyCoveMockService.shared.publishTideActivity(draft: draft) { [weak self] result in
            guard let self else { return }
            self.publishButton.isLoading = false
            self.publishButton.isEnabled = true
            guard result.code == 200 else {
                self.showToast(result.message)
                return
            }
            self.showToast("Event published.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self.navigationController?.popToRootViewController(animated: false)
                self.tabBarController?.selectedIndex = 0
            }
        }
    }

    @objc private func textFieldChanged(_ sender: UITextField) {
        if sender === titleField, let text = sender.text, text.count > 20 {
            sender.text = String(text.prefix(20))
        }
        updateCounters()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === groupSizeField || textField === priceField {
            return string.isEmpty || string.allSatisfy(\.isNumber)
        }
        if textField === titleField {
            let current = textField.text ?? ""
            guard let textRange = Range(range, in: current) else { return true }
            return current.replacingCharacters(in: textRange, with: string).count <= 20
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        descriptionPlaceholder.isHidden = !textView.text.isEmpty
        if textView.text.count > 150 {
            textView.text = String(textView.text.prefix(150))
        }
        updateCounters()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let current = textView.text ?? ""
        guard let textRange = Range(range, in: current) else { return true }
        return current.replacingCharacters(in: textRange, with: text).count <= 150
    }

    private func updateCounters() {
        titleCount.text = "\(titleField.text?.count ?? 0)/20"
        descriptionCount.text = "\(descriptionView.text.count)/150"
    }

    private func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let inset = frame.height - view.safeAreaInsets.bottom + 18
        scrollView.contentInset.bottom = inset
        scrollView.verticalScrollIndicatorInsets.bottom = inset
    }

    @objc private func keyboardWillHide(_ note: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

private final class SuliJoyEventInputButton: UIButton {
    private let valueLabel = UILabel()
    private let placeholder: String

    init(placeholder: String) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        buildUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 14
        clipsToBounds = true
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.text = placeholder
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        valueLabel.textColor = UIColor(red: 0.68, green: 0.67, blue: 0.66, alpha: 1)
        valueLabel.isUserInteractionEnabled = false
        addSubview(valueLabel)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 52),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func setValue(_ value: String) {
        valueLabel.text = value
        valueLabel.textColor = .suliInk
    }
}

private final class SuliJoyEventPhotoSlotView: UIControl {
    var onTap: ((Int) -> Void)?
    var onRemove: ((Int) -> Void)?
    private let index: Int
    private let imageView = UIImageView()
    private let cameraView = UIImageView()
    private let coverBadge = UIImageView()
    private let coverText = UILabel()
    private let removeButton = UIButton(type: .system)

    init(index: Int, isCover: Bool) {
        self.index = index
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        buildUI(isCover: isCover)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildUI(isCover: Bool) {
        backgroundColor = .white
        layer.cornerRadius = 12
        clipsToBounds = true
        addTarget(self, action: #selector(open), for: .touchUpInside)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = true
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.image = UIImage(named: "sulijoy_event_create_camera_slot")?.withRenderingMode(.alwaysOriginal)
        cameraView.contentMode = .scaleAspectFit
        cameraView.isUserInteractionEnabled = false

        coverBadge.translatesAutoresizingMaskIntoConstraints = false
        coverBadge.image = UIImage(named: "sulijoy_event_create_cover_badge")
        coverBadge.isHidden = !isCover
        coverText.translatesAutoresizingMaskIntoConstraints = false
        coverText.text = "Cover"
        coverText.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        coverText.textColor = .white
        coverText.isHidden = !isCover

        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.setImage(UIImage(named: "sulijoy_post_media_remove_mark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        removeButton.isHidden = true
        removeButton.addTarget(self, action: #selector(remove), for: .touchUpInside)

        [imageView, cameraView, coverBadge, coverText, removeButton].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cameraView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cameraView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cameraView.widthAnchor.constraint(equalToConstant: 40),
            cameraView.heightAnchor.constraint(equalToConstant: 40),
            coverBadge.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            coverBadge.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            coverBadge.widthAnchor.constraint(equalToConstant: 52),
            coverBadge.heightAnchor.constraint(equalToConstant: 24),
            coverText.centerXAnchor.constraint(equalTo: coverBadge.centerXAnchor),
            coverText.centerYAnchor.constraint(equalTo: coverBadge.centerYAnchor),
            removeButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            removeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            removeButton.widthAnchor.constraint(equalToConstant: 26),
            removeButton.heightAnchor.constraint(equalToConstant: 26)
        ])
    }

    func setImage(_ image: UIImage?) {
        imageView.image = image
        imageView.isHidden = image == nil
        cameraView.isHidden = image != nil
        removeButton.isHidden = image == nil
    }

    @objc private func open() {
        onTap?(index)
    }

    @objc private func remove() {
        onRemove?(index)
    }
}
