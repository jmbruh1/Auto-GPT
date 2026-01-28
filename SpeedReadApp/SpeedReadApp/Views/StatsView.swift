import SwiftUI

struct StatsView: View {
    @EnvironmentObject var libraryViewModel: LibraryViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Main stats cards
                    statsGrid

                    // Recent activity
                    recentActivitySection

                    // Achievements
                    achievementsSection
                }
                .padding()
            }
            .navigationTitle("Statistics")
            .refreshable {
                libraryViewModel.loadArticles()
            }
        }
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatCard(
                title: "Words Read",
                value: formatNumber(libraryViewModel.stats.totalWordsRead),
                icon: "text.word.spacing",
                color: .blue
            )

            StatCard(
                title: "Reading Time",
                value: libraryViewModel.stats.formattedTotalTime,
                icon: "clock",
                color: .green
            )

            StatCard(
                title: "Articles Completed",
                value: "\(libraryViewModel.stats.articlesCompleted)",
                icon: "checkmark.circle",
                color: .orange
            )

            StatCard(
                title: "Average Speed",
                value: "\(libraryViewModel.stats.averageWPM) WPM",
                icon: "speedometer",
                color: .purple
            )

            StatCard(
                title: "Current Streak",
                value: "\(libraryViewModel.stats.currentStreak) days",
                icon: "flame",
                color: .red
            )

            StatCard(
                title: "Best Streak",
                value: "\(libraryViewModel.stats.longestStreak) days",
                icon: "trophy",
                color: .yellow
            )
        }
    }

    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activity")
                .font(.headline)

            if libraryViewModel.articles.filter({ $0.lastReadDate != nil }).isEmpty {
                Text("No reading activity yet")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(recentArticles) { article in
                    RecentActivityRow(article: article)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private var recentArticles: [Article] {
        libraryViewModel.articles
            .filter { $0.lastReadDate != nil }
            .sorted { ($0.lastReadDate ?? .distantPast) > ($1.lastReadDate ?? .distantPast) }
            .prefix(5)
            .map { $0 }
    }

    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Achievements")
                .font(.headline)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                AchievementBadge(
                    title: "First Read",
                    icon: "book",
                    isUnlocked: libraryViewModel.stats.articlesCompleted >= 1
                )

                AchievementBadge(
                    title: "Bookworm",
                    icon: "books.vertical",
                    isUnlocked: libraryViewModel.stats.articlesCompleted >= 10
                )

                AchievementBadge(
                    title: "Speed Demon",
                    icon: "hare",
                    isUnlocked: libraryViewModel.stats.averageWPM >= 400
                )

                AchievementBadge(
                    title: "10K Club",
                    icon: "star",
                    isUnlocked: libraryViewModel.stats.totalWordsRead >= 10000
                )

                AchievementBadge(
                    title: "Consistent",
                    icon: "flame",
                    isUnlocked: libraryViewModel.stats.longestStreak >= 7
                )

                AchievementBadge(
                    title: "Marathon",
                    icon: "figure.run",
                    isUnlocked: libraryViewModel.stats.totalReadingTime >= 3600
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    private func formatNumber(_ number: Int) -> String {
        if number >= 1000000 {
            return String(format: "%.1fM", Double(number) / 1000000)
        } else if number >= 1000 {
            return String(format: "%.1fK", Double(number) / 1000)
        }
        return "\(number)"
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct RecentActivityRow: View {
    let article: Article

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.subheadline)
                    .lineLimit(1)

                if let lastRead = article.lastReadDate {
                    Text(lastRead, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            ProgressCircle(progress: article.readingProgress)
        }
        .padding(.vertical, 4)
    }
}

struct ProgressCircle: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 3)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))

            Text("\(Int(progress * 100))%")
                .font(.caption2)
        }
        .frame(width: 40, height: 40)
    }
}

struct AchievementBadge: View {
    let title: String
    let icon: String
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isUnlocked ? Color.yellow.opacity(0.2) : Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isUnlocked ? .yellow : .gray)
            }

            Text(title)
                .font(.caption2)
                .foregroundColor(isUnlocked ? .primary : .secondary)
                .multilineTextAlignment(.center)
        }
        .opacity(isUnlocked ? 1.0 : 0.5)
    }
}

#Preview {
    StatsView()
        .environmentObject(LibraryViewModel())
}
