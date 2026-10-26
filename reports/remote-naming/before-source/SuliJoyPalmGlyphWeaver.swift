import Foundation

enum SuliJoyPalmGlyphWeaver {
    static func unfurl(_ palmThread: String) -> String {
        var shorelinePhrase = String()
        shorelinePhrase.reserveCapacity(palmThread.count / 2)
        for (reefOffset, tideGlyph) in palmThread.enumerated() where reefOffset.isMultiple(of: 2) {
            shorelinePhrase.append(tideGlyph)
        }
        return shorelinePhrase
    }
}

extension String {
    var suliJoyPalmUnfurled: String {
        SuliJoyPalmGlyphWeaver.unfurl(self)
    }
}
