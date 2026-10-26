import UIKit

final class SuliJoyLagoonLettersViewController: SuliJoyTropicCanvasController, UITableViewDataSource, UITableViewDelegate {
    private let letterTable = UITableView(frame: .zero, style: .plain)
    private let emptyLabel = UILabel()
    private var threads: [SuliJoyLagoonLetterThread] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        buildLetterList()
        reloadLetters()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    private func buildLetterList() {
        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.tintColor = .suliInk
        back.addTarget(self, action: #selector(closeLetters), for: .touchUpInside)

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "Messages"
        title.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        title.textColor = .suliInk
        title.textAlignment = .center

        letterTable.translatesAutoresizingMaskIntoConstraints = false
        letterTable.backgroundColor = .clear
        letterTable.separatorStyle = .none
        letterTable.dataSource = self
        letterTable.delegate = self
        letterTable.rowHeight = 86
        letterTable.contentInset.bottom = 24
        letterTable.register(SuliJoyLagoonLetterCell.self, forCellReuseIdentifier: "SuliJoyLagoonLetterCell")
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reloadLetters), for: .valueChanged)
        letterTable.refreshControl = refresh

        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "No messages yet."
        emptyLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        emptyLabel.textColor = .suliMutedInk
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0
        emptyLabel.isHidden = true

        [back, title, letterTable, emptyLabel].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            back.widthAnchor.constraint(equalToConstant: 44),
            back.heightAnchor.constraint(equalToConstant: 44),
            title.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: back.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -60),
            letterTable.topAnchor.constraint(equalTo: back.bottomAnchor, constant: 8),
            letterTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            letterTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            letterTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: letterTable.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: letterTable.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    @objc private func reloadLetters() {
        SuliJoyLagoonProfileRemoteService.shared.fetchLetterThreads { [weak self] result in
            guard let self else { return }
            self.letterTable.refreshControl?.endRefreshing()
            guard result.beachwearCapsule == 200 else {
                self.showLagoonToast(result.coastalWardrobe)
                self.emptyLabel.isHidden = !self.threads.isEmpty
                return
            }
            self.threads = result.sandbarLayering ?? []
            self.emptyLabel.isHidden = !self.threads.isEmpty
            self.letterTable.reloadData()
        }
    }

    @objc private func closeLetters() {
        navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        threads.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuliJoyLagoonLetterCell", for: indexPath) as! SuliJoyLagoonLetterCell
        cell.apply(threads[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = SuliJoyLagoonLetterDetailController(thread: threads[indexPath.row])
        navigationController?.pushViewController(detail, animated: true)
    }
}

final class SuliJoyLagoonLetterDetailController: SuliJoyTropicCanvasController, UITableViewDataSource, UITextFieldDelegate {
    private enum LetterDetailMetric {
        static let composerHeight: CGFloat = 56
        static let orbitSide: CGFloat = 44
        static let inputHeight: CGFloat = 44
    }

    private let thread: SuliJoyLagoonLetterThread
    private var notes: [SuliJoyLagoonLetterNote] = []
    private var ownPortraitToken = ""
    private let noteTable = UITableView(frame: .zero, style: .plain)
    private let composer = UIView()
    private let mediaOrbitButton = SuliJoyLagoonLetterOrbitButton(style: .media)
    private let inputField = UITextField()
    private let sendOrbitButton = SuliJoyLagoonLetterOrbitButton(style: .send)
    private var composerBottom: NSLayoutConstraint?

    init(thread: SuliJoyLagoonLetterThread) {
        self.thread = thread
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLetterDetail()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        reloadNotes()
        loadOwnPortrait()
        SuliJoyLagoonProfileRemoteService.shared.markLetterRead(conversationID: thread.conversationID)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    private func loadOwnPortrait() {
        SuliJoyLagoonProfileRemoteService.shared.fetchIslandProfileSummary { [weak self] result in
            guard let self, let snapshot = result.sandbarLayering else { return }
            self.ownPortraitToken = snapshot.lagoonAvatarAssetName
            self.noteTable.reloadData()
        }
    }

    private func buildLetterDetail() {
        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.tintColor = .black
        back.addTarget(self, action: #selector(closeLetter), for: .touchUpInside)

        let more = UIButton(type: .system)
        more.translatesAutoresizingMaskIntoConstraints = false
        more.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        more.tintColor = .black
        more.addTarget(self, action: #selector(showLetterHarborMenu), for: .touchUpInside)

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = thread.peerName.isEmpty ? "Message" : thread.peerName
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.textColor = .black
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.7

        noteTable.translatesAutoresizingMaskIntoConstraints = false
        noteTable.backgroundColor = .clear
        noteTable.separatorStyle = .none
        noteTable.dataSource = self
        noteTable.keyboardDismissMode = .interactive
        noteTable.rowHeight = UITableView.automaticDimension
        noteTable.estimatedRowHeight = 88
        noteTable.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 12, right: 0)
        noteTable.register(SuliJoyLagoonLetterNoteCell.self, forCellReuseIdentifier: "SuliJoyLagoonLetterNoteCell")

        composer.translatesAutoresizingMaskIntoConstraints = false
        composer.backgroundColor = .clear

        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.placeholder = "What do you do on weekends?"
        inputField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        inputField.textColor = .suliInk
        inputField.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1)
        inputField.layer.cornerRadius = LetterDetailMetric.inputHeight / 2
        inputField.layer.cornerCurve = .continuous
        inputField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 1))
        inputField.leftViewMode = .always
        inputField.returnKeyType = .send
        inputField.delegate = self

        mediaOrbitButton.translatesAutoresizingMaskIntoConstraints = false
        mediaOrbitButton.addTarget(self, action: #selector(openLetterMedia), for: .touchUpInside)
        sendOrbitButton.translatesAutoresizingMaskIntoConstraints = false
        sendOrbitButton.addTarget(self, action: #selector(sendLetter), for: .touchUpInside)

        composer.addSubview(mediaOrbitButton)
        composer.addSubview(inputField)
        composer.addSubview(sendOrbitButton)
        [back, more, title, noteTable, composer].forEach { view.addSubview($0) }
        composerBottom = composer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        composerBottom?.isActive = true

        let dismiss = UITapGestureRecognizer(target: self, action: #selector(foldKeyboard))
        dismiss.cancelsTouchesInView = false
        noteTable.addGestureRecognizer(dismiss)

        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            back.widthAnchor.constraint(equalToConstant: 44),
            back.heightAnchor.constraint(equalToConstant: 44),
            more.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            more.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            more.widthAnchor.constraint(equalToConstant: 44),
            more.heightAnchor.constraint(equalToConstant: 44),
            title.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: back.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(lessThanOrEqualTo: more.leadingAnchor, constant: -12),
            noteTable.topAnchor.constraint(equalTo: back.bottomAnchor, constant: 6),
            noteTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noteTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noteTable.bottomAnchor.constraint(equalTo: composer.topAnchor),
            composer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            composer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            composer.heightAnchor.constraint(equalToConstant: LetterDetailMetric.composerHeight),
            mediaOrbitButton.leadingAnchor.constraint(equalTo: composer.leadingAnchor, constant: 16),
            mediaOrbitButton.centerYAnchor.constraint(equalTo: composer.centerYAnchor),
            mediaOrbitButton.widthAnchor.constraint(equalToConstant: LetterDetailMetric.orbitSide),
            mediaOrbitButton.heightAnchor.constraint(equalToConstant: LetterDetailMetric.orbitSide),
            sendOrbitButton.trailingAnchor.constraint(equalTo: composer.trailingAnchor, constant: -16),
            sendOrbitButton.centerYAnchor.constraint(equalTo: composer.centerYAnchor),
            sendOrbitButton.widthAnchor.constraint(equalToConstant: LetterDetailMetric.orbitSide),
            sendOrbitButton.heightAnchor.constraint(equalToConstant: LetterDetailMetric.orbitSide),
            inputField.leadingAnchor.constraint(equalTo: mediaOrbitButton.trailingAnchor, constant: 10),
            inputField.trailingAnchor.constraint(equalTo: sendOrbitButton.leadingAnchor, constant: -10),
            inputField.centerYAnchor.constraint(equalTo: composer.centerYAnchor),
            inputField.heightAnchor.constraint(equalToConstant: LetterDetailMetric.inputHeight)
        ])
    }

    private func reloadNotes() {
        SuliJoyLagoonProfileRemoteService.shared.fetchLetterNotes(conversationID: thread.conversationID) { [weak self] result in
            guard let self else { return }
            guard result.beachwearCapsule == 200 else {
                self.showLagoonToast(result.coastalWardrobe)
                return
            }
            self.notes = result.sandbarLayering ?? []
            self.noteTable.reloadData()
            self.scrollNotesToEnd(animated: false)
        }
    }

    private func scrollNotesToEnd(animated: Bool) {
        guard !notes.isEmpty else { return }
        noteTable.scrollToRow(at: IndexPath(row: notes.count - 1, section: 0), at: .bottom, animated: animated)
    }

    @objc private func showLetterHarborMenu() {
        presentSuliJoyHarborGuardMenu { [weak self] in
            guard let self else { return }
            self.presentSuliJoyReportSheet(target: .softDrape(seersuckerStripe: self.thread.peerID))
        } block: { [weak self] in
            self?.showLagoonToast("Chat actions updated locally.")
        }
    }

    @objc private func openLetterMedia() {
        showLagoonToast("Photo messages will arrive in a later update.")
    }

    @objc private func sendLetter() {
        let text = inputField.text ?? ""
        sendOrbitButton.isEnabled = false
        SuliJoyLagoonProfileRemoteService.shared.sendLetter(conversationID: thread.conversationID, text: text) { [weak self] result in
            guard let self else { return }
            self.sendOrbitButton.isEnabled = true
            guard let note = result.sandbarLayering else {
                self.showLagoonToast(result.coastalWardrobe)
                return
            }
            self.inputField.text = ""
            self.notes.append(note)
            self.noteTable.reloadData()
            self.scrollNotesToEnd(animated: true)
        }
    }

    @objc private func closeLetter() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func foldKeyboard() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendLetter()
        return true
    }

    @objc private func keyboardWillShow(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let overlap = max(0, frame.height - view.safeAreaInsets.bottom)
        composerBottom?.constant = -overlap
        noteTable.contentInset.bottom = 12
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        scrollNotesToEnd(animated: true)
    }

    @objc private func keyboardWillHide(_ note: Notification) {
        composerBottom?.constant = 0
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuliJoyLagoonLetterNoteCell", for: indexPath) as! SuliJoyLagoonLetterNoteCell
        let note = notes[indexPath.row]
        let previous = indexPath.row > 0 ? notes[indexPath.row - 1] : nil
        let next = indexPath.row + 1 < notes.count ? notes[indexPath.row + 1] : nil
        let showsTimestamp = previous?.momentLine != note.momentLine
        let showsOwnAvatar = note.own && next?.own != true
        let showsPeerAvatar = !note.own
        cell.apply(
            note: note,
            peerPortraitToken: thread.portraitToken,
            ownPortraitToken: ownPortraitToken,
            showsTimestamp: showsTimestamp,
            showsOwnAvatar: showsOwnAvatar,
            showsPeerAvatar: showsPeerAvatar
        )
        return cell
    }
}

private final class SuliJoyLagoonLetterOrbitButton: UIButton {
    enum OrbitStyle {
        case media
        case send
    }

    private let gradientLayer = CAGradientLayer()

    init(style: OrbitStyle) {
        super.init(frame: .zero)
        layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = 22
        layer.masksToBounds = true
        switch style {
        case .media:
            gradientLayer.colors = [
                UIColor(red: 1, green: 0.55, blue: 0.35, alpha: 1).cgColor,
                UIColor(red: 1, green: 0.38, blue: 0.58, alpha: 1).cgColor
            ]
            setImage(UIImage(systemName: "video.fill"), for: .normal)
            tintColor = .white
        case .send:
            gradientLayer.colors = [
                UIColor(red: 1, green: 0.93, blue: 0.38, alpha: 1).cgColor,
                UIColor(red: 1, green: 0.62, blue: 0.28, alpha: 1).cgColor,
                UIColor(red: 0.62, green: 0.92, blue: 0.55, alpha: 1).cgColor
            ]
            let sendMark = UIImage(named: "sulijoy_feed_comment_send_mark")?.withRenderingMode(.alwaysOriginal)
                ?? UIImage(systemName: "paperplane.fill")
            setImage(sendMark, for: .normal)
            tintColor = .black
        }
        imageView?.contentMode = .scaleAspectFit
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = bounds.height / 2
    }
}

private final class SuliJoyLagoonLetterCell: UITableViewCell {
    private let card = UIView()
    private let portrait = UIImageView()
    private let nameLabel = UILabel()
    private let previewLabel = UILabel()
    private let timeLabel = UILabel()
    private let unreadLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = UIColor.white.withAlphaComponent(0.92)
        card.layer.cornerRadius = 18
        portrait.translatesAutoresizingMaskIntoConstraints = false
        portrait.contentMode = .scaleAspectFill
        portrait.clipsToBounds = true
        portrait.layer.cornerRadius = 22
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = .suliInk
        previewLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        previewLabel.textColor = .suliMutedInk
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        timeLabel.textColor = .suliMutedInk
        unreadLabel.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        unreadLabel.textColor = .white
        unreadLabel.backgroundColor = UIColor(red: 1, green: 0.35, blue: 0.35, alpha: 1)
        unreadLabel.textAlignment = .center
        unreadLabel.layer.cornerRadius = 9
        unreadLabel.clipsToBounds = true
        [nameLabel, previewLabel, timeLabel, unreadLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        contentView.addSubview(card)
        [portrait, nameLabel, previewLabel, timeLabel, unreadLabel].forEach { card.addSubview($0) }
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            portrait.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            portrait.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            portrait.widthAnchor.constraint(equalToConstant: 44),
            portrait.heightAnchor.constraint(equalToConstant: 44),
            nameLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),
            nameLabel.leadingAnchor.constraint(equalTo: portrait.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -8),
            timeLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            previewLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            previewLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            previewLabel.trailingAnchor.constraint(lessThanOrEqualTo: unreadLabel.leadingAnchor, constant: -8),
            unreadLabel.centerYAnchor.constraint(equalTo: previewLabel.centerYAnchor),
            unreadLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            unreadLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 18),
            unreadLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(_ thread: SuliJoyLagoonLetterThread) {
        portrait.suliJoyApplyPortrait(thread.portraitToken)
        nameLabel.text = thread.peerName.isEmpty ? "Stylist" : thread.peerName
        previewLabel.text = thread.blocked ? "This chat is unavailable." : thread.preview
        timeLabel.text = thread.momentLine
        unreadLabel.isHidden = thread.unread <= 0
        unreadLabel.text = thread.unread > 99 ? "99+" : "\(thread.unread)"
    }
}

private final class SuliJoyLagoonLetterNoteCell: UITableViewCell {
    private enum NoteMetric {
        static let side: CGFloat = 16
        static let portraitSide: CGFloat = 40
        static let bubbleGap: CGFloat = 8
        static let bubbleMaxRatio: CGFloat = 0.72
    }

    private let timestampLabel = UILabel()
    private let peerPortrait = UIImageView()
    private let ownPortrait = UIImageView()
    private let bubbleShell = UIView()
    private let bubbleLabel = UILabel()
    private var incomingLeading: NSLayoutConstraint?
    private var incomingLeadingEdge: NSLayoutConstraint?
    private var incomingPortraitWidth: NSLayoutConstraint?
    private var outgoingTrailing: NSLayoutConstraint?
    private var outgoingTrailingEdge: NSLayoutConstraint?
    private var outgoingPortraitWidth: NSLayoutConstraint?
    private var bubbleTopToTimestamp: NSLayoutConstraint?
    private var bubbleTopToContent: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        timestampLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        timestampLabel.textColor = UIColor(red: 0.79, green: 0.69, blue: 0.42, alpha: 1)
        timestampLabel.textAlignment = .center

        [peerPortrait, ownPortrait].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = NoteMetric.portraitSide / 2
            $0.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)
        }

        bubbleShell.translatesAutoresizingMaskIntoConstraints = false
        bubbleShell.layer.cornerRadius = 18
        bubbleShell.layer.cornerCurve = .continuous
        bubbleShell.clipsToBounds = true

        bubbleLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        bubbleLabel.numberOfLines = 0
        bubbleShell.addSubview(bubbleLabel)

        [timestampLabel, peerPortrait, ownPortrait, bubbleShell].forEach { contentView.addSubview($0) }

        incomingLeading = bubbleShell.leadingAnchor.constraint(equalTo: peerPortrait.trailingAnchor, constant: NoteMetric.bubbleGap)
        incomingLeadingEdge = bubbleShell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: NoteMetric.side)
        incomingPortraitWidth = peerPortrait.widthAnchor.constraint(equalToConstant: NoteMetric.portraitSide)
        outgoingTrailing = bubbleShell.trailingAnchor.constraint(equalTo: ownPortrait.leadingAnchor, constant: -NoteMetric.bubbleGap)
        outgoingTrailingEdge = bubbleShell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -NoteMetric.side)
        outgoingPortraitWidth = ownPortrait.widthAnchor.constraint(equalToConstant: NoteMetric.portraitSide)
        bubbleTopToTimestamp = bubbleShell.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: 10)
        bubbleTopToContent = bubbleShell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4)

        NSLayoutConstraint.activate([
            timestampLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            timestampLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timestampLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: NoteMetric.side),

            peerPortrait.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: NoteMetric.side),
            peerPortrait.bottomAnchor.constraint(equalTo: bubbleShell.bottomAnchor),
            peerPortrait.heightAnchor.constraint(equalToConstant: NoteMetric.portraitSide),
            incomingPortraitWidth!,

            ownPortrait.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -NoteMetric.side),
            ownPortrait.bottomAnchor.constraint(equalTo: bubbleShell.bottomAnchor),
            ownPortrait.heightAnchor.constraint(equalToConstant: NoteMetric.portraitSide),
            outgoingPortraitWidth!,

            bubbleShell.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: NoteMetric.bubbleMaxRatio),
            bubbleShell.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 56),
            bubbleShell.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -NoteMetric.side),
            bubbleShell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            bubbleLabel.topAnchor.constraint(equalTo: bubbleShell.topAnchor, constant: 10),
            bubbleLabel.leadingAnchor.constraint(equalTo: bubbleShell.leadingAnchor, constant: 14),
            bubbleLabel.trailingAnchor.constraint(equalTo: bubbleShell.trailingAnchor, constant: -14),
            bubbleLabel.bottomAnchor.constraint(equalTo: bubbleShell.bottomAnchor, constant: -10)
        ])
        bubbleTopToContent?.isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(
        note: SuliJoyLagoonLetterNote,
        peerPortraitToken: String,
        ownPortraitToken: String,
        showsTimestamp: Bool,
        showsOwnAvatar: Bool,
        showsPeerAvatar: Bool
    ) {
        bubbleLabel.text = note.text
        timestampLabel.text = note.momentLine
        timestampLabel.isHidden = !showsTimestamp

        bubbleTopToTimestamp?.isActive = showsTimestamp
        bubbleTopToContent?.isActive = !showsTimestamp

        [incomingLeading, incomingLeadingEdge, outgoingTrailing, outgoingTrailingEdge].forEach { $0?.isActive = false }

        if note.own {
            bubbleShell.backgroundColor = UIColor(red: 1, green: 0.70, blue: 0.50, alpha: 1)
            bubbleLabel.textColor = .white
            peerPortrait.isHidden = true
            ownPortrait.isHidden = !showsOwnAvatar
            ownPortrait.suliJoyApplyPortrait(ownPortraitToken)
            outgoingPortraitWidth?.constant = showsOwnAvatar ? NoteMetric.portraitSide : 0
            if showsOwnAvatar {
                outgoingTrailing?.isActive = true
            } else {
                outgoingTrailingEdge?.isActive = true
            }
        } else {
            bubbleShell.backgroundColor = .white
            bubbleLabel.textColor = .suliInk
            ownPortrait.isHidden = true
            peerPortrait.isHidden = !showsPeerAvatar
            peerPortrait.suliJoyApplyPortrait(peerPortraitToken)
            incomingPortraitWidth?.constant = showsPeerAvatar ? NoteMetric.portraitSide : 0
            if showsPeerAvatar {
                incomingLeading?.isActive = true
            } else {
                incomingLeadingEdge?.isActive = true
            }
        }
    }
}
