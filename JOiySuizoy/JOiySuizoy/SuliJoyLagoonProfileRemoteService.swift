import Foundation
import AVFoundation

struct SuliJoyLagoonVoiceCard: Equatable {
    let roomID: String
    let place: String
    let hostName: String
    let hostPortraitToken: String
    let coverToken: String
    let heat: Int
    let audience: Int
    let summary: String
    let faceTokens: [String]
}

struct SuliJoyLagoonLiveCategoryChoice: Equatable {
    let submitValue: String
    let displayTitle: String
}

struct SuliJoyLagoonLiveHostSetup {
    let categoryChoices: [SuliJoyLagoonLiveCategoryChoice]
    let liveTypes: [(code: String, title: String)]
    let locales: [(languageName: String, countryCode: String)]
    let contentReminderText: String

    var categories: [String] { categoryChoices.map(\.submitValue) }
}

struct SuliJoyLagoonVoiceRoomTagChoice: Equatable {
    let submitValue: String
    let displayTitle: String
}

struct SuliJoyLagoonVoiceRoomSetup {
    let canCreateRoom: Bool
    let createRoomLevel: Int
    let roomTagChoices: [SuliJoyLagoonVoiceRoomTagChoice]
    let templates: [(id: Int, title: String, imageURL: String)]
    let languages: [(name: String, code: String)]
}

enum SuliJoyGoLiveCatalog {
    /// Live-list row tags. Two labels are chosen from this fixed pool for each room.
    static let displayShoreCategories = ["Chill", "Style", "Lifestyle", "Beachwear", "Resort Look", "Coastal Vibes"]

    private static let shelfLock = NSLock()
    private static var publishCategoriesStorage: [String] = []

    /// Latest `categories` from live host options — sole source for Go Live chips and live list tag pool.
    static var publishCategories: [String] {
        shelfLock.lock()
        defer { shelfLock.unlock() }
        return publishCategoriesStorage
    }

    static func replacePublishCategories(_ raw: [String]) {
        var seen = Set<String>()
        var cleaned: [String] = []
        for name in raw {
            let line = name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !line.isEmpty else { continue }
            let key = line.lowercased()
            guard !seen.contains(key) else { continue }
            seen.insert(key)
            cleaned.append(line)
        }
        shelfLock.lock()
        publishCategoriesStorage = cleaned
        shelfLock.unlock()
    }

    /// Backend `liveType` — pass the option `code` from host options, not the chip label.
    static let defaultLiveTypes: [(code: String, title: String)] = [
        ("VIDEO", "Style cam"),
        ("AUDIO", "Voice chat"),
    ]
    static let defaultLanguageName = "English"
    static let defaultCountryCode = "US"
}

struct SuliJoyGoLiveDraft {
    let coverSandboxPath: String
    let liveTitle: String
    let category: String?
    let liveType: String
    let contentReminderAccepted: Bool

    var languageName: String { SuliJoyGoLiveCatalog.defaultLanguageName }
    var countryCode: String { SuliJoyGoLiveCatalog.defaultCountryCode }
}

enum SuliJoyVoiceRoomCatalog {
    static let defaultLanguageName = "English"
    private static let shelfLock = NSLock()
    private static var roomLanguageCodeStorage = ""

    /// `roomLanguage` on create — language **code** from party languages API (H5 parity).
    static var defaultRoomLanguageCode: String {
        shelfLock.lock()
        defer { shelfLock.unlock() }
        return roomLanguageCodeStorage
    }

    static func replaceDefaultRoomLanguageCode(_ code: String) {
        let line = code.trimmingCharacters(in: .whitespacesAndNewlines)
        shelfLock.lock()
        roomLanguageCodeStorage = line
        shelfLock.unlock()
    }
}

struct SuliJoyVoiceRoomDraft {
    let coverSandboxPath: String
    let roomName: String
    let greetingMessage: String
    let roomTempID: Int

    var roomLanguageCode: String { SuliJoyVoiceRoomCatalog.defaultRoomLanguageCode }
}

struct SuliJoyLagoonLiveCard: Equatable {
    let roomID: String
    let hostID: String
    let title: String
    let subtitle: String
    let coverToken: String
    let portraitToken: String
    let heat: Int
    let onlineCount: Int
    let viewerPortraitTokens: [String]
    let tagLabels: [String]
    let category: String
    let followed: Bool
}

struct SuliJoyLagoonLetterThread: Equatable {
    let conversationID: String
    let peerID: String
    let peerName: String
    let portraitToken: String
    let preview: String
    let momentLine: String
    let unread: Int
    let blocked: Bool
}

struct SuliJoyLagoonLetterNote: Equatable {
    let noteID: String
    let text: String
    let own: Bool
    let momentLine: String
    let createdAt: Int64
}

enum SuliJoyLagoonLetterCopy {
    static func preview(for letter: SuliJoyLagoonRemoteLetter?) -> String {
        guard let letter else { return "" }
        switch letter.kind {
        case "image":
            return "Photo"
        case "voice":
            return "Voice"
        case "video_call":
            return "Video call"
        default:
            return letter.text
        }
    }

    static func note(from letter: SuliJoyLagoonRemoteLetter) -> SuliJoyLagoonLetterNote {
        SuliJoyLagoonLetterNote(
            noteID: letter.noteID.isEmpty ? UUID().uuidString : letter.noteID,
            text: preview(for: letter),
            own: letter.own,
            momentLine: clock(milliseconds: letter.createdAt),
            createdAt: letter.createdAt
        )
    }

    static func clock(milliseconds: Int64) -> String {
        guard milliseconds > 0 else { return "" }
        let date = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = Calendar.current.isDateInToday(date) ? "h:mm a" : "MMM d"
        return formatter.string(from: date)
    }
}

struct SuliJoyLagoonLiveShelf: Equatable {
    let cards: [SuliJoyLagoonLiveCard]
    let total: Int
}

final class SuliJoyLagoonProfileRemoteService {
    static let shared = SuliJoyLagoonProfileRemoteService()

    private let remoteClient: SuliJoyLagoonRemoteClient
    private var visitorShelf: [String: SuliJoyLagoonVisitor] = [:]
    private var momentShelf: [String: SuliJoyReefMoment] = [:]
    private var clipShelf: [String: SuliJoyShellClip] = [:]
    private var followingMarks: Set<String> = []
    private let shelfLock = NSLock()

    private init() {
        remoteClient = SuliJoyLagoonRemoteClient(sessionVault: SuliJoyTideSessionVault())
    }

    func fetchIslandProfileSummary(completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyLagoonProfileSnapshot>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let profile = try await remoteClient.fetchCurrentIslandProfile()
                let avatarToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: profile.icon)
                let snapshot = SuliJoyLagoonProfileSnapshot(
                    lagoonNameText: profile.nickname,
                    lagoonAvatarAssetName: avatarToken,
                    islandTraceText: String(profile.userID),
                    reefTallies: [
                        SuliJoyReefProfileTally(reefLabel: "Friends", reefTotal: profile.friendCount),
                        SuliJoyReefProfileTally(reefLabel: "Following", reefTotal: profile.followingCount),
                        SuliJoyReefProfileTally(reefLabel: "Fans", reefTotal: profile.followerCount),
                        SuliJoyReefProfileTally(reefLabel: "Likes", reefTotal: profile.receivedLikeCount)
                    ]
                )
                completion(.success(snapshot))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func syncCurrentPearlBalance(completion: @escaping (SuliJoySuiRequestEnvelope<Int>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let profile = try await remoteClient.fetchCurrentIslandProfile()
                SuliJoyShellPearlStore.shared.syncPearlBalance(profile.diamondBalance)
                completion(.success(profile.diamondBalance))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func fetchRecommendedStylists(completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyLagoonStylist]>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let remoteStylists = try await remoteClient.fetchLagoonStylists()
                let stylists = await remoteStylists.list.asyncMap { row in
                    let portraitToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: row.icon)
                    return SuliJoyLagoonStylist(
                        stylistID: String(row.userId),
                        displayName: row.nickName,
                        avatarAssetName: portraitToken,
                        suliJoyCoastalModeration: 0,
                        suliJoyCoastalChecklist: row.fansCount,
                        suliJoyCoastalMeter: row.followed
                    )
                }
                completion(.success(stylists))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func fetchBlockedLagoonVisitors(completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyLagoonVisitor]>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let blockedUsers = try await remoteClient.fetchBlockedIslandUsers()
                let visitors = await blockedUsers.rows.asyncMap { user in
                    let portraitToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: user.icon)
                    return SuliJoyLagoonVisitor(
                        lagoonGuestToken: String(user.userID),
                        islandStylistAlias: user.nickname,
                        portraitAssetToken: portraitToken,
                        shorelineHeartTotal: 0,
                        reefFollowerTotal: 0,
                        coveFollowingTotal: 0,
                        coveAffinityState: .shorelineUnlinked,
                        suliJoyIslandEnsemble: false,
                        suliJoyIslandIndex: false
                    )
                }
                completion(.success(visitors))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func fetchMineShoreMoments(completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyReefMoment]>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let remoteMoments = try await remoteClient.fetchIslandMoments()
                let moments = await remoteMoments.rows.asyncMap { [weak self] row in
                    await self?.makeMoment(from: row) ?? SuliJoyLagoonProfileRemoteMapper.emptyMoment
                }
                remember(moments: moments)
                completion(.success(moments))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func fetchMineShellClips(completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyShellClip]>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let remoteClips = try await remoteClient.fetchIslandShortVideos()
                let clips = await remoteClips.items.asyncMap { [weak self] row in
                    await self?.makeClip(from: row) ?? SuliJoyLagoonProfileRemoteMapper.emptyClip
                }
                remember(clips: clips)
                completion(.success(clips))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func fetchMineTideActivities(completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyTideActivity]>) -> Void) {
        fetchIslandActivities(userID: nil, completion: completion)
    }

    func fetchVoiceBoard(
        lane: SuliJoyVoiceRoomLane = .islandVibes,
        completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyLagoonVoiceCard]>) -> Void
    ) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let rooms = try await remoteClient.fetchVoiceRooms(lane: lane)
                let cards = await rooms.asyncMap { await self.makeVoiceCard(from: $0) }
                self.finishBoard { completion(.success(cards)) }
            } catch {
                self.finishBoard { completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode)) }
            }
        }
    }

    func fetchLiveBoard(
        category: String? = nil,
        completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyLagoonLiveShelf>) -> Void
    ) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let rooms = try await remoteClient.fetchDiscoverLiveRooms(category: category)
                let cards = await rooms.rows.filter { $0.roomID > 0 }.asyncMap { await self.makeLiveCard(from: $0) }
                let shelf = SuliJoyLagoonLiveShelf(cards: cards, total: max(rooms.total, cards.count))
                self.finishBoard { completion(.success(shelf)) }
            } catch {
                self.finishBoard { completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode)) }
            }
        }
    }

    func fetchPublicShellClips(completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyShellClip]>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let remoteClips = try await remoteClient.fetchShellClips()
                let clips = await remoteClips.items.asyncMap { [weak self] row in
                    await self?.makeClip(from: row) ?? SuliJoyLagoonProfileRemoteMapper.emptyClip
                }
                remember(clips: clips)
                finishBoard { completion(.success(clips)) }
            } catch {
                finishBoard { completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode)) }
            }
        }
    }

    func fetchShoreMoments(
        filter: SuliJoyReefMomentFilter,
        completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyReefMoment]>) -> Void
    ) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let feedType: String
                switch filter {
                case .coastalPick: feedType = "NEW"
                case .sunsetRush: feedType = "TRENDING"
                case .lagoonCircle: feedType = "FOLLOW"
                }
                let remoteMoments = try await remoteClient.fetchIslandMomentFeed(feedType: feedType)
                let moments = await remoteMoments.rows.asyncMap { [weak self] row in
                    await self?.makeMoment(from: row) ?? SuliJoyLagoonProfileRemoteMapper.emptyMoment
                }
                remember(moments: moments)
                completion(.success(moments))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func fetchMomentComments(
        momentID: String,
        completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyReefReply]>) -> Void
    ) {
        guard let numericID = Int64(momentID) else {
            completion(.failure("Moment is unavailable.", code: 400))
            return
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                let remoteComments = try await remoteClient.fetchIslandMomentComments(momentID: numericID)
                let comments = await remoteComments.rows.asyncMap { row in
                    let avatarToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: row.icon)
                    return SuliJoyReefReply(
                        reefReplyID: String(row.commentID),
                        reefEchoName: row.nickname,
                        reefEchoAvatarAssetName: avatarToken,
                        reefPhraseText: row.content,
                        tideAgoText: row.createTime
                    )
                }
                if var moment = currentMoment(for: momentID) {
                    moment.reefReplies = comments
                    moment.reefReplyTally = comments.count
                    remember(moment: moment)
                }
                completion(.success(comments))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func addShoreComment(
        momentID: String,
        text: String,
        completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyReefMoment>) -> Void
    ) {
        guard let numericID = Int64(momentID), var moment = currentMoment(for: momentID) else {
            completion(.failure("Moment is unavailable.", code: 400))
            return
        }
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            completion(.failure("Please enter a comment.", code: 400))
            return
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                let result = try await remoteClient.createIslandMomentComment(momentID: numericID, content: trimmedText)
                let profile = try? await remoteClient.fetchCurrentIslandProfile()
                let avatarToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: profile?.icon ?? "")
                moment.reefReplies.append(
                    SuliJoyReefReply(
                        reefReplyID: String(result.commentID),
                        reefEchoName: profile?.nickname ?? "",
                        reefEchoAvatarAssetName: avatarToken,
                        reefPhraseText: trimmedText,
                        tideAgoText: "just now"
                    )
                )
                moment.reefReplyTally = max(result.commentCount, moment.reefReplies.count)
                remember(moment: moment)
                completion(.success(moment, note: "Comment added."))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func fetchShellClipDetail(
        clipID: String,
        completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyShellClip>) -> Void
    ) {
        guard let numericID = Int64(clipID) else {
            completion(.failure("Short video is unavailable.", code: 400))
            return
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                let result = try await remoteClient.fetchIslandShortVideoDetail(videoID: numericID)
                var clip = await makePublishedClip(from: result)
                if let comments = try? await remoteClient.fetchIslandShortVideoComments(videoID: numericID) {
                    clip.sailorCollar = await makeClipComments(from: comments.items)
                    clip.marineStripe = max(clip.marineStripe, clip.sailorCollar.count)
                }
                remember(clip: clip)
                completion(.success(clip))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func reportShoreContent(
        draft: SuliJoyShoreReportDraft,
        completion: @escaping (SuliJoySuiRequestEnvelope<Bool>) -> Void
    ) {
        Task { [weak self] in
            guard let self else { return }
            do {
                switch draft.target {
                case .beachBlazer(let momentID):
                    guard let numericID = Int64(momentID) else { throw SuliJoyLagoonRemoteError.invalidRequest }
                    try await remoteClient.reportIslandMoment(
                        momentID: numericID,
                        commentID: nil,
                        reasonCode: draft.reason.rawValue,
                        description: draft.otherText
                    )
                case .linenVest(let momentID, let commentID):
                    guard let numericID = Int64(momentID), let numericCommentID = Int64(commentID) else { throw SuliJoyLagoonRemoteError.invalidRequest }
                    try await remoteClient.reportIslandMoment(
                        momentID: numericID,
                        commentID: numericCommentID,
                        reasonCode: draft.reason.rawValue,
                        description: draft.otherText
                    )
                case .flowyHem(let clipID), .relaxedTailor(let clipID, _):
                    guard let numericID = Int64(clipID) else { throw SuliJoyLagoonRemoteError.invalidRequest }
                    try await remoteClient.reportIslandShortVideo(
                        videoID: numericID,
                        reasonCode: draft.reason.rawValue,
                        description: draft.otherText
                    )
                case .softDrape(let visitorID):
                    try await blockLagoonVisitorRemote(visitorID: visitorID)
                case .wideLegLinen, .breezyFit:
                    throw SuliJoyLagoonRemoteError.business(code: "400", message: "This report target is unavailable.", requestID: nil)
                }
                completion(.success(true, note: "Report received."))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func publishShoreMoment(
        draft: SuliJoyShoreDraftMoment,
        completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyReefMoment>) -> Void
    ) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let text = draft.islandCaptionLine.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !text.isEmpty || !draft.reefPicks.isEmpty || draft.waveDraft != nil else {
                    completion(.failure("Please add content."))
                    return
                }
                let imageURLs = try await draft.reefPicks.asyncThrowingMap { pick in
                    try await self.uploadIslandResource(path: pick.reefSandboxPath, mimeType: "image/jpeg")
                }
                let audioURL: String?
                if let waveDraft = draft.waveDraft, !waveDraft.waveSandboxPath.isEmpty {
                    audioURL = try await uploadIslandResource(path: waveDraft.waveSandboxPath, mimeType: "audio/m4a")
                } else {
                    audioURL = nil
                }
                let result = try await remoteClient.publishIslandMoment(
                    textContent: text,
                    imageURLs: imageURLs,
                    audioURL: audioURL,
                    audioDuration: audioURL == nil ? nil : draft.waveDraft?.waveSeconds
                )
                guard result.published else {
                    completion(.failure(result.message.isEmpty ? "The post could not be published." : result.message))
                    return
                }
                let moment = await makePublishedMoment(
                    momentID: result.momentID,
                    text: text,
                    imageURLs: imageURLs,
                    audioURL: audioURL,
                    audioDuration: draft.waveDraft?.waveSeconds ?? 0
                )
                remember(moment: moment)
                completion(.success(moment, note: result.message.isEmpty ? "Published." : result.message))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func publishReefClip(
        draft: SuliJoyReefClipDraft,
        completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyShellClip>) -> Void
    ) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let caption = draft.hibiscusShade.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !caption.isEmpty || draft.tropicalMotif != nil else {
                    completion(.failure("Please add a clip or caption."))
                    return
                }
                guard let media = draft.tropicalMotif else {
                    completion(.failure("A video is required."))
                    return
                }
                let videoURL = try await uploadIslandResource(path: media.reefMotionPath, mimeType: mediaMimeType(for: media.reefMotionPath))
                let coverURL: String?
                if let coverPath = media.coverImagePath, !coverPath.isEmpty {
                    coverURL = try await uploadIslandResource(path: coverPath, mimeType: "image/jpeg")
                } else {
                    coverURL = nil
                }
                let asset = AVURLAsset(url: URL(fileURLWithPath: media.reefMotionPath))
                let duration = max(0, Int(asset.duration.seconds.rounded()))
                let naturalSize = asset.tracks(withMediaType: .video).first?.naturalSize ?? .zero
                let result = try await remoteClient.publishIslandShortVideo(
                    caption: caption,
                    videoURL: videoURL,
                    coverURL: coverURL,
                    durationSeconds: duration,
                    width: max(0, Int(abs(naturalSize.width))),
                    height: max(0, Int(abs(naturalSize.height)))
                )
                let clip = await makePublishedClip(from: result)
                remember(clip: clip)
                completion(.success(clip, note: "Published."))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func fetchLiveHostSetup(completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyLagoonLiveHostSetup>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let options = try await remoteClient.fetchLiveHostOptions()
                SuliJoyGoLiveCatalog.replacePublishCategories(options.categories)
                let categoryChoices = options.categoryChoices.map {
                    SuliJoyLagoonLiveCategoryChoice(submitValue: $0.submitValue, displayTitle: $0.displayTitle)
                }
                let setup = SuliJoyLagoonLiveHostSetup(
                    categoryChoices: categoryChoices,
                    liveTypes: options.liveTypes.map { ($0.code, $0.title) },
                    locales: options.locales.map { ($0.languageName, $0.countryCode) },
                    contentReminderText: options.contentReminderText
                )
                completion(.success(setup))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func publishLiveBroadcast(
        draft: SuliJoyGoLiveDraft,
        completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyLagoonRemoteLiveHostSession>) -> Void
    ) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let title = draft.liveTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !title.isEmpty else {
                    completion(.failure("Enter a live title."))
                    return
                }
                let options = try await remoteClient.fetchLiveHostOptions()
                SuliJoyGoLiveCatalog.replacePublishCategories(options.categories)
                let allowedCategories = options.categories.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
                guard let pickedCategory = draft.category?.trimmingCharacters(in: .whitespacesAndNewlines),
                      !pickedCategory.isEmpty,
                      let category = allowedCategories.first(where: { $0.caseInsensitiveCompare(pickedCategory) == .orderedSame }) else {
                    completion(.failure("Select a category from the list."))
                    return
                }
                let allowedTypeCodes = Set(options.liveTypes.map(\.code))
                let liveType = allowedTypeCodes.contains(draft.liveType) ? draft.liveType : (options.liveTypes.first?.code ?? draft.liveType)
                let coverURL = try await uploadIslandResource(path: draft.coverSandboxPath, mimeType: "image/jpeg")
                let requestNo = UUID().uuidString
                let prepared = try await remoteClient.prepareLiveHostSession(
                    category: category,
                    coverURL: coverURL,
                    liveTitle: title,
                    liveType: liveType,
                    languageName: draft.languageName,
                    countryCode: draft.countryCode,
                    requestNo: requestNo,
                    contentReminderAccepted: true
                )
                let started = try await remoteClient.startLiveHostSession(
                    roomID: prepared.roomID,
                    sessionID: prepared.sessionID
                )
                completion(.success(started, note: "You are live."))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func fetchVoiceRoomSetup(completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyLagoonVoiceRoomSetup>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                async let conditionsTask = remoteClient.fetchPartyCreateConditions()
                async let templatesTask = remoteClient.fetchPartyRoomTemplates()
                async let languagesTask = remoteClient.fetchPartyLanguages()
                let conditions = try await conditionsTask
                let templates = try await templatesTask
                let languages = try await languagesTask
                let languageCode = Self.resolvePartyRoomLanguageCode(from: languages)
                SuliJoyVoiceRoomCatalog.replaceDefaultRoomLanguageCode(languageCode)
                let tagChoices = conditions.roomTagChoices.map {
                    SuliJoyLagoonVoiceRoomTagChoice(submitValue: $0.submitValue, displayTitle: $0.displayTitle)
                }
                let setup = SuliJoyLagoonVoiceRoomSetup(
                    canCreateRoom: conditions.canCreateRoom,
                    createRoomLevel: conditions.createRoomLevel,
                    roomTagChoices: tagChoices,
                    templates: templates.map { ($0.templateID, $0.title, $0.imageURL) },
                    languages: languages.map { ($0.languageName, $0.languageCode) }
                )
                completion(.success(setup))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func publishVoiceRoom(
        draft: SuliJoyVoiceRoomDraft,
        completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyLagoonRemotePartyRoom>) -> Void
    ) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let roomName = draft.roomName.trimmingCharacters(in: .whitespacesAndNewlines)
                let greeting = draft.greetingMessage.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !roomName.isEmpty else {
                    completion(.failure("Enter a room name."))
                    return
                }
                guard !greeting.isEmpty else {
                    completion(.failure("Add a short greeting for listeners."))
                    return
                }
                let languages = try await remoteClient.fetchPartyLanguages()
                let roomLanguageCode = Self.resolvePartyRoomLanguageCode(from: languages)
                SuliJoyVoiceRoomCatalog.replaceDefaultRoomLanguageCode(roomLanguageCode)
                let avatarURL = try await uploadIslandResource(path: draft.coverSandboxPath, mimeType: "image/jpeg")
                // Match room-shell H5: create payload omits `roomTags` (backend 4002 when tags are not exact codes).
                let room = try await remoteClient.createIslandPartyRoom(
                    roomName: roomName,
                    roomAvatar: avatarURL,
                    greetingMessage: greeting,
                    roomLanguage: draft.roomLanguageCode.isEmpty ? roomLanguageCode : draft.roomLanguageCode,
                    roomTempID: draft.roomTempID
                )
                completion(.success(room, note: "Room created."))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func publishTideActivity(
        draft: SuliJoyTideDraftActivity,
        completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyTideActivity>) -> Void
    ) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let title = draft.tideTitleLine.trimmingCharacters(in: .whitespacesAndNewlines)
                let brief = draft.shoreBriefLine.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !title.isEmpty, !brief.isEmpty, let firstPick = draft.reefPhotoPicks.first else {
                    completion(.failure("Please complete the activity details."))
                    return
                }
                let avatarURL = try await uploadIslandResource(path: firstPick.reefSandboxPath, mimeType: "image/jpeg")
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "EEE, MMM d, yyyy h:mm a"
                let schedule = dateFormatter.string(from: combineActivityDate(day: draft.tideDay, clock: draft.tideClock))
                let location = draft.shoreSpotLine.trimmingCharacters(in: .whitespacesAndNewlines)
                let detail = [
                    brief,
                    "Type: \(draft.tideStyleKind)",
                    "Dress theme: \(draft.wardrobeThemeLine)",
                    "When: \(schedule)",
                    "Location: \(location)",
                    "Group size: \(draft.tideCrewLimit)",
                    "Activity fee: \(draft.pearlNeed)"
                ].joined(separator: "\n")
                let languages = try await remoteClient.fetchPartyLanguages()
                let roomLanguageCode = Self.resolvePartyRoomLanguageCode(from: languages)
                let room = try await remoteClient.createIslandPartyRoom(
                    roomName: title,
                    roomAvatar: avatarURL,
                    greetingMessage: detail,
                    roomLanguage: roomLanguageCode
                )
                completion(.success(await makeActivity(from: room), note: "Published."))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func fetchLagoonVisitorProfile(seersuckerStripe visitorID: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyLagoonVisitor>) -> Void) {
        guard let numericID = Int64(visitorID) else {
            completion(.failure("Visitor profile is unavailable.", code: 400))
            return
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                let card = try await remoteClient.fetchIslandPersonalCard(userID: numericID)
                let visitor = await makeVisitor(from: card, fallbackID: visitorID)
                remember(visitor: visitor)
                completion(.success(visitor))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func fetchVisitorShoreMoments(seersuckerStripe visitorID: String, completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyReefMoment]>) -> Void) {
        fetchVisitorMoments(visitorID: visitorID, completion: completion)
    }

    func fetchVisitorShellClips(seersuckerStripe visitorID: String, completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyShellClip]>) -> Void) {
        guard let numericID = Int64(visitorID) else {
            completion(.failure("Visitor clips are unavailable.", code: 400))
            return
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                let remoteClips = try await remoteClient.fetchIslandShortVideos(userID: numericID)
                let clips = await remoteClips.items.asyncMap { [weak self] row in
                    await self?.makeClip(from: row) ?? SuliJoyLagoonProfileRemoteMapper.emptyClip
                }
                remember(clips: clips)
                completion(.success(clips))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func fetchVisitorTideActivities(seersuckerStripe visitorID: String, completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyTideActivity]>) -> Void) {
        fetchIslandActivities(userID: Int64(visitorID), completion: completion)
    }

    func toggleLagoonVisitorFollow(seersuckerStripe visitorID: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyLagoonVisitor>) -> Void) {
        guard let numericID = Int64(visitorID) else {
            completion(.failure("Visitor profile is unavailable.", code: 400))
            return
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                let shouldFollow = !self.isLagoonFollowing(visitorID: visitorID)
                try await remoteClient.changeIslandFollow(userID: numericID, follow: shouldFollow)
                let card = try await remoteClient.fetchIslandPersonalCard(userID: numericID)
                let visitor = await makeVisitor(from: card, fallbackID: visitorID)
                remember(visitor: visitor)
                completion(.success(visitor))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func fetchLetterThreads(completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyLagoonLetterThread]>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let page = try await remoteClient.fetchLetterThreads()
                let threads = await page.items.asyncMap { row in
                    let portraitToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: row.avatarURL)
                    return SuliJoyLagoonLetterThread(
                        conversationID: row.conversationID,
                        peerID: row.userID,
                        peerName: row.displayName,
                        portraitToken: portraitToken,
                        preview: SuliJoyLagoonLetterCopy.preview(for: row.latest),
                        momentLine: SuliJoyLagoonLetterCopy.clock(milliseconds: row.latest?.createdAt ?? row.sortTime),
                        unread: row.unread,
                        blocked: row.blocked
                    )
                }
                completion(.success(threads))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func fetchLetterNotes(conversationID: String, completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyLagoonLetterNote]>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let page = try await remoteClient.fetchLetterHistory(conversationID: conversationID)
                let notes = page.items.map { SuliJoyLagoonLetterCopy.note(from: $0) }
                    .sorted { $0.createdAt < $1.createdAt }
                completion(.success(notes))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func sendLetter(conversationID: String, text: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyLagoonLetterNote>) -> Void) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            completion(.failure("Please enter a message.", code: 400))
            return
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                let sent = try await remoteClient.sendLetter(conversationID: conversationID, text: trimmed)
                completion(.success(SuliJoyLagoonLetterCopy.note(from: sent), note: "Sent."))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func openLetterThread(userID: String, fallbackName: String = "", completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyLagoonLetterThread>) -> Void) {
        guard Int64(userID) != nil else {
            completion(.failure("Messages are unavailable.", code: 400))
            return
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                let row = try await remoteClient.openLetterThread(userID: userID)
                let portraitToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: row.avatarURL)
                let thread = SuliJoyLagoonLetterThread(
                    conversationID: row.conversationID,
                    peerID: row.userID.isEmpty ? userID : row.userID,
                    peerName: row.displayName.isEmpty ? fallbackName : row.displayName,
                    portraitToken: portraitToken,
                    preview: "",
                    momentLine: "",
                    unread: 0,
                    blocked: row.blocked
                )
                completion(.success(thread))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func markLetterRead(conversationID: String) {
        Task { [weak self] in
            try? await self?.remoteClient.markLetterRead(conversationID: conversationID)
        }
    }

    func blockLagoonVisitor(seersuckerStripe visitorID: String, completion: @escaping (SuliJoySuiRequestEnvelope<Bool>) -> Void) {
        guard let numericID = Int64(visitorID) else {
            completion(.failure("Visitor profile is unavailable.", code: 400))
            return
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                try await remoteClient.blockIslandUser(userID: numericID)
                completion(.success(true))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func toggleMomentLike(sunwashedDenim momentID: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyReefMoment>) -> Void) {
        guard let numericID = Int64(momentID) else {
            completion(.failure("Moment is unavailable.", code: 400))
            return
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                let current = currentMoment(for: momentID)
                let nextLike = !(current?.isHearted ?? false)
                try await remoteClient.changeIslandMomentLike(momentID: numericID, liked: nextLike)
                guard var updated = current else {
                    completion(.failure("Moment is unavailable.", code: 404))
                    return
                }
                updated.isHearted = nextLike
                updated.heartTally = max(0, updated.heartTally + (nextLike ? 1 : -1))
                remember(moment: updated)
                completion(.success(updated))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func toggleWavePlayback(sunwashedDenim momentID: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyReefMoment>) -> Void) {
        guard var moment = currentMoment(for: momentID) else {
            completion(.failure("Moment is unavailable.", code: 404))
            return
        }
        moment.waveNote.isWaveRolling.toggle()
        remember(moment: moment)
        completion(.success(moment))
    }

    func blockMomentAuthor(sunwashedDenim momentID: String, completion: @escaping (SuliJoySuiRequestEnvelope<Bool>) -> Void) {
        guard let authorID = currentMoment(for: momentID)?.islandStylistMark, let numericID = Int64(authorID) else {
            completion(.failure("Moment author is unavailable.", code: 400))
            return
        }
        blockLagoonVisitor(seersuckerStripe: String(numericID), completion: completion)
    }

    func toggleShellClipLike(coconutCream clipID: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyShellClip>) -> Void) {
        guard let numericID = Int64(clipID) else {
            completion(.failure("Short video is unavailable.", code: 400))
            return
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                let current = currentClip(for: clipID)
                let nextLike = !(current?.driftwoodPalette ?? false)
                try await remoteClient.changeIslandShortVideoLike(videoID: numericID, liked: nextLike)
                guard var updated = current else {
                    completion(.failure("Short video is unavailable.", code: 404))
                    return
                }
                updated.driftwoodPalette = nextLike
                updated.ropeBelt = nextLike
                updated.palmLeafPattern = max(0, updated.palmLeafPattern + (nextLike ? 1 : -1))
                remember(clip: updated)
                completion(.success(updated))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func toggleShellClipFollow(coconutCream clipID: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyShellClip>) -> Void) {
        guard let clip = currentClip(for: clipID), let numericID = Int64(clip.terracottaWarmth.clipStylistMark) else {
            completion(.failure("Short video author is unavailable.", code: 400))
            return
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                let nextFollow = !clip.coastalChic
                try await remoteClient.changeIslandFollow(userID: numericID, follow: nextFollow)
                var updated = clip
                updated.coastalChic = nextFollow
                remember(clip: updated)
                completion(.success(updated))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func addShellClipComment(coconutCream clipID: String, reefReplyText: String, completion: @escaping (SuliJoySuiRequestEnvelope<SuliJoyShellClip>) -> Void) {
        guard let numericID = Int64(clipID), var clip = currentClip(for: clipID) else {
            completion(.failure("Short video is unavailable.", code: 400))
            return
        }
        let text = reefReplyText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else {
            completion(.failure("Please enter a comment.", code: 400))
            return
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                let result = try await remoteClient.createIslandShortVideoComment(videoID: numericID, content: text)
                let profile = try? await remoteClient.fetchCurrentIslandProfile()
                let alias = profile?.nickname ?? ""
                let avatarToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: profile?.icon ?? "")
                let reply = SuliJoyShellClipComment(
                    reefReplyMark: UUID().uuidString,
                    reefReplyAuthorAlias: alias,
                    reefReplyAvatarToken: avatarToken,
                    reefReplyText: text,
                    reefReplyMomentLine: "",
                    isReefFlagged: false
                )
                clip.sailorCollar.append(reply)
                clip.marineStripe = max(result.commentCount, clip.marineStripe + 1)
                remember(clip: clip)
                completion(.success(clip))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    func isLagoonFollowing(visitorID: String) -> Bool {
        guard !visitorID.isEmpty else { return false }
        shelfLock.lock()
        defer { shelfLock.unlock() }
        if followingMarks.contains(visitorID) {
            return true
        }
        if let visitor = visitorShelf[visitorID] {
            return visitor.suliJoyIslandEnsemble || visitor.coveAffinityState != .shorelineUnlinked
        }
        return false
    }

    func isLagoonFollowing(authorName: String) -> Bool {
        shelfLock.lock()
        defer { shelfLock.unlock() }
        if followingMarks.contains(where: { mark in
            visitorShelf[mark]?.islandStylistAlias == authorName
        }) {
            return true
        }
        return followingMarks.contains { mark in
            momentShelf[mark]?.islandStylistName == authorName
                || clipShelf[mark]?.terracottaWarmth.clipStylistAlias == authorName
        }
    }

    private func blockLagoonVisitorRemote(visitorID: String) async throws {
        guard let numericID = Int64(visitorID) else { throw SuliJoyLagoonRemoteError.invalidRequest }
        try await remoteClient.blockIslandUser(userID: numericID)
    }

    private func fetchVisitorMoments(visitorID: String, completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyReefMoment]>) -> Void) {
        guard let numericID = Int64(visitorID) else {
            completion(.failure("Visitor moments are unavailable.", code: 400))
            return
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                let remoteMoments = try await remoteClient.fetchIslandMoments(userID: numericID)
                let moments = await remoteMoments.rows.asyncMap { [weak self] row in
                    await self?.makeMoment(from: row) ?? SuliJoyLagoonProfileRemoteMapper.emptyMoment
                }
                remember(moments: moments)
                completion(.success(moments))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    private func uploadIslandResource(path: String, mimeType: String) async throws -> String {
        let fileURL = URL(fileURLWithPath: path)
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            throw SuliJoyLagoonRemoteError.invalidRequest
        }
        return try await remoteClient.uploadIslandResource(fileURL: fileURL, mimeType: mimeType)
    }

    private func combineActivityDate(day: Date, clock: Date) -> Date {
        let calendar = Calendar.current
        let dayComponents = calendar.dateComponents([.year, .month, .day], from: day)
        let clockComponents = calendar.dateComponents([.hour, .minute], from: clock)
        var combined = DateComponents()
        combined.year = dayComponents.year
        combined.month = dayComponents.month
        combined.day = dayComponents.day
        combined.hour = clockComponents.hour
        combined.minute = clockComponents.minute
        return calendar.date(from: combined) ?? day
    }

    private func mediaMimeType(for path: String) -> String {
        switch URL(fileURLWithPath: path).pathExtension.lowercased() {
        case "mp4": return "video/mp4"
        case "m4v": return "video/x-m4v"
        default: return "video/quicktime"
        }
    }

    private func makePublishedMoment(
        momentID: Int64,
        text: String,
        imageURLs: [String],
        audioURL: String?,
        audioDuration: Int
    ) async -> SuliJoyReefMoment {
        let profile = try? await remoteClient.fetchCurrentIslandProfile()
        let avatarToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: profile?.icon ?? "")
        let media = await imageURLs.enumerated().asyncMap { item in
            SuliJoyReefMedia(
                reefMediaStamp: "\(momentID)-\(item.offset)",
                reefMediaKind: .shoreSnapshot,
                reefAssetToken: await SuliJoyLagoonProfileAssetVault.shared.localToken(for: item.element),
                hibiscusShade: ""
            )
        }
        return SuliJoyReefMoment(
            reefMomentID: momentID == 0 ? UUID().uuidString : String(momentID),
            islandStylistName: profile?.nickname ?? "",
            islandStylistMark: profile.map { String($0.userID) } ?? "",
            islandStyleLine: "",
            islandStylistAvatarAssetName: avatarToken,
            tideAgoText: "just now",
            shoreSpotText: "",
            shoreTideText: "",
            islandCaptionText: text,
            reefMedia: media,
            waveNote: SuliJoyWaveSonicNote(
                waveNoteStamp: String(momentID),
                waveSeconds: audioDuration,
                waveStripeAssetToken: "",
                waveFileToken: audioURL ?? "",
                isWaveRolling: false,
                waveProgressRatio: 0
            ),
            heartTally: 0,
            reefReplyTally: 0,
            reefReplies: [],
            isHearted: false,
            reefFilter: .coastalPick,
            isTideHidden: false,
            isReefFlagged: false
        )
    }

    private func makePublishedClip(from result: SuliJoyLagoonRemoteShortVideoPublishResult) async -> SuliJoyShellClip {
        let profile = try? await remoteClient.fetchCurrentIslandProfile()
        let author = result.author
        let avatarToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: author?.icon ?? profile?.icon ?? "")
        let coverToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: result.coverURL)
        return SuliJoyShellClip(
            coconutCream: result.videoID,
            terracottaWarmth: SuliJoyLagoonClipCreator(
                clipStylistMark: author?.userID ?? profile.map { String($0.userID) } ?? "",
                clipStylistAlias: author?.nickname ?? profile?.nickname ?? "",
                clipPortraitToken: avatarToken
            ),
            hibiscusShade: result.caption,
            tropicalMotif: SuliJoyReefClipMedia(
                aquaGradient: result.videoURL,
                seafoamTint: "",
                sandyNeutral: coverToken
            ),
            palmLeafPattern: result.likeCount,
            marineStripe: result.commentCount,
            sailorCollar: [],
            ropeBelt: result.liked,
            driftwoodPalette: result.liked,
            coastalChic: result.followed,
            lagoonViewTotal: result.viewCount
        )
    }

    private func makeClipComments(from comments: [SuliJoyLagoonRemoteShortVideoComment]) async -> [SuliJoyShellClipComment] {
        await comments.asyncMap { comment in
            let avatarToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: comment.icon)
            return SuliJoyShellClipComment(
                reefReplyMark: comment.commentID,
                reefReplyAuthorAlias: comment.nickname,
                reefReplyAvatarToken: avatarToken,
                reefReplyText: comment.content,
                reefReplyMomentLine: comment.createdAt == 0 ? "" : String(comment.createdAt),
                isReefFlagged: false
            )
        }
    }

    private func fetchIslandActivities(userID: Int64?, completion: @escaping (SuliJoySuiRequestEnvelope<[SuliJoyTideActivity]>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let rooms = try await remoteClient.fetchIslandPartyRooms(userID: userID)
                let activities = await rooms.rows.asyncMap { await self.makeActivity(from: $0) }
                completion(.success(activities))
            } catch {
                completion(.failure(error.localizedDescription, code: error.suliJoyLagoonCode))
            }
        }
    }

    private func makeVisitor(from card: SuliJoyLagoonRemotePersonalCard, fallbackID: String) async -> SuliJoyLagoonVisitor {
        let portraitToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: card.icon)
        let affinity: SuliJoyCoveAffinityState
        if card.isBlocked {
            affinity = .shorelineUnlinked
        } else if card.isMutualFollow {
            affinity = .reefMutualBond
        } else if card.isFollowed {
            affinity = .islandAwaitingReturn
        } else {
            affinity = .shorelineUnlinked
        }
        return SuliJoyLagoonVisitor(
            lagoonGuestToken: fallbackID,
            islandStylistAlias: card.nickname,
            portraitAssetToken: portraitToken,
            shorelineHeartTotal: card.receivedLikeCount,
            reefFollowerTotal: card.followerCount,
            coveFollowingTotal: card.followingCount,
            coveAffinityState: affinity,
            suliJoyIslandEnsemble: card.isFollowed,
            suliJoyIslandIndex: card.isMutualFollow
        )
    }

    private func makeMoment(from row: SuliJoyLagoonRemoteMoment) async -> SuliJoyReefMoment {
        let avatarToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: row.icon)
        let media = await row.imageURLs.enumerated().asyncMap { item in
            let index = item.offset
            let imageURL = item.element
            return SuliJoyReefMedia(
                reefMediaStamp: "\(row.momentID)-\(index)",
                reefMediaKind: .shoreSnapshot,
                reefAssetToken: await SuliJoyLagoonProfileAssetVault.shared.localToken(for: imageURL),
                hibiscusShade: ""
            )
        }
        let waveNote = SuliJoyWaveSonicNote(
            waveNoteStamp: String(row.momentID),
            waveSeconds: row.audioDuration,
            waveStripeAssetToken: "",
            waveFileToken: row.audioURL,
            isWaveRolling: false,
            waveProgressRatio: 0
        )
        updateFollowingMark(String(row.userID), isFollowing: row.followFlag != 0 && row.userID != 0)
        return SuliJoyReefMoment(
            reefMomentID: String(row.momentID),
            islandStylistName: row.nickname,
            islandStylistMark: String(row.userID),
            islandStyleLine: "",
            islandStylistAvatarAssetName: avatarToken,
            tideAgoText: row.createTime,
            shoreSpotText: "",
            shoreTideText: row.createTime,
            islandCaptionText: row.textContent,
            reefMedia: media,
            waveNote: waveNote,
            heartTally: row.likeCount,
            reefReplyTally: row.commentCount,
            reefReplies: [],
            isHearted: row.likeFlag != 0,
            reefFilter: .coastalPick,
            isTideHidden: false,
            isReefFlagged: false
        )
    }

    private func makeClip(from row: SuliJoyLagoonRemoteShortVideo) async -> SuliJoyShellClip {
        let author = row.author
        let portraitToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: author?.icon ?? "")
        let clipCreator = SuliJoyLagoonClipCreator(
            clipStylistMark: author?.userID ?? "",
            clipStylistAlias: author?.nickname ?? "",
            clipPortraitToken: portraitToken
        )
        return SuliJoyShellClip(
            coconutCream: row.videoID,
            terracottaWarmth: clipCreator,
            hibiscusShade: row.caption,
            tropicalMotif: SuliJoyReefClipMedia(
                aquaGradient: row.videoURL,
                seafoamTint: "",
                sandyNeutral: await SuliJoyLagoonProfileAssetVault.shared.localToken(for: row.coverURL)
            ),
            palmLeafPattern: row.likeCount,
            marineStripe: row.commentCount,
            sailorCollar: [],
            ropeBelt: row.liked,
            driftwoodPalette: row.liked,
            coastalChic: row.followed,
            lagoonViewTotal: row.viewCount
        )
    }

    private func makeActivity(from room: SuliJoyLagoonRemotePartyRoom) async -> SuliJoyTideActivity {
        let avatarToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: room.roomAvatar)
        return SuliJoyTideActivity(
            tideMark: String(room.roomID),
            shoreDayText: room.createTime,
            sunMeridiemText: "",
            shoreClockText: "",
            tideScheduleLine: room.createTime,
            tideTitleLine: room.roomName,
            shoreHostAlias: String(room.ownerID),
            shoreSpotLine: room.countryCode,
            shoreSummaryLine: room.greetingMessage,
            tideFallbackHeroToken: avatarToken,
            shoreBriefLine: room.greetingMessage,
            relatedTideMarks: [],
            tideState: room.roomStatus == 1 ? .tideOpen : .tideClosed,
            isReefFlagged: false,
            tideJoinedTotal: room.heatValue,
            tideCrewLimit: 0,
            pearlNeed: 0,
            reefGallery: [],
            shorelineAvatarTokens: avatarToken.isEmpty ? [] : [avatarToken]
        )
    }

    private func makeVoiceCard(from room: SuliJoyLagoonRemotePartyRoom) async -> SuliJoyLagoonVoiceCard {
        let coverSource = room.scenicCover.isEmpty ? room.roomAvatar : room.scenicCover
        let coverToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: coverSource)
        let hostSource = room.roomAvatar.isEmpty ? (room.onlineFaces.first?.avatar ?? "") : room.roomAvatar
        let hostPortraitToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: hostSource)
        let faces = await room.onlineFaces.prefix(2).asyncMap { face in
            await SuliJoyLagoonProfileAssetVault.shared.localToken(for: face.avatar)
        }
        let place = room.countryCode.isEmpty ? "Island" : room.countryCode
        let hostName: String
        if !room.ownerName.isEmpty {
            hostName = room.ownerName
        } else if !room.roomName.isEmpty {
            hostName = room.roomName
        } else {
            hostName = place
        }
        let summary = room.greetingMessage.isEmpty ? "Say hi, chill out, and stay for the vibes." : room.greetingMessage
        return SuliJoyLagoonVoiceCard(
            roomID: String(room.roomID),
            place: place,
            hostName: hostName,
            hostPortraitToken: hostPortraitToken,
            coverToken: coverToken,
            heat: room.heatValue,
            audience: room.audienceNum,
            summary: summary,
            faceTokens: faces.filter { !$0.isEmpty }
        )
    }

    private func makeLiveCard(from room: SuliJoyLagoonRemoteLiveRoom) async -> SuliJoyLagoonLiveCard {
        let portraitToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: room.icon)
        let coverSource = room.coverURL.isEmpty ? room.icon : room.coverURL
        let coverToken = await SuliJoyLagoonProfileAssetVault.shared.localToken(for: coverSource)
        let title = room.nickname.isEmpty ? "Live host" : room.nickname
        let subtitle = room.liveTitle
        var viewerTokens = await room.viewerFaces.prefix(3).asyncMap { face in
            await SuliJoyLagoonProfileAssetVault.shared.localToken(for: face.avatar)
        }
        viewerTokens = viewerTokens.filter { !$0.isEmpty }
        let onlineCount = max(room.audienceCount, 0)
        if viewerTokens.isEmpty, onlineCount > 0, !portraitToken.isEmpty {
            viewerTokens = [portraitToken]
        }
        let heat = room.heatValue > 0 ? room.heatValue : max(onlineCount * 3, 24)
        return SuliJoyLagoonLiveCard(
            roomID: String(room.roomID),
            hostID: String(room.hostID),
            title: title,
            subtitle: subtitle,
            coverToken: coverToken,
            portraitToken: portraitToken.isEmpty ? coverToken : portraitToken,
            heat: heat,
            onlineCount: onlineCount,
            viewerPortraitTokens: viewerTokens,
            tagLabels: lagoonLiveTagLabels(roomID: room.roomID),
            category: room.category,
            followed: room.followed
        )
    }

    /// Two display tags from the fixed Go Live category labels.
    private func lagoonLiveTagLabels(roomID: Int64) -> [String] {
        lagoonLivePairedPublishTags(from: SuliJoyGoLiveCatalog.displayShoreCategories, roomID: max(roomID, 1))
    }

    private func lagoonLivePairedPublishTags(from pool: [String], roomID: Int64) -> [String] {
        let tags = pool.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        guard tags.count >= 2 else { return Array(tags.prefix(2)) }
        var seed = UInt64(bitPattern: roomID) ^ 0x9E37_79B9_7F4A_7C15
        func nextIndex(_ upper: Int) -> Int {
            seed = seed &* 2_862_933_555_777_941_757 &+ 3_037_000_493
            return Int(seed % UInt64(upper))
        }
        let first = nextIndex(tags.count)
        var second = nextIndex(tags.count - 1)
        if second >= first { second += 1 }
        let a = tags[first]
        let b = tags[second]
        if a.caseInsensitiveCompare(b) == .orderedSame, tags.count > 2 {
            let third = (second + 1) % tags.count
            return [a, tags[third]]
        }
        return [a, b]
    }

    private static func resolvePartyRoomLanguageCode(from languages: [SuliJoyLagoonRemotePartyLanguage]) -> String {
        if let english = languages.first(where: {
            $0.languageName.caseInsensitiveCompare(SuliJoyVoiceRoomCatalog.defaultLanguageName) == .orderedSame
        }), !english.languageCode.isEmpty {
            return english.languageCode
        }
        if let first = languages.first(where: { !$0.languageCode.isEmpty }) {
            return first.languageCode
        }
        return ""
    }

    private func finishBoard(_ work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }

    private func updateFollowingMark(_ mark: String, isFollowing: Bool) {
        shelfLock.lock()
        if isFollowing {
            followingMarks.insert(mark)
        } else {
            followingMarks.remove(mark)
        }
        shelfLock.unlock()
    }

    private func currentMoment(for momentID: String) -> SuliJoyReefMoment? {
        shelfLock.lock()
        defer { shelfLock.unlock() }
        return momentShelf[momentID]
    }

    private func currentClip(for clipID: String) -> SuliJoyShellClip? {
        shelfLock.lock()
        defer { shelfLock.unlock() }
        return clipShelf[clipID]
    }

    private func remember(visitor: SuliJoyLagoonVisitor) {
        shelfLock.lock()
        visitorShelf[visitor.lagoonGuestToken] = visitor
        let isFollowing = visitor.suliJoyIslandEnsemble || visitor.coveAffinityState != .shorelineUnlinked
        if isFollowing {
            followingMarks.insert(visitor.lagoonGuestToken)
        } else {
            followingMarks.remove(visitor.lagoonGuestToken)
        }
        shelfLock.unlock()
    }

    private func remember(moments: [SuliJoyReefMoment]) {
        shelfLock.lock()
        moments.forEach { momentShelf[$0.reefMomentID] = $0 }
        shelfLock.unlock()
    }

    private func remember(moment: SuliJoyReefMoment) {
        shelfLock.lock()
        momentShelf[moment.reefMomentID] = moment
        shelfLock.unlock()
    }

    private func remember(clips: [SuliJoyShellClip]) {
        shelfLock.lock()
        clips.forEach {
            clipShelf[$0.coconutCream] = $0
            if $0.coastalChic, !$0.terracottaWarmth.clipStylistMark.isEmpty {
                followingMarks.insert($0.terracottaWarmth.clipStylistMark)
            }
        }
        shelfLock.unlock()
    }

    private func remember(clip: SuliJoyShellClip) {
        shelfLock.lock()
        clipShelf[clip.coconutCream] = clip
        if clip.coastalChic, !clip.terracottaWarmth.clipStylistMark.isEmpty {
            followingMarks.insert(clip.terracottaWarmth.clipStylistMark)
        } else {
            followingMarks.remove(clip.terracottaWarmth.clipStylistMark)
        }
        shelfLock.unlock()
    }
}

private enum SuliJoyLagoonProfileRemoteMapper {
    static let emptyMoment = SuliJoyReefMoment(
        reefMomentID: "",
        islandStylistName: "",
        islandStylistMark: "",
        islandStyleLine: "",
        islandStylistAvatarAssetName: "",
        tideAgoText: "",
        shoreSpotText: "",
        shoreTideText: "",
        islandCaptionText: "",
        reefMedia: [],
        waveNote: SuliJoyWaveSonicNote(waveNoteStamp: "", waveSeconds: 0, waveStripeAssetToken: "", waveFileToken: "", isWaveRolling: false, waveProgressRatio: 0),
        heartTally: 0,
        reefReplyTally: 0,
        reefReplies: [],
        isHearted: false,
        reefFilter: .coastalPick,
        isTideHidden: false,
        isReefFlagged: false
    )

    static let emptyClip = SuliJoyShellClip(
        coconutCream: "",
        terracottaWarmth: SuliJoyLagoonClipCreator(clipStylistMark: "", clipStylistAlias: "", clipPortraitToken: ""),
        hibiscusShade: "",
        tropicalMotif: SuliJoyReefClipMedia(aquaGradient: "", seafoamTint: "", sandyNeutral: nil),
        palmLeafPattern: 0,
        marineStripe: 0,
        sailorCollar: [],
        ropeBelt: false,
        driftwoodPalette: false,
        coastalChic: false
    )
}

private actor SuliJoyLagoonProfileAssetVault {
    static let shared = SuliJoyLagoonProfileAssetVault()

    func localToken(for remoteToken: String) async -> String {
        if let cached = SuliJoyLagoonImageShelf.existingFilePath(for: remoteToken) {
            return cached
        }
        return remoteToken
    }
}

private extension Error {
    var suliJoyLagoonCode: Int {
        (self as? SuliJoyLagoonRemoteError)?.statusCode ?? 400
    }
}

private extension Sequence {
    func asyncMap<Output>(_ transform: @escaping (Element) async -> Output) async -> [Output] {
        var values: [Output] = []
        for element in self {
            values.append(await transform(element))
        }
        return values
    }

    func asyncThrowingMap<Output>(_ transform: @escaping (Element) async throws -> Output) async throws -> [Output] {
        var values: [Output] = []
        for element in self {
            values.append(try await transform(element))
        }
        return values
    }
}
