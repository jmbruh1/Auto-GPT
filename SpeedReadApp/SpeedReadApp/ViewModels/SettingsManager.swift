import SwiftUI
import Combine

@MainActor
class SettingsManager: ObservableObject {
    @Published var settings: ReadingSettings {
        didSet {
            saveSettings()
        }
    }

    private let userDefaults = UserDefaults.standard
    private let settingsKey = "readingSettings"

    init() {
        if let data = userDefaults.data(forKey: settingsKey),
           let decoded = try? JSONDecoder().decode(ReadingSettings.self, from: data) {
            settings = decoded
        } else {
            settings = .default
        }
    }

    private func saveSettings() {
        if let encoded = try? JSONEncoder().encode(settings) {
            userDefaults.set(encoded, forKey: settingsKey)
        }
    }

    func resetToDefaults() {
        settings = .default
    }

    // Speed presets
    static let speedPresets: [(name: String, wpm: Int)] = [
        ("Slow", 150),
        ("Normal", 250),
        ("Fast", 350),
        ("Very Fast", 450),
        ("Speed Reader", 600),
        ("Expert", 800)
    ]

    // Font options
    static let fontFamilies = [
        "System",
        "Georgia",
        "Helvetica Neue",
        "Menlo",
        "Avenir Next",
        "Palatino"
    ]

    // Theme presets
    struct ThemePreset: Identifiable {
        let id = UUID()
        let name: String
        let textColor: CodableColor
        let backgroundColor: CodableColor
        let highlightColor: CodableColor
        let darkMode: Bool
    }

    static let themePresets: [ThemePreset] = [
        ThemePreset(
            name: "Light",
            textColor: CodableColor(red: 0, green: 0, blue: 0),
            backgroundColor: CodableColor(red: 1, green: 1, blue: 1),
            highlightColor: CodableColor(red: 1, green: 0, blue: 0),
            darkMode: false
        ),
        ThemePreset(
            name: "Dark",
            textColor: CodableColor(red: 1, green: 1, blue: 1),
            backgroundColor: CodableColor(red: 0.1, green: 0.1, blue: 0.1),
            highlightColor: CodableColor(red: 0, green: 0.8, blue: 1),
            darkMode: true
        ),
        ThemePreset(
            name: "Sepia",
            textColor: CodableColor(red: 0.3, green: 0.2, blue: 0.1),
            backgroundColor: CodableColor(red: 0.96, green: 0.94, blue: 0.88),
            highlightColor: CodableColor(red: 0.8, green: 0.4, blue: 0),
            darkMode: false
        ),
        ThemePreset(
            name: "Night",
            textColor: CodableColor(red: 0.8, green: 0.8, blue: 0.7),
            backgroundColor: CodableColor(red: 0.05, green: 0.05, blue: 0.05),
            highlightColor: CodableColor(red: 0.4, green: 0.8, blue: 0.4),
            darkMode: true
        ),
        ThemePreset(
            name: "Ocean",
            textColor: CodableColor(red: 0.9, green: 0.95, blue: 1),
            backgroundColor: CodableColor(red: 0.1, green: 0.2, blue: 0.35),
            highlightColor: CodableColor(red: 0, green: 0.9, blue: 0.7),
            darkMode: true
        )
    ]

    func applyTheme(_ theme: ThemePreset) {
        settings.textColor = theme.textColor
        settings.backgroundColor = theme.backgroundColor
        settings.highlightColor = theme.highlightColor
        settings.darkMode = theme.darkMode
    }
}
