import Foundation

final class SuliJoyShellWalletStore {
    static let shared = SuliJoyShellWalletStore()

    private let defaults = UserDefaults.standard
    private let walletKey = "sulijoy.shell.wallet.v1"

    private init() {}

    func fetchWallet() -> SuliJoyLocalRequestEnvelope<SuliJoyShellWallet> {
        .success(loadWallet())
    }

    func currentBalance() -> Int {
        loadWallet().coinBalance
    }

    func spendForActivity(tideID: String, coinCost: Int) -> SuliJoyLocalRequestEnvelope<SuliJoyShellWallet> {
        var wallet = loadWallet()
        guard wallet.coinBalance >= coinCost else {
            return .failure("Not enough coins.")
        }
        wallet.coinBalance -= coinCost
        wallet.coralLedgers.insert(
            SuliJoyCoralCoinLedger(
                ledgerID: "suli_ledger_\(UUID().uuidString)",
                kind: .joinedActivity,
                coinDelta: -coinCost,
                referenceID: tideID,
                createdAt: Date()
            ),
            at: 0
        )
        save(wallet)
        return .success(wallet, message: "Coins spent.")
    }

    func addRecharge(pack: SuliJoyPearlCoinPack, transactionID: String) -> SuliJoyLocalRequestEnvelope<SuliJoyShellWallet> {
        var wallet = loadWallet()
        wallet.coinBalance += pack.coinAmount
        wallet.coralLedgers.insert(
            SuliJoyCoralCoinLedger(
                ledgerID: "suli_ledger_\(UUID().uuidString)",
                kind: .iapRecharge,
                coinDelta: pack.coinAmount,
                referenceID: transactionID,
                createdAt: Date()
            ),
            at: 0
        )
        save(wallet)
        return .success(wallet, message: "Recharge completed.")
    }

    private func loadWallet() -> SuliJoyShellWallet {
        guard let data = defaults.data(forKey: walletKey),
              let wallet = try? JSONDecoder().decode(SuliJoyShellWallet.self, from: data) else {
            return SuliJoyShellWallet(coinBalance: 0, coralLedgers: [])
        }
        return wallet
    }

    private func save(_ wallet: SuliJoyShellWallet) {
        guard let data = try? JSONEncoder().encode(wallet) else { return }
        defaults.set(data, forKey: walletKey)
    }
}
