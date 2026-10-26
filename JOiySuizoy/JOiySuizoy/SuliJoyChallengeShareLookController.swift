import UIKit

final class dateTimeStack: SuliJoyTropicCanvasController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    private enum login {
        static let pageSide: CGFloat = 20
        static let pearlBadgeShell: CGFloat = 8
        static let toggleShoreMomentAudio: CGFloat = 44
        static let presentReefPhotoChoice: CGFloat = 16
        static let shoreReplyCountLabel: CGFloat = 28
        static let shoreTap: CGFloat = 1.12
        static let followWidth: CGFloat = 24
        static let reefFrameHarvester: CGFloat = 10
        static let makeShoreFeedScene: CGFloat = 56
        static let bodyGlyph: CGFloat = 12
        static let reefBackShell: CGFloat = 30
        static let reefAssetName: CGFloat = 56
    }

    var lagoonNameText: ((SuliJoyTideActivity) -> Void)?

    private let discover: String
    private let shoreScroll = UIScrollView()
    private let driftwoodPalette = UIView()
    private let desuliJoyPalmMatcherlete = UIControl()
    private let bioSide = UIImageView()
    private let pinMistVeil = UIControl()
    private let reefMediaPicks = UILabel()
    private let logoWidth = UITextField()
    private let raglanEase = SuliJoyGradientButton(reefHeadline: "Sxhxaxrxex xLxoxoxkx".suliJoyPalmUnfurled, reefHeight: login.reefAssetName)
    private var suliJoyShorelineStore: UIImage?
    private var reefInputBar: SuliJoyReefLocalMediaPick?

    init(discover: String) {
        self.discover = discover
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("ixnxixtx(xcxoxdxexrx:x)x xhxaxsx xnxoxtx xbxexexnx xixmxpxlxexmxexnxtxexdx".suliJoyPalmUnfurled)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pauseWaveRecording()
        toggleFollow()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    @MainActor deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func pauseWaveRecording() {
        shoreScroll.translatesAutoresizingMaskIntoConstraints = false
        shoreScroll.showsVerticalScrollIndicator = false
        shoreScroll.keyboardDismissMode = .interactive
        shoreScroll.backgroundColor = .clear
        driftwoodPalette.translatesAutoresizingMaskIntoConstraints = false
        driftwoodPalette.backgroundColor = .clear

        let presentShorePortraitPicker = UIButton(type: .system)
        presentShorePortraitPicker.translatesAutoresizingMaskIntoConstraints = false
        presentShorePortraitPicker.setImage(UIImage(systemName: "cxhxexvxrxoxnx.xlxexfxtx".suliJoyPalmUnfurled, withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)), for: .normal)
        presentShorePortraitPicker.tintColor = .suliInk
        presentShorePortraitPicker.addTarget(self, action: #selector(avatarShellTop), for: .touchUpInside)

        let pinwhoMistVeil = UILabel()
        pinwhoMistVeil.translatesAutoresizingMaskIntoConstraints = false
        pinwhoMistVeil.text = "Sxhxaxrxex xYxoxuxrx xLxoxoxkx".suliJoyPalmUnfurled
        pinwhoMistVeil.font = UIFont.systemFont(ofSize: 18, weight: .black)
        pinwhoMistVeil.textColor = .suliInk
        pinwhoMistVeil.textAlignment = .center

        desuliJoyPalmMatcherlete.translatesAutoresizingMaskIntoConstraints = false
        desuliJoyPalmMatcherlete.backgroundColor = UIColor(red: 0.98, green: 0.86, blue: 0.62, alpha: 1)
        desuliJoyPalmMatcherlete.layer.cornerRadius = login.shoreReplyCountLabel
        desuliJoyPalmMatcherlete.clipsToBounds = true
        desuliJoyPalmMatcherlete.addTarget(self, action: #selector(addShoreReportContent), for: .touchUpInside)

        bioSide.translatesAutoresizingMaskIntoConstraints = false
        bioSide.contentMode = .scaleAspectFill
        bioSide.clipsToBounds = true
        bioSide.image = esuliJoyPalmGuidemail.guestAvatarView

        pinMistVeil.translatesAutoresizingMaskIntoConstraints = false
        pinMistVeil.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        pinMistVeil.layer.cornerRadius = 20
        pinMistVeil.layer.borderWidth = 1
        pinMistVeil.layer.borderColor = UIColor.white.withAlphaComponent(0.85).cgColor
        pinMistVeil.addTarget(self, action: #selector(addShoreReportContent), for: .touchUpInside)

        let buttonHeight = UIImageView(image: UIImage(systemName: "cxaxmxexrxax.xfxixlxlx".suliJoyPalmUnfurled))
        buttonHeight.translatesAutoresizingMaskIntoConstraints = false
        buttonHeight.tintColor = .white
        buttonHeight.contentMode = .scaleAspectFit
        let secondaryAction = UILabel()
        secondaryAction.translatesAutoresizingMaskIntoConstraints = false
        secondaryAction.text = "Exdxixtx xPxhxoxtxox".suliJoyPalmUnfurled
        secondaryAction.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        secondaryAction.textColor = .white
        pinMistVeil.addSubview(buttonHeight)
        pinMistVeil.addSubview(secondaryAction)

        reefMediaPicks.translatesAutoresizingMaskIntoConstraints = false
        reefMediaPicks.text = "Wxrxixtxex xax xcxaxpxtxixoxnx".suliJoyPalmUnfurled
        reefMediaPicks.font = UIFont.systemFont(ofSize: 18, weight: .black)
        reefMediaPicks.textColor = .suliInk

        logoWidth.translatesAutoresizingMaskIntoConstraints = false
        logoWidth.placeholder = "Bxlxuxex xsxkxixexsx,x xixsxlxaxnxdx xvxixbxexsx".suliJoyPalmUnfurled
        logoWidth.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        logoWidth.textColor = .suliInk
        logoWidth.backgroundColor = .white
        logoWidth.layer.cornerRadius = login.bodyGlyph
        logoWidth.delegate = self
        logoWidth.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        logoWidth.leftViewMode = .always
        logoWidth.attributedPlaceholder = NSAttributedString(
            string: "Bxlxuxex xsxkxixexsx,x xixsxlxaxnxdx xvxixbxexsx".suliJoyPalmUnfurled,
            attributes: [
                .foregroundColor: UIColor(red: 0.74, green: 0.74, blue: 0.74, alpha: 1),
                .font: UIFont.systemFont(ofSize: 16, weight: .regular)
            ]
        )

        raglanEase.translatesAutoresizingMaskIntoConstraints = false
        raglanEase.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .black)
        raglanEase.addTarget(self, action: #selector(relatedTideMarks), for: .touchUpInside)

        view.addSubview(shoreScroll)
        view.addSubview(raglanEase)
        shoreScroll.addSubview(driftwoodPalette)
        driftwoodPalette.addSubview(presentShorePortraitPicker)
        driftwoodPalette.addSubview(pinwhoMistVeil)
        driftwoodPalette.addSubview(desuliJoyPalmMatcherlete)
        desuliJoyPalmMatcherlete.addSubview(bioSide)
        desuliJoyPalmMatcherlete.addSubview(pinMistVeil)

        NSLayoutConstraint.activate([
            raglanEase.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: login.pageSide),
            raglanEase.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -login.pageSide),
            raglanEase.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -login.reefBackShell),

            shoreScroll.topAnchor.constraint(equalTo: view.topAnchor),
            shoreScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoreScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoreScroll.bottomAnchor.constraint(equalTo: raglanEase.topAnchor, constant: -12),

            driftwoodPalette.topAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.topAnchor),
            driftwoodPalette.leadingAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.leadingAnchor),
            driftwoodPalette.trailingAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.trailingAnchor),
            driftwoodPalette.bottomAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.bottomAnchor),
            driftwoodPalette.widthAnchor.constraint(equalTo: shoreScroll.frameLayoutGuide.widthAnchor),

            presentShorePortraitPicker.topAnchor.constraint(equalTo: driftwoodPalette.safeAreaLayoutGuide.topAnchor, constant: login.pearlBadgeShell),
            presentShorePortraitPicker.leadingAnchor.constraint(equalTo: driftwoodPalette.leadingAnchor, constant: login.pageSide),
            presentShorePortraitPicker.widthAnchor.constraint(equalToConstant: login.toggleShoreMomentAudio),
            presentShorePortraitPicker.heightAnchor.constraint(equalToConstant: login.toggleShoreMomentAudio),

            pinwhoMistVeil.centerYAnchor.constraint(equalTo: presentShorePortraitPicker.centerYAnchor),
            pinwhoMistVeil.centerXAnchor.constraint(equalTo: driftwoodPalette.centerXAnchor),
            pinwhoMistVeil.leadingAnchor.constraint(greaterThanOrEqualTo: presentShorePortraitPicker.trailingAnchor, constant: 8),

            desuliJoyPalmMatcherlete.topAnchor.constraint(equalTo: presentShorePortraitPicker.bottomAnchor, constant: login.presentReefPhotoChoice),
            desuliJoyPalmMatcherlete.leadingAnchor.constraint(equalTo: driftwoodPalette.leadingAnchor, constant: login.pageSide),
            desuliJoyPalmMatcherlete.trailingAnchor.constraint(equalTo: driftwoodPalette.trailingAnchor, constant: -login.pageSide),
            desuliJoyPalmMatcherlete.heightAnchor.constraint(equalTo: desuliJoyPalmMatcherlete.widthAnchor, multiplier: login.shoreTap),

            bioSide.topAnchor.constraint(equalTo: desuliJoyPalmMatcherlete.topAnchor),
            bioSide.leadingAnchor.constraint(equalTo: desuliJoyPalmMatcherlete.leadingAnchor),
            bioSide.trailingAnchor.constraint(equalTo: desuliJoyPalmMatcherlete.trailingAnchor),
            bioSide.bottomAnchor.constraint(equalTo: desuliJoyPalmMatcherlete.bottomAnchor),

            pinMistVeil.centerXAnchor.constraint(equalTo: desuliJoyPalmMatcherlete.centerXAnchor),
            pinMistVeil.bottomAnchor.constraint(equalTo: desuliJoyPalmMatcherlete.bottomAnchor, constant: -16),
            pinMistVeil.heightAnchor.constraint(equalToConstant: 40),

            buttonHeight.leadingAnchor.constraint(equalTo: pinMistVeil.leadingAnchor, constant: 14),
            buttonHeight.centerYAnchor.constraint(equalTo: pinMistVeil.centerYAnchor),
            buttonHeight.widthAnchor.constraint(equalToConstant: 16),
            buttonHeight.heightAnchor.constraint(equalToConstant: 14),

            secondaryAction.leadingAnchor.constraint(equalTo: buttonHeight.trailingAnchor, constant: 6),
            secondaryAction.trailingAnchor.constraint(equalTo: pinMistVeil.trailingAnchor, constant: -14),
            secondaryAction.centerYAnchor.constraint(equalTo: pinMistVeil.centerYAnchor)
        ])

        driftwoodPalette.addSubview(reefMediaPicks)
        driftwoodPalette.addSubview(logoWidth)
        NSLayoutConstraint.activate([
            reefMediaPicks.topAnchor.constraint(equalTo: desuliJoyPalmMatcherlete.bottomAnchor, constant: login.followWidth),
            reefMediaPicks.leadingAnchor.constraint(equalTo: desuliJoyPalmMatcherlete.leadingAnchor),
            reefMediaPicks.trailingAnchor.constraint(equalTo: desuliJoyPalmMatcherlete.trailingAnchor),

            logoWidth.topAnchor.constraint(equalTo: reefMediaPicks.bottomAnchor, constant: login.reefFrameHarvester),
            logoWidth.leadingAnchor.constraint(equalTo: desuliJoyPalmMatcherlete.leadingAnchor),
            logoWidth.trailingAnchor.constraint(equalTo: desuliJoyPalmMatcherlete.trailingAnchor),
            logoWidth.heightAnchor.constraint(equalToConstant: login.makeShoreFeedScene),
            logoWidth.bottomAnchor.constraint(equalTo: driftwoodPalette.bottomAnchor, constant: -20)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(emojiButton))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func addShoreReportContent() {
        emojiButton()
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sheet.addAction(UIAlertAction(title: "Txaxkxex xPxhxoxtxox".suliJoyPalmUnfurled, style: .default) { [weak self] _ in
                self?.makeHarborTitle(source: .camera)
            })
        }
        sheet.addAction(UIAlertAction(title: "Cxhxoxoxsxex xfxrxoxmx xLxixbxrxaxrxyx".suliJoyPalmUnfurled, style: .default) { [weak self] _ in
            self?.makeHarborTitle(source: .photoLibrary)
        })
        sheet.addAction(UIAlertAction(title: "Cxaxnxcxexlx".suliJoyPalmUnfurled, style: .cancel))
        sheet.popoverPresentationController?.sourceView = desuliJoyPalmMatcherlete
        sheet.popoverPresentationController?.sourceRect = desuliJoyPalmMatcherlete.bounds
        present(sheet, animated: true)
    }

    private func makeHarborTitle(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else { return }
        let fieldBottom = UIImagePickerController()
        fieldBottom.sourceType = source
        fieldBottom.delegate = self
        fieldBottom.allowsEditing = true
        present(fieldBottom, animated: true)
    }

    func imagePickerController(_ fieldBottom: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        fieldBottom.dismiss(animated: true)
        guard let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage) else { return }
        suliJoyShorelineStore = image
        bioSide.image = image
        reefInputBar = dismissReefUnlockNotice(image)
    }

    func imagePickerControllerDidCancel(_ fieldBottom: UIImagePickerController) {
        fieldBottom.dismiss(animated: true)
    }

    private func dismissReefUnlockNotice(_ image: UIImage) -> SuliJoyReefLocalMediaPick? {
        guard let data = image.jpegData(compressionQuality: 0.86) else { return nil }
        let heroRadius = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("SxuxlxixJxoxyxPxoxsxtxMxexdxixax".suliJoyPalmUnfurled, isDirectory: true)
        try? FileManager.default.createDirectory(at: heroRadius, withIntermediateDirectories: true)
        let url = heroRadius.appendingPathComponent("\("cxhxaxlxlxexnxgxex_xlxoxoxkx_x".suliJoyPalmUnfurled)\(UUID().uuidString)\(".xjxpxgx".suliJoyPalmUnfurled)")
        do {
            try data.write(to: url, options: .atomic)
            return SuliJoyReefLocalMediaPick(reefSandboxPath: url.path, hibiscusShade: "Cxhxaxlxlxexnxgxex xlxoxoxkx".suliJoyPalmUnfurled)
        } catch {
            return nil
        }
    }

    @objc private func relatedTideMarks() {
        emojiButton()
        guard let reefInputBar else {
            showLagoonToast("Pxlxexaxsxex xaxdxdx xax xpxhxoxtxox xfxoxrx xyxoxuxrx xlxoxoxkx.x".suliJoyPalmUnfurled)
            return
        }
        let caption = (logoWidth.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !caption.isEmpty else {
            showLagoonToast("Pxlxexaxsxex xwxrxixtxex xax xcxaxpxtxixoxnx.x".suliJoyPalmUnfurled)
            return
        }
        let draft = SuliJoyShoreDraftMoment(
            islandCaptionLine: caption,
            reefPicks: [reefInputBar],
            waveDraft: nil
        )
        raglanEase.isLoading = true
        SuliJoyCoveMockService.shared.publishShoreMoment(draft: draft) { [weak self] publishEnvelope in
            guard let self else { return }
            guard publishEnvelope.beachwearCapsule == 200 else {
                self.raglanEase.isLoading = false
                self.showLagoonToast(publishEnvelope.coastalWardrobe)
                return
            }
            SuliJoyCoveMockService.shared.joinActivity(tideID: self.discover) { joinEnvelope in
                self.raglanEase.isLoading = false
                guard joinEnvelope.beachwearCapsule == 200, let paintLagoonGlowWash = joinEnvelope.sandbarLayering else {
                    self.showLagoonToast(joinEnvelope.coastalWardrobe)
                    return
                }
                NotificationCenter.default.post(name: .suliJoyShoreMomentPublished, object: publishEnvelope.sandbarLayering)
                self.lagoonNameText?(paintLagoonGlowWash)
                self.showLagoonToast("Lxoxoxkx xsxhxaxrxexdx x—x xcxhxaxlxlxexnxgxex xjxoxixnxexdx!x".suliJoyPalmUnfurled)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    @objc private func avatarShellTop() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func emojiButton() {
        view.endEditing(true)
    }

    private func toggleFollow() {
        NotificationCenter.default.addObserver(self, selector: #selector(reefMotionShelf(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissShorePearlDialog(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func reefMotionShelf(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let inset = frame.height - view.safeAreaInsets.bottom + 12
        shoreScroll.contentInset.bottom = inset
        shoreScroll.verticalScrollIndicatorInsets.bottom = inset
    }

    @objc private func dismissShorePearlDialog(_ note: Notification) {
        shoreScroll.contentInset.bottom = 0
        shoreScroll.verticalScrollIndicatorInsets.bottom = 0
    }
}
