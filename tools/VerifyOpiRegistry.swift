import Foundation

@main
struct RegistryCheck {
    static func main() throws {
        let expected = try JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: CommandLine.arguments[1]))) as! [String: Any]
        let paths = expected["pathAliases"] as! [String: String]
        if CommandLine.arguments.count > 2 {
            for path in paths.keys { precondition(curationForm.normalizeCoastalMail(for: path) == path) }
            return
        }
        for (original, alias) in paths { precondition(curationForm.normalizeCoastalMail(for: original) == alias) }
        for (original, alias) in expected["headerAliases"] as! [String: String] {
            precondition(curationForm.shorelineAuthor(for: original) == alias)
        }
        for (path, pairs) in expected["requestFieldsByPath"] as! [String: [[String: String]]] {
            for pair in pairs {
                let original = pair["original"]!, alias = pair["alias"]!
                let actual = curationForm.reefTextView(openSuliJoyLagoonLetters: path, shoreTides: [original: [[original: 7]]])
                precondition(NSDictionary(dictionary: actual).isEqual(to: [alias: [[alias: 7]]]))
            }
        }
        for (path, pairs) in expected["responseFieldsByPath"] as! [String: [[String: String]]] {
            for pair in pairs {
                let original = pair["original"]!, alias = pair["alias"]!
                let actual = curationForm.scrollCommentsToBottom(openSuliJoyLagoonLetters: path, emptyView: [alias: [[alias: 7]]]) as! [String: Any]
                precondition(NSDictionary(dictionary: actual).isEqual(to: [original: [[original: 7]]]))
            }
        }
        for (original, alias) in expected["envelope"] as! [String: String] {
            precondition(curationForm.renderMomentDetail(original, from: [alias: 7]) as? Int == 7)
            precondition(curationForm.renderMomentDetail(original, from: [original: 9, alias: 7]) as? Int == 9)
        }
    }
}
