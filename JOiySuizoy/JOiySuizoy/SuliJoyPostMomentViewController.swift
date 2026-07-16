import AVFoundation
import UIKit

final class SuliJoyPostMomentViewController: SuliJoyBaseIslandViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let navRow = UIView()
    private let imageRow = UIStackView()
    private let contentTitle = UILabel()
    private let textContainer = UIView()
    private let textView = UITextView()
    private let placeholderLabel = UILabel()
    private let recordingButton = UIButton(type: .system)
    private let recordingIcon = UIImageView()
    private let recordingLabel = UILabel()
    private let recordingRetry = UIButton(type: .system)
    private let confirmButton = SuliJoyGradientButton(title: "Confirm")
    private var bottomConstraint: NSLayoutConstraint?
    private var selectedImageIndex = 0
    private var mediaPicks: [SuliJoyReefLocalMediaPick] = []
    private var mediaImages: [UIImage] = []
    private var imageSlots: [SuliJoyPostImageSlotView] = []
    private var recordingDraft: SuliJoyWaveRecordingDraft?

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        buildUI()
        registerKeyboardObservers()
        updateState()
    }

    @MainActor deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func buildUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        contentView.translatesAutoresizingMaskIntoConstraints = false

        configureNav()
        configureImageSlots()
        configureTextArea()
        configureRecordingRow()
        configureConfirm()

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [navRow, imageRow, contentTitle, textContainer, recordingButton, confirmButton].forEach { contentView.addSubview($0) }
        bottomConstraint = contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        bottomConstraint?.isActive = true

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),

            navRow.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 14),
            navRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            navRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            navRow.heightAnchor.constraint(equalToConstant: 44),

            imageRow.topAnchor.constraint(equalTo: navRow.bottomAnchor, constant: 24),
            imageRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            imageRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            imageRow.heightAnchor.constraint(equalTo: imageRow.widthAnchor, multiplier: 86.0 / 345.0),

            contentTitle.topAnchor.constraint(equalTo: imageRow.bottomAnchor, constant: 28),
            contentTitle.leadingAnchor.constraint(equalTo: imageRow.leadingAnchor),
            contentTitle.trailingAnchor.constraint(equalTo: imageRow.trailingAnchor),

            textContainer.topAnchor.constraint(equalTo: contentTitle.bottomAnchor, constant: 18),
            textContainer.leadingAnchor.constraint(equalTo: imageRow.leadingAnchor),
            textContainer.trailingAnchor.constraint(equalTo: imageRow.trailingAnchor),
            textContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 190),

            recordingButton.topAnchor.constraint(equalTo: textContainer.bottomAnchor, constant: 18),
            recordingButton.leadingAnchor.constraint(equalTo: imageRow.leadingAnchor),
            recordingButton.trailingAnchor.constraint(equalTo: imageRow.trailingAnchor),
            recordingButton.heightAnchor.constraint(equalToConstant: 54),

            confirmButton.leadingAnchor.constraint(equalTo: imageRow.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: imageRow.trailingAnchor),
            confirmButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -34)
        ])

        let softBottom = confirmButton.topAnchor.constraint(greaterThanOrEqualTo: recordingButton.bottomAnchor, constant: 84)
        softBottom.priority = .defaultHigh
        softBottom.isActive = true

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
        title.text = "Post"
        title.font = UIFont.systemFont(ofSize: 26, weight: .black)
        title.textColor = .suliInk
        title.textAlignment = .center

        navRow.addSubview(back)
        navRow.addSubview(title)
        NSLayoutConstraint.activate([
            back.leadingAnchor.constraint(equalTo: navRow.leadingAnchor),
            back.centerYAnchor.constraint(equalTo: navRow.centerYAnchor),
            back.widthAnchor.constraint(equalToConstant: 36),
            back.heightAnchor.constraint(equalToConstant: 36),
            title.centerXAnchor.constraint(equalTo: navRow.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: navRow.centerYAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: back.trailingAnchor, constant: 12)
        ])
    }

    private func configureImageSlots() {
        imageRow.translatesAutoresizingMaskIntoConstraints = false
        imageRow.axis = .horizontal
        imageRow.spacing = 10
        imageRow.distribution = .fillEqually
        for index in 0..<3 {
            let slot = SuliJoyPostImageSlotView(index: index)
            slot.onTap = { [weak self] slotIndex in
                self?.selectedImageIndex = slotIndex
                self?.presentPhotoChoice()
            }
            slot.onRemove = { [weak self] slotIndex in
                self?.removeMedia(at: slotIndex)
            }
            imageSlots.append(slot)
            imageRow.addArrangedSubview(slot)
        }
    }

    private func configureTextArea() {
        contentTitle.translatesAutoresizingMaskIntoConstraints = false
        contentTitle.text = "Content"
        contentTitle.font = UIFont.systemFont(ofSize: 22, weight: .black)
        contentTitle.textColor = .suliInk

        textContainer.translatesAutoresizingMaskIntoConstraints = false
        textContainer.backgroundColor = .white
        textContainer.layer.cornerRadius = 20
        textContainer.clipsToBounds = true

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textColor = .suliInk
        textView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textView.textContainerInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        textView.delegate = self

        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.text = "Say Something"
        placeholderLabel.textColor = UIColor(red: 0.68, green: 0.67, blue: 0.66, alpha: 1)
        placeholderLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        textContainer.addSubview(textView)
        textContainer.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: textContainer.topAnchor),
            textView.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: textContainer.bottomAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: textContainer.topAnchor, constant: 22),
            placeholderLabel.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor, constant: 25),
            placeholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: textContainer.trailingAnchor, constant: -20)
        ])
    }

    private func configureRecordingRow() {
        recordingButton.translatesAutoresizingMaskIntoConstraints = false
        recordingButton.backgroundColor = .white
        recordingButton.layer.cornerRadius = 27
        recordingButton.clipsToBounds = true
        recordingButton.addTarget(self, action: #selector(openRecorder), for: .touchUpInside)

        recordingIcon.translatesAutoresizingMaskIntoConstraints = false
        recordingIcon.image = UIImage(named: "sulijoy_post_record_mic")?.withRenderingMode(.alwaysOriginal)
        recordingIcon.contentMode = .scaleAspectFit
        recordingIcon.isUserInteractionEnabled = false

        recordingLabel.translatesAutoresizingMaskIntoConstraints = false
        recordingLabel.font = UIFont.systemFont(ofSize: 20, weight: .black)
        recordingLabel.textColor = .suliInk
        recordingLabel.isUserInteractionEnabled = false

        recordingRetry.translatesAutoresizingMaskIntoConstraints = false
        recordingRetry.setImage(UIImage(named: "sulijoy_post_record_retry")?.withRenderingMode(.alwaysOriginal), for: .normal)
        recordingRetry.addTarget(self, action: #selector(openRecorder), for: .touchUpInside)

        [recordingIcon, recordingLabel, recordingRetry].forEach { recordingButton.addSubview($0) }
        NSLayoutConstraint.activate([
            recordingIcon.leadingAnchor.constraint(equalTo: recordingButton.leadingAnchor, constant: 30),
            recordingIcon.centerYAnchor.constraint(equalTo: recordingButton.centerYAnchor),
            recordingIcon.widthAnchor.constraint(equalToConstant: 22),
            recordingIcon.heightAnchor.constraint(equalToConstant: 22),
            recordingLabel.leadingAnchor.constraint(equalTo: recordingIcon.trailingAnchor, constant: 14),
            recordingLabel.centerYAnchor.constraint(equalTo: recordingButton.centerYAnchor),
            recordingRetry.trailingAnchor.constraint(equalTo: recordingButton.trailingAnchor),
            recordingRetry.centerYAnchor.constraint(equalTo: recordingButton.centerYAnchor),
            recordingRetry.widthAnchor.constraint(equalToConstant: 48),
            recordingRetry.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func configureConfirm() {
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.addTarget(self, action: #selector(confirmPost), for: .touchUpInside)
    }

    private func updateState() {
        for index in 0..<imageSlots.count {
            if mediaImages.indices.contains(index) {
                imageSlots[index].configure(image: mediaImages[index])
            } else {
                imageSlots[index].configure(image: nil)
            }
        }
        placeholderLabel.isHidden = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        if let recordingDraft {
            recordingLabel.text = "\(recordingDraft.duration)s"
            recordingRetry.isHidden = false
        } else {
            recordingLabel.text = "Recording"
            recordingRetry.isHidden = true
        }
        let canPost = hasPostContent()
        confirmButton.isEnabled = canPost && !confirmButton.isLoading
        confirmButton.alpha = canPost ? 1 : 0.48
    }

    private func hasPostContent() -> Bool {
        !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !mediaPicks.isEmpty || recordingDraft != nil
    }

    private func presentPhotoChoice() {
        dismissKeyboard()
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sheet.addAction(UIAlertAction(title: "Photo", style: .default) { [weak self] _ in
                self?.openImagePicker(source: .camera)
            })
        }
        sheet.addAction(UIAlertAction(title: "Album", style: .default) { [weak self] _ in
            self?.openImagePicker(source: .photoLibrary)
        })
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        if let popover = sheet.popoverPresentationController {
            popover.sourceView = imageSlots[selectedImageIndex]
            popover.sourceRect = imageSlots[selectedImageIndex].bounds
        }
        present(sheet, animated: true)
    }

    private func openImagePicker(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            showToast("Camera is unavailable.")
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.mediaTypes = ["public.image"]
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        picker.dismiss(animated: true) { [weak self] in
            self?.storePickedImage(image)
        }
    }

    private func storePickedImage(_ image: UIImage) {
        guard let pick = saveImageToSandbox(image) else {
            showToast("Photo could not be saved.")
            return
        }
        if mediaPicks.indices.contains(selectedImageIndex) {
            mediaPicks[selectedImageIndex] = pick
            mediaImages[selectedImageIndex] = image
        } else if mediaPicks.count < 3 {
            mediaPicks.append(pick)
            mediaImages.append(image)
        }
        updateState()
    }

    private func removeMedia(at index: Int) {
        guard mediaPicks.indices.contains(index) else { return }
        mediaPicks.remove(at: index)
        mediaImages.remove(at: index)
        updateState()
    }

    private func saveImageToSandbox(_ image: UIImage) -> SuliJoyReefLocalMediaPick? {
        guard let data = image.jpegData(compressionQuality: 0.86) else { return nil }
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("SuliJoyPostMedia", isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let fileURL = directory.appendingPathComponent("shore_photo_\(UUID().uuidString).jpg")
        do {
            try data.write(to: fileURL, options: .atomic)
            return SuliJoyReefLocalMediaPick(localPath: fileURL.path, caption: "Island style photo")
        } catch {
            return nil
        }
    }

    @objc private func openRecorder() {
        dismissKeyboard()
        let recorder = SuliJoyWaveRecorderOverlayView(existingDraft: recordingDraft)
        recorder.onCancel = { [weak recorder] in
            recorder?.removeFromSuperview()
        }
        recorder.onComplete = { [weak self, weak recorder] draft in
            self?.recordingDraft = draft
            self?.updateState()
            recorder?.removeFromSuperview()
        }
        recorder.onError = { [weak self, weak recorder] message in
            self?.showToast(message)
            recorder?.removeFromSuperview()
        }
        recorder.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recorder)
        recorder.suliPinEdges(to: view)
    }

    @objc private func confirmPost() {
        guard hasPostContent() else {
            showToast("Please add content, photos, or audio.")
            return
        }
        let draft = SuliJoyShoreDraftMoment(
            body: textView.text,
            mediaPicks: mediaPicks,
            audioDraft: recordingDraft
        )
        confirmButton.isLoading = true
        updateState()
        SuliJoyCoveMockService.shared.publishShoreMoment(draft: draft) { [weak self] result in
            guard let self else { return }
            self.confirmButton.isLoading = false
            self.updateState()
            guard result.code == 200 else {
                self.showToast(result.message)
                return
            }
            NotificationCenter.default.post(name: .suliJoyShoreMomentPublished, object: result.data)
            self.showToast(result.message)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self.tabBarController?.selectedIndex = 1
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        updateState()
    }

    private func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let overlap = max(0, frame.height - view.safeAreaInsets.bottom)
        scrollView.contentInset.bottom = overlap + 22
        scrollView.scrollIndicatorInsets.bottom = overlap + 22
        let visible = textContainer.convert(textContainer.bounds, to: scrollView)
        scrollView.scrollRectToVisible(visible.insetBy(dx: 0, dy: -24), animated: true)
    }

    @objc private func keyboardWillHide(_ note: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

private final class SuliJoyPostImageSlotView: UIControl {
    var onTap: ((Int) -> Void)?
    var onRemove: ((Int) -> Void)?
    private let index: Int
    private let imageView = UIImageView()
    private let cameraView = UIImageView()
    private let removeButton = UIButton(type: .system)

    init(index: Int) {
        self.index = index
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 13
        clipsToBounds = true
        addTarget(self, action: #selector(tapped), for: .touchUpInside)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.image = UIImage(named: "sulijoy_post_photo_slot_camera")?.withRenderingMode(.alwaysOriginal)
        cameraView.contentMode = .scaleAspectFit
        cameraView.isUserInteractionEnabled = false

        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.setImage(UIImage(named: "sulijoy_post_media_remove_mark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)

        [imageView, cameraView, removeButton].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cameraView.centerXAnchor.constraint(equalTo: centerXAnchor),
            cameraView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cameraView.widthAnchor.constraint(equalToConstant: 46),
            cameraView.heightAnchor.constraint(equalToConstant: 46),
            removeButton.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            removeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            removeButton.widthAnchor.constraint(equalToConstant: 30),
            removeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        configure(image: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(image: UIImage?) {
        imageView.image = image
        imageView.isHidden = image == nil
        cameraView.isHidden = image != nil
        removeButton.isHidden = image == nil
    }

    @objc private func tapped() {
        onTap?(index)
    }

    @objc private func removeTapped() {
        onRemove?(index)
    }
}

private final class SuliJoyWaveRecorderOverlayView: UIView, AVAudioRecorderDelegate {
    var onCancel: (() -> Void)?
    var onComplete: ((SuliJoyWaveRecordingDraft) -> Void)?
    var onError: ((String) -> Void)?
    private let playButton = UIButton(type: .system)
    private let pauseButton = UIButton(type: .system)
    private let timerLabel = UILabel()
    private let pauseTimerLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    private let doneButton = UIButton(type: .system)
    private var recorder: AVAudioRecorder?
    private var timer: Timer?
    private var elapsed = 0
    private var fileURL: URL?

    init(existingDraft: SuliJoyWaveRecordingDraft?) {
        super.init(frame: .zero)
        if let existingDraft {
            elapsed = existingDraft.duration
            fileURL = URL(fileURLWithPath: existingDraft.localPath)
        }
        buildUI()
        updateUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func buildUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.48)

        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.backgroundColor = UIColor.white.withAlphaComponent(0.70)
        playButton.layer.cornerRadius = 70
        playButton.setImage(UIImage(named: "sulijoy_post_record_play")?.withRenderingMode(.alwaysOriginal), for: .normal)
        playButton.addTarget(self, action: #selector(startOrResume), for: .touchUpInside)

        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.backgroundColor = UIColor.white.withAlphaComponent(0.70)
        pauseButton.layer.cornerRadius = 70
        pauseButton.setImage(UIImage(named: "sulijoy_post_record_pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
        pauseButton.addTarget(self, action: #selector(pauseRecording), for: .touchUpInside)

        [timerLabel, pauseTimerLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 16, weight: .black)
            $0.textAlignment = .center
        }

        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.backgroundColor = UIColor(red: 1, green: 0.29, blue: 0.29, alpha: 1)
        retryButton.layer.cornerRadius = 28
        retryButton.setImage(UIImage(systemName: "plus"), for: .normal)
        retryButton.tintColor = .white
        retryButton.addTarget(self, action: #selector(resetRecording), for: .touchUpInside)

        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.backgroundColor = UIColor(red: 0.28, green: 0.90, blue: 0.22, alpha: 1)
        doneButton.layer.cornerRadius = 28
        doneButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        doneButton.tintColor = .white
        doneButton.addTarget(self, action: #selector(confirmRecording), for: .touchUpInside)

        [playButton, timerLabel, pauseButton, pauseTimerLabel, retryButton, doneButton].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -108),
            playButton.widthAnchor.constraint(equalToConstant: 140),
            playButton.heightAnchor.constraint(equalToConstant: 140),
            timerLabel.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 12),
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            pauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            pauseButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 48),
            pauseButton.widthAnchor.constraint(equalToConstant: 140),
            pauseButton.heightAnchor.constraint(equalToConstant: 140),
            pauseTimerLabel.topAnchor.constraint(equalTo: pauseButton.bottomAnchor, constant: 12),
            pauseTimerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            retryButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: -92),
            retryButton.topAnchor.constraint(equalTo: pauseTimerLabel.bottomAnchor, constant: 36),
            retryButton.widthAnchor.constraint(equalToConstant: 56),
            retryButton.heightAnchor.constraint(equalToConstant: 56),
            doneButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: 92),
            doneButton.centerYAnchor.constraint(equalTo: retryButton.centerYAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 56),
            doneButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func updateUI() {
        let time = formattedTime()
        timerLabel.text = time
        pauseTimerLabel.text = time
        let hasRecording = elapsed > 0 || fileURL != nil
        retryButton.isHidden = !hasRecording
        doneButton.isHidden = !hasRecording
    }

    private func formattedTime() -> String {
        "0:\(String(format: "%02d", elapsed))/0:60"
    }

    @objc private func startOrResume() {
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
            DispatchQueue.main.async {
                guard let self else { return }
                guard granted else {
                    self.onError?("Microphone permission is required.")
                    return
                }
                self.startRecorderIfNeeded()
                self.recorder?.record()
                self.startTimer()
            }
        }
    }

    private func startRecorderIfNeeded() {
        if recorder != nil { return }
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("SuliJoyPostAudio", isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let url = fileURL ?? directory.appendingPathComponent("shore_audio_\(UUID().uuidString).m4a")
        fileURL = url
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, mode: .default)
        try? session.setActive(true)
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]
        do {
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.delegate = self
            recorder?.prepareToRecord()
        } catch {
            onError?("Recorder could not start.")
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.elapsed = min(60, self.elapsed + 1)
            self.updateUI()
            if self.elapsed >= 60 {
                self.pauseRecording()
            }
        }
    }

    @objc private func pauseRecording() {
        recorder?.pause()
        timer?.invalidate()
        updateUI()
    }

    @objc private func resetRecording() {
        timer?.invalidate()
        recorder?.stop()
        if let fileURL {
            try? FileManager.default.removeItem(at: fileURL)
        }
        recorder = nil
        fileURL = nil
        elapsed = 0
        updateUI()
    }

    @objc private func confirmRecording() {
        pauseRecording()
        guard let fileURL, elapsed > 0 else {
            onError?("Please record audio first.")
            return
        }
        onComplete?(SuliJoyWaveRecordingDraft(localPath: fileURL.path, duration: elapsed, createdAt: Date()))
    }
}
