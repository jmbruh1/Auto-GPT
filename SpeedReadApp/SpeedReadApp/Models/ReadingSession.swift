import Foundation

struct ReadingSession: Identifiable, Codable {
    let id: UUID
    let articleId: UUID
    let startDate: Date
    var endDate: Date?
    var wordsRead: Int
    var averageWPM: Int

    var duration: TimeInterval {
        let end = endDate ?? Date()
        return end.timeIntervalSince(startDate)
    }

    init(
        id: UUID = UUID(),
        articleId: UUID,
        startDate: Date = Date(),
        endDate: Date? = nil,
        wordsRead: Int = 0,
        averageWPM: Int = 0
    ) {
        self.id = id
        self.articleId = articleId
        self.startDate = startDate
        self.endDate = endDate
        self.wordsRead = wordsRead
        self.averageWPM = averageWPM
    }
}

struct ReadingStats: Codable {
    var totalWordsRead: Int
    var totalReadingTime: TimeInterval
    var articlesCompleted: Int
    var averageWPM: Int
    var longestStreak: Int
    var currentStreak: Int
    var lastReadDate: Date?

    var formattedTotalTime: String {
        let hours = Int(totalReadingTime) / 3600
        let minutes = (Int(totalReadingTime) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    init(
        totalWordsRead: Int = 0,
        totalReadingTime: TimeInterval = 0,
        articlesCompleted: Int = 0,
        averageWPM: Int = 0,
        longestStreak: Int = 0,
        currentStreak: Int = 0,
        lastReadDate: Date? = nil
    ) {
        self.totalWordsRead = totalWordsRead
        self.totalReadingTime = totalReadingTime
        self.articlesCompleted = articlesCompleted
        self.averageWPM = averageWPM
        self.longestStreak = longestStreak
        self.currentStreak = currentStreak
        self.lastReadDate = lastReadDate
    }
}
