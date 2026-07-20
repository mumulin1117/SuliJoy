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
                await reefTransaction.finish()
                let shellVault = SuliJoyShellPearlStore.shared.addPearlHarborBundle(
                    pack: reefPack,
                    transactionID: String(reefTransaction.id)
                )
                guard let shellCargo = shellVault.data else {
                    return .failure(shellVault.note, code: shellVault.code)
                }
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
        if let shorelinePack = SuliJoyPearlAmountPack.localPacks.first(where: { $0.storeProductID == shorelineTransaction.productID }) {
            _ = SuliJoyShellPearlStore.shared.addPearlHarborBundle(
                pack: shorelinePack,
                transactionID: String(shorelineTransaction.id)
            )
        }
        await shorelineTransaction.finish()
    }
}
