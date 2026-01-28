import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var viewModel: LibraryViewModel
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showingImportSheet = false
    @State private var showingSortOptions = false
    @State private var selectedArticle: Article?

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.filteredArticles.isEmpty {
                    emptyStateView
                } else {
                    articleList
                }
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    filterMenu
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        sortButton
                        addButton
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search articles")
            .sheet(isPresented: $showingImportSheet) {
                ImportView()
            }
            .fullScreenCover(item: $selectedArticle) { article in
                ReaderView(article: article)
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("No Articles")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Import articles from clipboard, URL, or text to start speed reading")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: { showingImportSheet = true }) {
                Label("Add Article", systemImage: "plus.circle.fill")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .padding()
    }

    private var articleList: some View {
        List {
            ForEach(viewModel.filteredArticles) { article in
                ArticleRow(article: article)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedArticle = article
                    }
            }
            .onDelete(perform: viewModel.deleteArticles)
        }
        .listStyle(.insetGrouped)
        .refreshable {
            viewModel.loadArticles()
        }
    }

    private var filterMenu: some View {
        Menu {
            ForEach(FilterOption.allCases, id: \.self) { option in
                Button(action: { viewModel.filterOption = option }) {
                    Label(
                        option.rawValue,
                        systemImage: viewModel.filterOption == option
                            ? "checkmark"
                            : option.iconName
                    )
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
        }
    }

    private var sortButton: some View {
        Menu {
            ForEach(SortOption.allCases, id: \.self) { option in
                Button(action: { viewModel.sortOption = option }) {
                    Label(
                        option.rawValue,
                        systemImage: viewModel.sortOption == option
                            ? "checkmark"
                            : option.iconName
                    )
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
    }

    private var addButton: some View {
        Button(action: { showingImportSheet = true }) {
            Image(systemName: "plus")
        }
    }
}

struct ArticleRow: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: article.source.iconName)
                    .foregroundColor(.secondary)
                    .font(.caption)

                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)

                Spacer()

                if article.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }

            HStack(spacing: 16) {
                Label("\(article.wordCount) words", systemImage: "text.word.spacing")

                Label(formatTime(article.estimatedReadingTime), systemImage: "clock")

                if article.currentWordIndex > 0 && !article.isCompleted {
                    ProgressView(value: article.readingProgress)
                        .frame(width: 50)
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        if minutes < 1 {
            return "<1 min"
        }
        return "\(minutes) min"
    }
}

#Preview {
    LibraryView()
        .environmentObject(LibraryViewModel())
        .environmentObject(SettingsManager())
}
