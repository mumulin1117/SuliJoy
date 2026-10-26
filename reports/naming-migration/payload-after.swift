import Foundation
private struct shorePlaceInput: Encodable {
        let email: String
        let password: String
        let onReefCancel: String
    private enum CodingKeys: String, CodingKey {
        case email = "email"
        case password = "password"
        case onReefCancel = "deviceNo"
    }

    }
private struct tuneReefLaunchStack: Encodable {
        let sendComment: String
    private enum CodingKeys: String, CodingKey {
        case sendComment = "refreshToken"
    }

    }
private struct driftSuliJoybackTopriorCove: Encodable {
        let collage: String
        let ShellWardrobeEntry: String
        let icon: String?
    private enum CodingKeys: String, CodingKey {
        case collage = "nickname"
        case ShellWardrobeEntry = "signature"
        case icon = "icon"
    }

    }
private struct openShoreTimeWheel: Encodable {}
private struct ensureTestProfile: Encodable {
        let userID: Int64

        private enum CodingKeys: String, CodingKey {
            case userID = "userId"
        }
    }
private struct coverBadgeView: Encodable {
        let publishCenterLift: Int64
        let backdrop: Int

        private enum CodingKeys: String, CodingKey {
            case publishCenterLift = "followUserId"
            case backdrop = "followType"
        }
    }
private struct makeReadyIslandBackdrop: Encodable {
        let tuneTideConfirm: Int
        let reefContentView: Int
    private enum CodingKeys: String, CodingKey {
        case tuneTideConfirm = "cursor"
        case reefContentView = "limit"
    }

    }
private struct assembleReefLaunchCard: Encodable {
        let cardSide: String
        let tuneTideConfirm: Int
        let reefContentView: Int
    private enum CodingKeys: String, CodingKey {
        case cardSide = "conversationId"
        case tuneTideConfirm = "cursor"
        case reefContentView = "limit"
    }

    }
private struct pearlMarkShell: Encodable {
        let cardSide: String
        let kind: String
        let text: String
        let shorelineAvatarPool: String
    private enum CodingKeys: String, CodingKey {
        case cardSide = "conversationId"
        case kind = "kind"
        case text = "text"
        case shorelineAvatarPool = "clientMessageId"
    }

    }
private struct ReefCardMeasure: Encodable {
        let cardSide: String
    private enum CodingKeys: String, CodingKey {
        case cardSide = "conversationId"
    }

    }
private struct openCoverReefPicker: Encodable {
        let crownBundle: String
    private enum CodingKeys: String, CodingKey {
        case crownBundle = "userId"
    }

    }
private struct makeReadyIslandTitle: Encodable {
        let userID: Int64
        let partial: Int

        private enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case partial = "type"
        }
    }
let encoder = JSONEncoder()
encoder.outputFormatting = [.sortedKeys]
let value0 = try encoder.encode(shorePlaceInput(email: "fixture", password: "fixture", onReefCancel: "fixture"))
print("SuliJoyEmailPayload:" + String(data: value0, encoding: .utf8)!)
let value1 = try encoder.encode(tuneReefLaunchStack(sendComment: "fixture"))
print("SuliJoyRefreshPayload:" + String(data: value1, encoding: .utf8)!)
let value2 = try encoder.encode(driftSuliJoybackTopriorCove(collage: "fixture", ShellWardrobeEntry: "fixture", icon: "fixture"))
print("SuliJoyProfilePayload:" + String(data: value2, encoding: .utf8)!)
let value3 = try encoder.encode(openShoreTimeWheel())
print("SuliJoyEmptyPayload:" + String(data: value3, encoding: .utf8)!)
let value4 = try encoder.encode(ensureTestProfile(userID: 7))
print("SuliJoyUserIDPayload:" + String(data: value4, encoding: .utf8)!)
let value5 = try encoder.encode(coverBadgeView(publishCenterLift: 7, backdrop: 7))
print("SuliJoyUserFollowPayload:" + String(data: value5, encoding: .utf8)!)
let value6 = try encoder.encode(makeReadyIslandBackdrop(tuneTideConfirm: 7, reefContentView: 7))
print("SuliJoyLetterListPayload:" + String(data: value6, encoding: .utf8)!)
let value7 = try encoder.encode(assembleReefLaunchCard(cardSide: "fixture", tuneTideConfirm: 7, reefContentView: 7))
print("SuliJoyLetterHistoryPayload:" + String(data: value7, encoding: .utf8)!)
let value8 = try encoder.encode(pearlMarkShell(cardSide: "fixture", kind: "fixture", text: "fixture", shorelineAvatarPool: "fixture"))
print("SuliJoyLetterSendPayload:" + String(data: value8, encoding: .utf8)!)
let value9 = try encoder.encode(ReefCardMeasure(cardSide: "fixture"))
print("SuliJoyLetterReadPayload:" + String(data: value9, encoding: .utf8)!)
let value10 = try encoder.encode(openCoverReefPicker(crownBundle: "fixture"))
print("SuliJoyLetterOpenPayload:" + String(data: value10, encoding: .utf8)!)
let value11 = try encoder.encode(makeReadyIslandTitle(userID: 7, partial: 7))
print("SuliJoyUserBlockPayload:" + String(data: value11, encoding: .utf8)!)
