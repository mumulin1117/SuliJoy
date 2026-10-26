import Foundation
import SwiftParser
import SwiftSyntax
import SwiftSyntaxBuilder

final class CanonicalStrings: SyntaxRewriter {
    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        let visited = super.visit(node)
        if let call = visited.as(FunctionCallExprSyntax.self), call.calledExpression.description == "Character",
           call.arguments.count == 1, let literal = call.arguments.first?.expression.as(StringLiteralExprSyntax.self) {
            return ExprSyntax(literal)
        }
        return visited
    }
    override func visit(_ node: MemberAccessExprSyntax) -> ExprSyntax {
        if node.declName.baseName.text == "suliJoyPalmUnfurled", let base = node.base?.as(StringLiteralExprSyntax.self), let value = base.representedLiteralValue {
            let decoded = String(value.enumerated().filter { $0.offset.isMultiple(of: 2) }.map(\.element))
            return ExprSyntax(StringLiteralExprSyntax(content: decoded))
        }
        return super.visit(node)
    }
    override func visit(_ node: StringLiteralExprSyntax) -> ExprSyntax {
        if let value = node.representedLiteralValue { return ExprSyntax(StringLiteralExprSyntax(content: value)) }
        let marker = "SULIJOY_STRING_BOUNDARY_8A6D3E"
        var flat = node
        flat.segments = StringLiteralSegmentListSyntax(node.segments.map { segment in
            segment.is(ExpressionSegmentSyntax.self) ? .stringSegment(StringSegmentSyntax(content: .stringSegment(marker))) : segment
        })
        guard let value = flat.representedLiteralValue else { fatalError("Unsupported string") }
        let pieces = value.components(separatedBy: marker)
        let expressions = node.segments.compactMap { $0.as(ExpressionSegmentSyntax.self) }
        var output = [StringLiteralSegmentListSyntax.Element]()
        var pending = ""
        for index in pieces.indices {
            pending += pieces[index]
            if index < expressions.count {
                var segment = super.visit(expressions[index])
                segment.pounds = nil
                if segment.expressions.count == 1, segment.expressions.first?.label == nil,
                   let literal = segment.expressions.first?.expression.as(StringLiteralExprSyntax.self), let text = literal.representedLiteralValue {
                    pending += text
                } else {
                    output.append(contentsOf: StringLiteralExprSyntax(content: pending).segments)
                    pending = ""
                    output.append(.expressionSegment(segment))
                }
            }
        }
        output.append(contentsOf: StringLiteralExprSyntax(content: pending).segments)
        return ExprSyntax(StringLiteralExprSyntax(openingQuote: .stringQuoteToken(), segments: StringLiteralSegmentListSyntax(output), closingQuote: .stringQuoteToken()))
    }
}

let before = URL(fileURLWithPath: CommandLine.arguments[1])
let after = URL(fileURLWithPath: CommandLine.arguments[2])
var verified = 0
for file in try FileManager.default.contentsOfDirectory(at: before, includingPropertiesForKeys: nil).filter({ $0.pathExtension == "swift" }) {
    func tokens(_ url: URL) throws -> [TokenKind] {
        let tree = Parser.parse(source: try String(contentsOf: url, encoding: .utf8))
        return CanonicalStrings(viewMode: .sourceAccurate).rewrite(tree).tokens(viewMode: .sourceAccurate).map(\.tokenKind)
    }
    let lhs = try tokens(file), rhs = try tokens(after.appendingPathComponent(file.lastPathComponent))
    guard lhs == rhs else {
        print("Mismatch: \(file.lastPathComponent)")
        for (index, pair) in zip(lhs, rhs).enumerated() where pair.0 != pair.1 { print("\(index): \(pair)"); break }
        exit(1)
    }
    verified += 1
}
print("PASS: \(verified) files, identical normalized syntax and string values")
