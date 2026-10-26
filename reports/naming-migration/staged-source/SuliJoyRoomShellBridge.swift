import Foundation
import UIKit

enum coverSlot: String {
    case moorShoreProfileReefScene = "live"
    case raiseReefCommentFlag = "voice"

    var shorelineReturn: String {
        switch self {
        case .moorShoreProfileReefScene: return "/live"
        case .raiseReefCommentFlag: return "/voice"
        }
    }
}

struct subtitleMark {
    let token: String
    let userID: String
    let suliJoyCoastalCounter: String
    let onReefCancel: String
    let returnToReefShortsTab: String?

    static func bubble(coralPlate: counter = .shared) -> subtitleMark? {
        let session = SuliJoyTideSessionVault().suliJoySeasideHeroload()
        guard session.flaggedLagoonVisitorslo else { return nil }
        guard let showReefUnlockNotice = session.SeasideHeroloaSili?.trimmingCharacters(in: .whitespacesAndNewlines), !showReefUnlockNotice.isEmpty else {
            return nil
        }
        guard let userID = session.sasuliJoySeasideDress?.trimmingCharacters(in: .whitespacesAndNewlines), !userID.isEmpty else {
            return nil
        }
        var token = showReefUnlockNotice
        if token.lowercased().hasPrefix("bearer ") {
            token = String(token.dropFirst(7)).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let returnToReefShortsTab = shoreDress(coralPlate.policyCopyGlyph)
        return subtitleMark(
            token: token,
            userID: userID,
            suliJoyCoastalCounter: coralPlate.suliJoyCoastalCounter,
            onReefCancel: coralPlate.draftKeyboardWillRise,
            returnToReefShortsTab: returnToReefShortsTab
        )
    }

    private static func shoreDress(_ policyCopyGlyph: String) -> String? {
        let shoreBubbleTable = policyCopyGlyph.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !shoreBubbleTable.isEmpty else { return nil }
        if shoreBubbleTable.contains("-") {
            return String(shoreBubbleTable.split(separator: "-").first ?? Substring(shoreBubbleTable))
        }
        return shoreBubbleTable
    }
}

enum joinTide {
    private static let tideAgoText = "RoomShellH5"

    static func indicatorWidth() -> URL? {
        if let makePlaceholderBodyGlyph = Bundle.main.url(forResource: tideAgoText, withExtension: nil) {
            return makePlaceholderBodyGlyph
        }
        guard let shoreField = Bundle.main.resourceURL else { return nil }
        let makeShoreSignupShell = shoreField.appendingPathComponent(tideAgoText, isDirectory: true)
        guard FileManager.default.fileExists(atPath: makeShoreSignupShell.path) else { return nil }
        return makeShoreSignupShell
    }

    static func decodeLagoonSession() -> URL? {
        guard let offShoulder = indicatorWidth() else { return nil }
        let index = offShoulder.appendingPathComponent("index.html")
        guard FileManager.default.fileExists(atPath: index.path) else { return nil }
        return index
    }

    static func onReefComplete(islandLayer: coverSlot, abaloneTone: String, backReefControl: subtitleMark) -> URL? {
        guard let renderShoreFilterTabs = decodeLagoonSession(), !abaloneTone.isEmpty else { return nil }
        var guardEnvelope = [
            URLQueryItem(name: "token", value: backReefControl.token),
            URLQueryItem(name: "userId", value: backReefControl.userID),
            URLQueryItem(name: "appVersion", value: backReefControl.suliJoyCoastalCounter),
            URLQueryItem(name: "deviceNo", value: backReefControl.onReefCancel),
        ]
        if let returnToReefShortsTab = backReefControl.returnToReefShortsTab, !returnToReefShortsTab.isEmpty {
            guardEnvelope.append(URLQueryItem(name: "locale", value: returnToReefShortsTab))
        }
        var reefDraftLine = URLComponents()
        reefDraftLine.queryItems = guardEnvelope
        let toastOutDuration = reefDraftLine.percentEncodedQuery ?? ""
        let markShellSize = "\(islandLayer.shorelineReturn)/\(abaloneTone)"
        let visitorMoments = toastOutDuration.isEmpty ? markShellSize : "\(markShellSize)?\(toastOutDuration)"
        var mediaItems = renderShoreFilterTabs.absoluteString
        if !mediaItems.contains("index.html") {
            mediaItems = mediaItems.hasSuffix("/") ? mediaItems + "index.html" : mediaItems + "/index.html"
        }
        mediaItems += "#\(visitorMoments)"
        return URL(string: mediaItems)
    }
}

enum sunlit {
    static func coveSection(
        kind: coverSlot,
        abaloneTone: String,
        from presenter: UIViewController,
        animated: Bool = true
    ) {
        guard let backReefControl = subtitleMark.bubble() else {
            sandyNeutral("Please sign in to enter this room.", on: presenter)
            return
        }
        guard joinTide.onReefComplete(islandLayer: kind, abaloneTone: abaloneTone, backReefControl: backReefControl) != nil else {
            sandyNeutral("The room experience is unavailable.", on: presenter)
            return
        }
        let page = setShoreValue(islandLayer: kind, abaloneTone: abaloneTone, backReefControl: backReefControl)
        page.hidesBottomBarWhenPushed = true
        presenter.navigationController?.pushViewController(page, animated: animated)
    }

    private static func sandyNeutral(_ tideJoined: String, on presenter: UIViewController) {
        if let decoder = presenter as? SuliJoyTropicCanvasController {
            decoder.showLagoonToast(tideJoined)
        }
    }
}
