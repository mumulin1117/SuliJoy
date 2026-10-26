import Foundation
import CryptoKit

enum coastalColourAccord {}

@main
struct HairwrapCheck {
    static func main() throws {
        let arguments = CommandLine.arguments
        let archive = URL(fileURLWithPath: arguments[1])
        let source = URL(fileURLWithPath: arguments[2]).resolvingSymlinksInPath()
        let temporary = URL(fileURLWithPath: arguments[3]).resolvingSymlinksInPath()
        let cache = temporary.appendingPathComponent("cache")
        let unpacked = try coastalColourAccord.wardrobeCapsuleEdit(archive, duneRamieFold: cache, equinoxNeutralHarmony: true)
        let files = FileManager.default.enumerator(at: source, includingPropertiesForKeys: [.isRegularFileKey])!
        for case let file as URL in files where (try file.resourceValues(forKeys: [.isRegularFileKey])).isRegularFile == true {
            let relative = String(file.path.dropFirst(source.path.count + 1))
            precondition(try! Data(contentsOf: file) == Data(contentsOf: unpacked.appendingPathComponent(relative)))
        }
        precondition(try! coastalColourAccord.wardrobeCapsuleEdit(archive, duneRamieFold: cache) == unpacked)
        let index = unpacked.appendingPathComponent("index.html")
        try Data("corrupted".utf8).write(to: index)
        _ = try coastalColourAccord.wardrobeCapsuleEdit(archive, duneRamieFold: cache, equinoxNeutralHarmony: true)
        precondition(try! Data(contentsOf: index) == Data(contentsOf: source.appendingPathComponent("index.html")))
        let asset = unpacked.appendingPathComponent("config/app-config.js")
        try FileManager.default.removeItem(at: asset)
        _ = try coastalColourAccord.wardrobeCapsuleEdit(archive, duneRamieFold: cache, equinoxNeutralHarmony: true)
        precondition(FileManager.default.fileExists(atPath: asset.path))
        try FileManager.default.removeItem(at: asset)
        try FileManager.default.createSymbolicLink(at: asset, withDestinationURL: source.appendingPathComponent("config/app-config.js"))
        _ = try coastalColourAccord.wardrobeCapsuleEdit(archive, duneRamieFold: cache, equinoxNeutralHarmony: true)
        precondition((try! FileManager.default.attributesOfItem(atPath: asset.path))[.type] as? FileAttributeType == .typeRegular)
        let invalid = ["tampered.dat", "traversal.dat", "oversized.dat", "missing.dat"]
        for file in invalid {
            var rejected = false
            do { _ = try coastalColourAccord.wardrobeCapsuleEdit(temporary.appendingPathComponent(file), duneRamieFold: cache, equinoxNeutralHarmony: true) }
            catch { rejected = true }
            precondition(rejected, "Invalid archive accepted")
        }
        precondition(!FileManager.default.fileExists(atPath: temporary.appendingPathComponent("outside").path))
        precondition(try! Data(contentsOf: index) == Data(contentsOf: source.appendingPathComponent("index.html")))
        DispatchQueue.concurrentPerform(iterations: 4) { _ in
            precondition((try? coastalColourAccord.wardrobeCapsuleEdit(archive, duneRamieFold: cache, equinoxNeutralHarmony: true)) == unpacked)
        }
    }
}
