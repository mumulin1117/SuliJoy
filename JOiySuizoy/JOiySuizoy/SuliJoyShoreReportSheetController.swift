import UIKit

private final class SuliJoyShoreReportRadioView: UIView {
    var isChecked: Bool = false {
        didSet { setNeedsDisplay() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let stroke = isChecked ? UIColor(red: 1, green: 0.62, blue: 0.33, alpha: 1) : UIColor.black.withAlphaComponent(0.38)
        let circleRect = bounds.insetBy(dx: 2, dy: 2)
        let path = UIBezierPath(ovalIn: circleRect)
        stroke.setStroke()
        path.lineWidth = 2
        path.stroke()

        guard isChecked else { return }
        let dotRect = bounds.insetBy(dx: 7, dy: 7)
        UIColor(red: 0.78, green: 0.98, blue: 0.46, alpha: 1).setFill()
        UIBezierPath(ovalIn: dotRect).fill()
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
    private let completion: (SuliJoyLocalRequestEnvelope<Bool>) -> Void
    private let dimmingView = UIView()
    private let sheetView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let confirmContainer = UIView()
    private let confirmButton = SuliJoyGradientButton(title: "Confirm")
    private let otherTextView = UITextView()
    private let placeholderLabel = UILabel()
    private let messageLabel = UILabel()
    private var sheetBottomConstraint: NSLayoutConstraint?
    private var selectedReason: SuliJoyShoreReportReason?
    private var reasonRows: [SuliJoyShoreReportReasonRow] = []

    init(target: SuliJoyShoreReportTarget, completion: @escaping (SuliJoyLocalRequestEnvelope<Bool>) -> Void) {
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
        buildInterface()
        registerKeyboardNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func buildInterface() {
        view.backgroundColor = .clear

        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.52)
        dimmingView.alpha = 0
        view.addSubview(dimmingView)
        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeSheet)))

        sheetView.translatesAutoresizingMaskIntoConstraints = false
        sheetView.backgroundColor = .white
        sheetView.layer.cornerRadius = 24
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        sheetView.clipsToBounds = true
        view.addSubview(sheetView)

        let bottom = sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        sheetBottomConstraint = bottom
        NSLayoutConstraint.activate([
            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottom,
            sheetView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.78),
            sheetView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: 0.56)
        ])

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        sheetView.addGestureRecognizer(pan)

        confirmContainer.translatesAutoresizingMaskIntoConstraints = false
        confirmContainer.backgroundColor = .white
        sheetView.addSubview(confirmContainer)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = false
        scrollView.keyboardDismissMode = .interactive
        sheetView.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.addTarget(self, action: #selector(confirmReport), for: .touchUpInside)
        confirmContainer.addSubview(confirmButton)

        let confirmTopBorder = UIView()
        confirmTopBorder.translatesAutoresizingMaskIntoConstraints = false
        confirmTopBorder.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        confirmContainer.addSubview(confirmTopBorder)

        NSLayoutConstraint.activate([
            confirmContainer.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor),
            confirmContainer.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor),
            confirmContainer.bottomAnchor.constraint(equalTo: sheetView.safeAreaLayoutGuide.bottomAnchor),
            confirmContainer.heightAnchor.constraint(equalToConstant: 86),

            confirmTopBorder.topAnchor.constraint(equalTo: confirmContainer.topAnchor),
            confirmTopBorder.leadingAnchor.constraint(equalTo: confirmContainer.leadingAnchor),
            confirmTopBorder.trailingAnchor.constraint(equalTo: confirmContainer.trailingAnchor),
            confirmTopBorder.heightAnchor.constraint(equalToConstant: 1),

            confirmButton.leadingAnchor.constraint(equalTo: confirmContainer.leadingAnchor, constant: 15),
            confirmButton.trailingAnchor.constraint(equalTo: confirmContainer.trailingAnchor, constant: -15),
            confirmButton.centerYAnchor.constraint(equalTo: confirmContainer.centerYAnchor),

            scrollView.topAnchor.constraint(equalTo: sheetView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: confirmContainer.topAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        addSheetContent()

        view.layoutIfNeeded()
        sheetView.transform = CGAffineTransform(translationX: 0, y: sheetView.bounds.height)
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
            self.dimmingView.alpha = 1
            self.sheetView.transform = .identity
        }
    }

    private func addSheetContent() {
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
            row.addTarget(self, action: #selector(selectReason(_:)), for: .touchUpInside)
            reasonRows.append(row)
            stack.addArrangedSubview(row)
        }

        let otherRow = SuliJoyShoreReportReasonRow(reason: .other)
        otherRow.addTarget(self, action: #selector(selectReason(_:)), for: .touchUpInside)
        reasonRows.append(otherRow)

        otherTextView.translatesAutoresizingMaskIntoConstraints = false
        otherTextView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        otherTextView.layer.cornerRadius = 12
        otherTextView.textColor = .suliInk
        otherTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        otherTextView.textContainerInset = UIEdgeInsets(top: 18, left: 16, bottom: 14, right: 16)
        otherTextView.delegate = self
        otherTextView.returnKeyType = .done

        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.text = "Enter your reason here ..."
        placeholderLabel.textColor = UIColor.black.withAlphaComponent(0.18)
        placeholderLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        otherTextView.addSubview(placeholderLabel)

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.alpha = 0
        messageLabel.textColor = UIColor(red: 1, green: 0.42, blue: 0.18, alpha: 1)
        messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        [titleLabel, subtitleLabel, stack, otherRow, otherTextView, messageLabel].forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            stack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 18),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            otherRow.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 22),
            otherRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            otherRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            otherTextView.topAnchor.constraint(equalTo: otherRow.bottomAnchor, constant: 10),
            otherTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            otherTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            otherTextView.heightAnchor.constraint(equalToConstant: 100),

            placeholderLabel.topAnchor.constraint(equalTo: otherTextView.topAnchor, constant: 18),
            placeholderLabel.leadingAnchor.constraint(equalTo: otherTextView.leadingAnchor, constant: 20),
            placeholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: otherTextView.trailingAnchor, constant: -20),

            messageLabel.topAnchor.constraint(equalTo: otherTextView.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
        ])
    }

    @objc private func selectReason(_ sender: SuliJoyShoreReportReasonRow) {
        selectedReason = sender.reason
        reasonRows.forEach { $0.isChosen = $0 === sender }
        hideInlineMessage()
        if sender.reason == .other {
            otherTextView.becomeFirstResponder()
        }
    }

    @objc private func confirmReport() {
        view.endEditing(true)
        let otherText = otherTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalReason: SuliJoyShoreReportReason
        if let selectedReason {
            finalReason = selectedReason
        } else if !otherText.isEmpty {
            finalReason = .other
        } else {
            showInlineMessage("Please select a report reason.")
            return
        }

        if finalReason == .other && otherText.isEmpty {
            showInlineMessage("Please enter your report reason.")
            return
        }

        hideInlineMessage()
        confirmButton.isLoading = true
        let draft = SuliJoyShoreReportDraft(
            target: target,
            reason: finalReason,
            otherText: otherText.isEmpty ? nil : otherText,
            createdAt: Date()
        )
        SuliJoyCoveMockService.shared.submitShoreReport(draft: draft) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.confirmButton.isLoading = false
                if result.code == 200 {
                    self.dismissSheet {
                        self.completion(result)
                    }
                } else {
                    self.showInlineMessage(result.message)
                }
            }
        }
    }

    private func showInlineMessage(_ message: String) {
        messageLabel.text = message
        UIView.animate(withDuration: 0.18) {
            self.messageLabel.alpha = 1
        }
    }

    private func hideInlineMessage() {
        guard messageLabel.alpha > 0 else { return }
        UIView.animate(withDuration: 0.18) {
            self.messageLabel.alpha = 0
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        if !textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedReason == nil {
            selectedReason = .other
            reasonRows.forEach { $0.isChosen = $0.reason == .other }
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let overlap = max(0, view.bounds.maxY - frame.minY)
        sheetBottomConstraint?.constant = -overlap
        scrollView.contentInset.bottom = 16
        scrollView.scrollIndicatorInsets.bottom = 16
        animateKeyboardChange(notification)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.scrollView.scrollRectToVisible(self.otherTextView.convert(self.otherTextView.bounds, to: self.scrollView), animated: true)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        sheetBottomConstraint?.constant = 0
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
        animateKeyboardChange(notification)
    }

    private func animateKeyboardChange(_ notification: Notification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        let curveRaw = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 7
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curveRaw << 16)) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                sheetView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended, .cancelled:
            if translation.y > 90 {
                dismissSheet()
            } else {
                UIView.animate(withDuration: 0.18) {
                    self.sheetView.transform = .identity
                }
            }
        default:
            break
        }
    }

    @objc private func closeSheet() {
        dismissSheet()
    }

    private func dismissSheet(completion: (() -> Void)? = nil) {
        view.endEditing(true)
        UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseIn]) {
            self.dimmingView.alpha = 0
            self.sheetView.transform = CGAffineTransform(translationX: 0, y: self.sheetView.bounds.height)
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

extension SuliJoyBaseIslandViewController {
    func presentSuliJoyReportSheet(target: SuliJoyShoreReportTarget, completion: (() -> Void)? = nil) {
        let sheet = SuliJoyShoreReportSheetController(target: target) { [weak self] result in
            self?.showToast(result.message)
            completion?()
        }
        present(sheet, animated: false)
    }

    func presentSuliJoyModerationMenu(report: @escaping () -> Void, block: @escaping () -> Void) {
        let menu = SuliJoyShoreModerationMenuController(report: report, block: block)
        present(menu, animated: false)
    }
}

private final class SuliJoyShoreModerationMenuController: UIViewController {
    private let dimmingView = UIView()
    private let container = UIStackView()
    private let reportAction: () -> Void
    private let blockAction: () -> Void

    init(report: @escaping () -> Void, block: @escaping () -> Void) {
        reportAction = report
        blockAction = block
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseOut]) {
            self.dimmingView.alpha = 1
            self.container.transform = .identity
        }
    }

    private func buildUI() {
        view.backgroundColor = .clear

        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.48)
        dimmingView.alpha = 0
        view.addSubview(dimmingView)
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelNow)))

        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.spacing = 12
        container.transform = CGAffineTransform(translationX: 0, y: 180)
        view.addSubview(container)

        let report = makePlainButton(title: "Report", action: #selector(reportNow))
        let block = makePlainButton(title: "Block", action: #selector(blockNow))
        let cancel = SuliJoyGradientButton(title: "Cancel")
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
        cancel.addTarget(self, action: #selector(cancelNow), for: .touchUpInside)

        [report, block, cancel].forEach {
            container.addArrangedSubview($0)
            $0.heightAnchor.constraint(equalToConstant: 56).isActive = true
        }

        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }

    private func makePlainButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(white: 0.58, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
        button.layer.cornerRadius = 28
        button.clipsToBounds = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func dismissThen(_ action: @escaping () -> Void) {
        UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseIn]) {
            self.dimmingView.alpha = 0
            self.container.transform = CGAffineTransform(translationX: 0, y: 180)
        } completion: { _ in
            self.dismiss(animated: false, completion: action)
        }
    }

    @objc private func reportNow() {
        dismissThen(reportAction)
    }

    @objc private func blockNow() {
        dismissThen(blockAction)
    }

    @objc private func cancelNow() {
        dismissThen {}
    }
}
