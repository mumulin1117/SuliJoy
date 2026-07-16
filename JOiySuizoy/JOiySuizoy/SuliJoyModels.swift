import Foundation

struct SuliJoyLocalRequestEnvelope<T> {
    let code: Int
    let message: String
    let traceID: String
    let serverTime: Date
    let data: T?

    static func success(_ data: T?, message: String = "OK") -> SuliJoyLocalRequestEnvelope<T> {
        SuliJoyLocalRequestEnvelope(
            code: 200,
            message: message,
            traceID: "suli_trace_\(UUID().uuidString.prefix(8))",
            serverTime: Date(),
            data: data
        )
    }

    static func failure(_ message: String, code: Int = 400) -> SuliJoyLocalRequestEnvelope<T> {
        SuliJoyLocalRequestEnvelope(
            code: code,
            message: message,
            traceID: "suli_trace_\(UUID().uuidString.prefix(8))",
            serverTime: Date(),
            data: nil
        )
    }
}

struct SuliJoyLagoonSession: Codable {
    var isLoggedIn: Bool
    var token: String?
    var userID: String?
    var currentEmail: String?
    var hasAgreedEULA: Bool
}

struct SuliJoyIslandAccount: Codable, Equatable {
    let accountID: String
    let email: String
    let password: String
    let registeredAt: Date
}

struct SuliJoyShoreProfile: Codable, Equatable {
    let profileID: String
    let email: String
    var nickname: String
    var avatarPath: String?
    var bio: String
    var styleTags: [String]
    let createdAt: Date
}

struct SuliJoySignupDraft {
    let name: String
    let email: String
    let password: String
}

enum SuliJoyCoveRequestMode {
    case success
    case empty
    case failure
}

enum SuliJoyReefMediaKind: String, Codable {
    case image
    case video
    case audio
}

enum SuliJoyTideActivityStatus: String, Codable {
    case open = "Open"
    case joined = "Joined"
    case closed = "Closed"
}

enum SuliJoyShoreMomentFilter: String, CaseIterable, Codable {
    case recommend = "Recommend"
    case hot = "Hot"
    case followed = "Followed"
}

struct SuliJoyReefMedia: Codable, Equatable {
    let mediaID: String
    let kind: SuliJoyReefMediaKind
    let assetName: String
    let caption: String
}

struct SuliJoyWaveAudioNote: Codable, Equatable {
    let noteID: String
    let duration: Int
    let waveformAssetName: String
    let audioFileName: String
    var isPlaying: Bool
    var progress: Float
}

struct SuliJoyReefLocalMediaPick: Equatable {
    let localPath: String
    let caption: String
}

struct SuliJoyWaveRecordingDraft: Equatable {
    let localPath: String
    let duration: Int
    let createdAt: Date
}

struct SuliJoyShoreDraftMoment: Equatable {
    let body: String
    let mediaPicks: [SuliJoyReefLocalMediaPick]
    let audioDraft: SuliJoyWaveRecordingDraft?
}

struct SuliJoyReefEventPhotoPick: Codable, Equatable {
    let localPath: String
    let caption: String
}

struct SuliJoyTideDraftActivity: Equatable {
    let title: String
    let eventType: String
    let dressTheme: String
    let description: String
    let eventDate: Date
    let eventTime: Date
    let location: String
    let groupSize: Int
    let gemCost: Int
    let photoPicks: [SuliJoyReefEventPhotoPick]
}

struct SuliJoyTideActivity: Codable, Equatable {
    let tideID: String
    let dayText: String
    let meridiem: String
    let timeText: String
    let shoreScheduleText: String
    let title: String
    let shoreHostName: String
    let location: String
    let summary: String
    let detailHeroAssetName: String
    let shoreBrief: String
    let relatedTideIDs: [String]
    var status: SuliJoyTideActivityStatus
    var isReportedLocally: Bool
    var joinedCount: Int
    let capacity: Int
    let gemCost: Int
    let media: [SuliJoyReefMedia]
    let avatarAssetNames: [String]
}

struct SuliJoyLagoonVoiceSeat: Equatable {
    let seatID: String
    var displayName: String
    var avatarAssetName: String?
    var isOwner: Bool
    var isCurrentUser: Bool
    var isOpen: Bool
}

struct SuliJoyShoreChatBubble: Equatable {
    let bubbleID: String
    let senderName: String
    let avatarAssetName: String?
    let text: String
    let createdAt: Date
    let isMine: Bool
}

struct SuliJoyTideTalkSpace: Equatable {
    let tideID: String
    let tideTitle: String
    let hostName: String
    let backgroundAssetName: String
    let participantAvatarAssetNames: [String]
    var voiceSeats: [SuliJoyLagoonVoiceSeat]
    var chatBubbles: [SuliJoyShoreChatBubble]
}

enum SuliJoyCoralCoinLedgerKind: String, Codable {
    case joinedActivity
    case iapRecharge
}

struct SuliJoyCoralCoinLedger: Codable, Equatable {
    let ledgerID: String
    let kind: SuliJoyCoralCoinLedgerKind
    let coinDelta: Int
    let referenceID: String
    let createdAt: Date
}

struct SuliJoyShellWallet: Codable, Equatable {
    var coinBalance: Int
    var coralLedgers: [SuliJoyCoralCoinLedger]
}

struct SuliJoyLagoonClipCreator: Codable, Equatable {
    let creatorID: String
    let displayName: String
    let avatarAssetName: String
}

struct SuliJoyReefClipMedia: Codable, Equatable {
    let mediaID: String
    let localVideoFileName: String
    let fallbackCoverAssetName: String?
}

struct SuliJoyShellClipComment: Codable, Equatable {
    let commentID: String
    let commenterName: String
    let commenterAvatarAssetName: String
    let text: String
    let timeAgo: String
    var isReportedLocally: Bool
}

struct SuliJoyShellClip: Codable, Equatable {
    let clipID: String
    var creator: SuliJoyLagoonClipCreator
    var caption: String
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

    private enum CodingKeys: String, CodingKey {
        case kind
        case momentID
        case commentID
        case tideID
        case clipID
        case visitorID
    }

    private enum Kind: String, Codable {
        case moment
        case shoreComment
        case tideActivity
        case shellClip
        case shellClipComment
        case lagoonVisitor
        case tideTalkSpace
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let kind = try container.decode(Kind.self, forKey: .kind)
        switch kind {
        case .moment:
            self = .moment(momentID: try container.decode(String.self, forKey: .momentID))
        case .shoreComment:
            self = .shoreComment(
                momentID: try container.decode(String.self, forKey: .momentID),
                commentID: try container.decode(String.self, forKey: .commentID)
            )
        case .tideActivity:
            self = .tideActivity(tideID: try container.decode(String.self, forKey: .tideID))
        case .shellClip:
            self = .shellClip(clipID: try container.decode(String.self, forKey: .clipID))
        case .shellClipComment:
            self = .shellClipComment(
                clipID: try container.decode(String.self, forKey: .clipID),
                commentID: try container.decode(String.self, forKey: .commentID)
            )
        case .lagoonVisitor:
            self = .lagoonVisitor(visitorID: try container.decode(String.self, forKey: .visitorID))
        case .tideTalkSpace:
            self = .tideTalkSpace(tideID: try container.decode(String.self, forKey: .tideID))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .moment(let momentID):
            try container.encode(Kind.moment, forKey: .kind)
            try container.encode(momentID, forKey: .momentID)
        case .shoreComment(let momentID, let commentID):
            try container.encode(Kind.shoreComment, forKey: .kind)
            try container.encode(momentID, forKey: .momentID)
            try container.encode(commentID, forKey: .commentID)
        case .tideActivity(let tideID):
            try container.encode(Kind.tideActivity, forKey: .kind)
            try container.encode(tideID, forKey: .tideID)
        case .shellClip(let clipID):
            try container.encode(Kind.shellClip, forKey: .kind)
            try container.encode(clipID, forKey: .clipID)
        case .shellClipComment(let clipID, let commentID):
            try container.encode(Kind.shellClipComment, forKey: .kind)
            try container.encode(clipID, forKey: .clipID)
            try container.encode(commentID, forKey: .commentID)
        case .lagoonVisitor(let visitorID):
            try container.encode(Kind.lagoonVisitor, forKey: .kind)
            try container.encode(visitorID, forKey: .visitorID)
        case .tideTalkSpace(let tideID):
            try container.encode(Kind.tideTalkSpace, forKey: .kind)
            try container.encode(tideID, forKey: .tideID)
        }
    }
}

struct SuliJoyShoreReportDraft: Codable, Equatable {
    let target: SuliJoyShoreReportTarget
    let reason: SuliJoyShoreReportReason
    let otherText: String?
    let createdAt: Date
}

struct SuliJoyLagoonClipMedia: Equatable {
    let localVideoPath: String
    let coverImagePath: String?
    let duration: TimeInterval?
}

struct SuliJoyReefClipDraft: Equatable {
    let caption: String
    let media: SuliJoyLagoonClipMedia?
}

struct SuliJoyPearlCoinPack: Equatable {
    let packID: String
    let storeProductID: String
    let coinAmount: Int
    let displayPriceFallback: String
    var displayPrice: String

    static let localPacks: [SuliJoyPearlCoinPack] = [
        SuliJoyPearlCoinPack(packID: "sulijoy_pearl_200", storeProductID: "quznsqvspwkymdjk", coinAmount: 200, displayPriceFallback: "$0.99", displayPrice: "$0.99"),
        SuliJoyPearlCoinPack(packID: "sulijoy_pearl_600", storeProductID: "jxfqqgtppxczxtir", coinAmount: 600, displayPriceFallback: "$1.99", displayPrice: "$1.99"),
        SuliJoyPearlCoinPack(packID: "sulijoy_pearl_2250", storeProductID: "xzrknvrhgvvhqyfj", coinAmount: 2250, displayPriceFallback: "$4.99", displayPrice: "$4.99"),
        SuliJoyPearlCoinPack(packID: "sulijoy_pearl_5000", storeProductID: "bjvjxbzelbnnqtur", coinAmount: 5000, displayPriceFallback: "$9.99", displayPrice: "$9.99"),
        SuliJoyPearlCoinPack(packID: "sulijoy_pearl_10500", storeProductID: "wzinbusxjeymlaog", coinAmount: 10500, displayPriceFallback: "$19.99", displayPrice: "$19.99"),
        SuliJoyPearlCoinPack(packID: "sulijoy_pearl_27500", storeProductID: "tthnuiuwlwrnhbpv", coinAmount: 27500, displayPriceFallback: "$49.99", displayPrice: "$49.99"),
        SuliJoyPearlCoinPack(packID: "sulijoy_pearl_61700", storeProductID: "sevbpuwmdpkbkexe", coinAmount: 61700, displayPriceFallback: "$99.99", displayPrice: "$99.99")
    ]
}

struct SuliJoyLagoonStylist: Equatable {
    let stylistID: String
    let displayName: String
    let avatarAssetName: String
    let followingCount: Int
    let followerCount: Int
    var isFollowed: Bool = false
}

enum SuliJoyCoveFollowState: String, Codable, Equatable {
    case notFollowing
    case followingPending
    case mutualFollowing
}

struct SuliJoyLagoonVisitor: Equatable {
    let visitorID: String
    let displayName: String
    let avatarAssetName: String
    let likeCount: Int
    let followerCount: Int
    let followingCount: Int
    let followState: SuliJoyCoveFollowState
    var isReportedLocally: Bool
    var isBlockedLocally: Bool

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
    let moments: [SuliJoyShoreMoment]
    let clips: [SuliJoyShellClip]
    let activities: [SuliJoyTideActivity]
}

enum SuliJoyMineCoveSection: String, CaseIterable {
    case feed = "Feed"
    case shorts = "Shorts"
    case events = "Events"
}

struct SuliJoyShoreProfileMetric: Equatable {
    let title: String
    let value: Int
}

struct SuliJoyIslandProfileSummary: Equatable {
    let displayName: String
    let avatarAssetName: String
    let islandID: String
    let metrics: [SuliJoyShoreProfileMetric]
}

struct SuliJoyShoreComment: Codable, Equatable {
    let commentID: String
    let commenterName: String
    let commenterAvatarAssetName: String
    let text: String
    let timeAgo: String
}

struct SuliJoyShoreMoment: Codable, Equatable {
    let momentID: String
    let authorName: String
    let authorHandle: String
    let authorStyleLine: String
    let authorAvatarAssetName: String
    let timeAgo: String
    let shorePlaceText: String
    let shoreTimeText: String
    let body: String
    let media: [SuliJoyReefMedia]
    var audioNote: SuliJoyWaveAudioNote
    var likeCount: Int
    var commentCount: Int
    var comments: [SuliJoyShoreComment]
    var isLiked: Bool
    let filter: SuliJoyShoreMomentFilter
    var isBlocked: Bool
    var isReportedLocally: Bool
}
