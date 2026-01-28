import SwiftUI
import Combine

@MainActor
class LibraryViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .dateAdded
    @Published var filterOption: FilterOption = .all
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let storageManager = StorageManager.shared

    var filteredArticles: [Article] {
        var result = articles

        // Apply search filter
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Apply status filter
        switch filterOption {
        case .all:
            break
        case .inProgress:
            result = result.filter { $0.currentWordIndex > 0 && !$0.isCompleted }
        case .completed:
            result = result.filter { $0.isCompleted }
        case .unread:
            result = result.filter { $0.currentWordIndex == 0 && !$0.isCompleted }
        }

        // Apply sorting
        switch sortOption {
        case .dateAdded:
            result.sort { $0.dateAdded > $1.dateAdded }
        case .title:
            result.sort { $0.title.localizedCompare($1.title) == .orderedAscending }
        case .progress:
            result.sort { $0.readingProgress > $1.readingProgress }
        case .wordCount:
            result.sort { $0.wordCount > $1.wordCount }
        case .lastRead:
            result.sort {
                ($0.lastReadDate ?? .distantPast) > ($1.lastReadDate ?? .distantPast)
            }
        }

        return result
    }

    var stats: ReadingStats {
        storageManager.loadStats()
    }

    init() {
        loadArticles()
    }

    func loadArticles() {
        articles = storageManager.loadArticles()
    }

    func addArticle(_ article: Article) {
        articles.insert(article, at: 0)
        storageManager.saveArticle(article)
    }

    func deleteArticle(_ article: Article) {
        articles.removeAll { $0.id == article.id }
        storageManager.deleteArticle(article)
    }

    func deleteArticles(at offsets: IndexSet) {
        let articlesToDelete = offsets.map { filteredArticles[$0] }
        for article in articlesToDelete {
            deleteArticle(article)
        }
    }

    func updateArticle(_ article: Article) {
        if let index = articles.firstIndex(where: { $0.id == article.id }) {
            articles[index] = article
            storageManager.updateArticle(article)
        }
    }

    func importFromClipboard() async {
        guard let text = UIPasteboard.general.string, !text.isEmpty else {
            errorMessage = "Clipboard is empty"
            return
        }

        let title = TextProcessor.extractTitle(from: text) ?? "Clipboard Import"
        let article = Article(
            title: title,
            content: TextProcessor.cleanText(text),
            source: .clipboard
        )
        addArticle(article)
    }

    func importFromURL(_ urlString: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let (title, content) = try await ArticleImporter.importFromURL(urlString)
            let article = Article(
                title: title,
                content: content,
                source: .url
            )
            addArticle(article)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func importFromText(title: String, content: String) {
        let article = Article(
            title: title.isEmpty ? "Untitled" : title,
            content: TextProcessor.cleanText(content),
            source: .manual
        )
        addArticle(article)
    }
}

enum SortOption: String, CaseIterable {
    case dateAdded = "Date Added"
    case title = "Title"
    case progress = "Progress"
    case wordCount = "Word Count"
    case lastRead = "Last Read"

    var iconName: String {
        switch self {
        case .dateAdded: return "calendar"
        case .title: return "textformat"
        case .progress: return "chart.bar"
        case .wordCount: return "number"
        case .lastRead: return "clock"
        }
    }
}

enum FilterOption: String, CaseIterable {
    case all = "All"
    case inProgress = "In Progress"
    case completed = "Completed"
    case unread = "Unread"

    var iconName: String {
        switch self {
        case .all: return "tray.full"
        case .inProgress: return "book"
        case .completed: return "checkmark.circle"
        case .unread: return "book.closed"
        }
    }
}
