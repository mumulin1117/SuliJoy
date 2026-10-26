import Foundation
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
let encoder = JSONEncoder()
encoder.outputFormatting = [.sortedKeys]
let value0 = try encoder.encode(SuliJoyEmailPayload(email: "fixture", password: "fixture", deviceNo: "fixture"))
print("SuliJoyEmailPayload:" + String(data: value0, encoding: .utf8)!)
let value1 = try encoder.encode(SuliJoyRefreshPayload(refreshToken: "fixture"))
print("SuliJoyRefreshPayload:" + String(data: value1, encoding: .utf8)!)
let value2 = try encoder.encode(SuliJoyProfilePayload(nickname: "fixture", signature: "fixture", icon: "fixture"))
print("SuliJoyProfilePayload:" + String(data: value2, encoding: .utf8)!)
let value3 = try encoder.encode(SuliJoyEmptyPayload())
print("SuliJoyEmptyPayload:" + String(data: value3, encoding: .utf8)!)
let value4 = try encoder.encode(SuliJoyUserIDPayload(userID: 7))
print("SuliJoyUserIDPayload:" + String(data: value4, encoding: .utf8)!)
let value5 = try encoder.encode(SuliJoyUserFollowPayload(followUserID: 7, followType: 7))
print("SuliJoyUserFollowPayload:" + String(data: value5, encoding: .utf8)!)
let value6 = try encoder.encode(SuliJoyLetterListPayload(cursor: 7, limit: 7))
print("SuliJoyLetterListPayload:" + String(data: value6, encoding: .utf8)!)
let value7 = try encoder.encode(SuliJoyLetterHistoryPayload(conversationId: "fixture", cursor: 7, limit: 7))
print("SuliJoyLetterHistoryPayload:" + String(data: value7, encoding: .utf8)!)
let value8 = try encoder.encode(SuliJoyLetterSendPayload(conversationId: "fixture", kind: "fixture", text: "fixture", clientMessageId: "fixture"))
print("SuliJoyLetterSendPayload:" + String(data: value8, encoding: .utf8)!)
let value9 = try encoder.encode(SuliJoyLetterReadPayload(conversationId: "fixture"))
print("SuliJoyLetterReadPayload:" + String(data: value9, encoding: .utf8)!)
let value10 = try encoder.encode(SuliJoyLetterOpenPayload(userId: "fixture"))
print("SuliJoyLetterOpenPayload:" + String(data: value10, encoding: .utf8)!)
let value11 = try encoder.encode(SuliJoyUserBlockPayload(userID: 7, type: 7))
print("SuliJoyUserBlockPayload:" + String(data: value11, encoding: .utf8)!)
