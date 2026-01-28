import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showingResetAlert = false
    @State private var showingExportSheet = false
    @State private var showingImportPicker = false

    var body: some View {
        NavigationStack {
            List {
                Section("Reading Speed") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Default Speed")
                            Spacer()
                            Text("\(settingsManager.settings.wordsPerMinute) WPM")
                                .foregroundColor(.secondary)
                        }

                        Slider(
                            value: Binding(
                                get: { Double(settingsManager.settings.wordsPerMinute) },
                                set: { settingsManager.settings.wordsPerMinute = Int($0) }
                            ),
                            in: 50...1000,
                            step: 25
                        )

                        HStack {
                            Text("50")
                            Spacer()
                            Text("1000")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }

                    Stepper(
                        "Chunk Size: \(settingsManager.settings.chunkSize) word\(settingsManager.settings.chunkSize > 1 ? "s" : "")",
                        value: $settingsManager.settings.chunkSize,
                        in: 1...5
                    )
                }

                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $settingsManager.settings.darkMode)

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

                    Picker("Font Family", selection: $settingsManager.settings.fontFamily) {
                        ForEach(SettingsManager.fontFamilies, id: \.self) { font in
                            Text(font).tag(font)
                        }
                    }
                }

                Section("Display Options") {
                    Toggle("Show Progress Bar", isOn: $settingsManager.settings.showProgress)
                    Toggle("Show WPM Indicator", isOn: $settingsManager.settings.showWPM)
                    Toggle("Highlight Focus Letter", isOn: $settingsManager.settings.focusLetter)
                }

                Section("Reading Behavior") {
                    Toggle("Pause on Punctuation", isOn: $settingsManager.settings.pauseOnPunctuation)

                    if settingsManager.settings.pauseOnPunctuation {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Punctuation Delay")
                                Spacer()
                                Text("\(String(format: "%.1f", settingsManager.settings.punctuationDelay))x")
                                    .foregroundColor(.secondary)
                            }

                            Slider(
                                value: $settingsManager.settings.punctuationDelay,
                                in: 1.0...3.0,
                                step: 0.25
                            )
                        }
                    }

                    Toggle("Haptic Feedback", isOn: $settingsManager.settings.hapticFeedback)
                }

                Section("Themes") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(SettingsManager.themePresets) { theme in
                                ThemeCard(theme: theme) {
                                    settingsManager.applyTheme(theme)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }

                Section("Data") {
                    Button(action: { showingExportSheet = true }) {
                        Label("Export Data", systemImage: "square.and.arrow.up")
                    }

                    Button(action: { showingImportPicker = true }) {
                        Label("Import Data", systemImage: "square.and.arrow.down")
                    }

                    Button(role: .destructive, action: { showingResetAlert = true }) {
                        Label("Reset All Settings", systemImage: "arrow.counterclockwise")
                    }
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    Link(destination: URL(string: "https://github.com")!) {
                        Label("Source Code", systemImage: "chevron.left.forwardslash.chevron.right")
                    }

                    Link(destination: URL(string: "https://example.com/privacy")!) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Reset Settings", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    settingsManager.resetToDefaults()
                }
            } message: {
                Text("This will reset all settings to their default values.")
            }
            .sheet(isPresented: $showingExportSheet) {
                ExportDataView()
            }
        }
    }
}

struct ThemeCard: View {
    let theme: SettingsManager.ThemePreset
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(theme.backgroundColor.color)
                    .frame(width: 80, height: 60)
                    .overlay(
                        VStack(spacing: 4) {
                            Text("Speed")
                                .font(.caption2)
                            Text("Read")
                                .font(.caption.bold())
                        }
                        .foregroundColor(theme.textColor.color)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 2)

                Text(theme.name)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
    }
}

struct ExportDataView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var exportData: Data?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "doc.zipper")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)

                Text("Export Your Data")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Your articles and reading statistics will be exported as a JSON file.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)

                if let data = exportData {
                    ShareLink(item: data, preview: SharePreview("SpeedRead Export", image: Image(systemName: "doc"))) {
                        Label("Share Export File", systemImage: "square.and.arrow.up")
                            .font(.headline)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .navigationTitle("Export Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                exportData = StorageManager.shared.exportData()
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsManager())
}
