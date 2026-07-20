import UIKit

private final class SuliJoyShoreReportRadioView: UIView {
    private enum LagoonRadioPalette {
        static let selectedRing = UIColor(red: 1, green: 0.62, blue: 0.33, alpha: 1)
        static let idleRing = UIColor.black.withAlphaComponent(0.38)
        static let selectedPearl = UIColor(red: 0.78, green: 0.98, blue: 0.46, alpha: 1)
    }

    private enum LagoonRadioShape {
        static let ringInset: CGFloat = 2
        static let pearlInset: CGFloat = 7
        static let ringWidth: CGFloat = 2
    }

    var isChecked: Bool = false {
        didSet { setNeedsDisplay() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareLagoonRadioSurface()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        drawLagoonRing(in: bounds)
        if isChecked {
            drawLagoonPearl(in: bounds)
        }
    }

    private func prepareLagoonRadioSurface() {
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    private func drawLagoonRing(in radioBounds: CGRect) {
        lagoonRingColor().setStroke()
        let ringPath = UIBezierPath(ovalIn: radioBounds.insetBy(dx: LagoonRadioShape.ringInset, dy: LagoonRadioShape.ringInset))
        ringPath.lineWidth = LagoonRadioShape.ringWidth
        ringPath.stroke()
    }

    private func drawLagoonPearl(in radioBounds: CGRect) {
        LagoonRadioPalette.selectedPearl.setFill()
        UIBezierPath(ovalIn: radioBounds.insetBy(dx: LagoonRadioShape.pearlInset, dy: LagoonRadioShape.pearlInset)).fill()
    }

    private func lagoonRingColor() -> UIColor {
        isChecked ? LagoonRadioPalette.selectedRing : LagoonRadioPalette.idleRing
    }
}

private final class SuliJoyShoreReportReasonRow: UIControl {
    let reason: SuliJoyShoreReportReason
    private let radioView = SuliJoyShoreReportRadioView()
    private let titleLabel = UILabel()

    var isChosen: Bool = false {
        didSet { radioView.isChecked = isChosen }
    }

    init(reason: SuliJoyShoreReportReason) {
        self.reason = reason
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white

        let topBorder = UIView()
        topBorder.translatesAutoresizingMaskIntoConstraints = false
        topBorder.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)

        radioView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = reason.rawValue
        titleLabel.textColor = .suliInk
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: reason == .scamOrCommercial ? .semibold : .regular)

        addSubview(topBorder)
        addSubview(radioView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 64),

            topBorder.topAnchor.constraint(equalTo: topAnchor),
            topBorder.leadingAnchor.constraint(equalTo: leadingAnchor),
            topBorder.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBorder.heightAnchor.constraint(equalToConstant: 1),

            radioView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            radioView.centerYAnchor.constraint(equalTo: centerYAnchor),
            radioView.widthAnchor.constraint(equalToConstant: 24),
            radioView.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.leadingAnchor.constraint(equalTo: radioView.trailingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class SuliJoyShoreReportSheetController: UIViewController, UITextViewDelegate {
    private let target: SuliJoyShoreReportTarget
    private let completion: (SuliJoySuiRequestEnvelope<Bool>) -> Void
    private let shoreCurtainView = UIView()
    private let shoreSheetView = UIView()
    private let shoreScrollView = UIScrollView()
    private let shoreContentView = UIView()
    private let shoreConfirmDock = UIView()
    private let shoreConfirmButton = SuliJoyGradientButton(reefHeadline: "Confirm")
    private let shoreOtherTextView = UITextView()
    private let shorePlaceholderLabel = UILabel()
    private let shoreInlineLabel = UILabel()
    private var sheetBottomConstraint: NSLayoutConstraint?
    private var chosenShoreReason: SuliJoyShoreReportReason?
    private var shoreReasonRows: [SuliJoyShoreReportReasonRow] = []

    init(target: SuliJoyShoreReportTarget, completion: @escaping (SuliJoySuiRequestEnvelope<Bool>) -> Void) {
        self.target = target
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildShoreReportReef()
        registerShoreKeyboardSignals()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func buildShoreReportReef() {
        view.backgroundColor = .clear

        shoreCurtainView.translatesAutoresizingMaskIntoConstraints = false
        shoreCurtainView.backgroundColor = UIColor.black.withAlphaComponent(0.52)
        shoreCurtainView.alpha = 0
        view.addSubview(shoreCurtainView)
        NSLayoutConstraint.activate([
            shoreCurtainView.topAnchor.constraint(equalTo: view.topAnchor),
            shoreCurtainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoreCurtainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoreCurtainView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        shoreCurtainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeShoreReportSheet)))

        shoreSheetView.translatesAutoresizingMaskIntoConstraints = false
        shoreSheetView.backgroundColor = .white
        shoreSheetView.layer.cornerRadius = 24
        shoreSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        shoreSheetView.clipsToBounds = true
        view.addSubview(shoreSheetView)

        let bottom = shoreSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        sheetBottomConstraint = bottom
        NSLayoutConstraint.activate([
            shoreSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoreSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottom,
            shoreSheetView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.78),
            shoreSheetView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.56)
        ])

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleShoreSheetPan(_:)))
        shoreSheetView.addGestureRecognizer(pan)

        shoreConfirmDock.translatesAutoresizingMaskIntoConstraints = false
        shoreConfirmDock.backgroundColor = .white
        shoreSheetView.addSubview(shoreConfirmDock)

        shoreScrollView.translatesAutoresizingMaskIntoConstraints = false
        shoreScrollView.alwaysBounceVertical = false
        shoreScrollView.keyboardDismissMode = .interactive
        shoreSheetView.addSubview(shoreScrollView)

        shoreContentView.translatesAutoresizingMaskIntoConstraints = false
        shoreScrollView.addSubview(shoreContentView)

        shoreConfirmButton.translatesAutoresizingMaskIntoConstraints = false
        shoreConfirmButton.addTarget(self, action: #selector(confirmShoreReport), for: .touchUpInside)
        shoreConfirmDock.addSubview(shoreConfirmButton)

        let confirmTopBorder = UIView()
        confirmTopBorder.translatesAutoresizingMaskIntoConstraints = false
        confirmTopBorder.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        shoreConfirmDock.addSubview(confirmTopBorder)

        NSLayoutConstraint.activate([
            shoreConfirmDock.leadingAnchor.constraint(equalTo: shoreSheetView.leadingAnchor),
            shoreConfirmDock.trailingAnchor.constraint(equalTo: shoreSheetView.trailingAnchor),
            shoreConfirmDock.bottomAnchor.constraint(equalTo: shoreSheetView.safeAreaLayoutGuide.bottomAnchor),
            shoreConfirmDock.heightAnchor.constraint(equalToConstant: 86),

            confirmTopBorder.topAnchor.constraint(equalTo: shoreConfirmDock.topAnchor),
            confirmTopBorder.leadingAnchor.constraint(equalTo: shoreConfirmDock.leadingAnchor),
            confirmTopBorder.trailingAnchor.constraint(equalTo: shoreConfirmDock.trailingAnchor),
            confirmTopBorder.heightAnchor.constraint(equalToConstant: 1),

            shoreConfirmButton.leadingAnchor.constraint(equalTo: shoreConfirmDock.leadingAnchor, constant: 15),
            shoreConfirmButton.trailingAnchor.constraint(equalTo: shoreConfirmDock.trailingAnchor, constant: -15),
            shoreConfirmButton.centerYAnchor.constraint(equalTo: shoreConfirmDock.centerYAnchor),

            shoreScrollView.topAnchor.constraint(equalTo: shoreSheetView.topAnchor),
            shoreScrollView.leadingAnchor.constraint(equalTo: shoreSheetView.leadingAnchor),
            shoreScrollView.trailingAnchor.constraint(equalTo: shoreSheetView.trailingAnchor),
            shoreScrollView.bottomAnchor.constraint(equalTo: shoreConfirmDock.topAnchor),

            shoreContentView.topAnchor.constraint(equalTo: shoreScrollView.contentLayoutGuide.topAnchor),
            shoreContentView.leadingAnchor.constraint(equalTo: shoreScrollView.contentLayoutGuide.leadingAnchor),
            shoreContentView.trailingAnchor.constraint(equalTo: shoreScrollView.contentLayoutGuide.trailingAnchor),
            shoreContentView.bottomAnchor.constraint(equalTo: shoreScrollView.contentLayoutGuide.bottomAnchor),
            shoreContentView.widthAnchor.constraint(equalTo: shoreScrollView.frameLayoutGuide.widthAnchor)
        ])

        addShoreReportContent()

        view.layoutIfNeeded()
        shoreSheetView.transform = CGAffineTransform(translationX: 0, y: shoreSheetView.bounds.height)
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
            self.shoreCurtainView.alpha = 1
            self.shoreSheetView.transform = .identity
        }
    }

    private func addShoreReportContent() {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Report"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .black)

        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "Please select the reason for reporting this \(target.subjectText):"
        subtitleLabel.textColor = UIColor.black.withAlphaComponent(0.60)
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.numberOfLines = 0

        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0

        [SuliJoyShoreReportReason.fakePhoto, .scamOrCommercial, .notInterested].forEach { reason in
            let row = SuliJoyShoreReportReasonRow(reason: reason)
            row.addTarget(self, action: #selector(chooseShoreReason(_:)), for: .touchUpInside)
            shoreReasonRows.append(row)
            stack.addArrangedSubview(row)
        }

        let otherRow = SuliJoyShoreReportReasonRow(reason: .other)
        otherRow.addTarget(self, action: #selector(chooseShoreReason(_:)), for: .touchUpInside)
        shoreReasonRows.append(otherRow)

        shoreOtherTextView.translatesAutoresizingMaskIntoConstraints = false
        shoreOtherTextView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        shoreOtherTextView.layer.cornerRadius = 12
        shoreOtherTextView.textColor = .suliInk
        shoreOtherTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        shoreOtherTextView.textContainerInset = UIEdgeInsets(top: 18, left: 16, bottom: 14, right: 16)
        shoreOtherTextView.delegate = self
        shoreOtherTextView.returnKeyType = .done

        shorePlaceholderLabel.translatesAutoresizingMaskIntoConstraints = false
        shorePlaceholderLabel.text = "Enter your reason here ..."
        shorePlaceholderLabel.textColor = UIColor.black.withAlphaComponent(0.18)
        shorePlaceholderLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        shoreOtherTextView.addSubview(shorePlaceholderLabel)

        shoreInlineLabel.translatesAutoresizingMaskIntoConstraints = false
        shoreInlineLabel.alpha = 0
        shoreInlineLabel.textColor = UIColor(red: 1, green: 0.42, blue: 0.18, alpha: 1)
        shoreInlineLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        shoreInlineLabel.textAlignment = .center
        shoreInlineLabel.numberOfLines = 0

        [titleLabel, subtitleLabel, stack, otherRow, shoreOtherTextView, shoreInlineLabel].forEach { shoreContentView.addSubview($0) }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: shoreContentView.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: shoreContentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: shoreContentView.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: shoreContentView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: shoreContentView.trailingAnchor, constant: -24),

            stack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 18),
            stack.leadingAnchor.constraint(equalTo: shoreContentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: shoreContentView.trailingAnchor),

            otherRow.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 22),
            otherRow.leadingAnchor.constraint(equalTo: shoreContentView.leadingAnchor),
            otherRow.trailingAnchor.constraint(equalTo: shoreContentView.trailingAnchor),

            shoreOtherTextView.topAnchor.constraint(equalTo: otherRow.bottomAnchor, constant: 10),
            shoreOtherTextView.leadingAnchor.constraint(equalTo: shoreContentView.leadingAnchor, constant: 24),
            shoreOtherTextView.trailingAnchor.constraint(equalTo: shoreContentView.trailingAnchor, constant: -24),
            shoreOtherTextView.heightAnchor.constraint(equalToConstant: 100),

            shorePlaceholderLabel.topAnchor.constraint(equalTo: shoreOtherTextView.topAnchor, constant: 18),
            shorePlaceholderLabel.leadingAnchor.constraint(equalTo: shoreOtherTextView.leadingAnchor, constant: 20),
            shorePlaceholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: shoreOtherTextView.trailingAnchor, constant: -20),

            shoreInlineLabel.topAnchor.constraint(equalTo: shoreOtherTextView.bottomAnchor, constant: 10),
            shoreInlineLabel.leadingAnchor.constraint(equalTo: shoreContentView.leadingAnchor, constant: 24),
            shoreInlineLabel.trailingAnchor.constraint(equalTo: shoreContentView.trailingAnchor, constant: -24),
            shoreInlineLabel.bottomAnchor.constraint(equalTo: shoreContentView.bottomAnchor, constant: -18)
        ])
    }

    @objc private func chooseShoreReason(_ sender: SuliJoyShoreReportReasonRow) {
        chosenShoreReason = sender.reason
        shoreReasonRows.forEach { $0.isChosen = $0 === sender }
        hideShoreInlineNote()
        if sender.reason == .other {
            shoreOtherTextView.becomeFirstResponder()
        }
    }

    @objc private func confirmShoreReport() {
        view.endEditing(true)
        let otherText = shoreOtherTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalReason: SuliJoyShoreReportReason
        if let chosenShoreReason {
            finalReason = chosenShoreReason
        } else if !otherText.isEmpty {
            finalReason = .other
        } else {
            showShoreInlineNote("Please select a report reason.")
            return
        }

        if finalReason == .other && otherText.isEmpty {
            showShoreInlineNote("Please enter your report reason.")
            return
        }

        hideShoreInlineNote()
        shoreConfirmButton.isLoading = true
        let draft = SuliJoyShoreReportDraft(
            target: target,
            reason: finalReason,
            otherText: otherText.isEmpty ? nil : otherText,
            waveCreatedAt: Date()
        )
        SuliJoyCoveMockService.shared.submitShoreReport(draft: draft) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.shoreConfirmButton.isLoading = false
                if result.code == 200 {
                    self.dismissShoreReportSheet {
                        self.completion(result)
                    }
                } else {
                    self.showShoreInlineNote(result.note)
                }
            }
        }
    }

    private func showShoreInlineNote(_ jback: String) {
        shoreInlineLabel.text = jback
        UIView.animate(withDuration: 0.18) {
            self.shoreInlineLabel.alpha = 1
        }
    }

    private func hideShoreInlineNote() {
        guard shoreInlineLabel.alpha > 0 else { return }
        UIView.animate(withDuration: 0.18) {
            self.shoreInlineLabel.alpha = 0
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        shorePlaceholderLabel.isHidden = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        if !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && chosenShoreReason == nil {
            chosenShoreReason = .other
            shoreReasonRows.forEach { $0.isChosen = $0.reason == .other }
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    private func registerShoreKeyboardSignals() {
        NotificationCenter.default.addObserver(self, selector: #selector(shoreKeyboardWillRise(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shoreKeyboardWillSettle(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func shoreKeyboardWillRise(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let overlap = max(0, view.bounds.maxY - frame.minY)
        sheetBottomConstraint?.constant = -overlap
        shoreScrollView.contentInset.bottom = 16
        shoreScrollView.verticalScrollIndicatorInsets.bottom = 16
        animateShoreKeyboardShift(notification)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.shoreScrollView.scrollRectToVisible(self.shoreOtherTextView.convert(self.shoreOtherTextView.bounds, to: self.shoreScrollView), animated: true)
        }
    }

    @objc private func shoreKeyboardWillSettle(_ notification: Notification) {
        sheetBottomConstraint?.constant = 0
        shoreScrollView.contentInset.bottom = 0
        shoreScrollView.verticalScrollIndicatorInsets.bottom = 0
        animateShoreKeyboardShift(notification)
    }

    private func animateShoreKeyboardShift(_ notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        let curveRaw = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 7
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curveRaw << 16)) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func handleShoreSheetPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                shoreSheetView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended, .cancelled:
            if translation.y > 90 {
                dismissShoreReportSheet()
            } else {
                UIView.animate(withDuration: 0.18) {
                    self.shoreSheetView.transform = .identity
                }
            }
        default:
            break
        }
    }

    @objc private func closeShoreReportSheet() {
        dismissShoreReportSheet()
    }

    private func dismissShoreReportSheet(completion: (() -> Void)? = nil) {
        view.endEditing(true)
        UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseIn]) {
            self.shoreCurtainView.alpha = 0
            self.shoreSheetView.transform = CGAffineTransform(translationX: 0, y: self.shoreSheetView.bounds.height)
        } completion: { _ in
            self.dismiss(animated: false, completion: completion)
        }
    }
}

private extension SuliJoyShoreReportTarget {
    var subjectText: String {
        switch self {
        case .moment:
            return "post"
        case .shoreComment, .shellClipComment:
            return "comment"
        case .tideActivity:
            return "activity"
        case .shellClip:
            return "short"
        case .lagoonVisitor:
            return "user"
        case .tideTalkSpace:
            return "room"
        }
    }
}

extension SuliJoyTropicCanvasController {
    func presentSuliJoyReportSheet(target: SuliJoyShoreReportTarget, completion: (() -> Void)? = nil) {
        let sheet = SuliJoyShoreReportSheetController(target: target) { [weak self] result in
            self?.showLagoonToast(result.note)
            completion?()
        }
        present(sheet, animated: false)
    }

    func presentSuliJoyHarborGuardMenu(_ harborFlag: @escaping () -> Void, block reefMute: @escaping () -> Void) {
        let coveSheet = SuliJoyHarborGuardSheetController(harborFlag: harborFlag, reefMute: reefMute)
        present(coveSheet, animated: false)
    }
}

private final class SuliJoyHarborGuardSheetController: UIViewController {
    private let duskVeilView = UIView()
    private let coveActionStack = UIStackView()
    private let harborFlagDrift: () -> Void
    private let reefMuteDrift: () -> Void

    init(harborFlag: @escaping () -> Void, reefMute: @escaping () -> Void) {
        harborFlagDrift = harborFlag
        reefMuteDrift = reefMute
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        weaveHarborGuardUI()
    }

    override func viewDidAppear(_ shoreAnimated: Bool) {
        super.viewDidAppear(shoreAnimated)
        UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseOut]) {
            self.duskVeilView.alpha = 1
            self.coveActionStack.transform = .identity
        }
    }

    private func weaveHarborGuardUI() {
        view.backgroundColor = .clear

        duskVeilView.translatesAutoresizingMaskIntoConstraints = false
        duskVeilView.backgroundColor = UIColor.black.withAlphaComponent(0.48)
        duskVeilView.alpha = 0
        view.addSubview(duskVeilView)
        duskVeilView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapSandCancel)))

        coveActionStack.translatesAutoresizingMaskIntoConstraints = false
        coveActionStack.axis = .vertical
        coveActionStack.spacing = 12
        coveActionStack.transform = CGAffineTransform(translationX: 0, y: 180)
        view.addSubview(coveActionStack)

        let harborFlagButton = makePearlPlainAction(reefHeadline: "Report", action: #selector(tapHarborFlag))
        let reefMuteButton = makePearlPlainAction(reefHeadline: "Block", action: #selector(tapReefMute))
        let sandCancelButton = SuliJoyGradientButton(reefHeadline: "Cancel")
        sandCancelButton.translatesAutoresizingMaskIntoConstraints = false
        sandCancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
        sandCancelButton.addTarget(self, action: #selector(tapSandCancel), for: .touchUpInside)

        [harborFlagButton, reefMuteButton, sandCancelButton].forEach {
            coveActionStack.addArrangedSubview($0)
            $0.heightAnchor.constraint(equalToConstant: 56).isActive = true
        }

        NSLayoutConstraint.activate([
            duskVeilView.topAnchor.constraint(equalTo: view.topAnchor),
            duskVeilView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            duskVeilView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            duskVeilView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            coveActionStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            coveActionStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            coveActionStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }

    private func makePearlPlainAction(reefHeadline: String, action: Selector) -> UIButton {
        let pearlActionButton = UIButton(type: .system)
        pearlActionButton.translatesAutoresizingMaskIntoConstraints = false
        pearlActionButton.backgroundColor = .white
        pearlActionButton.setTitle(title, for: .normal)
        pearlActionButton.setTitleColor(UIColor(white: 0.58, alpha: 1), for: .normal)
        pearlActionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
        pearlActionButton.layer.cornerRadius = 28
        pearlActionButton.clipsToBounds = true
        pearlActionButton.addTarget(self, action: action, for: .touchUpInside)
        return pearlActionButton
    }

    private func foldHarborGuard(after reefAction: @escaping () -> Void) {
        UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseIn]) {
            self.duskVeilView.alpha = 0
            self.coveActionStack.transform = CGAffineTransform(translationX: 0, y: 180)
        } completion: { _ in
            self.dismiss(animated: false, completion: reefAction)
        }
    }

    @objc private func tapHarborFlag() {
        foldHarborGuard(after: harborFlagDrift)
    }

    @objc private func tapReefMute() {
        foldHarborGuard(after: reefMuteDrift)
    }

    @objc private func tapSandCancel() {
        foldHarborGuard {}
    }
}
