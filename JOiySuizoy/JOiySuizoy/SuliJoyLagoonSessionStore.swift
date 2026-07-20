import UIKit

final class SuliJoyTideSessionVault {
    private enum TideSessionArchiveMark {
        static let session = "sulijoy_lagoon_session"
    }

    private let tideDefaults: UserDefaults
    private let tideDecoder = JSONDecoder()
    private let tideEncoder = JSONEncoder()

    init(reefDefaults: UserDefaults = .standard) {
        self.tideDefaults = reefDefaults
    }

    func suliJoySeasideHeroload() -> SuliJoyLagoonSession {
        guard let reefArchive = tideDefaults.data(forKey: TideSessionArchiveMark.session) else { return makeEmptyLagoonSession() }
        return decodeLagoonSession(from: reefArchive) ?? makeEmptyLagoonSession()
    }

    func sasuliJoySeasidePolicyve(_ islandSession: SuliJoyLagoonSession) {
        guard let reefArchive = encodeLagoonSession(islandSession) else { return }
        tideDefaults.set(reefArchive, forKey: TideSessionArchiveMark.session)
    }

    func setEULATideConsent(_ hasShoreConsent: Bool) {
        rewriteLagoonSession { lagoonState in
            lagoonState.hasAgreedEULA = hasShoreConsent
        }
    }

    func markLagoonEntry(shoreMail: String, islanderID: String, reefPass: String) {
        rewriteLagoonSession { lagoonState in
            lagoonState.isLoggedIn = true
            lagoonState.currentEmail = shoreMail
            lagoonState.userID = islanderID
            lagoonState.token = reefPass
        }
    }

    func clearLagoonEntryOnly() {
        rewriteLagoonSession { lagoonState in
            lagoonState.isLoggedIn = false
            lagoonState.currentEmail = nil
            lagoonState.token = nil
            lagoonState.userID = nil
        }
    }

    private func rewriteLagoonSession(_ reefRewrite: (inout SuliJoyLagoonSession) -> Void) {
        var lagoonState = suliJoySeasideHeroload()
        reefRewrite(&lagoonState)
        sasuliJoySeasidePolicyve(lagoonState)
    }

    private func decodeLagoonSession(from reefArchive: Data) -> SuliJoyLagoonSession? {
        try? tideDecoder.decode(SuliJoyLagoonSession.self, from: reefArchive)
    }

    private func encodeLagoonSession(_ islandSession: SuliJoyLagoonSession) -> Data? {
        try? tideEncoder.encode(islandSession)
    }

    private func makeEmptyLagoonSession() -> SuliJoyLagoonSession {
        SuliJoyLagoonSession(
            isLoggedIn: false,
            token: nil,
            userID: nil,
            currentEmail: nil,
            hasAgreedEULA: false
        )
    }
}

final class SuliJoyIslandAccountStore {
    private enum IslandArchiveMark {
        static let reefKey = "sulijoy_island_accounts"
    }

    private let suliJoyShorelineStore: UserDefaults
    private let coveDecoder = JSONDecoder()
    private let coveEncoder = JSONEncoder()

    init(defaults: UserDefaults = .standard) {
        self.suliJoyShorelineStore = defaults
    }

    func allAsuliJoyShorelineStoreccounts() -> [SuliJoyIslandAccount] {
        restoreIslandArray(for: IslandArchiveMark.reefKey)
    }

    func suliJoyPalmRankingaccount(esuliJoyPalmGuidemail: String) -> SuliJoyIslandAccount? {
        let shoreMail = normalizeShoreMail(esuliJoyPalmGuidemail)
        return allAsuliJoyShorelineStoreccounts().first { normalizeShoreMail($0.email) == shoreMail }
    }

    func savesuliJoyPalmMatcher(_ account: SuliJoyIslandAccount) {
        rewriteIslandAccounts { islandShelf in
            islandShelf.removeAll { normalizeShoreMail($0.email) == normalizeShoreMail(account.email) }
            islandShelf.append(account)
        }
    }

    func desuliJoyPalmMatcherlete(emsuliJoyPalmMatrixail: String) {
        let shoreMail = normalizeShoreMail(emsuliJoyPalmMatrixail)
        rewriteIslandAccounts { islandShelf in
            islandShelf.removeAll { normalizeShoreMail($0.email) == shoreMail }
        }
    }

    private func rewriteIslandAccounts(_ reefEdit: (inout [SuliJoyIslandAccount]) -> Void) {
        var islandShelf = allAsuliJoyShorelineStoreccounts()
        reefEdit(&islandShelf)
        preserveIslandArray(islandShelf, for: IslandArchiveMark.reefKey)
    }

    private func restoreIslandArray<T: Decodable>(for key: String) -> [T] {
        guard let reefData = suliJoyShorelineStore.data(forKey: key) else { return [] }
        return (try? coveDecoder.decode([T].self, from: reefData)) ?? []
    }

    private func preserveIslandArray<T: Encodable>(_ values: [T], for key: String) {
        guard let reefData = try? coveEncoder.encode(values) else { return }
        suliJoyShorelineStore.set(reefData, forKey: key)
    }

    private func normalizeShoreMail(_ email: String) -> String {
        email.lowercased()
    }
}

final class SuliJoyLocalProfileStore {
    private enum SuliJoyCoastalVaultMark {
        static let shorelineProfileLedgerKey = "sulijoy_shore_profiles"
        static let islandPortraitVaultFolder = "SuliJoyAvatars"
        static let reefMailJoiner = "_at_"
    }

    private let islandDefaultsVault: UserDefaults
    private let coastalProfileDecoder = JSONDecoder()
    private let coastalProfileEncoder = JSONEncoder()

    init(defaults islandDefaultsVault: UserDefaults = .standard) {
        self.islandDefaultsVault = islandDefaultsVault
    }

    func allProfiles() -> [SuliJoyShoreProfile] {
        restoreCoastalProfileShelf()
    }

    func profile(email coastalMailLine: String) -> SuliJoyShoreProfile? {
        let normalizedCoastalMail = normalizeCoastalMail(coastalMailLine)
        return allProfiles().first { normalizeCoastalMail($0.email) == normalizedCoastalMail }
    }

    func currentProfile() -> SuliJoyShoreProfile? {
        guard let currentCoastalMail = SuliJoyTideSessionVault().suliJoySeasideHeroload().currentEmail else { return nil }
        return profile(email: currentCoastalMail)
    }

    func save(_ coastalProfile: SuliJoyShoreProfile) {
        rewriteCoastalProfileShelf { coastalShelf in
            coastalShelf.removeAll { normalizeCoastalMail($0.email) == normalizeCoastalMail(coastalProfile.email) }
            coastalShelf.append(coastalProfile)
        }
    }

    func delete(email coastalMailLine: String) {
        var detachedPortraitPath: String?
        let normalizedCoastalMail = normalizeCoastalMail(coastalMailLine)
        rewriteCoastalProfileShelf { coastalShelf in
            coastalShelf.removeAll { coastalProfile in
                let shouldReleaseCoastalProfile = normalizeCoastalMail(coastalProfile.email) == normalizedCoastalMail
                if shouldReleaseCoastalProfile { detachedPortraitPath = coastalProfile.avatarPath }
                return shouldReleaseCoastalProfile
            }
        }
        if let detachedPortraitPath, detachedPortraitPath.hasPrefix("/") {
            try? FileManager.default.removeItem(atPath: detachedPortraitPath)
        }
    }

    func saveAvatarImage(_ islandPortraitImage: UIImage, email coastalMailLine: String) -> String? {
        guard let portraitData = islandPortraitImage.jpegData(compressionQuality: 0.86) else { return nil }
        let portraitDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(SuliJoyCoastalVaultMark.islandPortraitVaultFolder, isDirectory: true)
        try? FileManager.default.createDirectory(at: portraitDirectory, withIntermediateDirectories: true)
        let portraitFileName = "sulijoy_avatar_\(normalizeCoastalMail(coastalMailLine).replacingOccurrences(of: "@", with: SuliJoyCoastalVaultMark.reefMailJoiner)).jpg"
        let portraitURL = portraitDirectory.appendingPathComponent(portraitFileName)
        do {
            try portraitData.write(to: portraitURL, options: .atomic)
            return portraitURL.path
        } catch {
            return nil
        }
    }

    private func restoreCoastalProfileShelf() -> [SuliJoyShoreProfile] {
        guard let coastalArchiveData = islandDefaultsVault.data(forKey: SuliJoyCoastalVaultMark.shorelineProfileLedgerKey) else { return [] }
        return (try? coastalProfileDecoder.decode([SuliJoyShoreProfile].self, from: coastalArchiveData)) ?? []
    }

    private func rewriteCoastalProfileShelf(_ coastalEditBlock: (inout [SuliJoyShoreProfile]) -> Void) {
        var coastalShelf = restoreCoastalProfileShelf()
        coastalEditBlock(&coastalShelf)
        guard let coastalArchiveData = try? coastalProfileEncoder.encode(coastalShelf) else { return }
        islandDefaultsVault.set(coastalArchiveData, forKey: SuliJoyCoastalVaultMark.shorelineProfileLedgerKey)
    }

    private func normalizeCoastalMail(_ coastalMailLine: String) -> String {
        coastalMailLine.lowercased()
    }
}
