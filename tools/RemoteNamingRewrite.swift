import Foundation
import SwiftParser
import SwiftSyntax
import SwiftSyntaxBuilder

struct RenamePlan: Decodable {
    let mapping: [String: String]
    let protected_offsets: [String: [[Int]]]
    let external_call_offsets: [String: [[Int]]]
    let source: String
}

final class TokenRename: SyntaxRewriter {
    let mapping: [String: String]
    let converter: SourceLocationConverter
    let externalPositions: Set<String>
    let externalCallPositions: Set<String>
    let localCallPositions: Set<String>
    var skipPositions = Set<Int>()
    init(mapping: [String: String], tree: SourceFileSyntax, file: String, positions: [[Int]], callPositions: [[Int]], localCalls: [[Int]] = []) {
        self.mapping = mapping
        converter = SourceLocationConverter(fileName: file, tree: tree)
        externalPositions = Set(positions.map { "\($0[0]):\($0[1])" })
        externalCallPositions = Set(callPositions.map { "\($0[0]):\($0[1])" })
        localCallPositions = Set(localCalls.map { "\($0[0]):\($0[1])" })
        super.init(viewMode: .sourceAccurate)
    }
    func isExternal(_ token: TokenSyntax) -> Bool {
        let loc = converter.location(for: token.positionAfterSkippingLeadingTrivia)
        return externalPositions.contains("\(loc.line):\(loc.column)")
    }
    override func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
        if isExternal(node.name) {
            for parameter in node.signature.parameterClause.parameters {
                skipPositions.insert(parameter.firstName.positionAfterSkippingLeadingTrivia.utf8Offset)
            }
        }
        return super.visit(node)
    }
    override func visit(_ node: FunctionParameterSyntax) -> FunctionParameterSyntax {
        var ancestor = node.parent
        while let current = ancestor {
            if let function = current.as(FunctionDeclSyntax.self) {
                if isExternal(function.name), node.secondName == nil,
                   let replacement = mapping[node.firstName.text] {
                    var result = super.visit(node)
                    result.firstName = node.firstName
                    result.secondName = .identifier(replacement, leadingTrivia: .space)
                    return result
                }
                break
            }
            ancestor = current.parent
        }
        return super.visit(node)
    }
    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        if node.calledExpression.tokens(viewMode: .sourceAccurate).contains(where: { token in
            let loc = converter.location(for: token.positionAfterSkippingLeadingTrivia)
            return localCallPositions.contains("\(loc.line):\(loc.column)")
        }) { return super.visit(node) }
        if node.calledExpression.tokens(viewMode: .sourceAccurate).contains(where: { token in
            let loc = converter.location(for: token.positionAfterSkippingLeadingTrivia)
            return isExternal(token) || externalCallPositions.contains("\(loc.line):\(loc.column)")
        }) {
            for arg in node.arguments {
                if let label = arg.label { skipPositions.insert(label.positionAfterSkippingLeadingTrivia.utf8Offset) }
            }
        }
        return super.visit(node)
    }
    override func visit(_ node: MemberAccessExprSyntax) -> ExprSyntax {

        if ["element", "key", "value"].contains(node.declName.baseName.text) {
            skipPositions.insert(node.declName.baseName.positionAfterSkippingLeadingTrivia.utf8Offset)
        }
        return super.visit(node)
    }
    override func visit(_ node: CatchClauseSyntax) -> CatchClauseSyntax {
        var result = super.visit(node)
        if node.catchItems.isEmpty, let replacement = mapping["error"] {
            result.catchItems = CatchItemListSyntax([
                CatchItemSyntax(pattern: PatternSyntax(ValueBindingPatternSyntax(bindingSpecifier: .keyword(.let, leadingTrivia: .space, trailingTrivia: .space), pattern: IdentifierPatternSyntax(identifier: .identifier(replacement)))))
            ])
            result.catchKeyword.trailingTrivia = []
        }
        return result
    }
    override func visit(_ token: TokenSyntax) -> TokenSyntax {
        guard case .identifier(let value) = token.tokenKind,
              let replacement = mapping[value], !isExternal(token),
              !skipPositions.contains(token.positionAfterSkippingLeadingTrivia.utf8Offset) else { return token }
        var token = token
        token.tokenKind = .identifier(replacement)
        return token
    }
}

final class PreserveWireNames: SyntaxRewriter {
    let reverse: [String: String]
    init(reverse: [String: String]) {
        self.reverse = reverse
        super.init(viewMode: .sourceAccurate)
    }
    override func visit(_ node: EnumDeclSyntax) -> DeclSyntax {
        let isString = node.inheritanceClause?.inheritedTypes.contains { $0.type.trimmedDescription == "String" } ?? false
        guard isString else { return super.visit(node) }
        var node = node
        node.memberBlock.members = MemberBlockItemListSyntax(node.memberBlock.members.map { item in
            guard var declaration = item.decl.as(EnumCaseDeclSyntax.self) else { return item }
            declaration.elements = EnumCaseElementListSyntax(declaration.elements.map { element in
                var element = element
                if element.rawValue == nil, let original = reverse[element.name.text] {
                    element.rawValue = InitializerClauseSyntax(
                        equal: .equalToken(leadingTrivia: .space, trailingTrivia: .space),
                        value: ExprSyntax(StringLiteralExprSyntax(content: original)))
                }
                return element
            })
            var item = item; item.decl = DeclSyntax(declaration); return item
        })
        return super.visit(node)
    }
    override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        let codable = node.inheritanceClause?.inheritedTypes.contains {
            ["Codable", "Encodable", "Decodable"].contains($0.type.trimmedDescription)
        } ?? false
        let hasKeys = node.memberBlock.members.contains {
            $0.decl.as(EnumDeclSyntax.self)?.name.text == "CodingKeys"
        }
        guard codable, !hasKeys else { return super.visit(node) }
        var properties: [String] = []
        var changed = false
        for member in node.memberBlock.members {
            guard let variable = member.decl.as(VariableDeclSyntax.self),
                  !variable.modifiers.contains(where: { ["static", "class"].contains($0.name.text) }) else { continue }
            for binding in variable.bindings {
                guard binding.accessorBlock == nil,
                      let id = binding.pattern.as(IdentifierPatternSyntax.self) else { continue }
                let name = id.identifier.text
                let original = reverse[name] ?? name
                changed = changed || original != name
                properties.append("        case \(name) = \"\(original)\"")
            }
        }
        guard changed else { return super.visit(node) }
        let code = "\n    private enum CodingKeys: String, CodingKey {\n" + properties.joined(separator: "\n") + "\n    }\n"
        var node = node
        node.memberBlock.members.append(MemberBlockItemSyntax(decl: DeclSyntax(stringLiteral: code)))
        return super.visit(node)
    }
}

final class ReferenceRename: SyntaxRewriter {
    let converter: SourceLocationConverter
    let references: [String: String]
    let callPositions: Set<String>
    let mapping: [String: String]
    var labels: [Int: String] = [:]
    init(tree: SourceFileSyntax, references: [String: String], calls: [[Int]], mapping: [String: String]) {
        converter = SourceLocationConverter(fileName: "", tree: tree)
        self.references = references
        callPositions = Set(calls.map { "\($0[0]):\($0[1])" })
        self.mapping = mapping
        super.init(viewMode: .sourceAccurate)
    }
    func position(_ token: TokenSyntax) -> String {
        let loc = converter.location(for: token.positionAfterSkippingLeadingTrivia)
        return "\(loc.line):\(loc.column)"
    }
    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        if node.calledExpression.tokens(viewMode: .sourceAccurate).contains(where: { callPositions.contains(position($0)) }) {
            for argument in node.arguments {
                if let label = argument.label, let replacement = mapping[label.text] {
                    labels[label.positionAfterSkippingLeadingTrivia.utf8Offset] = replacement
                }
            }
        }
        return super.visit(node)
    }
    override func visit(_ token: TokenSyntax) -> TokenSyntax {
        guard case .identifier = token.tokenKind,
              let replacement = references[position(token)] ?? labels[token.positionAfterSkippingLeadingTrivia.utf8Offset] else { return token }
        var result = token; result.tokenKind = .identifier(replacement); return result
    }
}

let args = CommandLine.arguments
guard args.count == 3 else { fatalError("Usage: rewrite plan.json staged-directory") }
let plan = try JSONDecoder().decode(RenamePlan.self, from: Data(contentsOf: URL(fileURLWithPath: args[1])))
let extras = try JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: args[1]))) as! [String: Any]
let target = extras["target"] as! String
let references = extras["references"] as! [String: [String: String]]
let targetCalls = extras["target_calls"] as! [String: [[Int]]]
let source = URL(fileURLWithPath: plan.source)
let staged = URL(fileURLWithPath: args[2])
let files = FileManager.default.enumerator(at: source, includingPropertiesForKeys: nil)!
for case let file as URL in files where file.pathExtension == "swift" {
    let relative = String(file.path.dropFirst(source.path.count + 1))
    let text = try String(contentsOf: file, encoding: .utf8)
    let tree = Parser.parse(source: text)
    guard !tree.hasError else { fatalError("Input syntax error: \(relative)") }
    let tokens = Set(tree.tokens(viewMode: .sourceAccurate).map(\.text))
    let fileMap = plan.mapping.filter { tokens.contains($0.key) }
    let rewriter = TokenRename(mapping: fileMap, tree: tree, file: file.path,
                              positions: plan.protected_offsets[relative] ?? [],
                              callPositions: plan.external_call_offsets[relative] ?? [], localCalls: targetCalls[relative] ?? [])
    let renamed = relative == target ? rewriter.rewrite(tree).as(SourceFileSyntax.self)! : ReferenceRename(tree: tree, references: references[relative] ?? [:], calls: targetCalls[relative] ?? [], mapping: plan.mapping).rewrite(tree).as(SourceFileSyntax.self)!
    let reverse = Dictionary(uniqueKeysWithValues: fileMap.map { ($0.value, $0.key) })
    var result = relative == target ? PreserveWireNames(reverse: reverse).rewrite(renamed).description : renamed.description


    if relative == "SuliJoyIslandVisitorProfileViewController.swift", let local = fileMap["imageView"] {
        result = result.replacingOccurrences(of: "guard let imageView else { return }", with: "guard let \(local) = imageView else { return }")
        result = result.replacingOccurrences(of: "imageView.bounds", with: "\(local).bounds")
        result = result.replacingOccurrences(of: "imageView.frame", with: "\(local).frame")
    }
    guard !Parser.parse(source: result).hasError else { fatalError("Output syntax error: \(relative)") }
    let output = staged.appendingPathComponent(relative)
    try FileManager.default.createDirectory(at: output.deletingLastPathComponent(), withIntermediateDirectories: true)
    try result.write(to: output, atomically: true, encoding: .utf8)
}
