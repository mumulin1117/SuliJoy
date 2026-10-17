import Foundation
import UIKit

enum SuliJoyRoomShellKind: String {
    case live
    case voice

    var routePrefix: String {
        switch self {
        case .live: return "/live"
        case .voice: return "/voice"
        }
    }
}

struct SuliJoyRoomShellCredentials {
    let token: String
    let userID: String
    let appVersion: String
    let deviceNo: String
    let locale: String?

    static func fromCurrentSession(configuration: SuliJoyLagoonRemoteConfiguration = .shared) -> SuliJoyRoomShellCredentials? {
        let session = SuliJoyTideSessionVault().suliJoySeasideHeroload()
        guard session.flaggedLagoonVisitorslo else { return nil }
        guard let rawToken = session.SeasideHeroloaSili?.trimmingCharacters(in: .whitespacesAndNewlines), !rawToken.isEmpty else {
            return nil
        }
        guard let userID = session.sasuliJoySeasideDress?.trimmingCharacters(in: .whitespacesAndNewlines), !userID.isEmpty else {
            return nil
        }
        var token = rawToken
        if token.lowercased().hasPrefix("bearer ") {
            token = String(token.dropFirst(7)).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        let locale = normalizeRoomLocale(configuration.language)
        return SuliJoyRoomShellCredentials(
            token: token,
            userID: userID,
            appVersion: configuration.appVersion,
            deviceNo: configuration.deviceNumber,
            locale: locale
        )
    }

    private static func normalizeRoomLocale(_ language: String) -> String? {
        let trimmed = language.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        if trimmed.contains("-") {
            return String(trimmed.split(separator: "-").first ?? Substring(trimmed))
        }
        return trimmed
    }
}

enum SuliJoyRoomShellBundleLocator {
    private static let folderName = "RoomShellH5"

    static func distDirectoryURL() -> URL? {
        if let folder = Bundle.main.url(forResource: folderName, withExtension: nil) {
            return folder
        }
        guard let resourceRoot = Bundle.main.resourceURL else { return nil }
        let candidate = resourceRoot.appendingPathComponent(folderName, isDirectory: true)
        guard FileManager.default.fileExists(atPath: candidate.path) else { return nil }
        return candidate
    }

    static func indexFileURL() -> URL? {
        guard let dist = distDirectoryURL() else { return nil }
        let index = dist.appendingPathComponent("index.html")
        guard FileManager.default.fileExists(atPath: index.path) else { return nil }
        return index
    }

    static func buildEntryURL(roomKind: SuliJoyRoomShellKind, roomID: String, credentials: SuliJoyRoomShellCredentials) -> URL? {
        guard let indexURL = indexFileURL(), !roomID.isEmpty else { return nil }
        var queryItems = [
            URLQueryItem(name: "token", value: credentials.token),
            URLQueryItem(name: "userId", value: credentials.userID),
            URLQueryItem(name: "appVersion", value: credentials.appVersion),
            URLQueryItem(name: "deviceNo", value: credentials.deviceNo),
        ]
        if let locale = credentials.locale, !locale.isEmpty {
            queryItems.append(URLQueryItem(name: "locale", value: locale))
        }
        var components = URLComponents()
        components.queryItems = queryItems
        let query = components.percentEncodedQuery ?? ""
        let route = "\(roomKind.routePrefix)/\(roomID)"
        let fragment = query.isEmpty ? route : "\(route)?\(query)"
        var urlString = indexURL.absoluteString
        if !urlString.contains("index.html") {
            urlString = urlString.hasSuffix("/") ? urlString + "index.html" : urlString + "/index.html"
        }
        urlString += "#\(fragment)"
        return URL(string: urlString)
    }
}

enum SuliJoyRoomShellNavigator {
    static func openRoom(
        kind: SuliJoyRoomShellKind,
        roomID: String,
        from presenter: UIViewController,
        animated: Bool = true
    ) {
        guard let credentials = SuliJoyRoomShellCredentials.fromCurrentSession() else {
            lagoonToast("Please sign in to enter this room.", on: presenter)
            return
        }
        guard SuliJoyRoomShellBundleLocator.buildEntryURL(roomKind: kind, roomID: roomID, credentials: credentials) != nil else {
            lagoonToast("The room experience is unavailable.", on: presenter)
            return
        }
        let page = SuliJoyRoomShellWebController(roomKind: kind, roomID: roomID, credentials: credentials)
        page.hidesBottomBarWhenPushed = true
        presenter.navigationController?.pushViewController(page, animated: animated)
    }

    private static func lagoonToast(_ message: String, on presenter: UIViewController) {
        if let canvas = presenter as? SuliJoyTropicCanvasController {
            canvas.showLagoonToast(message)
        }
    }
}
