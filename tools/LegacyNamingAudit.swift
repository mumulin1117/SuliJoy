import Foundation
import SwiftParser
import SwiftSyntax

func qualified(_ node: some SyntaxProtocol, name: String) -> String {
    var names = [name]
    var parent = node.parent
    while let item = parent {
        if let value = item.as(StructDeclSyntax.self) { names.append(value.name.text) }
        if let value = item.as(EnumDeclSyntax.self) { names.append(value.name.text) }
        if let value = item.as(ClassDeclSyntax.self) { names.append(value.name.text) }
        parent = item.parent
    }
    return names.reversed().joined(separator: ".")
}

final class Shapes: SyntaxVisitor {
    var keys = Set<String>()
    var explicitRaw = Set<String>()
    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        if node.memberBlock.members.contains(where: { $0.decl.as(EnumDeclSyntax.self)?.name.text == "CodingKeys" }) {
            keys.insert(qualified(node, name: node.name.text))
        }
        return .visitChildren
    }
    override func visit(_ node: EnumCaseElementSyntax) -> SyntaxVisitorContinueKind {
        if node.rawValue != nil { explicitRaw.insert(qualified(node, name: node.name.text)) }
        return .visitChildren
    }
}

final class RestoreIdentifiers: SyntaxRewriter {
    let reverse: [String: String]
    init(_ reverse: [String: String]) { self.reverse = reverse; super.init(viewMode: .sourceAccurate) }
    override func visit(_ token: TokenSyntax) -> TokenSyntax {
        guard case .identifier(let value) = token.tokenKind, let old = reverse[value] else { return token }
        var result = token; result.tokenKind = .identifier(old); return result
    }
}

final class StripCompatibilitySyntax: SyntaxRewriter {
    let baseline: Shapes
    init(_ baseline: Shapes) { self.baseline = baseline; super.init(viewMode: .sourceAccurate) }
    override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        var result = node
        if !baseline.keys.contains(qualified(node, name: node.name.text)) {
            result.memberBlock.members = MemberBlockItemListSyntax(node.memberBlock.members.filter {
                $0.decl.as(EnumDeclSyntax.self)?.name.text != "CodingKeys"
            })
        }
        return super.visit(result)
    }
    override func visit(_ node: EnumCaseElementSyntax) -> EnumCaseElementSyntax {
        var result = node
        if let raw = node.rawValue, !baseline.explicitRaw.contains(qualified(node, name: node.name.text)),
           raw.value.as(StringLiteralExprSyntax.self)?.representedLiteralValue == node.name.text {
            result.rawValue = nil
        }
        return super.visit(result)
    }
    override func visit(_ node: FunctionParameterSyntax) -> FunctionParameterSyntax {
        var node = node
        if node.firstName.text == node.secondName?.text { node.secondName = nil }
        return super.visit(node)
    }
    override func visit(_ node: OptionalBindingConditionSyntax) -> OptionalBindingConditionSyntax {
        var node = node
        if let id = node.pattern.as(IdentifierPatternSyntax.self),
           node.initializer?.value.trimmedDescription == id.identifier.text {
            node.initializer = nil
        }
        return super.visit(node)
    }
}

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let reportRoot = root.appendingPathComponent("reports/naming-migration")
let plan = try JSONSerialization.jsonObject(with: Data(contentsOf: reportRoot.appendingPathComponent("rename-plan.json"))) as! [String: Any]
let mapping = plan["mapping"] as! [String: String]
let beforeRoot = reportRoot.appendingPathComponent("before-source")
let afterRoot = root.appendingPathComponent("JOiySuizoy/JOiySuizoy")
var rows: [[String: Any]] = []
for case let file as URL in FileManager.default.enumerator(at: beforeRoot, includingPropertiesForKeys: nil)! where file.pathExtension == "swift" {
    let rel = String(file.path.dropFirst(beforeRoot.path.count + 1))
    let a = Parser.parse(source: try String(contentsOf: file, encoding: .utf8))
    let b = Parser.parse(source: try String(contentsOf: afterRoot.appendingPathComponent(rel), encoding: .utf8))
    let shapes = Shapes(viewMode: .sourceAccurate); shapes.walk(a)
    let beforeNames = Set(a.tokens(viewMode: .sourceAccurate).map(\.text))
    let reverse = Dictionary(uniqueKeysWithValues: mapping.filter { beforeNames.contains($0.key) }.map { ($0.value, $0.key) })
    let restored = RestoreIdentifiers(reverse).rewrite(b)
    let ca = StripCompatibilitySyntax(shapes).rewrite(a).tokens(viewMode: .sourceAccurate).map { String(describing: $0.tokenKind) }
    let cb = StripCompatibilitySyntax(shapes).rewrite(restored).tokens(viewMode: .sourceAccurate).map { String(describing: $0.tokenKind) }
    let equal = ca == cb
    rows.append(["file": rel, "identical_after_inverse_rename": equal, "before_tokens": ca.count, "after_tokens": cb.count])
}
let data = try JSONSerialization.data(withJSONObject: rows.sorted { ($0["file"] as! String) < ($1["file"] as! String) }, options: [.prettyPrinted, .sortedKeys])
try data.write(to: reportRoot.appendingPathComponent("semantic-token-audit.json"))
let failed = rows.filter { !($0["identical_after_inverse_rename"] as! Bool) }.count
if failed > 0 { exit(1) }
