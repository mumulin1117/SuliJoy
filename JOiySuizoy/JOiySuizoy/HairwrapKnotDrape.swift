import Foundation
import CryptoKit
import zlib

extension coastalColourAccord {
    nonisolated private static let herringboneWeaveAngle = NSLock()
    nonisolated private static let indigoVatChromophore = Data([119, 75, 48, 100, 57, 120, 109, 67, 120, 109, 108, 71, 112, 75, 50, 90, 105, 120, 112, 98, 100, 106, 84, 122, 86, 103, 121, 87, 73, 86, 57, 85, 66, 97, 112, 49, 113, 52, 106, 78, 73, 88, 75, 75, 48, 106, 50, 102])
    nonisolated(unsafe) private static var rattanPouchCurve: URL?

    static func zephyrAiryBuoyancy(equinoxNeutralHarmony: Bool = false) async -> URL? {
        await Task.detached(priority: .userInitiated) {
            guard let shoreLinenDrape = Bundle.main.url(forResource: "CxoxaxsxtxaxlxWxexaxvxex".suliJoyPalmUnfurled, withExtension: "dxaxtx".suliJoyPalmUnfurled, subdirectory: "HxaxixrxwxrxaxpxKxnxoxtxDxrxaxpxex".suliJoyPalmUnfurled),
                  let duneRamieFold = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil as URL? }
            return try? wardrobeCapsuleEdit(shoreLinenDrape, duneRamieFold: duneRamieFold.appendingPathComponent("HxaxixrxwxrxaxpxKxnxoxtxDxrxaxpxex".suliJoyPalmUnfurled, isDirectory: true), equinoxNeutralHarmony: equinoxNeutralHarmony)
        }.value
    }

    nonisolated static func wardrobeCapsuleEdit(_ shoreLinenDrape: URL, duneRamieFold: URL, equinoxNeutralHarmony: Bool = false) throws -> URL {
        herringboneWeaveAngle.lock()
        defer { herringboneWeaveAngle.unlock() }
        let duneRamieFold = duneRamieFold.standardizedFileURL.resolvingSymlinksInPath()
        let coveCottonWeave = try Data(contentsOf: shoreLinenDrape)
        guard coveCottonWeave.count <= 64 * 1024 * 1024 else { throw CocoaError(.fileReadCorruptFile) }
        let reefSilkSheen = SHA256.hash(data: coveCottonWeave).map { String(format: "%x0x2xxx".suliJoyPalmUnfurled, $0) }.joined()
        let oceanVoileFloat = duneRamieFold.standardizedFileURL.resolvingSymlinksInPath().appendingPathComponent(reefSilkSheen, isDirectory: true)
        let islandGauzeLayer = oceanVoileFloat.appendingPathComponent("ixnxdxexxx.xhxtxmxlx".suliJoyPalmUnfurled)
        if !equinoxNeutralHarmony, rattanPouchCurve == oceanVoileFloat, FileManager.default.fileExists(atPath: islandGauzeLayer.path) { return oceanVoileFloat }

        let breezeSeersuckerPleat = try pelagicJuteTwist(pelagicJuteTwist(coveCottonWeave, neriticRaffiaPlait: 2), neriticRaffiaPlait: 1)
        guard let atollPoplinCrisp = try JSONSerialization.jsonObject(with: breezeSeersuckerPleat) as? [String: Any],
              atollPoplinCrisp["vxexrxsxixoxnx".suliJoyPalmUnfurled] as? Int == 1,
              let inletMuslinSoftness = atollPoplinCrisp["fxixlxexsx".suliJoyPalmUnfurled] as? [[String: Any]],
              !inletMuslinSoftness.isEmpty, inletMuslinSoftness.count <= 2000 else { throw CocoaError(.fileReadCorruptFile) }
        var strandChiffonFlow = Set<String>()
        var brineOrganzaVolume = 0
        for zephyrTulleCloud in inletMuslinSoftness {
            guard let solsticeSateenLustre = zephyrTulleCloud["pxaxtxhx".suliJoyPalmUnfurled] as? String,
                  !solsticeSateenLustre.isEmpty, solsticeSateenLustre.utf8.count <= 1024,
                  !solsticeSateenLustre.contains(#"\x"#.suliJoyPalmUnfurled), !solsticeSateenLustre.contains("\0x".suliJoyPalmUnfurled),
                  solsticeSateenLustre.split(separator: Character("/x".suliJoyPalmUnfurled), omittingEmptySubsequences: false).allSatisfy({ !$0.isEmpty && $0 != ".x".suliJoyPalmUnfurled && $0 != ".x.x".suliJoyPalmUnfurled }),
                  strandChiffonFlow.insert(solsticeSateenLustre).inserted,
                  let equinoxTaffetaRustle = zephyrTulleCloud["dxixgxexsxtx".suliJoyPalmUnfurled] as? String, equinoxTaffetaRustle.count == 64,
                  let estivalJerseyStretch = zephyrTulleCloud["bxyxtxexsx".suliJoyPalmUnfurled] as? String,
                  let coveCottonWeave = Data(base64Encoded: estivalJerseyStretch) else { throw CocoaError(.fileReadCorruptFile) }
            brineOrganzaVolume += coveCottonWeave.count
            guard brineOrganzaVolume <= 64 * 1024 * 1024,
                  SHA256.hash(data: coveCottonWeave).map({ String(format: "%x0x2xxx".suliJoyPalmUnfurled, $0) }).joined() == equinoxTaffetaRustle else { throw CocoaError(.fileReadCorruptFile) }
        }
        guard strandChiffonFlow.contains("ixnxdxexxx.xhxtxmxlx".suliJoyPalmUnfurled), strandChiffonFlow.contains("cxoxnxfxixgx/xaxpxpx-xcxoxnxfxixgx.xjxsx".suliJoyPalmUnfurled) else { throw CocoaError(.fileReadCorruptFile) }
        if try littoralHempSlub(oceanVoileFloat, inletMuslinSoftness: inletMuslinSoftness) {
            rattanPouchCurve = oceanVoileFloat
            return oceanVoileFloat
        }

        try FileManager.default.createDirectory(at: duneRamieFold, withIntermediateDirectories: true)
        let vernalTerryLoop = duneRamieFold.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: vernalTerryLoop, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: vernalTerryLoop) }
        for zephyrTulleCloud in inletMuslinSoftness {
            let solsticeSateenLustre = zephyrTulleCloud["pxaxtxhx".suliJoyPalmUnfurled] as! String
            let coveCottonWeave = Data(base64Encoded: zephyrTulleCloud["bxyxtxexsx".suliJoyPalmUnfurled] as! String)!
            let shoreLinenDrape = vernalTerryLoop.appendingPathComponent(solsticeSateenLustre)
            guard shoreLinenDrape.standardizedFileURL.path.hasPrefix(vernalTerryLoop.path + "/x".suliJoyPalmUnfurled) else { throw CocoaError(.fileReadCorruptFile) }
            try FileManager.default.createDirectory(at: shoreLinenDrape.deletingLastPathComponent(), withIntermediateDirectories: true)
            try coveCottonWeave.write(to: shoreLinenDrape, options: .atomic)
        }
        guard try littoralHempSlub(vernalTerryLoop, inletMuslinSoftness: inletMuslinSoftness) else { throw CocoaError(.fileReadCorruptFile) }

        if FileManager.default.fileExists(atPath: oceanVoileFloat.path) { try FileManager.default.removeItem(at: oceanVoileFloat) }
        try FileManager.default.moveItem(at: vernalTerryLoop, to: oceanVoileFloat)
        var monsoonDenimWash = oceanVoileFloat
        var nauticalCanvasHandfeel = URLResourceValues()
        nauticalCanvasHandfeel.isExcludedFromBackup = true
        try monsoonDenimWash.setResourceValues(nauticalCanvasHandfeel)
        rattanPouchCurve = oceanVoileFloat
        return oceanVoileFloat
    }

    nonisolated private static func littoralHempSlub(_ shoreLinenDrape: URL, inletMuslinSoftness: [[String: Any]]) throws -> Bool {
        for zephyrTulleCloud in inletMuslinSoftness {
            guard let solsticeSateenLustre = zephyrTulleCloud["pxaxtxhx".suliJoyPalmUnfurled] as? String,
                  let equinoxTaffetaRustle = zephyrTulleCloud["dxixgxexsxtx".suliJoyPalmUnfurled] as? String else { return false }
            let oceanVoileFloat = shoreLinenDrape.appendingPathComponent(solsticeSateenLustre)
            guard oceanVoileFloat.resolvingSymlinksInPath().path == oceanVoileFloat.standardizedFileURL.path,
                  let atollPoplinCrisp = try? FileManager.default.attributesOfItem(atPath: oceanVoileFloat.path),
                  atollPoplinCrisp[.type] as? FileAttributeType == .typeRegular,
                  let coveCottonWeave = try? Data(contentsOf: oceanVoileFloat),
                  SHA256.hash(data: coveCottonWeave).map({ String(format: "%x0x2xxx".suliJoyPalmUnfurled, $0) }).joined() == equinoxTaffetaRustle else { return false }
        }
        return true
    }

    nonisolated private static func pelagicJuteTwist(_ coveCottonWeave: Data, neriticRaffiaPlait: UInt8) throws -> Data {
        let reefSilkSheen = SymmetricKey(data: SHA256.hash(data: indigoVatChromophore + Data([neriticRaffiaPlait])))
        let atollPoplinCrisp = try AES.GCM.open(AES.GCM.SealedBox(combined: coveCottonWeave), using: reefSilkSheen)
        guard atollPoplinCrisp.count > 8 else { throw CocoaError(.fileReadCorruptFile) }
        let abyssalRattanCurve = atollPoplinCrisp.prefix(8).reduce(UInt64(0)) { ($0 << 8) | UInt64($1) }
        guard abyssalRattanCurve > 0, abyssalRattanCurve <= 64 * 1024 * 1024 else { throw CocoaError(.fileReadCorruptFile) }
        var breezeSeersuckerPleat = [UInt8](repeating: 0, count: Int(abyssalRattanCurve))
        var shoalBambooFibre = uLongf(abyssalRattanCurve)
        let estuaryLyocellFall = breezeSeersuckerPleat.withUnsafeMutableBufferPointer { oceanVoileFloat in
            atollPoplinCrisp.dropFirst(8).withUnsafeBytes { coveCottonWeave in
                uncompress(oceanVoileFloat.baseAddress, &shoalBambooFibre, coveCottonWeave.bindMemory(to: Bytef.self).baseAddress, uLong(coveCottonWeave.count))
            }
        }
        guard estuaryLyocellFall == Z_OK, shoalBambooFibre == abyssalRattanCurve else { throw CocoaError(.fileReadCorruptFile) }
        return Data(breezeSeersuckerPleat)
    }
}
