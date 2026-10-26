import UIKit

final class SuliJoyTideCurationDraftController: SuliJoyTropicCanvasController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    private enum openShoreDateWheel {
        static let pageSide: CGFloat = 20
        static let pearlBadgeShell: CGFloat = 8
        static let toggleShoreMomentAudio: CGFloat = 44
        static let removeCoverControl: CGFloat = 16
        static let toastSide: CGFloat = 22
        static let arrivalScene: CGFloat = 188
        static let formTop: CGFloat = 22
        static let wrapCoastalEnvelope: CGFloat = 18
        static let dismissKeyboard: CGFloat = 18
        static let email: CGFloat = 52
        static let makeShoreSignupNextControl: CGFloat = 16
        static let shoreNameInput: CGFloat = 54
        static let completeProfile: CGFloat = 8
    }

    private let shoreDraftScrollCanvas = UIScrollView()
    private let shoreDraftDeck = UIView()
    private let shoreDraftNavRail = UIView()
    private let styleTitleField = UITextField()
    private let shorePublishControl = SuliJoyGradientButton(reefHeadline: "Create Challenge", reefHeight: openShoreDateWheel.shoreNameInput)

    private let reefShelves = UIImageView()
    private let returnAcrossReef = UIStackView()
    private var coverReefPicks: [SuliJoyReefEventPhotoPick] = []
    private var makeQuietHeadlineLabel: [UIButton] = []
    private var SuliJoyavatarSide: [UIButton] = []
    private var cardMinRatio = "Blue"
    private var suggestionRow = "23h"

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        detail()
        registerDraftKeyboardObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    @MainActor deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func detail() {
        shoreDraftScrollCanvas.translatesAutoresizingMaskIntoConstraints = false
        shoreDraftScrollCanvas.keyboardDismissMode = .interactive
        shoreDraftScrollCanvas.showsVerticalScrollIndicator = false
        shoreDraftScrollCanvas.backgroundColor = .clear
        shoreDraftDeck.translatesAutoresizingMaskIntoConstraints = false
        shoreDraftDeck.backgroundColor = .clear

        loadPublishedClipReef()

        let anchorCurationDraftNav = UIControl()
        anchorCurationDraftNav.translatesAutoresizingMaskIntoConstraints = false
        anchorCurationDraftNav.backgroundColor = UIColor(red: 0.98, green: 0.86, blue: 0.62, alpha: 1)
        anchorCurationDraftNav.layer.cornerRadius = openShoreDateWheel.toastSide
        anchorCurationDraftNav.clipsToBounds = true
        anchorCurationDraftNav.addTarget(self, action: #selector(refreshedMoment), for: .touchUpInside)

        reefShelves.translatesAutoresizingMaskIntoConstraints = false
        reefShelves.contentMode = .scaleAspectFill
        reefShelves.clipsToBounds = true
        reefShelves.image = esuliJoyPalmGuidemail.guestAvatarView

        let tideCardShell = UIImageView(image: UIImage(systemName: "camera.fill"))
        tideCardShell.translatesAutoresizingMaskIntoConstraints = false
        tideCardShell.tintColor = .white
        tideCardShell.contentMode = .scaleAspectFit
        let taglineSize = UILabel()
        taglineSize.text = "Add a cover photo"
        taglineSize.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        taglineSize.textColor = .white
        returnAcrossReef.axis = .vertical
        returnAcrossReef.alignment = .center
        returnAcrossReef.spacing = 8
        returnAcrossReef.translatesAutoresizingMaskIntoConstraints = false
        returnAcrossReef.isUserInteractionEnabled = false
        returnAcrossReef.addArrangedSubview(tideCardShell)
        returnAcrossReef.addArrangedSubview(taglineSize)
        anchorCurationDraftNav.addSubview(reefShelves)
        anchorCurationDraftNav.addSubview(returnAcrossReef)

        styleTitleField.translatesAutoresizingMaskIntoConstraints = false
        styleTitleField.placeholder = "e.g. A Touch of Blue"
        styleTitleField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        styleTitleField.textColor = .suliInk
        styleTitleField.backgroundColor = .white
        styleTitleField.layer.cornerRadius = openShoreDateWheel.makeShoreSignupNextControl
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

        let isVisitorSelected = reefFollowerTotal(
            sheetCorner: ["Blue", "Linen", "Floral", "White", "Breezy", "Resort", "Bold"],
            selected: cardMinRatio,
            heroTop: &makeQuietHeadlineLabel,
            action: #selector(cancelTap(_:))
        )
        let tuneWaveRow = reefFollowerTotal(
            sheetCorner: ["23h", "3 days", "7 days"],
            selected: suggestionRow,
            heroTop: &SuliJoyavatarSide,
            action: #selector(chooseShorelineStyle(_:))
        )

        let shoreContentGlyph = UIStackView()
        shoreContentGlyph.translatesAutoresizingMaskIntoConstraints = false
        shoreContentGlyph.axis = .vertical
        shoreContentGlyph.spacing = openShoreDateWheel.wrapCoastalEnvelope
        shoreContentGlyph.addArrangedSubview(followEnvelope("Challenge title"))
        shoreContentGlyph.addArrangedSubview(styleTitleField)
        shoreContentGlyph.addArrangedSubview(followEnvelope("Style Signal"))
        shoreContentGlyph.addArrangedSubview(isVisitorSelected)
        shoreContentGlyph.addArrangedSubview(followEnvelope("Challenge duration"))
        shoreContentGlyph.addArrangedSubview(tuneWaveRow)
        styleTitleField.heightAnchor.constraint(equalToConstant: openShoreDateWheel.email).isActive = true

        shorePublishControl.translatesAutoresizingMaskIntoConstraints = false
        shorePublishControl.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .black)
        shorePublishControl.addTarget(self, action: #selector(publishShorelineDraft), for: .touchUpInside)

        view.addSubview(shoreDraftScrollCanvas)
        view.addSubview(shorePublishControl)
        shoreDraftScrollCanvas.addSubview(shoreDraftDeck)
        [shoreDraftNavRail, anchorCurationDraftNav, shoreContentGlyph].forEach { shoreDraftDeck.addSubview($0) }

        NSLayoutConstraint.activate([
            shorePublishControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: openShoreDateWheel.pageSide),
            shorePublishControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -openShoreDateWheel.pageSide),
            shorePublishControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -openShoreDateWheel.completeProfile),

            shoreDraftScrollCanvas.topAnchor.constraint(equalTo: view.topAnchor),
            shoreDraftScrollCanvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoreDraftScrollCanvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoreDraftScrollCanvas.bottomAnchor.constraint(equalTo: shorePublishControl.topAnchor, constant: -12),

            shoreDraftDeck.topAnchor.constraint(equalTo: shoreDraftScrollCanvas.contentLayoutGuide.topAnchor),
            shoreDraftDeck.leadingAnchor.constraint(equalTo: shoreDraftScrollCanvas.contentLayoutGuide.leadingAnchor),
            shoreDraftDeck.trailingAnchor.constraint(equalTo: shoreDraftScrollCanvas.contentLayoutGuide.trailingAnchor),
            shoreDraftDeck.bottomAnchor.constraint(equalTo: shoreDraftScrollCanvas.contentLayoutGuide.bottomAnchor),
            shoreDraftDeck.widthAnchor.constraint(equalTo: shoreDraftScrollCanvas.frameLayoutGuide.widthAnchor),

            shoreDraftNavRail.topAnchor.constraint(equalTo: shoreDraftDeck.safeAreaLayoutGuide.topAnchor, constant: openShoreDateWheel.pearlBadgeShell),
            shoreDraftNavRail.leadingAnchor.constraint(equalTo: shoreDraftDeck.leadingAnchor, constant: openShoreDateWheel.pageSide),
            shoreDraftNavRail.trailingAnchor.constraint(equalTo: shoreDraftDeck.trailingAnchor, constant: -openShoreDateWheel.pageSide),
            shoreDraftNavRail.heightAnchor.constraint(equalToConstant: openShoreDateWheel.toggleShoreMomentAudio),

            anchorCurationDraftNav.topAnchor.constraint(equalTo: shoreDraftNavRail.bottomAnchor, constant: openShoreDateWheel.removeCoverControl),
            anchorCurationDraftNav.leadingAnchor.constraint(equalTo: shoreDraftDeck.leadingAnchor, constant: openShoreDateWheel.pageSide),
            anchorCurationDraftNav.trailingAnchor.constraint(equalTo: shoreDraftDeck.trailingAnchor, constant: -openShoreDateWheel.pageSide),
            anchorCurationDraftNav.heightAnchor.constraint(equalToConstant: openShoreDateWheel.arrivalScene),

            reefShelves.topAnchor.constraint(equalTo: anchorCurationDraftNav.topAnchor),
            reefShelves.leadingAnchor.constraint(equalTo: anchorCurationDraftNav.leadingAnchor),
            reefShelves.trailingAnchor.constraint(equalTo: anchorCurationDraftNav.trailingAnchor),
            reefShelves.bottomAnchor.constraint(equalTo: anchorCurationDraftNav.bottomAnchor),

            returnAcrossReef.centerXAnchor.constraint(equalTo: anchorCurationDraftNav.centerXAnchor),
            returnAcrossReef.centerYAnchor.constraint(equalTo: anchorCurationDraftNav.centerYAnchor),
            tideCardShell.widthAnchor.constraint(equalToConstant: 28),
            tideCardShell.heightAnchor.constraint(equalToConstant: 24),

            shoreContentGlyph.topAnchor.constraint(equalTo: anchorCurationDraftNav.bottomAnchor, constant: openShoreDateWheel.formTop),
            shoreContentGlyph.leadingAnchor.constraint(equalTo: anchorCurationDraftNav.leadingAnchor),
            shoreContentGlyph.trailingAnchor.constraint(equalTo: anchorCurationDraftNav.trailingAnchor),
            shoreContentGlyph.bottomAnchor.constraint(equalTo: shoreDraftDeck.bottomAnchor, constant: -24)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(foldDraftKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func loadPublishedClipReef() {
        shoreDraftNavRail.translatesAutoresizingMaskIntoConstraints = false
        let presentShorePortraitPicker = UIButton(type: .system)
        presentShorePortraitPicker.translatesAutoresizingMaskIntoConstraints = false
        presentShorePortraitPicker.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)), for: .normal)
        presentShorePortraitPicker.tintColor = .suliInk
        presentShorePortraitPicker.addTarget(self, action: #selector(driftBackFromCurationDraft), for: .touchUpInside)
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Create Events"
        title.font = UIFont.systemFont(ofSize: 18, weight: .black)
        title.textColor = .suliInk
        title.textAlignment = .center
        shoreDraftNavRail.addSubview(presentShorePortraitPicker)
        shoreDraftNavRail.addSubview(title)
        NSLayoutConstraint.activate([
            presentShorePortraitPicker.leadingAnchor.constraint(equalTo: shoreDraftNavRail.leadingAnchor),
            presentShorePortraitPicker.centerYAnchor.constraint(equalTo: shoreDraftNavRail.centerYAnchor),
            presentShorePortraitPicker.widthAnchor.constraint(equalToConstant: 40),
            presentShorePortraitPicker.heightAnchor.constraint(equalToConstant: 40),
            title.centerXAnchor.constraint(equalTo: shoreDraftNavRail.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: shoreDraftNavRail.centerYAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: presentShorePortraitPicker.trailingAnchor, constant: 8)
        ])
    }

    private func followEnvelope(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: openShoreDateWheel.dismissKeyboard, weight: .black)
        label.textColor = .suliInk
        return label
    }

    private func reefFollowerTotal(sheetCorner: [String], selected: String, heroTop: inout [UIButton], action: Selector) -> UIStackView {
        let clipPortraitToken = UIStackView()
        clipPortraitToken.axis = .vertical
        clipPortraitToken.spacing = 10
        clipPortraitToken.alignment = .leading
        var row = UIStackView()
        row.axis = .horizontal
        row.spacing = 10
        var width: CGFloat = 0
        let reefContentView = UIScreen.main.bounds.width - openShoreDateWheel.pageSide * 2
        for name in sheetCorner {
            let reefMuteButton = ReefLaunchCrown()
            reefMuteButton.setTitle(name, for: .normal)
            reefMuteButton.addTarget(self, action: action, for: .touchUpInside)
            stylistEnvelope(reefMuteButton, selected: name == selected)
            heroTop.append(reefMuteButton)
            let islandAwaitingReturn = max(72, CGFloat(name.count * 9 + 36))
            if width > 0, width + islandAwaitingReturn > reefContentView {
                clipPortraitToken.addArrangedSubview(row)
                row = UIStackView()
                row.axis = .horizontal
                row.spacing = 10
                width = 0
            }
            row.addArrangedSubview(reefMuteButton)
            width += islandAwaitingReturn + 10
        }
        if !row.arrangedSubviews.isEmpty {
            clipPortraitToken.addArrangedSubview(row)
        }
        return clipPortraitToken
    }

    private func stylistEnvelope(_ reefMuteButton: ReefLaunchCrown, selected: Bool) {
        reefMuteButton.lagoonFansTextGlyph(selected)
        reefMuteButton.setTitleColor(selected ? .suliInk : UIColor(red: 0.70, green: 0.69, blue: 0.67, alpha: 1), for: .normal)
    }

    @objc private func refreshedMoment() {
        suliJoyCoastalStyle()
    }

    @objc private func cancelTap(_ sender: UIButton) {
        cardMinRatio = sender.title(for: .normal) ?? cardMinRatio
        makeQuietHeadlineLabel.forEach {
            stylistEnvelope($0 as! ReefLaunchCrown, selected: $0 === sender)
        }
    }

    @objc private func chooseShorelineStyle(_ sender: UIButton) {
        suggestionRow = sender.title(for: .normal) ?? suggestionRow
        SuliJoyavatarSide.forEach {
            stylistEnvelope($0 as! ReefLaunchCrown, selected: $0 === sender)
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
        coverChoiceSheet.popoverPresentationController?.sourceView = reefShelves
        coverChoiceSheet.popoverPresentationController?.sourceRect = reefShelves.bounds
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
        reefShelves.image = coverImage
        returnAcrossReef.isHidden = true
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
        let lagoonMarkControl: TimeInterval
        switch suggestionRow {
        case "3 days": lagoonMarkControl = 3 * 24
        case "7 days": lagoonMarkControl = 7 * 24
        default: lagoonMarkControl = 23
        }
        let openSettingCove = Date().addingTimeInterval(lagoonMarkControl * 3600)
        let tideDraft = SuliJoyTideDraftActivity(
            tideTitleLine: shorelineTitle,
            tideStyleKind: cardMinRatio,
            wardrobeThemeLine: cardMinRatio,
            shoreBriefLine: "Style Signal: \(cardMinRatio) · \(suggestionRow)",
            tideDay: openSettingCove,
            tideClock: openSettingCove,
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

private final class ReefLaunchCrown: UIButton {
    private let toastIconSide = CAGradientLayer()
    private let reefImage = UIView()

    init() {
        super.init(frame: .zero)
        titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        toastIconSide.colors = [
            UIColor(red: 1, green: 0.55, blue: 0.28, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.92, blue: 0.32, alpha: 1).cgColor,
            UIColor(red: 0.55, green: 0.98, blue: 0.55, alpha: 1).cgColor
        ]
        toastIconSide.startPoint = CGPoint(x: 0, y: 0.5)
        toastIconSide.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(toastIconSide, at: 0)
        reefImage.backgroundColor = .white
        reefImage.isUserInteractionEnabled = false
        insertSubview(reefImage, at: 0)
        lagoonFansTextGlyph(false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func lagoonFansTextGlyph(_ selected: Bool) {
        toastIconSide.isHidden = !selected
        layer.borderWidth = selected ? 0 : 1
        layer.borderColor = UIColor(red: 0.90, green: 0.88, blue: 0.84, alpha: 1).cgColor
        backgroundColor = .white
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        toastIconSide.frame = bounds
        toastIconSide.cornerRadius = bounds.height / 2
        let inset: CGFloat = toastIconSide.isHidden ? 0 : 2
        reefImage.frame = bounds.insetBy(dx: inset, dy: inset)
        reefImage.layer.cornerRadius = reefImage.bounds.height / 2
    }
}
