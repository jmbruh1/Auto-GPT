import SwiftUI

struct ReadingProgressBar: View {
    let progress: Double
    let remainingTime: String
    let accentColor: Color

    var body: some View {
        VStack(spacing: 8) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))

                    // Progress
                    RoundedRectangle(cornerRadius: 4)
                        .fill(accentColor)
                        .frame(width: geometry.size.width * progress)
                        .animation(.linear(duration: 0.1), value: progress)
                }
            }
            .frame(height: 6)

            HStack {
                Text("\(Int(progress * 100))%")
                    .font(.caption2)
                    .foregroundColor(.secondary)

                Spacer()

                Text(remainingTime)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ChapterProgressView: View {
    let currentChapter: Int
    let totalChapters: Int
    let chapterProgress: Double
    let accentColor: Color

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<totalChapters, id: \.self) { index in
                ChapterIndicator(
                    isCompleted: index < currentChapter,
                    isCurrent: index == currentChapter,
                    progress: index == currentChapter ? chapterProgress : 0,
                    accentColor: accentColor
                )
            }
        }
    }
}

struct ChapterIndicator: View {
    let isCompleted: Bool
    let isCurrent: Bool
    let progress: Double
    let accentColor: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(isCompleted ? accentColor : Color(.systemGray5))

                if isCurrent {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(accentColor)
                        .frame(width: geometry.size.width * progress)
                }
            }
        }
        .frame(height: 4)
    }
}

struct CircularProgressView: View {
    let progress: Double
    let lineWidth: CGFloat
    let accentColor: Color
    let showPercentage: Bool

    init(
        progress: Double,
        lineWidth: CGFloat = 8,
        accentColor: Color = .blue,
        showPercentage: Bool = true
    ) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.accentColor = accentColor
        self.showPercentage = showPercentage
    }

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color(.systemGray5), lineWidth: lineWidth)

            // Progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    accentColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: progress)

            // Percentage text
            if showPercentage {
                Text("\(Int(progress * 100))%")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.semibold)
            }
        }
    }
}

struct AnimatedProgressBar: View {
    let progress: Double
    let height: CGFloat
    let backgroundColor: Color
    let foregroundColor: Color
    let animated: Bool

    @State private var animatedProgress: Double = 0

    init(
        progress: Double,
        height: CGFloat = 8,
        backgroundColor: Color = Color(.systemGray5),
        foregroundColor: Color = .blue,
        animated: Bool = true
    ) {
        self.progress = progress
        self.height = height
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.animated = animated
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(backgroundColor)

                // Progress
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(foregroundColor)
                    .frame(width: geometry.size.width * (animated ? animatedProgress : progress))
            }
        }
        .frame(height: height)
        .onAppear {
            if animated {
                withAnimation(.easeOut(duration: 0.5)) {
                    animatedProgress = progress
                }
            }
        }
        .onChange(of: progress) { _, newValue in
            if animated {
                withAnimation(.easeOut(duration: 0.2)) {
                    animatedProgress = newValue
                }
            }
        }
    }
}

struct SegmentedProgressBar: View {
    let segments: Int
    let completedSegments: Int
    let currentSegmentProgress: Double
    let spacing: CGFloat
    let accentColor: Color

    init(
        segments: Int,
        completedSegments: Int,
        currentSegmentProgress: Double = 0,
        spacing: CGFloat = 4,
        accentColor: Color = .blue
    ) {
        self.segments = segments
        self.completedSegments = completedSegments
        self.currentSegmentProgress = currentSegmentProgress
        self.spacing = spacing
        self.accentColor = accentColor
    }

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<segments, id: \.self) { index in
                ProgressSegment(
                    fillAmount: fillAmount(for: index),
                    accentColor: accentColor
                )
            }
        }
        .frame(height: 6)
    }

    private func fillAmount(for index: Int) -> Double {
        if index < completedSegments {
            return 1.0
        } else if index == completedSegments {
            return currentSegmentProgress
        } else {
            return 0.0
        }
    }
}

struct ProgressSegment: View {
    let fillAmount: Double
    let accentColor: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(.systemGray5))

                RoundedRectangle(cornerRadius: 3)
                    .fill(accentColor)
                    .frame(width: geometry.size.width * fillAmount)
            }
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        ReadingProgressBar(
            progress: 0.65,
            remainingTime: "3:45",
            accentColor: .blue
        )
        .padding()

        CircularProgressView(progress: 0.75)
            .frame(width: 100, height: 100)

        AnimatedProgressBar(progress: 0.5)
            .padding()

        SegmentedProgressBar(
            segments: 5,
            completedSegments: 2,
            currentSegmentProgress: 0.4
        )
        .padding()

        ChapterProgressView(
            currentChapter: 2,
            totalChapters: 5,
            chapterProgress: 0.6,
            accentColor: .green
        )
        .padding()
    }
    .padding()
}
