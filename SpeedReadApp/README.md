# SpeedRead - iOS Speed Reading App

A modern iOS speed reading app built with SwiftUI, featuring RSVP (Rapid Serial Visual Presentation) technology to help you read faster while maintaining comprehension.

## Features

### Core Reading Features
- **RSVP Technology**: Display words one at a time at adjustable speeds (50-1000 WPM)
- **Optimal Recognition Point (ORP)**: Highlights the focus letter in each word for faster processing
- **Smart Punctuation Pausing**: Automatically pauses longer on sentences and clauses
- **Chunk Reading**: Option to display multiple words at once (1-5 words)
- **Progress Tracking**: Real-time progress bar and time remaining estimates

### Import Options
- **Clipboard**: Paste text directly from your clipboard
- **URL Import**: Extract article content from web pages
- **File Import**: Support for .txt, .md, .rtf, and .html files
- **Manual Entry**: Type or paste text directly

### Customization
- **Adjustable Speed**: Fine-tune reading speed from 50 to 1000 WPM
- **Font Settings**: Multiple font families, sizes (16-64pt), and weights
- **Theme Presets**: Light, Dark, Sepia, Night, and Ocean themes
- **Focus Letter**: Toggle the highlighted focus point
- **Haptic Feedback**: Optional vibration feedback during reading

### Library Management
- **Article Library**: Organize and manage all your imported content
- **Search & Filter**: Find articles by title or content
- **Sort Options**: Date added, title, progress, word count, last read
- **Progress Persistence**: Resume reading from where you left off

### Statistics & Achievements
- **Reading Stats**: Track words read, reading time, articles completed
- **Average Speed**: Monitor your average reading speed
- **Reading Streaks**: Build daily reading habits
- **Achievement Badges**: Unlock achievements as you read more

## Project Structure

```
SpeedReadApp/
├── SpeedReadApp.xcodeproj/
└── SpeedReadApp/
    ├── App/
    │   └── SpeedReadApp.swift          # App entry point
    ├── Models/
    │   ├── Article.swift               # Article data model
    │   ├── ReadingSession.swift        # Session tracking model
    │   └── ReadingSettings.swift       # User preferences model
    ├── ViewModels/
    │   ├── ReaderViewModel.swift       # RSVP reader engine
    │   ├── LibraryViewModel.swift      # Library management
    │   └── SettingsManager.swift       # Settings persistence
    ├── Views/
    │   ├── ContentView.swift           # Main tab view
    │   ├── LibraryView.swift           # Article library
    │   ├── ReaderView.swift            # Speed reader interface
    │   ├── SettingsView.swift          # App settings
    │   ├── StatsView.swift             # Reading statistics
    │   ├── ImportView.swift            # Content import
    │   └── Components/
    │       ├── WordDisplayView.swift   # RSVP word display
    │       ├── SpeedControlView.swift  # Speed adjustment controls
    │       └── ProgressBarView.swift   # Progress indicators
    ├── Services/
    │   ├── TextProcessor.swift         # Text tokenization & analysis
    │   ├── ArticleImporter.swift       # URL/file content extraction
    │   └── StorageManager.swift        # Data persistence
    ├── Utilities/
    │   └── Extensions.swift            # Swift extensions
    └── Resources/
        └── Assets.xcassets/            # App icons & colors
```

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Getting Started

1. Open `SpeedReadApp.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run (Cmd + R)

## Usage

### Adding Content
1. Tap the **+** button in the Library tab
2. Choose import method: Clipboard, URL, Text, or File
3. The article will appear in your library

### Reading
1. Tap an article in the Library to open the reader
2. Press the **Play** button to start
3. Tap anywhere to pause/show controls
4. Swipe left/right to skip words
5. Swipe up/down to adjust speed

### Customizing
- Tap the **gear icon** in the reader for quick settings
- Visit the **Settings tab** for full customization options

## Key Technologies

- **SwiftUI**: Modern declarative UI framework
- **Combine**: Reactive programming for data flow
- **MVVM Architecture**: Clean separation of concerns
- **Codable**: Type-safe JSON encoding/decoding
- **FileManager**: Local data persistence

## License

This project is open source and available under the MIT License.
