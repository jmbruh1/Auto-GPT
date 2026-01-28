import SwiftUI

struct WordDisplayView: View {
    let word: String
    let focusIndex: Int
    let settings: ReadingSettings

    var body: some View {
        VStack(spacing: 0) {
            // Focus point indicator (small triangle)
            Triangle()
                .fill(settings.highlightColor.color)
                .frame(width: 10, height: 6)
                .offset(x: calculateFocusOffset())

            // Word display with focus letter highlighted
            HStack(spacing: 0) {
                if settings.focusLetter && !word.isEmpty {
                    focusLetterText
                } else {
                    Text(word)
                        .font(fontForSettings)
                        .fontWeight(settings.fontWeight.fontWeight)
                        .foregroundColor(settings.textColor.color)
                }
            }
            .frame(maxWidth: .infinity)
            .animation(.none, value: word)

            // Bottom focus point indicator
            Triangle()
                .fill(settings.highlightColor.color)
                .frame(width: 10, height: 6)
                .rotationEffect(.degrees(180))
                .offset(x: calculateFocusOffset())
        }
    }

    @ViewBuilder
    private var focusLetterText: some View {
        let characters = Array(word)
        let safeIndex = min(focusIndex, max(0, characters.count - 1))

        HStack(spacing: 0) {
            // Before focus letter
            if safeIndex > 0 {
                Text(String(characters[0..<safeIndex]))
                    .font(fontForSettings)
                    .fontWeight(settings.fontWeight.fontWeight)
                    .foregroundColor(settings.textColor.color)
            }

            // Focus letter
            if characters.indices.contains(safeIndex) {
                Text(String(characters[safeIndex]))
                    .font(fontForSettings)
                    .fontWeight(.bold)
                    .foregroundColor(settings.highlightColor.color)
            }

            // After focus letter
            if safeIndex < characters.count - 1 {
                Text(String(characters[(safeIndex + 1)...]))
                    .font(fontForSettings)
                    .fontWeight(settings.fontWeight.fontWeight)
                    .foregroundColor(settings.textColor.color)
            }
        }
    }

    private var fontForSettings: Font {
        if settings.fontFamily == "System" {
            return .system(size: settings.fontSize, design: .default)
        } else {
            return .custom(settings.fontFamily, size: settings.fontSize)
        }
    }

    private func calculateFocusOffset() -> CGFloat {
        guard settings.focusLetter && !word.isEmpty else { return 0 }

        let characters = Array(word)
        let safeIndex = min(focusIndex, max(0, characters.count - 1))

        // Estimate character width (approximate)
        let avgCharWidth = settings.fontSize * 0.55
        let wordWidth = CGFloat(characters.count) * avgCharWidth
        let focusPosition = CGFloat(safeIndex) * avgCharWidth + avgCharWidth / 2

        return focusPosition - wordWidth / 2
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

struct RSVPWordView: View {
    let word: String
    let focusIndex: Int
    let fontSize: CGFloat
    let textColor: Color
    let highlightColor: Color

    var body: some View {
        Canvas { context, size in
            let characters = Array(word)
            guard !characters.isEmpty else { return }

            let safeIndex = min(focusIndex, characters.count - 1)

            // Calculate total width
            let font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
            let charWidths = characters.map { char -> CGFloat in
                let str = String(char)
                return str.size(withAttributes: [.font: font]).width
            }
            let totalWidth = charWidths.reduce(0, +)

            // Calculate starting X to center the word
            var x = (size.width - totalWidth) / 2
            let y = size.height / 2

            for (index, char) in characters.enumerated() {
                let str = String(char)
                let color = index == safeIndex ? highlightColor : textColor
                let weight: UIFont.Weight = index == safeIndex ? .bold : .medium

                let charFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
                let attributedString = NSAttributedString(
                    string: str,
                    attributes: [
                        .font: charFont,
                        .foregroundColor: UIColor(color)
                    ]
                )

                context.draw(
                    Text(AttributedString(attributedString)),
                    at: CGPoint(x: x + charWidths[index] / 2, y: y)
                )

                x += charWidths[index]
            }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        WordDisplayView(
            word: "Reading",
            focusIndex: 2,
            settings: .default
        )

        WordDisplayView(
            word: "Speed",
            focusIndex: 1,
            settings: ReadingSettings(
                wordsPerMinute: 300,
                chunkSize: 1,
                fontSize: 40,
                fontWeight: .bold,
                fontFamily: "System",
                textColor: CodableColor(red: 1, green: 1, blue: 1),
                backgroundColor: CodableColor(red: 0.1, green: 0.1, blue: 0.1),
                highlightColor: CodableColor(red: 0, green: 0.8, blue: 1),
                darkMode: true,
                showProgress: true,
                showWPM: true,
                pauseOnPunctuation: true,
                punctuationDelay: 1.5,
                focusLetter: true,
                hapticFeedback: true
            )
        )
        .background(Color.black)
    }
    .padding()
}
