import SwiftUI

struct ReaderView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var settingsManager: SettingsManager
    @StateObject private var viewModel: ReaderViewModel

    @State private var showingControls = true
    @State private var showingSettings = false
    @State private var hideControlsTask: Task<Void, Never>?

    init(article: Article) {
        _viewModel = StateObject(wrappedValue: ReaderViewModel(
            article: article,
            settings: SettingsManager().settings
        ))
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                settingsManager.settings.backgroundColor.color
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Top bar
                    if showingControls {
                        topBar
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    Spacer()

                    // Word display
                    WordDisplayView(
                        word: viewModel.currentChunk,
                        focusIndex: viewModel.focusLetterIndex,
                        settings: settingsManager.settings
                    )
                    .frame(height: geometry.size.height * 0.3)

                    Spacer()

                    // Progress bar
                    if settingsManager.settings.showProgress {
                        progressSection
                    }

                    // Bottom controls
                    if showingControls {
                        bottomControls
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .onTapGesture {
                handleTap()
            }
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onEnded { value in
                        handleSwipe(value)
                    }
            )
        }
        .sheet(isPresented: $showingSettings) {
            ReaderSettingsSheet(viewModel: viewModel)
        }
        .onAppear {
            viewModel.updateSettings(settingsManager.settings)
        }
        .statusBarHidden(!showingControls)
    }

    private var topBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(settingsManager.settings.textColor.color)
                    .padding()
            }

            Spacer()

            VStack(spacing: 2) {
                Text(viewModel.article.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)

                if settingsManager.settings.showWPM {
                    Text("\(viewModel.currentWPM) WPM")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button(action: { showingSettings = true }) {
                Image(systemName: "gear")
                    .font(.title3)
                    .foregroundColor(settingsManager.settings.textColor.color)
                    .padding()
            }
        }
        .background(settingsManager.settings.backgroundColor.color.opacity(0.8))
    }

    private var progressSection: some View {
        VStack(spacing: 8) {
            ProgressView(value: viewModel.progress)
                .tint(settingsManager.settings.highlightColor.color)
                .padding(.horizontal)

            HStack {
                Text("\(Int(viewModel.progress * 100))%")
                Spacer()
                Text(viewModel.estimatedTimeRemaining)
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.horizontal)
        }
        .padding(.bottom, 8)
    }

    private var bottomControls: some View {
        VStack(spacing: 16) {
            // Speed controls
            SpeedControlView(
                wpm: viewModel.currentWPM,
                onSpeedChange: { delta in
                    viewModel.adjustSpeed(by: delta)
                }
            )

            // Playback controls
            HStack(spacing: 40) {
                Button(action: { viewModel.restart() }) {
                    Image(systemName: "backward.end.fill")
                        .font(.title2)
                }

                Button(action: { viewModel.skipBackward() }) {
                    Image(systemName: "gobackward.10")
                        .font(.title)
                }

                Button(action: { viewModel.toggle() }) {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 64))
                }

                Button(action: { viewModel.skipForward() }) {
                    Image(systemName: "goforward.10")
                        .font(.title)
                }

                Button(action: { viewModel.seekTo(progress: 1.0) }) {
                    Image(systemName: "forward.end.fill")
                        .font(.title2)
                }
            }
            .foregroundColor(settingsManager.settings.textColor.color)
        }
        .padding()
        .background(settingsManager.settings.backgroundColor.color.opacity(0.8))
    }

    private func handleTap() {
        if viewModel.isPlaying {
            viewModel.pause()
        } else {
            withAnimation(.easeInOut(duration: 0.2)) {
                showingControls.toggle()
            }
        }
        scheduleHideControls()
    }

    private func handleSwipe(_ value: DragGesture.Value) {
        let horizontal = value.translation.width
        let vertical = value.translation.height

        if abs(horizontal) > abs(vertical) {
            // Horizontal swipe
            if horizontal > 0 {
                viewModel.skipBackward()
            } else {
                viewModel.skipForward()
            }
        } else {
            // Vertical swipe - adjust speed
            if vertical < 0 {
                viewModel.adjustSpeed(by: 25)
            } else {
                viewModel.adjustSpeed(by: -25)
            }
        }
    }

    private func scheduleHideControls() {
        hideControlsTask?.cancel()

        if viewModel.isPlaying {
            hideControlsTask = Task {
                try? await Task.sleep(nanoseconds: 3_000_000_000)
                if !Task.isCancelled {
                    await MainActor.run {
                        withAnimation {
                            showingControls = false
                        }
                    }
                }
            }
        }
    }
}

struct ReaderSettingsSheet: View {
    @ObservedObject var viewModel: ReaderViewModel
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Speed") {
                    Stepper(
                        "\(settingsManager.settings.wordsPerMinute) WPM",
                        value: $settingsManager.settings.wordsPerMinute,
                        in: 50...1000,
                        step: 25
                    )

                    HStack {
                        ForEach(SettingsManager.speedPresets, id: \.wpm) { preset in
                            Button(preset.name) {
                                settingsManager.settings.wordsPerMinute = preset.wpm
                            }
                            .buttonStyle(.bordered)
                            .tint(settingsManager.settings.wordsPerMinute == preset.wpm ? .blue : .gray)
                        }
                    }
                }

                Section("Display") {
                    Stepper(
                        "Font Size: \(Int(settingsManager.settings.fontSize))",
                        value: $settingsManager.settings.fontSize,
                        in: 16...64,
                        step: 2
                    )

                    Picker("Font Weight", selection: $settingsManager.settings.fontWeight) {
                        ForEach(FontWeightOption.allCases, id: \.self) { weight in
                            Text(weight.rawValue).tag(weight)
                        }
                    }

                    Toggle("Show Focus Letter", isOn: $settingsManager.settings.focusLetter)
                    Toggle("Show Progress", isOn: $settingsManager.settings.showProgress)
                    Toggle("Show WPM", isOn: $settingsManager.settings.showWPM)
                }

                Section("Reading") {
                    Toggle("Pause on Punctuation", isOn: $settingsManager.settings.pauseOnPunctuation)

                    if settingsManager.settings.pauseOnPunctuation {
                        Stepper(
                            "Punctuation Delay: \(String(format: "%.1f", settingsManager.settings.punctuationDelay))x",
                            value: $settingsManager.settings.punctuationDelay,
                            in: 1.0...3.0,
                            step: 0.25
                        )
                    }

                    Toggle("Haptic Feedback", isOn: $settingsManager.settings.hapticFeedback)
                }

                Section("Theme") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(SettingsManager.themePresets) { theme in
                                ThemePresetButton(
                                    theme: theme,
                                    isSelected: settingsManager.settings.darkMode == theme.darkMode
                                ) {
                                    settingsManager.applyTheme(theme)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Reader Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        viewModel.updateSettings(settingsManager.settings)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ThemePresetButton: View {
    let theme: SettingsManager.ThemePreset
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(theme.backgroundColor.color)
                    .frame(width: 60, height: 40)
                    .overlay(
                        Text("Aa")
                            .font(.headline)
                            .foregroundColor(theme.textColor.color)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )

                Text(theme.name)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
    }
}

#Preview {
    ReaderView(article: Article(
        title: "Sample Article",
        content: "This is a sample article with some text for speed reading practice. The quick brown fox jumps over the lazy dog. Speed reading is a technique that helps you read faster while maintaining comprehension."
    ))
    .environmentObject(SettingsManager())
}
