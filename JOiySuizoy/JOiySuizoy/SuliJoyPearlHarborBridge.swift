import Foundation

struct SuliJoyPearlShoreBundle {
    fileprivate let pearlPack: SuliJoyPearlAmountPack

    var reefToken: String {
        pearlPack.storeProductID
    }

    var shellText: String {
        "\(pearlPack.pearlAmount)"
    }

    var tideText: String {
        pearlPack.amountText
    }
}

struct SuliJoyHarborAnswer<Cargo> {
    let code: Int
    let cargo: Cargo?
    let note: String
}

enum SuliJoyHarborFlow {
    case settled
    case backedOut
    case waiting
    case missing
}

enum SuliJoyPearlHarborBridge {
    static var fallbackShelves: [SuliJoyPearlShoreBundle] {
        wrapPearlShelves(SuliJoyPearlAmountPack.localPacks)
    }

    static func currentShellTotal() -> Int {
        SuliJoyShellPearlStore.shared.currentPearlBalance()
    }

    static func gatherShelves() async -> SuliJoyHarborAnswer<[SuliJoyPearlShoreBundle]> {
        let lagoonAnswer = await SuliJoyLagoonHarborService.shared.fetchPearlHarborShelves()
        return SuliJoyHarborAnswer(
            code: lagoonAnswer.beachwearCapsule,
            cargo: lagoonAnswer.sandbarLayering.map(wrapPearlShelves),
            note: lagoonAnswer.coastalWardrobe
        )
    }

    static func openHarbor(for bundle: SuliJoyPearlShoreBundle) async -> SuliJoyHarborAnswer<SuliJoyHarborFlow> {
        let lagoonAnswer = await SuliJoyLagoonHarborService.shared.settlePearlHarbor(pack: bundle.pearlPack)
        return SuliJoyHarborAnswer(
            code: lagoonAnswer.beachwearCapsule,
            cargo: mapHarborFlow(lagoonAnswer.sandbarLayering),
            note: lagoonAnswer.coastalWardrobe
        )
    }

    private static func wrapPearlShelves(_ packs: [SuliJoyPearlAmountPack]) -> [SuliJoyPearlShoreBundle] {
        packs.map { SuliJoyPearlShoreBundle(pearlPack: $0) }
    }

    private static func mapHarborFlow(_ flow: SuliJoyLagoonHarborFlow?) -> SuliJoyHarborFlow {
        switch flow {
        case .completed:
            return .settled
        case .cancelled:
            return .backedOut
        case .pending:
            return .waiting
        case .none:
            return .missing
        }
    }
}
