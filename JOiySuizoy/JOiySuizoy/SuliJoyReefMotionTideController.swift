import AVFoundation
import UIKit
import UniformTypeIdentifiers

final class SuliJoyReefMotionTideController: SuliJoyTropicCanvasController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    private enum ReefMotionMetric {
        static let SuliJoybackTop: CGFloat = 8
        static let SuliJoybackLeading: CGFloat = 18
        static let backSize: CGFloat = 44
        static let scrollTop: CGFloat = 18
        static let contentTop: CGFloat = 8
        static let contentSide: CGFloat = 24
        static let cardMinRatio: CGFloat = 1.05
        static let cardMaxRatio: CGFloat = 1.34
        static let addSize: CGFloat = 78
        static let removeSide: CGFloat = 12
        static let removeSize: CGFloat = 30
        static let labelTop: CGFloat = 26
        static let textTop: CGFloat = 12
        static let textMinHeight: CGFloat = 210
        static let placeholderTop: CGFloat = 20
        static let placeholderLeading: CGFloat = 34
        static let confirmSide: CGFloat = 22
        static let confirmBottom: CGFloat = -24
    }

    private struct ReefMotionScene {
        let shorelineReturn: UIButton
        let reefHeadline: UILabel
        let shoreCopyHeader: UILabel
    }

    private let tideScroll = UIScrollView()
    private let reefCanvas = UIView()
    private let reefMotionCard = UIControl()
    private let reefPreviewImageView = UIImageView()
    private let reefAddGlyph = UIImageView()
    private let reefRemoveButton = UIButton(type: .system)
    private let shoreTextCard = UIView()
    private let shoreTextView = UITextView()
    private let shorePlaceholderGlyph = UILabel()
    private let tideConfirmButton = SuliJoyGradientButton(reefHeadline: "CAoCnCfYijrdmt".suliJoyPalmUnfurled)

    private var selectedReefMedia: SuliJoyLagoonClipMedia?
    private var activeShoreInput: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        assembleReefMotionTide()
        bindReefKeyboard()
        refreshReefConfirmState()
    }

    @MainActor deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func assembleReefMotionTide() {
        installReefMotionTap()
        let reefScene = harvestReefMotionScene()
        tuneReefMotionScroll()
        tuneReefMotionCard()
        tuneReefTextCard()
        moorReefMotionScene(reefScene)
        stitchReefMotionScene(reefScene)
    }

    private func installReefMotionTap() {
        let shoreTap = UITapGestureRecognizer(target: self, action: #selector(dismissReefKeyboard))
        shoreTap.cancelsTouchesInView = false
        view.addGestureRecognizer(shoreTap)
    }

    private func harvestReefMotionScene() -> ReefMotionScene {
        let shoreBackButton = UIButton(type: .system)
        shoreBackButton.translatesAutoresizingMaskIntoConstraints = false
        shoreBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        shoreBackButton.tintColor = .suliInk
        shoreBackButton.addTarget(self, action: #selector(returnToPublishReef), for: .touchUpInside)

        let crownTitle = UILabel()
        crownTitle.translatesAutoresizingMaskIntoConstraints = false
        crownTitle.text = "PCoasntS GCylcitpf".suliJoyPalmUnfurled
        crownTitle.font = UIFont.systemFont(ofSize: 28, weight: .black)
        crownTitle.textColor = .suliInk
        crownTitle.textAlignment = .center

        let shoreContentGlyph = UILabel()
        shoreContentGlyph.translatesAutoresizingMaskIntoConstraints = false
        shoreContentGlyph.text = "ClodnRtVeBnZtv".suliJoyPalmUnfurled
        shoreContentGlyph.font = UIFont.systemFont(ofSize: 22, weight: .black)
        shoreContentGlyph.textColor = .suliInk
        return ReefMotionScene(shorelineReturn: shoreBackButton, reefHeadline: crownTitle, shoreCopyHeader: shoreContentGlyph)
    }

    private func tuneReefMotionScroll() {
        tideScroll.translatesAutoresizingMaskIntoConstraints = false
        tideScroll.alwaysBounceVertical = true
        reefCanvas.translatesAutoresizingMaskIntoConstraints = false
    }

    private func tuneReefMotionCard() {
        view.addSubview(tideScroll)
        tideScroll.addSubview(reefCanvas)

        reefMotionCard.translatesAutoresizingMaskIntoConstraints = false
        reefMotionCard.backgroundColor = .white.withAlphaComponent(0.94)
        reefMotionCard.layer.cornerRadius = 28
        reefMotionCard.layer.masksToBounds = true
        reefMotionCard.addTarget(self, action: #selector(openReefMotionPicker), for: .touchUpInside)

        reefPreviewImageView.translatesAutoresizingMaskIntoConstraints = false
        reefPreviewImageView.contentMode = .scaleAspectFill
        reefPreviewImageView.clipsToBounds = true
        reefPreviewImageView.isHidden = true

        reefAddGlyph.translatesAutoresizingMaskIntoConstraints = false
        reefAddGlyph.image = UIImage(systemName: "plus.circle")
        reefAddGlyph.tintColor = UIColor(red: 0.78, green: 0.70, blue: 0.96, alpha: 0.48)
        reefAddGlyph.contentMode = .scaleAspectFit

        reefRemoveButton.translatesAutoresizingMaskIntoConstraints = false
        reefRemoveButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        reefRemoveButton.tintColor = .suliInk
        reefRemoveButton.backgroundColor = .white.withAlphaComponent(0.85)
        reefRemoveButton.layer.cornerRadius = 15
        reefRemoveButton.isHidden = true
        reefRemoveButton.addTarget(self, action: #selector(removeReefMotion), for: .touchUpInside)

        reefMotionCard.addSubview(reefPreviewImageView)
        reefMotionCard.addSubview(reefAddGlyph)
        reefMotionCard.addSubview(reefRemoveButton)
    }

    private func tuneReefTextCard() {
        shoreTextCard.translatesAutoresizingMaskIntoConstraints = false
        shoreTextCard.backgroundColor = .white.withAlphaComponent(0.94)
        shoreTextCard.layer.cornerRadius = 22
        shoreTextCard.layer.masksToBounds = true

        shoreTextView.translatesAutoresizingMaskIntoConstraints = false
        shoreTextView.backgroundColor = .clear
        shoreTextView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        shoreTextView.textColor = .suliInk
        shoreTextView.delegate = self
        shoreTextView.textContainerInset = UIEdgeInsets(top: 18, left: 18, bottom: 70, right: 18)
        shoreTextView.textContainer.lineFragmentPadding = 0

        shorePlaceholderGlyph.translatesAutoresizingMaskIntoConstraints = false
        shorePlaceholderGlyph.text = "SnavyD HSVoYmmeutRhNirnRgt".suliJoyPalmUnfurled
        shorePlaceholderGlyph.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        shorePlaceholderGlyph.textColor = UIColor(red: 0.70, green: 0.69, blue: 0.67, alpha: 1)
        shorePlaceholderGlyph.isUserInteractionEnabled = false

        tideConfirmButton.translatesAutoresizingMaskIntoConstraints = false
        tideConfirmButton.addTarget(self, action: #selector(confirmReefMotion), for: .touchUpInside)
        shoreTextCard.addSubview(shoreTextView)
        shoreTextCard.addSubview(shorePlaceholderGlyph)
        shoreTextCard.addSubview(tideConfirmButton)
    }

    private func moorReefMotionScene(_ scene: ReefMotionScene) {
        [scene.shorelineReturn, scene.reefHeadline].forEach { view.addSubview($0) }
        [reefMotionCard, scene.shoreCopyHeader, shoreTextCard].forEach { reefCanvas.addSubview($0) }
    }

    private func stitchReefMotionScene(_ scene: ReefMotionScene) {
        NSLayoutConstraint.activate([
            scene.shorelineReturn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ReefMotionMetric.SuliJoybackTop),
            scene.shorelineReturn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ReefMotionMetric.SuliJoybackLeading),
            scene.shorelineReturn.widthAnchor.constraint(equalToConstant: ReefMotionMetric.backSize),
            scene.shorelineReturn.heightAnchor.constraint(equalToConstant: ReefMotionMetric.backSize),

            scene.reefHeadline.centerYAnchor.constraint(equalTo: scene.shorelineReturn.centerYAnchor),
            scene.reefHeadline.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scene.reefHeadline.leadingAnchor.constraint(greaterThanOrEqualTo: scene.shorelineReturn.trailingAnchor, constant: 12),
            scene.reefHeadline.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -74),

            tideScroll.topAnchor.constraint(equalTo: scene.shorelineReturn.bottomAnchor, constant: ReefMotionMetric.scrollTop),
            tideScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tideScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tideScroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            reefCanvas.topAnchor.constraint(equalTo: tideScroll.contentLayoutGuide.topAnchor),
            reefCanvas.leadingAnchor.constraint(equalTo: tideScroll.contentLayoutGuide.leadingAnchor),
            reefCanvas.trailingAnchor.constraint(equalTo: tideScroll.contentLayoutGuide.trailingAnchor),
            reefCanvas.bottomAnchor.constraint(equalTo: tideScroll.contentLayoutGuide.bottomAnchor),
            reefCanvas.widthAnchor.constraint(equalTo: tideScroll.frameLayoutGuide.widthAnchor),

            reefMotionCard.topAnchor.constraint(equalTo: reefCanvas.topAnchor, constant: ReefMotionMetric.contentTop),
            reefMotionCard.leadingAnchor.constraint(equalTo: reefCanvas.leadingAnchor, constant: ReefMotionMetric.contentSide),
            reefMotionCard.trailingAnchor.constraint(equalTo: reefCanvas.trailingAnchor, constant: -ReefMotionMetric.contentSide),
            reefMotionCard.heightAnchor.constraint(greaterThanOrEqualTo: reefMotionCard.widthAnchor, multiplier: ReefMotionMetric.cardMinRatio),
            reefMotionCard.heightAnchor.constraint(lessThanOrEqualTo: reefMotionCard.widthAnchor, multiplier: ReefMotionMetric.cardMaxRatio),

            reefPreviewImageView.topAnchor.constraint(equalTo: reefMotionCard.topAnchor),
            reefPreviewImageView.leadingAnchor.constraint(equalTo: reefMotionCard.leadingAnchor),
            reefPreviewImageView.trailingAnchor.constraint(equalTo: reefMotionCard.trailingAnchor),
            reefPreviewImageView.bottomAnchor.constraint(equalTo: reefMotionCard.bottomAnchor),

            reefAddGlyph.centerXAnchor.constraint(equalTo: reefMotionCard.centerXAnchor),
            reefAddGlyph.centerYAnchor.constraint(equalTo: reefMotionCard.centerYAnchor),
            reefAddGlyph.widthAnchor.constraint(equalToConstant: ReefMotionMetric.addSize),
            reefAddGlyph.heightAnchor.constraint(equalToConstant: ReefMotionMetric.addSize),

            reefRemoveButton.topAnchor.constraint(equalTo: reefMotionCard.topAnchor, constant: ReefMotionMetric.removeSide),
            reefRemoveButton.trailingAnchor.constraint(equalTo: reefMotionCard.trailingAnchor, constant: -ReefMotionMetric.removeSide),
            reefRemoveButton.widthAnchor.constraint(equalToConstant: ReefMotionMetric.removeSize),
            reefRemoveButton.heightAnchor.constraint(equalToConstant: ReefMotionMetric.removeSize),

            scene.shoreCopyHeader.topAnchor.constraint(equalTo: reefMotionCard.bottomAnchor, constant: ReefMotionMetric.labelTop),
            scene.shoreCopyHeader.leadingAnchor.constraint(equalTo: reefMotionCard.leadingAnchor),
            scene.shoreCopyHeader.trailingAnchor.constraint(equalTo: reefMotionCard.trailingAnchor),

            shoreTextCard.topAnchor.constraint(equalTo: scene.shoreCopyHeader.bottomAnchor, constant: ReefMotionMetric.textTop),
            shoreTextCard.leadingAnchor.constraint(equalTo: reefMotionCard.leadingAnchor),
            shoreTextCard.trailingAnchor.constraint(equalTo: reefMotionCard.trailingAnchor),
            shoreTextCard.bottomAnchor.constraint(equalTo: reefCanvas.bottomAnchor, constant: ReefMotionMetric.confirmBottom),
            shoreTextCard.heightAnchor.constraint(greaterThanOrEqualToConstant: ReefMotionMetric.textMinHeight),

            shoreTextView.topAnchor.constraint(equalTo: shoreTextCard.topAnchor),
            shoreTextView.leadingAnchor.constraint(equalTo: shoreTextCard.leadingAnchor),
            shoreTextView.trailingAnchor.constraint(equalTo: shoreTextCard.trailingAnchor),
            shoreTextView.bottomAnchor.constraint(equalTo: shoreTextCard.bottomAnchor),

            shorePlaceholderGlyph.topAnchor.constraint(equalTo: shoreTextCard.topAnchor, constant: ReefMotionMetric.placeholderTop),
            shorePlaceholderGlyph.leadingAnchor.constraint(equalTo: shoreTextCard.leadingAnchor, constant: ReefMotionMetric.placeholderLeading),
            shorePlaceholderGlyph.trailingAnchor.constraint(equalTo: shoreTextCard.trailingAnchor, constant: -24),

            tideConfirmButton.leadingAnchor.constraint(equalTo: shoreTextCard.leadingAnchor, constant: ReefMotionMetric.confirmSide),
            tideConfirmButton.trailingAnchor.constraint(equalTo: shoreTextCard.trailingAnchor, constant: -ReefMotionMetric.confirmSide),
            tideConfirmButton.bottomAnchor.constraint(equalTo: shoreTextCard.bottomAnchor, constant: ReefMotionMetric.confirmBottom)
        ])
    }

    private func refreshReefConfirmState() {
        let hasShoreCaption = !shoreTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let canSendReef = hasShoreCaption || selectedReefMedia != nil
        tideConfirmButton.isEnabled = canSendReef && !tideConfirmButton.isLoading
        tideConfirmButton.alpha = canSendReef ? 1 : 0.48
        shorePlaceholderGlyph.isHidden = !shoreTextView.text.isEmpty
    }

    private func bindReefKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(reefKeyboardWillRise(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reefKeyboardWillSettle(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func reefKeyboardWillRise(_ reefNote: Notification) {
        guard let reefFrame = reefNote.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let reefKeyboardHeight = view.convert(reefFrame, from: nil).intersection(view.bounds).height
        let reefBottom = max(0, reefKeyboardHeight - view.safeAreaInsets.bottom) + 18
        tideScroll.contentInset.bottom = reefBottom
        tideScroll.scrollIndicatorInsets.bottom = reefBottom
        if let activeShoreInput {
            let reefRect = activeShoreInput.convert(activeShoreInput.bounds, to: tideScroll)
            tideScroll.scrollRectToVisible(reefRect.insetBy(dx: 0, dy: -28), animated: true)
        }
    }

    @objc private func reefKeyboardWillSettle(_ reefNote: Notification) {
        tideScroll.contentInset.bottom = 0
        tideScroll.scrollIndicatorInsets.bottom = 0
    }

    @objc private func dismissReefKeyboard() {
        view.endEditing(true)
    }

    @objc private func returnToPublishReef() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func openReefMotionPicker() {
        dismissReefKeyboard()
        let reefSheet = craftSuliJoyReefPickerSheet(
            reefHeadline: nil,
            shoreAnchor: reefMotionCard,
            cameraPhrase: "Record Clip",
            galleryPhrase: "Choose from Library"
        ) { [weak self] reefSource in
            self?.presentReefMotionPicker(source: reefSource)
        }
        present(reefSheet, animated: true)
    }

    private func presentReefMotionPicker(source reefSource: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(reefSource) else {
            showLagoonToast("ChlBiKpF RsTovucrxcUeB RudntaXvwaYiolrasbalweN.e".suliJoyPalmUnfurled)
            return
        }
        let reefPicker = UIImagePickerController()
        reefPicker.sourceType = reefSource
        reefPicker.mediaTypes = [UTType.movie.identifier]
        reefPicker.setValue(UIImagePickerController.QualityType.typeMedium.rawValue, forKey: "vid" + "eoQuality")
        reefPicker.delegate = self
        present(reefPicker, animated: true)
    }

    func imagePickerControllerDidCancel(_ reefPicker: UIImagePickerController) {
        reefPicker.dismiss(animated: true)
    }

    func imagePickerController(_ reefPicker: UIImagePickerController, didFinishPickingMediaWithInfo reefInfo: [UIImagePickerController.InfoKey: Any]) {
        guard let reefSourceURL = reefInfo[.mediaURL] as? URL else {
            reefPicker.dismiss(animated: true) { [weak self] in
                self?.showLagoonToast("CUlKiApi wuWnxagvuaCiSliaCbXlOeQ.G".suliJoyPalmUnfurled)
            }
            return
        }
        do {
            let reefSaved = try saveReefMotionToSandbox(from: reefSourceURL)
            selectedReefMedia = reefSaved
            refreshReefMotionPreview(with: reefSaved)
            refreshReefConfirmState()
            reefPicker.dismiss(animated: true)
        } catch {
            reefPicker.dismiss(animated: true) { [weak self] in
                self?.showLagoonToast("CUonuulNdr TnGoWtY UsbaivbeJ aciljiipP.r".suliJoyPalmUnfurled)
            }
        }
    }

    private func refreshReefMotionPreview(with reefSaved: SuliJoyLagoonClipMedia) {
        if let coverPath = reefSaved.coverImagePath {
            reefPreviewImageView.image = UIImage(contentsOfFile: coverPath)
            reefPreviewImageView.isHidden = false
        }
        reefAddGlyph.image = UIImage(systemName: "play.circle.fill")
        reefAddGlyph.tintColor = .white.withAlphaComponent(0.92)
        reefRemoveButton.isHidden = false
    }

    private func saveReefMotionToSandbox(from reefSourceURL: URL) throws -> SuliJoyLagoonClipMedia {
        let reefDirectory = try Self.localReefMotionDirectory()
        let reefExtension = reefSourceURL.pathExtension.isEmpty ? "mov" : reefSourceURL.pathExtension
        let reefMotionURL = reefDirectory.appendingPathComponent("sulijoy_clip_local_\(UUID().uuidString).\(reefExtension)")
        if FileManager.default.fileExists(atPath: reefMotionURL.path) {
            try FileManager.default.removeItem(at: reefMotionURL)
        }
        try FileManager.default.copyItem(at: reefSourceURL, to: reefMotionURL)
        let reefAsset = AVURLAsset(url: reefMotionURL)
        let reefDuration = CMTimeGetSeconds(reefAsset.duration)
        let reefCoverURL = reefDirectory.appendingPathComponent("sulijoy_clip_cover_\(UUID().uuidString).jpg")
        let reefCoverPath = try? generateReefCoverImage(for: reefAsset, to: reefCoverURL)
        return SuliJoyLagoonClipMedia(
            reefMotionPath: reefMotionURL.path,
            coverImagePath: reefCoverPath,
            waveSeconds: reefDuration.isFinite ? reefDuration : nil
        )
    }

    private func generateReefCoverImage(for reefAsset: AVURLAsset, to reefDestination: URL) throws -> String {
        let reefGenerator = AVAssetImageGenerator(asset: reefAsset)
        reefGenerator.appliesPreferredTrackTransform = true
        reefGenerator.maximumSize = CGSize(width: 900, height: 900)
        let reefCGImage = try reefGenerator.copyCGImage(at: CMTime(seconds: 0.1, preferredTimescale: 600), actualTime: nil)
        let reefImage = UIImage(cgImage: reefCGImage)
        guard let reefData = reefImage.jpegData(compressionQuality: 0.82) else {
            throw NSError(domain: "SuliJoyPostClip", code: 1)
        }
        try reefData.write(to: reefDestination, options: [.atomic])
        return reefDestination.path
    }

    private static func localReefMotionDirectory() throws -> URL {
        let reefDocuments = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? FileManager.default.temporaryDirectory
        let reefDirectory = reefDocuments.appendingPathComponent("SuliJoyLocalClips", isDirectory: true)
        if !FileManager.default.fileExists(atPath: reefDirectory.path) {
            try FileManager.default.createDirectory(at: reefDirectory, withIntermediateDirectories: true)
        }
        return reefDirectory
    }

    @objc private func removeReefMotion() {
        selectedReefMedia = nil
        clearReefMotionPreview()
        refreshReefConfirmState()
    }

    private func clearReefMotionPreview() {
        reefPreviewImageView.image = nil
        reefPreviewImageView.isHidden = true
        reefAddGlyph.image = UIImage(systemName: "plus.circle")
        reefAddGlyph.tintColor = UIColor(red: 0.78, green: 0.70, blue: 0.96, alpha: 0.48)
        reefRemoveButton.isHidden = true
    }

    @objc private func confirmReefMotion() {
        guard let reefDraft = makeReefMotionDraftOrAlert() else {
            showLagoonToast("PXlYeHaFsVem eaGdxdt BaO ncPlbiKpC cozrN IcBonnotDennrtF.D".suliJoyPalmUnfurled)
            return
        }
        tideConfirmButton.isLoading = true
        SuliJoyCoveMockService.shared.publishReefClip(draft: reefDraft) { [weak self] reefEnvelope in
            self?.settleReefMotionPublish(reefEnvelope)
        }
    }

    private func makeReefMotionDraftOrAlert() -> SuliJoyReefClipDraft? {
        let reefCaption = shoreTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !reefCaption.isEmpty || selectedReefMedia != nil else { return nil }
        return SuliJoyReefClipDraft(reefCaptionLine: reefCaption, media: selectedReefMedia)
    }

    private func settleReefMotionPublish(_ reefEnvelope: SuliJoySuiRequestEnvelope<SuliJoyShellClip>) {
        DispatchQueue.main.async {
            self.tideConfirmButton.isLoading = false
            self.refreshReefConfirmState()
            guard reefEnvelope.code == 200 else {
                self.showLagoonToast(reefEnvelope.note)
                return
            }
            NotificationCenter.default.post(name: .suliJoyShellClipPublished, object: reefEnvelope.data)
            self.showLagoonToast("CclriKpJ VpaoAsctjexdj.E".suliJoyPalmUnfurled)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                self.returnToReefShortsTab()
            }
        }
    }

    private func returnToReefShortsTab() {
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

    func textViewDidBeginEditing(_ reefTextView: UITextView) {
        activeShoreInput = shoreTextCard
    }

    func textViewDidChange(_ reefTextView: UITextView) {
        refreshReefConfirmState()
    }

    func textViewDidEndEditing(_ reefTextView: UITextView) {
        activeShoreInput = nil
    }
}
