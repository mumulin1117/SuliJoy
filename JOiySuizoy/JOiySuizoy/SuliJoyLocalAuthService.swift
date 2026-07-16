import UIKit

final class SuliJoyLocalAuthService {
    static let shared = SuliJoyLocalAuthService()

    private let sessionStore: SuliJoyLagoonSessionStore
    private let accountStore: SuliJoyIslandAccountStore
    private let profileStore: SuliJoyLocalProfileStore

    private let testEmail = "litest@gmail.com"
    private let testPassword = "000000"

    init(
        sessionStore: SuliJoyLagoonSessionStore = SuliJoyLagoonSessionStore(),
        accountStore: SuliJoyIslandAccountStore = SuliJoyIslandAccountStore(),
        profileStore: SuliJoyLocalProfileStore = SuliJoyLocalProfileStore()
    ) {
        self.sessionStore = sessionStore
        self.accountStore = accountStore
        self.profileStore = profileStore
    }

    func restoreSession() -> SuliJoyLagoonSession {
        sessionStore.load()
    }

    func setEULAAgreed(_ agreed: Bool) {
        sessionStore.setEULAAgreed(agreed)
    }

    func login(email: String, password: String) -> SuliJoyLocalRequestEnvelope<SuliJoyLagoonSession> {
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanEmail.isEmpty {
            return .failure("Please enter your email.")
        }
        if password.isEmpty {
            return .failure("Please enter your password.")
        }

        if cleanEmail.lowercased() == testEmail && password == testPassword {
            sessionStore.saveLogin(email: cleanEmail, userID: "suli_islander_test", token: "suli_token_test_000000")
            ensureTestProfile(email: cleanEmail)
            return .success(sessionStore.load())
        }

        guard let account = accountStore.account(email: cleanEmail) else {
            return .failure("Account does not exist.", code: 404)
        }

        guard account.password == password else {
            return .failure("Incorrect password.", code: 401)
        }

        sessionStore.saveLogin(email: cleanEmail, userID: account.accountID, token: "suli_token_\(UUID().uuidString.prefix(12))")
        return .success(sessionStore.load())
    }

    func validateSignupDraft(name: String, email: String, password: String) -> SuliJoyLocalRequestEnvelope<SuliJoySignupDraft> {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanName.isEmpty {
            return .failure("Please enter your name.")
        }
        if cleanEmail.isEmpty {
            return .failure("Please enter your email.")
        }
        if !isValidEmail(cleanEmail) {
            return .failure("Please enter a valid email address.")
        }
        if password.count < 8 {
            return .failure("Password must be at least 8 characters.")
        }
        if cleanEmail.lowercased() == testEmail || accountStore.account(email: cleanEmail) != nil {
            return .failure("This email is already registered.")
        }
        return .success(SuliJoySignupDraft(name: cleanName, email: cleanEmail, password: password))
    }

    func completeProfile(draft: SuliJoySignupDraft, bio: String, avatar: UIImage?) -> SuliJoyLocalRequestEnvelope<SuliJoyShoreProfile> {
        let account = SuliJoyIslandAccount(
            accountID: "suli_islander_\(UUID().uuidString.prefix(8))",
            email: draft.email,
            password: draft.password,
            registeredAt: Date()
        )
        accountStore.save(account)

        let avatarPath = avatar.flatMap { profileStore.saveAvatarImage($0, email: draft.email) }
        let profile = SuliJoyShoreProfile(
            profileID: account.accountID,
            email: draft.email,
            nickname: draft.name,
            avatarPath: avatarPath,
            bio: bio.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Collecting little sounds of my days." : bio,
            styleTags: ["island-style", "beachwear", "sunset-look"],
            createdAt: Date()
        )
        profileStore.save(profile)
        sessionStore.saveLogin(email: draft.email, userID: account.accountID, token: "suli_token_\(UUID().uuidString.prefix(12))")
        return .success(profile, message: "Profile completed.")
    }

    func loadCurrentProfile() -> SuliJoyShoreProfile? {
        guard let email = sessionStore.load().currentEmail else { return nil }
        return profileStore.profile(email: email)
    }

    func logout() {
        logoutLagoonSession()
    }

    func logoutLagoonSession() {
        sessionStore.logoutOnly()
    }

    func deleteCurrentIslandAccount() -> SuliJoyLocalRequestEnvelope<Bool> {
        let session = sessionStore.load()
        guard let email = session.currentEmail else {
            sessionStore.logoutOnly()
            return .success(true, message: "Account deleted.")
        }

        profileStore.delete(email: email)
        if email.lowercased() != testEmail {
            accountStore.delete(email: email)
        }
        sessionStore.logoutOnly()
        return .success(true, message: "Account deleted.")
    }

    private func ensureTestProfile(email: String) {
        guard profileStore.profile(email: email) == nil else { return }
        profileStore.save(SuliJoyShoreProfile(
            profileID: "suli_islander_test",
            email: email,
            nickname: "SuliJoy Tester",
            avatarPath: nil,
            bio: "Testing relaxed island looks and sunny outfit ideas.",
            styleTags: ["tester", "coastal", "resort"],
            createdAt: Date()
        ))
    }

    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}
