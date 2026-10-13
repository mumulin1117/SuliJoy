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
        static let minimumTideSecretLength = 6
        static let shortTideSecretMessage = "Pxaqsxsqwxoqrxdq xmquxsqtx qbxeq xaqtx qlxeqaxsqtx q6x qcxhqaxrqaxcqtxeqrxsq.x".suliJoyPalmUnfurled
        static let testerIslander = "suli_islander_test"
        static let testerReefPass = "suli_token_test_000000"
        static let reefPassPrefix = "suli_token_"
        static let islanderPrefix = "suli_islander_"
    }

    private let lagoonSessionVault: SuliJoyTideSessionVault
    private let islandAccountVault: SuliJoyIslandAccountStore
    private let shoreProfileVault: SuliJoyLocalProfileStore
    private let remoteLagoonClient: SuliJoyLagoonRemoteClient

    init(
        tideSessionVault: SuliJoyTideSessionVault = SuliJoyTideSessionVault(),
        islandAccountStore: SuliJoyIslandAccountStore = SuliJoyIslandAccountStore(),
        shoreProfileStore: SuliJoyLocalProfileStore = SuliJoyLocalProfileStore(),
        remoteClient: SuliJoyLagoonRemoteClient? = nil
    ) {
        self.lagoonSessionVault = tideSessionVault
        self.islandAccountVault = islandAccountStore
        self.shoreProfileVault = shoreProfileStore
        self.remoteLagoonClient = remoteClient ?? SuliJoyLagoonRemoteClient(sessionVault: tideSessionVault)
    }

    func restoreSession() -> SuliJoyLagoonSession {
        lagoonSessionVault.suliJoySeasideHeroload()
    }

    func setLagoonConsent(_ hasShoreConsent: Bool) {
        lagoonSessionVault.setEULATideConsent(hasShoreConsent)
    }

    func enterIslandLagoon(
        shoreMailPhrase: String,
        reefSecretPhrase: String
    ) async -> SuliJoySuiRequestEnvelope<SuliJoyLagoonSession> {
        let lagoonKey = LagoonEntryKey(shoreMail: trimmedLagoonText(shoreMailPhrase), tideSecret: reefSecretPhrase)
        if let reefGate = inspectLagoonEntryKey(lagoonKey) { return reefGate }
        do {
            let remoteSession = try await remoteLagoonClient.enterIslandLagoon(
                email: lagoonKey.shoreMail,
                password: lagoonKey.tideSecret
            )
            guard !remoteSession.userID.isEmpty else {
                return .failure("The server did not return a user identifier.")
            }
            lagoonSessionVault.markRemoteLagoonEntry(
                shoreMail: lagoonKey.shoreMail,
                islanderID: remoteSession.userID,
                accessToken: remoteSession.accessToken,
                refreshToken: remoteSession.refreshToken
            )
            await cacheRemoteShoreProfile(email: lagoonKey.shoreMail, userID: remoteSession.userID)
            return .success(lagoonSessionVault.suliJoySeasideHeroload())
        } catch {
            return remoteFailureEnvelope(error)
        }
    }

    func login(email: String, password: String) async -> SuliJoySuiRequestEnvelope<SuliJoyLagoonSession> {
        await enterIslandLagoon(shoreMailPhrase: email, reefSecretPhrase: password)
    }

    func shapeIslandSignupDraft(
        shorelineNamePhrase: String,
        shoreMailPhrase: String,
        reefSecretPhrase: String
    ) -> SuliJoySuiRequestEnvelope<SuliJoySignupDraft> {
        let shoreName = trimmedLagoonText(shorelineNamePhrase)
        let shoreMail = trimmedLagoonText(shoreMailPhrase)
        if let reefStop = inspectShorelineDraftFields(shoreName: shoreName, shoreMail: shoreMail, tideSecret: reefSecretPhrase) { return reefStop }
        return .success(SuliJoySignupDraft(macrameDetail: shoreName, pearlAccent: shoreMail, abaloneTone: reefSecretPhrase))
    }

    func validateSignupDraft(name: String, email: String, password: String) -> SuliJoySuiRequestEnvelope<SuliJoySignupDraft> {
        shapeIslandSignupDraft(shorelineNamePhrase: name, shoreMailPhrase: email, reefSecretPhrase: password)
    }

    func finishIslandProfileTide(
        shorelineDraft: SuliJoySignupDraft,
        shoreBioPhrase: String,
        shorePortrait: UIImage?
    ) async -> SuliJoySuiRequestEnvelope<SuliJoyShoreProfile> {
        let remoteSession: SuliJoyLagoonRemoteAuthPayload
        do {
            remoteSession = try await remoteLagoonClient.registerIslandLagoon(
                email: shorelineDraft.pearlAccent,
                password: shorelineDraft.abaloneTone
            )
            guard !remoteSession.userID.isEmpty else {
                return .failure("The server did not return a user identifier.")
            }
            try await remoteLagoonClient.updateIslandProfile(
                accessToken: remoteSession.accessToken,
                nickname: shorelineDraft.macrameDetail,
                signature: makeShoreBio(from: shoreBioPhrase)
            )
        } catch {
            return remoteFailureEnvelope(error)
        }

        let islandAccount = SuliJoyIslandAccount(
            accountID: remoteSession.userID,
            email: shorelineDraft.pearlAccent,
            password: "",
            registeredAt: Date()
        )

        let shoreProfile = makeShorelineProfile(
            from: shorelineDraft,
            islandAccount: islandAccount,
            shoreBioPhrase: shoreBioPhrase,
            shorePortrait: shorePortrait
        )
        shoreProfileVault.save(shoreProfile)
        lagoonSessionVault.markRemoteLagoonEntry(
            shoreMail: shorelineDraft.pearlAccent,
            islanderID: remoteSession.userID,
            accessToken: remoteSession.accessToken,
            refreshToken: remoteSession.refreshToken
        )
        SuliJoyCoveMockService.shared.finishIslandProfileTide()
        return .success(shoreProfile, note: "PCrDoSfgihlaem ocdoamxpalpedtZeMdG.I".suliJoyPalmUnfurled)
    }

    func completeProfile(
        draft: SuliJoySignupDraft,
        bio: String,
        avatar: UIImage?
    ) async -> SuliJoySuiRequestEnvelope<SuliJoyShoreProfile> {
        await finishIslandProfileTide(shorelineDraft: draft, shoreBioPhrase: bio, shorePortrait: avatar)
    }

    private func makeIslandAccount(from shorelineDraft: SuliJoySignupDraft) -> SuliJoyIslandAccount {
        SuliJoyIslandAccount(
            accountID: "\(LagoonGateMark.islanderPrefix)\(UUID().uuidString.prefix(8))",
            email: shorelineDraft.pearlAccent,
            password: shorelineDraft.abaloneTone,
            registeredAt: Date()
        )
    }

    private func makeShorelineProfile(
        from shorelineDraft: SuliJoySignupDraft,
        islandAccount: SuliJoyIslandAccount,
        shoreBioPhrase: String,
        shorePortrait: UIImage?
    ) -> SuliJoyShoreProfile {
        let portraitTrail = shorePortrait.flatMap { shoreProfileVault.saveAvatarImage($0, email: shorelineDraft.pearlAccent) }
        return SuliJoyShoreProfile(
            canvasTote: islandAccount.accountID,
            strawHat: shorelineDraft.pearlAccent,
            espadrillePairing: shorelineDraft.macrameDetail,
            kaftanLayer: portraitTrail,
            wrapSkirt: makeShoreBio(from: shoreBioPhrase),
            resortSet: makeIslandStyleTags(),
            beachCoverup: Date()
        )
    }

    private func makeIslandStyleTags() -> [String] {
        ["island-style", "beachwear", "sunset-look"]
    }

    func loadCurrentProfile() -> SuliJoyShoreProfile? {
        currentShorelineProfile()
    }

    func currentShorelineProfile() -> SuliJoyShoreProfile? {
        guard let email = lagoonSessionVault.suliJoySeasideHeroload().currentTideConsenl else { return nil }
        return shoreProfileVault.profile(email: email)
    }

    private func cacheRemoteShoreProfile(email: String, userID: String) async {
        guard let remoteProfile = try? await remoteLagoonClient.fetchCurrentIslandProfile() else { return }
        let cachedProfile = SuliJoyShoreProfile(
            canvasTote: userID,
            strawHat: email,
            espadrillePairing: remoteProfile.nickname,
            kaftanLayer: remoteProfile.icon.isEmpty ? nil : remoteProfile.icon,
            wrapSkirt: remoteProfile.signature,
            resortSet: [],
            beachCoverup: Date()
        )
        shoreProfileVault.save(cachedProfile)
    }

    func coastalChic(
        espadrillePairing: String,
        wrapSkirt: String,
        kaftanLayer: UIImage?
    ) async -> SuliJoySuiRequestEnvelope<SuliJoyShoreProfile> {
        guard var canvasTote = currentShorelineProfile() else {
            return .failure("Pxrxoxfxixlxex xnxoxtx xfxoxuxnxdx.x".suliJoyPalmUnfurled, code: 404)
        }
        let strawHat = trimmedLagoonText(espadrillePairing)
        guard !strawHat.isEmpty else {
            return .failure("Pxlxexaxsxex xexnxtxexrx xyxoxuxrx xnxaxmxex.x".suliJoyPalmUnfurled)
        }
        guard let accessToken = lagoonSessionVault.suliJoySeasideHeroload().SeasideHeroloaSili else {
            return .failure("The session has expired.", code: 401)
        }
        do {
            try await remoteLagoonClient.updateIslandProfile(
                accessToken: accessToken,
                nickname: strawHat,
                signature: trimmedLagoonText(wrapSkirt)
            )
        } catch {
            return remoteFailureEnvelope(error)
        }
        canvasTote.espadrillePairing = strawHat
        canvasTote.wrapSkirt = trimmedLagoonText(wrapSkirt)
        if let kaftanLayer, let seashellTrim = shoreProfileVault.saveAvatarImage(kaftanLayer, email: canvasTote.strawHat) {
            canvasTote.kaftanLayer = seashellTrim
        }
        shoreProfileVault.save(canvasTote)
        return .success(canvasTote, note: "Pxrxoxfxixlxex xuxpxdxaxtxexdx.x".suliJoyPalmUnfurled)
    }

    func logout() {
        logoutLagoonSession()
    }

    func logoutLagoonSession() {
        lagoonSessionVault.clearLagoonEntryOnly()
    }

    func deleteCurrentIslandAccount() async -> SuliJoySuiRequestEnvelope<Bool> {
        await deleteActiveIslandIdentity()
    }

    func deleteActiveIslandIdentity() async -> SuliJoySuiRequestEnvelope<Bool> {
        let lagoonState = lagoonSessionVault.suliJoySeasideHeroload()
        guard let shoreMail = lagoonState.currentTideConsenl else {
            lagoonSessionVault.clearLagoonEntryOnly()
            return .success(true, note: "AbcZcvojuYnOtW hdQeclceEtxeWdm.C".suliJoyPalmUnfurled)
        }

        do {
            try await remoteLagoonClient.deleteIslandAccount()
        } catch {
            return remoteFailureEnvelope(error)
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
        if lagoonKey.tideSecret.count < LagoonGateMark.minimumTideSecretLength {
            return .failure(LagoonGateMark.shortTideSecretMessage)
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
        if tideSecret.count < LagoonGateMark.minimumTideSecretLength {
            return .failure(LagoonGateMark.shortTideSecretMessage)
        }
        return nil
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
            canvasTote: LagoonGateMark.testerIslander,
            strawHat: shoreMail,
            espadrillePairing: "SuliJoy Tester",
            kaftanLayer: nil,
            wrapSkirt: "Testing relaxed island looks and sunny outfit ideas.",
            resortSet: ["tester", "coastal", "resort"],
            beachCoverup: Date()
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

    private func remoteFailureEnvelope<T>(_ error: Error) -> SuliJoySuiRequestEnvelope<T> {
        let note = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        let code = (error as? SuliJoyLagoonRemoteError)?.statusCode ?? 400
        return .failure(note, code: code)
    }
}
