import Foundation

class StorageManager {
    static let shared = StorageManager()

    private let fileManager = FileManager.default
    private let articlesFileName = "articles.json"
    private let statsFileName = "stats.json"

    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private var articlesURL: URL {
        documentsDirectory.appendingPathComponent(articlesFileName)
    }

    private var statsURL: URL {
        documentsDirectory.appendingPathComponent(statsFileName)
    }

    private init() {}

    // MARK: - Articles

    func loadArticles() -> [Article] {
        guard fileManager.fileExists(atPath: articlesURL.path) else {
            return []
        }

        do {
            let data = try Data(contentsOf: articlesURL)
            let articles = try JSONDecoder().decode([Article].self, from: data)
            return articles
        } catch {
            print("Error loading articles: \(error)")
            return []
        }
    }

    func saveArticle(_ article: Article) {
        var articles = loadArticles()
        if let index = articles.firstIndex(where: { $0.id == article.id }) {
            articles[index] = article
        } else {
            articles.insert(article, at: 0)
        }
        saveAllArticles(articles)
    }

    func updateArticle(_ article: Article) {
        var articles = loadArticles()
        if let index = articles.firstIndex(where: { $0.id == article.id }) {
            articles[index] = article
            saveAllArticles(articles)
        }
    }

    func deleteArticle(_ article: Article) {
        var articles = loadArticles()
        articles.removeAll { $0.id == article.id }
        saveAllArticles(articles)
    }

    private func saveAllArticles(_ articles: [Article]) {
        do {
            let data = try JSONEncoder().encode(articles)
            try data.write(to: articlesURL)
        } catch {
            print("Error saving articles: \(error)")
        }
    }

    // MARK: - Stats

    func loadStats() -> ReadingStats {
        guard fileManager.fileExists(atPath: statsURL.path) else {
            return ReadingStats()
        }

        do {
            let data = try Data(contentsOf: statsURL)
            return try JSONDecoder().decode(ReadingStats.self, from: data)
        } catch {
            print("Error loading stats: \(error)")
            return ReadingStats()
        }
    }

    func saveStats(_ stats: ReadingStats) {
        do {
            let data = try JSONEncoder().encode(stats)
            try data.write(to: statsURL)
        } catch {
            print("Error saving stats: \(error)")
        }
    }

    func updateStats(wordsRead: Int, readingTime: TimeInterval, completed: Bool, wpm: Int) {
        var stats = loadStats()

        stats.totalWordsRead += wordsRead
        stats.totalReadingTime += readingTime

        if completed {
            stats.articlesCompleted += 1
        }

        // Update average WPM
        if stats.averageWPM == 0 {
            stats.averageWPM = wpm
        } else {
            stats.averageWPM = (stats.averageWPM + wpm) / 2
        }

        // Update streak
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastRead = stats.lastReadDate {
            let lastReadDay = calendar.startOfDay(for: lastRead)
            let daysSince = calendar.dateComponents([.day], from: lastReadDay, to: today).day ?? 0

            if daysSince == 1 {
                stats.currentStreak += 1
            } else if daysSince > 1 {
                stats.currentStreak = 1
            }
        } else {
            stats.currentStreak = 1
        }

        stats.longestStreak = max(stats.longestStreak, stats.currentStreak)
        stats.lastReadDate = Date()

        saveStats(stats)
    }

    // MARK: - Export/Import

    func exportData() -> Data? {
        let articles = loadArticles()
        let stats = loadStats()

        let exportData = ExportData(articles: articles, stats: stats)

        return try? JSONEncoder().encode(exportData)
    }

    func importData(_ data: Data) throws {
        let exportData = try JSONDecoder().decode(ExportData.self, from: data)

        saveAllArticles(exportData.articles)
        saveStats(exportData.stats)
    }

    func clearAllData() {
        try? fileManager.removeItem(at: articlesURL)
        try? fileManager.removeItem(at: statsURL)
    }
}

struct ExportData: Codable {
    let articles: [Article]
    let stats: ReadingStats
    let exportDate: Date

    init(articles: [Article], stats: ReadingStats) {
        self.articles = articles
        self.stats = stats
        self.exportDate = Date()
    }
}
