import AVFoundation
import UIKit

final class SuliJoyReefMomentTideController: SuliJoyTropicCanvasController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    private let shoreScroll = UIScrollView()
    private let reefCanvas = UIView()
    private let crownRow = UIView()
    private let reefPhotoRow = UIStackView()
    private let shoreTextTitle = UILabel()
    private let shoreTextShell = UIView()
    private let shoreTextView = UITextView()
    private let shorePlaceholderGlyph = UILabel()
    private let waveButton = UIButton(type: .system)
    private let waveIconView = UIImageView()
    private let waveStatusGlyph = UILabel()
    private let waveRetryButton = UIButton(type: .system)
    private let tideConfirmButton = SuliJoyGradientButton(reefHeadline: "CqoEnMfJiarImR".suliJoyPalmUnfurled)
    private var shoreBottomTether: NSLayoutConstraint?
    private var activePhotoIndex = 0
    private var reefMediaPicks: [SuliJoyReefLocalMediaPick] = []
    private var reefPhotoImages: [UIImage] = []
    private var reefPhotoSlots: [SuliJoyReefPhotoSlotControl] = []
    private var waveDraft: SuliJoyWaveResonanceDraft?

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        raiseShoreMomentTide()
        bindShoreKeyboardTides()
        refreshShoreMomentState()
    }

    @MainActor deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func raiseShoreMomentTide() {
        shoreScroll.translatesAutoresizingMaskIntoConstraints = false
        shoreScroll.showsVerticalScrollIndicator = false
        shoreScroll.keyboardDismissMode = .interactive
        reefCanvas.translatesAutoresizingMaskIntoConstraints = false

        tuneCrownRow()
        tuneReefPhotoSlots()
        tuneShoreTextArea()
        tuneWaveRow()
        tuneTideConfirm()

        view.addSubview(shoreScroll)
        shoreScroll.addSubview(reefCanvas)
        [crownRow, reefPhotoRow, shoreTextTitle, shoreTextShell, waveButton, tideConfirmButton].forEach { reefCanvas.addSubview($0) }
        shoreBottomTether = reefCanvas.bottomAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.bottomAnchor)
        shoreBottomTether?.isActive = true

        NSLayoutConstraint.activate([
            shoreScroll.topAnchor.constraint(equalTo: view.topAnchor),
            shoreScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoreScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoreScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            reefCanvas.topAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.topAnchor),
            reefCanvas.leadingAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.leadingAnchor),
            reefCanvas.trailingAnchor.constraint(equalTo: shoreScroll.contentLayoutGuide.trailingAnchor),
            reefCanvas.widthAnchor.constraint(equalTo: shoreScroll.frameLayoutGuide.widthAnchor),
            reefCanvas.heightAnchor.constraint(greaterThanOrEqualTo: shoreScroll.frameLayoutGuide.heightAnchor),

            crownRow.topAnchor.constraint(equalTo: reefCanvas.safeAreaLayoutGuide.topAnchor, constant: 14),
            crownRow.leadingAnchor.constraint(equalTo: reefCanvas.leadingAnchor, constant: 20),
            crownRow.trailingAnchor.constraint(equalTo: reefCanvas.trailingAnchor, constant: -20),
            crownRow.heightAnchor.constraint(equalToConstant: 44),

            reefPhotoRow.topAnchor.constraint(equalTo: crownRow.bottomAnchor, constant: 24),
            reefPhotoRow.leadingAnchor.constraint(equalTo: reefCanvas.leadingAnchor, constant: 30),
            reefPhotoRow.trailingAnchor.constraint(equalTo: reefCanvas.trailingAnchor, constant: -30),
            reefPhotoRow.heightAnchor.constraint(equalTo: reefPhotoRow.widthAnchor, multiplier: 86.0 / 345.0),

            shoreTextTitle.topAnchor.constraint(equalTo: reefPhotoRow.bottomAnchor, constant: 28),
            shoreTextTitle.leadingAnchor.constraint(equalTo: reefPhotoRow.leadingAnchor),
            shoreTextTitle.trailingAnchor.constraint(equalTo: reefPhotoRow.trailingAnchor),

            shoreTextShell.topAnchor.constraint(equalTo: shoreTextTitle.bottomAnchor, constant: 18),
            shoreTextShell.leadingAnchor.constraint(equalTo: reefPhotoRow.leadingAnchor),
            shoreTextShell.trailingAnchor.constraint(equalTo: reefPhotoRow.trailingAnchor),
            shoreTextShell.heightAnchor.constraint(greaterThanOrEqualToConstant: 190),

            waveButton.topAnchor.constraint(equalTo: shoreTextShell.bottomAnchor, constant: 18),
            waveButton.leadingAnchor.constraint(equalTo: reefPhotoRow.leadingAnchor),
            waveButton.trailingAnchor.constraint(equalTo: reefPhotoRow.trailingAnchor),
            waveButton.heightAnchor.constraint(equalToConstant: 54),

            tideConfirmButton.leadingAnchor.constraint(equalTo: reefPhotoRow.leadingAnchor),
            tideConfirmButton.trailingAnchor.constraint(equalTo: reefPhotoRow.trailingAnchor),
            tideConfirmButton.bottomAnchor.constraint(equalTo: reefCanvas.safeAreaLayoutGuide.bottomAnchor, constant: -34)
        ])

        let tideSoftBottom = tideConfirmButton.topAnchor.constraint(greaterThanOrEqualTo: waveButton.bottomAnchor, constant: 84)
        tideSoftBottom.priority = .defaultHigh
        tideSoftBottom.isActive = true

        let shoreTap = UITapGestureRecognizer(target: self, action: #selector(dismissShoreKeyboard))
        shoreTap.cancelsTouchesInView = false
        view.addGestureRecognizer(shoreTap)
    }

    private func tuneCrownRow() {
        crownRow.translatesAutoresizingMaskIntoConstraints = false

        let backShell = UIButton(type: .system)
        backShell.translatesAutoresizingMaskIntoConstraints = false
        backShell.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backShell.tintColor = .suliInk
        backShell.addTarget(self, action: #selector(returnToPreviousReef), for: .touchUpInside)

        let crownGlyph = UILabel()
        crownGlyph.translatesAutoresizingMaskIntoConstraints = false
        crownGlyph.text = "PwoPsftw".suliJoyPalmUnfurled
        crownGlyph.font = UIFont.systemFont(ofSize: 26, weight: .black)
        crownGlyph.textColor = .suliInk
        crownGlyph.textAlignment = .center

        crownRow.addSubview(backShell)
        crownRow.addSubview(crownGlyph)
        NSLayoutConstraint.activate([
            backShell.leadingAnchor.constraint(equalTo: crownRow.leadingAnchor),
            backShell.centerYAnchor.constraint(equalTo: crownRow.centerYAnchor),
            backShell.widthAnchor.constraint(equalToConstant: 36),
            backShell.heightAnchor.constraint(equalToConstant: 36),
            crownGlyph.centerXAnchor.constraint(equalTo: crownRow.centerXAnchor),
            crownGlyph.centerYAnchor.constraint(equalTo: crownRow.centerYAnchor),
            crownGlyph.leadingAnchor.constraint(greaterThanOrEqualTo: backShell.trailingAnchor, constant: 12)
        ])
    }

    private func tuneReefPhotoSlots() {
        reefPhotoRow.translatesAutoresizingMaskIntoConstraints = false
        reefPhotoRow.axis = .horizontal
        reefPhotoRow.spacing = 10
        reefPhotoRow.distribution = .fillEqually
        for reefIndex in 0..<3 {
            let photoSlot = SuliJoyReefPhotoSlotControl(reefIndex: reefIndex)
            photoSlot.onReefTap = { [weak self] slotIndex in
                self?.activePhotoIndex = slotIndex
                self?.presentReefPhotoChoice()
            }
            photoSlot.onReefRemove = { [weak self] slotIndex in
                self?.removeReefMedia(at: slotIndex)
            }
            reefPhotoSlots.append(photoSlot)
            reefPhotoRow.addArrangedSubview(photoSlot)
        }
    }

    private func tuneShoreTextArea() {
        shoreTextTitle.translatesAutoresizingMaskIntoConstraints = false
        shoreTextTitle.text = "CroEnEtseUnutr".suliJoyPalmUnfurled
        shoreTextTitle.font = UIFont.systemFont(ofSize: 22, weight: .black)
        shoreTextTitle.textColor = .suliInk

        shoreTextShell.translatesAutoresizingMaskIntoConstraints = false
        shoreTextShell.backgroundColor = .white
        shoreTextShell.layer.cornerRadius = 20
        shoreTextShell.clipsToBounds = true

        shoreTextView.translatesAutoresizingMaskIntoConstraints = false
        shoreTextView.backgroundColor = .clear
        shoreTextView.textColor = .suliInk
        shoreTextView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        shoreTextView.textContainerInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        shoreTextView.delegate = self

        shorePlaceholderGlyph.translatesAutoresizingMaskIntoConstraints = false
        shorePlaceholderGlyph.text = "SxaGyg DSGoBmAeKtthuiYnzgg".suliJoyPalmUnfurled
        shorePlaceholderGlyph.textColor = UIColor(red: 0.68, green: 0.67, blue: 0.66, alpha: 1)
        shorePlaceholderGlyph.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        shoreTextShell.addSubview(shoreTextView)
        shoreTextShell.addSubview(shorePlaceholderGlyph)
        NSLayoutConstraint.activate([
            shoreTextView.topAnchor.constraint(equalTo: shoreTextShell.topAnchor),
            shoreTextView.leadingAnchor.constraint(equalTo: shoreTextShell.leadingAnchor),
            shoreTextView.trailingAnchor.constraint(equalTo: shoreTextShell.trailingAnchor),
            shoreTextView.bottomAnchor.constraint(equalTo: shoreTextShell.bottomAnchor),
            shorePlaceholderGlyph.topAnchor.constraint(equalTo: shoreTextShell.topAnchor, constant: 22),
            shorePlaceholderGlyph.leadingAnchor.constraint(equalTo: shoreTextShell.leadingAnchor, constant: 25),
            shorePlaceholderGlyph.trailingAnchor.constraint(lessThanOrEqualTo: shoreTextShell.trailingAnchor, constant: -20)
        ])
    }

    private func tuneWaveRow() {
        waveButton.translatesAutoresizingMaskIntoConstraints = false
        waveButton.backgroundColor = .white
        waveButton.layer.cornerRadius = 27
        waveButton.clipsToBounds = true
        waveButton.addTarget(self, action: #selector(openWaveRecorder), for: .touchUpInside)

        waveIconView.translatesAutoresizingMaskIntoConstraints = false
        waveIconView.image = UIImage(named: "sulijoy_post_record_mic")?.withRenderingMode(.alwaysOriginal)
        waveIconView.contentMode = .scaleAspectFit
        waveIconView.isUserInteractionEnabled = false

        waveStatusGlyph.translatesAutoresizingMaskIntoConstraints = false
        waveStatusGlyph.font = UIFont.systemFont(ofSize: 20, weight: .black)
        waveStatusGlyph.textColor = .suliInk
        waveStatusGlyph.isUserInteractionEnabled = false

        waveRetryButton.translatesAutoresizingMaskIntoConstraints = false
        waveRetryButton.setImage(UIImage(named: "sulijoy_post_record_retry")?.withRenderingMode(.alwaysOriginal), for: .normal)
        waveRetryButton.addTarget(self, action: #selector(openWaveRecorder), for: .touchUpInside)

        [waveIconView, waveStatusGlyph, waveRetryButton].forEach { waveButton.addSubview($0) }
        NSLayoutConstraint.activate([
            waveIconView.leadingAnchor.constraint(equalTo: waveButton.leadingAnchor, constant: 30),
            waveIconView.centerYAnchor.constraint(equalTo: waveButton.centerYAnchor),
            waveIconView.widthAnchor.constraint(equalToConstant: 22),
            waveIconView.heightAnchor.constraint(equalToConstant: 22),
            waveStatusGlyph.leadingAnchor.constraint(equalTo: waveIconView.trailingAnchor, constant: 14),
            waveStatusGlyph.centerYAnchor.constraint(equalTo: waveButton.centerYAnchor),
            waveRetryButton.trailingAnchor.constraint(equalTo: waveButton.trailingAnchor),
            waveRetryButton.centerYAnchor.constraint(equalTo: waveButton.centerYAnchor),
            waveRetryButton.widthAnchor.constraint(equalToConstant: 48),
            waveRetryButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func tuneTideConfirm() {
        tideConfirmButton.translatesAutoresizingMaskIntoConstraints = false
        tideConfirmButton.addTarget(self, action: #selector(confirmShoreMoment), for: .touchUpInside)
    }

    private func refreshShoreMomentState() {
        for reefIndex in 0..<reefPhotoSlots.count {
            if reefPhotoImages.indices.contains(reefIndex) {
                reefPhotoSlots[reefIndex].configure(image: reefPhotoImages[reefIndex])
            } else {
                reefPhotoSlots[reefIndex].configure(image: nil)
            }
        }
        shorePlaceholderGlyph.isHidden = !shoreTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        if let waveDraft {
            waveStatusGlyph.text = "\(waveDraft.waveSeconds)s"
            waveRetryButton.isHidden = false
        } else {
            waveStatusGlyph.text = "RfeOcxoErbdsiWnOgq".suliJoyPalmUnfurled
            waveRetryButton.isHidden = true
        }
        let canSendShoreMoment = hasShoreMomentContent()
        tideConfirmButton.isEnabled = canSendShoreMoment && !tideConfirmButton.isLoading
        tideConfirmButton.alpha = canSendShoreMoment ? 1 : 0.48
    }

    private func hasShoreMomentContent() -> Bool {
        !shoreTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !reefMediaPicks.isEmpty || waveDraft != nil
    }

    private func presentReefPhotoChoice() {
        dismissShoreKeyboard()
        guard reefPhotoSlots.indices.contains(activePhotoIndex) else { return }
        let reefSheet = craftSuliJoyReefPickerSheet(
            reefHeadline: nil,
            shoreAnchor: reefPhotoSlots[activePhotoIndex],
            cameraPhrase: "Photo",
            galleryPhrase: "Album"
        ) { [weak self] reefSource in
            self?.openReefImagePicker(source: reefSource)
        }
        present(reefSheet, animated: true)
    }

    private func openReefImagePicker(source reefSource: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(reefSource) else {
            showLagoonToast("CWaamueArDaG Eiosb yuvnxabvWaCiclUaPbklLet.X".suliJoyPalmUnfurled)
            return
        }
        let reefPicker = UIImagePickerController()
        reefPicker.sourceType = reefSource
        reefPicker.mediaTypes = ["public.image"]
        reefPicker.allowsEditing = false
        reefPicker.delegate = self
        present(reefPicker, animated: true)
    }

    func imagePickerControllerDidCancel(_ reefPicker: UIImagePickerController) {
        reefPicker.dismiss(animated: true)
    }

    func imagePickerController(_ reefPicker: UIImagePickerController, didFinishPickingMediaWithInfo reefInfo: [UIImagePickerController.InfoKey: Any]) {
        guard let reefImage = reefInfo[.originalImage] as? UIImage else {
            reefPicker.dismiss(animated: true)
            return
        }
        reefPicker.dismiss(animated: true) { [weak self] in
            self?.storeReefImage(reefImage)
        }
    }

    private func storeReefImage(_ reefImage: UIImage) {
        guard let reefPick = saveReefImageToSandbox(reefImage) else {
            showLagoonToast("PWhToZtOoo pcFoFuplvdC AnpoVtS hbPet msaaevUeAdv.a".suliJoyPalmUnfurled)
            return
        }
        if reefMediaPicks.indices.contains(activePhotoIndex) {
            reefMediaPicks[activePhotoIndex] = reefPick
            reefPhotoImages[activePhotoIndex] = reefImage
        } else if reefMediaPicks.count < 3 {
            reefMediaPicks.append(reefPick)
            reefPhotoImages.append(reefImage)
        }
        refreshShoreMomentState()
    }

    private func removeReefMedia(at reefIndex: Int) {
        guard reefMediaPicks.indices.contains(reefIndex) else { return }
        reefMediaPicks.remove(at: reefIndex)
        reefPhotoImages.remove(at: reefIndex)
        refreshShoreMomentState()
    }

    private func saveReefImageToSandbox(_ reefImage: UIImage) -> SuliJoyReefLocalMediaPick? {
        guard let reefData = reefImage.jpegData(compressionQuality: 0.86) else { return nil }
        let reefDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("SuliJoyPostMedia", isDirectory: true)
        try? FileManager.default.createDirectory(at: reefDirectory, withIntermediateDirectories: true)
        let reefURL = reefDirectory.appendingPathComponent("shore_photo_\(UUID().uuidString).jpg")
        do {
            try reefData.write(to: reefURL, options: .atomic)
            return SuliJoyReefLocalMediaPick(reefSandboxPath: reefURL.path, reefCaptionLine: "IosNldamnydi csAtNyUlTeu fpbhDoNtJoV".suliJoyPalmUnfurled)
        } catch {
            return nil
        }
    }

    @objc private func openWaveRecorder() {
        dismissShoreKeyboard()
        let waveOverlay = SuliJoyWaveDraftReefOverlay(existingDraft: waveDraft)
        waveOverlay.onReefCancel = { [weak waveOverlay] in
            waveOverlay?.removeFromSuperview()
        }
        waveOverlay.onReefComplete = { [weak self, weak waveOverlay] shoreDraft in
            self?.waveDraft = shoreDraft
            self?.refreshShoreMomentState()
            waveOverlay?.removeFromSuperview()
        }
        waveOverlay.onReefIssue = { [weak self, weak waveOverlay] reefNotice in
            self?.showLagoonToast(reefNotice)
            waveOverlay?.removeFromSuperview()
        }
        waveOverlay.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(waveOverlay)
        waveOverlay.suliPinEdges(to: view)
    }

    @objc private func confirmShoreMoment() {
        guard hasShoreMomentContent() else {
            showLagoonToast("PxleewaVsAej EaCdydv kcCoJnjtNetnztS,o VpDhLoKtQopsq,M uoQrT hazutdZiroQ.k".suliJoyPalmUnfurled)
            return
        }
        let shoreDraft = SuliJoyShoreDraftMoment(
            islandCaptionLine: shoreTextView.text,
            reefPicks: reefMediaPicks,
            waveDraft: waveDraft
        )
        tideConfirmButton.isLoading = true
        refreshShoreMomentState()
        SuliJoyCoveMockService.shared.publishShoreMoment(draft: shoreDraft) { [weak self] reefResult in
            guard let self else { return }
            self.tideConfirmButton.isLoading = false
            self.refreshShoreMomentState()
            guard reefResult.code == 200 else {
                self.showLagoonToast(reefResult.note)
                return
            }
            NotificationCenter.default.post(name: .suliJoyShoreMomentPublished, object: reefResult.data)
            self.showLagoonToast(reefResult.note)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self.tabBarController?.selectedIndex = 1
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func textViewDidChange(_ shoreView: UITextView) {
        refreshShoreMomentState()
    }

    private func bindShoreKeyboardTides() {
        NotificationCenter.default.addObserver(self, selector: #selector(shoreKeyboardWillRise(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shoreKeyboardWillSettle(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func shoreKeyboardWillRise(_ reefNote: Notification) {
        guard let reefFrame = reefNote.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let shoreOverlap = max(0, reefFrame.height - view.safeAreaInsets.bottom)
        shoreScroll.contentInset.bottom = shoreOverlap + 22
        shoreScroll.scrollIndicatorInsets.bottom = shoreOverlap + 22
        let reefVisible = shoreTextShell.convert(shoreTextShell.bounds, to: shoreScroll)
        shoreScroll.scrollRectToVisible(reefVisible.insetBy(dx: 0, dy: -24), animated: true)
    }

    @objc private func shoreKeyboardWillSettle(_ reefNote: Notification) {
        shoreScroll.contentInset.bottom = 0
        shoreScroll.scrollIndicatorInsets.bottom = 0
    }

    @objc private func dismissShoreKeyboard() {
        view.endEditing(true)
    }

    @objc private func returnToPreviousReef() {
        navigationController?.popViewController(animated: true)
    }
}

private final class SuliJoyReefPhotoSlotControl: UIControl {
    var onReefTap: ((Int) -> Void)?
    var onReefRemove: ((Int) -> Void)?
    private let reefIndex: Int
    private let reefImageView = UIImageView()
    private let reefCameraView = UIImageView()
    private let reefRemoveButton = UIButton(type: .system)

    init(reefIndex: Int) {
        self.reefIndex = reefIndex
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 13
        clipsToBounds = true
        addTarget(self, action: #selector(tapReefPhoto), for: .touchUpInside)

        reefImageView.translatesAutoresizingMaskIntoConstraints = false
        reefImageView.contentMode = .scaleAspectFill
        reefImageView.clipsToBounds = true

        reefCameraView.translatesAutoresizingMaskIntoConstraints = false
        reefCameraView.image = UIImage(named: "sulijoy_post_photo_slot_camera")?.withRenderingMode(.alwaysOriginal)
        reefCameraView.contentMode = .scaleAspectFit
        reefCameraView.isUserInteractionEnabled = false

        reefRemoveButton.translatesAutoresizingMaskIntoConstraints = false
        reefRemoveButton.setImage(UIImage(named: "sulijoy_post_media_remove_mark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        reefRemoveButton.addTarget(self, action: #selector(tapReefRemove), for: .touchUpInside)

        [reefImageView, reefCameraView, reefRemoveButton].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            reefImageView.topAnchor.constraint(equalTo: topAnchor),
            reefImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            reefImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            reefImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            reefCameraView.centerXAnchor.constraint(equalTo: centerXAnchor),
            reefCameraView.centerYAnchor.constraint(equalTo: centerYAnchor),
            reefCameraView.widthAnchor.constraint(equalToConstant: 46),
            reefCameraView.heightAnchor.constraint(equalToConstant: 46),
            reefRemoveButton.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            reefRemoveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            reefRemoveButton.widthAnchor.constraint(equalToConstant: 30),
            reefRemoveButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        configure(image: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("iMnViVtJ(CcgoHdRewrG:m)G ohxaXsj Jnfobtb sbPeaeNnE KilmipjlZeUmaeinlthesdw".suliJoyPalmUnfurled)
    }

    func configure(image: UIImage?) {
        reefImageView.image = image
        reefImageView.isHidden = image == nil
        reefCameraView.isHidden = image != nil
        reefRemoveButton.isHidden = image == nil
    }

    @objc private func tapReefPhoto() {
        onReefTap?(reefIndex)
    }

    @objc private func tapReefRemove() {
        onReefRemove?(reefIndex)
    }
}

private final class SuliJoyWaveDraftReefOverlay: UIView, AVAudioRecorderDelegate {
    var onReefCancel: (() -> Void)?
    var onReefComplete: ((SuliJoyWaveResonanceDraft) -> Void)?
    var onReefIssue: ((String) -> Void)?
    private let waveStartButton = UIButton(type: .system)
    private let wavePauseButton = UIButton(type: .system)
    private let waveTimeGlyph = UILabel()
    private let wavePauseTimeGlyph = UILabel()
    private let waveRetryButton = UIButton(type: .system)
    private let waveDoneButton = UIButton(type: .system)
    private var waveRecorder: AVAudioRecorder?
    private var waveTicker: Timer?
    private var waveElapsed = 0
    private var waveFileURL: URL?

    init(existingDraft: SuliJoyWaveResonanceDraft?) {
        super.init(frame: .zero)
        if let existingDraft {
            waveElapsed = existingDraft.waveSeconds
            waveFileURL = URL(fileURLWithPath: existingDraft.waveSandboxPath)
        }
        raiseWaveOverlay()
        refreshWaveOverlay()
    }

    required init?(coder: NSCoder) {
        fatalError("ijnuiFtt(KcAordFefru:T)g phJaysh NnioNtH PbgedeLnL PiomTpylkermtefnctXebdx".suliJoyPalmUnfurled)
    }

    private func raiseWaveOverlay() {
        backgroundColor = UIColor.black.withAlphaComponent(0.48)

        waveStartButton.translatesAutoresizingMaskIntoConstraints = false
        waveStartButton.backgroundColor = UIColor.white.withAlphaComponent(0.70)
        waveStartButton.layer.cornerRadius = 70
        waveStartButton.setImage(UIImage(named: "sulijoy_post_record_play")?.withRenderingMode(.alwaysOriginal), for: .normal)
        waveStartButton.addTarget(self, action: #selector(startOrResumeWave), for: .touchUpInside)

        wavePauseButton.translatesAutoresizingMaskIntoConstraints = false
        wavePauseButton.backgroundColor = UIColor.white.withAlphaComponent(0.70)
        wavePauseButton.layer.cornerRadius = 70
        wavePauseButton.setImage(UIImage(named: "sulijoy_post_record_pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
        wavePauseButton.addTarget(self, action: #selector(pauseWaveRecording), for: .touchUpInside)

        [waveTimeGlyph, wavePauseTimeGlyph].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 16, weight: .black)
            $0.textAlignment = .center
        }

        waveRetryButton.translatesAutoresizingMaskIntoConstraints = false
        waveRetryButton.backgroundColor = UIColor(red: 1, green: 0.29, blue: 0.29, alpha: 1)
        waveRetryButton.layer.cornerRadius = 28
        waveRetryButton.setImage(UIImage(systemName: "plus"), for: .normal)
        waveRetryButton.tintColor = .white
        waveRetryButton.addTarget(self, action: #selector(resetWaveRecording), for: .touchUpInside)

        waveDoneButton.translatesAutoresizingMaskIntoConstraints = false
        waveDoneButton.backgroundColor = UIColor(red: 0.28, green: 0.90, blue: 0.22, alpha: 1)
        waveDoneButton.layer.cornerRadius = 28
        waveDoneButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        waveDoneButton.tintColor = .white
        waveDoneButton.addTarget(self, action: #selector(confirmWaveRecording), for: .touchUpInside)

        [waveStartButton, waveTimeGlyph, wavePauseButton, wavePauseTimeGlyph, waveRetryButton, waveDoneButton].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            waveStartButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            waveStartButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -108),
            waveStartButton.widthAnchor.constraint(equalToConstant: 140),
            waveStartButton.heightAnchor.constraint(equalToConstant: 140),
            waveTimeGlyph.topAnchor.constraint(equalTo: waveStartButton.bottomAnchor, constant: 12),
            waveTimeGlyph.centerXAnchor.constraint(equalTo: centerXAnchor),

            wavePauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            wavePauseButton.topAnchor.constraint(equalTo: waveTimeGlyph.bottomAnchor, constant: 48),
            wavePauseButton.widthAnchor.constraint(equalToConstant: 140),
            wavePauseButton.heightAnchor.constraint(equalToConstant: 140),
            wavePauseTimeGlyph.topAnchor.constraint(equalTo: wavePauseButton.bottomAnchor, constant: 12),
            wavePauseTimeGlyph.centerXAnchor.constraint(equalTo: centerXAnchor),

            waveRetryButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: -92),
            waveRetryButton.topAnchor.constraint(equalTo: wavePauseTimeGlyph.bottomAnchor, constant: 36),
            waveRetryButton.widthAnchor.constraint(equalToConstant: 56),
            waveRetryButton.heightAnchor.constraint(equalToConstant: 56),
            waveDoneButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: 92),
            waveDoneButton.centerYAnchor.constraint(equalTo: waveRetryButton.centerYAnchor),
            waveDoneButton.widthAnchor.constraint(equalToConstant: 56),
            waveDoneButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func refreshWaveOverlay() {
        let waveText = makeWaveTimeText()
        waveTimeGlyph.text = waveText
        wavePauseTimeGlyph.text = waveText
        let hasWaveCapture = waveElapsed > 0 || waveFileURL != nil
        waveRetryButton.isHidden = !hasWaveCapture
        waveDoneButton.isHidden = !hasWaveCapture
    }

    private func makeWaveTimeText() -> String {
        "0:\(String(format: "%02d", waveElapsed))/0:60"
    }

    @objc private func startOrResumeWave() {
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
            DispatchQueue.main.async {
                guard let self else { return }
                guard granted else {
                    self.onReefIssue?("Microphone permission is required.")
                    return
                }
                self.prepareWaveRecorderIfNeeded()
                self.waveRecorder?.record()
                self.startWaveTicker()
            }
        }
    }

    private func prepareWaveRecorderIfNeeded() {
        if waveRecorder != nil { return }
        let waveDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("SuliJoyPostAudio", isDirectory: true)
        try? FileManager.default.createDirectory(at: waveDirectory, withIntermediateDirectories: true)
        let waveURL = waveFileURL ?? waveDirectory.appendingPathComponent("shore_audio_\(UUID().uuidString).m4a")
        waveFileURL = waveURL
        let waveSession = AVAudioSession.sharedInstance()
        try? waveSession.setCategory(.playAndRecord, mode: .default)
        try? waveSession.setActive(true)
        let waveSettings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
        do {
            waveRecorder = try AVAudioRecorder(url: waveURL, settings: waveSettings)
            waveRecorder?.delegate = self
            waveRecorder?.prepareToRecord()
        } catch {
            onReefIssue?("Recorder could not start.")
        }
    }

    private func startWaveTicker() {
        waveTicker?.invalidate()
        waveTicker = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.waveElapsed = min(60, self.waveElapsed + 1)
            self.refreshWaveOverlay()
            if self.waveElapsed >= 60 {
                self.pauseWaveRecording()
            }
        }
    }

    @objc private func pauseWaveRecording() {
        waveRecorder?.pause()
        waveTicker?.invalidate()
        refreshWaveOverlay()
    }

    @objc private func resetWaveRecording() {
        waveTicker?.invalidate()
        waveRecorder?.stop()
        if let waveFileURL {
            try? FileManager.default.removeItem(at: waveFileURL)
        }
        waveRecorder = nil
        waveFileURL = nil
        waveElapsed = 0
        refreshWaveOverlay()
    }

    @objc private func confirmWaveRecording() {
        pauseWaveRecording()
        guard let waveFileURL, waveElapsed > 0 else {
            onReefIssue?("Please record audio first.")
            return
        }
        onReefComplete?(SuliJoyWaveResonanceDraft(waveSandboxPath: waveFileURL.path, waveSeconds: waveElapsed, waveCreatedAt: Date()))
    }
}
