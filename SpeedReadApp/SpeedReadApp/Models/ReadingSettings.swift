import SwiftUI

struct ReadingSettings: Codable, Equatable {
    var wordsPerMinute: Int
    var chunkSize: Int
    var fontSize: CGFloat
    var fontWeight: FontWeightOption
    var fontFamily: String
    var textColor: CodableColor
    var backgroundColor: CodableColor
    var highlightColor: CodableColor
    var darkMode: Bool
    var showProgress: Bool
    var showWPM: Bool
    var pauseOnPunctuation: Bool
    var punctuationDelay: Double
    var focusLetter: Bool
    var hapticFeedback: Bool

    static let `default` = ReadingSettings(
        wordsPerMinute: 300,
        chunkSize: 1,
        fontSize: 32,
        fontWeight: .medium,
        fontFamily: "System",
        textColor: CodableColor(color: .primary),
        backgroundColor: CodableColor(color: .clear),
        highlightColor: CodableColor(color: .red),
        darkMode: false,
        showProgress: true,
        showWPM: true,
        pauseOnPunctuation: true,
        punctuationDelay: 1.5,
        focusLetter: true,
        hapticFeedback: true
    )

    var interval: TimeInterval {
        60.0 / Double(wordsPerMinute) * Double(chunkSize)
    }
}

enum FontWeightOption: String, Codable, CaseIterable {
    case light = "Light"
    case regular = "Regular"
    case medium = "Medium"
    case semibold = "Semibold"
    case bold = "Bold"

    var fontWeight: Font.Weight {
        switch self {
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        }
    }
}

struct CodableColor: Codable, Equatable {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double

    init(color: Color) {
        // Default colors for encoding
        if color == .primary {
            self.red = 0
            self.green = 0
            self.blue = 0
            self.opacity = 1
        } else if color == .red {
            self.red = 1
            self.green = 0
            self.blue = 0
            self.opacity = 1
        } else if color == .clear {
            self.red = 0
            self.green = 0
            self.blue = 0
            self.opacity = 0
        } else {
            self.red = 0.5
            self.green = 0.5
            self.blue = 0.5
            self.opacity = 1
        }
    }

    init(red: Double, green: Double, blue: Double, opacity: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.opacity = opacity
    }

    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}
