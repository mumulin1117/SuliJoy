import UIKit

private enum SuliJoyLagoonBoardMeasure {
    static let pageSide: CGFloat = 16
    static let headerTop: CGFloat = 8
    static let chatSide: CGFloat = 44
    static let listBottom: CGFloat = 116
}

private func suliJoyCoverImage(named token: String) -> UIImage? {
    UIImage.suliJoyPhoto(named: token)
}

private enum SuliJoyLagoonCrownStyle {
    case brand
    case islandLive
    case community
}

final class SuliJoyLagoonModuleCrown: UIView {
    let pearlButton = SuliJoyShellGemPillButton(shellWidth: 92, shellHeight: 40)
    let chatButton = UIButton(type: .custom)
    private var roundsChatShadow = false

    fileprivate init(style: SuliJoyLagoonCrownStyle) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        let mark = makeMark(style)
        roundsChatShadow = true
        let chatSide = SuliJoyLagoonBoardMeasure.chatSide
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        chatButton.backgroundColor = .white
        chatButton.layer.cornerRadius = chatSide / 2
        chatButton.layer.shadowColor = UIColor.black.withAlphaComponent(0.06).cgColor
        chatButton.layer.shadowOpacity = 1
        chatButton.layer.shadowRadius = 8
        chatButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        chatButton.setImage(UIImage(named: "sulijoy_cove_search_mark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        chatButton.imageView?.contentMode = .scaleAspectFit
        chatButton.accessibilityLabel = "Chat"
        addSubview(mark)
        addSubview(pearlButton)
        addSubview(chatButton)
        NSLayoutConstraint.activate([
            mark.leadingAnchor.constraint(equalTo: leadingAnchor),
            mark.centerYAnchor.constraint(equalTo: centerYAnchor),
            mark.trailingAnchor.constraint(lessThanOrEqualTo: pearlButton.leadingAnchor, constant: -8),
            chatButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            chatButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            chatButton.widthAnchor.constraint(equalToConstant: chatSide),
            chatButton.heightAnchor.constraint(equalToConstant: chatSide),
            pearlButton.trailingAnchor.constraint(equalTo: chatButton.leadingAnchor, constant: -10),
            pearlButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard roundsChatShadow else { return }
        chatButton.layer.shadowPath = UIBezierPath(ovalIn: chatButton.bounds).cgPath
    }

    func refreshPearlBalance() {
        pearlButton.setShellGemTally(SuliJoyShellPearlStore.shared.currentPearlBalance())
    }

    private func makeMark(_ style: SuliJoyLagoonCrownStyle) -> UIView {
        switch style {
        case .brand:
            let logo = UIImageView(image: UIImage(named: "sulijoyHaidao"))
            logo.translatesAutoresizingMaskIntoConstraints = false
            logo.contentMode = .scaleAspectFit
            logo.heightAnchor.constraint(equalToConstant: 44).isActive = true
            logo.widthAnchor.constraint(equalToConstant: 148).isActive = true
            return logo
        case .islandLive:
            let logo = UIImageView(image: UIImage(named: "sulijoy_live_board_title")?.withRenderingMode(.alwaysOriginal))
            logo.translatesAutoresizingMaskIntoConstraints = false
            logo.contentMode = .scaleAspectFit
            logo.heightAnchor.constraint(equalToConstant: 40).isActive = true
            logo.widthAnchor.constraint(equalTo: logo.heightAnchor, multiplier: 348.0 / 80.0).isActive = true
            return logo
        case .community:
            return makeTitlePill(symbol: "film.fill", title: "Community")
        }
    }

    private func makeTitlePill(symbol: String, title: String) -> UIView {
        let pill = UIView()
        pill.translatesAutoresizingMaskIntoConstraints = false
        pill.backgroundColor = UIColor.white.withAlphaComponent(0.92)
        pill.layer.cornerRadius = 22
        let icon = UIImageView(image: UIImage(systemName: symbol))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = .suliInk
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = UIFont.systemFont(ofSize: 20, weight: .black)
        label.textColor = .suliInk
        pill.addSubview(icon)
        pill.addSubview(label)
        NSLayoutConstraint.activate([
            pill.heightAnchor.constraint(equalToConstant: 44),
            icon.leadingAnchor.constraint(equalTo: pill.leadingAnchor, constant: 14),
            icon.centerYAnchor.constraint(equalTo: pill.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 18),
            icon.heightAnchor.constraint(equalToConstant: 18),
            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: pill.trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: pill.centerYAnchor)
        ])
        return pill
    }
}

final class SuliJoyLagoonVoiceBoardController: SuliJoyTropicCanvasController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let crown = SuliJoyLagoonModuleCrown(style: .brand)
    private let roomCollection: UICollectionView
    private let emptyNote = UILabel()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private var laneButtons: [SuliJoyVoiceRoomLane: UIButton] = [:]
    private var laneMarks: [SuliJoyVoiceRoomLane: UIView] = [:]
    private var rooms: [SuliJoyLagoonVoiceCard] = []
    private var lane: SuliJoyVoiceRoomLane = .islandVibes

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = 12
        flow.minimumLineSpacing = 12
        roomCollection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        crown.pearlButton.addTarget(self, action: #selector(openPearlHarbor), for: .touchUpInside)
        crown.chatButton.addTarget(self, action: #selector(openChatList), for: .touchUpInside)
        let banner = makeActivityBanner()
        let lanes = makeLaneRow()
        tuneCollection()
        tuneEmptyNote()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        [crown, banner, lanes, roomCollection, emptyNote, spinner].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            crown.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SuliJoyLagoonBoardMeasure.headerTop),
            crown.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SuliJoyLagoonBoardMeasure.pageSide),
            crown.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SuliJoyLagoonBoardMeasure.pageSide),
            banner.topAnchor.constraint(equalTo: crown.bottomAnchor, constant: 14),
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            banner.heightAnchor.constraint(equalTo: banner.widthAnchor, multiplier: 168.0 / 750.0),
            lanes.topAnchor.constraint(equalTo: banner.bottomAnchor, constant: 16),
            lanes.leadingAnchor.constraint(equalTo: crown.leadingAnchor),
            lanes.trailingAnchor.constraint(equalTo: crown.trailingAnchor),
            lanes.heightAnchor.constraint(equalToConstant: 36),
            roomCollection.topAnchor.constraint(equalTo: lanes.bottomAnchor, constant: 8),
            roomCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            roomCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            roomCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyNote.centerXAnchor.constraint(equalTo: roomCollection.centerXAnchor),
            emptyNote.centerYAnchor.constraint(equalTo: roomCollection.centerYAnchor),
            emptyNote.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyNote.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            spinner.centerXAnchor.constraint(equalTo: roomCollection.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: roomCollection.centerYAnchor)
        ])
        paintLanes()
        reloadVoiceBoard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        crown.refreshPearlBalance()
    }

    private func tuneCollection() {
        roomCollection.translatesAutoresizingMaskIntoConstraints = false
        roomCollection.backgroundColor = .clear
        roomCollection.dataSource = self
        roomCollection.delegate = self
        roomCollection.alwaysBounceVertical = true
        roomCollection.contentInset = UIEdgeInsets(top: 4, left: 16, bottom: SuliJoyLagoonBoardMeasure.listBottom, right: 16)
        roomCollection.register(SuliJoyLagoonVoiceTileCell.self, forCellWithReuseIdentifier: "SuliJoyLagoonVoiceTileCell")
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reloadVoiceBoard), for: .valueChanged)
        roomCollection.refreshControl = refresh
    }

    private func tuneEmptyNote() {
        emptyNote.translatesAutoresizingMaskIntoConstraints = false
        emptyNote.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        emptyNote.textColor = .suliMutedInk
        emptyNote.textAlignment = .center
        emptyNote.numberOfLines = 0
        emptyNote.isHidden = true
    }

    private func makeActivityBanner() -> UIControl {
        let card = UIControl()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .clear
        card.addTarget(self, action: #selector(openActivityList), for: .touchUpInside)
        card.accessibilityLabel = "Create a look. Pass it on."
        card.isAccessibilityElement = true

        let art = UIImageView(image: UIImage(named: "sulijoy_home_activity_entry"))
        art.translatesAutoresizingMaskIntoConstraints = false
        art.contentMode = .scaleAspectFit
        art.isUserInteractionEnabled = false
        card.addSubview(art)
        NSLayoutConstraint.activate([
            art.topAnchor.constraint(equalTo: card.topAnchor),
            art.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            art.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            art.bottomAnchor.constraint(equalTo: card.bottomAnchor)
        ])
        return card
    }

    private func makeLaneRow() -> UIView {
        let row = UIStackView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.distribution = .fillEqually
        let lanes: [(SuliJoyVoiceRoomLane, String)] = [
            (.islandVibes, "Island Vibes"),
            (.styleTalk, "Style Talk"),
            (.meetMingle, "Meet & Mingle")
        ]
        for item in lanes {
            let column = UIStackView()
            column.axis = .vertical
            column.alignment = .center
            column.spacing = 4
            let button = UIButton(type: .system)
            button.setTitle(item.1, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.7
            button.tag = laneTag(item.0)
            button.addTarget(self, action: #selector(changeLane(_:)), for: .touchUpInside)
            let mark = SuliJoyGradientCapsuleView(colors: [
                UIColor(red: 1, green: 0.45, blue: 0.28, alpha: 1),
                UIColor(red: 1, green: 0.92, blue: 0.28, alpha: 1),
                UIColor(red: 0.45, green: 0.95, blue: 0.45, alpha: 1)
            ])
            mark.translatesAutoresizingMaskIntoConstraints = false
            column.addArrangedSubview(button)
            column.addArrangedSubview(mark)
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 24),
                mark.widthAnchor.constraint(equalToConstant: 28),
                mark.heightAnchor.constraint(equalToConstant: 5)
            ])
            row.addArrangedSubview(column)
            laneButtons[item.0] = button
            laneMarks[item.0] = mark
        }
        return row
    }

    private func laneTag(_ lane: SuliJoyVoiceRoomLane) -> Int {
        switch lane {
        case .islandVibes: return 0
        case .styleTalk: return 1
        case .meetMingle: return 2
        }
    }

    private func laneForTag(_ tag: Int) -> SuliJoyVoiceRoomLane {
        switch tag {
        case 1: return .styleTalk
        case 2: return .meetMingle
        default: return .islandVibes
        }
    }

    private func paintLanes() {
        for item in laneButtons {
            let active = item.key == lane
            item.value.setTitleColor(active ? .suliInk : .suliMutedInk, for: .normal)
            laneMarks[item.key]?.alpha = active ? 1 : 0
        }
    }

    @objc private func changeLane(_ sender: UIButton) {
        let next = laneForTag(sender.tag)
        guard next != lane else { return }
        lane = next
        paintLanes()
        rooms = []
        roomCollection.reloadData()
        reloadVoiceBoard()
    }

    @objc private func reloadVoiceBoard() {
        if rooms.isEmpty {
            spinner.startAnimating()
            emptyNote.isHidden = true
        }
        SuliJoyLagoonProfileRemoteService.shared.fetchVoiceBoard(lane: lane) { [weak self] result in
            guard let self else { return }
            self.spinner.stopAnimating()
            self.roomCollection.refreshControl?.endRefreshing()
            guard result.beachwearCapsule == 200 else {
                self.rooms = []
                self.roomCollection.reloadData()
                self.emptyNote.text = result.coastalWardrobe
                self.emptyNote.isHidden = false
                self.showLagoonToast(result.coastalWardrobe)
                return
            }
            self.rooms = result.sandbarLayering ?? []
            self.roomCollection.reloadData()
            self.emptyNote.text = "No voice rooms right now."
            self.emptyNote.isHidden = !self.rooms.isEmpty
        }
    }

    @objc private func openPearlHarbor() {
        pushShorePage(SuliJoyPearlHarborViewController())
    }

    @objc private func openChatList() {
        openSuliJoyLagoonLetters()
    }

    @objc private func openActivityList() {
        pushShorePage(SuliJoyForinController())
    }

    private func pushShorePage(_ page: UIViewController) {
        page.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(page, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        rooms.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuliJoyLagoonVoiceTileCell", for: indexPath) as! SuliJoyLagoonVoiceTileCell
        cell.applyVoiceCard(rooms[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right - 12) / 2)
        return CGSize(width: max(width, 120), height: max(width, 120) * 1.28)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let room = rooms[indexPath.item]
        let preview = SuliJoyLagoonRoomPreviewController(
            shoreTitle: room.place,
            hostLine: "Voice room",
            coverToken: room.coverToken,
            detailLine: room.summary
        )
        pushShorePage(preview)
    }
}

final class SuliJoyLagoonLiveBoardController: SuliJoyTropicCanvasController, UITableViewDataSource, UITableViewDelegate {
    private enum LiveSort {
        case forYou
        case following
        case trending
    }

    private let crown = SuliJoyLagoonModuleCrown(style: .islandLive)
    private let roomTable = UITableView(frame: .zero, style: .plain)
    private let emptyNote = UILabel()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private let categoryRow = UIStackView()
    private var categoryButtons: [String: UIControl] = [:]
    private var categoryCounts: [String: UILabel] = [:]
    private var sortButtons: [LiveSort: UIButton] = [:]
    private var sortMarks: [LiveSort: UIView] = [:]
    private var rooms: [SuliJoyLagoonLiveCard] = []
    private var sort: LiveSort = .forYou
    private let categories = ["Chill & Chat", "Style & Beauty", "Lifestyle"]

    override func viewDidLoad() {
        super.viewDidLoad()
        crown.pearlButton.addTarget(self, action: #selector(openPearlHarbor), for: .touchUpInside)
        crown.chatButton.addTarget(self, action: #selector(openChatList), for: .touchUpInside)
        tuneCategoryRow()
        let sorts = makeSortRow()
        tuneTable()
        tuneEmptyNote()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        [crown, categoryRow, sorts, roomTable, emptyNote, spinner].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            crown.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SuliJoyLagoonBoardMeasure.headerTop),
            crown.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SuliJoyLagoonBoardMeasure.pageSide),
            crown.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SuliJoyLagoonBoardMeasure.pageSide),
            categoryRow.topAnchor.constraint(equalTo: crown.bottomAnchor, constant: 14),
            categoryRow.leadingAnchor.constraint(equalTo: crown.leadingAnchor),
            categoryRow.trailingAnchor.constraint(equalTo: crown.trailingAnchor),
            sorts.topAnchor.constraint(equalTo: categoryRow.bottomAnchor, constant: 16),
            sorts.leadingAnchor.constraint(equalTo: crown.leadingAnchor),
            sorts.trailingAnchor.constraint(equalTo: crown.trailingAnchor),
            sorts.heightAnchor.constraint(equalToConstant: 34),
            roomTable.topAnchor.constraint(equalTo: sorts.bottomAnchor, constant: 8),
            roomTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            roomTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            roomTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyNote.centerXAnchor.constraint(equalTo: roomTable.centerXAnchor),
            emptyNote.topAnchor.constraint(equalTo: roomTable.topAnchor, constant: 36),
            emptyNote.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyNote.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            spinner.centerXAnchor.constraint(equalTo: roomTable.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: roomTable.centerYAnchor)
        ])
        paintSorts()
        reloadLiveBoard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        crown.refreshPearlBalance()
    }

    private func tuneCategoryRow() {
        categoryRow.translatesAutoresizingMaskIntoConstraints = false
        categoryRow.axis = .horizontal
        categoryRow.spacing = 12
        categoryRow.distribution = .fillEqually
        let artNames = [
            "sulijoy_live_category_chill",
            "sulijoy_live_category_style",
            "sulijoy_live_category_lifestyle"
        ]
        for (index, name) in categories.enumerated() {
            let card = UIControl()
            card.translatesAutoresizingMaskIntoConstraints = false
            card.layer.cornerRadius = 18
            card.clipsToBounds = true
            card.tag = index
            card.addTarget(self, action: #selector(changeCategory(_:)), for: .touchUpInside)

            let art = UIImageView(image: UIImage(named: artNames[index])?.withRenderingMode(.alwaysOriginal))
            art.translatesAutoresizingMaskIntoConstraints = false
            art.contentMode = .scaleAspectFill
            art.isUserInteractionEnabled = false

            let title = UILabel()
            title.translatesAutoresizingMaskIntoConstraints = false
            title.text = name
            title.font = UIFont.systemFont(ofSize: 13, weight: .black)
            title.textColor = .white
            title.numberOfLines = 2

            let countChip = UIView()
            countChip.translatesAutoresizingMaskIntoConstraints = false
            countChip.backgroundColor = UIColor.white.withAlphaComponent(0.28)
            countChip.layer.cornerRadius = 9
            countChip.clipsToBounds = true
            countChip.isUserInteractionEnabled = false

            let wave = UIImageView(image: UIImage(systemName: "waveform"))
            wave.translatesAutoresizingMaskIntoConstraints = false
            wave.tintColor = .white
            wave.contentMode = .scaleAspectFit

            let count = UILabel()
            count.translatesAutoresizingMaskIntoConstraints = false
            count.text = "0"
            count.font = UIFont.systemFont(ofSize: 11, weight: .bold)
            count.textColor = .white

            card.addSubview(art)
            card.addSubview(title)
            card.addSubview(countChip)
            countChip.addSubview(wave)
            countChip.addSubview(count)
            NSLayoutConstraint.activate([
                art.topAnchor.constraint(equalTo: card.topAnchor),
                art.leadingAnchor.constraint(equalTo: card.leadingAnchor),
                art.trailingAnchor.constraint(equalTo: card.trailingAnchor),
                art.bottomAnchor.constraint(equalTo: card.bottomAnchor),
                card.heightAnchor.constraint(equalTo: card.widthAnchor, multiplier: 164.0 / 222.0),
                title.topAnchor.constraint(equalTo: card.topAnchor, constant: 10),
                title.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10),
                title.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -6),
                countChip.leadingAnchor.constraint(equalTo: title.leadingAnchor),
                countChip.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6),
                countChip.heightAnchor.constraint(equalToConstant: 18),
                wave.leadingAnchor.constraint(equalTo: countChip.leadingAnchor, constant: 6),
                wave.centerYAnchor.constraint(equalTo: countChip.centerYAnchor),
                wave.widthAnchor.constraint(equalToConstant: 12),
                wave.heightAnchor.constraint(equalToConstant: 10),
                count.leadingAnchor.constraint(equalTo: wave.trailingAnchor, constant: 3),
                count.trailingAnchor.constraint(equalTo: countChip.trailingAnchor, constant: -6),
                count.centerYAnchor.constraint(equalTo: countChip.centerYAnchor)
            ])
            categoryRow.addArrangedSubview(card)
            categoryButtons[name] = card
            categoryCounts[name] = count
        }
    }

    private func makeSortRow() -> UIView {
        let row = UIStackView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.distribution = .fillEqually
        let sorts: [(LiveSort, String)] = [(.forYou, "For You"), (.following, "Following"), (.trending, "Trending")]
        for item in sorts {
            let column = UIStackView()
            column.axis = .vertical
            column.alignment = .center
            column.spacing = 3
            let button = UIButton(type: .system)
            button.setTitle(item.1, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
            button.addTarget(self, action: #selector(changeSort(_:)), for: .touchUpInside)
            button.tag = item.0 == .forYou ? 0 : item.0 == .following ? 1 : 2
            let mark = SuliJoyGradientCapsuleView(colors: [
                UIColor(red: 1, green: 0.45, blue: 0.28, alpha: 1),
                UIColor(red: 0.55, green: 0.95, blue: 0.4, alpha: 1)
            ])
            mark.translatesAutoresizingMaskIntoConstraints = false
            column.addArrangedSubview(button)
            column.addArrangedSubview(mark)
            NSLayoutConstraint.activate([
                mark.widthAnchor.constraint(equalToConstant: 26),
                mark.heightAnchor.constraint(equalToConstant: 5)
            ])
            row.addArrangedSubview(column)
            sortButtons[item.0] = button
            sortMarks[item.0] = mark
        }
        return row
    }

    private func paintSorts() {
        for item in sortButtons {
            item.value.setTitleColor(item.key == sort ? .suliInk : .suliMutedInk, for: .normal)
            sortMarks[item.key]?.alpha = item.key == sort ? 1 : 0
        }
    }

    private var visibleRooms: [SuliJoyLagoonLiveCard] {
        switch sort {
        case .forYou:
            return rooms
        case .following:
            return rooms.filter(\.followed)
        case .trending:
            return rooms.sorted { $0.onlineCount > $1.onlineCount }
        }
    }

    @objc private func changeCategory(_ sender: UIControl) {
        let page = SuliJoyLagoonLiveCategoryController(category: categories[sender.tag])
        page.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(page, animated: true)
    }

    @objc private func changeSort(_ sender: UIButton) {
        sort = sender.tag == 1 ? .following : sender.tag == 2 ? .trending : .forYou
        paintSorts()
        roomTable.reloadData()
        emptyNote.isHidden = !visibleRooms.isEmpty
        emptyNote.text = "No live rooms right now."
    }

    private func tuneTable() {
        roomTable.translatesAutoresizingMaskIntoConstraints = false
        roomTable.backgroundColor = .clear
        roomTable.separatorStyle = .none
        roomTable.dataSource = self
        roomTable.delegate = self
        roomTable.rowHeight = 118
        roomTable.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: SuliJoyLagoonBoardMeasure.listBottom, right: 0)
        roomTable.register(SuliJoyLagoonLiveRowCell.self, forCellReuseIdentifier: "SuliJoyLagoonLiveRowCell")
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reloadLiveBoard), for: .valueChanged)
        roomTable.refreshControl = refresh
    }

    private func tuneEmptyNote() {
        emptyNote.translatesAutoresizingMaskIntoConstraints = false
        emptyNote.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        emptyNote.textColor = .suliMutedInk
        emptyNote.textAlignment = .center
        emptyNote.numberOfLines = 0
        emptyNote.isHidden = true
    }

    @objc private func reloadLiveBoard() {
        if rooms.isEmpty { spinner.startAnimating() }
        SuliJoyLagoonProfileRemoteService.shared.fetchLiveBoard { [weak self] result in
            guard let self else { return }
            self.spinner.stopAnimating()
            self.roomTable.refreshControl?.endRefreshing()
            guard result.beachwearCapsule == 200, let shelf = result.sandbarLayering else {
                self.rooms = []
                self.roomTable.reloadData()
                self.emptyNote.text = result.coastalWardrobe
                self.emptyNote.isHidden = false
                self.showLagoonToast(result.coastalWardrobe)
                return
            }
            self.rooms = shelf.cards
            let tally = "\(shelf.total)"
            self.categoryCounts.values.forEach { $0.text = tally }
            self.roomTable.reloadData()
            self.emptyNote.text = "No live rooms right now."
            self.emptyNote.isHidden = !self.visibleRooms.isEmpty
        }
    }

    @objc private func openPearlHarbor() {
        let page = SuliJoyPearlHarborViewController()
        page.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(page, animated: true)
    }

    @objc private func openChatList() {
        openSuliJoyLagoonLetters()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        visibleRooms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuliJoyLagoonLiveRowCell", for: indexPath) as! SuliJoyLagoonLiveRowCell
        cell.applyLiveCard(visibleRooms[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let room = visibleRooms[indexPath.row]
        let preview = SuliJoyLagoonRoomPreviewController(
            shoreTitle: room.title,
            hostLine: room.subtitle,
            coverToken: room.coverToken,
            detailLine: "\(room.onlineCount) watching"
        )
        preview.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(preview, animated: true)
    }
}

final class SuliJoyLagoonLiveCategoryController: SuliJoyTropicCanvasController, UITableViewDataSource, UITableViewDelegate {
    private let categoryName: String
    private let roomTable = UITableView(frame: .zero, style: .plain)
    private let emptyNote = UILabel()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private var rooms: [SuliJoyLagoonLiveCard] = []

    init(category: String) {
        categoryName = category
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let header = makeShoreHeader()
        tuneTable()
        tuneEmptyNote()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        [header, roomTable, emptyNote, spinner].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            header.heightAnchor.constraint(equalToConstant: 44),
            roomTable.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12),
            roomTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            roomTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            roomTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyNote.centerXAnchor.constraint(equalTo: roomTable.centerXAnchor),
            emptyNote.topAnchor.constraint(equalTo: roomTable.topAnchor, constant: 36),
            emptyNote.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyNote.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            spinner.centerXAnchor.constraint(equalTo: roomTable.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: roomTable.centerYAnchor)
        ])
        reloadCategoryBoard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    private func makeShoreHeader() -> UIView {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.tintColor = .suliInk
        back.addTarget(self, action: #selector(returnToLiveBoard), for: .touchUpInside)
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = categoryName
        title.font = UIFont.systemFont(ofSize: 22, weight: .black)
        title.textColor = .suliInk
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.7
        header.addSubview(back)
        header.addSubview(title)
        NSLayoutConstraint.activate([
            back.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            back.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            back.widthAnchor.constraint(equalToConstant: 44),
            back.heightAnchor.constraint(equalToConstant: 44),
            title.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            title.leadingAnchor.constraint(greaterThanOrEqualTo: back.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(lessThanOrEqualTo: header.trailingAnchor, constant: -56)
        ])
        return header
    }

    private func tuneTable() {
        roomTable.translatesAutoresizingMaskIntoConstraints = false
        roomTable.backgroundColor = .clear
        roomTable.separatorStyle = .none
        roomTable.dataSource = self
        roomTable.delegate = self
        roomTable.rowHeight = 118
        roomTable.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 28, right: 0)
        roomTable.register(SuliJoyLagoonLiveRowCell.self, forCellReuseIdentifier: "SuliJoyLagoonLiveRowCell")
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(reloadCategoryBoard), for: .valueChanged)
        roomTable.refreshControl = refresh
    }

    private func tuneEmptyNote() {
        emptyNote.translatesAutoresizingMaskIntoConstraints = false
        emptyNote.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        emptyNote.textColor = .suliMutedInk
        emptyNote.textAlignment = .center
        emptyNote.numberOfLines = 0
        emptyNote.isHidden = true
    }

    @objc private func reloadCategoryBoard() {
        if rooms.isEmpty { spinner.startAnimating() }
        SuliJoyLagoonProfileRemoteService.shared.fetchLiveBoard(category: categoryName) { [weak self] result in
            guard let self else { return }
            self.spinner.stopAnimating()
            self.roomTable.refreshControl?.endRefreshing()
            guard result.beachwearCapsule == 200, let shelf = result.sandbarLayering else {
                self.rooms = []
                self.roomTable.reloadData()
                self.emptyNote.text = result.coastalWardrobe
                self.emptyNote.isHidden = false
                self.showLagoonToast(result.coastalWardrobe)
                return
            }
            self.rooms = shelf.cards
            self.roomTable.reloadData()
            self.emptyNote.text = "No live rooms right now."
            self.emptyNote.isHidden = !self.rooms.isEmpty
        }
    }

    @objc private func returnToLiveBoard() {
        navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rooms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuliJoyLagoonLiveRowCell", for: indexPath) as! SuliJoyLagoonLiveRowCell
        cell.applyLiveCard(rooms[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let room = rooms[indexPath.row]
        let preview = SuliJoyLagoonRoomPreviewController(
            shoreTitle: room.title,
            hostLine: room.subtitle,
            coverToken: room.coverToken,
            detailLine: "\(room.onlineCount) watching"
        )
        preview.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(preview, animated: true)
    }
}

final class SuliJoyShoreCatalogController: SuliJoyTropicCanvasController {
    private let crown = SuliJoyLagoonModuleCrown(style: .community)
    private let postButton = UIButton(type: .system)
    private let shortsButton = UIButton(type: .system)
    private let selectionWash = SuliJoyGradientCapsuleView(colors: [
        UIColor(red: 1, green: 0.72, blue: 0.35, alpha: 1),
        UIColor(red: 0.72, green: 0.95, blue: 0.45, alpha: 1)
    ])
    private let postFeed = SuliJoyShoortController()
    private let shortsFeed = suliJoyShorelineIntent()
    private var showsPosts = true
    private var selectionLeading: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        crown.pearlButton.addTarget(self, action: #selector(openPearlHarbor), for: .touchUpInside)
        crown.chatButton.addTarget(self, action: #selector(openChatList), for: .touchUpInside)
        let switcher = makeSwitcher()
        let stage = UIView()
        stage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(crown)
        view.addSubview(switcher)
        view.addSubview(stage)
        NSLayoutConstraint.activate([
            crown.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SuliJoyLagoonBoardMeasure.headerTop),
            crown.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SuliJoyLagoonBoardMeasure.pageSide),
            crown.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SuliJoyLagoonBoardMeasure.pageSide),
            switcher.topAnchor.constraint(equalTo: crown.bottomAnchor, constant: 12),
            switcher.leadingAnchor.constraint(equalTo: crown.leadingAnchor),
            switcher.trailingAnchor.constraint(equalTo: crown.trailingAnchor),
            switcher.heightAnchor.constraint(equalToConstant: 48),
            stage.topAnchor.constraint(equalTo: switcher.bottomAnchor, constant: 6),
            stage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        postFeed.hidesShoreCrown = true
        shortsFeed.hidesShorelineCrown = true
        mount(postFeed, in: stage)
        mount(shortsFeed, in: stage)
        shortsFeed.view.isHidden = true
        paintSwitcher()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        crown.refreshPearlBalance()
    }

    private func makeSwitcher() -> UIView {
        let track = UIView()
        track.translatesAutoresizingMaskIntoConstraints = false
        track.backgroundColor = UIColor.white.withAlphaComponent(0.92)
        track.layer.cornerRadius = 24
        selectionWash.translatesAutoresizingMaskIntoConstraints = false
        postButton.translatesAutoresizingMaskIntoConstraints = false
        shortsButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.setTitle("Post", for: .normal)
        shortsButton.setTitle("Shorts", for: .normal)
        postButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        shortsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        postButton.addTarget(self, action: #selector(showPosts), for: .touchUpInside)
        shortsButton.addTarget(self, action: #selector(showShorts), for: .touchUpInside)
        track.addSubview(selectionWash)
        track.addSubview(postButton)
        track.addSubview(shortsButton)
        selectionLeading = selectionWash.leadingAnchor.constraint(equalTo: track.leadingAnchor, constant: 4)
        NSLayoutConstraint.activate([
            selectionLeading!,
            selectionWash.centerYAnchor.constraint(equalTo: track.centerYAnchor),
            selectionWash.heightAnchor.constraint(equalToConstant: 40),
            selectionWash.widthAnchor.constraint(equalTo: track.widthAnchor, multiplier: 0.5, constant: -6),
            postButton.leadingAnchor.constraint(equalTo: track.leadingAnchor),
            postButton.topAnchor.constraint(equalTo: track.topAnchor),
            postButton.bottomAnchor.constraint(equalTo: track.bottomAnchor),
            postButton.widthAnchor.constraint(equalTo: track.widthAnchor, multiplier: 0.5),
            shortsButton.trailingAnchor.constraint(equalTo: track.trailingAnchor),
            shortsButton.topAnchor.constraint(equalTo: track.topAnchor),
            shortsButton.bottomAnchor.constraint(equalTo: track.bottomAnchor),
            shortsButton.widthAnchor.constraint(equalTo: track.widthAnchor, multiplier: 0.5)
        ])
        return track
    }

    private func mount(_ child: UIViewController, in stage: UIView) {
        addChild(child)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        stage.addSubview(child.view)
        NSLayoutConstraint.activate([
            child.view.topAnchor.constraint(equalTo: stage.topAnchor),
            child.view.leadingAnchor.constraint(equalTo: stage.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: stage.trailingAnchor),
            child.view.bottomAnchor.constraint(equalTo: stage.bottomAnchor)
        ])
        child.didMove(toParent: self)
    }

    private func paintSwitcher() {
        postButton.setTitleColor(showsPosts ? .suliInk : .suliMutedInk, for: .normal)
        shortsButton.setTitleColor(showsPosts ? .suliMutedInk : .suliInk, for: .normal)
        postFeed.view.isHidden = !showsPosts
        shortsFeed.view.isHidden = showsPosts
    }

    @objc private func showPosts() {
        guard !showsPosts else { return }
        showsPosts = true
        selectionLeading?.constant = 4
        UIView.animate(withDuration: 0.2) { self.view.layoutIfNeeded() }
        paintSwitcher()
    }

    @objc private func showShorts() {
        guard showsPosts else { return }
        showsPosts = false
        let travel = (postButton.superview?.bounds.width ?? 0) / 2
        selectionLeading?.constant = max(travel, 4)
        UIView.animate(withDuration: 0.2) { self.view.layoutIfNeeded() }
        paintSwitcher()
    }

    @objc private func openPearlHarbor() {
        let page = SuliJoyPearlHarborViewController()
        page.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(page, animated: true)
    }

    @objc private func openChatList() {
        openSuliJoyLagoonLetters()
    }
}

final class SuliJoyLagoonRoomPreviewController: SuliJoyTropicCanvasController {
    private let shoreTitle: String
    private let hostLine: String
    private let coverToken: String
    private let detailLine: String

    init(shoreTitle: String, hostLine: String, coverToken: String, detailLine: String) {
        self.shoreTitle = shoreTitle
        self.hostLine = hostLine
        self.coverToken = coverToken
        self.detailLine = detailLine
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        let back = UIButton(type: .system)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.tintColor = .suliInk
        back.addTarget(self, action: #selector(sailBack), for: .touchUpInside)
        let cover = UIImageView(image: suliJoyCoverImage(named: coverToken))
        cover.translatesAutoresizingMaskIntoConstraints = false
        cover.contentMode = .scaleAspectFill
        cover.clipsToBounds = true
        cover.layer.cornerRadius = 24
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = shoreTitle
        title.font = UIFont.systemFont(ofSize: 24, weight: .black)
        title.textColor = .suliInk
        title.numberOfLines = 2
        let host = UILabel()
        host.translatesAutoresizingMaskIntoConstraints = false
        host.text = hostLine
        host.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        host.textColor = .suliMutedInk
        let detail = UILabel()
        detail.translatesAutoresizingMaskIntoConstraints = false
        detail.text = detailLine
        detail.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        detail.textColor = .suliInk
        detail.numberOfLines = 0
        [back, cover, title, host, detail].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            back.widthAnchor.constraint(equalToConstant: 44),
            back.heightAnchor.constraint(equalToConstant: 44),
            cover.topAnchor.constraint(equalTo: back.bottomAnchor, constant: 12),
            cover.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cover.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cover.heightAnchor.constraint(equalTo: cover.widthAnchor, multiplier: 0.62),
            title.topAnchor.constraint(equalTo: cover.bottomAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: cover.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: cover.trailingAnchor),
            host.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6),
            host.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            host.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            detail.topAnchor.constraint(equalTo: host.bottomAnchor, constant: 12),
            detail.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            detail.trailingAnchor.constraint(equalTo: title.trailingAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    @objc private func sailBack() {
        navigationController?.popViewController(animated: true)
    }
}

private final class SuliJoyLagoonVoiceTileCell: UICollectionViewCell {
    private let coverView = UIImageView()
    private let hostChip = UIView()
    private let hostAvatar = UIImageView()
    private let hostName = UILabel()
    private let heatChip = UIView()
    private let heatIcon = UIImageView()
    private let heatLabel = UILabel()
    private let peopleChip = UIView()
    private let faceRow = UIStackView()
    private let extraLabel = UILabel()
    private let summaryLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 18
        contentView.clipsToBounds = true

        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.contentMode = .scaleAspectFill

        let veil = UIColor.black.withAlphaComponent(0.42)
        hostChip.translatesAutoresizingMaskIntoConstraints = false
        hostChip.backgroundColor = veil
        hostChip.layer.cornerRadius = 13
        hostChip.clipsToBounds = true

        hostAvatar.translatesAutoresizingMaskIntoConstraints = false
        hostAvatar.contentMode = .scaleAspectFill
        hostAvatar.clipsToBounds = true
        hostAvatar.layer.cornerRadius = 9

        hostName.translatesAutoresizingMaskIntoConstraints = false
        hostName.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        hostName.textColor = .white
        hostName.lineBreakMode = .byTruncatingTail

        heatChip.translatesAutoresizingMaskIntoConstraints = false
        heatChip.backgroundColor = UIColor(red: 0.49, green: 0.32, blue: 0.98, alpha: 1)
        heatChip.layer.cornerRadius = 13
        heatChip.clipsToBounds = true

        heatIcon.translatesAutoresizingMaskIntoConstraints = false
        heatIcon.image = UIImage(named: "sulijoy_voice_heat")?.withRenderingMode(.alwaysOriginal)
        heatIcon.contentMode = .scaleAspectFit

        heatLabel.translatesAutoresizingMaskIntoConstraints = false
        heatLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        heatLabel.textColor = .white

        peopleChip.translatesAutoresizingMaskIntoConstraints = false
        peopleChip.backgroundColor = veil
        peopleChip.layer.cornerRadius = 14
        peopleChip.clipsToBounds = true

        faceRow.translatesAutoresizingMaskIntoConstraints = false
        faceRow.axis = .horizontal
        faceRow.spacing = -8

        extraLabel.translatesAutoresizingMaskIntoConstraints = false
        extraLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        extraLabel.textColor = .white

        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        summaryLabel.textColor = .white
        summaryLabel.numberOfLines = 2

        contentView.addSubview(coverView)
        contentView.addSubview(hostChip)
        hostChip.addSubview(hostAvatar)
        hostChip.addSubview(hostName)
        contentView.addSubview(heatChip)
        heatChip.addSubview(heatIcon)
        heatChip.addSubview(heatLabel)
        contentView.addSubview(peopleChip)
        peopleChip.addSubview(faceRow)
        peopleChip.addSubview(extraLabel)
        contentView.addSubview(summaryLabel)

        hostChip.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        hostName.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        heatChip.setContentCompressionResistancePriority(.required, for: .horizontal)
        heatChip.setContentHuggingPriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            coverView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hostChip.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            hostChip.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            hostChip.trailingAnchor.constraint(lessThanOrEqualTo: heatChip.leadingAnchor, constant: -6),
            hostChip.heightAnchor.constraint(equalToConstant: 26),
            hostAvatar.leadingAnchor.constraint(equalTo: hostChip.leadingAnchor, constant: 4),
            hostAvatar.centerYAnchor.constraint(equalTo: hostChip.centerYAnchor),
            hostAvatar.widthAnchor.constraint(equalToConstant: 18),
            hostAvatar.heightAnchor.constraint(equalToConstant: 18),
            hostName.leadingAnchor.constraint(equalTo: hostAvatar.trailingAnchor, constant: 5),
            hostName.trailingAnchor.constraint(equalTo: hostChip.trailingAnchor, constant: -8),
            hostName.centerYAnchor.constraint(equalTo: hostChip.centerYAnchor),
            heatChip.topAnchor.constraint(equalTo: hostChip.topAnchor),
            heatChip.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            heatChip.heightAnchor.constraint(equalToConstant: 26),
            heatIcon.leadingAnchor.constraint(equalTo: heatChip.leadingAnchor, constant: 8),
            heatIcon.centerYAnchor.constraint(equalTo: heatChip.centerYAnchor),
            heatIcon.widthAnchor.constraint(equalToConstant: 10),
            heatIcon.heightAnchor.constraint(equalToConstant: 13),
            heatLabel.leadingAnchor.constraint(equalTo: heatIcon.trailingAnchor, constant: 3),
            heatLabel.trailingAnchor.constraint(equalTo: heatChip.trailingAnchor, constant: -8),
            heatLabel.centerYAnchor.constraint(equalTo: heatChip.centerYAnchor),
            summaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            summaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            summaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            peopleChip.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            peopleChip.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            peopleChip.bottomAnchor.constraint(equalTo: summaryLabel.topAnchor, constant: -6),
            peopleChip.heightAnchor.constraint(equalToConstant: 28),
            faceRow.leadingAnchor.constraint(equalTo: peopleChip.leadingAnchor, constant: 4),
            faceRow.centerYAnchor.constraint(equalTo: peopleChip.centerYAnchor),
            faceRow.heightAnchor.constraint(equalToConstant: 22),
            extraLabel.leadingAnchor.constraint(equalTo: faceRow.trailingAnchor, constant: 6),
            extraLabel.trailingAnchor.constraint(equalTo: peopleChip.trailingAnchor, constant: -8),
            extraLabel.centerYAnchor.constraint(equalTo: peopleChip.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        faceRow.arrangedSubviews.forEach {
            faceRow.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    func applyVoiceCard(_ card: SuliJoyLagoonVoiceCard) {
        coverView.image = suliJoyCoverImage(named: card.coverToken)
        hostAvatar.image = UIImage.suliJoyPortrait(named: card.hostPortraitToken)
        hostName.text = card.hostName
        heatLabel.text = "\(card.heat)"
        summaryLabel.text = card.summary
        let faces = Array(card.faceTokens.prefix(2))
        let shown = faces.isEmpty ? [""] : faces
        for token in shown {
            let face = UIImageView(image: UIImage.suliJoyPortrait(named: token))
            face.translatesAutoresizingMaskIntoConstraints = false
            face.contentMode = .scaleAspectFill
            face.clipsToBounds = true
            face.layer.cornerRadius = 11
            face.layer.borderWidth = 1
            face.layer.borderColor = UIColor.white.cgColor
            faceRow.addArrangedSubview(face)
            face.widthAnchor.constraint(equalToConstant: 22).isActive = true
            face.heightAnchor.constraint(equalToConstant: 22).isActive = true
        }
        extraLabel.text = "+\(max(card.audience, shown.count))"
    }
}

private final class SuliJoyLagoonLiveRowCell: UITableViewCell {
    private let card = UIView()
    private let portraitRing = UIView()
    private let portraitRingLayer = CAGradientLayer()
    private let portraitView = UIImageView()
    private let liveBadge = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let heatChip = UIView()
    private let heatIcon = UIImageView()
    private let heatLabel = UILabel()
    private let tagRow = UIStackView()
    private let bottomRow = UIStackView()
    private let tagPrimary = UILabel()
    private let tagSecondary = UILabel()
    private let faceRow = UIStackView()
    private let extraChip = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .white
        card.layer.cornerRadius = 24

        portraitRing.translatesAutoresizingMaskIntoConstraints = false
        portraitRingLayer.colors = [
            UIColor(red: 1, green: 0.45, blue: 0.28, alpha: 1).cgColor,
            UIColor(red: 0.55, green: 0.95, blue: 0.4, alpha: 1).cgColor
        ]
        portraitRingLayer.startPoint = CGPoint(x: 0, y: 0.5)
        portraitRingLayer.endPoint = CGPoint(x: 1, y: 0.5)
        portraitRing.layer.addSublayer(portraitRingLayer)
        portraitView.translatesAutoresizingMaskIntoConstraints = false
        portraitView.contentMode = .scaleAspectFill
        portraitView.clipsToBounds = true
        portraitView.layer.cornerRadius = 28
        portraitView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.98, alpha: 1)

        liveBadge.translatesAutoresizingMaskIntoConstraints = false
        liveBadge.image = UIImage(named: "sulijoy_live_badge")?.withRenderingMode(.alwaysOriginal)
        liveBadge.contentMode = .scaleAspectFit

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .suliInk
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        subtitleLabel.textColor = .suliMutedInk

        heatChip.translatesAutoresizingMaskIntoConstraints = false
        heatChip.backgroundColor = UIColor.black.withAlphaComponent(0.08)
        heatChip.layer.cornerRadius = 11
        heatChip.clipsToBounds = true
        heatIcon.translatesAutoresizingMaskIntoConstraints = false
        heatIcon.image = UIImage(named: "sulijoy_live_heat")?.withRenderingMode(.alwaysOriginal)
        heatIcon.contentMode = .scaleAspectFit
        heatLabel.translatesAutoresizingMaskIntoConstraints = false
        heatLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        heatLabel.textColor = UIColor(red: 1, green: 0.45, blue: 0.2, alpha: 1)

        tagRow.translatesAutoresizingMaskIntoConstraints = false
        tagRow.axis = .horizontal
        tagRow.spacing = 6
        tagRow.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        bottomRow.translatesAutoresizingMaskIntoConstraints = false
        bottomRow.axis = .horizontal
        bottomRow.alignment = .center
        bottomRow.spacing = 8
        for tag in [tagPrimary, tagSecondary] {
            tag.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
            tag.textColor = UIColor(red: 0.95, green: 0.45, blue: 0.55, alpha: 1)
            tag.backgroundColor = UIColor(red: 1, green: 0.93, blue: 0.94, alpha: 1)
            tag.layer.cornerRadius = 10
            tag.clipsToBounds = true
            tagRow.addArrangedSubview(tag)
        }

        faceRow.translatesAutoresizingMaskIntoConstraints = false
        faceRow.axis = .horizontal
        faceRow.spacing = -8
        faceRow.setContentHuggingPriority(.required, for: .horizontal)

        extraChip.translatesAutoresizingMaskIntoConstraints = false
        extraChip.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        extraChip.textColor = .white
        extraChip.backgroundColor = UIColor.suliInk.withAlphaComponent(0.88)
        extraChip.layer.cornerRadius = 11
        extraChip.clipsToBounds = true
        extraChip.textAlignment = .center
        extraChip.setContentHuggingPriority(.required, for: .horizontal)

        contentView.addSubview(card)
        card.addSubview(portraitRing)
        card.addSubview(portraitView)
        card.addSubview(liveBadge)
        card.addSubview(titleLabel)
        card.addSubview(subtitleLabel)
        card.addSubview(heatChip)
        heatChip.addSubview(heatIcon)
        heatChip.addSubview(heatLabel)
        card.addSubview(bottomRow)
        bottomRow.addArrangedSubview(tagRow)
        bottomRow.addArrangedSubview(faceRow)
        bottomRow.addArrangedSubview(extraChip)

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            portraitRing.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            portraitRing.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            portraitRing.widthAnchor.constraint(equalToConstant: 64),
            portraitRing.heightAnchor.constraint(equalToConstant: 64),
            portraitView.centerXAnchor.constraint(equalTo: portraitRing.centerXAnchor),
            portraitView.centerYAnchor.constraint(equalTo: portraitRing.centerYAnchor),
            portraitView.widthAnchor.constraint(equalToConstant: 56),
            portraitView.heightAnchor.constraint(equalToConstant: 56),
            liveBadge.centerXAnchor.constraint(equalTo: portraitRing.centerXAnchor),
            liveBadge.bottomAnchor.constraint(equalTo: portraitRing.bottomAnchor, constant: 6),
            liveBadge.widthAnchor.constraint(equalToConstant: 52),
            liveBadge.heightAnchor.constraint(equalToConstant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: portraitRing.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: portraitRing.topAnchor, constant: 2),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: heatChip.leadingAnchor, constant: -8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            heatChip.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            heatChip.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            heatChip.heightAnchor.constraint(equalToConstant: 22),
            heatIcon.leadingAnchor.constraint(equalTo: heatChip.leadingAnchor, constant: 6),
            heatIcon.centerYAnchor.constraint(equalTo: heatChip.centerYAnchor),
            heatIcon.widthAnchor.constraint(equalToConstant: 10),
            heatIcon.heightAnchor.constraint(equalToConstant: 13),
            heatLabel.leadingAnchor.constraint(equalTo: heatIcon.trailingAnchor, constant: 3),
            heatLabel.trailingAnchor.constraint(equalTo: heatChip.trailingAnchor, constant: -8),
            heatLabel.centerYAnchor.constraint(equalTo: heatChip.centerYAnchor),
            bottomRow.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bottomRow.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            bottomRow.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            bottomRow.heightAnchor.constraint(equalToConstant: 22),
            tagRow.heightAnchor.constraint(equalToConstant: 20),
            faceRow.heightAnchor.constraint(equalToConstant: 22),
            extraChip.heightAnchor.constraint(equalToConstant: 22),
            extraChip.widthAnchor.constraint(greaterThanOrEqualToConstant: 34)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = portraitRing.bounds.height / 2
        portraitRing.layer.cornerRadius = radius
        portraitRingLayer.cornerRadius = radius
        portraitRingLayer.frame = portraitRing.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        faceRow.isHidden = false
        faceRow.arrangedSubviews.forEach {
            faceRow.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    func applyLiveCard(_ card: SuliJoyLagoonLiveCard) {
        portraitView.image = UIImage.suliJoyPortrait(named: card.portraitToken)
        titleLabel.text = card.title
        subtitleLabel.text = card.subtitle
        heatLabel.text = "\(max(card.heat, 0))"
        let tags = card.tagLabels
        tagPrimary.text = tags.first.map { "  \($0)  " } ?? ""
        tagPrimary.isHidden = tags.isEmpty
        tagSecondary.isHidden = tags.count < 2
        tagSecondary.text = tags.count > 1 ? "  \(tags[1])  " : ""
        extraChip.text = " +\(max(card.onlineCount, 0)) "
        let faces = card.viewerPortraitTokens.prefix(3)
        if faces.isEmpty {
            faceRow.isHidden = true
        } else {
            faceRow.isHidden = false
            for token in faces {
                let face = UIImageView(image: UIImage.suliJoyPortrait(named: token))
                face.translatesAutoresizingMaskIntoConstraints = false
                face.contentMode = .scaleAspectFill
                face.clipsToBounds = true
                face.layer.cornerRadius = 11
                face.layer.borderWidth = 1
                face.layer.borderColor = UIColor.white.cgColor
                faceRow.addArrangedSubview(face)
                face.widthAnchor.constraint(equalToConstant: 22).isActive = true
                face.heightAnchor.constraint(equalToConstant: 22).isActive = true
            }
        }
    }
}
