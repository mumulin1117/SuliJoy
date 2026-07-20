import Foundation

struct SuliJoySuiRequestEnvelope<T> {
    let code: Int
    let note: String
    let traceID: String
    let serverTime: Date
    let data: T?

    static func success(_ data: T?, note: String = "OK") -> SuliJoySuiRequestEnvelope<T> {
        wrapCoastalEnvelope(shorelineStatus: 200, islandNotice: note, reefPayload: data)
    }

    static func failure(_ note: String, code: Int = 400) -> SuliJoySuiRequestEnvelope<T> {
        wrapCoastalEnvelope(shorelineStatus: code, islandNotice: note, reefPayload: nil)
    }

    private static func wrapCoastalEnvelope(shorelineStatus: Int, islandNotice: String, reefPayload: T?) -> SuliJoySuiRequestEnvelope<T> {
        SuliJoySuiRequestEnvelope(
            code: shorelineStatus,
            note: islandNotice,
            traceID: makeCoastalTraceMark(),
            serverTime: Date(),
            data: reefPayload
        )
    }

    private static func makeCoastalTraceMark() -> String {
        "suli_trace_\(UUID().uuidString.prefix(8))"
    }
}

struct SuliJoyLagoonSession: Codable {
    private var reefEntryUnlocked: Bool
    private var lagoonPassphrase: String?
    private var islanderStamp: String?
    private var shoreMailMark: String?
    private var eulaShellConsent: Bool

    var isLoggedIn: Bool {
        get { reefEntryUnlocked }
        set { reefEntryUnlocked = newValue }
    }

    var token: String? {
        get { lagoonPassphrase }
        set { lagoonPassphrase = newValue }
    }

    var userID: String? {
        get { islanderStamp }
        set { islanderStamp = newValue }
    }

    var currentEmail: String? {
        get { shoreMailMark }
        set { shoreMailMark = newValue }
    }

    var hasAgreedEULA: Bool {
        get { eulaShellConsent }
        set { eulaShellConsent = newValue }
    }

    init(isLoggedIn: Bool, token: String?, userID: String?, currentEmail: String?, hasAgreedEULA: Bool) {
        self.reefEntryUnlocked = isLoggedIn
        self.lagoonPassphrase = token
        self.islanderStamp = userID
        self.shoreMailMark = currentEmail
        self.eulaShellConsent = hasAgreedEULA
    }

    private enum CodingKeys: String, CodingKey {
        case reefEntryUnlocked = "isLoggedIn"
        case lagoonPassphrase = "token"
        case islanderStamp = "userID"
        case shoreMailMark = "currentEmail"
        case eulaShellConsent = "hasAgreedEULA"
    }
}

struct SuliJoyIslandAccount: Codable, Equatable {
    private let islanderStamp: String
    private let shoreMailMark: String
    private let reefSecretPhrase: String
    private let tideArchiveDate: Date

    var accountID: String { islanderStamp }
    var email: String { shoreMailMark }
    var password: String { reefSecretPhrase }
    var registeredAt: Date { tideArchiveDate }

    init(accountID: String, email: String, password: String, registeredAt: Date) {
        self.islanderStamp = accountID
        self.shoreMailMark = email
        self.reefSecretPhrase = password
        self.tideArchiveDate = registeredAt
    }

    private enum CodingKeys: String, CodingKey {
        case islanderStamp = "accountID"
        case shoreMailMark = "email"
        case reefSecretPhrase = "password"
        case tideArchiveDate = "registeredAt"
    }
}

struct SuliJoyShoreProfile: Codable, Equatable {
    private let shorelineStamp: String
    private let shoreMailMark: String
    private var islandAlias: String
    private var portraitTrail: String?
    private var islandBioLine: String
    private var styleShellTags: [String]
    private let tideArchiveDate: Date

    var profileID: String { shorelineStamp }
    var email: String { shoreMailMark }
    var nickname: String {
        get { islandAlias }
        set { islandAlias = newValue }
    }
    var avatarPath: String? {
        get { portraitTrail }
        set { portraitTrail = newValue }
    }
    var bio: String {
        get { islandBioLine }
        set { islandBioLine = newValue }
    }
    var styleTags: [String] {
        get { styleShellTags }
        set { styleShellTags = newValue }
    }
    var createdAt: Date { tideArchiveDate }

    init(profileID: String, email: String, nickname: String, avatarPath: String?, bio: String, styleTags: [String], createdAt: Date) {
        self.shorelineStamp = profileID
        self.shoreMailMark = email
        self.islandAlias = nickname
        self.portraitTrail = avatarPath
        self.islandBioLine = bio
        self.styleShellTags = styleTags
        self.tideArchiveDate = createdAt
    }

    private enum CodingKeys: String, CodingKey {
        case shorelineStamp = "profileID"
        case shoreMailMark = "email"
        case islandAlias = "nickname"
        case portraitTrail = "avatarPath"
        case islandBioLine = "bio"
        case styleShellTags = "styleTags"
        case tideArchiveDate = "createdAt"
    }
}

struct SuliJoySignupDraft {
    private let islandAlias: String
    private let shoreMailMark: String
    private let reefSecretPhrase: String

    var name: String { islandAlias }
    var email: String { shoreMailMark }
    var password: String { reefSecretPhrase }

    init(name: String, email: String, password: String) {
        self.islandAlias = name
        self.shoreMailMark = email
        self.reefSecretPhrase = password
    }
}

enum SuliJoyCoveRequestMode {
    case reefBloom
    case quietShelf
    case stormDrift
}

enum SuliJoyReefMediaKind: String, Codable {
    case shoreSnapshot = "image"
    case reefMotion = "motion"
    case waveResonance = "audio"
}

enum SuliJoyTideActivityStatus: String, Codable {
    case tideOpen = "Open"
    case tideJoined = "Joined"
    case tideClosed = "Closed"
}

enum SuliJoyReefMomentFilter: String, CaseIterable, Codable {
    case coastalPick = "Recommend"
    case sunsetRush = "Hot"
    case lagoonCircle = "Followed"
}

struct SuliJoyReefMedia: Codable, Equatable {
    let reefMediaStamp: String
    let reefMediaKind: SuliJoyReefMediaKind
    let reefAssetToken: String
    let reefCaptionLine: String

    private enum CodingKeys: String, CodingKey {
        case reefMediaStamp = "mediaID"
        case reefMediaKind = "kind"
        case reefAssetToken = "assetName"
        case reefCaptionLine = "caption"
    }
}

struct SuliJoyWaveSonicNote: Codable, Equatable {
    let waveNoteStamp: String
    let waveSeconds: Int
    let waveStripeAssetToken: String
    let waveFileToken: String
    var isWaveRolling: Bool
    var waveProgressRatio: Float

    private enum CodingKeys: String, CodingKey {
        case waveNoteStamp = "noteID"
        case waveSeconds = "duration"
        case waveStripeAssetToken = "waveformAssetName"
        case waveFileToken = "sonicFileName"
        case isWaveRolling = "isPlaying"
        case waveProgressRatio = "progress"
    }
}

struct SuliJoyReefLocalMediaPick: Equatable {
    let reefSandboxPath: String
    let reefCaptionLine: String
}

struct SuliJoyWaveResonanceDraft: Equatable {
    let waveSandboxPath: String
    let waveSeconds: Int
    let waveCreatedAt: Date
}

struct SuliJoyShoreDraftMoment: Equatable {
    let islandCaptionLine: String
    let reefPicks: [SuliJoyReefLocalMediaPick]
    let waveDraft: SuliJoyWaveResonanceDraft?
}

struct SuliJoyReefEventPhotoPick: Codable, Equatable {
    let reefSandboxPath: String
    let reefCaptionLine: String

    private enum CodingKeys: String, CodingKey {
        case reefSandboxPath = "localPath"
        case reefCaptionLine = "caption"
    }
}

struct SuliJoyTideDraftActivity: Equatable {
    let tideTitleLine: String
    let tideStyleKind: String
    let wardrobeThemeLine: String
    let shoreBriefLine: String
    let tideDay: Date
    let tideClock: Date
    let shoreSpotLine: String
    let tideCrewLimit: Int
    let pearlNeed: Int
    let reefPhotoPicks: [SuliJoyReefEventPhotoPick]
}

struct SuliJoyTideActivity: Codable, Equatable {
    let tideMark: String
    let shoreDayText: String
    let sunMeridiemText: String
    let shoreClockText: String
    let tideScheduleLine: String
    let tideTitleLine: String
    let shoreHostAlias: String
    let shoreSpotLine: String
    let shoreSummaryLine: String
    let tideFallbackHeroToken: String
    let shoreBriefLine: String
    let relatedTideMarks: [String]
    var tideState: SuliJoyTideActivityStatus
    var isReefFlagged: Bool
    var tideJoinedTotal: Int
    let tideCrewLimit: Int
    let pearlNeed: Int
    let reefGallery: [SuliJoyReefMedia]
    let shorelineAvatarTokens: [String]

    private enum CodingKeys: String, CodingKey {
        case tideMark = "tideID"
        case shoreDayText = "dayText"
        case sunMeridiemText = "meridiem"
        case shoreClockText = "timeText"
        case tideScheduleLine = "shoreScheduleText"
        case tideTitleLine = "title"
        case shoreHostAlias = "shoreHostName"
        case shoreSpotLine = "shoreSpotText"
        case shoreSummaryLine = "summary"
        case tideFallbackHeroToken = "detailHeroAssetName"
        case shoreBriefLine = "shoreBrief"
        case relatedTideMarks = "relatedTideIDs"
        case tideState = "status"
        case isReefFlagged = "suliJoyIslandEnsemble"
        case tideJoinedTotal = "joinedCount"
        case tideCrewLimit = "capacity"
        case pearlNeed = "gemCost"
        case reefGallery = "media"
        case shorelineAvatarTokens = "avatarAssetNames"
    }
}

struct SuliJoyLagoonVoiceSeat: Equatable {
    let lagoonSeatMark: String
    var seatAliasLine: String
    var seatAvatarToken: String?
    var isTideHost: Bool
    var isCurrentIslander: Bool
    var isSeatOpen: Bool
}

struct SuliJoyShoreBubble: Equatable {
    let bubbleID: String
    let senderName: String
    let avatarAssetName: String?
    let text: String
    let waveCreatedAt: Date
    let isMine: Bool
}

struct SuliJoyTideTalkSpace: Equatable {
    let tideMark: String
    let tideTitleLine: String
    let shoreHostAlias: String
    let tropicBackdropToken: String
    let participantPortraitTokens: [String]
    var lagoonSeats: [SuliJoyLagoonVoiceSeat]
    var shoreBreezeBubbles: [SuliJoyShoreBubble]
}

enum SuliJoyCoralPearlLedgerKind: String, Codable {
    case joinedActivity
    case iapRecharge
}

struct SuliJoyCoralPearlLedger: Codable, Equatable {
    let ledgerID: String
    let reefMediaKind: SuliJoyCoralPearlLedgerKind
    let pearlDelta: Int
    let referenceID: String
    let waveCreatedAt: Date
}

struct SuliJoyShellWallet: Codable, Equatable {
    var shellPearlTotal: Int
    var coralLedgerTrail: [SuliJoyCoralPearlLedger]

    private enum CodingKeys: String, CodingKey {
        case shellPearlTotal = "pearlBalance"
        case coralLedgerTrail = "coralLedgers"
    }
}

struct SuliJoyLagoonClipCreator: Codable, Equatable {
    let clipStylistMark: String
    let clipStylistAlias: String
    let clipPortraitToken: String

    private enum CodingKeys: String, CodingKey {
        case clipStylistMark = "creatorID"
        case clipStylistAlias = "displayName"
        case clipPortraitToken = "avatarAssetName"
    }
}

struct SuliJoyReefClipMedia: Codable, Equatable {
    let mediaID: String
    let reefMotionFileName: String
    let fallbackCoverAssetName: String?
}

struct SuliJoyShellClipComment: Codable, Equatable {
    let reefReplyMark: String
    let reefReplyAuthorAlias: String
    let reefReplyAvatarToken: String
    let reefReplyText: String
    let reefReplyMomentLine: String
    var isReefFlagged: Bool

    private enum CodingKeys: String, CodingKey {
        case reefReplyMark = "commentID"
        case reefReplyAuthorAlias = "commenterName"
        case reefReplyAvatarToken = "commenterAvatarAssetName"
        case reefReplyText = "text"
        case reefReplyMomentLine = "timeAgo"
        case isReefFlagged = "suliJoyIslandEnsemble"
    }
}

struct SuliJoyShellClip: Codable, Equatable {
    let clipID: String
    var creator: SuliJoyLagoonClipCreator
    var reefCaptionLine: String
    var media: SuliJoyReefClipMedia
    var likeCount: Int
    var commentCount: Int
    var comments: [SuliJoyShellClipComment]
    var isLiked: Bool
    var isFollowed: Bool
    var isReportedLocally: Bool
}

enum SuliJoyShoreReportReason: String, CaseIterable, Codable {
    case fakePhoto = "Fake photo"
    case scamOrCommercial = "Scam or commercial"
    case notInterested = "Not interested"
    case other = "Other"
}

enum SuliJoyShoreReportTarget: Codable, Equatable {
    case moment(momentID: String)
    case shoreComment(momentID: String, commentID: String)
    case tideActivity(tideID: String)
    case shellClip(clipID: String)
    case shellClipComment(clipID: String, commentID: String)
    case lagoonVisitor(visitorID: String)
    case tideTalkSpace(tideID: String)

    private enum ShoreReportCoveKey: String, CodingKey {
        case kind
        case momentID
        case commentID
        case tideID
        case clipID
        case visitorID
    }

    private enum ShoreReportTideKind: String, Codable {
        case moment
        case shoreComment
        case tideActivity
        case shellClip
        case shellClipComment
        case lagoonVisitor
        case tideTalkSpace
    }

    init(from decoder: Decoder) throws {
        let reefBox = try decoder.container(keyedBy: ShoreReportCoveKey.self)
        let tideKind = try reefBox.decode(ShoreReportTideKind.self, forKey: .kind)
        switch tideKind {
        case .moment:
            self = .moment(momentID: try reefBox.decode(String.self, forKey: .momentID))
        case .shoreComment:
            self = .shoreComment(
                momentID: try reefBox.decode(String.self, forKey: .momentID),
                commentID: try reefBox.decode(String.self, forKey: .commentID)
            )
        case .tideActivity:
            self = .tideActivity(tideID: try reefBox.decode(String.self, forKey: .tideID))
        case .shellClip:
            self = .shellClip(clipID: try reefBox.decode(String.self, forKey: .clipID))
        case .shellClipComment:
            self = .shellClipComment(
                clipID: try reefBox.decode(String.self, forKey: .clipID),
                commentID: try reefBox.decode(String.self, forKey: .commentID)
            )
        case .lagoonVisitor:
            self = .lagoonVisitor(visitorID: try reefBox.decode(String.self, forKey: .visitorID))
        case .tideTalkSpace:
            self = .tideTalkSpace(tideID: try reefBox.decode(String.self, forKey: .tideID))
        }
    }

    func encode(to encoder: Encoder) throws {
        var reefBox = encoder.container(keyedBy: ShoreReportCoveKey.self)
        switch self {
        case .moment(let momentID):
            try reefBox.encode(ShoreReportTideKind.moment, forKey: .kind)
            try reefBox.encode(momentID, forKey: .momentID)
        case .shoreComment(let momentID, let commentID):
            try reefBox.encode(ShoreReportTideKind.shoreComment, forKey: .kind)
            try reefBox.encode(momentID, forKey: .momentID)
            try reefBox.encode(commentID, forKey: .commentID)
        case .tideActivity(let tideID):
            try reefBox.encode(ShoreReportTideKind.tideActivity, forKey: .kind)
            try reefBox.encode(tideID, forKey: .tideID)
        case .shellClip(let clipID):
            try reefBox.encode(ShoreReportTideKind.shellClip, forKey: .kind)
            try reefBox.encode(clipID, forKey: .clipID)
        case .shellClipComment(let clipID, let commentID):
            try reefBox.encode(ShoreReportTideKind.shellClipComment, forKey: .kind)
            try reefBox.encode(clipID, forKey: .clipID)
            try reefBox.encode(commentID, forKey: .commentID)
        case .lagoonVisitor(let visitorID):
            try reefBox.encode(ShoreReportTideKind.lagoonVisitor, forKey: .kind)
            try reefBox.encode(visitorID, forKey: .visitorID)
        case .tideTalkSpace(let tideID):
            try reefBox.encode(ShoreReportTideKind.tideTalkSpace, forKey: .kind)
            try reefBox.encode(tideID, forKey: .tideID)
        }
    }
}

struct SuliJoyShoreReportDraft: Codable, Equatable {
    let target: SuliJoyShoreReportTarget
    let reason: SuliJoyShoreReportReason
    let otherText: String?
    let waveCreatedAt: Date
}

struct SuliJoyLagoonClipMedia: Equatable {
    let reefMotionPath: String
    let coverImagePath: String?
    let waveSeconds: TimeInterval?
}

struct SuliJoyReefClipDraft: Equatable {
    let reefCaptionLine: String
    let media: SuliJoyLagoonClipMedia?
}

struct SuliJoyPearlAmountPack: Equatable {
    let packID: String
    let storeProductID: String
    let pearlAmount: Int
    let amountTextFallback: String
    var amountText: String

    static let localPacks: [SuliJoyPearlAmountPack] = [
        SuliJoyPearlAmountPack(packID: "sulijoy_pearl_200", storeProductID: "quznsqvspwkymdjk", pearlAmount: 200, amountTextFallback: "$0.99", amountText: "$0.99"),
        SuliJoyPearlAmountPack(packID: "sulijoy_pearl_600", storeProductID: "jxfqqgtppxczxtir", pearlAmount: 600, amountTextFallback: "$1.99", amountText: "$1.99"),
        SuliJoyPearlAmountPack(packID: "sulijoy_pearl_2250", storeProductID: "xzrknvrhgvvhqyfj", pearlAmount: 2250, amountTextFallback: "$4.99", amountText: "$4.99"),
        SuliJoyPearlAmountPack(packID: "sulijoy_pearl_5000", storeProductID: "bjvjxbzelbnnqtur", pearlAmount: 5000, amountTextFallback: "$9.99", amountText: "$9.99"),
        SuliJoyPearlAmountPack(packID: "sulijoy_pearl_10500", storeProductID: "wzinbusxjeymlaog", pearlAmount: 10500, amountTextFallback: "$19.99", amountText: "$19.99"),
        SuliJoyPearlAmountPack(packID: "sulijoy_pearl_27500", storeProductID: "tthnuiuwlwrnhbpv", pearlAmount: 27500, amountTextFallback: "$49.99", amountText: "$49.99"),
        SuliJoyPearlAmountPack(packID: "sulijoy_pearl_61700", storeProductID: "sevbpuwmdpkbkexe", pearlAmount: 61700, amountTextFallback: "$99.99", amountText: "$99.99")
    ]
}

struct SuliJoyLagoonStylist: Equatable {
    let stylistID: String
    let displayName: String
    let avatarAssetName: String
    let suliJoyCoastalModeration: Int
    let suliJoyCoastalChecklist: Int
    var suliJoyCoastalMeter: Bool = false
}

enum SuliJoyCoveFollowState: String, Codable, Equatable {
    case suliJoyCoastalAlbum
    case followingPending
    case suliJoyIslandInspiration
}

struct SuliJoyLagoonVisitor: Equatable {
    let visitorID: String
    let displayName: String
    let avatarAssetName: String
    let likeCount: Int
    let followerCount: Int
    let followingCount: Int
    let followState: SuliJoyCoveFollowState
    var suliJoyIslandEnsemble: Bool
    var suliJoyIslandIndex: Bool

    static func visitorID(for displayName: String) -> String {
        let normalized = displayName
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: "_")
        return "sulijoy_lagoon_visitor_\(normalized.isEmpty ? "shore_guest" : normalized)"
    }
}

struct SuliJoyVisitorShoreBundle: Equatable {
    let visitor: SuliJoyLagoonVisitor
    let moments: [SuliJoyReefMoment]
    let clips: [SuliJoyShellClip]
    let activities: [SuliJoyTideActivity]
}

enum SuliJoyMineCoveSection: String, CaseIterable {
    case feed = "Feed"
    case shorts = "Shorts"
    case events = "Events"
}

struct SuliJoyReefProfileTally: Equatable {
    let reefLabel: String
    let reefTotal: Int
}

struct SuliJoyLagoonProfileSnapshot: Equatable {
    let lagoonNameText: String
    let lagoonAvatarAssetName: String
    let islandTraceText: String
    let reefTallies: [SuliJoyReefProfileTally]
}

struct SuliJoyReefReply: Codable, Equatable {
    let reefReplyID: String
    let reefEchoName: String
    let reefEchoAvatarAssetName: String
    let reefPhraseText: String
    let tideAgoText: String

    enum CodingKeys: String, CodingKey {
        case reefReplyID = "commentID"
        case reefEchoName = "commenterName"
        case reefEchoAvatarAssetName = "commenterAvatarAssetName"
        case reefPhraseText = "text"
        case tideAgoText = "timeAgo"
    }
}

struct SuliJoyReefMoment: Codable, Equatable {
    let reefMomentID: String
    let islandStylistName: String
    let islandStylistMark: String
    let islandStyleLine: String
    let islandStylistAvatarAssetName: String
    let tideAgoText: String
    let shoreSpotText: String
    let shoreTideText: String
    let islandCaptionText: String
    let reefMedia: [SuliJoyReefMedia]
    var waveNote: SuliJoyWaveSonicNote
    var heartTally: Int
    var reefReplyTally: Int
    var reefReplies: [SuliJoyReefReply]
    var isHearted: Bool
    let reefFilter: SuliJoyReefMomentFilter
    var isTideHidden: Bool
    var isReefFlagged: Bool

    enum CodingKeys: String, CodingKey {
        case reefMomentID = "momentID"
        case islandStylistName = "authorName"
        case islandStylistMark = "authorHandle"
        case islandStyleLine = "authorStyleLine"
        case islandStylistAvatarAssetName = "authorAvatarAssetName"
        case tideAgoText = "timeAgo"
        case shoreSpotText = "shorePlaceText"
        case shoreTideText = "shoreTimeText"
        case islandCaptionText = "body"
        case reefMedia = "media"
        case waveNote = "audioNote"
        case heartTally = "likeCount"
        case reefReplyTally = "commentCount"
        case reefReplies = "comments"
        case isHearted = "isLiked"
        case reefFilter = "filter"
        case isTideHidden = "isBlocked"
        case isReefFlagged = "suliJoyIslandEnsemble"
    }
}
