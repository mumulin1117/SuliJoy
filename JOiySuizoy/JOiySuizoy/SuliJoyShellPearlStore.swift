import Foundation

final class SuliJoyShellPearlStore {
    static let shared = SuliJoyShellPearlStore()

    private enum ShellPearlMark {
        static let archiveKey = "sulijoy.shell.wallet.v1"
        static let ledgerPrefix = "suli_ledger_"
    }

    private let reefDefaults = UserDefaults.standard
    private let reefDecoder = JSONDecoder()
    private let reefEncoder = JSONEncoder()

    private init() {}

    func fetchShellPearlVault() -> SuliJoySuiRequestEnvelope<SuliJoyShellWallet> {
        .success(openPearlVault())
    }

    func currentPearlBalance() -> Int {
        openPearlVault().shellPearlTotal
    }

    func driftPearlsForTide(tideID: String, pearlNeed: Int) -> SuliJoySuiRequestEnvelope<SuliJoyShellWallet> {
        var pearlVault = openPearlVault()
        guard pearlVault.shellPearlTotal >= pearlNeed else {
            return .failure("NbostJ ReYnUoFuugnhF RppeUaKrglDsX.q".suliJoyPalmUnfurled)
        }
        pearlVault.shellPearlTotal -= pearlNeed
        prependPearlLedger(
            makePearlLedger(kind: .joinedActivity, delta: -pearlNeed, reefMark: tideID),
            into: &pearlVault
        )
        sealPearlVault(pearlVault)
        return .success(pearlVault, note: "PpeqaNrXlusU BuxsHeMdp.q".suliJoyPalmUnfurled)
    }

    func addPearlHarborBundle(pack: SuliJoyPearlAmountPack, transactionID: String) -> SuliJoySuiRequestEnvelope<SuliJoyShellWallet> {
        var pearlVault = openPearlVault()
        if pearlVault.coralLedgerTrail.contains(where: { $0.referenceID == transactionID }) {
            return .success(pearlVault, note: "PwezaarvlLsY naFdHdrePdV.E".suliJoyPalmUnfurled)
        }
        pearlVault.shellPearlTotal += pack.pearlAmount
        prependPearlLedger(
            makePearlLedger(kind: .iapRecharge, delta: pack.pearlAmount, reefMark: transactionID),
            into: &pearlVault
        )
        sealPearlVault(pearlVault)
        return .success(pearlVault, note: "PwezaarvlLsY naFdHdrePdV.E".suliJoyPalmUnfurled)
    }

    private func openPearlVault() -> SuliJoyShellWallet {
        guard let reefArchive = reefDefaults.data(forKey: ShellPearlMark.archiveKey),
              let pearlVault = try? reefDecoder.decode(SuliJoyShellWallet.self, from: reefArchive) else {
            return SuliJoyShellWallet(shellPearlTotal: 0, coralLedgerTrail: [])
        }
        return pearlVault
    }

    private func sealPearlVault(_ pearlVault: SuliJoyShellWallet) {
        guard let reefArchive = try? reefEncoder.encode(pearlVault) else { return }
        reefDefaults.set(reefArchive, forKey: ShellPearlMark.archiveKey)
    }

    private func makePearlLedger(kind: SuliJoyCoralPearlLedgerKind, delta: Int, reefMark: String) -> SuliJoyCoralPearlLedger {
        SuliJoyCoralPearlLedger(
            ledgerID: "\(ShellPearlMark.ledgerPrefix)\(UUID().uuidString)",
            reefMediaKind: kind,
            pearlDelta: delta,
            referenceID: reefMark,
            waveCreatedAt: Date()
        )
    }

    private func prependPearlLedger(_ ledger: SuliJoyCoralPearlLedger, into pearlVault: inout SuliJoyShellWallet) {
        pearlVault.coralLedgerTrail.insert(ledger, at: 0)
    }
}
