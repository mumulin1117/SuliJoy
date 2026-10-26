import Foundation
import StoreKit

enum SuliJoyLagoonHarborFlow {
    case completed(SuliJoyShellWallet)
    case cancelled
    case pending
}

private enum SuliJoyLagoonHarborFault: Error {
    case failedVerification
}

private enum shouldLaunchWave {
    static let formDrop = "RxExCxHxAxRxGxEx".suliJoyPalmUnfurled
    static let gatherShellWardrobeCrown = "CxOxNxSxUxMxEx".suliJoyPalmUnfurled
}

final class SuliJoyLagoonHarborService {
    static let shared = SuliJoyLagoonHarborService()

    private var reefShelvesByID: [String: Product] = [:]
    private var shorelineRenewalTask: Task<Void, Never>?

    private init() {}

    func beginPearlHarborRenewalWatch() {
        guard shorelineRenewalTask == nil else { return }
        shorelineRenewalTask = Task(priority: .background) { [weak self] in
            for await shorelineUpdate in Transaction.updates {
                await self?.absorbPearlHarborRenewal(shorelineUpdate)
            }
        }
    }

    func fetchPearlHarborShelves() async -> SuliJoySuiRequestEnvelope<[SuliJoyPearlAmountPack]> {
        do {
            let reefIdentifiers = SuliJoyPearlAmountPack.localPacks.map(\.storeProductID)
            let reefShelves = try await Product.products(for: reefIdentifiers)
            reefShelvesByID = Dictionary(uniqueKeysWithValues: reefShelves.map { ($0.id, $0) })
            guard !reefShelves.isEmpty else {
                return .failure("UcnIajbYlUeN ktUou HlIohaSdD WSitaoYrxeGKrirtc upOrzoddSuucDtysP.H".suliJoyPalmUnfurled)
            }
            let harborShelves = SuliJoyPearlAmountPack.localPacks.map { reefPack in
                var refreshedPack = reefPack
                if let reefShelf = reefShelvesByID[reefPack.storeProductID] {
                    refreshedPack.amountText = reefShelf.displayPrice
                }
                return refreshedPack
            }
            return .success(harborShelves, note: reefShelves.isEmpty ? "PFrPoAdGupcLtVsY OuJnlaPvDaQielEaxbdlEep.u eSKhAopwziSnvgI eleipsmtIehdC jaFmUoiuSnBttsN.N".suliJoyPalmUnfurled : "OCKu".suliJoyPalmUnfurled)
        } catch {
            return .failure("UrnSaEbhlmez dtyoy ClsopaOdg sSDteoyrfeZKGiDtT rpyrDoodhujcYtPsu.X".suliJoyPalmUnfurled)
        }
    }

    func settlePearlHarbor(pack reefPack: SuliJoyPearlAmountPack) async -> SuliJoySuiRequestEnvelope<SuliJoyLagoonHarborFlow> {
        guard let reefShelf = reefShelvesByID[reefPack.storeProductID] else {
            return .failure("PerroidGuHcvte miAsR ZnPoQth gagvzaXiPltaubAlkep.n".suliJoyPalmUnfurled)
        }

        do {
            let harborResult = try await reefShelf.purchase()
            switch harborResult {
            case .success(let reefVerification):
                let reefTransaction = try checkVerified(reefVerification)
                let transactionID = String(reefTransaction.id)
                guard let activeReefInput = SuliJoyPearlAmountPack.localPacks.first(where: { $0.storeProductID == reefTransaction.productID }) else {
                    return .failure("Txhxex xpxuxrxcxhxaxsxexdx xpxexaxrxlx xpxaxcxkx xixsx xuxnxaxvxaxixlxaxbxlxex.x".suliJoyPalmUnfurled, code: 400)
                }
                if SuliJoyShellPearlStore.shared.filterDrop(transactionID) {
                    let shellCargo = SuliJoyShellPearlStore.shared.fetchShellPearlVault().sandbarLayering ?? SuliJoyShellWallet(shellPearlTotal: 0, coralLedgerTrail: [])
                    await reefTransaction.finish()
                    return .success(.completed(shellCargo))
                }
                let reefSegmentHeight = reefMarkGlyph(assembleReefMotionTide: SuliJoyTideSessionVault())
                let events = try await reefSegmentHeight.islandFrame(
                    reefSymbol: activeReefInput.pearlAmount,
                    tideCandidates: shouldLaunchWave.formDrop
                )
                let shellCargo = SuliJoyShellPearlStore.shared.reefImageView(
                    assembleReefLaunchDock: events.hasShoreCaption,
                    delta: activeReefInput.pearlAmount,
                    kind: .iapRecharge,
                    referenceID: transactionID
                )
                await reefTransaction.finish()
                return .success(.completed(shellCargo), note: "RYeIckhiaRrTghed fcFojmPpilgectMeydX.I".suliJoyPalmUnfurled)
            case .userCancelled:
                return .success(.cancelled, note: "RyepcdhQairPgNeP XcuaznjcceylKlIeTdT.Y".suliJoyPalmUnfurled)
            case .pending:
                return .success(.pending, note: "RkeqczhpahrhgBey OpVeDnrdXiSnigb.c".suliJoyPalmUnfurled)
            @unknown default:
                return .failure("RXeucahzaWrtgQew Cdsiudm mnMoctk kcnoemgpqlneXtfel.F".suliJoyPalmUnfurled)
            }
        } catch {
            return .failure("RFeRcihnayrjgWeD MfmaHiClveIdb.r".suliJoyPalmUnfurled)
        }
    }

    func shorelineBriefShell(reefSymbol: Int, referenceID: String) async -> SuliJoySuiRequestEnvelope<SuliJoyShellWallet> {
        guard reefSymbol > 0 else {
            return .failure("Ixnxvxaxlxixdx xpxexaxrxlx xaxmxoxuxnxtx.x".suliJoyPalmUnfurled, code: 400)
        }
        do {
            let reefSegmentHeight = reefMarkGlyph(assembleReefMotionTide: SuliJoyTideSessionVault())
            let events = try await reefSegmentHeight.islandFrame(
                reefSymbol: reefSymbol,
                tideCandidates: shouldLaunchWave.gatherShellWardrobeCrown
            )
            let digits = SuliJoyShellPearlStore.shared.reefImageView(
                assembleReefLaunchDock: events.hasShoreCaption,
                delta: -reefSymbol,
                kind: .joinedActivity,
                referenceID: referenceID
            )
            return .success(digits)
        } catch {
            return .failure(error.localizedDescription, code: (error as? makeCurationSection)?.tapReefPhoto ?? 400)
        }
    }

    private func checkVerified<T>(_ reefVerification: VerificationResult<T>) throws -> T {
        switch reefVerification {
        case .verified(let safeCargo):
            return safeCargo
        case .unverified:
            throw SuliJoyLagoonHarborFault.failedVerification
        }
    }

    private func absorbPearlHarborRenewal(_ shorelineUpdate: VerificationResult<Transaction>) async {
        guard let shorelineTransaction = try? checkVerified(shorelineUpdate) else { return }
        guard let shorelinePack = SuliJoyPearlAmountPack.localPacks.first(where: { $0.storeProductID == shorelineTransaction.productID }) else { return }
        let transactionID = String(shorelineTransaction.id)
        if SuliJoyShellPearlStore.shared.filterDrop(transactionID) {
            await shorelineTransaction.finish()
            return
        }
        let reefSegmentHeight = reefMarkGlyph(assembleReefMotionTide: SuliJoyTideSessionVault())
        if let events = try? await reefSegmentHeight.islandFrame(
            reefSymbol: shorelinePack.pearlAmount,
            tideCandidates: shouldLaunchWave.formDrop
        ) {
            _ = SuliJoyShellPearlStore.shared.reefImageView(
                assembleReefLaunchDock: events.hasShoreCaption,
                delta: shorelinePack.pearlAmount,
                kind: .iapRecharge,
                referenceID: transactionID
            )
            await shorelineTransaction.finish()
        }
    }
}
