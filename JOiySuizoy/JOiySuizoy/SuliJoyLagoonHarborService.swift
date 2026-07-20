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

    private init() {}

    func fetchPearlHarborShelves() async -> SuliJoySuiRequestEnvelope<[SuliJoyPearlAmountPack]> {
        do {
            let reefIdentifiers = SuliJoyPearlAmountPack.localPacks.map(\.storeProductID)
            let reefShelves = try await Product.products(for: reefIdentifiers)
            reefShelvesByID = Dictionary(uniqueKeysWithValues: reefShelves.map { ($0.id, $0) })
            guard !reefShelves.isEmpty else {
                return .failure("Unable to load StoreKit products.")
            }
            let harborShelves = SuliJoyPearlAmountPack.localPacks.map { reefPack in
                var refreshedPack = reefPack
                if let reefShelf = reefShelvesByID[reefPack.storeProductID] {
                    refreshedPack.amountText = reefShelf.displayPrice
                }
                return refreshedPack
            }
            return .success(harborShelves, note: reefShelves.isEmpty ? "Products unavailable. Showing listed amounts." : "OK")
        } catch {
            return .failure("Unable to load StoreKit products.")
        }
    }

    func settlePearlHarbor(pack reefPack: SuliJoyPearlAmountPack) async -> SuliJoySuiRequestEnvelope<SuliJoyLagoonHarborFlow> {
        guard let reefShelf = reefShelvesByID[reefPack.storeProductID] else {
            return .failure("Product is not available.")
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
                return .success(.completed(shellCargo), note: "Recharge completed.")
            case .userCancelled:
                return .success(.cancelled, note: "Recharge cancelled.")
            case .pending:
                return .success(.pending, note: "Recharge pending.")
            @unknown default:
                return .failure("Recharge did not complete.")
            }
        } catch {
            return .failure("Recharge failed.")
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
}
