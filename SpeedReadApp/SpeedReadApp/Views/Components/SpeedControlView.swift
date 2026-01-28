import SwiftUI

struct SpeedControlView: View {
    let wpm: Int
    let onSpeedChange: (Int) -> Void

    @State private var isExpanded = false

    var body: some View {
        HStack(spacing: 16) {
            // Decrease button
            Button(action: { onSpeedChange(-25) }) {
                Image(systemName: "minus.circle")
                    .font(.title2)
            }
            .buttonRepeatBehavior(.enabled)

            // Current WPM display
            VStack(spacing: 2) {
                Text("\(wpm)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .monospacedDigit()

                Text("WPM")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(width: 60)

            // Increase button
            Button(action: { onSpeedChange(25) }) {
                Image(systemName: "plus.circle")
                    .font(.title2)
            }
            .buttonRepeatBehavior(.enabled)
        }
    }
}

struct SpeedSliderView: View {
    @Binding var wpm: Int
    let range: ClosedRange<Int>
    let step: Int

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("\(range.lowerBound)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Slider(
                    value: Binding(
                        get: { Double(wpm) },
                        set: { wpm = Int($0) }
                    ),
                    in: Double(range.lowerBound)...Double(range.upperBound),
                    step: Double(step)
                )

                Text("\(range.upperBound)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text("\(wpm) WPM")
                .font(.headline)
                .monospacedDigit()
        }
    }
}

struct SpeedPresetPicker: View {
    @Binding var wpm: Int
    let presets: [(name: String, wpm: Int)]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(presets, id: \.wpm) { preset in
                    SpeedPresetButton(
                        name: preset.name,
                        wpm: preset.wpm,
                        isSelected: wpm == preset.wpm
                    ) {
                        wpm = preset.wpm
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct SpeedPresetButton: View {
    let name: String
    let wpm: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(name)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)

                Text("\(wpm)")
                    .font(.headline)
                    .monospacedDigit()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(8)
        }
    }
}

struct CircularSpeedControl: View {
    @Binding var wpm: Int
    let minWPM: Int
    let maxWPM: Int

    @State private var isDragging = false

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: size / 2, y: size / 2)
            let radius = size / 2 - 20

            ZStack {
                // Background circle
                Circle()
                    .stroke(Color(.systemGray4), lineWidth: 8)

                // Progress arc
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color.blue,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                // Center display
                VStack(spacing: 4) {
                    Text("\(wpm)")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .monospacedDigit()

                    Text("WPM")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                // Drag handle
                Circle()
                    .fill(Color.blue)
                    .frame(width: 24, height: 24)
                    .shadow(radius: isDragging ? 4 : 2)
                    .scaleEffect(isDragging ? 1.2 : 1.0)
                    .position(handlePosition(center: center, radius: radius))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                isDragging = true
                                updateWPM(from: value.location, center: center)
                            }
                            .onEnded { _ in
                                isDragging = false
                            }
                    )
            }
            .frame(width: size, height: size)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private var progress: Double {
        Double(wpm - minWPM) / Double(maxWPM - minWPM)
    }

    private func handlePosition(center: CGPoint, radius: CGFloat) -> CGPoint {
        let angle = (progress * 360 - 90) * .pi / 180
        return CGPoint(
            x: center.x + radius * cos(angle),
            y: center.y + radius * sin(angle)
        )
    }

    private func updateWPM(from point: CGPoint, center: CGPoint) {
        let vector = CGPoint(x: point.x - center.x, y: point.y - center.y)
        var angle = atan2(vector.y, vector.x) * 180 / .pi + 90

        if angle < 0 {
            angle += 360
        }

        let newProgress = angle / 360
        let newWPM = Int(Double(minWPM) + newProgress * Double(maxWPM - minWPM))
        wpm = max(minWPM, min(maxWPM, (newWPM / 25) * 25)) // Round to nearest 25
    }
}

#Preview {
    VStack(spacing: 40) {
        SpeedControlView(wpm: 300) { delta in
            print("Speed changed by \(delta)")
        }

        SpeedSliderView(wpm: .constant(300), range: 50...1000, step: 25)
            .padding()

        SpeedPresetPicker(wpm: .constant(300), presets: SettingsManager.speedPresets)

        CircularSpeedControl(wpm: .constant(300), minWPM: 50, maxWPM: 1000)
            .frame(width: 200, height: 200)
    }
    .padding()
}
