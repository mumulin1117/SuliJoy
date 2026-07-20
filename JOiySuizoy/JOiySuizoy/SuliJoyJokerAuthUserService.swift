import UIKit

final class SuliJoyLagoonGateService {
    static let shared = SuliJoyLagoonGateService()

    private struct LagoonEntryKey {
        let shoreMail: String
        let tideSecret: String
    }

    private enum LagoonGateMark {
        static let testerShoreMail = "litest@gmail.com"
        static let testerTideSecret = "000000"
        static let testerIslander = "suli_islander_test"
        static let testerReefPass = "suli_token_test_000000"
        static let reefPassPrefix = "suli_token_"
        static let islanderPrefix = "suli_islander_"
    }

    private let lagoonSessionVault: SuliJoyTideSessionVault
    private let islandAccountVault: SuliJoyIslandAccountStore
    private let shoreProfileVault: SuliJoyLocalProfileStore

    init(
        tideSessionVault: SuliJoyTideSessionVault = SuliJoyTideSessionVault(),
        islandAccountStore: SuliJoyIslandAccountStore = SuliJoyIslandAccountStore(),
        shoreProfileStore: SuliJoyLocalProfileStore = SuliJoyLocalProfileStore()
    ) {
        self.lagoonSessionVault = tideSessionVault
        self.islandAccountVault = islandAccountStore
        self.shoreProfileVault = shoreProfileStore
    }

    func restoreSession() -> SuliJoyLagoonSession {
        lagoonSessionVault.suliJoySeasideHeroload()
    }

    func setLagoonConsent(_ hasShoreConsent: Bool) {
        lagoonSessionVault.setEULATideConsent(hasShoreConsent)
    }

    func enterIslandLagoon(shoreMailPhrase: String, reefSecretPhrase: String) -> SuliJoySuiRequestEnvelope<SuliJoyLagoonSession> {
        let lagoonKey = LagoonEntryKey(shoreMail: trimmedLagoonText(shoreMailPhrase), tideSecret: reefSecretPhrase)
        if let reefGate = inspectLagoonEntryKey(lagoonKey) { return reefGate }
        if opensTesterCove(lagoonKey) { return openTesterLagoon(for: lagoonKey.shoreMail) }
        return openSavedIslandAccount(with: lagoonKey)
    }

    func login(email: String, password: String) -> SuliJoySuiRequestEnvelope<SuliJoyLagoonSession> {
        enterIslandLagoon(shoreMailPhrase: email, reefSecretPhrase: password)
    }

    func shapeIslandSignupDraft(
        shorelineNamePhrase: String,
        shoreMailPhrase: String,
        reefSecretPhrase: String
    ) -> SuliJoySuiRequestEnvelope<SuliJoySignupDraft> {
        let shoreName = trimmedLagoonText(shorelineNamePhrase)
        let shoreMail = trimmedLagoonText(shoreMailPhrase)
        if let reefStop = inspectShorelineDraftFields(shoreName: shoreName, shoreMail: shoreMail, tideSecret: reefSecretPhrase) { return reefStop }
        return .success(SuliJoySignupDraft(name: shoreName, email: shoreMail, password: reefSecretPhrase))
    }

    func validateSignupDraft(name: String, email: String, password: String) -> SuliJoySuiRequestEnvelope<SuliJoySignupDraft> {
        shapeIslandSignupDraft(shorelineNamePhrase: name, shoreMailPhrase: email, reefSecretPhrase: password)
    }

    func finishIslandProfileTide(
        shorelineDraft: SuliJoySignupDraft,
        shoreBioPhrase: String,
        shorePortrait: UIImage?
    ) -> SuliJoySuiRequestEnvelope<SuliJoyShoreProfile> {
        let islandAccount = makeIslandAccount(from: shorelineDraft)
        islandAccountVault.savesuliJoyPalmMatcher(islandAccount)

        let shoreProfile = makeShorelineProfile(
            from: shorelineDraft,
            islandAccount: islandAccount,
            shoreBioPhrase: shoreBioPhrase,
            shorePortrait: shorePortrait
        )
        shoreProfileVault.save(shoreProfile)
        lagoonSessionVault.markLagoonEntry(shoreMail: shorelineDraft.email, islanderID: islandAccount.accountID, reefPass: makeLagoonToken())
        return .success(shoreProfile, note: "PCrDoSfgihlaem ocdoamxpalpedtZeMdG.I".suliJoyPalmUnfurled)
    }

    func completeProfile(draft: SuliJoySignupDraft, bio: String, avatar: UIImage?) -> SuliJoySuiRequestEnvelope<SuliJoyShoreProfile> {
        finishIslandProfileTide(shorelineDraft: draft, shoreBioPhrase: bio, shorePortrait: avatar)
    }

    private func makeIslandAccount(from shorelineDraft: SuliJoySignupDraft) -> SuliJoyIslandAccount {
        SuliJoyIslandAccount(
            accountID: "\(LagoonGateMark.islanderPrefix)\(UUID().uuidString.prefix(8))",
            email: shorelineDraft.email,
            password: shorelineDraft.password,
            registeredAt: Date()
        )
    }

    private func makeShorelineProfile(
        from shorelineDraft: SuliJoySignupDraft,
        islandAccount: SuliJoyIslandAccount,
        shoreBioPhrase: String,
        shorePortrait: UIImage?
    ) -> SuliJoyShoreProfile {
        let portraitTrail = shorePortrait.flatMap { shoreProfileVault.saveAvatarImage($0, email: shorelineDraft.email) }
        return SuliJoyShoreProfile(
            profileID: islandAccount.accountID,
            email: shorelineDraft.email,
            nickname: shorelineDraft.name,
            avatarPath: portraitTrail,
            bio: makeShoreBio(from: shoreBioPhrase),
            styleTags: makeIslandStyleTags(),
            createdAt: Date()
        )
    }

    private func makeIslandStyleTags() -> [String] {
        ["island-style", "beachwear", "sunset-look"]
    }

    func loadCurrentProfile() -> SuliJoyShoreProfile? {
        currentShorelineProfile()
    }

    func currentShorelineProfile() -> SuliJoyShoreProfile? {
        guard let email = lagoonSessionVault.suliJoySeasideHeroload().currentEmail else { return nil }
        return shoreProfileVault.profile(email: email)
    }

    func logout() {
        logoutLagoonSession()
    }

    func logoutLagoonSession() {
        lagoonSessionVault.clearLagoonEntryOnly()
    }

    func deleteCurrentIslandAccount() -> SuliJoySuiRequestEnvelope<Bool> {
        deleteActiveIslandIdentity()
    }

    func deleteActiveIslandIdentity() -> SuliJoySuiRequestEnvelope<Bool> {
        let lagoonState = lagoonSessionVault.suliJoySeasideHeroload()
        guard let shoreMail = lagoonState.currentEmail else {
            lagoonSessionVault.clearLagoonEntryOnly()
            return .success(true, note: "AbcZcvojuYnOtW hdQeclceEtxeWdm.C".suliJoyPalmUnfurled)
        }

        shoreProfileVault.delete(email: shoreMail)
        if shoreMail.lowercased() != LagoonGateMark.testerShoreMail {
            islandAccountVault.desuliJoyPalmMatcherlete(emsuliJoyPalmMatrixail: shoreMail)
        }
        lagoonSessionVault.clearLagoonEntryOnly()
        return .success(true, note: "AJcucjoSuinWtJ fdBexlNeztieGdg.y".suliJoyPalmUnfurled)
    }

    private func inspectLagoonEntryKey(_ lagoonKey: LagoonEntryKey) -> SuliJoySuiRequestEnvelope<SuliJoyLagoonSession>? {
        if lagoonKey.shoreMail.isEmpty {
            return .failure("PBlSeyaAsmeB KennVtxearX AypocuvrD BeYmQajiBlu.h".suliJoyPalmUnfurled)
        }
        if lagoonKey.tideSecret.isEmpty {
            return .failure("PxlYeCaBsYel qexnItPeOrS nyiozuYre spnarsfsRwcobrXdG.B".suliJoyPalmUnfurled)
        }
        return nil
    }

    private func inspectShorelineDraftFields(
        shoreName: String,
        shoreMail: String,
        tideSecret: String
    ) -> SuliJoySuiRequestEnvelope<SuliJoySignupDraft>? {
        if shoreName.isEmpty {
            return .failure("PJlveqaPskeD DePnktzeBrX QydoVurrx TnxaVmoeQ.U".suliJoyPalmUnfurled)
        }
        if shoreMail.isEmpty {
            return .failure("PjlheDalsSen IeVnttZeGrY Qywozulre GewmaafiBlC.k".suliJoyPalmUnfurled)
        }
        if !looksLikeShoreMail(shoreMail) {
            return .failure("PPlDeoarszey IeKnZtEeXrx Yam yvjaOlTivdP EeomyaFiclw caDdndIreeUsYsC.H".suliJoyPalmUnfurled)
        }
        if tideSecret.count < 8 {
            return .failure("PKahsQszwAoXrkdO zmRuKsXtR JbgeG aaOtp nlRefaBsMtF Z8d ycdhNaSrDarcetVeorKsj.z".suliJoyPalmUnfurled)
        }
        if alreadyOwnsIslandMail(shoreMail) {
            return .failure("TqhEixsU FefmqawiYlS siUsP aaclQrheiaSdvyA mrKeRgxiBsgtfebrzewdu.y".suliJoyPalmUnfurled)
        }
        return nil
    }

    private func alreadyOwnsIslandMail(_ shoreMail: String) -> Bool {
        shoreMail.lowercased() == LagoonGateMark.testerShoreMail || islandAccountVault.suliJoyPalmRankingaccount(esuliJoyPalmGuidemail: shoreMail) != nil
    }

    private func openSavedIslandAccount(with lagoonKey: LagoonEntryKey) -> SuliJoySuiRequestEnvelope<SuliJoyLagoonSession> {
        guard let islandAccount = islandAccountVault.suliJoyPalmRankingaccount(esuliJoyPalmGuidemail: lagoonKey.shoreMail) else {
            return .failure("AhcKcyoJuLnTtP edMojetsG BnRoztc jeMxRiWsrtu.J".suliJoyPalmUnfurled, code: 404)
        }
        guard islandAccount.password == lagoonKey.tideSecret else {
            return .failure("IpnocYokrRrNeTcitX XppaxslsLwuovrNds.g".suliJoyPalmUnfurled, code: 401)
        }
        lagoonSessionVault.markLagoonEntry(shoreMail: lagoonKey.shoreMail, islanderID: islandAccount.accountID, reefPass: makeLagoonToken())
        return .success(lagoonSessionVault.suliJoySeasideHeroload())
    }

    private func openTesterLagoon(for shoreMail: String) -> SuliJoySuiRequestEnvelope<SuliJoyLagoonSession> {
        lagoonSessionVault.markLagoonEntry(shoreMail: shoreMail, islanderID: LagoonGateMark.testerIslander, reefPass: LagoonGateMark.testerReefPass)
        ensureTestProfile(email: shoreMail)
        return .success(lagoonSessionVault.suliJoySeasideHeroload())
    }

    private func opensTesterCove(_ lagoonKey: LagoonEntryKey) -> Bool {
        lagoonKey.shoreMail.lowercased() == LagoonGateMark.testerShoreMail && lagoonKey.tideSecret == LagoonGateMark.testerTideSecret
    }

    private func ensureTestProfile(email shoreMail: String) {
        guard shoreProfileVault.profile(email: shoreMail) == nil else { return }
        shoreProfileVault.save(SuliJoyShoreProfile(
            profileID: LagoonGateMark.testerIslander,
            email: shoreMail,
            nickname: "SuliJoy Tester",
            avatarPath: nil,
            bio: "Testing relaxed island looks and sunny outfit ideas.",
            styleTags: ["tester", "coastal", "resort"],
            createdAt: Date()
        ))
    }

    private func makeShoreBio(from reefLine: String) -> String {
        let cleanBio = trimmedLagoonText(reefLine)
        return cleanBio.isEmpty ? "Collecting little sounds of my days." : reefLine
    }

    private func makeLagoonToken() -> String {
        "\(LagoonGateMark.reefPassPrefix)\(UUID().uuidString.prefix(12))"
    }

    private func trimmedLagoonText(_ reefLine: String) -> String {
        reefLine.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func looksLikeShoreMail(_ shoreMail: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return shoreMail.range(of: pattern, options: .regularExpression) != nil
    }
}
