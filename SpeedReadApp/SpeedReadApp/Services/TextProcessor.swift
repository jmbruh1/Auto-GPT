import Foundation

enum TextProcessor {
    /// Tokenizes text into words for RSVP display
    static func tokenize(_ text: String) -> [String] {
        // Split by whitespace and filter empty strings
        let words = text
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }

        return words
    }

    /// Extracts a title from text (first sentence or first N characters)
    static func extractTitle(from text: String) -> String? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        // Try to get first line
        if let firstLine = trimmed.components(separatedBy: .newlines).first {
            let cleaned = firstLine.trimmingCharacters(in: .whitespacesAndNewlines)
            if !cleaned.isEmpty && cleaned.count <= 100 {
                return cleaned
            }
        }

        // Otherwise, get first sentence
        let sentenceEnders = CharacterSet(charactersIn: ".!?")
        if let range = trimmed.rangeOfCharacter(from: sentenceEnders) {
            let firstSentence = String(trimmed[..<range.upperBound])
            if firstSentence.count <= 100 {
                return firstSentence
            }
        }

        // Fallback: first 50 characters
        let prefix = String(trimmed.prefix(50))
        return prefix + (trimmed.count > 50 ? "..." : "")
    }

    /// Cleans text by removing extra whitespace and normalizing
    static func cleanText(_ text: String) -> String {
        var cleaned = text

        // Remove HTML tags if present
        cleaned = cleaned.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
        )

        // Decode HTML entities
        cleaned = decodeHTMLEntities(cleaned)

        // Normalize whitespace
        cleaned = cleaned.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        // Remove multiple spaces
        while cleaned.contains("  ") {
            cleaned = cleaned.replacingOccurrences(of: "  ", with: " ")
        }

        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Decodes common HTML entities
    private static func decodeHTMLEntities(_ text: String) -> String {
        var result = text
        let entities: [String: String] = [
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&apos;": "'",
            "&#39;": "'",
            "&nbsp;": " ",
            "&mdash;": "—",
            "&ndash;": "–",
            "&hellip;": "...",
            "&rsquo;": "'",
            "&lsquo;": "'",
            "&rdquo;": """,
            "&ldquo;": """
        ]

        for (entity, replacement) in entities {
            result = result.replacingOccurrences(of: entity, with: replacement)
        }

        return result
    }

    /// Calculates estimated reading time in minutes
    static func estimatedReadingTime(wordCount: Int, wpm: Int = 250) -> Int {
        return max(1, Int(ceil(Double(wordCount) / Double(wpm))))
    }

    /// Splits text into paragraphs
    static func splitIntoParagraphs(_ text: String) -> [String] {
        return text.components(separatedBy: "\n\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    /// Gets word at specific index
    static func getWord(from text: String, at index: Int) -> String? {
        let words = tokenize(text)
        guard index >= 0 && index < words.count else { return nil }
        return words[index]
    }

    /// Analyzes text complexity
    static func analyzeComplexity(_ text: String) -> TextComplexity {
        let words = tokenize(text)
        let wordCount = words.count

        guard wordCount > 0 else {
            return TextComplexity(
                averageWordLength: 0,
                longWordPercentage: 0,
                sentenceCount: 0,
                difficulty: .easy
            )
        }

        let totalLength = words.reduce(0) { $0 + $1.count }
        let averageWordLength = Double(totalLength) / Double(wordCount)

        let longWords = words.filter { $0.count > 6 }
        let longWordPercentage = Double(longWords.count) / Double(wordCount)

        let sentenceEnders = CharacterSet(charactersIn: ".!?")
        let sentenceCount = text.unicodeScalars.filter { sentenceEnders.contains($0) }.count

        let difficulty: TextDifficulty
        if averageWordLength < 4.5 && longWordPercentage < 0.15 {
            difficulty = .easy
        } else if averageWordLength < 5.5 && longWordPercentage < 0.25 {
            difficulty = .medium
        } else {
            difficulty = .hard
        }

        return TextComplexity(
            averageWordLength: averageWordLength,
            longWordPercentage: longWordPercentage,
            sentenceCount: sentenceCount,
            difficulty: difficulty
        )
    }
}

struct TextComplexity {
    let averageWordLength: Double
    let longWordPercentage: Double
    let sentenceCount: Int
    let difficulty: TextDifficulty
}

enum TextDifficulty: String {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var suggestedWPM: Int {
        switch self {
        case .easy: return 350
        case .medium: return 280
        case .hard: return 220
        }
    }

    var color: String {
        switch self {
        case .easy: return "green"
        case .medium: return "orange"
        case .hard: return "red"
        }
    }
}
