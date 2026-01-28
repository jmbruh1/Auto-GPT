import Foundation

struct Article: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var content: String
    var source: ArticleSource
    var dateAdded: Date
    var lastReadDate: Date?
    var currentWordIndex: Int
    var isCompleted: Bool
    var totalReadingTime: TimeInterval

    var wordCount: Int {
        content.split(separator: " ").count
    }

    var readingProgress: Double {
        guard wordCount > 0 else { return 0 }
        return Double(currentWordIndex) / Double(wordCount)
    }

    var estimatedReadingTime: TimeInterval {
        // Assuming average reading speed of 250 WPM
        return Double(wordCount) / 250.0 * 60.0
    }

    init(
        id: UUID = UUID(),
        title: String,
        content: String,
        source: ArticleSource = .clipboard,
        dateAdded: Date = Date(),
        lastReadDate: Date? = nil,
        currentWordIndex: Int = 0,
        isCompleted: Bool = false,
        totalReadingTime: TimeInterval = 0
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.source = source
        self.dateAdded = dateAdded
        self.lastReadDate = lastReadDate
        self.currentWordIndex = currentWordIndex
        self.isCompleted = isCompleted
        self.totalReadingTime = totalReadingTime
    }
}

enum ArticleSource: String, Codable, CaseIterable {
    case clipboard = "Clipboard"
    case url = "URL"
    case file = "File"
    case manual = "Manual Entry"

    var iconName: String {
        switch self {
        case .clipboard: return "doc.on.clipboard"
        case .url: return "link"
        case .file: return "doc.text"
        case .manual: return "square.and.pencil"
        }
    }
}
