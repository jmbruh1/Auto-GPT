import SwiftUI

@main
struct SpeedReadApp: App {
    @StateObject private var libraryViewModel = LibraryViewModel()
    @StateObject private var settingsManager = SettingsManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(libraryViewModel)
                .environmentObject(settingsManager)
                .preferredColorScheme(settingsManager.settings.darkMode ? .dark : .light)
        }
    }
}
