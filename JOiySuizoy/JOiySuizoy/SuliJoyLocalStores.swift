import UIKit

final class SuliJoyLagoonSessionStore {
    private let defaults: UserDefaults
    private let key = "sulijoy_lagoon_session"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> SuliJoyLagoonSession {
        guard
            let data = defaults.data(forKey: key),
            let session = try? JSONDecoder().decode(SuliJoyLagoonSession.self, from: data)
        else {
            return SuliJoyLagoonSession(isLoggedIn: false, token: nil, userID: nil, currentEmail: nil, hasAgreedEULA: false)
        }
        return session
    }

    func save(_ session: SuliJoyLagoonSession) {
        guard let data = try? JSONEncoder().encode(session) else { return }
        defaults.set(data, forKey: key)
    }

    func setEULAAgreed(_ agreed: Bool) {
        var session = load()
        session.hasAgreedEULA = agreed
        save(session)
    }

    func saveLogin(email: String, userID: String, token: String) {
        var session = load()
        session.isLoggedIn = true
        session.currentEmail = email
        session.userID = userID
        session.token = token
        save(session)
    }

    func logoutOnly() {
        var session = load()
        session.isLoggedIn = false
        session.currentEmail = nil
        session.token = nil
        session.userID = nil
        save(session)
    }
}

final class SuliJoyIslandAccountStore {
    private let defaults: UserDefaults
    private let key = "sulijoy_island_accounts"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func allAccounts() -> [SuliJoyIslandAccount] {
        guard
            let data = defaults.data(forKey: key),
            let accounts = try? JSONDecoder().decode([SuliJoyIslandAccount].self, from: data)
        else { return [] }
        return accounts
    }

    func account(email: String) -> SuliJoyIslandAccount? {
        allAccounts().first { $0.email.lowercased() == email.lowercased() }
    }

    func save(_ account: SuliJoyIslandAccount) {
        var accounts = allAccounts().filter { $0.email.lowercased() != account.email.lowercased() }
        accounts.append(account)
        guard let data = try? JSONEncoder().encode(accounts) else { return }
        defaults.set(data, forKey: key)
    }

    func delete(email: String) {
        let accounts = allAccounts().filter { $0.email.lowercased() != email.lowercased() }
        guard let data = try? JSONEncoder().encode(accounts) else { return }
        defaults.set(data, forKey: key)
    }
}

final class SuliJoyLocalProfileStore {
    private let defaults: UserDefaults
    private let key = "sulijoy_shore_profiles"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func allProfiles() -> [SuliJoyShoreProfile] {
        guard
            let data = defaults.data(forKey: key),
            let profiles = try? JSONDecoder().decode([SuliJoyShoreProfile].self, from: data)
        else { return [] }
        return profiles
    }

    func profile(email: String) -> SuliJoyShoreProfile? {
        allProfiles().first { $0.email.lowercased() == email.lowercased() }
    }

    func currentProfile() -> SuliJoyShoreProfile? {
        guard let email = SuliJoyLagoonSessionStore().load().currentEmail else { return nil }
        return profile(email: email)
    }

    func save(_ profile: SuliJoyShoreProfile) {
        var profiles = allProfiles().filter { $0.email.lowercased() != profile.email.lowercased() }
        profiles.append(profile)
        guard let data = try? JSONEncoder().encode(profiles) else { return }
        defaults.set(data, forKey: key)
    }

    func delete(email: String) {
        var removedAvatarPath: String?
        let profiles = allProfiles().filter { profile in
            let shouldKeep = profile.email.lowercased() != email.lowercased()
            if !shouldKeep {
                removedAvatarPath = profile.avatarPath
            }
            return shouldKeep
        }
        guard let data = try? JSONEncoder().encode(profiles) else { return }
        defaults.set(data, forKey: key)
        if let removedAvatarPath, removedAvatarPath.hasPrefix("/") {
            try? FileManager.default.removeItem(atPath: removedAvatarPath)
        }
    }

    func saveAvatarImage(_ image: UIImage, email: String) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.86) else { return nil }
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("SuliJoyAvatars", isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let fileName = "sulijoy_avatar_\(email.lowercased().replacingOccurrences(of: "@", with: "_at_")).jpg"
        let url = directory.appendingPathComponent(fileName)
        do {
            try data.write(to: url, options: .atomic)
            return url.path
        } catch {
            return nil
        }
    }
}
