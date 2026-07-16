import Foundation
import StoreKit

enum SuliJoyLagoonPurchaseOutcome {
    case completed(SuliJoyShellWallet)
    case cancelled
    case pending
}

private enum SuliJoyLagoonPurchaseError: Error {
    case failedVerification
}

final class SuliJoyLagoonPurchaseService {
    static let shared = SuliJoyLagoonPurchaseService()

    private var productsByID: [String: Product] = [:]

    private init() {}

    func fetchPearlCoinPacks() async -> SuliJoyLocalRequestEnvelope<[SuliJoyPearlCoinPack]> {
        do {
            let ids = SuliJoyPearlCoinPack.localPacks.map(\.storeProductID)
            let products = try await Product.products(for: ids)
            productsByID = Dictionary(uniqueKeysWithValues: products.map { ($0.id, $0) })
            guard !products.isEmpty else {
                return .failure("Unable to load StoreKit products.")
            }
            let packs = SuliJoyPearlCoinPack.localPacks.map { pack in
                var updated = pack
                if let product = productsByID[pack.storeProductID] {
                    updated.displayPrice = product.displayPrice
                }
                return updated
            }
            return .success(packs, message: products.isEmpty ? "" : "OK")//Products unavailable. Showing listed prices.
        } catch {
            return .failure("Unable to load StoreKit products.")
        }
    }

    func purchase(pack: SuliJoyPearlCoinPack) async -> SuliJoyLocalRequestEnvelope<SuliJoyLagoonPurchaseOutcome> {
        guard let product = productsByID[pack.storeProductID] else {
            return .failure("Product is not available.")
        }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                let wallet = SuliJoyShellWalletStore.shared.addRecharge(
                    pack: pack,
                    transactionID: String(transaction.id)
                )
                guard let data = wallet.data else {
                    return .failure(wallet.message, code: wallet.code)
                }
                return .success(.completed(data), message: "Recharge completed.")
            case .userCancelled:
                return .success(.cancelled, message: "Purchase cancelled.")
            case .pending:
                return .success(.pending, message: "Purchase pending.")
            @unknown default:
                return .failure("Purchase did not complete.")
            }
        } catch {
            return .failure("Purchase failed.")
        }
    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw SuliJoyLagoonPurchaseError.failedVerification
        }
    }
}
