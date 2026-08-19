import UIKit

final class SuliJoyTideCurationDraftController: SuliJoyTropicCanvasController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    private let shoreDraftScrollCanvas = UIScrollView()
    private let shoreDraftDeck = UIView()
    private let shoreDraftNavRail = UIView()
    private let coverPhotoRail = UIStackView()
    private let styleTitleField = UITextField()
    private let styleTitleMeter = UILabel()
    private let shoreBriefTextView = UITextView()
    private let shoreBriefGhostGlyph = UILabel()
    private let shoreBriefMeter = UILabel()
    private let shoreDateCapsule = SuliJoyTideCalendarCapsuleButton(shorePlaceholderText: "Fill in the event date")
    private let shoreTimeCapsule = SuliJoyTideCalendarCapsuleButton(shorePlaceholderText: "Fill in the event time")
    private let shorePlaceField = UITextField()
    private let shoreCrewField = UITextField()
    private let entryPearlField = UITextField()
    private let shorePublishControl = SuliJoyGradientButton(reefHeadline: "PNuVbglUiNsfhd uENvOevnjtX".suliJoyPalmUnfurled)
    private var coverSlotControls: [SuliJoyTideCoverSlotControl] = []
    private var coverReefPicks: [SuliJoyReefEventPhotoPick] = []
    private var coverPreviewImages: [UIImage] = []
    private var activeCoverSlotIndex = 0
    private var chosenShorelineStyle = "Style Party"
    private var chosenResortTheme = "Tropical Sunset"
    private var chosenShoreDate: Date?
    private var chosenShoreTime: Date?

    private let shorelineStyleOptions = ["Style Party", "Photo Walk", "Beach Meetup", "Brunch Social", "Sunset Picnic", "Outdoor Social", "Island Market Tour"]
    private let resortThemeOptions = ["Tropical Sunset", "Coastal Resort", "Ocean Blue & White", "Mediterranean Summer", "Tropical Prints", "Bohemian Island", "Vintage Resort", "Come as You Are"]
    private var shorelineStyleControls: [UIButton] = []
    private var resortThemeControls: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        raiseCurationDraftScene()
        registerDraftKeyboardObservers()
        refreshDraftCounters()
    }

    @MainActor deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func raiseCurationDraftScene() {
        shoreDraftScrollCanvas.translatesAutoresizingMaskIntoConstraints = false
        shoreDraftScrollCanvas.keyboardDismissMode = .interactive
        shoreDraftScrollCanvas.showsVerticalScrollIndicator = false
        shoreDraftDeck.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(shoreDraftScrollCanvas)
        shoreDraftScrollCanvas.addSubview(shoreDraftDeck)

        anchorCurationDraftNav()
        anchorCoverPhotoSlots()
        let typeWrap = makeShorelineChoiceWrap(options: shorelineStyleOptions, selected: chosenShorelineStyle, buttons: &shorelineStyleControls, action: #selector(chooseShorelineStyle(_:)))
        let themeWrap = makeShorelineChoiceWrap(options: resortThemeOptions, selected: chosenResortTheme, buttons: &resortThemeControls, action: #selector(chooseResortTheme(_:)))
        let titleInput = makeCurationTextShell(field: styleTitleField, shorePlaceholderText: "Enter the Event name", counter: styleTitleMeter)
        let descriptionInput = makeCurationBriefShell()
        let dateTimeStack = makeResortVerticalStack([shoreDateCapsule, shoreTimeCapsule], spacing: 12)
        let shorePlaceInput = makeCurationTextShell(field: shorePlaceField, shorePlaceholderText: "Fill in the event " + "loc" + "ation")
        let sizeInput = makeCurationTextShell(field: shoreCrewField, shorePlaceholderText: "Fill in the number of participants in the event")
        let pearlInput = makeCurationTextShell(field: entryPearlField, shorePlaceholderText: "Fill in the activity fee")

        shoreDateCapsule.addTarget(self, action: #selector(openShoreDateWheel), for: .touchUpInside)
        shoreTimeCapsule.addTarget(self, action: #selector(openShoreTimeWheel), for: .touchUpInside)
        shorePublishControl.translatesAutoresizingMaskIntoConstraints = false
        shorePublishControl.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .black)
        shorePublishControl.addTarget(self, action: #selector(publishShorelineDraft), for: .touchUpInside)

        let curationForm = UIStackView()
        curationForm.translatesAutoresizingMaskIntoConstraints = false
        curationForm.axis = .vertical
        curationForm.spacing = 18
        curationForm.addArrangedSubview(makeCurationSection(reefHeadline: "Event Title", required: true, content: titleInput))
        curationForm.addArrangedSubview(makeCurationSection(reefHeadline: "Event Type", required: false, content: typeWrap))
        curationForm.addArrangedSubview(makeCurationSection(reefHeadline: "Dress Theme", required: false, content: themeWrap))
        curationForm.addArrangedSubview(makeCurationSection(reefHeadline: "Event Description", required: true, content: descriptionInput))
        curationForm.addArrangedSubview(makeCurationSection(reefHeadline: "Event Date/Time", required: true, content: dateTimeStack))
        curationForm.addArrangedSubview(makeCurationSection(reefHeadline: "Event " + "Loc" + "ation", required: false, content: shorePlaceInput))
        curationForm.addArrangedSubview(makeCurationSection(reefHeadline: "Group Size", required: true, content: sizeInput))
        curationForm.addArrangedSubview(makeCurationSection(reefHeadline: "Event " + "Pr" + "ice", required: true, content: pearlInput))

        [shoreDraftNavRail, coverPhotoRail, curationForm, shorePublishControl].forEach { shoreDraftDeck.addSubview($0) }

        NSLayoutConstraint.activate([
            shoreDraftScrollCanvas.topAnchor.constraint(equalTo: view.topAnchor),
            shoreDraftScrollCanvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoreDraftScrollCanvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoreDraftScrollCanvas.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            shoreDraftDeck.topAnchor.constraint(equalTo: shoreDraftScrollCanvas.contentLayoutGuide.topAnchor),
            shoreDraftDeck.leadingAnchor.constraint(equalTo: shoreDraftScrollCanvas.contentLayoutGuide.leadingAnchor),
            shoreDraftDeck.trailingAnchor.constraint(equalTo: shoreDraftScrollCanvas.contentLayoutGuide.trailingAnchor),
            shoreDraftDeck.bottomAnchor.constraint(equalTo: shoreDraftScrollCanvas.contentLayoutGuide.bottomAnchor),
            shoreDraftDeck.widthAnchor.constraint(equalTo: shoreDraftScrollCanvas.frameLayoutGuide.widthAnchor),
            shoreDraftDeck.heightAnchor.constraint(greaterThanOrEqualTo: shoreDraftScrollCanvas.frameLayoutGuide.heightAnchor),

            shoreDraftNavRail.topAnchor.constraint(equalTo: shoreDraftDeck.safeAreaLayoutGuide.topAnchor, constant: 12),
            shoreDraftNavRail.leadingAnchor.constraint(equalTo: shoreDraftDeck.leadingAnchor, constant: 20),
            shoreDraftNavRail.trailingAnchor.constraint(equalTo: shoreDraftDeck.trailingAnchor, constant: -20),
            shoreDraftNavRail.heightAnchor.constraint(equalToConstant: 44),

            coverPhotoRail.topAnchor.constraint(equalTo: shoreDraftNavRail.bottomAnchor, constant: 26),
            coverPhotoRail.leadingAnchor.constraint(equalTo: shoreDraftDeck.leadingAnchor, constant: 20),
            coverPhotoRail.trailingAnchor.constraint(equalTo: shoreDraftDeck.trailingAnchor, constant: -20),
            coverPhotoRail.heightAnchor.constraint(equalTo: coverPhotoRail.widthAnchor, multiplier: 86.0 / 345.0),

            curationForm.topAnchor.constraint(equalTo: coverPhotoRail.bottomAnchor, constant: 28),
            curationForm.leadingAnchor.constraint(equalTo: coverPhotoRail.leadingAnchor),
            curationForm.trailingAnchor.constraint(equalTo: coverPhotoRail.trailingAnchor),

            shorePublishControl.topAnchor.constraint(equalTo: curationForm.bottomAnchor, constant: 30),
            shorePublishControl.leadingAnchor.constraint(equalTo: coverPhotoRail.leadingAnchor),
            shorePublishControl.trailingAnchor.constraint(equalTo: coverPhotoRail.trailingAnchor),
            shorePublishControl.heightAnchor.constraint(equalToConstant: 54),
            shorePublishControl.bottomAnchor.constraint(equalTo: shoreDraftDeck.safeAreaLayoutGuide.bottomAnchor, constant: -28)
        ])

        [styleTitleField, shorePlaceField, shoreCrewField, entryPearlField].forEach {
            $0.delegate = self
            $0.addTarget(self, action: #selector(shoreDraftTextFieldChanged(_:)), for: .editingChanged)
        }
        shoreCrewField.keyboardType = .numberPad
        entryPearlField.keyboardType = .numberPad
        shoreBriefTextView.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(foldDraftKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func anchorCurationDraftNav() {
        shoreDraftNavRail.translatesAutoresizingMaskIntoConstraints = false
        let shoreReturnControl = UIButton(type: .system)
        shoreReturnControl.translatesAutoresizingMaskIntoConstraints = false
        shoreReturnControl.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        shoreReturnControl.tintColor = .suliInk
        shoreReturnControl.addTarget(self, action: #selector(driftBackFromCurationDraft), for: .touchUpInside)
        let curationHeadlineGlyph = UILabel()
        curationHeadlineGlyph.translatesAutoresizingMaskIntoConstraints = false
        curationHeadlineGlyph.text = "CfrDeIabtFeu dEovsehnttHsh".suliJoyPalmUnfurled
        curationHeadlineGlyph.font = UIFont.systemFont(ofSize: 25, weight: .black)
        curationHeadlineGlyph.textColor = .suliInk
        curationHeadlineGlyph.textAlignment = .center
        shoreDraftNavRail.addSubview(shoreReturnControl)
        shoreDraftNavRail.addSubview(curationHeadlineGlyph)
        NSLayoutConstraint.activate([
            shoreReturnControl.leadingAnchor.constraint(equalTo: shoreDraftNavRail.leadingAnchor),
            shoreReturnControl.centerYAnchor.constraint(equalTo: shoreDraftNavRail.centerYAnchor),
            shoreReturnControl.widthAnchor.constraint(equalToConstant: 38),
            shoreReturnControl.heightAnchor.constraint(equalToConstant: 38),
            curationHeadlineGlyph.centerXAnchor.constraint(equalTo: shoreDraftNavRail.centerXAnchor),
            curationHeadlineGlyph.centerYAnchor.constraint(equalTo: shoreDraftNavRail.centerYAnchor),
            curationHeadlineGlyph.leadingAnchor.constraint(greaterThanOrEqualTo: shoreReturnControl.trailingAnchor, constant: 12)
        ])
    }

    private func anchorCoverPhotoSlots() {
        coverPhotoRail.translatesAutoresizingMaskIntoConstraints = false
        coverPhotoRail.axis = .horizontal
        coverPhotoRail.spacing = 8
        coverPhotoRail.distribution = .fillEqually
        for reefSlotIndex in 0..<3 {
            let coverSlot = SuliJoyTideCoverSlotControl(index: reefSlotIndex, isCover: reefSlotIndex == 0)
            coverSlot.onCoverSlotTap = { [weak self] selectedSlotIndex in
                self?.activeCoverSlotIndex = selectedSlotIndex
                self?.suliJoyCoastalStyle()
            }
            coverSlot.onCoverSlotRemove = { [weak self] selectedSlotIndex in
                self?.removeCoverPhoto(at: selectedSlotIndex)
            }
            coverSlotControls.append(coverSlot)
            coverPhotoRail.addArrangedSubview(coverSlot)
        }
    }

    private func makeCurationSection(reefHeadline: String, required: Bool, content: UIView) -> UIView {
        let shorelineSectionStack = UIStackView()
        shorelineSectionStack.axis = .vertical
        shorelineSectionStack.spacing = 10
        shorelineSectionStack.translatesAutoresizingMaskIntoConstraints = false
        let sectionHeadlineGlyph = UILabel()
        sectionHeadlineGlyph.attributedText = makeCurationSectionTitle(reefHeadline, required: required)
        shorelineSectionStack.addArrangedSubview(sectionHeadlineGlyph)
        shorelineSectionStack.addArrangedSubview(content)
        return shorelineSectionStack
    }

    private func makeCurationSectionTitle(_ reefHeadline: String, required: Bool) -> NSAttributedString {
        let shorelineHeadlineText = NSMutableAttributedString(
            string: reefHeadline,
            attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .black), .foregroundColor: UIColor.suliInk]
        )
        if required {
            shorelineHeadlineText.append(NSAttributedString(
                string: "*",
                attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .black), .foregroundColor: UIColor(red: 0.92, green: 0.11, blue: 0.11, alpha: 1)]
            ))
        }
        return shorelineHeadlineText
    }

    private func makeCurationTextShell(field: UITextField, shorePlaceholderText: String, counter: UILabel? = nil) -> UIView {
        let shorelineInputShell = UIView()
        shorelineInputShell.translatesAutoresizingMaskIntoConstraints = false
        shorelineInputShell.backgroundColor = .white
        shorelineInputShell.layer.cornerRadius = 14
        shorelineInputShell.clipsToBounds = true
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = shorePlaceholderText
        field.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        field.textColor = .suliInk
        field.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        shorelineInputShell.addSubview(field)
        NSLayoutConstraint.activate([
            shorelineInputShell.heightAnchor.constraint(equalToConstant: 56),
            field.leadingAnchor.constraint(equalTo: shorelineInputShell.leadingAnchor, constant: 20),
            field.centerYAnchor.constraint(equalTo: shorelineInputShell.centerYAnchor)
        ])
        if let counter {
            counter.translatesAutoresizingMaskIntoConstraints = false
            counter.textColor = UIColor(red: 0.66, green: 0.65, blue: 0.63, alpha: 1)
            counter.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            shorelineInputShell.addSubview(counter)
            NSLayoutConstraint.activate([
                field.trailingAnchor.constraint(equalTo: counter.leadingAnchor, constant: -10),
                counter.trailingAnchor.constraint(equalTo: shorelineInputShell.trailingAnchor, constant: -18),
                counter.centerYAnchor.constraint(equalTo: shorelineInputShell.centerYAnchor)
            ])
        } else {
            field.trailingAnchor.constraint(equalTo: shorelineInputShell.trailingAnchor, constant: -20).isActive = true
        }
        return shorelineInputShell
    }

    private func makeCurationBriefShell() -> UIView {
        let shorelineBriefShell = UIView()
        shorelineBriefShell.translatesAutoresizingMaskIntoConstraints = false
        shorelineBriefShell.backgroundColor = .white
        shorelineBriefShell.layer.cornerRadius = 18
        shorelineBriefShell.clipsToBounds = true
        shoreBriefTextView.translatesAutoresizingMaskIntoConstraints = false
        shoreBriefTextView.backgroundColor = .clear
        shoreBriefTextView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        shoreBriefTextView.textColor = .suliInk
        shoreBriefTextView.textContainerInset = UIEdgeInsets(top: 18, left: 14, bottom: 30, right: 14)
        shoreBriefGhostGlyph.translatesAutoresizingMaskIntoConstraints = false
        shoreBriefGhostGlyph.text = "Describe the activity, dress theme, and\noverall experience."
        shoreBriefGhostGlyph.numberOfLines = 2
        shoreBriefGhostGlyph.textColor = UIColor(red: 0.72, green: 0.71, blue: 0.70, alpha: 1)
        shoreBriefGhostGlyph.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        shoreBriefMeter.translatesAutoresizingMaskIntoConstraints = false
        shoreBriefMeter.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        shoreBriefMeter.textColor = UIColor(red: 0.66, green: 0.65, blue: 0.63, alpha: 1)
        [shoreBriefTextView, shoreBriefGhostGlyph, shoreBriefMeter].forEach { shorelineBriefShell.addSubview($0) }
        NSLayoutConstraint.activate([
            shorelineBriefShell.heightAnchor.constraint(equalToConstant: 154),
            shoreBriefTextView.topAnchor.constraint(equalTo: shorelineBriefShell.topAnchor),
            shoreBriefTextView.leadingAnchor.constraint(equalTo: shorelineBriefShell.leadingAnchor),
            shoreBriefTextView.trailingAnchor.constraint(equalTo: shorelineBriefShell.trailingAnchor),
            shoreBriefTextView.bottomAnchor.constraint(equalTo: shorelineBriefShell.bottomAnchor),
            shoreBriefGhostGlyph.topAnchor.constraint(equalTo: shorelineBriefShell.topAnchor, constant: 20),
            shoreBriefGhostGlyph.leadingAnchor.constraint(equalTo: shorelineBriefShell.leadingAnchor, constant: 22),
            shoreBriefGhostGlyph.trailingAnchor.constraint(equalTo: shorelineBriefShell.trailingAnchor, constant: -22),
            shoreBriefMeter.trailingAnchor.constraint(equalTo: shorelineBriefShell.trailingAnchor, constant: -18),
            shoreBriefMeter.bottomAnchor.constraint(equalTo: shorelineBriefShell.bottomAnchor, constant: -14)
        ])
        return shorelineBriefShell
    }

    private func makeShorelineChoiceWrap(options: [String], selected: String, buttons: inout [UIButton], action: Selector) -> UIView {
        let choiceLagoonStack = UIStackView()
        choiceLagoonStack.axis = .vertical
        choiceLagoonStack.spacing = 10
        choiceLagoonStack.translatesAutoresizingMaskIntoConstraints = false
        var shorelineOptionRail = makeCurationChoiceRail()
        choiceLagoonStack.addArrangedSubview(shorelineOptionRail)
        var occupiedRailWidth: CGFloat = 0
        for optionText in options {
            let optionWidth = max(96, CGFloat(optionText.count * 9 + 30))
            if occupiedRailWidth + optionWidth > 332, !shorelineOptionRail.arrangedSubviews.isEmpty {
                shorelineOptionRail = makeCurationChoiceRail()
                choiceLagoonStack.addArrangedSubview(shorelineOptionRail)
                occupiedRailWidth = 0
            }
            let optionControl = makeCurationChoiceControl(optionText, width: optionWidth, action: action)
            shorelineOptionRail.addArrangedSubview(optionControl)
            buttons.append(optionControl)
            occupiedRailWidth += optionWidth + 8
        }
        refreshCurationChoiceControls(buttons, selected: selected)
        return choiceLagoonStack
    }

    private func makeCurationChoiceRail() -> UIStackView {
        let shorelineOptionRail = UIStackView()
        shorelineOptionRail.axis = .horizontal
        shorelineOptionRail.spacing = 8
        shorelineOptionRail.alignment = .leading
        return shorelineOptionRail
    }

    private func makeCurationChoiceControl(_ optionText: String, width optionWidth: CGFloat, action: Selector) -> UIButton {
        let optionControl = UIButton(type: .system)
        optionControl.setTitle(optionText, for: .normal)
        optionControl.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        optionControl.layer.cornerRadius = 19
        optionControl.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        optionControl.addTarget(self, action: action, for: .touchUpInside)
        optionControl.widthAnchor.constraint(greaterThanOrEqualToConstant: optionWidth).isActive = true
        return optionControl
    }

    private func makeResortVerticalStack(_ shorelinePieces: [UIView], spacing: CGFloat) -> UIStackView {
        let resortStack = UIStackView(arrangedSubviews: shorelinePieces)
        resortStack.axis = .vertical
        resortStack.spacing = spacing
        resortStack.translatesAutoresizingMaskIntoConstraints = false
        return resortStack
    }

    private func refreshCurationChoiceControls(_ optionControls: [UIButton], selected: String) {
        for optionControl in optionControls {
            let isSelected = optionControl.title(for: .normal) == selected
            optionControl.backgroundColor = .white
            optionControl.setTitleColor(isSelected ? .suliInk : UIColor(red: 0.70, green: 0.69, blue: 0.67, alpha: 1), for: .normal)
            optionControl.layer.borderWidth = 1
            optionControl.layer.borderColor = isSelected ? UIColor(red: 1, green: 0.35, blue: 0.16, alpha: 1).cgColor : UIColor(red: 0.94, green: 0.92, blue: 0.86, alpha: 1).cgColor
        }
    }

    @objc private func chooseShorelineStyle(_ sender: UIButton) {
        chosenShorelineStyle = sender.title(for: .normal) ?? chosenShorelineStyle
        refreshCurationChoiceControls(shorelineStyleControls, selected: chosenShorelineStyle)
    }

    @objc private func chooseResortTheme(_ sender: UIButton) {
        chosenResortTheme = sender.title(for: .normal) ?? chosenResortTheme
        refreshCurationChoiceControls(resortThemeControls, selected: chosenResortTheme)
    }

    private func suliJoyCoastalStyle() {
        foldDraftKeyboard()
        let coverChoiceSheet = UIAlertController(suliJoyReefTitle: nil, reefStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            coverChoiceSheet.addAction(UIAlertAction(reefHeadline: "TdaZkKeS APThkoOtqop".suliJoyPalmUnfurled, style: .default) { [weak self] _ in
                self?.openCoverImagePicker(source: .camera)
            })
        }
        coverChoiceSheet.addAction(UIAlertAction(reefHeadline: "CchwoDofsVeZ EfZrsoImC ELciybsraajrAyz".suliJoyPalmUnfurled, style: .default) { [weak self] _ in
            self?.openCoverImagePicker(source: .photoLibrary)
        })
        coverChoiceSheet.addAction(UIAlertAction(reefHeadline: "CCaqndcaeqlP".suliJoyPalmUnfurled, style: .cancel))
        let coverAnchor: UIView = coverSlotControls.indices.contains(activeCoverSlotIndex) ? coverSlotControls[activeCoverSlotIndex] : self.view
        coverChoiceSheet.popoverPresentationController?.sourceView = coverAnchor
        coverChoiceSheet.popoverPresentationController?.sourceRect = coverAnchor.bounds
        present(coverChoiceSheet, animated: true)
    }

    private func openCoverImagePicker(source reefSource: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(reefSource) else {
            showLagoonToast("SjooucrAcneY suHnTaOvCatiplVasbKlMeq.b".suliJoyPalmUnfurled)
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
            showLagoonToast("PahSoctcoC xcWoGualMdj xnlortX jbHeZ ssRaOvAebdM.R".suliJoyPalmUnfurled)
            return
        }
        let reefPick = SuliJoyReefEventPhotoPick(reefSandboxPath: shorelinePath, hibiscusShade: activeCoverSlotIndex == 0 ? "EnvEeQnhtl YctomvPeXrn".suliJoyPalmUnfurled : "EkvQeFnotb KpzhPoJteoN".suliJoyPalmUnfurled)
        if activeCoverSlotIndex < coverReefPicks.count {
            coverReefPicks[activeCoverSlotIndex] = reefPick
            coverPreviewImages[activeCoverSlotIndex] = coverImage
        } else if coverReefPicks.count < 3 {
            coverReefPicks.append(reefPick)
            coverPreviewImages.append(coverImage)
        }
        refreshCoverPhotoSlots()
    }

    func imagePickerControllerDidCancel(_ coverPicker: UIImagePickerController) {
        coverPicker.dismiss(animated: true)
    }

    private func removeCoverPhoto(at index: Int) {
        guard coverReefPicks.indices.contains(index) else { return }
        coverReefPicks.remove(at: index)
        coverPreviewImages.remove(at: index)
        refreshCoverPhotoSlots()
    }

    private func refreshCoverPhotoSlots() {
        for index in 0..<coverSlotControls.count {
            if coverPreviewImages.indices.contains(index) {
                coverSlotControls[index].setImage(coverPreviewImages[index])
            } else {
                coverSlotControls[index].setImage(nil)
            }
        }
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

    @objc private func openShoreDateWheel() {
        presentShoreCalendarWheel(mode: .date, reefHeadline: "Choose event date") { [weak self] date in
            guard let self else { return }
            self.chosenShoreDate = date
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            self.shoreDateCapsule.setShoreValue(formatter.string(from: date))
        }
    }

    @objc private func openShoreTimeWheel() {
        presentShoreCalendarWheel(mode: .time, reefHeadline: "Choose event time") { [weak self] date in
            guard let self else { return }
            self.chosenShoreTime = date
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            self.shoreTimeCapsule.setShoreValue(formatter.string(from: date))
        }
    }

    private func presentShoreCalendarWheel(mode: UIDatePicker.Mode, reefHeadline: String, completion: @escaping (Date) -> Void) {
        foldDraftKeyboard()
        let calendarSheet = UIAlertController(suliJoyReefTitle: reefHeadline, reefBody: "\n\n\n\n\n\n\n\n", reefStyle: .actionSheet)
        let shorelineWheel = UIDatePicker()
        shorelineWheel.translatesAutoresizingMaskIntoConstraints = false
        shorelineWheel.datePickerMode = mode
        shorelineWheel.preferredDatePickerStyle = .wheels
        if mode == .date {
            shorelineWheel.minimumDate = Date()
        }
        calendarSheet.view.addSubview(shorelineWheel)
        NSLayoutConstraint.activate([
            shorelineWheel.leadingAnchor.constraint(equalTo: calendarSheet.view.leadingAnchor, constant: 12),
            shorelineWheel.trailingAnchor.constraint(equalTo: calendarSheet.view.trailingAnchor, constant: -12),
            shorelineWheel.topAnchor.constraint(equalTo: calendarSheet.view.topAnchor, constant: 44),
            shorelineWheel.heightAnchor.constraint(equalToConstant: 190)
        ])
        calendarSheet.addAction(UIAlertAction(reefHeadline: "CpaSnCcXehlU".suliJoyPalmUnfurled, style: .cancel))
        calendarSheet.addAction(UIAlertAction(reefHeadline: "Dhoynyel".suliJoyPalmUnfurled, style: .default) { _ in completion(shorelineWheel.date) })
        calendarSheet.popoverPresentationController?.sourceView = mode == .date ? shoreDateCapsule : shoreTimeCapsule
        calendarSheet.popoverPresentationController?.sourceRect = (mode == .date ? shoreDateCapsule : shoreTimeCapsule).bounds
        present(calendarSheet, animated: true)
    }

    @objc private func publishShorelineDraft() {
        foldDraftKeyboard()
        guard !coverReefPicks.isEmpty else { showLagoonToast("PildeyaLsYea KaXdYdK KaW TcZoqvpeurm npmhjoktuop.l".suliJoyPalmUnfurled); return }
        let shorelineTitle = (styleTitleField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !shorelineTitle.isEmpty else { showLagoonToast("PklsegaEsLeC QexndtveHrS pabnP veevoeQnZte WtciutplPej.y".suliJoyPalmUnfurled); return }
        let shorelineBrief = shoreBriefTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !shorelineBrief.isEmpty else { showLagoonToast("PmlDeEaesTeG GeRnNtKeJrt OaPnh veIvTebnrtd hdaecsFcQrCixpdtliFonnh.D".suliJoyPalmUnfurled); return }
        guard let chosenShoreDate, let chosenShoreTime else { showLagoonToast("PglUeGahsmeC wcXhcoroSsoeQ lejvLelnCto xdeaptgel eadnqdQ YtyidmHeR.z".suliJoyPalmUnfurled); return }
        guard let crewLimit = Int(shoreCrewField.text ?? ""), crewLimit > 0 else {
            showLagoonToast("PhlQeVarspeb reFnftiePrs baZ bvgaWlTiOdf vgMrDojutpI zsxikzSeh.X".suliJoyPalmUnfurled)
            return
        }
        guard let pearlNeed = Int(entryPearlField.text ?? ""), pearlNeed >= 0 else {
            showLagoonToast("PBldekalsueL meanrtdeury WaH XvFavlcikdT rejvXernwtf e".suliJoyPalmUnfurled + "pVrK".suliJoyPalmUnfurled + "idcyex.h".suliJoyPalmUnfurled)
            return
        }
        let tideDraft = SuliJoyTideDraftActivity(
            tideTitleLine: shorelineTitle,
            tideStyleKind: chosenShorelineStyle,
            wardrobeThemeLine: chosenResortTheme,
            shoreBriefLine: shorelineBrief,
            tideDay: chosenShoreDate,
            tideClock: chosenShoreTime,
            shoreSpotLine: shorePlaceField.text ?? "",
            tideCrewLimit: crewLimit,
            pearlNeed: pearlNeed,
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
            self.showLagoonToast("EYvoefnttJ rptutbklFiJsbhzeedU.y".suliJoyPalmUnfurled)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self.navigationController?.popToRootViewController(animated: false)
                self.tabBarController?.selectedIndex = 0
            }
        }
    }

    @objc private func shoreDraftTextFieldChanged(_ sender: UITextField) {
        if sender === styleTitleField, let text = sender.text, text.count > 20 {
            sender.text = String(text.prefix(20))
        }
        refreshDraftCounters()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField === shoreCrewField || textField === entryPearlField {
            return string.isEmpty || string.allSatisfy(\.isNumber)
        }
        if textField === styleTitleField {
            let current = textField.text ?? ""
            guard let textRange = Range(range, in: current) else { return true }
            return current.replacingCharacters(in: textRange, with: string).count <= 20
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        shoreBriefGhostGlyph.isHidden = !textView.text.isEmpty
        if textView.text.count > 150 {
            textView.text = String(textView.text.prefix(150))
        }
        refreshDraftCounters()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let current = textView.text ?? ""
        guard let textRange = Range(range, in: current) else { return true }
        return current.replacingCharacters(in: textRange, with: text).count <= 150
    }

    private func refreshDraftCounters() {
        styleTitleMeter.text = "\(styleTitleField.text?.count ?? 0)/20"
        shoreBriefMeter.text = "\(shoreBriefTextView.text.count)/150"
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

private final class SuliJoyTideCalendarCapsuleButton: UIButton {
    private let shoreValueGlyph = UILabel()
    private let shorePlaceholderText: String

    init(shorePlaceholderText: String) {
        self.shorePlaceholderText = shorePlaceholderText
        super.init(frame: .zero)
        raiseCurationDraftScene()
    }

    required init?(coder: NSCoder) {
        fatalError("ixnEiFtP(ScEoHdneKrk:L)a uhWaBss KnjoxtO fbzeLeqnw ViQmwpRlzegmZeAnhtqeddD".suliJoyPalmUnfurled)
    }

    private func raiseCurationDraftScene() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 14
        clipsToBounds = true
        shoreValueGlyph.translatesAutoresizingMaskIntoConstraints = false
        shoreValueGlyph.text = shorePlaceholderText
        shoreValueGlyph.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        shoreValueGlyph.textColor = UIColor(red: 0.68, green: 0.67, blue: 0.66, alpha: 1)
        shoreValueGlyph.isUserInteractionEnabled = false
        addSubview(shoreValueGlyph)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 52),
            shoreValueGlyph.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            shoreValueGlyph.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            shoreValueGlyph.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func setShoreValue(_ value: String) {
        shoreValueGlyph.text = value
        shoreValueGlyph.textColor = .suliInk
    }
}

private final class SuliJoyTideCoverSlotControl: UIControl {
    var onCoverSlotTap: ((Int) -> Void)?
    var onCoverSlotRemove: ((Int) -> Void)?
    private let reefSlotIndex: Int
    private let coverImageView = UIImageView()
    private let cameraGlyphView = UIImageView()
    private let coverBadgeView = UIImageView()
    private let coverTextGlyph = UILabel()
    private let removeCoverControl = UIButton(type: .system)

    init(index: Int, isCover: Bool) {
        self.reefSlotIndex = index
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        raiseCurationDraftScene(isCover: isCover)
    }

    required init?(coder: NSCoder) {
        fatalError("irnRittM(acuoldFedrR:B)F RhOaJsb tnDortt zbZeqeNna DiLmQpKlNehmeejnNtMeMdq".suliJoyPalmUnfurled)
    }

    private func raiseCurationDraftScene(isCover: Bool) {
        backgroundColor = .white
        layer.cornerRadius = 12
        clipsToBounds = true
        addTarget(self, action: #selector(openCoverReefPicker), for: .touchUpInside)

        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        coverImageView.isHidden = true
        cameraGlyphView.translatesAutoresizingMaskIntoConstraints = false
        cameraGlyphView.image = UIImage(named: "sulijoy_event_create_camera_slot")?.withRenderingMode(.alwaysOriginal)
        cameraGlyphView.contentMode = .scaleAspectFit
        cameraGlyphView.isUserInteractionEnabled = false

        coverBadgeView.translatesAutoresizingMaskIntoConstraints = false
        coverBadgeView.image = UIImage(named: "sulijoy_event_create_cover_badge")
        coverBadgeView.isHidden = !isCover
        coverTextGlyph.translatesAutoresizingMaskIntoConstraints = false
        coverTextGlyph.text = "CIoBvHeprJ".suliJoyPalmUnfurled
        coverTextGlyph.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        coverTextGlyph.textColor = .white
        coverTextGlyph.isHidden = !isCover

        removeCoverControl.translatesAutoresizingMaskIntoConstraints = false
        removeCoverControl.setImage(UIImage(named: "sulijoy_post_media_remove_mark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        removeCoverControl.isHidden = true
        removeCoverControl.addTarget(self, action: #selector(clearCoverReefPick), for: .touchUpInside)

        [coverImageView, cameraGlyphView, coverBadgeView, coverTextGlyph, removeCoverControl].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cameraGlyphView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cameraGlyphView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cameraGlyphView.widthAnchor.constraint(equalToConstant: 40),
            cameraGlyphView.heightAnchor.constraint(equalToConstant: 40),
            coverBadgeView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            coverBadgeView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            coverBadgeView.widthAnchor.constraint(equalToConstant: 52),
            coverBadgeView.heightAnchor.constraint(equalToConstant: 24),
            coverTextGlyph.centerXAnchor.constraint(equalTo: coverBadgeView.centerXAnchor),
            coverTextGlyph.centerYAnchor.constraint(equalTo: coverBadgeView.centerYAnchor),
            removeCoverControl.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            removeCoverControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            removeCoverControl.widthAnchor.constraint(equalToConstant: 26),
            removeCoverControl.heightAnchor.constraint(equalToConstant: 26)
        ])
    }

    func setImage(_ image: UIImage?) {
        coverImageView.image = image
        coverImageView.isHidden = image == nil
        cameraGlyphView.isHidden = image != nil
        removeCoverControl.isHidden = image == nil
    }

    @objc private func openCoverReefPicker() {
        onCoverSlotTap?(reefSlotIndex)
    }

    @objc private func clearCoverReefPick() {
        onCoverSlotRemove?(reefSlotIndex)
    }
}
