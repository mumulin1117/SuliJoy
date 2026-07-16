import AVFoundation
import UIKit
import UniformTypeIdentifiers

final class SuliJoyPostClipViewController: SuliJoyBaseIslandViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let videoCard = UIControl()
    private let videoImageView = UIImageView()
    private let addImageView = UIImageView()
    private let removeVideoButton = UIButton(type: .system)
    private let textCard = UIView()
    private let textView = UITextView()
    private let placeholderLabel = UILabel()
    private let confirmButton = SuliJoyGradientButton(title: "Confirm")

    private var selectedMedia: SuliJoyLagoonClipMedia?
    private var activeInputView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        configureLayout()
        bindKeyboard()
        updateConfirmState()
    }

    @MainActor deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func configureLayout() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        let backButton = UIButton(type: .system)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .suliInk
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Post Clip"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .black)
        titleLabel.textColor = .suliInk
        titleLabel.textAlignment = .center

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [backButton, titleLabel].forEach { view.addSubview($0) }

        videoCard.translatesAutoresizingMaskIntoConstraints = false
        videoCard.backgroundColor = .white.withAlphaComponent(0.94)
        videoCard.layer.cornerRadius = 28
        videoCard.layer.masksToBounds = true
        videoCard.addTarget(self, action: #selector(openVideoPicker), for: .touchUpInside)

        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        videoImageView.contentMode = .scaleAspectFill
        videoImageView.clipsToBounds = true
        videoImageView.isHidden = true

        addImageView.translatesAutoresizingMaskIntoConstraints = false
        addImageView.image = UIImage(systemName: "plus.circle")
        addImageView.tintColor = UIColor(red: 0.78, green: 0.70, blue: 0.96, alpha: 0.48)
        addImageView.contentMode = .scaleAspectFit

        removeVideoButton.translatesAutoresizingMaskIntoConstraints = false
        removeVideoButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        removeVideoButton.tintColor = .suliInk
        removeVideoButton.backgroundColor = .white.withAlphaComponent(0.85)
        removeVideoButton.layer.cornerRadius = 15
        removeVideoButton.isHidden = true
        removeVideoButton.addTarget(self, action: #selector(removeVideo), for: .touchUpInside)

        videoCard.addSubview(videoImageView)
        videoCard.addSubview(addImageView)
        videoCard.addSubview(removeVideoButton)

        let contentLabel = UILabel()
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.text = "Content"
        contentLabel.font = UIFont.systemFont(ofSize: 22, weight: .black)
        contentLabel.textColor = .suliInk

        textCard.translatesAutoresizingMaskIntoConstraints = false
        textCard.backgroundColor = .white.withAlphaComponent(0.94)
        textCard.layer.cornerRadius = 22
        textCard.layer.masksToBounds = true

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textView.textColor = .suliInk
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 18, left: 18, bottom: 70, right: 18)
        textView.textContainer.lineFragmentPadding = 0

        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.text = "Say Something"
        placeholderLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        placeholderLabel.textColor = UIColor(red: 0.70, green: 0.69, blue: 0.67, alpha: 1)
        placeholderLabel.isUserInteractionEnabled = false

        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.addTarget(self, action: #selector(confirmPost), for: .touchUpInside)
        textCard.addSubview(textView)
        textCard.addSubview(placeholderLabel)
        textCard.addSubview(confirmButton)

        [videoCard, contentLabel, textCard].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: backButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -74),

            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 18),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            videoCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            videoCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            videoCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            videoCard.heightAnchor.constraint(greaterThanOrEqualTo: videoCard.widthAnchor, multiplier: 1.05),
            videoCard.heightAnchor.constraint(lessThanOrEqualTo: videoCard.widthAnchor, multiplier: 1.34),

            videoImageView.topAnchor.constraint(equalTo: videoCard.topAnchor),
            videoImageView.leadingAnchor.constraint(equalTo: videoCard.leadingAnchor),
            videoImageView.trailingAnchor.constraint(equalTo: videoCard.trailingAnchor),
            videoImageView.bottomAnchor.constraint(equalTo: videoCard.bottomAnchor),

            addImageView.centerXAnchor.constraint(equalTo: videoCard.centerXAnchor),
            addImageView.centerYAnchor.constraint(equalTo: videoCard.centerYAnchor),
            addImageView.widthAnchor.constraint(equalToConstant: 78),
            addImageView.heightAnchor.constraint(equalToConstant: 78),

            removeVideoButton.topAnchor.constraint(equalTo: videoCard.topAnchor, constant: 12),
            removeVideoButton.trailingAnchor.constraint(equalTo: videoCard.trailingAnchor, constant: -12),
            removeVideoButton.widthAnchor.constraint(equalToConstant: 30),
            removeVideoButton.heightAnchor.constraint(equalToConstant: 30),

            contentLabel.topAnchor.constraint(equalTo: videoCard.bottomAnchor, constant: 26),
            contentLabel.leadingAnchor.constraint(equalTo: videoCard.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: videoCard.trailingAnchor),

            textCard.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 12),
            textCard.leadingAnchor.constraint(equalTo: videoCard.leadingAnchor),
            textCard.trailingAnchor.constraint(equalTo: videoCard.trailingAnchor),
            textCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            textCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 210),

            textView.topAnchor.constraint(equalTo: textCard.topAnchor),
            textView.leadingAnchor.constraint(equalTo: textCard.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: textCard.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: textCard.bottomAnchor),

            placeholderLabel.topAnchor.constraint(equalTo: textCard.topAnchor, constant: 20),
            placeholderLabel.leadingAnchor.constraint(equalTo: textCard.leadingAnchor, constant: 34),
            placeholderLabel.trailingAnchor.constraint(equalTo: textCard.trailingAnchor, constant: -24),

            confirmButton.leadingAnchor.constraint(equalTo: textCard.leadingAnchor, constant: 22),
            confirmButton.trailingAnchor.constraint(equalTo: textCard.trailingAnchor, constant: -22),
            confirmButton.bottomAnchor.constraint(equalTo: textCard.bottomAnchor, constant: -24)
        ])
    }

    private func updateConfirmState() {
        let hasCaption = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let canPost = hasCaption || selectedMedia != nil
        confirmButton.isEnabled = canPost && !confirmButton.isLoading
        confirmButton.alpha = canPost ? 1 : 0.48
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    private func bindKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = view.convert(frame, from: nil).intersection(view.bounds).height
        let bottom = max(0, keyboardHeight - view.safeAreaInsets.bottom) + 18
        scrollView.contentInset.bottom = bottom
        scrollView.scrollIndicatorInsets.bottom = bottom
        if let activeInputView {
            let rect = activeInputView.convert(activeInputView.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect.insetBy(dx: 0, dy: -28), animated: true)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func openVideoPicker() {
        dismissKeyboard()
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sheet.addAction(UIAlertAction(title: "Record Video", style: .default) { [weak self] _ in
                self?.presentVideoPicker(source: .camera)
            })
        }
        sheet.addAction(UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.presentVideoPicker(source: .photoLibrary)
        })
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.popoverPresentationController?.sourceView = videoCard
        sheet.popoverPresentationController?.sourceRect = videoCard.bounds
        present(sheet, animated: true)
    }

    private func presentVideoPicker(source: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else {
            showToast("Video source unavailable.")
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.mediaTypes = [UTType.movie.identifier]
        picker.videoQuality = .typeMedium
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let sourceURL = info[.mediaURL] as? URL else {
            picker.dismiss(animated: true) { [weak self] in
                self?.showToast("Video unavailable.")
            }
            return
        }
        do {
            let saved = try saveVideoToSandbox(from: sourceURL)
            selectedMedia = saved
            if let coverPath = saved.coverImagePath {
                videoImageView.image = UIImage(contentsOfFile: coverPath)
                videoImageView.isHidden = false
            }
            addImageView.image = UIImage(systemName: "play.circle.fill")
            addImageView.tintColor = .white.withAlphaComponent(0.92)
            removeVideoButton.isHidden = false
            updateConfirmState()
            picker.dismiss(animated: true)
        } catch {
            picker.dismiss(animated: true) { [weak self] in
                self?.showToast("Could not save video.")
            }
        }
    }

    private func saveVideoToSandbox(from sourceURL: URL) throws -> SuliJoyLagoonClipMedia {
        let directory = try Self.localClipDirectory()
        let ext = sourceURL.pathExtension.isEmpty ? "mov" : sourceURL.pathExtension
        let videoURL = directory.appendingPathComponent("sulijoy_clip_local_\(UUID().uuidString).\(ext)")
        if FileManager.default.fileExists(atPath: videoURL.path) {
            try FileManager.default.removeItem(at: videoURL)
        }
        try FileManager.default.copyItem(at: sourceURL, to: videoURL)
        let asset = AVURLAsset(url: videoURL)
        let duration = CMTimeGetSeconds(asset.duration)
        let coverURL = directory.appendingPathComponent("sulijoy_clip_cover_\(UUID().uuidString).jpg")
        let coverPath = try? generateCoverImage(for: asset, to: coverURL)
        return SuliJoyLagoonClipMedia(
            localVideoPath: videoURL.path,
            coverImagePath: coverPath,
            duration: duration.isFinite ? duration : nil
        )
    }

    private func generateCoverImage(for asset: AVURLAsset, to destination: URL) throws -> String {
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 900, height: 900)
        let cgImage = try generator.copyCGImage(at: CMTime(seconds: 0.1, preferredTimescale: 600), actualTime: nil)
        let image = UIImage(cgImage: cgImage)
        guard let data = image.jpegData(compressionQuality: 0.82) else {
            throw NSError(domain: "SuliJoyPostClip", code: 1)
        }
        try data.write(to: destination, options: [.atomic])
        return destination.path
    }

    private static func localClipDirectory() throws -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? FileManager.default.temporaryDirectory
        let directory = documents.appendingPathComponent("SuliJoyLocalClips", isDirectory: true)
        if !FileManager.default.fileExists(atPath: directory.path) {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        }
        return directory
    }

    @objc private func removeVideo() {
        selectedMedia = nil
        videoImageView.image = nil
        videoImageView.isHidden = true
        addImageView.image = UIImage(systemName: "plus.circle")
        addImageView.tintColor = UIColor(red: 0.78, green: 0.70, blue: 0.96, alpha: 0.48)
        removeVideoButton.isHidden = true
        updateConfirmState()
    }

    @objc private func confirmPost() {
        let caption = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !caption.isEmpty || selectedMedia != nil else {
            showToast("Please add a video or content.")
            return
        }
        confirmButton.isLoading = true
        let draft = SuliJoyReefClipDraft(caption: caption, media: selectedMedia)
        SuliJoyCoveMockService.shared.publishReefClip(draft: draft) { [weak self] envelope in
            DispatchQueue.main.async {
                guard let self else { return }
                self.confirmButton.isLoading = false
                self.updateConfirmState()
                guard envelope.code == 200 else {
                    self.showToast(envelope.message)
                    return
                }
                NotificationCenter.default.post(name: .suliJoyShellClipPublished, object: envelope.data)
                self.showToast("Clip posted.")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.returnToShortsTab()
                }
            }
        }
    }

    private func returnToShortsTab() {
        guard let tabBarController else {
            navigationController?.popViewController(animated: true)
            return
        }
        navigationController?.popToRootViewController(animated: false)
        tabBarController.selectedIndex = 3
        if let controllers = tabBarController.viewControllers, controllers.indices.contains(3),
           let shortsNav = controllers[3] as? UINavigationController {
            shortsNav.popToRootViewController(animated: false)
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        activeInputView = textCard
    }

    func textViewDidChange(_ textView: UITextView) {
        updateConfirmState()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        activeInputView = nil
    }
}
