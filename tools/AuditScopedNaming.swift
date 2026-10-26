import Foundation
import SwiftParser
import SwiftSyntax

final class InverseNames: SyntaxRewriter {
    let names: [String: String]
    init(_ names: [String: String]) { self.names = names; super.init(viewMode: .sourceAccurate) }
    override func visit(_ token: TokenSyntax) -> TokenSyntax {
        guard case .identifier(let value) = token.tokenKind, let original = names[value] else { return token }
        var token = token
        token.tokenKind = .identifier(original)
        return token
    }
}

let planURL = URL(fileURLWithPath: CommandLine.arguments[1])
let plan = try JSONSerialization.jsonObject(with: Data(contentsOf: planURL)) as! [String: Any]
let mapping = plan["mapping"] as! [String: String]
let target = plan["target"] as! String
let before = try String(contentsOf: URL(fileURLWithPath: plan["source"] as! String).appendingPathComponent(target), encoding: .utf8)
let after = try String(contentsOf: URL(fileURLWithPath: CommandLine.arguments[2]).appendingPathComponent(target), encoding: .utf8)
let a = Parser.parse(source: before), b = Parser.parse(source: after)
precondition(!a.hasError && !b.hasError)
let restored = InverseNames(Dictionary(uniqueKeysWithValues: mapping.map { ($0.value, $0.key) })).rewrite(b)
let lhs = a.tokens(viewMode: .sourceAccurate).map(\.tokenKind)
let rhs = restored.tokens(viewMode: .sourceAccurate).map(\.tokenKind)
precondition(lhs == rhs, "Unexpected non-identifier change")
let result: [String: Any] = ["file": target, "identifiers": mapping.count, "all_tokens_identical_after_inverse_rename": true, "strings_selectors_and_layout_expressions_preserved": true]
try JSONSerialization.data(withJSONObject: result, options: [.prettyPrinted, .sortedKeys]).write(to: planURL.deletingLastPathComponent().appendingPathComponent("syntax-audit.json"))
