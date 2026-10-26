import Foundation
import SwiftParser
import SwiftSyntax
import SwiftSyntaxBuilder

let root = URL(fileURLWithPath: CommandLine.arguments[1])
let report = URL(fileURLWithPath: CommandLine.arguments[2])
let fm = FileManager.default
try fm.createDirectory(at: report.appendingPathComponent("before-source"), withIntermediateDirectories: true)
var records = [[String: Any]]()

final class EncodeStrings: SyntaxRewriter {
    var changed = 0
    var skipped = [String: Int]()
    func encodedExpression(_ value: String) -> ExprSyntax {
        let encoded = value.map { String($0) + "x" }.joined()
        let decoded = String(encoded.enumerated().filter { $0.offset.isMultiple(of: 2) }.map(\.element))
        precondition(decoded == value, "Character round-trip mismatch")
        return ExprSyntax("\(StringLiteralExprSyntax(content: encoded)).suliJoyPalmUnfurled")
    }
    func skip(_ reason: String, _ node: StringLiteralExprSyntax) -> ExprSyntax {
        skipped[reason, default: 0] += 1
        return super.visit(node)
    }
    override func visit(_ node: StringLiteralExprSyntax) -> ExprSyntax {
        if let member = node.parent?.as(MemberAccessExprSyntax.self), member.declName.baseName.text == "suliJoyPalmUnfurled" {
            return ExprSyntax(node)
        }
        var parent = node.parent
        while let ancestor = parent {
            if ancestor.is(EnumCaseElementSyntax.self) || ancestor.is(AttributeSyntax.self) || ancestor.is(MacroExpansionExprSyntax.self) {
                return skip("compile-time literal", node)
            }
            if ancestor.is(CodeBlockItemSyntax.self) || ancestor.is(MemberBlockItemSyntax.self) { break }
            parent = ancestor.parent
        }
        guard let value = node.representedLiteralValue else {
            // Resolve escape sequences and multiline indentation with SwiftSyntax,
            // substituting markers only for interpolation expressions, never their values.
            let marker = "SULIJOY_STRING_BOUNDARY_8A6D3E"
            precondition(!node.description.contains(marker))
            var flat = node
            flat.segments = StringLiteralSegmentListSyntax(node.segments.map { segment in
                if segment.is(ExpressionSegmentSyntax.self) {
                    return .stringSegment(StringSegmentSyntax(content: .stringSegment(marker)))
                }
                return segment
            })
            guard let flattened = flat.representedLiteralValue else { return skip("unsupported literal", node) }
            let pieces = flattened.components(separatedBy: marker)
            let expressions = node.segments.compactMap { $0.as(ExpressionSegmentSyntax.self) }
            guard pieces.count == expressions.count + 1 else { return skip("unsupported literal", node) }
            var segments = [StringLiteralSegmentListSyntax.Element]()
            for index in pieces.indices {
                if !pieces[index].isEmpty {
                    segments.append(.expressionSegment(ExpressionSegmentSyntax(expressions: LabeledExprListSyntax([
                        LabeledExprSyntax(expression: encodedExpression(pieces[index]))
                    ]))))
                }
                if index < expressions.count {
                    var expression = expressions[index]
                    expression.pounds = nil
                    expression = super.visit(expression)
                    segments.append(.expressionSegment(expression))
                }
            }
            var result = StringLiteralExprSyntax(openingQuote: .stringQuoteToken(), segments: StringLiteralSegmentListSyntax(segments), closingQuote: .stringQuoteToken())
            result.leadingTrivia = node.leadingTrivia
            result.trailingTrivia = node.trailingTrivia
            changed += 1
            return ExprSyntax(result)
        }
        guard !value.isEmpty else { return ExprSyntax(node) }
        // Work in Swift Characters, exactly like the existing decoder (including emoji).
        var expression = encodedExpression(value)
        var context = node.parent
        while let ancestor = context {
            if let argument = ancestor.as(LabeledExprSyntax.self), argument.label?.text == "whereSeparator", value.count == 1 {
                expression = ExprSyntax("Character(\(expression))")
                break
            }
            context = ancestor.parent
        }
        if let argument = node.parent?.as(LabeledExprSyntax.self), argument.label?.text == "separator",
           let call = argument.parent?.parent?.as(FunctionCallExprSyntax.self),
           call.calledExpression.as(MemberAccessExprSyntax.self)?.declName.baseName.text == "split", value.count == 1 {
            expression = ExprSyntax("Character(\(expression))")
        }
        expression.leadingTrivia = node.leadingTrivia
        expression.trailingTrivia = node.trailingTrivia
        changed += 1
        return expression
    }
}

for url in try fm.contentsOfDirectory(at: root, includingPropertiesForKeys: nil).filter({ $0.pathExtension == "swift" }).sorted(by: { $0.path < $1.path }) {
    if url.lastPathComponent == "SuliJoyPalmGlyphWeaver.swift" { continue }
    let snapshot = report.appendingPathComponent("before-source").appendingPathComponent(url.lastPathComponent)
    let source = try String(contentsOf: fm.fileExists(atPath: snapshot.path) ? snapshot : url, encoding: .utf8)
    if !fm.fileExists(atPath: snapshot.path) { try source.write(to: snapshot, atomically: true, encoding: .utf8) }
    let rewriter = EncodeStrings(viewMode: .sourceAccurate)
    let result = rewriter.rewrite(Parser.parse(source: source)).description
    if result != source { try result.write(to: url, atomically: true, encoding: .utf8) }
    records.append(["file": url.lastPathComponent, "encoded": rewriter.changed, "excluded": rewriter.skipped])
}
try JSONSerialization.data(withJSONObject: records, options: [.prettyPrinted, .sortedKeys]).write(to: report.appendingPathComponent("summary.json"))
print("Encoded \(records.reduce(0) { $0 + ($1["encoded"] as! Int) }) literals")
