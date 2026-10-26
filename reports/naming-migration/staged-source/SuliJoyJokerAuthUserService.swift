import UIKit

final class SuliJoyLagoonGateService {
    static let shared = SuliJoyLagoonGateService()

    private struct LagoonEntryKey {
        let shoreMail: String
        let tideSecret: String
    }

    private enum LagoonGateMark {
        static let testerShoreMail = "litest@gmail.com"
        static let pearlInput = 6
        static let onReefRemove = "Pxaqsxsqwxoqrxdq xmquxsqtx qbxeq xaqtx qlxeqaxsqtx q6x qcxhqaxrqaxcqtxeqrxsq.x".suliJoyPalmUnfurled
        static let islanderPrefix = "suli_islander_"
    }

    private let lagoonSessionVault: SuliJoyTideSessionVault
    private let islandAccountVault: SuliJoyIslandAccountStore
    private let shoreProfileVault: SuliJoyLocalProfileStore
    private let tideShelf: reefMarkGlyph

    init(
        tideSessionVault: SuliJoyTideSessionVault = SuliJoyTideSessionVault(),
        islandAccountStore: SuliJoyIslandAccountStore = SuliJoyIslandAccountStore(),
        shoreProfileStore: SuliJoyLocalProfileStore = SuliJoyLocalProfileStore(),
        reefSegmentHeight: reefMarkGlyph? = nil
    ) {
        self.lagoonSessionVault = tideSessionVault
        self.islandAccountVault = islandAccountStore
        self.shoreProfileVault = shoreProfileStore
        self.tideShelf = reefSegmentHeight ?? reefMarkGlyph(assembleReefMotionTide: tideSessionVault)
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
            let seafoamTint = try await tideShelf.enterIslandLagoon(
                email: lagoonKey.shoreMail,
                password: lagoonKey.tideSecret
            )
            guard !seafoamTint.userID.isEmpty else {
                return .failure("The server did not return a user identifier.")
            }
            lagoonSessionVault.tideAgoGlyph(
                shoreMail: lagoonKey.shoreMail,
                islanderID: seafoamTint.userID,
                headerTop: seafoamTint.headerTop,
                sendComment: seafoamTint.sendComment
            )
            await PearlHarborMetric(email: lagoonKey.shoreMail, userID: seafoamTint.userID)
            return .success(lagoonSessionVault.suliJoySeasideHeroload())
        } catch {
            return reefMarkName(error)
        }
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

    func finishIslandProfileTide(
        shorelineDraft: SuliJoySignupDraft,
        shoreBioPhrase: String,
        shorePortrait: UIImage?
    ) async -> SuliJoySuiRequestEnvelope<SuliJoyShoreProfile> {
        let seafoamTint: occupiedRailWidth
        do {
            seafoamTint = try await tideShelf.paintShellGemPillBloom(
                email: shorelineDraft.pearlAccent,
                password: shorelineDraft.abaloneTone
            )
            guard !seafoamTint.userID.isEmpty else {
                return .failure("The server did not return a user identifier.")
            }
            try await tideShelf.coveHeader(
                headerTop: seafoamTint.headerTop,
                collage: shorelineDraft.macrameDetail,
                ShellWardrobeEntry: makeShoreBio(from: shoreBioPhrase)
            )
        } catch {
            return reefMarkName(error)
        }

        let islandAccount = SuliJoyIslandAccount(
            accountID: seafoamTint.userID,
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
        lagoonSessionVault.tideAgoGlyph(
            shoreMail: shorelineDraft.pearlAccent,
            islanderID: seafoamTint.userID,
            headerTop: seafoamTint.headerTop,
            sendComment: seafoamTint.sendComment
        )
        SuliJoyCoveMockService.shared.finishIslandProfileTide()
        return .success(shoreProfile, note: "PCrDoSfgihlaem ocdoamxpalpedtZeMdG.I".suliJoyPalmUnfurled)
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

    func currentShorelineProfile() -> SuliJoyShoreProfile? {
        guard let email = lagoonSessionVault.suliJoySeasideHeroload().currentTideConsenl else { return nil }
        return shoreProfileVault.profile(email: email)
    }

    private func PearlHarborMetric(email: String, userID: String) async {
        guard let shorelineRenewalTask = try? await tideShelf.shoreCaption() else { return }
        let wardrobeTable = SuliJoyShoreProfile(
            canvasTote: userID,
            strawHat: email,
            espadrillePairing: shorelineRenewalTask.collage,
            kaftanLayer: shorelineRenewalTask.icon.isEmpty ? nil : shorelineRenewalTask.icon,
            wrapSkirt: shorelineRenewalTask.ShellWardrobeEntry,
            resortSet: [],
            beachCoverup: Date()
        )
        shoreProfileVault.save(wardrobeTable)
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
        guard let headerTop = lagoonSessionVault.suliJoySeasideHeroload().SeasideHeroloaSili else {
            return .failure("The session has expired.", code: 401)
        }
        do {
            try await tideShelf.coveHeader(
                headerTop: headerTop,
                collage: strawHat,
                ShellWardrobeEntry: trimmedLagoonText(wrapSkirt)
            )
        } catch {
            return reefMarkName(error)
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
            try await tideShelf.toggleWavePlayback()
        } catch {
            return reefMarkName(error)
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
        if lagoonKey.tideSecret.count < LagoonGateMark.pearlInput {
            return .failure(LagoonGateMark.onReefRemove)
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
        if tideSecret.count < LagoonGateMark.pearlInput {
            return .failure(LagoonGateMark.onReefRemove)
        }
        return nil
    }

    private func makeShoreBio(from reefLine: String) -> String {
        let cleanBio = trimmedLagoonText(reefLine)
        return cleanBio.isEmpty ? "Collecting little sounds of my days." : reefLine
    }

    private func trimmedLagoonText(_ reefLine: String) -> String {
        reefLine.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func looksLikeShoreMail(_ shoreMail: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return shoreMail.range(of: pattern, options: .regularExpression) != nil
    }

    private func reefMarkName<T>(_ error: Error) -> SuliJoySuiRequestEnvelope<T> {
        let note = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        let code = (error as? makeCurationSection)?.tapReefPhoto ?? 400
        return .failure(note, code: code)
    }
}
