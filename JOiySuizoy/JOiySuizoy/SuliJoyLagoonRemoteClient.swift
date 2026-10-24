import Foundation
import CommonCrypto

private enum SuliJoyLagoonRemoteDebugLogger {
    struct Trace {
        let id: Int
        let path: String
        let startedAt: Date
    }

    private static let gate = NSLock()
    private static var serial = 0
    private static let maximumTextLength = 240
    private static let maximumListCount = 12
    private static let maximumLogLength = 12_000

    static func begin(
        path: String,
        appID: String,
        deviceNo: String,
        appVersion: String,
        language: String,
        hasAuthorization: Bool,
        body: Data
    ) -> Trace {
        let trace = makeTrace(path: path)
        #if DEBUG
        print("""
        [SuliJoyRemote] #\(trace.id) → POST \(path)
        [SuliJoyRemote] #\(trace.id) headers appId=\(appID) deviceNo=\(deviceNo) appVersion=\(appVersion) language=\(language) authorization=\(hasAuthorization ? "present" : "absent")
        [SuliJoyRemote] #\(trace.id) body \(render(body))
        """)
        #endif
        return trace
    }

    static func beginUpload(
        path: String,
        appID: String,
        deviceNo: String,
        appVersion: String,
        language: String,
        hasAuthorization: Bool,
        fileName: String,
        mimeType: String,
        byteCount: Int
    ) -> Trace {
        let trace = makeTrace(path: path)
        #if DEBUG
        print("""
        [SuliJoyRemote] #\(trace.id) → POST \(path)
        [SuliJoyRemote] #\(trace.id) headers appId=\(appID) deviceNo=\(deviceNo) appVersion=\(appVersion) language=\(language) authorization=\(hasAuthorization ? "present" : "absent")
        [SuliJoyRemote] #\(trace.id) upload file=\(fileName) mimeType=\(mimeType) bytes=\(byteCount)
        """)
        #endif
        return trace
    }

    static func finish(
        _ trace: Trace,
        status: Int,
        code: String,
        message: String,
        requestID: String?,
        payload: Data?
    ) {
        #if DEBUG
        let result = payload.map { "\n[SuliJoyRemote] #\(trace.id) result \(render($0))" } ?? ""
        print("""
        [SuliJoyRemote] #\(trace.id) ← \(elapsed(trace))ms http=\(status) code=\(code) message=\(message) requestId=\(display(requestID))\(result)
        """)
        #endif
    }

    static func fail(
        _ trace: Trace,
        status: Int?,
        code: String,
        message: String,
        requestID: String?
    ) {
        #if DEBUG
        let httpStatus = status.map(String.init) ?? "-"
        print("[SuliJoyRemote] #\(trace.id) ← \(elapsed(trace))ms http=\(httpStatus) code=\(code) message=\(message) requestId=\(display(requestID))")
        #endif
    }

    static func decodeFailure(_ trace: Trace, error: Error) {
        #if DEBUG
        print("[SuliJoyRemote] #\(trace.id) decode failed: \(describe(error))")
        #endif
    }

    private static func makeTrace(path: String) -> Trace {
        gate.lock()
        serial += 1
        let id = serial
        gate.unlock()
        return Trace(id: id, path: path, startedAt: Date())
    }

    private static func elapsed(_ trace: Trace) -> Int {
        Int(Date().timeIntervalSince(trace.startedAt) * 1000)
    }

    private static func display(_ requestID: String?) -> String {
        guard let requestID, !requestID.isEmpty else { return "-" }
        return requestID
    }

    private static func describe(_ error: Error) -> String {
        guard let decoding = error as? DecodingError else { return error.localizedDescription }
        switch decoding {
        case .keyNotFound(let key, let context):
            return "missing \(key.stringValue) at \(path(context.codingPath))"
        case .typeMismatch(let type, let context):
            return "expected \(type) at \(path(context.codingPath))"
        case .valueNotFound(let type, let context):
            return "null \(type) at \(path(context.codingPath))"
        case .dataCorrupted(let context):
            return "corrupted at \(path(context.codingPath)): \(context.debugDescription)"
        @unknown default:
            return decoding.localizedDescription
        }
    }

    private static func path(_ codingPath: [CodingKey]) -> String {
        let joined = codingPath.map(\.stringValue).joined(separator: ".")
        return joined.isEmpty ? "<root>" : joined
    }

    private static func render(_ data: Data) -> String {
        guard !data.isEmpty else { return "{}" }
        guard let object = try? JSONSerialization.jsonObject(with: data),
              let sanitized = sanitize(object),
              JSONSerialization.isValidJSONObject(sanitized),
              let json = try? JSONSerialization.data(withJSONObject: sanitized, options: [.prettyPrinted, .sortedKeys]),
              var text = String(data: json, encoding: .utf8) else {
            return "<non-json \(data.count) bytes>"
        }
        if text.count > maximumLogLength {
            text = String(text.prefix(maximumLogLength)) + "\n… truncated"
        }
        return text
    }

    private static func sanitize(_ value: Any, key: String? = nil) -> Any? {
        if let key, isSecret(key) {
            return "<redacted>"
        }
        if let dictionary = value as? [String: Any] {
            return dictionary.reduce(into: [String: Any]()) { result, entry in
                result[entry.key] = sanitize(entry.value, key: entry.key) ?? NSNull()
            }
        }
        if let array = value as? [Any] {
            let visible = array.prefix(maximumListCount).compactMap { sanitize($0) }
            if array.count > maximumListCount {
                return visible + ["… \(array.count - maximumListCount) more"]
            }
            return visible
        }
        if let text = value as? String, text.count > maximumTextLength {
            return String(text.prefix(maximumTextLength)) + "…(\(text.count) chars)"
        }
        if value is NSNull || value is String || value is NSNumber {
            return value
        }
        return String(describing: value)
    }

    private static func isSecret(_ key: String) -> Bool {
        let name = key.lowercased().replacingOccurrences(of: "_", with: "")
        if name == "tokentype" { return false }
        if name.contains("password") || name.contains("token") || name == "authorization" { return true }
        return name == "encryptionkey" || name == "encryptioniv"
    }
}

struct SuliJoyLagoonRemotePhoto: Decodable {
    let photoURL: String

    private enum CodingKeys: String, CodingKey {
        case photoURL = "photoUrl"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        photoURL = container.suliJoyText(forKey: .photoURL)
    }
}

struct SuliJoyLagoonRemoteUserInfo: Decodable {
    let userID: Int64
    let nickname: String
    let icon: String
    let signature: String
    let friendCount: Int
    let followerCount: Int
    let followingCount: Int
    let diamondBalance: Int
    let receivedLikeCount: Int
    let videoCount: Int
    let videoLikeCount: Int
    let photoList: [SuliJoyLagoonRemotePhoto]

    private enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname
        case icon
        case signature
        case friendCount = "friendNum"
        case followerCount = "fansNum"
        case followingCount = "upsNum"
        case diamondBalance = "diamondNum"
        case receivedLikeCount
        case videoCount
        case videoLikeCount
        case photoList
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userID = container.suliJoyInt64(forKey: .userID)
        nickname = container.suliJoyText(forKey: .nickname)
        icon = container.suliJoyText(forKey: .icon)
        signature = container.suliJoyText(forKey: .signature)
        friendCount = container.suliJoyInt(forKey: .friendCount)
        followerCount = container.suliJoyInt(forKey: .followerCount)
        followingCount = container.suliJoyInt(forKey: .followingCount)
        diamondBalance = container.suliJoyInt(forKey: .diamondBalance)
        receivedLikeCount = container.suliJoyInt(forKey: .receivedLikeCount)
        videoCount = container.suliJoyInt(forKey: .videoCount)
        videoLikeCount = container.suliJoyInt(forKey: .videoLikeCount)
        photoList = (try? container.decode([SuliJoyLagoonRemotePhoto].self, forKey: .photoList)) ?? []
    }
}

struct SuliJoyLagoonRemotePersonalCard: Decodable {
    let userID: Int64
    let nickname: String
    let icon: String
    let signature: String
    let followerCount: Int
    let followingCount: Int
    let receivedLikeCount: Int
    let videoCount: Int
    let videoLikeCount: Int
    let isFollowed: Bool
    let isMutualFollow: Bool
    let isBlocked: Bool
    let photoList: [SuliJoyLagoonRemotePhoto]

    private enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname = "nickName"
        case icon
        case signature
        case followerCount = "fans"
        case followingCount = "follow"
        case receivedLikeCount
        case videoCount
        case videoLikeCount
        case isFollowed = "isFollow"
        case isMutualFollow
        case isBlocked
        case photoList
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userID = container.suliJoyInt64(forKey: .userID)
        nickname = container.suliJoyText(forKey: .nickname)
        icon = container.suliJoyText(forKey: .icon)
        signature = container.suliJoyText(forKey: .signature)
        followerCount = container.suliJoyInt(forKey: .followerCount)
        followingCount = container.suliJoyInt(forKey: .followingCount)
        receivedLikeCount = container.suliJoyInt(forKey: .receivedLikeCount)
        videoCount = container.suliJoyInt(forKey: .videoCount)
        videoLikeCount = container.suliJoyInt(forKey: .videoLikeCount)
        isFollowed = container.suliJoyBool(forKey: .isFollowed)
        isMutualFollow = container.suliJoyBool(forKey: .isMutualFollow)
        isBlocked = container.suliJoyBoolOrInt(forKey: .isBlocked)
        photoList = (try? container.decode([SuliJoyLagoonRemotePhoto].self, forKey: .photoList)) ?? []
    }
}

struct SuliJoyLagoonRemoteMoment: Decodable {
    let momentID: Int64
    let textContent: String
    let nickname: String
    let icon: String
    let userID: Int64
    let imageURLs: [String]
    let audioURL: String
    let audioDuration: Int
    let likeFlag: Int
    let likeCount: Int
    let followFlag: Int
    let createTime: String
    let commentCount: Int

    private enum CodingKeys: String, CodingKey {
        case momentID = "id"
        case textContent
        case nickname
        case icon
        case userID = "userId"
        case imageURLs = "imgUrls"
        case audioURL = "audioUrl"
        case audioDuration
        case likeFlag
        case likeCount = "likeNum"
        case followFlag
        case createTime
        case commentCount = "commentNum"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        momentID = container.suliJoyInt64(forKey: .momentID)
        textContent = container.suliJoyText(forKey: .textContent)
        nickname = container.suliJoyText(forKey: .nickname)
        icon = container.suliJoyText(forKey: .icon)
        userID = container.suliJoyInt64(forKey: .userID)
        imageURLs = (try? container.decode([String].self, forKey: .imageURLs)) ?? []
        audioURL = container.suliJoyText(forKey: .audioURL)
        audioDuration = container.suliJoyInt(forKey: .audioDuration)
        likeFlag = container.suliJoyInt(forKey: .likeFlag)
        likeCount = container.suliJoyInt(forKey: .likeCount)
        followFlag = container.suliJoyInt(forKey: .followFlag)
        createTime = container.suliJoyText(forKey: .createTime)
        commentCount = container.suliJoyInt(forKey: .commentCount)
    }
}

struct SuliJoyLagoonRemoteMomentList: Decodable {
    let rows: [SuliJoyLagoonRemoteMoment]

    private enum CodingKeys: String, CodingKey {
        case list
    }

    private struct RowList: Decodable {
        let rows: [SuliJoyLagoonRemoteMoment]
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = (try? container.decode(RowList.self, forKey: .list).rows) ?? []
    }
}

struct SuliJoyLagoonRemoteMomentComment: Decodable {
    let commentID: Int64
    let nickname: String
    let icon: String
    let content: String
    let createTime: String

    private enum CodingKeys: String, CodingKey {
        case commentID = "id"
        case nickname
        case icon
        case content = "commentContent"
        case createTime
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        commentID = container.suliJoyInt64(forKey: .commentID)
        nickname = container.suliJoyText(forKey: .nickname)
        icon = container.suliJoyText(forKey: .icon)
        content = container.suliJoyText(forKey: .content)
        createTime = container.suliJoyText(forKey: .createTime)
    }
}

struct SuliJoyLagoonRemoteMomentCommentList: Decodable {
    let rows: [SuliJoyLagoonRemoteMomentComment]

    private enum CodingKeys: String, CodingKey {
        case rows
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = (try? container.decode([SuliJoyLagoonRemoteMomentComment].self, forKey: .rows)) ?? []
    }
}

struct SuliJoyLagoonRemoteMomentCommentResult: Decodable {
    let success: Bool
    let commentID: Int64
    let commentCount: Int

    private enum CodingKeys: String, CodingKey {
        case success
        case commentID = "commentId"
        case commentCount = "commentNum"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = container.suliJoyBool(forKey: .success)
        commentID = container.suliJoyInt64(forKey: .commentID)
        commentCount = container.suliJoyInt(forKey: .commentCount)
    }
}

struct SuliJoyLagoonRemoteMomentPublishResult: Decodable {
    let published: Bool
    let momentID: Int64
    let validImageURLs: [String]
    let message: String

    private enum CodingKeys: String, CodingKey {
        case published
        case momentID = "friendsCircleId"
        case validImageURLs = "validImgUrls"
        case message
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        published = container.suliJoyBool(forKey: .published)
        momentID = container.suliJoyInt64(forKey: .momentID)
        validImageURLs = (try? container.decode([String].self, forKey: .validImageURLs)) ?? []
        message = container.suliJoyText(forKey: .message)
    }
}

struct SuliJoyLagoonRemoteShortVideoAuthor: Decodable {
    let userID: String
    let nickname: String
    let icon: String

    private enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname
        case icon
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userID = container.suliJoyText(forKey: .userID)
        nickname = container.suliJoyText(forKey: .nickname)
        icon = container.suliJoyText(forKey: .icon)
    }
}

struct SuliJoyLagoonRemoteShortVideo: Decodable {
    let videoID: String
    let caption: String
    let videoURL: String
    let coverURL: String
    let durationSeconds: Int
    let likeCount: Int
    let commentCount: Int
    let liked: Bool
    let followed: Bool
    let viewCount: Int
    let createdAt: Int64
    let author: SuliJoyLagoonRemoteShortVideoAuthor?

    private enum CodingKeys: String, CodingKey {
        case videoID = "videoId"
        case caption
        case videoURL = "videoUrl"
        case coverURL = "coverUrl"
        case durationSeconds
        case likeCount
        case commentCount
        case liked
        case followed
        case viewCount
        case createdAt
        case author
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        videoID = container.suliJoyText(forKey: .videoID)
        caption = container.suliJoyText(forKey: .caption)
        videoURL = container.suliJoyText(forKey: .videoURL)
        coverURL = container.suliJoyText(forKey: .coverURL)
        durationSeconds = container.suliJoyInt(forKey: .durationSeconds)
        likeCount = container.suliJoyInt(forKey: .likeCount)
        commentCount = container.suliJoyInt(forKey: .commentCount)
        liked = container.suliJoyBool(forKey: .liked)
        followed = container.suliJoyBool(forKey: .followed)
        viewCount = container.suliJoyInt(forKey: .viewCount)
        createdAt = container.suliJoyInt64(forKey: .createdAt)
        author = try? container.decode(SuliJoyLagoonRemoteShortVideoAuthor.self, forKey: .author)
    }
}

struct SuliJoyLagoonRemoteShortVideoList: Decodable {
    let items: [SuliJoyLagoonRemoteShortVideo]

    private enum CodingKeys: String, CodingKey {
        case items
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = (try? container.decode([SuliJoyLagoonRemoteShortVideo].self, forKey: .items)) ?? []
    }
}

struct SuliJoyLagoonRemotePartyRoom: Decodable {
    let roomID: Int64
    let ownerID: Int64
    let roomName: String
    let roomAvatar: String
    let greetingMessage: String
    let countryCode: String
    let heatValue: Int
    let roomStatus: Int
    let createTime: String
    let ownerName: String
    let yxRoomId: String
    let roomTempId: Int64
    let audienceNum: Int
    let roomSeatList: [SuliJoyLagoonRemoteVoiceSeat]
    let onlineFaces: [SuliJoyLagoonRemoteOnlineFace]
    let scenicCover: String

    private enum CodingKeys: String, CodingKey {
        case roomID = "id"
        case ownerID = "ownerId"
        case roomName
        case roomAvatar
        case greetingMessage
        case countryCode
        case heatValue
        case roomStatus
        case createTime
        case ownerName, yxRoomId, roomTempId, audienceNum, roomSeatList
        case onlineFaces = "onlineUserList"
        case scenicCover = "bigImgUrl"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        roomID = container.suliJoyInt64(forKey: .roomID)
        ownerID = container.suliJoyInt64(forKey: .ownerID)
        roomName = container.suliJoyText(forKey: .roomName)
        roomAvatar = container.suliJoyText(forKey: .roomAvatar)
        greetingMessage = container.suliJoyText(forKey: .greetingMessage)
        countryCode = container.suliJoyText(forKey: .countryCode)
        heatValue = container.suliJoyInt(forKey: .heatValue)
        roomStatus = container.suliJoyInt(forKey: .roomStatus)
        createTime = container.suliJoyText(forKey: .createTime)
        ownerName = container.suliJoyText(forKey: .ownerName)
        yxRoomId = container.suliJoyText(forKey: .yxRoomId)
        roomTempId = container.suliJoyInt64(forKey: .roomTempId)
        audienceNum = container.suliJoyInt(forKey: .audienceNum)
        roomSeatList = try container.decodeIfPresent([SuliJoyLagoonRemoteVoiceSeat].self, forKey: .roomSeatList) ?? []
        onlineFaces = (try? container.decode([SuliJoyLagoonRemoteOnlineFace].self, forKey: .onlineFaces)) ?? []
        scenicCover = container.suliJoyText(forKey: .scenicCover)
        guard roomID > 0 else { throw SuliJoyLagoonRemoteError.invalidRequest }
    }
}

struct SuliJoyLagoonRemoteLiveCategoryChoice: Decodable, Equatable {
    /// Passed as `category` on `host/prepare`.
    let submitValue: String
    let displayTitle: String

    init(submitValue: String, displayTitle: String) {
        self.submitValue = submitValue
        self.displayTitle = displayTitle
    }

    init(from decoder: Decoder) throws {
        if let single = try? decoder.singleValueContainer(),
           let text = try? single.decode(String.self) {
            let line = text.trimmingCharacters(in: .whitespacesAndNewlines)
            submitValue = line
            displayTitle = line
            return
        }
        let container = try decoder.container(keyedBy: SuliJoyLagoonRemoteFlexibleKey.self)
        let submit = container.suliJoyFlexibleText(
            "category", "categoryCode", "code", "value", "name", "tag", "tagCode"
        )
        let display = container.suliJoyFlexibleText(
            "categoryName", "name", "label", "title", "text", "tagName"
        )
        if !submit.isEmpty {
            submitValue = submit
            displayTitle = display.isEmpty ? submit : display
        } else {
            let line = display.trimmingCharacters(in: .whitespacesAndNewlines)
            submitValue = line
            displayTitle = line
        }
    }
}

struct SuliJoyLagoonRemoteLiveHostOptions: Decodable {
    let categoryChoices: [SuliJoyLagoonRemoteLiveCategoryChoice]
    let liveTypes: [SuliJoyLagoonRemoteLiveTypeChoice]
    let locales: [SuliJoyLagoonRemoteLiveLocaleChoice]
    let contentReminderText: String

    var categories: [String] { categoryChoices.map(\.submitValue) }

    private enum CodingKeys: String, CodingKey {
        case liveTypes
        case locales
        case contentReminder
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        categoryChoices = Self.decodeCategoryChoices(from: decoder)
        liveTypes = (try? container.decode([SuliJoyLagoonRemoteLiveTypeChoice].self, forKey: .liveTypes)) ?? []
        locales = (try? container.decode([SuliJoyLagoonRemoteLiveLocaleChoice].self, forKey: .locales)) ?? []
        if let reminder = try? container.decode(SuliJoyLagoonRemoteLiveContentReminder.self, forKey: .contentReminder) {
            contentReminderText = reminder.text
        } else {
            contentReminderText = ""
        }
    }

    private static func decodeCategoryChoices(from decoder: Decoder) -> [SuliJoyLagoonRemoteLiveCategoryChoice] {
        guard let container = try? decoder.container(keyedBy: SuliJoyLagoonRemoteFlexibleKey.self) else {
            return []
        }
        for key in ["categories", "categoryList", "liveCategories", "categoryConfigList", "tags", "roomTags"] {
            guard let codingKey = SuliJoyLagoonRemoteFlexibleKey(stringValue: key) else { continue }
            if let raw = try? container.decode([SuliJoyLagoonRemoteLiveCategoryChoice].self, forKey: codingKey) {
                let cleaned = raw.filter { !$0.submitValue.isEmpty || !$0.displayTitle.isEmpty }
                if !cleaned.isEmpty { return cleaned }
            }
        }
        return []
    }
}

struct SuliJoyLagoonRemoteLiveContentReminder: Decodable {
    let text: String

    private enum CodingKeys: String, CodingKey {
        case text
        case message
        case content
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var line = container.suliJoyText(forKey: .text)
        if line.isEmpty { line = container.suliJoyText(forKey: .message) }
        if line.isEmpty { line = container.suliJoyText(forKey: .content) }
        text = line
    }
}

struct SuliJoyLagoonRemoteLiveTypeChoice: Decodable {
    let code: String
    let title: String

    init(from decoder: Decoder) throws {
        if let single = try? decoder.singleValueContainer(), let value = try? single.decode(String.self) {
            code = value
            title = value
            return
        }
        let container = try decoder.container(keyedBy: SuliJoyLagoonRemoteFlexibleKey.self)
        let parsedCode = container.suliJoyFlexibleText("code", "liveType", "value", "id", "type")
        var parsedTitle = container.suliJoyFlexibleText("name", "label", "title", "text")
        if parsedTitle.isEmpty { parsedTitle = parsedCode }
        code = parsedCode
        title = parsedTitle
    }
}

struct SuliJoyLagoonRemoteLiveLocaleChoice: Decodable {
    let languageName: String
    let countryCode: String

    private enum CodingKeys: String, CodingKey {
        case languageName
        case name
        case countries
        case countryCode
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var language = container.suliJoyText(forKey: .languageName)
        if language.isEmpty { language = container.suliJoyText(forKey: .name) }
        languageName = language
        if let countries = try? container.decode([SuliJoyLagoonRemoteLiveCountryChoice].self, forKey: .countries),
           let first = countries.first(where: { !$0.countryCode.isEmpty }) {
            countryCode = first.countryCode
        } else {
            countryCode = container.suliJoyText(forKey: .countryCode)
        }
    }
}

struct SuliJoyLagoonRemoteLiveCountryChoice: Decodable {
    let countryCode: String

    private enum CodingKeys: String, CodingKey {
        case countryCode
        case code
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var code = container.suliJoyText(forKey: .countryCode)
        if code.isEmpty { code = container.suliJoyText(forKey: .code) }
        countryCode = code
    }
}

struct SuliJoyLagoonRemoteLiveHostSession: Decodable {
    let roomID: Int64
    let sessionID: Int64
    let channelID: String
    let liveTitle: String
    let coverURL: String
    let status: String

    private enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case sessionID = "sessionId"
        case channelID = "channelId"
        case liveTitle
        case coverURL = "coverUrl"
        case status
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        roomID = container.suliJoyInt64(forKey: .roomID)
        sessionID = container.suliJoyInt64(forKey: .sessionID)
        channelID = container.suliJoyText(forKey: .channelID)
        liveTitle = container.suliJoyText(forKey: .liveTitle)
        coverURL = container.suliJoyText(forKey: .coverURL)
        status = container.suliJoyText(forKey: .status)
        guard roomID > 0 else { throw SuliJoyLagoonRemoteError.invalidResponse }
    }
}

struct SuliJoyLagoonRemotePartyRoomTagChoice: Decodable, Equatable {
    /// Value accepted by `party/room/create` when the backend enables tag submission.
    let submitValue: String
    let displayTitle: String

    init(submitValue: String, displayTitle: String) {
        self.submitValue = submitValue
        self.displayTitle = displayTitle
    }

    init(from decoder: Decoder) throws {
        if let single = try? decoder.singleValueContainer(),
           let text = try? single.decode(String.self) {
            let line = text.trimmingCharacters(in: .whitespacesAndNewlines)
            submitValue = line
            displayTitle = line
            return
        }
        let container = try decoder.container(keyedBy: SuliJoyLagoonRemoteFlexibleKey.self)
        let submit = container.suliJoyFlexibleText(
            "tag", "tagCode", "code", "value", "roomTag", "roomTagCode", "id"
        )
        let display = container.suliJoyFlexibleText(
            "tagName", "name", "label", "title", "roomTagName", "text"
        )
        if !submit.isEmpty {
            submitValue = submit
            displayTitle = display.isEmpty ? submit : display
        } else {
            let line = display.trimmingCharacters(in: .whitespacesAndNewlines)
            submitValue = line
            displayTitle = line
        }
    }
}

struct SuliJoyLagoonRemotePartyCreateConditions: Decodable {
    let canCreateRoom: Bool
    let createRoomLevel: Int
    let roomTagChoices: [SuliJoyLagoonRemotePartyRoomTagChoice]

    var roomTags: [String] { roomTagChoices.map(\.submitValue) }

    private enum CodingKeys: String, CodingKey {
        case canCreateRoom
        case createRoomLevel
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        canCreateRoom = container.suliJoyBool(forKey: .canCreateRoom)
        createRoomLevel = container.suliJoyInt(forKey: .createRoomLevel)
        roomTagChoices = Self.decodeRoomTagChoices(from: decoder)
    }

    private static func decodeRoomTagChoices(from decoder: Decoder) -> [SuliJoyLagoonRemotePartyRoomTagChoice] {
        guard let container = try? decoder.container(keyedBy: SuliJoyLagoonRemoteFlexibleKey.self) else {
            return []
        }
        for key in ["roomTags", "roomTagList", "tagList", "tags", "roomTagConfigList"] {
            guard let codingKey = SuliJoyLagoonRemoteFlexibleKey(stringValue: key),
                  let raw = try? container.decode([SuliJoyLagoonRemotePartyRoomTagChoice].self, forKey: codingKey) else {
                continue
            }
            let cleaned = raw.filter { !$0.submitValue.isEmpty || !$0.displayTitle.isEmpty }
            if !cleaned.isEmpty { return cleaned }
        }
        return []
    }
}

struct SuliJoyLagoonRemotePartyTemplate: Decodable {
    let templateID: Int
    let imageURL: String
    let title: String

    private enum CodingKeys: String, CodingKey {
        case templateID = "roomTempId"
        case imageURL = "imgUrl"
        case title
        case roomTempName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        templateID = container.suliJoyInt(forKey: .templateID)
        imageURL = container.suliJoyText(forKey: .imageURL)
        var name = container.suliJoyText(forKey: .title)
        if name.isEmpty { name = container.suliJoyText(forKey: .roomTempName) }
        title = name.isEmpty ? "Room layout" : name
    }
}

struct SuliJoyLagoonRemotePartyLanguage: Decodable {
    let languageName: String
    let languageCode: String

    private enum CodingKeys: String, CodingKey {
        case languageName
        case languageCode
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        languageName = container.suliJoyText(forKey: .languageName)
        languageCode = container.suliJoyText(forKey: .languageCode)
    }
}

struct SuliJoyLagoonRemotePartyTemplateList: Decodable {
    let templates: [SuliJoyLagoonRemotePartyTemplate]

    init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let rows = try? container.decode([SuliJoyLagoonRemotePartyTemplate].self) {
            templates = rows
            return
        }
        let container = try decoder.container(keyedBy: SuliJoyLagoonRemoteFlexibleKey.self)
        for key in ["list", "rows", "data", "resultList"] {
            if let key = SuliJoyLagoonRemoteFlexibleKey(stringValue: key),
               let rows = try? container.decode([SuliJoyLagoonRemotePartyTemplate].self, forKey: key) {
                templates = rows.filter { $0.templateID > 0 }
                return
            }
        }
        templates = []
    }
}

struct SuliJoyLagoonRemotePartyLanguageList: Decodable {
    let languages: [SuliJoyLagoonRemotePartyLanguage]

    init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer(),
           let rows = try? container.decode([SuliJoyLagoonRemotePartyLanguage].self) {
            languages = rows.filter { !$0.languageName.isEmpty }
            return
        }
        let container = try decoder.container(keyedBy: SuliJoyLagoonRemoteFlexibleKey.self)
        for key in ["list", "rows", "data", "languageList"] {
            if let key = SuliJoyLagoonRemoteFlexibleKey(stringValue: key),
               let rows = try? container.decode([SuliJoyLagoonRemotePartyLanguage].self, forKey: key) {
                languages = rows.filter { !$0.languageName.isEmpty }
                return
            }
        }
        languages = []
    }
}

struct SuliJoyLagoonRemoteOnlineFace: Decodable {
    let avatar: String

    private enum CodingKeys: String, CodingKey {
        case avatar
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        avatar = container.suliJoyText(forKey: .avatar)
    }
}

struct SuliJoyLagoonRemoteVoiceSeat: Decodable {
    let seatIndex: Int
    let userId: Int64?
    let avatar: String?
    let nickname: String?
    let isOccupied: Int?
    let roomRoleType: Int?
}

struct SuliJoyLagoonRemoteShoreBubble: Decodable {
    let bubbleID: String
    let userID: Int64
    let nickname: String
    let avatarUrl: String
    let text: String
    let createdAt: Int64

    private enum CodingKeys: String, CodingKey {
        case bubbleID = "id"
        case userID = "userId"
        case nickname, avatarUrl, text, createdAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bubbleID = container.suliJoyText(forKey: .bubbleID)
        userID = container.suliJoyInt64(forKey: .userID)
        nickname = container.suliJoyText(forKey: .nickname)
        avatarUrl = container.suliJoyText(forKey: .avatarUrl)
        text = container.suliJoyText(forKey: .text)
        createdAt = container.suliJoyInt64(forKey: .createdAt)
    }
}

struct SuliJoyLagoonRemoteStylistList: Decodable {
    struct SuliJoyLagoonStylist: Decodable {
        let userId: Int64
        let nickName: String
        let icon: String
        let fansCount: Int
        let followed: Bool

        private enum CodingKeys: String, CodingKey {
            case userId
            case nickName
            case icon
            case fansCount
            case followed
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            userId = container.suliJoyInt64(forKey: .userId)
            nickName = container.suliJoyText(forKey: .nickName)
            icon = container.suliJoyText(forKey: .icon)
            fansCount = container.suliJoyInt(forKey: .fansCount)
            followed = container.suliJoyBool(forKey: .followed)
        }
    }
    let list: [SuliJoyLagoonStylist]
}

struct SuliJoyLagoonRemotePartyRoomList: Decodable {
    let rows: [SuliJoyLagoonRemotePartyRoom]

    private enum CodingKeys: String, CodingKey {
        case rows
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = (try? container.decode([SuliJoyLagoonRemotePartyRoom].self, forKey: .rows)) ?? []
    }
}

struct SuliJoyLagoonRemoteLiveRoom: Decodable {
    let roomID: Int64
    let hostID: Int64
    let nickname: String
    let icon: String
    let coverURL: String
    let audienceCount: Int
    let heatValue: Int
    let liveTitle: String
    let tagLabels: [String]
    let viewerFaces: [SuliJoyLagoonRemoteOnlineFace]
    let countryID: String
    let category: String
    let followed: Bool

    private enum CodingKeys: String, CodingKey {
        case roomID = "id"
        case hostID = "userId"
        case nickname
        case icon
        case coverURL = "backgroundImgUrl"
        case audienceCount = "joinNum"
        case heatValue
        case heatNum
        case hotNum
        case hotValue
        case hotScore
        case liveName
        case liveTitle = "title"
        case roomTitle
        case roomName
        case tags
        case tagList
        case onlineUserList
        case audienceList
        case viewerList
        case countryID = "countryId"
        case category
        case followed = "followFlag"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        roomID = container.suliJoyInt64(forKey: .roomID)
        hostID = container.suliJoyInt64(forKey: .hostID)
        nickname = container.suliJoyText(forKey: .nickname)
        icon = container.suliJoyText(forKey: .icon)
        coverURL = container.suliJoyText(forKey: .coverURL)
        audienceCount = container.suliJoyInt(forKey: .audienceCount)
        var heat = container.suliJoyInt(forKey: .hotScore)
        if heat == 0 { heat = container.suliJoyInt(forKey: .heatValue) }
        if heat == 0 { heat = container.suliJoyInt(forKey: .heatNum) }
        if heat == 0 { heat = container.suliJoyInt(forKey: .hotNum) }
        if heat == 0 { heat = container.suliJoyInt(forKey: .hotValue) }
        heatValue = heat
        var titleLine = container.suliJoyText(forKey: .liveTitle)
        if titleLine.isEmpty { titleLine = container.suliJoyText(forKey: .roomTitle) }
        if titleLine.isEmpty { titleLine = container.suliJoyText(forKey: .liveName) }
        if titleLine.isEmpty { titleLine = container.suliJoyText(forKey: .roomName) }
        liveTitle = titleLine
        tagLabels = (try? container.decode([String].self, forKey: .tags))
            ?? (try? container.decode([String].self, forKey: .tagList))
            ?? []
        if let online = try? container.decode([SuliJoyLagoonRemoteOnlineFace].self, forKey: .onlineUserList) {
            viewerFaces = online
        } else if let online = try? container.decode([SuliJoyLagoonRemoteOnlineFace].self, forKey: .audienceList) {
            viewerFaces = online
        } else if let online = try? container.decode([SuliJoyLagoonRemoteOnlineFace].self, forKey: .viewerList) {
            viewerFaces = online
        } else {
            viewerFaces = []
        }
        countryID = container.suliJoyText(forKey: .countryID)
        category = container.suliJoyText(forKey: .category)
        followed = container.suliJoyBool(forKey: .followed)
    }
}

struct SuliJoyLagoonRemoteLiveList: Decodable {
    let rows: [SuliJoyLagoonRemoteLiveRoom]
    let total: Int

    private enum CodingKeys: String, CodingKey {
        case rows
        case total
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = (try? container.decode([SuliJoyLagoonRemoteLiveRoom].self, forKey: .rows)) ?? []
        total = container.suliJoyInt(forKey: .total)
    }
}

struct SuliJoyLagoonRemoteBlockedVisitor: Decodable {
    let userID: Int64
    let nickname: String
    let icon: String

    private enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname
        case icon
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userID = container.suliJoyInt64(forKey: .userID)
        nickname = container.suliJoyText(forKey: .nickname)
        icon = container.suliJoyText(forKey: .icon)
    }
}

struct SuliJoyLagoonRemoteBlockedVisitorList: Decodable {
    let rows: [SuliJoyLagoonRemoteBlockedVisitor]

    private enum CodingKeys: String, CodingKey {
        case rows
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rows = (try? container.decode([SuliJoyLagoonRemoteBlockedVisitor].self, forKey: .rows)) ?? []
    }
}

struct SuliJoyLagoonRemoteShortVideoCommentResult: Decodable {
    let commentCount: Int

    private enum CodingKeys: String, CodingKey {
        case commentCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        commentCount = container.suliJoyInt(forKey: .commentCount)
    }
}

struct SuliJoyLagoonRemoteShortVideoComment: Decodable {
    let commentID: String
    let content: String
    let createdAt: Int64
    let nickname: String
    let icon: String

    private enum CodingKeys: String, CodingKey {
        case commentID = "commentId"
        case content
        case createdAt
        case user
    }

    private struct Author: Decodable {
        let nickname: String
        let icon: String

        private enum CodingKeys: String, CodingKey {
            case nickname
            case icon
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        commentID = container.suliJoyText(forKey: .commentID)
        content = container.suliJoyText(forKey: .content)
        createdAt = container.suliJoyInt64(forKey: .createdAt)
        let author = try? container.decode(Author.self, forKey: .user)
        nickname = author?.nickname ?? ""
        icon = author?.icon ?? ""
    }
}

struct SuliJoyLagoonRemoteShortVideoCommentList: Decodable {
    let items: [SuliJoyLagoonRemoteShortVideoComment]

    private enum CodingKeys: String, CodingKey {
        case items
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = (try? container.decode([SuliJoyLagoonRemoteShortVideoComment].self, forKey: .items)) ?? []
    }
}

struct SuliJoyLagoonRemoteShortVideoPublishResult: Decodable {
    let videoID: String
    let caption: String
    let videoURL: String
    let coverURL: String
    let durationSeconds: Int
    let width: Int
    let height: Int
    let likeCount: Int
    let commentCount: Int
    let liked: Bool
    let followed: Bool
    let viewCount: Int
    let createdAt: Int64
    let author: SuliJoyLagoonRemoteShortVideoAuthor?

    private enum CodingKeys: String, CodingKey {
        case videoID = "videoId"
        case caption
        case videoURL = "videoUrl"
        case coverURL = "coverUrl"
        case durationSeconds
        case width
        case height
        case likeCount
        case commentCount
        case liked
        case followed
        case viewCount
        case createdAt
        case author
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        videoID = container.suliJoyText(forKey: .videoID)
        caption = container.suliJoyText(forKey: .caption)
        videoURL = container.suliJoyText(forKey: .videoURL)
        coverURL = container.suliJoyText(forKey: .coverURL)
        durationSeconds = container.suliJoyInt(forKey: .durationSeconds)
        width = container.suliJoyInt(forKey: .width)
        height = container.suliJoyInt(forKey: .height)
        likeCount = container.suliJoyInt(forKey: .likeCount)
        commentCount = container.suliJoyInt(forKey: .commentCount)
        liked = container.suliJoyBool(forKey: .liked)
        followed = container.suliJoyBool(forKey: .followed)
        viewCount = container.suliJoyInt(forKey: .viewCount)
        createdAt = container.suliJoyInt64(forKey: .createdAt)
        author = try? container.decode(SuliJoyLagoonRemoteShortVideoAuthor.self, forKey: .author)
    }
}

struct SuliJoyLagoonRemoteResourceUploadResult: Decodable {
    let resourceURL: String

    private enum CodingKeys: String, CodingKey {
        case resourceURL = "url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resourceURL = container.suliJoyText(forKey: .resourceURL)
    }
}

struct SuliJoyLagoonRemoteDiamondResult: Decodable {
    let diamondBalance: Int

    private enum CodingKeys: String, CodingKey {
        case diamondBalance = "diamondNum"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        diamondBalance = container.suliJoyInt(forKey: .diamondBalance)
    }
}

struct SuliJoyLagoonRemoteAuthPayload: Decodable {
    let accessToken: String
    let refreshToken: String
    let userID: String
    let balance: Double
    let registered: Bool
    let profileCompleted: Bool

    private enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
        case userID = "userId"
        case balance
        case registered
        case profileCompleted
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
        userID = Self.decodeText(container, forKey: .userID) ?? ""
        balance = Self.decodeNumber(container, forKey: .balance) ?? 0
        registered = (try? container.decode(Bool.self, forKey: .registered)) ?? false
        profileCompleted = (try? container.decode(Bool.self, forKey: .profileCompleted)) ?? false
    }

    private static func decodeText(
        _ container: KeyedDecodingContainer<CodingKeys>,
        forKey key: CodingKeys
    ) -> String? {
        if let value = try? container.decode(String.self, forKey: key) { return value }
        if let value = try? container.decode(Int64.self, forKey: key) { return String(value) }
        return nil
    }

    private static func decodeNumber(
        _ container: KeyedDecodingContainer<CodingKeys>,
        forKey key: CodingKeys
    ) -> Double? {
        if let value = try? container.decode(Double.self, forKey: key) { return value }
        if let value = try? container.decode(Int64.self, forKey: key) { return Double(value) }
        return nil
    }
}

struct SuliJoyLagoonRemoteLetter: Decodable {
    let noteID: String
    let conversationID: String
    let createdAt: Int64
    let kind: String
    let own: Bool
    let text: String
    let attachmentURL: String

    private enum CodingKeys: String, CodingKey {
        case noteID = "id"
        case conversationID = "conversationId"
        case createdAt
        case kind
        case own
        case text
        case attachmentURL = "attachmentUrl"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        noteID = container.suliJoyText(forKey: .noteID)
        conversationID = container.suliJoyText(forKey: .conversationID)
        createdAt = container.suliJoyInt64(forKey: .createdAt)
        kind = container.suliJoyText(forKey: .kind)
        own = container.suliJoyBool(forKey: .own)
        text = container.suliJoyText(forKey: .text)
        attachmentURL = container.suliJoyText(forKey: .attachmentURL)
    }
}

struct SuliJoyLagoonRemoteLetterThread: Decodable {
    let conversationID: String
    let userID: String
    let displayName: String
    let avatarURL: String
    let unread: Int
    let blocked: Bool
    let sortTime: Int64
    let latest: SuliJoyLagoonRemoteLetter?

    private enum CodingKeys: String, CodingKey {
        case conversationID = "conversationId"
        case userID = "userId"
        case displayName
        case avatarURL = "avatarUrl"
        case unread
        case blocked
        case sortTime
        case latest
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        conversationID = container.suliJoyText(forKey: .conversationID)
        userID = container.suliJoyText(forKey: .userID)
        displayName = container.suliJoyText(forKey: .displayName)
        avatarURL = container.suliJoyText(forKey: .avatarURL)
        unread = container.suliJoyInt(forKey: .unread)
        blocked = container.suliJoyBool(forKey: .blocked)
        sortTime = container.suliJoyInt64(forKey: .sortTime)
        latest = try? container.decode(SuliJoyLagoonRemoteLetter.self, forKey: .latest)
    }
}

struct SuliJoyLagoonRemoteLetterThreadList: Decodable {
    let items: [SuliJoyLagoonRemoteLetterThread]
    let nextCursor: String
    let finished: Bool

    private enum CodingKeys: String, CodingKey {
        case items
        case nextCursor
        case finished
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = (try? container.decode([SuliJoyLagoonRemoteLetterThread].self, forKey: .items)) ?? []
        nextCursor = container.suliJoyText(forKey: .nextCursor)
        finished = container.suliJoyBool(forKey: .finished)
    }
}

struct SuliJoyLagoonRemoteLetterPage: Decodable {
    let items: [SuliJoyLagoonRemoteLetter]
    let nextCursor: String
    let finished: Bool

    private enum CodingKeys: String, CodingKey {
        case items
        case nextCursor
        case finished
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = (try? container.decode([SuliJoyLagoonRemoteLetter].self, forKey: .items)) ?? []
        nextCursor = container.suliJoyText(forKey: .nextCursor)
        finished = container.suliJoyBool(forKey: .finished)
    }
}

enum SuliJoyLagoonRemoteError: LocalizedError {
    case invalidRequest
    case invalidResponse
    case transport(Error)
    case encryption(Error)
    case decoding(Error)
    case business(code: String, message: String, requestID: String?)

    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "Unable to prepare the request."
        case .invalidResponse:
            return "The server response is invalid."
        case .transport(let error), .encryption(let error), .decoding(let error):
            return error.localizedDescription
        case .business(_, let message, _):
            return message.isEmpty ? "The request could not be completed." : message
        }
    }

    var statusCode: Int {
        switch self {
        case .business(let code, _, _):
            return Int(code) ?? 400
        default:
            return 400
        }
    }

    var isUnauthorized: Bool {
        guard case .business(let code, _, _) = self else { return false }
        return code == "401" || code == "4010" || code == "4011" || code == "403"
    }
}

enum SuliJoyVoiceRoomLane {
    case islandVibes
    case styleTalk
    case meetMingle
}

final class SuliJoyLagoonRemoteClient {
    private struct SuliJoyLagoonEnvelope: Decodable {
        let code: String
        let message: String
        let requestID: String?
        let result: String?

        private enum CodingKeys: String, CodingKey {
            case code
            case message
            case requestID = "requestId"
            case result
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let text = try? container.decode(String.self, forKey: .code) {
                code = text
            } else if let number = try? container.decode(Int.self, forKey: .code) {
                code = String(number)
            } else {
                code = ""
            }
            message = (try? container.decode(String.self, forKey: .message)) ?? ""
            requestID = try? container.decode(String.self, forKey: .requestID)
            result = try? container.decode(String.self, forKey: .result)
            resultPayload = result
        }

        init(wire: [String: Any]) {
            code = Self.stringValue(SuliJoyOpiRegistry.semanticEnvelopeField("code", from: wire))
            message = Self.stringValue(SuliJoyOpiRegistry.semanticEnvelopeField("message", from: wire))
            let request = Self.stringValue(SuliJoyOpiRegistry.semanticEnvelopeField("requestId", from: wire))
            requestID = request.isEmpty ? nil : request
            resultPayload = SuliJoyOpiRegistry.semanticEnvelopeField("result", from: wire)
            if let text = resultPayload as? String {
                result = text
            } else {
                result = nil
            }
        }

        /// Encrypted hex string, or a JSON object/array when the gateway returns plaintext `result`.
        let resultPayload: Any?

        private static func stringValue(_ value: Any?) -> String {
            if let text = value as? String { return text }
            if let number = value as? NSNumber { return number.stringValue }
            return ""
        }
    }

    private struct SuliJoyLagoonRemoteExchange {
        let envelope: SuliJoyLagoonEnvelope
        let trace: SuliJoyLagoonRemoteDebugLogger.Trace
        let httpStatus: Int
        let semanticPath: String
    }

    private struct SuliJoyEmailPayload: Encodable {
        let email: String
        let password: String
        let deviceNo: String
    }

    private struct SuliJoyRefreshPayload: Encodable {
        let refreshToken: String
    }

    private struct SuliJoyProfilePayload: Encodable {
        let nickname: String
        let signature: String
        let icon: String?
    }

    private struct SuliJoyEmptyPayload: Encodable {}

    private struct SuliJoyUserIDPayload: Encodable {
        let userID: Int64

        private enum CodingKeys: String, CodingKey {
            case userID = "userId"
        }
    }

    private struct SuliJoyUserFollowPayload: Encodable {
        let followUserID: Int64
        let followType: Int

        private enum CodingKeys: String, CodingKey {
            case followUserID = "followUserId"
            case followType
        }
    }

    private struct SuliJoyLetterListPayload: Encodable {
        let cursor: Int
        let limit: Int
    }

    private struct SuliJoyLetterHistoryPayload: Encodable {
        let conversationId: String
        let cursor: Int
        let limit: Int
    }

    private struct SuliJoyLetterSendPayload: Encodable {
        let conversationId: String
        let kind: String
        let text: String
        let clientMessageId: String
    }

    private struct SuliJoyLetterReadPayload: Encodable {
        let conversationId: String
    }

    private struct SuliJoyLetterOpenPayload: Encodable {
        let userId: String
    }

    private struct SuliJoyUserBlockPayload: Encodable {
        let userID: Int64
        let type: Int

        private enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case type
        }
    }

    private struct SuliJoyMomentsUserPayload: Encodable {
        let userID: Int64?
        let cursorID: Int64
        let size: Int

        private enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case cursorID = "cursorId"
            case size
        }
    }

    private struct SuliJoyShortVideoUserPayload: Encodable {
        let userID: Int64?
        let cursor: Int64
        let pageSize: Int
        let contentType: String

        private enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case cursor
            case pageSize
            case contentType
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(userID, forKey: .userID)
            try container.encode(cursor, forKey: .cursor)
            try container.encode(pageSize, forKey: .pageSize)
            try container.encode(contentType, forKey: .contentType)
        }
    }

    private struct SuliJoyMomentLikePayload: Encodable {
        let momentID: Int64
        let optionType: Int

        private enum CodingKeys: String, CodingKey {
            case momentID = "id"
            case optionType
        }

        init(momentID: Int64, liked: Bool) {
            self.momentID = momentID
            optionType = liked ? 1 : 0
        }
    }

    private struct SuliJoyMomentFeedPayload: Encodable {
        let feedType: String
        let cursorID: Int64
        let size: Int

        private enum CodingKeys: String, CodingKey {
            case feedType
            case cursorID = "cursorId"
            case size
        }
    }

    private struct SuliJoyMomentCommentListPayload: Encodable {
        let momentID: Int64
        let currentPage: Int
        let pageSize: Int

        private enum CodingKeys: String, CodingKey {
            case momentID = "friendsCircleId"
            case currentPage
            case pageSize
        }
    }

    private struct SuliJoyMomentCommentPayload: Encodable {
        let momentID: Int64
        let commentContent: String

        private enum CodingKeys: String, CodingKey {
            case momentID = "friendsCircleId"
            case commentContent
        }
    }

    private struct SuliJoyMomentReportPayload: Encodable {
        let momentID: Int64
        let reasonCode: String
        let commentID: Int64?
        let description: String?

        private enum CodingKeys: String, CodingKey {
            case momentID = "id"
            case reasonCode
            case commentID = "commentId"
            case description
        }
    }

    private struct SuliJoyShortVideoLikePayload: Encodable {
        let videoID: Int64
        let liked: Bool

        private enum CodingKeys: String, CodingKey {
            case videoID = "videoId"
            case liked
        }
    }

    private struct SuliJoyShortVideoCommentPayload: Encodable {
        let videoID: Int64
        let content: String

        private enum CodingKeys: String, CodingKey {
            case videoID = "videoId"
            case content
        }
    }

    private struct SuliJoyShortVideoDetailPayload: Encodable {
        let videoID: Int64

        private enum CodingKeys: String, CodingKey {
            case videoID = "videoId"
        }
    }

    private struct SuliJoyShortVideoCommentListPayload: Encodable {
        let videoID: Int64
        let cursor: Int64
        let pageSize: Int

        private enum CodingKeys: String, CodingKey {
            case videoID = "videoId"
            case cursor
            case pageSize
        }
    }

    private struct SuliJoyShortVideoReportPayload: Encodable {
        let videoID: Int64
        let reasonCode: String
        let description: String?

        private enum CodingKeys: String, CodingKey {
            case videoID = "videoId"
            case reasonCode
            case description
        }
    }

    private struct SuliJoyDiamondChangePayload: Encodable {
        let recordType: String
        let diamondNum: Int
    }

    private struct SuliJoyMomentPublishPayload: Encodable {
        let textContent: String
        let imgURLs: [String]
        let displayRange: Int
        let audioURL: String?
        let audioDuration: Int?

        private enum CodingKeys: String, CodingKey {
            case textContent
            case imgURLs = "imgUrls"
            case displayRange
            case audioURL = "audioUrl"
            case audioDuration
        }
    }

    private struct SuliJoyShortVideoPublishPayload: Encodable {
        let contentType: String
        let clientRequestID: String
        let caption: String
        let videoURL: String
        let coverURL: String?
        let durationSeconds: Int
        let width: Int
        let height: Int
        let languageCode: String
        let tags: [String]
        let visibility: String
        let extra: String?

        private enum CodingKeys: String, CodingKey {
            case contentType
            case clientRequestID = "clientRequestId"
            case caption
            case videoURL = "videoUrl"
            case coverURL = "coverUrl"
            case durationSeconds
            case width
            case height
            case languageCode
            case tags
            case visibility
            case extra
        }
    }

    private struct SuliJoyPartyRoomCreatePayload: Encodable {
        let roomName: String
        let roomAvatar: String
        let greetingMessage: String
        let roomLanguage: String
        let roomTempID: Int
        let roomTags: [String]?
        let countryCode: String?
        let bgImgID: Int?

        private enum CodingKeys: String, CodingKey {
            case roomTags
            case roomName
            case roomAvatar
            case greetingMessage
            case roomLanguage
            case countryCode
            case roomTempID = "roomTempId"
            case bgImgID = "bgImgId"
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(roomName, forKey: .roomName)
            try container.encode(roomAvatar, forKey: .roomAvatar)
            try container.encode(greetingMessage, forKey: .greetingMessage)
            try container.encode(roomLanguage, forKey: .roomLanguage)
            try container.encode(roomTempID, forKey: .roomTempID)
            if let roomTags, !roomTags.isEmpty {
                try container.encode(roomTags, forKey: .roomTags)
            }
            if let countryCode, !countryCode.isEmpty {
                try container.encode(countryCode, forKey: .countryCode)
            }
            if let bgImgID {
                try container.encode(bgImgID, forKey: .bgImgID)
            }
        }
    }

    private struct SuliJoyLiveHostPreparePayload: Encodable {
        let category: String?
        let coverUrl: String
        let liveTitle: String
        let liveType: String
        let languageName: String
        let countryCode: String
        let requestNo: String
        let contentReminderAccepted: Bool
    }

    private struct SuliJoyLiveHostStartPayload: Encodable {
        let roomId: Int64
        let sessionId: Int64
    }

    private struct SuliJoyPartyTemplateListPayload: Encodable {
        let type: Int
    }

    private struct SuliJoyPartyRoomPayload: Encodable {
        let userID: Int64?
        let cursorID: Int64
        let size: Int

        private enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case cursorID = "cursorId"
            case size
        }
    }

    private struct SuliJoyBlockedVisitorPayload: Encodable {
        let currentPage: Int
        let pageSize: Int
    }

    private struct SuliJoyTideTalkPayload: Encodable {
        let roomId: Int64
        var seatIndex: Int? = nil
        var yxRoomId: String? = nil
        var roomTempId: Int64? = nil
        var content: String? = nil
        var limit: Int? = nil
    }

    private struct SuliJoyShoreFeedPayload: Encodable {
        var pageSize: Int = 50
        var cursor: Int64? = nil
        var contentType: String? = nil
        var scene: String? = nil
        var languageCode: String? = nil
        var version: String? = nil
    }

    private struct SuliJoyVoiceRoomListPayload: Encodable {
        let languageCode: String?
        let pageSize: Int
        let version: String

        private enum CodingKeys: String, CodingKey {
            case languageCode
            case pageSize
            case version
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            if let languageCode {
                try container.encode(languageCode, forKey: .languageCode)
            }
            try container.encode(pageSize, forKey: .pageSize)
            try container.encode(version, forKey: .version)
        }
    }

    private struct SuliJoyLiveListPayload: Encodable {
        let currentPage: Int
        let pageSize: Int
        let category: String?

        private enum CodingKeys: String, CodingKey {
            case currentPage
            case pageSize
            case category
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(currentPage, forKey: .currentPage)
            try container.encode(pageSize, forKey: .pageSize)
            if let category, !category.isEmpty {
                try container.encode(category, forKey: .category)
            }
        }
    }

    private struct SuliJoyShoreReportPayload: Encodable {
        let feedbackType: String
        let targetUserId: Int64?
        let roomId: Int64?
        let suggestion: String
    }

    private enum SuliJoyRemotePath {
        static let emailLogin = "/_v2/auth/email/login"
        static let emailRegister = "/_v2/auth/email/register"
        static let tokenRefresh = "/_v2/auth/token/refresh"
        static let accountDelete = "/_v2/auth/account/delete"
        static let profileUpdate = "/_v2/user/update"
        static let userInfo = "/_v2/user/info"
        static let personalCard = "/_v2/user/personalCard"
        static let momentsUserList = "/_v2/moments/user/list"
        static let momentsFeed = "/_v2/moments/feed"
        static let momentsComments = "/_v2/moments/getComments"
        static let momentsComment = "/_v2/moments/comment"
        static let momentsReport = "/_v2/moments/report"
        static let shortVideoUserList = "/_v2/short-video/user/list"
        static let shortVideoFeed = "/_v2/short-video/feed"
        static let shortVideoDetail = "/_v2/short-video/detail"
        static let partyRooms = "/_v2/user/party/rooms"
        static let followUser = "/_v2/user/followUser"
        static let blockUser = "/_v2/user/block/add"
        static let messageConversations = "/_v2/message/conversations"
        static let messageHistory = "/_v2/message/history"
        static let messageSend = "/_v2/message/send"
        static let messageOpen = "/_v2/message/get-or-create"
        static let messageRead = "/_v2/message/read"
        static let blockedUsers = "/_v2/user/block/list"
        static let momentLike = "/_v2/moments/like"
        static let shortVideoLike = "/_v2/short-video/like"
        static let shortVideoCommentCreate = "/_v2/short-video/comment/create"
        static let shortVideoCommentList = "/_v2/short-video/comment/list"
        static let shortVideoReport = "/_v2/short-video/report"
        static let shortVideoPublish = "/_v2/short-video/publish"
        static let momentsCreate = "/_v2/moments/create"
        static let resourceUpload = "/_v2/resource/upload"
        static let partyRoomCreate = "/sapi/weidou/v1/client/party/room/create"
        static let partyCreateConditions = "/sapi/weidou/v1/client/party/room/getCreateRoomConditions"
        static let partyRoomTemplates = "/sapi/weidou/v1/client/party/room/getRoomTempList"
        static let partyLanguages = "/sapi/weidou/v1/client/party/room/language/list"
        static let liveHostOptions = "/_v2/live/real/host/options"
        static let liveHostPrepare = "/_v2/live/real/host/prepare"
        static let liveHostStart = "/_v2/live/real/host/start"
        static let diamondConsume = "/_v2/user/diamond/consume"
    }

    private let configuration: SuliJoyLagoonRemoteConfiguration
    private let sessionVault: SuliJoyTideSessionVault
    private let session: URLSession
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(
        configuration: SuliJoyLagoonRemoteConfiguration = .shared,
        sessionVault: SuliJoyTideSessionVault,
        session: URLSession = .shared
    ) {
        self.configuration = configuration
        self.sessionVault = sessionVault
        self.session = session
    }

    func enterIslandLagoon(email: String, password: String) async throws -> SuliJoyLagoonRemoteAuthPayload {
        try await send(
            path: SuliJoyRemotePath.emailLogin,
            body: SuliJoyEmailPayload(email: email, password: password, deviceNo: configuration.deviceNumber),
            accessToken: nil,
            allowsRefresh: false
        )
    }

    func registerIslandLagoon(email: String, password: String) async throws -> SuliJoyLagoonRemoteAuthPayload {
        try await send(
            path: SuliJoyRemotePath.emailRegister,
            body: SuliJoyEmailPayload(email: email, password: password, deviceNo: configuration.deviceNumber),
            accessToken: nil,
            allowsRefresh: false
        )
    }

    func updateIslandProfile(
        accessToken: String,
        nickname: String,
        signature: String,
        icon: String? = nil
    ) async throws {
        try await sendWithoutPayload(
            path: SuliJoyRemotePath.profileUpdate,
            body: SuliJoyProfilePayload(nickname: nickname, signature: signature, icon: icon),
            accessToken: accessToken,
            allowsRefresh: false
        )
    }

    func fetchCurrentIslandProfile() async throws -> SuliJoyLagoonRemoteUserInfo {
        try await send(
            path: SuliJoyRemotePath.userInfo,
            body: SuliJoyEmptyPayload(),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func fetchIslandPersonalCard(userID: Int64) async throws -> SuliJoyLagoonRemotePersonalCard {
        try await send(
            path: SuliJoyRemotePath.personalCard,
            body: SuliJoyUserIDPayload(userID: userID),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func fetchIslandMoments(userID: Int64? = nil) async throws -> SuliJoyLagoonRemoteMomentList {
        try await send(
            path: SuliJoyRemotePath.momentsUserList,
            body: SuliJoyMomentsUserPayload(userID: userID, cursorID: 0, size: 50),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func fetchIslandMomentFeed(feedType: String) async throws -> SuliJoyLagoonRemoteMomentList {
        try await send(
            path: SuliJoyRemotePath.momentsFeed,
            body: SuliJoyMomentFeedPayload(feedType: feedType, cursorID: 0, size: 50),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func fetchIslandShortVideos(userID: Int64? = nil) async throws -> SuliJoyLagoonRemoteShortVideoList {
        try await send(
            path: SuliJoyRemotePath.shortVideoUserList,
            body: SuliJoyShortVideoUserPayload(userID: userID, cursor: 0, pageSize: 50, contentType: "VIDEO"),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func fetchIslandPartyRooms(userID: Int64? = nil) async throws -> SuliJoyLagoonRemotePartyRoomList {
        try await send(
            path: SuliJoyRemotePath.partyRooms,
            body: SuliJoyPartyRoomPayload(userID: userID, cursorID: 0, size: 50),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func fetchHomeActivities() async throws -> [SuliJoyLagoonRemotePartyRoom] {
        try await fetchVoiceRooms()
    }

    func fetchVoiceRooms(lane: SuliJoyVoiceRoomLane = .islandVibes) async throws -> [SuliJoyLagoonRemotePartyRoom] {
        let path: String
        let languageCode: String?
        switch lane {
        case .islandVibes:
            path = "/sapi/weidou/v1/client/party/room/list"
            languageCode = ""
        case .styleTalk:
            path = "/sapi/weidou/v1/client/party/room/followed/list"
            languageCode = nil
        case .meetMingle:
            path = "/sapi/weidou/v1/client/party/room/recent/list"
            languageCode = nil
        }
        return try await send(
            path: path,
            body: SuliJoyVoiceRoomListPayload(languageCode: languageCode, pageSize: 20, version: "v2"),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func fetchDiscoverLiveRooms(page: Int = 1, category: String? = nil) async throws -> SuliJoyLagoonRemoteLiveList {
        try await send(
            path: "/_v2/discover/live/pool",
            body: SuliJoyLiveListPayload(currentPage: page, pageSize: 20, category: category),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func fetchShellClips() async throws -> SuliJoyLagoonRemoteShortVideoList {
        try await send(
            path: SuliJoyRemotePath.shortVideoFeed,
            body: SuliJoyShoreFeedPayload(cursor: 0, contentType: "VIDEO", scene: "RECOMMEND"),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func fetchLagoonStylists() async throws -> SuliJoyLagoonRemoteStylistList {
        try await send(
            path: "/_v2/user/recommend/list", body: ["size": 20],
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili, allowsRefresh: true
        )
    }

    func joinActivity(tideID: Int64) async throws -> SuliJoyLagoonRemotePartyRoom {
        try await send(
            path: "/sapi/weidou/v1/client/party/room/enter", body: SuliJoyTideTalkPayload(roomId: tideID),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili, allowsRefresh: true
        )
    }

    func sendShoreBreeze(tideID: Int64, text: String) async throws -> SuliJoyLagoonRemoteShoreBubble {
        try await send(
            path: "/sapi/weidou/v1/client/party/room/message/send", body: SuliJoyTideTalkPayload(roomId: tideID, content: text),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili, allowsRefresh: true
        )
    }

    func joinLagoonVoiceSeat(room: SuliJoyLagoonRemotePartyRoom, seatIndex: Int) async throws {
        try await sendWithoutPayload(
            path: "/sapi/weidou/v1/client/party/seat/onSeat",
            body: SuliJoyTideTalkPayload(roomId: room.roomID, seatIndex: seatIndex, yxRoomId: room.yxRoomId, roomTempId: room.roomTempId),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili, allowsRefresh: true
        )
    }

    func reportLagoonVisitor(visitorID: Int64?, roomID: Int64?, reasonCode: String, description: String) async throws {
        try await sendWithoutPayload(
            path: "/_v2/feedback/save",
            body: SuliJoyShoreReportPayload(feedbackType: reasonCode, targetUserId: visitorID, roomId: roomID, suggestion: String(description.prefix(200))),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili, allowsRefresh: true
        )
    }

    func changeIslandFollow(userID: Int64, follow: Bool) async throws {
        try await sendWithoutPayload(
            path: SuliJoyRemotePath.followUser,
            body: SuliJoyUserFollowPayload(followUserID: userID, followType: follow ? 1 : 2),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func blockIslandUser(userID: Int64) async throws {
        try await sendWithoutPayload(
            path: SuliJoyRemotePath.blockUser,
            body: SuliJoyUserBlockPayload(userID: userID, type: 1),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func fetchLetterThreads(cursor: Int = 0) async throws -> SuliJoyLagoonRemoteLetterThreadList {
        try await send(
            path: SuliJoyRemotePath.messageConversations,
            body: SuliJoyLetterListPayload(cursor: cursor, limit: 50),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func fetchLetterHistory(conversationID: String, cursor: Int = 0) async throws -> SuliJoyLagoonRemoteLetterPage {
        try await send(
            path: SuliJoyRemotePath.messageHistory,
            body: SuliJoyLetterHistoryPayload(conversationId: conversationID, cursor: cursor, limit: 50),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func sendLetter(conversationID: String, text: String) async throws -> SuliJoyLagoonRemoteLetter {
        try await send(
            path: SuliJoyRemotePath.messageSend,
            body: SuliJoyLetterSendPayload(
                conversationId: conversationID,
                kind: "text",
                text: text,
                clientMessageId: UUID().uuidString
            ),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func openLetterThread(userID: String) async throws -> SuliJoyLagoonRemoteLetterThread {
        try await send(
            path: SuliJoyRemotePath.messageOpen,
            body: SuliJoyLetterOpenPayload(userId: userID),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func markLetterRead(conversationID: String) async throws {
        try await sendWithoutPayload(
            path: SuliJoyRemotePath.messageRead,
            body: SuliJoyLetterReadPayload(conversationId: conversationID),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func fetchBlockedIslandUsers() async throws -> SuliJoyLagoonRemoteBlockedVisitorList {
        try await send(
            path: SuliJoyRemotePath.blockedUsers,
            body: SuliJoyBlockedVisitorPayload(currentPage: 1, pageSize: 100),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func changeIslandMomentLike(momentID: Int64, liked: Bool) async throws {
        try await sendWithoutPayload(
            path: SuliJoyRemotePath.momentLike,
            body: SuliJoyMomentLikePayload(momentID: momentID, liked: liked),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func fetchIslandMomentComments(momentID: Int64) async throws -> SuliJoyLagoonRemoteMomentCommentList {
        try await send(
            path: SuliJoyRemotePath.momentsComments,
            body: SuliJoyMomentCommentListPayload(momentID: momentID, currentPage: 1, pageSize: 50),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func createIslandMomentComment(momentID: Int64, content: String) async throws -> SuliJoyLagoonRemoteMomentCommentResult {
        try await send(
            path: SuliJoyRemotePath.momentsComment,
            body: SuliJoyMomentCommentPayload(momentID: momentID, commentContent: content),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func reportIslandMoment(
        momentID: Int64,
        commentID: Int64?,
        reasonCode: String,
        description: String?
    ) async throws {
        try await sendWithoutPayload(
            path: SuliJoyRemotePath.momentsReport,
            body: SuliJoyMomentReportPayload(momentID: momentID, reasonCode: reasonCode, commentID: commentID, description: description),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func changeIslandShortVideoLike(videoID: Int64, liked: Bool) async throws {
        try await sendWithoutPayload(
            path: SuliJoyRemotePath.shortVideoLike,
            body: SuliJoyShortVideoLikePayload(videoID: videoID, liked: liked),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func createIslandShortVideoComment(videoID: Int64, content: String) async throws -> SuliJoyLagoonRemoteShortVideoCommentResult {
        try await send(
            path: SuliJoyRemotePath.shortVideoCommentCreate,
            body: SuliJoyShortVideoCommentPayload(videoID: videoID, content: content),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func fetchIslandShortVideoDetail(videoID: Int64) async throws -> SuliJoyLagoonRemoteShortVideoPublishResult {
        try await send(
            path: SuliJoyRemotePath.shortVideoDetail,
            body: SuliJoyShortVideoDetailPayload(videoID: videoID),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func fetchIslandShortVideoComments(videoID: Int64) async throws -> SuliJoyLagoonRemoteShortVideoCommentList {
        try await send(
            path: SuliJoyRemotePath.shortVideoCommentList,
            body: SuliJoyShortVideoCommentListPayload(videoID: videoID, cursor: 0, pageSize: 50),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func reportIslandShortVideo(videoID: Int64, reasonCode: String, description: String?) async throws {
        try await sendWithoutPayload(
            path: SuliJoyRemotePath.shortVideoReport,
            body: SuliJoyShortVideoReportPayload(videoID: videoID, reasonCode: reasonCode, description: description),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func publishIslandMoment(
        textContent: String,
        imageURLs: [String],
        audioURL: String?,
        audioDuration: Int?
    ) async throws -> SuliJoyLagoonRemoteMomentPublishResult {
        try await send(
            path: SuliJoyRemotePath.momentsCreate,
            body: SuliJoyMomentPublishPayload(
                textContent: textContent,
                imgURLs: imageURLs,
                displayRange: 1,
                audioURL: audioURL,
                audioDuration: audioDuration
            ),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func publishIslandShortVideo(
        caption: String,
        videoURL: String,
        coverURL: String?,
        durationSeconds: Int,
        width: Int,
        height: Int
    ) async throws -> SuliJoyLagoonRemoteShortVideoPublishResult {
        try await send(
            path: SuliJoyRemotePath.shortVideoPublish,
            body: SuliJoyShortVideoPublishPayload(
                contentType: "VIDEO",
                clientRequestID: UUID().uuidString,
                caption: caption,
                videoURL: videoURL,
                coverURL: coverURL,
                durationSeconds: durationSeconds,
                width: width,
                height: height,
                languageCode: configuration.language,
                tags: [],
                visibility: "PUBLIC",
                extra: nil
            ),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func uploadIslandResource(fileURL: URL, mimeType: String) async throws -> String {
        let uploadResult: SuliJoyLagoonRemoteResourceUploadResult = try await sendMultipart(
            path: SuliJoyRemotePath.resourceUpload,
            fileURL: fileURL,
            mimeType: mimeType,
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
        guard !uploadResult.resourceURL.isEmpty else {
            throw SuliJoyLagoonRemoteError.invalidResponse
        }
        return uploadResult.resourceURL
    }

    func fetchLiveHostOptions() async throws -> SuliJoyLagoonRemoteLiveHostOptions {
        try await send(
            path: SuliJoyRemotePath.liveHostOptions,
            body: SuliJoyEmptyPayload(),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func prepareLiveHostSession(
        category: String?,
        coverURL: String,
        liveTitle: String,
        liveType: String,
        languageName: String,
        countryCode: String,
        requestNo: String,
        contentReminderAccepted: Bool
    ) async throws -> SuliJoyLagoonRemoteLiveHostSession {
        try await send(
            path: SuliJoyRemotePath.liveHostPrepare,
            body: SuliJoyLiveHostPreparePayload(
                category: category,
                coverUrl: coverURL,
                liveTitle: liveTitle,
                liveType: liveType,
                languageName: languageName,
                countryCode: countryCode,
                requestNo: requestNo,
                contentReminderAccepted: contentReminderAccepted
            ),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func startLiveHostSession(roomID: Int64, sessionID: Int64) async throws -> SuliJoyLagoonRemoteLiveHostSession {
        try await send(
            path: SuliJoyRemotePath.liveHostStart,
            body: SuliJoyLiveHostStartPayload(roomId: roomID, sessionId: sessionID),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func fetchPartyCreateConditions() async throws -> SuliJoyLagoonRemotePartyCreateConditions {
        try await send(
            path: SuliJoyRemotePath.partyCreateConditions,
            body: SuliJoyEmptyPayload(),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func fetchPartyRoomTemplates() async throws -> [SuliJoyLagoonRemotePartyTemplate] {
        let list: SuliJoyLagoonRemotePartyTemplateList = try await send(
            path: SuliJoyRemotePath.partyRoomTemplates,
            body: SuliJoyPartyTemplateListPayload(type: 1),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
        return list.templates
    }

    func fetchPartyLanguages() async throws -> [SuliJoyLagoonRemotePartyLanguage] {
        let list: SuliJoyLagoonRemotePartyLanguageList = try await send(
            path: SuliJoyRemotePath.partyLanguages,
            body: SuliJoyEmptyPayload(),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
        return list.languages
    }

    func createIslandPartyRoom(
        roomName: String,
        roomAvatar: String,
        greetingMessage: String,
        roomLanguage: String,
        roomTempID: Int = 1,
        roomTags: [String]? = nil,
        countryCode: String? = nil,
        backgroundImageID: Int? = nil
    ) async throws -> SuliJoyLagoonRemotePartyRoom {
        try await send(
            path: SuliJoyRemotePath.partyRoomCreate,
            body: SuliJoyPartyRoomCreatePayload(
                roomName: roomName,
                roomAvatar: roomAvatar,
                greetingMessage: greetingMessage,
                roomLanguage: roomLanguage,
                roomTempID: roomTempID,
                roomTags: roomTags,
                countryCode: countryCode,
                bgImgID: backgroundImageID
            ),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func changeIslandDiamonds(amount: Int, recordType: String) async throws -> SuliJoyLagoonRemoteDiamondResult {
        guard amount > 0 else { throw SuliJoyLagoonRemoteError.invalidRequest }
        return try await send(
            path: SuliJoyRemotePath.diamondConsume,
            body: SuliJoyDiamondChangePayload(recordType: recordType, diamondNum: amount),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    func deleteIslandAccount() async throws {
        try await sendWithoutPayload(
            path: SuliJoyRemotePath.accountDelete,
            body: SuliJoyEmptyPayload(),
            accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili,
            allowsRefresh: true
        )
    }

    private func send<Payload: Decodable, Body: Encodable>(
        path: String,
        body: Body,
        accessToken: String?,
        allowsRefresh: Bool
    ) async throws -> Payload {
        do {
            return try await perform(path: path, body: body, accessToken: accessToken)
        } catch let error as SuliJoyLagoonRemoteError where allowsRefresh && error.isUnauthorized {
            try await refreshRemoteSession()
            return try await perform(path: path, body: body, accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili)
        }
    }

    private func sendWithoutPayload<Body: Encodable>(
        path: String,
        body: Body,
        accessToken: String?,
        allowsRefresh: Bool
    ) async throws {
        do {
            try await performWithoutPayload(path: path, body: body, accessToken: accessToken)
        } catch let error as SuliJoyLagoonRemoteError where allowsRefresh && error.isUnauthorized {
            try await refreshRemoteSession()
            try await performWithoutPayload(path: path, body: body, accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili)
        }
    }

    private func sendMultipart<Payload: Decodable>(
        path: String,
        fileURL: URL,
        mimeType: String,
        accessToken: String?,
        allowsRefresh: Bool
    ) async throws -> Payload {
        do {
            return try await performMultipart(
                path: path,
                fileURL: fileURL,
                mimeType: mimeType,
                accessToken: accessToken
            )
        } catch let error as SuliJoyLagoonRemoteError where allowsRefresh && error.isUnauthorized {
            try await refreshRemoteSession()
            return try await performMultipart(
                path: path,
                fileURL: fileURL,
                mimeType: mimeType,
                accessToken: sessionVault.suliJoySeasideHeroload().SeasideHeroloaSili
            )
        }
    }

    private func refreshRemoteSession() async throws {
        let sessionState = sessionVault.suliJoySeasideHeroload()
        guard let refreshToken = sessionState.lagoonRefreshPass, !refreshToken.isEmpty else {
            throw SuliJoyLagoonRemoteError.business(code: "401", message: "The session has expired.", requestID: nil)
        }
        let refreshed: SuliJoyLagoonRemoteAuthPayload = try await perform(
            path: SuliJoyRemotePath.tokenRefresh,
            body: SuliJoyRefreshPayload(refreshToken: refreshToken),
            accessToken: nil
        )
        guard !refreshed.accessToken.isEmpty, !refreshed.refreshToken.isEmpty else {
            throw SuliJoyLagoonRemoteError.invalidResponse
        }
        sessionVault.refreshRemoteTokens(
            accessToken: refreshed.accessToken,
            refreshToken: refreshed.refreshToken
        )
    }

    private func perform<Payload: Decodable, Body: Encodable>(
        path: String,
        body: Body,
        accessToken: String?
    ) async throws -> Payload {
        let exchange = try await performEnvelope(path: path, body: body, accessToken: accessToken)
        let plaintext = try decryptResult(exchange, semanticPath: path)
        do {
            return try decoder.decode(Payload.self, from: plaintext)
        } catch {
            SuliJoyLagoonRemoteDebugLogger.decodeFailure(exchange.trace, error: error)
            throw SuliJoyLagoonRemoteError.decoding(error)
        }
    }

    private func performWithoutPayload<Body: Encodable>(
        path: String,
        body: Body,
        accessToken: String?
    ) async throws {
        let exchange = try await performEnvelope(path: path, body: body, accessToken: accessToken)
        guard let result = exchange.envelope.result, !result.isEmpty else {
            SuliJoyLagoonRemoteDebugLogger.finish(
                exchange.trace,
                status: exchange.httpStatus,
                code: exchange.envelope.code,
                message: exchange.envelope.message,
                requestID: exchange.envelope.requestID,
                payload: nil
            )
            return
        }
        _ = try decryptResult(exchange, semanticPath: exchange.semanticPath)
    }

    private func decryptResult(_ exchange: SuliJoyLagoonRemoteExchange, semanticPath: String) throws -> Data {
        let plaintext: Data
        if let hex = exchange.envelope.result, !hex.isEmpty {
            do {
                plaintext = try decryptHex(hex)
            } catch {
                SuliJoyLagoonRemoteDebugLogger.fail(
                    exchange.trace,
                    status: exchange.httpStatus,
                    code: exchange.envelope.code,
                    message: "The result could not be decrypted.",
                    requestID: exchange.envelope.requestID
                )
                throw error
            }
        } else if let payload = exchange.envelope.resultPayload, JSONSerialization.isValidJSONObject(payload) {
            do {
                plaintext = try JSONSerialization.data(withJSONObject: payload)
            } catch {
                throw SuliJoyLagoonRemoteError.decoding(error)
            }
        } else {
            SuliJoyLagoonRemoteDebugLogger.fail(
                exchange.trace,
                status: exchange.httpStatus,
                code: exchange.envelope.code,
                message: "The success envelope has no result.",
                requestID: exchange.envelope.requestID
            )
            throw SuliJoyLagoonRemoteError.invalidResponse
        }
        let semanticPayload = semanticResultData(from: plaintext, semanticPath: semanticPath)
        SuliJoyLagoonRemoteDebugLogger.finish(
            exchange.trace,
            status: exchange.httpStatus,
            code: exchange.envelope.code,
            message: exchange.envelope.message,
            requestID: exchange.envelope.requestID,
            payload: semanticPayload
        )
        return semanticPayload
    }

    private func performMultipart<Payload: Decodable>(
        path: String,
        fileURL: URL,
        mimeType: String,
        accessToken: String?
    ) async throws -> Payload {
        let wirePath = SuliJoyOpiRegistry.aliasPath(for: path)
        guard let url = URL(string: wirePath, relativeTo: configuration.baseURL) else {
            throw SuliJoyLagoonRemoteError.invalidRequest
        }
        let fileData = try? Data(contentsOf: fileURL)
        let trace = SuliJoyLagoonRemoteDebugLogger.beginUpload(
            path: path,
            appID: configuration.appIdentifier,
            deviceNo: configuration.deviceNumber,
            appVersion: configuration.appVersion,
            language: configuration.language,
            hasAuthorization: accessToken?.isEmpty == false,
            fileName: fileURL.lastPathComponent,
            mimeType: mimeType,
            byteCount: fileData?.count ?? 0
        )
        guard let fileData else {
            SuliJoyLagoonRemoteDebugLogger.fail(trace, status: nil, code: "upload", message: "Unable to read the upload file.", requestID: nil)
            throw SuliJoyLagoonRemoteError.invalidRequest
        }
        let boundary = "SuliJoyBoundary-\(UUID().uuidString)"
        var body = Data()
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".utf8))
        body.append(Data("Content-Type: \(mimeType)\r\n\r\n".utf8))
        body.append(fileData)
        body.append(Data("\r\n--\(boundary)--\r\n".utf8))

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        applyOpiHeaders(to: &request, accessToken: accessToken)

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            SuliJoyLagoonRemoteDebugLogger.fail(trace, status: nil, code: "transport", message: error.localizedDescription, requestID: nil)
            throw SuliJoyLagoonRemoteError.transport(error)
        }
        let exchange = try readEnvelope(data: data, response: response, trace: trace, semanticPath: path)
        let plaintext = try decryptResult(exchange, semanticPath: path)
        do {
            return try decoder.decode(Payload.self, from: plaintext)
        } catch {
            SuliJoyLagoonRemoteDebugLogger.decodeFailure(trace, error: error)
            throw SuliJoyLagoonRemoteError.decoding(error)
        }
    }

    private func performEnvelope<Body: Encodable>(
        path: String,
        body: Body,
        accessToken: String?
    ) async throws -> SuliJoyLagoonRemoteExchange {
        let wirePath = SuliJoyOpiRegistry.aliasPath(for: path)
        guard let url = URL(string: wirePath, relativeTo: configuration.baseURL) else {
            throw SuliJoyLagoonRemoteError.invalidRequest
        }
        let plainBody: Data
        do {
            let encoded = try encoder.encode(body)
            if let semantic = try JSONSerialization.jsonObject(with: encoded) as? [String: Any] {
                let wireObject = SuliJoyOpiRegistry.aliasRequestBody(originalPath: path, semantic: semantic)
                plainBody = try JSONSerialization.data(withJSONObject: wireObject)
            } else {
                plainBody = encoded
            }
        } catch {
            throw SuliJoyLagoonRemoteError.encryption(error)
        }
        let trace = SuliJoyLagoonRemoteDebugLogger.begin(
            path: path,
            appID: configuration.appIdentifier,
            deviceNo: configuration.deviceNumber,
            appVersion: configuration.appVersion,
            language: configuration.language,
            hasAuthorization: accessToken?.isEmpty == false,
            body: plainBody
        )
        let encryptedBody: String
        do {
            encryptedBody = try encryptHex(plainBody)
        } catch {
            SuliJoyLagoonRemoteDebugLogger.fail(trace, status: nil, code: "encrypt", message: "The request body could not be encrypted.", requestID: nil)
            throw error
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = encryptedBody.data(using: .utf8)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        applyOpiHeaders(to: &request, accessToken: accessToken)

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            SuliJoyLagoonRemoteDebugLogger.fail(trace, status: nil, code: "transport", message: error.localizedDescription, requestID: nil)
            throw SuliJoyLagoonRemoteError.transport(error)
        }
        return try readEnvelope(data: data, response: response, trace: trace, semanticPath: path)
    }

    private func applyOpiHeaders(to request: inout URLRequest, accessToken: String?) {
        request.setValue(configuration.appIdentifier, forHTTPHeaderField: SuliJoyOpiRegistry.headerWireName(for: "appId"))
        request.setValue(configuration.deviceNumber, forHTTPHeaderField: SuliJoyOpiRegistry.headerWireName(for: "deviceNo"))
        request.setValue(configuration.appVersion, forHTTPHeaderField: SuliJoyOpiRegistry.headerWireName(for: "appVersion"))
        request.setValue(configuration.language, forHTTPHeaderField: SuliJoyOpiRegistry.headerWireName(for: "language"))
        if let accessToken, !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.setValue(accessToken, forHTTPHeaderField: SuliJoyOpiRegistry.headerWireName(for: "loginToken"))
        }
    }

    private func semanticResultData(from plaintext: Data, semanticPath: String) -> Data {
        guard
            let wireObject = try? JSONSerialization.jsonObject(with: plaintext),
            JSONSerialization.isValidJSONObject(wireObject)
        else {
            return plaintext
        }
        let semantic = SuliJoyOpiRegistry.semanticResponseBody(originalPath: semanticPath, wire: wireObject)
        guard JSONSerialization.isValidJSONObject(semantic) else { return plaintext }
        return (try? JSONSerialization.data(withJSONObject: semantic)) ?? plaintext
    }

    private func readEnvelope(
        data: Data,
        response: URLResponse,
        trace: SuliJoyLagoonRemoteDebugLogger.Trace,
        semanticPath: String
    ) throws -> SuliJoyLagoonRemoteExchange {
        guard let httpResponse = response as? HTTPURLResponse else {
            SuliJoyLagoonRemoteDebugLogger.fail(trace, status: nil, code: "http", message: "Missing HTTP response.", requestID: nil)
            throw SuliJoyLagoonRemoteError.invalidResponse
        }
        let envelope: SuliJoyLagoonEnvelope
        do {
            guard let wire = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                throw SuliJoyLagoonRemoteError.invalidResponse
            }
            envelope = SuliJoyLagoonEnvelope(wire: wire)
        } catch {
            SuliJoyLagoonRemoteDebugLogger.fail(trace, status: httpResponse.statusCode, code: "envelope", message: "The response envelope could not be read.", requestID: nil)
            throw SuliJoyLagoonRemoteError.decoding(error)
        }
        guard envelope.code == "0" else {
            let failureCode = envelope.code.isEmpty ? String(httpResponse.statusCode) : envelope.code
            SuliJoyLagoonRemoteDebugLogger.fail(
                trace,
                status: httpResponse.statusCode,
                code: failureCode,
                message: envelope.message,
                requestID: envelope.requestID
            )
            throw SuliJoyLagoonRemoteError.business(
                code: failureCode,
                message: envelope.message,
                requestID: envelope.requestID
            )
        }
        return SuliJoyLagoonRemoteExchange(
            envelope: envelope,
            trace: trace,
            httpStatus: httpResponse.statusCode,
            semanticPath: semanticPath
        )
    }

    private func encryptHex(_ plainBody: Data) throws -> String {
        let encrypted = try crypt(plainBody, operation: CCOperation(kCCEncrypt))
        return encrypted.map { String(format: "%02x", $0) }.joined()
    }

    private func decryptHex(_ encryptedValue: String) throws -> Data {
        guard encryptedValue.count.isMultiple(of: 2),
              let encrypted = Data(hexadecimal: encryptedValue) else {
            throw SuliJoyLagoonRemoteError.invalidResponse
        }
        return try crypt(encrypted, operation: CCOperation(kCCDecrypt))
    }

    private func crypt(_ data: Data, operation: CCOperation) throws -> Data {
        let key = Array(configuration.encryptionKey.utf8)
        let iv = Array(configuration.encryptionIV.utf8)
        let input = Array(data)
        guard key.count == kCCKeySizeAES128, iv.count == kCCBlockSizeAES128 else {
            throw SuliJoyLagoonRemoteError.invalidRequest
        }
        var output = [UInt8](repeating: 0, count: input.count + kCCBlockSizeAES128)
        let outputCapacity = output.count
        var outputLength = 0
        let status = key.withUnsafeBytes { keyBuffer in
            iv.withUnsafeBytes { ivBuffer in
                input.withUnsafeBytes { inputBuffer in
                    output.withUnsafeMutableBytes { outputBuffer in
                        CCCrypt(
                            operation,
                            CCAlgorithm(kCCAlgorithmAES),
                            CCOptions(kCCOptionPKCS7Padding),
                            keyBuffer.baseAddress,
                            key.count,
                            ivBuffer.baseAddress,
                            inputBuffer.baseAddress,
                            input.count,
                            outputBuffer.baseAddress,
                            outputCapacity,
                            &outputLength
                        )
                    }
                }
            }
        }
        guard status == kCCSuccess else {
            throw SuliJoyLagoonRemoteError.invalidResponse
        }
        return Data(output.prefix(outputLength))
    }
}

private extension Data {
    init?(hexadecimal value: String) {
        let characters = Array(value)
        guard characters.count.isMultiple(of: 2) else { return nil }
        var bytes = [UInt8]()
        bytes.reserveCapacity(characters.count / 2)
        for index in stride(from: 0, to: characters.count, by: 2) {
            let pair = String(characters[index...index + 1])
            guard let byte = UInt8(pair, radix: 16) else { return nil }
            bytes.append(byte)
        }
        self.init(bytes)
    }
}

private struct SuliJoyLagoonRemoteFlexibleKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}

private extension KeyedDecodingContainer where Key == SuliJoyLagoonRemoteFlexibleKey {
    func suliJoyFlexibleText(_ keys: String...) -> String {
        for key in keys {
            guard let codingKey = SuliJoyLagoonRemoteFlexibleKey(stringValue: key) else { continue }
            let line = suliJoyText(forKey: codingKey)
            if !line.isEmpty { return line }
        }
        return ""
    }
}

private extension KeyedDecodingContainer {
    func suliJoyText(forKey key: Key) -> String {
        if let value = try? decode(String.self, forKey: key) { return value }
        if let value = try? decode(Int64.self, forKey: key) { return String(value) }
        if let value = try? decode(Double.self, forKey: key) { return String(value) }
        return ""
    }

    func suliJoyInt64(forKey key: Key) -> Int64 {
        if let value = try? decode(Int64.self, forKey: key) { return value }
        if let value = try? decode(Int.self, forKey: key) { return Int64(value) }
        if let value = try? decode(String.self, forKey: key) { return Int64(value) ?? 0 }
        return 0
    }

    func suliJoyInt(forKey key: Key) -> Int {
        Int(suliJoyInt64(forKey: key))
    }

    func suliJoyBool(forKey key: Key) -> Bool {
        if let value = try? decode(Bool.self, forKey: key) { return value }
        return suliJoyInt(forKey: key) != 0
    }

    func suliJoyBoolOrInt(forKey key: Key) -> Bool {
        suliJoyBool(forKey: key)
    }
}
