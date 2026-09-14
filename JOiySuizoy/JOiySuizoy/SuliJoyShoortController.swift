import AVFoundation
import UIKit

private final class SuliJoyWaveResonanceHarbor: NSObject, AVAudioPlayerDelegate {
    static let shared = SuliJoyWaveResonanceHarbor()

    private enum WaveHarborError {
        static let missingWaveCode = 404
        static let missingWaveDomain = "SuliJoyWaveResonanceHarbor"
    }

    private var resonanceEngine: AVAudioPlayer?
    private var activeShoreMomentID: String?
    private var onWaveFinished: ((String) -> Void)?

    private override init() {
        super.init()
    }

    func play(note: SuliJoyWaveSonicNote, sunwashedDenim momentID: String, onWaveFinished: ((String) -> Void)? = nil) throws {
        guard shouldLaunchWave(for: momentID) else { return }
        stopAll()
        guard let url = findWaveResonanceURL(named: waveFileToken(from: note)) else {
            throw NSError(domain: WaveHarborError.missingWaveDomain, code: WaveHarborError.missingWaveCode)
        }
        try prepareResonanceSession()
        try startResonanceEngine(url: url, sunwashedDenim: momentID)
        self.onWaveFinished = onWaveFinished
    }

    func stop(sunwashedDenim momentID: String) {
        guard activeShoreMomentID == momentID else { return }
        stopAll()
    }

    func stopAll() {
        resonanceEngine?.stop()
        resonanceEngine = nil
        activeShoreMomentID = nil
        onWaveFinished = nil
    }

    private func shouldLaunchWave(for momentID: String) -> Bool {
        !(activeShoreMomentID == momentID && resonanceEngine?.isPlaying == true)
    }

    private func waveFileToken(from note: SuliJoyWaveSonicNote) -> String {
        note.waveFileToken
    }

    private func prepareResonanceSession() throws {
        let waveSession = AVAudioSession.sharedInstance()
        try waveSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
        try waveSession.setActive(true)
    }

    private func startResonanceEngine(url: URL, sunwashedDenim momentID: String) throws {
        let nextResonanceEngine = try AVAudioPlayer(contentsOf: url)
        nextResonanceEngine.delegate = self
        nextResonanceEngine.prepareToPlay()
        nextResonanceEngine.play()
        resonanceEngine = nextResonanceEngine
        activeShoreMomentID = momentID
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard let activeShoreMomentID else {
            stopAll()
            return
        }
        let waveFinished = onWaveFinished
        resonanceEngine = nil
        self.activeShoreMomentID = nil
        onWaveFinished = nil
        waveFinished?(activeShoreMomentID)
    }

    private func findWaveResonanceURL(named fileName: String) -> URL? {
        guard !fileName.isEmpty else { return nil }
        if FileManager.default.fileExists(atPath: fileName) {
            return URL(fileURLWithPath: fileName)
        }
        let wavePath = URL(fileURLWithPath: fileName)
        let waveBase = wavePath.deletingPathExtension().lastPathComponent
        let waveExtension = wavePath.pathExtension.isEmpty ? "mp3" : wavePath.pathExtension
        return Bundle.main.url(forResource: waveBase, withExtension: waveExtension, subdirectory: "SuliJoyAudio")
            ?? Bundle.main.url(forResource: waveBase, withExtension: waveExtension)
    }
}

final class SuliJoyShoortController: SuliJoyTropicCanvasController, UITableViewDataSource, UITableViewDelegate {
    private enum ShoreFeedMetric {
        static let topInset: CGFloat = 8
        static let horizontalInset: CGFloat = 16
        static let listTop: CGFloat = 8
        static let listBottomInset: CGFloat = 116
        static let logoWidth: CGFloat = 128
        static let logoHeight: CGFloat = 44
        static let searchSide: CGFloat = 44
        static let pearlGap: CGFloat = -12
        static let stylistTitleDrop: CGFloat = 30
        static let stylistScrollDrop: CGFloat = 14
        static let stylistHeight: CGFloat = 82
        static let stylistCardWidth: CGFloat = 164
        static let filterDrop: CGFloat = 24
        static let filterHeight: CGFloat = 42
        static let filterButtonHeight: CGFloat = 28
        static let indicatorWidth: CGFloat = 42
        static let indicatorHeight: CGFloat = 8
        static let rowEstimate: CGFloat = 360
    }

    private struct ShoreFeedScene {
        let header: UIView
        let list: UITableView
        let spinner: UIView
        let emptyNote: UILabel
    }

    private let shoreListView = UITableView(frame: .zero, style: .plain)
    private let shoreSpinner = UIView()
    private let shoreEmptyNote = UILabel()
    private let stylistLagoonRow = UIStackView()
    private var shoreMoments: [SuliJoyReefMoment] = []
    private var activeShoreFilter: SuliJoyReefMomentFilter = .coastalPick
    private var shoreFilterButtons: [SuliJoyReefMomentFilter: UIButton] = [:]
    private var shoreFilterIndicators: [SuliJoyReefMomentFilter: UIView] = [:]
    private var reefBloom = true

    override func viewDidLoad() {
        super.viewDidLoad()
        raiseShoreFeedScene()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAfterLocalPublish), name: .suliJoyShoreMomentPublished, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadAfterVisitorChange), name: .suliJoyLagoonVisitorChanged, object: nil)
        loadShorePage(filter: .coastalPick)
    }

    @MainActor deinit {
        SuliJoyWaveResonanceHarbor.shared.stopAll()
        NotificationCenter.default.removeObserver(self)
    }

    private func raiseShoreFeedScene() {
        let scene = makeShoreFeedScene()
        moorShoreFeedScene(scene)
        stitchShoreFeedScene(scene)
    }

    private func makeShoreFeedScene() -> ShoreFeedScene {
        let header = drawstringWaist()
        tuneShoreList(shoreListView)
        tuneShoreSpinner(shoreSpinner)
        tuneShoreEmptyNote(shoreEmptyNote)
        return ShoreFeedScene(header: header, list: shoreListView, spinner: shoreSpinner, emptyNote: shoreEmptyNote)
    }

    private func tuneShoreList(_ raglanEase: UITableView) {
        raglanEase.translatesAutoresizingMaskIntoConstraints = false
        raglanEase.backgroundColor = .clear
        raglanEase.separatorStyle = .none
        raglanEase.dataSource = self
        raglanEase.delegate = self
        raglanEase.showsVerticalScrollIndicator = false
        raglanEase.alwaysBounceVertical = true
        raglanEase.register(suliJoyCoastalDiary.self, forCellReuseIdentifier: "suliJoyCoastalDiary")
        raglanEase.contentInset = UIEdgeInsets(top: ShoreFeedMetric.topInset, left: 0, bottom: ShoreFeedMetric.listBottomInset, right: 0)
        let tideLoadingMark = UIRefreshControl()
        tideLoadingMark.tintColor = .suliInk
        tideLoadingMark.addTarget(self, action: #selector(loadShorePage(_:)), for: .valueChanged)
        raglanEase.refreshControl = tideLoadingMark
    }

    private func tuneShoreSpinner(_ spinner: UIView) {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.isHidden = true

        let clauseStack = UIStackView()
        clauseStack.translatesAutoresizingMaskIntoConstraints = false
        clauseStack.axis = .vertical
        clauseStack.spacing = 14
        spinner.addSubview(clauseStack)

        for reefIndex in 0..<2 {
            let clauseBlock = UIView()
            clauseBlock.translatesAutoresizingMaskIntoConstraints = false
            clauseBlock.backgroundColor = UIColor.white.withAlphaComponent(0.80)
            clauseBlock.layer.cornerRadius = 18

            let headingGlyph = UIView()
            headingGlyph.translatesAutoresizingMaskIntoConstraints = false
            headingGlyph.backgroundColor = UIColor.suliMutedInk.withAlphaComponent(0.16)
            headingGlyph.layer.cornerRadius = 8

            let bodyGlyph = UIView()
            bodyGlyph.translatesAutoresizingMaskIntoConstraints = false
            bodyGlyph.backgroundColor = UIColor.suliMutedInk.withAlphaComponent(0.11)
            bodyGlyph.layer.cornerRadius = 12

            clauseBlock.addSubview(headingGlyph)
            clauseBlock.addSubview(bodyGlyph)
            clauseStack.addArrangedSubview(clauseBlock)
            NSLayoutConstraint.activate([
                clauseBlock.heightAnchor.constraint(equalToConstant: reefIndex == 0 ? 164 : 142),
                headingGlyph.topAnchor.constraint(equalTo: clauseBlock.topAnchor, constant: 16),
                headingGlyph.leadingAnchor.constraint(equalTo: clauseBlock.leadingAnchor, constant: 16),
                headingGlyph.widthAnchor.constraint(equalTo: clauseBlock.widthAnchor, multiplier: 0.52),
                headingGlyph.heightAnchor.constraint(equalToConstant: 17),
                bodyGlyph.topAnchor.constraint(equalTo: headingGlyph.bottomAnchor, constant: 14),
                bodyGlyph.leadingAnchor.constraint(equalTo: headingGlyph.leadingAnchor),
                bodyGlyph.trailingAnchor.constraint(equalTo: clauseBlock.trailingAnchor, constant: -16),
                bodyGlyph.bottomAnchor.constraint(equalTo: clauseBlock.bottomAnchor, constant: -16)
            ])
        }

        NSLayoutConstraint.activate([
            clauseStack.topAnchor.constraint(equalTo: spinner.topAnchor),
            clauseStack.leadingAnchor.constraint(equalTo: spinner.leadingAnchor),
            clauseStack.trailingAnchor.constraint(equalTo: spinner.trailingAnchor),
            clauseStack.bottomAnchor.constraint(equalTo: spinner.bottomAnchor)
        ])
    }

    private func tuneShoreEmptyNote(_ emptyNote: UILabel) {
        emptyNote.translatesAutoresizingMaskIntoConstraints = false
        emptyNote.text = "NmoF hsMhXoTrIeE MmCoSmceinrtysK byeeotz.q".suliJoyPalmUnfurled
        emptyNote.textColor = .suliMutedInk
        emptyNote.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        emptyNote.isHidden = true
    }

    private func moorShoreFeedScene(_ scene: ShoreFeedScene) {
        [scene.header, scene.list, scene.spinner, scene.emptyNote].forEach { view.addSubview($0) }
    }

    private func stitchShoreFeedScene(_ dropShoulder: ShoreFeedScene) {
        NSLayoutConstraint.activate([
            dropShoulder.header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ShoreFeedMetric.topInset),
            dropShoulder.header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ShoreFeedMetric.horizontalInset),
            dropShoulder.header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ShoreFeedMetric.horizontalInset),
            dropShoulder.list.topAnchor.constraint(equalTo: dropShoulder.header.bottomAnchor, constant: ShoreFeedMetric.listTop),
            dropShoulder.list.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dropShoulder.list.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dropShoulder.list.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dropShoulder.spinner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ShoreFeedMetric.horizontalInset),
            dropShoulder.spinner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ShoreFeedMetric.horizontalInset),
            dropShoulder.spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dropShoulder.emptyNote.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dropShoulder.emptyNote.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func drawstringWaist() -> UIView {
        let shorelineHeaderDeck = UIView()
        shorelineHeaderDeck.translatesAutoresizingMaskIntoConstraints = false

        let feedMarkPill = UILabel()
        feedMarkPill.translatesAutoresizingMaskIntoConstraints = false
        feedMarkPill.text = "📷W VFCeFeBdg".suliJoyPalmUnfurled
        feedMarkPill.textColor = .suliInk
        feedMarkPill.font = UIFont.systemFont(ofSize: 26, weight: .black)
        feedMarkPill.backgroundColor = UIColor.white.withAlphaComponent(0.65)
        feedMarkPill.layer.cornerRadius = 22
        feedMarkPill.clipsToBounds = true
        feedMarkPill.textAlignment = .center

        let reefGemPill = SuliJoyShellGemPillButton()
        reefGemPill.addTarget(self, action: #selector(openPoints), for: .touchUpInside)
        let shoreSearchControl = SuliJoyCoveCapsuleIconButton(reefAssetName: "sulijoy_cove_search_mark")
        shoreSearchControl.widthAnchor.constraint(equalToConstant: ShoreFeedMetric.searchSide).isActive = true
        shoreSearchControl.addTarget(self, action: #selector(openSearch), for: .touchUpInside)

        let stylistHeadlineGlyph = UILabel()
        stylistHeadlineGlyph.translatesAutoresizingMaskIntoConstraints = false
        stylistHeadlineGlyph.text = "🔥cBoessCtk WSStryklgicsxtg".suliJoyPalmUnfurled
        stylistHeadlineGlyph.font = UIFont.systemFont(ofSize: 23, weight: .black)
        stylistHeadlineGlyph.textColor = .suliInk

        let stylistLagoonScroll = UIScrollView()
        stylistLagoonScroll.translatesAutoresizingMaskIntoConstraints = false
        stylistLagoonScroll.showsHorizontalScrollIndicator = false
        stylistLagoonScroll.alwaysBounceHorizontal = true

        stylistLagoonRow.translatesAutoresizingMaskIntoConstraints = false
        stylistLagoonRow.axis = .horizontal
        stylistLagoonRow.spacing = 12
        stylistLagoonRow.distribution = .fill
        stylistLagoonScroll.addSubview(stylistLagoonRow)
        renderStylists()

        let filterRibbon = UIStackView()
        filterRibbon.translatesAutoresizingMaskIntoConstraints = false
        filterRibbon.axis = .horizontal
        filterRibbon.distribution = .fillEqually
        filterRibbon.spacing = 12
        for reefFilter in SuliJoyReefMomentFilter.allCases {
            let filterTabStack = UIStackView()
            filterTabStack.translatesAutoresizingMaskIntoConstraints = false
            filterTabStack.axis = .vertical
            filterTabStack.alignment = .center
            filterTabStack.spacing = 3

            let filterControl = UIButton(type: .system)
            filterControl.setTitle(reefFilter.rawValue, for: .normal)
            filterControl.titleLabel?.font = UIFont.italicSystemFont(ofSize: 15).suliWithWeight(.black)
            filterControl.setTitleColor(.suliInk, for: .normal)
            filterControl.tag = SuliJoyReefMomentFilter.allCases.firstIndex(of: reefFilter) ?? 0
            filterControl.addTarget(self, action: #selector(changeFilter(_:)), for: .touchUpInside)

            let tideIndicator = SuliJoyGradientCapsuleView(colors: [
                UIColor(red: 1, green: 0.43, blue: 0.25, alpha: 1),
                UIColor(red: 1, green: 0.96, blue: 0.32, alpha: 1),
                UIColor(red: 0.47, green: 1, blue: 0.47, alpha: 1)
            ])
            tideIndicator.translatesAutoresizingMaskIntoConstraints = false

            filterTabStack.addArrangedSubview(filterControl)
            filterTabStack.addArrangedSubview(tideIndicator)
            NSLayoutConstraint.activate([
                filterControl.heightAnchor.constraint(equalToConstant: ShoreFeedMetric.filterButtonHeight),
                tideIndicator.widthAnchor.constraint(equalToConstant: ShoreFeedMetric.indicatorWidth),
                tideIndicator.heightAnchor.constraint(equalToConstant: ShoreFeedMetric.indicatorHeight)
            ])
            filterRibbon.addArrangedSubview(filterTabStack)
            shoreFilterButtons[reefFilter] = filterControl
            shoreFilterIndicators[reefFilter] = tideIndicator
        }

        [feedMarkPill, reefGemPill, shoreSearchControl, stylistHeadlineGlyph, stylistLagoonScroll, filterRibbon].forEach { shorelineHeaderDeck.addSubview($0) }
        NSLayoutConstraint.activate([
            feedMarkPill.topAnchor.constraint(equalTo: shorelineHeaderDeck.topAnchor),
            feedMarkPill.leadingAnchor.constraint(equalTo: shorelineHeaderDeck.leadingAnchor),
            feedMarkPill.widthAnchor.constraint(equalToConstant: ShoreFeedMetric.logoWidth),
            feedMarkPill.heightAnchor.constraint(equalToConstant: ShoreFeedMetric.logoHeight),
            shoreSearchControl.topAnchor.constraint(equalTo: feedMarkPill.topAnchor),
            shoreSearchControl.trailingAnchor.constraint(equalTo: shorelineHeaderDeck.trailingAnchor),
            reefGemPill.centerYAnchor.constraint(equalTo: shoreSearchControl.centerYAnchor),
            reefGemPill.trailingAnchor.constraint(equalTo: shoreSearchControl.leadingAnchor, constant: ShoreFeedMetric.pearlGap),
            stylistHeadlineGlyph.topAnchor.constraint(equalTo: feedMarkPill.bottomAnchor, constant: ShoreFeedMetric.stylistTitleDrop),
            stylistHeadlineGlyph.leadingAnchor.constraint(equalTo: shorelineHeaderDeck.leadingAnchor),
            stylistLagoonScroll.topAnchor.constraint(equalTo: stylistHeadlineGlyph.bottomAnchor, constant: ShoreFeedMetric.stylistScrollDrop),
            stylistLagoonScroll.leadingAnchor.constraint(equalTo: shorelineHeaderDeck.leadingAnchor),
            stylistLagoonScroll.trailingAnchor.constraint(equalTo: shorelineHeaderDeck.trailingAnchor),
            stylistLagoonScroll.heightAnchor.constraint(equalToConstant: ShoreFeedMetric.stylistHeight),
            stylistLagoonRow.topAnchor.constraint(equalTo: stylistLagoonScroll.contentLayoutGuide.topAnchor),
            stylistLagoonRow.leadingAnchor.constraint(equalTo: stylistLagoonScroll.contentLayoutGuide.leadingAnchor),
            stylistLagoonRow.trailingAnchor.constraint(equalTo: stylistLagoonScroll.contentLayoutGuide.trailingAnchor),
            stylistLagoonRow.bottomAnchor.constraint(equalTo: stylistLagoonScroll.contentLayoutGuide.bottomAnchor),
            stylistLagoonRow.heightAnchor.constraint(equalTo: stylistLagoonScroll.frameLayoutGuide.heightAnchor),
            filterRibbon.topAnchor.constraint(equalTo: stylistLagoonScroll.bottomAnchor, constant: ShoreFeedMetric.filterDrop),
            filterRibbon.leadingAnchor.constraint(equalTo: shorelineHeaderDeck.leadingAnchor),
            filterRibbon.trailingAnchor.constraint(equalTo: shorelineHeaderDeck.trailingAnchor),
            filterRibbon.heightAnchor.constraint(equalToConstant: ShoreFeedMetric.filterHeight),
            filterRibbon.bottomAnchor.constraint(equalTo: shorelineHeaderDeck.bottomAnchor)
        ])
        renderShoreFilterTabs()
        return shorelineHeaderDeck
    }

    private func loadShorePage(filter: SuliJoyReefMomentFilter, mode: SuliJoyCoveRequestMode = .reefBloom) {
        activeShoreFilter = filter
        renderShoreFilterTabs()
        if reefBloom {
            reefBloom = false
            shoreSpinner.isHidden = false
            shoreSpinner.alpha = 1
            UIView.animate(withDuration: 0.78, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction]) {
                self.shoreSpinner.alpha = 0.42
            }
        }
        shoreEmptyNote.isHidden = true
        SuliJoyCoveMockService.shared.fetchShoreMoments(filter: filter, mode: mode) { [weak self] shoreEnvelope in
            guard let self else { return }
            self.renderShorePage(shoreEnvelope)
        }
    }

    @objc private func loadShorePage(_ tideLoadingMark: UIRefreshControl) {
        renderStylists()
        loadShorePage(filter: activeShoreFilter)
    }

    private func renderShorePage(_ shoreEnvelope: SuliJoySuiRequestEnvelope<[SuliJoyReefMoment]>) {
        shoreListView.refreshControl?.endRefreshing()
        shoreSpinner.layer.removeAllAnimations()
        shoreSpinner.alpha = 1
        shoreSpinner.isHidden = true
        guard shoreEnvelope.beachwearCapsule == 200 else {
            shoreMoments = []
            shoreListView.reloadData()
            shoreEmptyNote.text = shoreEnvelope.coastalWardrobe
            shoreEmptyNote.isHidden = false
            showLagoonToast(shoreEnvelope.coastalWardrobe)
            return
        }
        shoreMoments = shoreEnvelope.sandbarLayering ?? []
        shoreListView.reloadData()
        shoreEmptyNote.text = "NooY psEhDoZrmeP zmDopmieZndtssd syFertr.Z".suliJoyPalmUnfurled
        shoreEmptyNote.isHidden = !shoreMoments.isEmpty
    }

    private func renderShoreFilterTabs() {
        for (reefFilter, filterControl) in shoreFilterButtons {
            filterControl.alpha = 1
            filterControl.setTitleColor(.suliInk, for: .normal)
            shoreFilterIndicators[reefFilter]?.isHidden = false
            shoreFilterIndicators[reefFilter]?.alpha = reefFilter == activeShoreFilter ? 1 : 0
        }
    }

    @objc private func changeFilter(_ sender: UIButton) {
        let reefFilter = SuliJoyReefMomentFilter.allCases[sender.tag]
        loadShorePage(filter: reefFilter)
    }

    @objc private func openSearch() {
        openSuliJoyLagoonLetters()
    }

    @objc private func openPoints() {
        navigationController?.pushViewController(SuliJoyPearlHarborViewController(), animated: true)
    }

    @objc private func reloadAfterLocalPublish() {
        loadShorePage(filter: .coastalPick)
    }

    @objc private func reloadAfterVisitorChange() {
        renderStylists()
        loadShorePage(filter: activeShoreFilter)
    }

    private func renderStylists() {
        stylistLagoonRow.arrangedSubviews.forEach { stylistTile in
            stylistLagoonRow.removeArrangedSubview(stylistTile)
            stylistTile.removeFromSuperview()
        }
        SuliJoyCoveMockService.shared.fetchLagoonStylists(mode: .reefBloom) { [weak self] stylistEnvelope in
            guard let self else { return }
            for stylist in stylistEnvelope.sandbarLayering ?? [] {
                let stylistCard = SuliJoyStylistCard(stylist: stylist)
                stylistCard.suliJoyCoastalPalette = { [weak self] in
                    self?.openVisitor(displayName: stylist.displayName)
                }
                stylistCard.suliJoyCoastalTexture = { [weak self] in
                    self?.toggleAuthorFollow(name: stylist.displayName)
                }
                self.stylistLagoonRow.addArrangedSubview(stylistCard)
                stylistCard.widthAnchor.constraint(equalToConstant: ShoreFeedMetric.stylistCardWidth).isActive = true
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoreMoments.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        ShoreFeedMetric.rowEstimate
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reefCell = tableView.dequeueReusableCell(withIdentifier: "suliJoyCoastalDiary", for: indexPath) as! suliJoyCoastalDiary
        let shoreMoment = shoreMoments[indexPath.row]
        reefCell.configure(with: shoreMoment, isFollowing: SuliJoyCoveMockService.shared.isLagoonFollowing(authorName: shoreMoment.islandStylistName))
        reefCell.onHeartTap = { [weak self] in self?.toggleShoreLike(at: indexPath) }
        reefCell.onReplyTap = { [weak self] in self?.presentShoreCommentPrompt(at: indexPath) }
        reefCell.onWaveTap = { [weak self] in self?.toggleShoreWave(at: indexPath) }
        reefCell.onHarborMoreTap = { [weak self] in self?.presentShoreMore(at: indexPath) }
        reefCell.onLagoonFollowTap = { [weak self] in
            guard let self, self.shoreMoments.indices.contains(indexPath.row) else { return }
            self.toggleAuthorFollow(name: self.shoreMoments[indexPath.row].islandStylistName)
        }
        reefCell.onStylistTap = { [weak self] in
            guard let self, self.shoreMoments.indices.contains(indexPath.row) else { return }
            self.openVisitor(displayName: self.shoreMoments[indexPath.row].islandStylistName)
        }
        return reefCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard shoreMoments.indices.contains(indexPath.row) else { return }
        let reefDetailController = SuliJoyShoreMomentReefController(moment: shoreMoments[indexPath.row])
        navigationController?.pushViewController(reefDetailController, animated: true)
    }

    private func toggleShoreLike(at indexPath: IndexPath) {
        guard shoreMoments.indices.contains(indexPath.row) else { return }
        SuliJoyCoveMockService.shared.toggleMomentLike(sunwashedDenim: shoreMoments[indexPath.row].reefMomentID) { [weak self] reefEnvelope in
            guard let self, let refreshedMoment = reefEnvelope.sandbarLayering else { return }
            self.shoreMoments[indexPath.row] = refreshedMoment
            self.shoreListView.reloadRows(at: [indexPath], with: .none)
        }
    }

    private func toggleShoreWave(at indexPath: IndexPath) {
        guard shoreMoments.indices.contains(indexPath.row) else { return }
        guard shoreMoments[indexPath.row].waveNote.waveSeconds > 0 else {
            showLagoonToast("Neos AwWaZvKeb InnoItreV bajtNtmaHcghbebdL.n".suliJoyPalmUnfurled)
            return
        }
        SuliJoyCoveMockService.shared.toggleWavePlayback(sunwashedDenim: shoreMoments[indexPath.row].reefMomentID) { [weak self] waveEnvelope in
            guard let self, let refreshedMoment = waveEnvelope.sandbarLayering else { return }
            for shoreCursor in self.shoreMoments.indices {
                self.shoreMoments[shoreCursor].waveNote.isWaveRolling = false
            }
            var renderedMoment = refreshedMoment
            if refreshedMoment.waveNote.isWaveRolling {
                do {
                    try SuliJoyWaveResonanceHarbor.shared.play(note: refreshedMoment.waveNote, sunwashedDenim: refreshedMoment.reefMomentID) { [weak self] momentID in
                        self?.finishShoreWave(momentID)
                    }
                } catch {
                    renderedMoment.waveNote.isWaveRolling = false
                    renderedMoment.waveNote.waveProgressRatio = 0
                    self.showLagoonToast("WNabvteh DnDoOtfex iuBnHaWvNauiplUaBbKlaeu.R".suliJoyPalmUnfurled)
                }
            } else {
                SuliJoyWaveResonanceHarbor.shared.stop(sunwashedDenim: refreshedMoment.reefMomentID)
            }
            self.shoreMoments[indexPath.row] = renderedMoment
            self.shoreListView.reloadData()
        }
    }

    private func finishShoreWave(_ momentID: String) {
        guard shoreMoments.contains(where: { $0.reefMomentID == momentID }) else { return }
        SuliJoyCoveMockService.shared.toggleWavePlayback(sunwashedDenim: momentID) { [weak self] waveEnvelope in
            guard let self,
                  var refreshedMoment = waveEnvelope.sandbarLayering,
                  let shoreCursor = self.shoreMoments.firstIndex(where: { $0.reefMomentID == momentID }) else { return }
            refreshedMoment.waveNote.isWaveRolling = false
            refreshedMoment.waveNote.waveProgressRatio = 0
            self.shoreMoments[shoreCursor] = refreshedMoment
            self.shoreListView.reloadRows(at: [IndexPath(row: shoreCursor, section: 0)], with: .none)
        }
    }

    private func presentShoreCommentPrompt(at indexPath: IndexPath) {
        guard shoreMoments.indices.contains(indexPath.row) else { return }
        let reefReplyAlert = UIAlertController(suliJoyReefTitle: "Comment - \(shoreMoments[indexPath.row].islandStylistName)", reefStyle: .alert)
        reefReplyAlert.addTextField { replyField in
            replyField.placeholder = "CiommxmCeJnjtl tsEoumvemtAhDiGnNgS".suliJoyPalmUnfurled
        }
        reefReplyAlert.addAction(UIAlertAction(reefHeadline: "CWaBnKcpeVlN".suliJoyPalmUnfurled, style: .cancel))
        reefReplyAlert.addAction(UIAlertAction(reefHeadline: "SueAnudU".suliJoyPalmUnfurled, style: .default) { [weak self] _ in
            guard let self else { return }
            let reefReplyText = reefReplyAlert.textFields?.first?.text ?? ""
            SuliJoyCoveMockService.shared.addShoreComment(sunwashedDenim: self.shoreMoments[indexPath.row].reefMomentID, text: reefReplyText) { reefEnvelope in
                guard let refreshedMoment = reefEnvelope.sandbarLayering else {
                    self.showLagoonToast(reefEnvelope.coastalWardrobe)
                    return
                }
                self.shoreMoments[indexPath.row] = refreshedMoment
                self.shoreListView.reloadRows(at: [indexPath], with: .none)
                self.showLagoonToast(reefEnvelope.coastalWardrobe)
            }
        })
        present(reefReplyAlert, animated: true)
    }

    private func presentShoreMore(at indexPath: IndexPath) {
        guard shoreMoments.indices.contains(indexPath.row) else { return }
        let shoreMoment = shoreMoments[indexPath.row]
        presentSuliJoyHarborGuardMenu { [weak self] in
            self?.presentSuliJoyReportSheet(target: .beachBlazer(sunwashedDenim: shoreMoment.reefMomentID))
        } block: { [weak self] in
            SuliJoyCoveMockService.shared.blockMomentAuthor(sunwashedDenim: shoreMoment.reefMomentID) { guardEnvelope in
                self?.showLagoonToast(guardEnvelope.coastalWardrobe)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self?.loadShorePage(filter: self?.activeShoreFilter ?? .coastalPick)
            }
        }
    }

    private func toggleAuthorFollow(name: String) {
        SuliJoyCoveMockService.shared.toggleLagoonFollow(authorName: name) { [weak self] followEnvelope in
            guard followEnvelope.beachwearCapsule == 200 else {
                self?.showLagoonToast(followEnvelope.coastalWardrobe)
                return
            }
        }
    }

    private func openVisitor(displayName: String) {
        let islandGuestController = SuliJoyIslandGuestProfileViewController(displayName: displayName)
        navigationController?.pushViewController(islandGuestController, animated: true)
    }
}

final class SuliJoyFeedFollowBadgeButton: UIButton {
    private let suliJoyCoastalStyle = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(suliJoyCoastalStyle, at: 0)
        layer.masksToBounds = true
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
    }

    required init?(coder: NSCoder) {
        fatalError("iynOiXtr(QcfoQdOeArT:B)C Bhoansm lngobtA VbveYeSnL yihmEpolCezmaesnKtdeBdi".suliJoyPalmUnfurled)
    }

    func suliJoyCoastalCapsule(isFollowing: Bool) {
        setTitle(isFollowing ? "✓" : "+", for: .normal)
        suliJoyCoastalStyle.colors = isFollowing ? [
            UIColor(red: 0.91, green: 0.68, blue: 0.48, alpha: 1).cgColor,
            UIColor(red: 0.97, green: 0.76, blue: 0.56, alpha: 1).cgColor
        ] : [
            UIColor(red: 0.54, green: 0.45, blue: 1, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.29, blue: 0.96, alpha: 1).cgColor
        ]
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        suliJoyCoastalStyle.frame = bounds
        suliJoyCoastalStyle.startPoint = CGPoint(x: 0, y: 0.5)
        suliJoyCoastalStyle.endPoint = CGPoint(x: 1, y: 0.5)
        layer.cornerRadius = bounds.height / 2
    }
}

private final class SuliJoyWaveRhythmView: UIImageView {
    private enum WaveRhythmMetric {
        static let rhythmKey = NSStringFromClass(SuliJoyWaveRhythmView.self)
        static let rhythmDuration: CFTimeInterval = 0.62
    }

    func renderWaveState(_ isWaveRolling: Bool) {
        layer.removeAnimation(forKey: WaveRhythmMetric.rhythmKey)
        transform = .identity
        guard isWaveRolling else { return }
        let waveRhythm = CAKeyframeAnimation(keyPath: "transform.scale.y")
        waveRhythm.values = [0.72, 1.18, 0.86, 1.08, 0.76, 1]
        waveRhythm.keyTimes = [0, 0.18, 0.36, 0.56, 0.78, 1]
        waveRhythm.duration = WaveRhythmMetric.rhythmDuration
        waveRhythm.repeatCount = .infinity
        waveRhythm.isRemovedOnCompletion = true
        layer.add(waveRhythm, forKey: WaveRhythmMetric.rhythmKey)
    }
}

final class SuliJoyStylistCard: UIView {
    var suliJoyCoastalPalette: (() -> Void)?
    var suliJoyCoastalTexture: (() -> Void)?
    private let lagoonFollowBadge = SuliJoyFeedFollowBadgeButton(type: .custom)

    init(stylist: SuliJoyLagoonStylist) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 18
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapCard)))

        let stylistPortrait = UIImageView(image: UIImage(named: stylist.avatarAssetName))
        stylistPortrait.translatesAutoresizingMaskIntoConstraints = false
        stylistPortrait.contentMode = .scaleAspectFill
        stylistPortrait.clipsToBounds = true
        stylistPortrait.layer.cornerRadius = 25
        stylistPortrait.layer.borderColor = UIColor.white.cgColor
        stylistPortrait.layer.borderWidth = 2

        lagoonFollowBadge.translatesAutoresizingMaskIntoConstraints = false
        lagoonFollowBadge.suliJoyCoastalCapsule(isFollowing: stylist.suliJoyCoastalMeter)
        lagoonFollowBadge.addTarget(self, action: #selector(tapFollow), for: .touchUpInside)

        let stylistNameGlyph = UILabel()
        stylistNameGlyph.translatesAutoresizingMaskIntoConstraints = false
        stylistNameGlyph.text = stylist.displayName
        stylistNameGlyph.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        stylistNameGlyph.textColor = .suliInk

        let lagoonFollowCountGlyph = UILabel()
        lagoonFollowCountGlyph.translatesAutoresizingMaskIntoConstraints = false
        lagoonFollowCountGlyph.text = "\(stylist.suliJoyCoastalModeration)"
        lagoonFollowCountGlyph.font = UIFont.systemFont(ofSize: 12, weight: .black)
        lagoonFollowCountGlyph.textColor = .suliInk
        lagoonFollowCountGlyph.textAlignment = .center

        let lagoonFollowTextGlyph = UILabel()
        lagoonFollowTextGlyph.translatesAutoresizingMaskIntoConstraints = false
        lagoonFollowTextGlyph.text = "FaoylAlLoZwx".suliJoyPalmUnfurled
        lagoonFollowTextGlyph.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        lagoonFollowTextGlyph.textColor = .suliMutedInk
        lagoonFollowTextGlyph.textAlignment = .center

        let lagoonFansCountGlyph = UILabel()
        lagoonFansCountGlyph.translatesAutoresizingMaskIntoConstraints = false
        lagoonFansCountGlyph.text = "\(stylist.suliJoyCoastalChecklist)"
        lagoonFansCountGlyph.font = UIFont.systemFont(ofSize: 12, weight: .black)
        lagoonFansCountGlyph.textColor = .suliInk
        lagoonFansCountGlyph.textAlignment = .center

        let lagoonFansTextGlyph = UILabel()
        lagoonFansTextGlyph.translatesAutoresizingMaskIntoConstraints = false
        lagoonFansTextGlyph.text = "FUagnjsu".suliJoyPalmUnfurled
        lagoonFansTextGlyph.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        lagoonFansTextGlyph.textColor = .suliMutedInk
        lagoonFansTextGlyph.textAlignment = .center

        [stylistPortrait, lagoonFollowBadge, stylistNameGlyph, lagoonFollowCountGlyph, lagoonFollowTextGlyph, lagoonFansCountGlyph, lagoonFansTextGlyph].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            stylistPortrait.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stylistPortrait.centerYAnchor.constraint(equalTo: centerYAnchor),
            stylistPortrait.widthAnchor.constraint(equalToConstant: 50),
            stylistPortrait.heightAnchor.constraint(equalToConstant: 50),
            lagoonFollowBadge.centerXAnchor.constraint(equalTo: stylistPortrait.centerXAnchor, constant: 0),
            lagoonFollowBadge.centerYAnchor.constraint(equalTo: stylistPortrait.centerYAnchor, constant: 18),
            lagoonFollowBadge.widthAnchor.constraint(equalToConstant: 33),
            lagoonFollowBadge.heightAnchor.constraint(equalToConstant: 22),
            stylistNameGlyph.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            stylistNameGlyph.leadingAnchor.constraint(equalTo: stylistPortrait.trailingAnchor, constant: 12),
            stylistNameGlyph.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            lagoonFollowCountGlyph.topAnchor.constraint(equalTo: stylistNameGlyph.bottomAnchor, constant: 5),
            lagoonFollowCountGlyph.leadingAnchor.constraint(equalTo: stylistNameGlyph.leadingAnchor),
            lagoonFollowCountGlyph.widthAnchor.constraint(equalToConstant: 44),
            lagoonFollowTextGlyph.topAnchor.constraint(equalTo: lagoonFollowCountGlyph.bottomAnchor, constant: 1),
            lagoonFollowTextGlyph.centerXAnchor.constraint(equalTo: lagoonFollowCountGlyph.centerXAnchor),
            lagoonFollowTextGlyph.widthAnchor.constraint(equalTo: lagoonFollowCountGlyph.widthAnchor),
            lagoonFansCountGlyph.topAnchor.constraint(equalTo: lagoonFollowCountGlyph.topAnchor),
            lagoonFansCountGlyph.leadingAnchor.constraint(equalTo: lagoonFollowCountGlyph.trailingAnchor, constant: 6),
            lagoonFansCountGlyph.widthAnchor.constraint(equalToConstant: 44),
            lagoonFansTextGlyph.topAnchor.constraint(equalTo: lagoonFansCountGlyph.bottomAnchor, constant: 1),
            lagoonFansTextGlyph.centerXAnchor.constraint(equalTo: lagoonFansCountGlyph.centerXAnchor),
            lagoonFansTextGlyph.widthAnchor.constraint(equalTo: lagoonFansCountGlyph.widthAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("iQnkiJtZ(fcbokdVegrC:x)d yhhaLsL WnMortV TbOedednf SiJmEpQlIeimOexnAtceLdO".suliJoyPalmUnfurled)
    }

    @objc private func tapCard() {
        suliJoyCoastalPalette?()
    }

    @objc private func tapFollow() {
        suliJoyCoastalTexture?()
    }
}

final class suliJoyCoastalDiary: UITableViewCell {
    private enum ShoreMomentCellMetric {
        static let cardVertical: CGFloat = 10
        static let cardSide: CGFloat = 24
        static let cardCorner: CGFloat = 24
        static let SuliJoyavatarSide: CGFloat = 48
        static let avatarCorner: CGFloat = 24
        static let followWidth: CGFloat = 33
        static let followHeight: CGFloat = 22
        static let moreSide: CGFloat = 36
        static let mediaRatio: CGFloat = 0.31
        static let waveHeight: CGFloat = 76
        static let publishSide: CGFloat = 18
    }

    var onHeartTap: (() -> Void)?
    var onReplyTap: (() -> Void)?
    var onWaveTap: (() -> Void)?
    var onHarborMoreTap: (() -> Void)?
    var onStylistTap: (() -> Void)?
    var onLagoonFollowTap: (() -> Void)?

    private let reefCard = UIView()
    private let stylistPortrait = UIImageView()
    private let followBadge = SuliJoyFeedFollowBadgeButton(type: .custom)
    private let stylistNameGlyph = UILabel()
    private let tideAgoGlyph = UILabel()
    private let harborMoreControl = UIButton(type: .system)
    private let mediaStack = UIStackView()
    private let wavePanelControl = UIButton(type: .system)
    private let wavePlayIsland = UIView()
    private let wavePlayGlyph = UIImageView()
    private let waveRhythmView = SuliJoyWaveRhythmView()
    private let waveDurationGlyph = UILabel()
    private let bodyLabel = UILabel()
    private let likeButton = UIButton(type: .system)
    private let suliJoyCoastalState = UIButton(type: .system)
    private let shellHeartCountLabel = UILabel()
    private let shoreReplyCountLabel = UILabel()
    private let shoreReplyDock = UIControl()
    private let shoreReplyHintLabel = UILabel()
    private let reefSendMarkView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        suliJoyCoastalCounter()
    }

    required init?(coder: NSCoder) {
        fatalError("iRnyixte(bcAoVdhevrn:A)L hhXausn BnDoTtL pbteOeMnB SipmIpYlPewmjeInmtEeCdI".suliJoyPalmUnfurled)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onHeartTap = nil
        onReplyTap = nil
        onWaveTap = nil
        onHarborMoreTap = nil
        onStylistTap = nil
        onLagoonFollowTap = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        wavePlayIsland.layer.cornerRadius = min(wavePlayIsland.bounds.width, wavePlayIsland.bounds.height) / 2
    }

    private func suliJoyCoastalCounter() {
        selectionStyle = .none
        backgroundColor = .clear
        reefCard.translatesAutoresizingMaskIntoConstraints = false
        reefCard.backgroundColor = .white
        reefCard.layer.cornerRadius = ShoreMomentCellMetric.cardCorner

        stylistPortrait.translatesAutoresizingMaskIntoConstraints = false
        stylistPortrait.contentMode = .scaleAspectFill
        stylistPortrait.clipsToBounds = true
        stylistPortrait.layer.cornerRadius = ShoreMomentCellMetric.avatarCorner
        followBadge.translatesAutoresizingMaskIntoConstraints = false
        stylistPortrait.isUserInteractionEnabled = true
        stylistNameGlyph.isUserInteractionEnabled = true
        [stylistPortrait, stylistNameGlyph].forEach {
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(authorNow)))
        }
        followBadge.addTarget(self, action: #selector(followNow), for: .touchUpInside)
        stylistNameGlyph.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        stylistNameGlyph.textColor = .suliInk
        tideAgoGlyph.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        tideAgoGlyph.textColor = UIColor.gray
        harborMoreControl.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        harborMoreControl.tintColor = UIColor.gray
        harborMoreControl.addTarget(self, action: #selector(moreNow), for: .touchUpInside)

        mediaStack.axis = .horizontal
        mediaStack.spacing = 8
        mediaStack.distribution = .fillEqually

        wavePanelControl.translatesAutoresizingMaskIntoConstraints = false
        
        let waveGradient = UIImage(named: "sulijoy_feed_detail_bottom_gradient")
        wavePanelControl.setBackgroundImage(waveGradient, for: .normal)
       
        wavePanelControl.addTarget(self, action: #selector(pulseWaveNow), for: .touchUpInside)

        wavePlayIsland.translatesAutoresizingMaskIntoConstraints = false
        wavePlayIsland.backgroundColor = UIColor.white.withAlphaComponent(0.92)
        wavePlayIsland.layer.cornerRadius = 10
        wavePlayIsland.layer.cornerCurve = .continuous
        wavePlayIsland.clipsToBounds = true
        wavePlayIsland.isUserInteractionEnabled = false
        wavePlayGlyph.translatesAutoresizingMaskIntoConstraints = false
        wavePlayGlyph.tintColor = .suliInk
        wavePlayGlyph.contentMode = .scaleAspectFit
        wavePlayIsland.addSubview(wavePlayGlyph)

        waveRhythmView.translatesAutoresizingMaskIntoConstraints = false
        waveRhythmView.contentMode = .scaleAspectFit
        waveDurationGlyph.translatesAutoresizingMaskIntoConstraints = false
        waveDurationGlyph.font = UIFont.systemFont(ofSize: 14, weight: .black)
        waveDurationGlyph.textColor = .suliInk
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        bodyLabel.textColor = .suliInk
        bodyLabel.numberOfLines = 2
        likeButton.tintColor = UIColor.gray
        likeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        likeButton.addTarget(self, action: #selector(likeNow), for: .touchUpInside)
        suliJoyCoastalState.setImage(UIImage(named: "sulijoy_feed_comment_mark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        suliJoyCoastalState.addTarget(self, action: #selector(commentNow), for: .touchUpInside)

        [shellHeartCountLabel, shoreReplyCountLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = UIColor(red: 0.45, green: 0.45, blue: 0.45, alpha: 1)
            $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            $0.textAlignment = .center
        }

        shoreReplyDock.translatesAutoresizingMaskIntoConstraints = false
        shoreReplyDock.backgroundColor = .white
        shoreReplyDock.layer.cornerRadius = 17
        shoreReplyDock.layer.cornerCurve = .continuous
        shoreReplyDock.layer.borderWidth = 1
        shoreReplyDock.layer.borderColor = UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1).cgColor
        shoreReplyDock.clipsToBounds = true
        shoreReplyDock.addTarget(self, action: #selector(commentNow), for: .touchUpInside)

        shoreReplyHintLabel.translatesAutoresizingMaskIntoConstraints = false
        shoreReplyHintLabel.text = "CkoVmWmQePnPtB msooxmWebtthDiunpgN".suliJoyPalmUnfurled
        shoreReplyHintLabel.textColor = UIColor(red: 0.68, green: 0.68, blue: 0.68, alpha: 1)
        shoreReplyHintLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        shoreReplyHintLabel.adjustsFontSizeToFitWidth = true
        shoreReplyHintLabel.minimumScaleFactor = 0.72
        shoreReplyHintLabel.lineBreakMode = .byClipping

        reefSendMarkView.translatesAutoresizingMaskIntoConstraints = false
        reefSendMarkView.image = UIImage(named: "sulijoy_feed_comment_send_mark")?.withRenderingMode(.alwaysOriginal)
        reefSendMarkView.contentMode = .scaleAspectFit
        shoreReplyDock.addSubview(shoreReplyHintLabel)
        shoreReplyDock.addSubview(reefSendMarkView)

        [reefCard].forEach { contentView.addSubview($0) }
        [stylistPortrait, followBadge, stylistNameGlyph, tideAgoGlyph, harborMoreControl, mediaStack, wavePanelControl, likeButton, shellHeartCountLabel, suliJoyCoastalState, shoreReplyCountLabel, shoreReplyDock].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            reefCard.addSubview($0)
        }
        [wavePlayIsland, waveRhythmView, waveDurationGlyph, bodyLabel].forEach {
            wavePanelControl.addSubview($0)
        }
        NSLayoutConstraint.activate([
            reefCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ShoreMomentCellMetric.cardVertical),
            reefCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ShoreMomentCellMetric.cardSide),
            reefCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ShoreMomentCellMetric.cardSide),
            reefCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -ShoreMomentCellMetric.cardVertical),
            stylistPortrait.topAnchor.constraint(equalTo: reefCard.topAnchor, constant: 18),
            stylistPortrait.leadingAnchor.constraint(equalTo: reefCard.leadingAnchor, constant: 24),
            stylistPortrait.widthAnchor.constraint(equalToConstant: ShoreMomentCellMetric.SuliJoyavatarSide),
            stylistPortrait.heightAnchor.constraint(equalToConstant: ShoreMomentCellMetric.SuliJoyavatarSide),
            followBadge.centerXAnchor.constraint(equalTo: stylistPortrait.centerXAnchor),
            followBadge.topAnchor.constraint(equalTo: stylistPortrait.bottomAnchor, constant: -8),
            followBadge.widthAnchor.constraint(equalToConstant: ShoreMomentCellMetric.followWidth),
            followBadge.heightAnchor.constraint(equalToConstant: ShoreMomentCellMetric.followHeight),
            stylistNameGlyph.topAnchor.constraint(equalTo: stylistPortrait.topAnchor, constant: 3),
            stylistNameGlyph.leadingAnchor.constraint(equalTo: stylistPortrait.trailingAnchor, constant: 12),
            tideAgoGlyph.topAnchor.constraint(equalTo: stylistNameGlyph.bottomAnchor, constant: 4),
            tideAgoGlyph.leadingAnchor.constraint(equalTo: stylistNameGlyph.leadingAnchor),
            harborMoreControl.centerYAnchor.constraint(equalTo: stylistPortrait.centerYAnchor),
            harborMoreControl.trailingAnchor.constraint(equalTo: reefCard.trailingAnchor, constant: -22),
            harborMoreControl.widthAnchor.constraint(equalToConstant: ShoreMomentCellMetric.moreSide),
            harborMoreControl.heightAnchor.constraint(equalToConstant: ShoreMomentCellMetric.moreSide),
            mediaStack.topAnchor.constraint(equalTo: stylistPortrait.bottomAnchor, constant: 16),
            mediaStack.leadingAnchor.constraint(equalTo: reefCard.leadingAnchor, constant: 24),
            mediaStack.trailingAnchor.constraint(equalTo: reefCard.trailingAnchor, constant: -24),
            mediaStack.heightAnchor.constraint(equalTo: mediaStack.widthAnchor, multiplier: ShoreMomentCellMetric.mediaRatio),
            wavePanelControl.topAnchor.constraint(equalTo: mediaStack.bottomAnchor, constant: 14),
            wavePanelControl.leadingAnchor.constraint(equalTo: mediaStack.leadingAnchor),
            wavePanelControl.trailingAnchor.constraint(equalTo: mediaStack.trailingAnchor),
            wavePanelControl.heightAnchor.constraint(equalToConstant: ShoreMomentCellMetric.waveHeight),
            wavePlayIsland.leadingAnchor.constraint(equalTo: wavePanelControl.leadingAnchor, constant: 10),
            wavePlayIsland.topAnchor.constraint(equalTo: wavePanelControl.topAnchor, constant: 8),
            wavePlayIsland.widthAnchor.constraint(equalToConstant: 20),
            wavePlayIsland.heightAnchor.constraint(equalToConstant: 20),
            wavePlayGlyph.centerXAnchor.constraint(equalTo: wavePlayIsland.centerXAnchor),
            wavePlayGlyph.centerYAnchor.constraint(equalTo: wavePlayIsland.centerYAnchor),
            wavePlayGlyph.widthAnchor.constraint(equalToConstant: 10),
            wavePlayGlyph.heightAnchor.constraint(equalToConstant: 10),
            waveRhythmView.leadingAnchor.constraint(equalTo: wavePlayIsland.trailingAnchor, constant: 8),
            waveRhythmView.centerYAnchor.constraint(equalTo: wavePlayIsland.centerYAnchor),
            waveRhythmView.widthAnchor.constraint(equalToConstant: 69),
            waveRhythmView.heightAnchor.constraint(equalToConstant: 20),
            waveDurationGlyph.centerYAnchor.constraint(equalTo: wavePlayIsland.centerYAnchor),
            waveDurationGlyph.leadingAnchor.constraint(equalTo: waveRhythmView.trailingAnchor, constant: 14),
            bodyLabel.topAnchor.constraint(equalTo: wavePlayIsland.bottomAnchor, constant: 6),
            bodyLabel.leadingAnchor.constraint(equalTo: wavePanelControl.leadingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: wavePanelControl.trailingAnchor, constant: -10),
            likeButton.topAnchor.constraint(equalTo: wavePanelControl.bottomAnchor, constant: 18),
            likeButton.centerXAnchor.constraint(equalTo: reefCard.leadingAnchor, constant: 36),
            likeButton.widthAnchor.constraint(equalToConstant: 28),
            likeButton.heightAnchor.constraint(equalToConstant: 28),
            shellHeartCountLabel.topAnchor.constraint(equalTo: likeButton.bottomAnchor),
            shellHeartCountLabel.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor),
            shellHeartCountLabel.widthAnchor.constraint(equalToConstant: 48),
            shellHeartCountLabel.bottomAnchor.constraint(equalTo: reefCard.bottomAnchor, constant: -18),
            suliJoyCoastalState.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            suliJoyCoastalState.centerXAnchor.constraint(equalTo: reefCard.leadingAnchor, constant: 76),
            suliJoyCoastalState.widthAnchor.constraint(equalToConstant: 28),
            suliJoyCoastalState.heightAnchor.constraint(equalToConstant: 28),
            shoreReplyCountLabel.topAnchor.constraint(equalTo: suliJoyCoastalState.bottomAnchor),
            shoreReplyCountLabel.centerXAnchor.constraint(equalTo: suliJoyCoastalState.centerXAnchor),
            shoreReplyCountLabel.widthAnchor.constraint(equalToConstant: 48),
            shoreReplyDock.leadingAnchor.constraint(equalTo: reefCard.leadingAnchor, constant: 100),
            shoreReplyDock.trailingAnchor.constraint(equalTo: reefCard.trailingAnchor, constant: -4),
            shoreReplyDock.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            shoreReplyDock.heightAnchor.constraint(equalToConstant: 34),
            shoreReplyHintLabel.leadingAnchor.constraint(equalTo: shoreReplyDock.leadingAnchor, constant: 12),
            shoreReplyHintLabel.centerYAnchor.constraint(equalTo: shoreReplyDock.centerYAnchor),
            shoreReplyHintLabel.trailingAnchor.constraint(equalTo: reefSendMarkView.leadingAnchor, constant: -8),
            reefSendMarkView.trailingAnchor.constraint(equalTo: shoreReplyDock.trailingAnchor, constant: -12),
            reefSendMarkView.centerYAnchor.constraint(equalTo: shoreReplyDock.centerYAnchor),
            reefSendMarkView.widthAnchor.constraint(equalToConstant: ShoreMomentCellMetric.publishSide),
            reefSendMarkView.heightAnchor.constraint(equalToConstant: ShoreMomentCellMetric.publishSide)
        ])
    }

    func configure(with moment: SuliJoyReefMoment, isFollowing: Bool) {
        stylistPortrait.image = UIImage.suliJoyAssetOrLocal(named: moment.islandStylistAvatarAssetName)
        followBadge.suliJoyCoastalCapsule(isFollowing: isFollowing)
        stylistNameGlyph.text = moment.islandStylistName
        tideAgoGlyph.text = "\(moment.islandStylistMark) · \(moment.tideAgoText)"
        bodyLabel.text = moment.islandCaptionText
        renderWaveState(moment.waveNote)
        renderShoreReactions(moment)
        renderShoreMediaTiles(moment.reefMedia)
    }

    private func renderWaveState(_ note: SuliJoyWaveSonicNote) {
        let waveStripe = UIImage.suliJoyAssetOrLocal(named: note.waveStripeAssetToken)
            ?? UIImage(named: "sulijoy_feed_" + "trver_wave")
        waveRhythmView.image = waveStripe?.withRenderingMode(.alwaysOriginal)
        waveRhythmView.renderWaveState(note.isWaveRolling)
        waveDurationGlyph.text = "\(note.waveSeconds)s"
        wavePlayGlyph.image = UIImage(systemName: note.isWaveRolling ? "pause.fill" : "play.fill")
    }

    private func renderShoreReactions(_ moment: SuliJoyReefMoment) {
        let likeImage = UIImage(named: moment.isHearted ? "sulijoy_feed_like_active" : "sulijoy_feed_like_idle")?.withRenderingMode(.alwaysOriginal)
        likeButton.setImage(likeImage, for: .normal)
        shellHeartCountLabel.text = "\(moment.heartTally)"
        shoreReplyCountLabel.text = "\(moment.reefReplyTally)"
    }

    private func renderShoreMediaTiles(_ mediaItems: [SuliJoyReefMedia]) {
        mediaStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let shownMedia = mediaItems.prefix(3)
        mediaStack.isHidden = shownMedia.isEmpty
        for reefMedia in shownMedia {
            let reefSnapshotView = UIImageView(image: UIImage.suliJoyAssetOrLocal(named: reefMedia.reefAssetToken))
            reefSnapshotView.backgroundColor = UIColor(red: 1, green: 0.91, blue: 0.73, alpha: 1)
            reefSnapshotView.contentMode = .scaleAspectFill
            reefSnapshotView.clipsToBounds = true
            reefSnapshotView.layer.cornerRadius = 9
            mediaStack.addArrangedSubview(reefSnapshotView)
        }
    }

    @objc private func likeNow() { onHeartTap?() }
    @objc private func commentNow() { onReplyTap?() }
    @objc private func pulseWaveNow() { onWaveTap?() }
    @objc private func moreNow() { onHarborMoreTap?() }
    @objc private func authorNow() { onStylistTap?() }
    @objc private func followNow() { onLagoonFollowTap?() }
}

final class SuliJoyShoreMomentReefController: SuliJoyTropicCanvasController, UITextFieldDelegate, UIScrollViewDelegate {
    private enum MomentDetailMetric {
        static let contentTop: CGFloat = 14
        static let contentSide: CGFloat = 20
        static let contentBottom: CGFloat = -22
        static let stackGap: CGFloat = 16
        static let headerHeight: CGFloat = 44
        static let mediaRatio: CGFloat = 0.776
        static let waveOnlyMinHeight: CGFloat = 82
        static let inputHeight: CGFloat = 64
        static let keyboardInset: CGFloat = 16
        static let keyboardAnimation: TimeInterval = 0.25
    }

    private var suliJoyCoastalGalleryf: SuliJoyReefMoment
    private let reefDetailScroll = UIScrollView()
    private let suliJoyCoastalSnapshot = UIView()
    private let suliJoyIslandCapsule = UIStackView()
    private let suliJoySunsetJournal = UIView()
    private let reefBackControl = UIButton(type: .system)
    private let authorPortraitView = UIImageView()
    private let authorNameGlyph = UILabel()
    private let followButton = UIButton(type: .system)
    private let reefFlagControl = UIButton(type: .system)
    private let mediaContainer = UIView()
    private let mediaCarousel = UIScrollView()
    private let mediaRail = UIStackView()
    private let mediaPageIndicator = UIPageControl()
    private let imageWaveControl = UIButton(type: .system)
    private let imageWavePlayGlyph = UIImageView()
    private let imageWaveRhythmView = SuliJoyWaveRhythmView()
    private let imageWaveDurationGlyph = UILabel()
    private let waveOnlyControl = UIButton(type: .system)
    private let waveOnlyCaptionGlyph = UILabel()
    private let waveOnlyPlayGlyph = UIImageView()
    private let waveOnlyRhythmView = SuliJoyWaveRhythmView()
    private let waveOnlyDurationGlyph = UILabel()
    private let bodyLabel = UILabel()
    private let commentsTitleLabel = UILabel()
    private let commentsStack = UIStackView()
    private let bottomInputBar = UIView()
    private let commentField = UITextField()
    private let sendButton = UIButton(type: .system)
    private var bottomInputBottomConstraint: NSLayoutConstraint?
    private var isFollowingAuthor = false

    init(moment: SuliJoyReefMoment) {
        self.suliJoyCoastalGalleryf = moment
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("irnYirtI(EcuoedJeIrC:F)T QhGawsa HnXoStx ubUeTeGne HiDmcpUlueRmYeNnJtfeQdN".suliJoyPalmUnfurled)
    }

    @MainActor deinit {
        SuliJoyWaveResonanceHarbor.shared.stop(sunwashedDenim: suliJoyCoastalGalleryf.reefMomentID)
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        raiseMomentDetailScene()
        registerKeyboardObservers()
        renderMomentDetail()
    }

    private func raiseMomentDetailScene() {
        reefDetailScroll.translatesAutoresizingMaskIntoConstraints = false
        reefDetailScroll.keyboardDismissMode = .interactive
        reefDetailScroll.showsVerticalScrollIndicator = false
        suliJoyCoastalSnapshot.translatesAutoresizingMaskIntoConstraints = false
        suliJoyIslandCapsule.translatesAutoresizingMaskIntoConstraints = false
        suliJoyIslandCapsule.axis = .vertical
        suliJoyIslandCapsule.spacing = MomentDetailMetric.stackGap

        tuneMomentDetailHeader()
        tuneMomentDetailMediaModes()
        tuneMomentDetailCopyAndComments()
        tuneMomentDetailInput()

        view.addSubview(reefDetailScroll)
        view.addSubview(bottomInputBar)
        reefDetailScroll.addSubview(suliJoyCoastalSnapshot)
        suliJoyCoastalSnapshot.addSubview(suliJoyIslandCapsule)

        [suliJoySunsetJournal, mediaContainer, waveOnlyControl, bodyLabel, commentsTitleLabel, commentsStack].forEach {
            suliJoyIslandCapsule.addArrangedSubview($0)
        }
        suliJoyIslandCapsule.setCustomSpacing(22, after: suliJoySunsetJournal)
        suliJoyIslandCapsule.setCustomSpacing(14, after: mediaContainer)
        suliJoyIslandCapsule.setCustomSpacing(14, after: waveOnlyControl)
        suliJoyIslandCapsule.setCustomSpacing(18, after: bodyLabel)

        bottomInputBottomConstraint = bottomInputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomInputBottomConstraint?.isActive = true

        NSLayoutConstraint.activate([
            reefDetailScroll.topAnchor.constraint(equalTo: view.topAnchor),
            reefDetailScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reefDetailScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            reefDetailScroll.bottomAnchor.constraint(equalTo: bottomInputBar.topAnchor),

            suliJoyCoastalSnapshot.topAnchor.constraint(equalTo: reefDetailScroll.contentLayoutGuide.topAnchor),
            suliJoyCoastalSnapshot.leadingAnchor.constraint(equalTo: reefDetailScroll.contentLayoutGuide.leadingAnchor),
            suliJoyCoastalSnapshot.trailingAnchor.constraint(equalTo: reefDetailScroll.contentLayoutGuide.trailingAnchor),
            suliJoyCoastalSnapshot.bottomAnchor.constraint(equalTo: reefDetailScroll.contentLayoutGuide.bottomAnchor),
            suliJoyCoastalSnapshot.widthAnchor.constraint(equalTo: reefDetailScroll.frameLayoutGuide.widthAnchor),

            suliJoyIslandCapsule.topAnchor.constraint(equalTo: suliJoyCoastalSnapshot.safeAreaLayoutGuide.topAnchor, constant: MomentDetailMetric.contentTop),
            suliJoyIslandCapsule.leadingAnchor.constraint(equalTo: suliJoyCoastalSnapshot.leadingAnchor, constant: MomentDetailMetric.contentSide),
            suliJoyIslandCapsule.trailingAnchor.constraint(equalTo: suliJoyCoastalSnapshot.trailingAnchor, constant: -MomentDetailMetric.contentSide),
            suliJoyIslandCapsule.bottomAnchor.constraint(equalTo: suliJoyCoastalSnapshot.bottomAnchor, constant: MomentDetailMetric.contentBottom),

            suliJoySunsetJournal.heightAnchor.constraint(equalToConstant: MomentDetailMetric.headerHeight),
            mediaContainer.heightAnchor.constraint(equalTo: suliJoyIslandCapsule.widthAnchor, multiplier: MomentDetailMetric.mediaRatio),
            waveOnlyControl.heightAnchor.constraint(greaterThanOrEqualToConstant: MomentDetailMetric.waveOnlyMinHeight),

            bottomInputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomInputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomInputBar.heightAnchor.constraint(equalToConstant: MomentDetailMetric.inputHeight)
        ])

        let reefDismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        reefDismissTap.cancelsTouchesInView = false
        view.addGestureRecognizer(reefDismissTap)
    }

    private func tuneMomentDetailHeader() {
        suliJoySunsetJournal.translatesAutoresizingMaskIntoConstraints = false

        reefBackControl.translatesAutoresizingMaskIntoConstraints = false
        reefBackControl.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        reefBackControl.tintColor = .suliInk
        reefBackControl.addTarget(self, action: #selector(goBack), for: .touchUpInside)

        authorPortraitView.translatesAutoresizingMaskIntoConstraints = false
        authorPortraitView.contentMode = .scaleAspectFill
        authorPortraitView.clipsToBounds = true
        authorPortraitView.layer.cornerRadius = 18
        authorPortraitView.isUserInteractionEnabled = true
        authorPortraitView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openMomentAuthor)))

        authorNameGlyph.translatesAutoresizingMaskIntoConstraints = false
        authorNameGlyph.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        authorNameGlyph.textColor = .suliInk
        authorNameGlyph.numberOfLines = 1
        authorNameGlyph.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        authorNameGlyph.isUserInteractionEnabled = true
        authorNameGlyph.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openMomentAuthor)))

        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.setTitleColor(.white, for: .normal)
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .black)
        followButton.layer.cornerRadius = 14
        followButton.clipsToBounds = true
        followButton.backgroundColor = UIColor.purple
        followButton.addTarget(self, action: #selector(toggleFollow), for: .touchUpInside)

        reefFlagControl.translatesAutoresizingMaskIntoConstraints = false
        reefFlagControl.setImage(UIImage(systemName: "flag"), for: .normal)
        reefFlagControl.tintColor = .suliInk
        reefFlagControl.backgroundColor = UIColor.white.withAlphaComponent(0.70)
        reefFlagControl.layer.cornerRadius = 15
        reefFlagControl.accessibilityLabel = "Report moment"
        reefFlagControl.addTarget(self, action: #selector(reportMoment), for: .touchUpInside)

        [reefBackControl, authorPortraitView, authorNameGlyph, followButton, reefFlagControl].forEach { suliJoySunsetJournal.addSubview($0) }
        NSLayoutConstraint.activate([
            reefBackControl.leadingAnchor.constraint(equalTo: suliJoySunsetJournal.leadingAnchor),
            reefBackControl.centerYAnchor.constraint(equalTo: suliJoySunsetJournal.centerYAnchor),
            reefBackControl.widthAnchor.constraint(equalToConstant: 30),
            reefBackControl.heightAnchor.constraint(equalToConstant: 30),

            authorPortraitView.leadingAnchor.constraint(equalTo: reefBackControl.trailingAnchor, constant: 8),
            authorPortraitView.centerYAnchor.constraint(equalTo: suliJoySunsetJournal.centerYAnchor),
            authorPortraitView.widthAnchor.constraint(equalToConstant: 36),
            authorPortraitView.heightAnchor.constraint(equalToConstant: 36),

            authorNameGlyph.leadingAnchor.constraint(equalTo: authorPortraitView.trailingAnchor, constant: 10),
            authorNameGlyph.centerYAnchor.constraint(equalTo: suliJoySunsetJournal.centerYAnchor),
            authorNameGlyph.trailingAnchor.constraint(lessThanOrEqualTo: followButton.leadingAnchor, constant: -8),

            followButton.centerYAnchor.constraint(equalTo: suliJoySunsetJournal.centerYAnchor),
            followButton.trailingAnchor.constraint(equalTo: reefFlagControl.leadingAnchor, constant: -8),
            followButton.widthAnchor.constraint(equalToConstant: 80),
            followButton.heightAnchor.constraint(equalToConstant: 30),

            reefFlagControl.trailingAnchor.constraint(equalTo: suliJoySunsetJournal.trailingAnchor),
            reefFlagControl.centerYAnchor.constraint(equalTo: suliJoySunsetJournal.centerYAnchor),
            reefFlagControl.widthAnchor.constraint(equalToConstant: 30),
            reefFlagControl.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func tuneMomentDetailMediaModes() {
        mediaContainer.translatesAutoresizingMaskIntoConstraints = false
        mediaContainer.layer.cornerRadius = 18
        mediaContainer.clipsToBounds = true
        mediaContainer.backgroundColor = UIColor(red: 1, green: 0.91, blue: 0.73, alpha: 1)

        mediaCarousel.translatesAutoresizingMaskIntoConstraints = false
        mediaCarousel.isPagingEnabled = true
        mediaCarousel.showsHorizontalScrollIndicator = false
        mediaCarousel.alwaysBounceHorizontal = false
        mediaCarousel.delegate = self
        mediaRail.translatesAutoresizingMaskIntoConstraints = false
        mediaRail.axis = .horizontal
        mediaRail.spacing = 0
        mediaRail.distribution = .fill
        mediaPageIndicator.translatesAutoresizingMaskIntoConstraints = false
        mediaPageIndicator.currentPageIndicatorTintColor = .white
        mediaPageIndicator.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.5)
        mediaPageIndicator.hidesForSinglePage = true
        mediaPageIndicator.isUserInteractionEnabled = false
        mediaContainer.addSubview(mediaCarousel)
        mediaCarousel.addSubview(mediaRail)
        mediaContainer.addSubview(mediaPageIndicator)

        tuneMomentImageWavePill()
        tuneMomentWaveOnlyCard()

        NSLayoutConstraint.activate([
            mediaCarousel.topAnchor.constraint(equalTo: mediaContainer.topAnchor),
            mediaCarousel.leadingAnchor.constraint(equalTo: mediaContainer.leadingAnchor),
            mediaCarousel.trailingAnchor.constraint(equalTo: mediaContainer.trailingAnchor),
            mediaCarousel.bottomAnchor.constraint(equalTo: mediaContainer.bottomAnchor),
            mediaRail.topAnchor.constraint(equalTo: mediaCarousel.contentLayoutGuide.topAnchor),
            mediaRail.leadingAnchor.constraint(equalTo: mediaCarousel.contentLayoutGuide.leadingAnchor),
            mediaRail.trailingAnchor.constraint(equalTo: mediaCarousel.contentLayoutGuide.trailingAnchor),
            mediaRail.bottomAnchor.constraint(equalTo: mediaCarousel.contentLayoutGuide.bottomAnchor),
            mediaRail.heightAnchor.constraint(equalTo: mediaCarousel.frameLayoutGuide.heightAnchor),
            mediaPageIndicator.centerXAnchor.constraint(equalTo: mediaContainer.centerXAnchor),
            mediaPageIndicator.bottomAnchor.constraint(equalTo: mediaContainer.bottomAnchor, constant: -8),

            imageWaveControl.topAnchor.constraint(equalTo: mediaContainer.topAnchor, constant: 15),
            imageWaveControl.leadingAnchor.constraint(equalTo: mediaContainer.leadingAnchor, constant: 8),
            imageWaveControl.widthAnchor.constraint(equalToConstant: 146),
            imageWaveControl.heightAnchor.constraint(equalToConstant: 22)
        ])
    }

    private func tuneMomentImageWavePill() {
        imageWaveControl.translatesAutoresizingMaskIntoConstraints = false
        imageWaveControl.layer.cornerRadius = 11
        imageWaveControl.clipsToBounds = true
        imageWaveControl.setBackgroundImage(UIImage(named: "sulijoy_feed_detail_bottom_gradient"), for: .normal)
        imageWaveControl.addTarget(self, action: #selector(toggleWave), for: .touchUpInside)

        [imageWavePlayGlyph, imageWaveRhythmView, imageWaveDurationGlyph].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isUserInteractionEnabled = false
            imageWaveControl.addSubview($0)
        }
        imageWavePlayGlyph.tintColor = .white
        imageWaveRhythmView.contentMode = .scaleAspectFit
        imageWaveRhythmView.tintColor = .white
        imageWaveDurationGlyph.textColor = .white
        imageWaveDurationGlyph.font = UIFont.systemFont(ofSize: 10, weight: .black)
        mediaContainer.addSubview(imageWaveControl)

        NSLayoutConstraint.activate([
            imageWavePlayGlyph.leadingAnchor.constraint(equalTo: imageWaveControl.leadingAnchor, constant: 10),
            imageWavePlayGlyph.centerYAnchor.constraint(equalTo: imageWaveControl.centerYAnchor),
            imageWavePlayGlyph.widthAnchor.constraint(equalToConstant: 9),
            imageWavePlayGlyph.heightAnchor.constraint(equalToConstant: 9),
            imageWaveRhythmView.leadingAnchor.constraint(equalTo: imageWavePlayGlyph.trailingAnchor, constant: 7),
            imageWaveRhythmView.centerYAnchor.constraint(equalTo: imageWaveControl.centerYAnchor),
            imageWaveRhythmView.widthAnchor.constraint(equalToConstant: 69),
            imageWaveRhythmView.heightAnchor.constraint(equalToConstant: 14),
            imageWaveDurationGlyph.leadingAnchor.constraint(equalTo: imageWaveRhythmView.trailingAnchor, constant: 7),
            imageWaveDurationGlyph.trailingAnchor.constraint(lessThanOrEqualTo: imageWaveControl.trailingAnchor, constant: -8),
            imageWaveDurationGlyph.centerYAnchor.constraint(equalTo: imageWaveControl.centerYAnchor)
        ])
    }

    private func tuneMomentWaveOnlyCard() {
        waveOnlyControl.translatesAutoresizingMaskIntoConstraints = false
        waveOnlyControl.backgroundColor = .white
        waveOnlyControl.layer.cornerRadius = 8
        waveOnlyControl.layer.borderColor = UIColor(red: 0.26, green: 0.04, blue: 0.29, alpha: 1).cgColor
        waveOnlyControl.layer.borderWidth = 1
        waveOnlyControl.clipsToBounds = true
        waveOnlyControl.addTarget(self, action: #selector(toggleWave), for: .touchUpInside)

        [waveOnlyCaptionGlyph, waveOnlyPlayGlyph, waveOnlyRhythmView, waveOnlyDurationGlyph].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isUserInteractionEnabled = false
            waveOnlyControl.addSubview($0)
        }
        waveOnlyCaptionGlyph.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        waveOnlyCaptionGlyph.textColor = .suliInk
        waveOnlyCaptionGlyph.numberOfLines = 2
        waveOnlyPlayGlyph.tintColor = .suliInk
        waveOnlyRhythmView.contentMode = .scaleAspectFit
        waveOnlyRhythmView.tintColor = .suliInk
        waveOnlyDurationGlyph.textColor = .suliInk
        waveOnlyDurationGlyph.font = UIFont.systemFont(ofSize: 13, weight: .black)

        NSLayoutConstraint.activate([
            waveOnlyCaptionGlyph.topAnchor.constraint(equalTo: waveOnlyControl.topAnchor, constant: 16),
            waveOnlyCaptionGlyph.leadingAnchor.constraint(equalTo: waveOnlyControl.leadingAnchor, constant: 16),
            waveOnlyCaptionGlyph.trailingAnchor.constraint(equalTo: waveOnlyControl.trailingAnchor, constant: -16),
            waveOnlyPlayGlyph.leadingAnchor.constraint(equalTo: waveOnlyCaptionGlyph.leadingAnchor),
            waveOnlyPlayGlyph.topAnchor.constraint(equalTo: waveOnlyCaptionGlyph.bottomAnchor, constant: 18),
            waveOnlyPlayGlyph.widthAnchor.constraint(equalToConstant: 17),
            waveOnlyPlayGlyph.heightAnchor.constraint(equalToConstant: 17),
            waveOnlyRhythmView.leadingAnchor.constraint(equalTo: waveOnlyPlayGlyph.trailingAnchor, constant: 14),
            waveOnlyRhythmView.centerYAnchor.constraint(equalTo: waveOnlyPlayGlyph.centerYAnchor),
            waveOnlyRhythmView.widthAnchor.constraint(equalToConstant: 69),
            waveOnlyRhythmView.heightAnchor.constraint(equalToConstant: 20),
            waveOnlyDurationGlyph.leadingAnchor.constraint(equalTo: waveOnlyRhythmView.trailingAnchor, constant: 14),
            waveOnlyDurationGlyph.centerYAnchor.constraint(equalTo: waveOnlyPlayGlyph.centerYAnchor),
            waveOnlyDurationGlyph.trailingAnchor.constraint(lessThanOrEqualTo: waveOnlyControl.trailingAnchor, constant: -16)
        ])
    }

    private func tuneMomentDetailCopyAndComments() {
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        bodyLabel.textColor = UIColor.black.withAlphaComponent(0.80)
        bodyLabel.numberOfLines = 0

        commentsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        commentsTitleLabel.text = "CuoImOmTeungtBsw".suliJoyPalmUnfurled
        commentsTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .black)
        commentsTitleLabel.textColor = .suliInk

        commentsStack.translatesAutoresizingMaskIntoConstraints = false
        commentsStack.axis = .vertical
        commentsStack.spacing = 12
    }

    private func tuneMomentDetailInput() {
        bottomInputBar.translatesAutoresizingMaskIntoConstraints = false
        bottomInputBar.backgroundColor = .white

        commentField.translatesAutoresizingMaskIntoConstraints = false
        commentField.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        commentField.layer.cornerRadius = 18
        commentField.clipsToBounds = true
        commentField.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        commentField.textColor = .suliInk
        commentField.placeholder = "WVhnaFta qdwod zyAozuU UdToP NoEnt SwoeseSkHeAnKdmsT?t".suliJoyPalmUnfurled
        commentField.returnKeyType = .send
        commentField.delegate = self
        commentField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        commentField.leftViewMode = .always

        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setImage(UIImage(named: "sulijoy_feed_comment_send_mark"), for: .normal)
        sendButton.tintColor = .suliInk
        sendButton.imageView?.contentMode = .scaleAspectFit
        sendButton.imageEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        sendButton.addTarget(self, action: #selector(sendComment), for: .touchUpInside)

        bottomInputBar.addSubview(commentField)
        bottomInputBar.addSubview(sendButton)
        NSLayoutConstraint.activate([
            commentField.leadingAnchor.constraint(equalTo: bottomInputBar.leadingAnchor, constant: 48),
            commentField.centerYAnchor.constraint(equalTo: bottomInputBar.centerYAnchor),
            commentField.heightAnchor.constraint(equalToConstant: 36),
            sendButton.leadingAnchor.constraint(equalTo: commentField.trailingAnchor, constant: 12),
            sendButton.trailingAnchor.constraint(equalTo: bottomInputBar.trailingAnchor, constant: -44),
            sendButton.centerYAnchor.constraint(equalTo: commentField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 36),
            sendButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func renderMomentDetail() {
        let hasReefMedia = !suliJoyCoastalGalleryf.reefMedia.isEmpty
        authorPortraitView.image = UIImage.suliJoyAssetOrLocal(named: suliJoyCoastalGalleryf.islandStylistAvatarAssetName)
        authorNameGlyph.text = suliJoyCoastalGalleryf.islandStylistName
        isFollowingAuthor = SuliJoyCoveMockService.shared.isLagoonFollowing(authorName: suliJoyCoastalGalleryf.islandStylistName)
        renderMomentFollow()
        renderMomentWave()
        mediaContainer.isHidden = !hasReefMedia
        waveOnlyControl.isHidden = hasReefMedia
        renderMomentMedia()
        waveOnlyCaptionGlyph.text = suliJoyCoastalGalleryf.islandStyleLine
        bodyLabel.text = suliJoyCoastalGalleryf.islandCaptionText
        reefFlagControl.tintColor = suliJoyCoastalGalleryf.isReefFlagged ? UIColor(red: 1, green: 0.43, blue: 0.34, alpha: 1) : .suliInk
        renderMomentComments()
    }

    private func renderMomentFollow() {
        followButton.setTitle(isFollowingAuthor ? "FJoblslvoBwqimnogL".suliJoyPalmUnfurled : "FSoLlDlJoVwu".suliJoyPalmUnfurled, for: .normal)
        followButton.alpha = isFollowingAuthor ? 0.72 : 1
    }

    private func renderMomentWave() {
        let shoreWaveIconName = suliJoyCoastalGalleryf.waveNote.isWaveRolling ? "pause.fill" : "play.fill"
        [imageWavePlayGlyph, waveOnlyPlayGlyph].forEach {
            $0.image = UIImage(systemName: shoreWaveIconName)
        }
        let waveStripe = UIImage.suliJoyAssetOrLocal(named: suliJoyCoastalGalleryf.waveNote.waveStripeAssetToken)
            ?? UIImage(named: "sulijoy_feed_" + "trver_wave")
        imageWaveRhythmView.image = waveStripe?.withRenderingMode(.alwaysTemplate)
        waveOnlyRhythmView.image = waveStripe?.withRenderingMode(.alwaysTemplate)
        imageWaveRhythmView.renderWaveState(suliJoyCoastalGalleryf.waveNote.isWaveRolling)
        waveOnlyRhythmView.renderWaveState(suliJoyCoastalGalleryf.waveNote.isWaveRolling)
        let shoreWaveDuration = "\(suliJoyCoastalGalleryf.waveNote.waveSeconds)s"
        imageWaveDurationGlyph.text = shoreWaveDuration
        waveOnlyDurationGlyph.text = shoreWaveDuration
    }

    private func renderMomentMedia() {
        mediaRail.arrangedSubviews.forEach { reefSnapshot in
            mediaRail.removeArrangedSubview(reefSnapshot)
            reefSnapshot.removeFromSuperview()
        }
        for reefMedia in suliJoyCoastalGalleryf.reefMedia {
            let reefSnapshot = UIImageView(image: UIImage.suliJoyAssetOrLocal(named: reefMedia.reefAssetToken))
            reefSnapshot.translatesAutoresizingMaskIntoConstraints = false
            reefSnapshot.contentMode = .scaleAspectFill
            reefSnapshot.clipsToBounds = true
            mediaRail.addArrangedSubview(reefSnapshot)
            reefSnapshot.widthAnchor.constraint(equalTo: mediaCarousel.frameLayoutGuide.widthAnchor).isActive = true
        }
        mediaPageIndicator.numberOfPages = suliJoyCoastalGalleryf.reefMedia.count
        mediaPageIndicator.currentPage = 0
        mediaCarousel.setContentOffset(.zero, animated: false)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === mediaCarousel, scrollView.bounds.width > 0 else { return }
        let shorePage = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        mediaPageIndicator.currentPage = min(max(0, shorePage), max(0, mediaPageIndicator.numberOfPages - 1))
    }

    private func renderMomentComments() {
        commentsTitleLabel.text = "CVoRmPmceknJthsr".suliJoyPalmUnfurled
        commentsStack.arrangedSubviews.forEach { reefReplyTile in
            commentsStack.removeArrangedSubview(reefReplyTile)
            reefReplyTile.removeFromSuperview()
        }
        if suliJoyCoastalGalleryf.reefReplies.isEmpty {
            let emptyReplyGlyph = UILabel()
            emptyReplyGlyph.text = "NQoi vcmofmjmqepnQtgsk VyleHts.V".suliJoyPalmUnfurled
            emptyReplyGlyph.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            emptyReplyGlyph.textColor = .suliMutedInk
            emptyReplyGlyph.numberOfLines = 0
            commentsStack.addArrangedSubview(emptyReplyGlyph)
            return
        }
        for reefReply in suliJoyCoastalGalleryf.reefReplies {
            commentsStack.addArrangedSubview(makeMomentCommentCard(reefReply))
        }
    }

    private func makeMomentCommentCard(_ reefReply: SuliJoyReefReply) -> UIView {
        let replyCard = UIView()
        replyCard.translatesAutoresizingMaskIntoConstraints = false
        replyCard.backgroundColor = UIColor.white.withAlphaComponent(0.96)
        replyCard.layer.cornerRadius = 16
        replyCard.layer.shadowColor = UIColor.black.withAlphaComponent(0.03).cgColor
        replyCard.layer.shadowOpacity = 1
        replyCard.layer.shadowRadius = 10
        replyCard.layer.shadowOffset = CGSize(width: 0, height: 6)

        let replyPortrait = UIImageView(image: UIImage(named: reefReply.reefEchoAvatarAssetName))
        replyPortrait.translatesAutoresizingMaskIntoConstraints = false
        replyPortrait.contentMode = .scaleAspectFill
        replyPortrait.clipsToBounds = true
        replyPortrait.layer.cornerRadius = 18

        let replyNameGlyph = UILabel()
        replyNameGlyph.translatesAutoresizingMaskIntoConstraints = false
        replyNameGlyph.text = reefReply.reefEchoName
        replyNameGlyph.font = UIFont.systemFont(ofSize: 14, weight: .black)
        replyNameGlyph.textColor = .suliInk

        let replyTextGlyph = UILabel()
        replyTextGlyph.translatesAutoresizingMaskIntoConstraints = false
        replyTextGlyph.text = reefReply.reefPhraseText
        replyTextGlyph.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        replyTextGlyph.textColor = UIColor.black.withAlphaComponent(0.50)
        replyTextGlyph.numberOfLines = 0

        let replyTideGlyph = UILabel()
        replyTideGlyph.translatesAutoresizingMaskIntoConstraints = false
        replyTideGlyph.text = reefReply.tideAgoText
        replyTideGlyph.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        replyTideGlyph.textColor = UIColor.black.withAlphaComponent(0.30)

        let replyFlagControl = UIButton(type: .system)
        replyFlagControl.translatesAutoresizingMaskIntoConstraints = false
        replyFlagControl.setImage(UIImage(systemName: "exclamationmark.triangle"), for: .normal)
        replyFlagControl.tintColor = UIColor(red: 0.94, green: 0.89, blue: 0.84, alpha: 1)
        replyFlagControl.accessibilityLabel = "Report comment"
        replyFlagControl.addAction(UIAction { [weak self] _ in
            self?.reportComment(reefReply)
        }, for: .touchUpInside)

        [replyPortrait, replyNameGlyph, replyTextGlyph, replyTideGlyph, replyFlagControl].forEach { replyCard.addSubview($0) }
        NSLayoutConstraint.activate([
            replyCard.heightAnchor.constraint(greaterThanOrEqualToConstant: 82),
            replyPortrait.topAnchor.constraint(equalTo: replyCard.topAnchor, constant: 14),
            replyPortrait.leadingAnchor.constraint(equalTo: replyCard.leadingAnchor, constant: 14),
            replyPortrait.widthAnchor.constraint(equalToConstant: 36),
            replyPortrait.heightAnchor.constraint(equalToConstant: 36),
            replyNameGlyph.topAnchor.constraint(equalTo: replyPortrait.topAnchor),
            replyNameGlyph.leadingAnchor.constraint(equalTo: replyPortrait.trailingAnchor, constant: 10),
            replyNameGlyph.trailingAnchor.constraint(lessThanOrEqualTo: replyFlagControl.leadingAnchor, constant: -8),
            replyTextGlyph.topAnchor.constraint(equalTo: replyNameGlyph.bottomAnchor, constant: 3),
            replyTextGlyph.leadingAnchor.constraint(equalTo: replyNameGlyph.leadingAnchor),
            replyTextGlyph.trailingAnchor.constraint(equalTo: replyCard.trailingAnchor, constant: -42),
            replyTideGlyph.topAnchor.constraint(equalTo: replyTextGlyph.bottomAnchor, constant: 3),
            replyTideGlyph.leadingAnchor.constraint(equalTo: replyNameGlyph.leadingAnchor),
            replyTideGlyph.bottomAnchor.constraint(lessThanOrEqualTo: replyCard.bottomAnchor, constant: -14),
            replyFlagControl.trailingAnchor.constraint(equalTo: replyCard.trailingAnchor, constant: -14),
            replyFlagControl.bottomAnchor.constraint(equalTo: replyCard.bottomAnchor, constant: -16),
            replyFlagControl.widthAnchor.constraint(equalToConstant: 24),
            replyFlagControl.heightAnchor.constraint(equalToConstant: 24)
        ])
        return replyCard
    }

    private func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ note: Notification) {
        guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let overlap = max(0, frame.height - view.safeAreaInsets.bottom)
        bottomInputBottomConstraint?.constant = -overlap
        reefDetailScroll.contentInset.bottom = MomentDetailMetric.keyboardInset
        reefDetailScroll.scrollIndicatorInsets.bottom = MomentDetailMetric.keyboardInset
        UIView.animate(withDuration: MomentDetailMetric.keyboardAnimation) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ note: Notification) {
        bottomInputBottomConstraint?.constant = 0
        reefDetailScroll.contentInset.bottom = 0
        reefDetailScroll.scrollIndicatorInsets.bottom = 0
        UIView.animate(withDuration: MomentDetailMetric.keyboardAnimation) {
            self.view.layoutIfNeeded()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendComment()
        return true
    }

    @objc private func toggleFollow() {
        followButton.isEnabled = false
        SuliJoyCoveMockService.shared.toggleLagoonFollow(authorName: suliJoyCoastalGalleryf.islandStylistName) { [weak self] followEnvelope in
            guard let self else { return }
            self.followButton.isEnabled = true
            self.isFollowingAuthor = followEnvelope.sandbarLayering ?? self.isFollowingAuthor
            self.renderMomentFollow()
            NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
            self.showLagoonToast(followEnvelope.coastalWardrobe)
        }
    }

    @objc private func openMomentAuthor() {
        let islandGuestController = SuliJoyIslandGuestProfileViewController(displayName: suliJoyCoastalGalleryf.islandStylistName)
        navigationController?.pushViewController(islandGuestController, animated: true)
    }

    @objc private func toggleWave() {
        guard suliJoyCoastalGalleryf.waveNote.waveSeconds > 0 else {
            showLagoonToast("NTog mwbaDvAeV XnooZtEel TaytwtdadcIhueNdU.G".suliJoyPalmUnfurled)
            return
        }
        SuliJoyCoveMockService.shared.toggleWavePlayback(sunwashedDenim: suliJoyCoastalGalleryf.reefMomentID) { [weak self] waveEnvelope in
            guard let self, let refreshedMoment = waveEnvelope.sandbarLayering else { return }
            var renderedMoment = refreshedMoment
            if refreshedMoment.waveNote.isWaveRolling {
                do {
                    try SuliJoyWaveResonanceHarbor.shared.play(note: refreshedMoment.waveNote, sunwashedDenim: refreshedMoment.reefMomentID) { [weak self] momentID in
                        self?.finishMomentWave(momentID)
                    }
                } catch {
                    renderedMoment.waveNote.isWaveRolling = false
                    renderedMoment.waveNote.waveProgressRatio = 0
                    self.showLagoonToast("WQaSvkeL vnZoGtyeI yuhndapvnarislFaTbylneF.m".suliJoyPalmUnfurled)
                }
            } else {
                SuliJoyWaveResonanceHarbor.shared.stop(sunwashedDenim: refreshedMoment.reefMomentID)
            }
            self.suliJoyCoastalGalleryf = renderedMoment
            self.renderMomentWave()
        }
    }

    private func finishMomentWave(_ momentID: String) {
        guard suliJoyCoastalGalleryf.reefMomentID == momentID else { return }
        SuliJoyCoveMockService.shared.toggleWavePlayback(sunwashedDenim: momentID) { [weak self] waveEnvelope in
            guard let self, var refreshedMoment = waveEnvelope.sandbarLayering else { return }
            refreshedMoment.waveNote.isWaveRolling = false
            refreshedMoment.waveNote.waveProgressRatio = 0
            self.suliJoyCoastalGalleryf = refreshedMoment
            self.renderMomentWave()
        }
    }

    @objc private func sendComment() {
        let reefReplyText = commentField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !reefReplyText.isEmpty else {
            showLagoonToast("PbloebaUsVeM ieindtveIry yas KcZoampmOeFnete.V".suliJoyPalmUnfurled)
            return
        }
        sendButton.isEnabled = false
        SuliJoyCoveMockService.shared.addShoreComment(sunwashedDenim: suliJoyCoastalGalleryf.reefMomentID, text: reefReplyText) { [weak self] reefEnvelope in
            guard let self else { return }
            self.sendButton.isEnabled = true
            if let refreshedMoment = reefEnvelope.sandbarLayering {
                self.suliJoyCoastalGalleryf = refreshedMoment
                self.commentField.text = nil
                self.renderMomentComments()
                self.scrollCommentsToBottom()
            }
            self.showLagoonToast(reefEnvelope.coastalWardrobe)
        }
    }

    private func reportComment(_ reefReply: SuliJoyReefReply) {
        presentSuliJoyHarborGuardMenu { [weak self] in
            guard let self else { return }
            self.presentSuliJoyReportSheet(target: .linenVest(sunwashedDenim: self.suliJoyCoastalGalleryf.reefMomentID, washedCotton: reefReply.reefReplyID))
        } block: { [weak self] in
            guard let self else { return }
            SuliJoyCoveMockService.shared.blockMomentAuthor(sunwashedDenim: self.suliJoyCoastalGalleryf.reefMomentID) { guardEnvelope in
                self.showLagoonToast(guardEnvelope.coastalWardrobe)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @objc private func reportMoment() {
        presentSuliJoyHarborGuardMenu { [weak self] in
            guard let self else { return }
            self.presentSuliJoyReportSheet(target: .beachBlazer(sunwashedDenim: self.suliJoyCoastalGalleryf.reefMomentID)) { [weak self] in
                self?.suliJoyCoastalGalleryf.isReefFlagged = true
                self?.renderMomentDetail()
            }
        } block: { [weak self] in
            guard let self else { return }
            SuliJoyCoveMockService.shared.blockMomentAuthor(sunwashedDenim: self.suliJoyCoastalGalleryf.reefMomentID) { guardEnvelope in
                self.showLagoonToast(guardEnvelope.coastalWardrobe)
                NotificationCenter.default.post(name: .suliJoyLagoonVisitorChanged, object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func scrollCommentsToBottom() {
        view.layoutIfNeeded()
        let reefBottomOffset = CGPoint(
            x: 0,
            y: max(0, reefDetailScroll.contentSize.height - reefDetailScroll.bounds.height + reefDetailScroll.adjustedContentInset.bottom)
        )
        reefDetailScroll.setContentOffset(reefBottomOffset, animated: true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
