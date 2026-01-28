import SwiftUI
import Combine

@MainActor
class ReaderViewModel: ObservableObject {
    @Published var article: Article
    @Published var currentWordIndex: Int = 0
    @Published var isPlaying: Bool = false
    @Published var currentChunk: String = ""
    @Published var focusLetterIndex: Int = 0
    @Published var sessionStartTime: Date?
    @Published var wordsReadInSession: Int = 0

    private var words: [String] = []
    private var timer: Timer?
    private var settings: ReadingSettings
    private let storageManager: StorageManager
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .light)

    var progress: Double {
        guard words.count > 0 else { return 0 }
        return Double(currentWordIndex) / Double(words.count)
    }

    var remainingWords: Int {
        max(0, words.count - currentWordIndex)
    }

    var estimatedTimeRemaining: String {
        let remaining = Double(remainingWords) / Double(settings.wordsPerMinute) * 60
        let minutes = Int(remaining) / 60
        let seconds = Int(remaining) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    var currentWPM: Int {
        settings.wordsPerMinute
    }

    init(article: Article, settings: ReadingSettings, storageManager: StorageManager = .shared) {
        self.article = article
        self.settings = settings
        self.storageManager = storageManager
        self.currentWordIndex = article.currentWordIndex
        processText()
        updateCurrentChunk()
    }

    private func processText() {
        words = TextProcessor.tokenize(article.content)
    }

    private func updateCurrentChunk() {
        guard currentWordIndex < words.count else {
            currentChunk = ""
            return
        }

        let endIndex = min(currentWordIndex + settings.chunkSize, words.count)
        let chunk = words[currentWordIndex..<endIndex].joined(separator: " ")
        currentChunk = chunk

        // Calculate focus letter index (usually the character just before center)
        if settings.focusLetter && !chunk.isEmpty {
            focusLetterIndex = calculateFocusIndex(for: chunk)
        }
    }

    private func calculateFocusIndex(for word: String) -> Int {
        // Optimal Recognition Point (ORP) is typically around 1/3 into the word
        let length = word.count
        if length <= 1 { return 0 }
        if length <= 3 { return 0 }
        if length <= 5 { return 1 }
        if length <= 9 { return 2 }
        if length <= 13 { return 3 }
        return 4
    }

    func play() {
        guard !isPlaying else { return }
        isPlaying = true

        if sessionStartTime == nil {
            sessionStartTime = Date()
        }

        startTimer()
    }

    func pause() {
        isPlaying = false
        stopTimer()
        saveProgress()
    }

    func toggle() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    private func startTimer() {
        stopTimer()

        let interval = settings.interval
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.advanceWord()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func advanceWord() {
        guard currentWordIndex < words.count else {
            completeReading()
            return
        }

        // Check for punctuation pause
        if settings.pauseOnPunctuation {
            let currentWord = words[currentWordIndex]
            if hasPunctuation(currentWord) {
                // Add extra delay for punctuation
                let extraDelay = settings.interval * (settings.punctuationDelay - 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + extraDelay) { [weak self] in
                    self?.moveToNextWord()
                }
                return
            }
        }

        moveToNextWord()
    }

    private func moveToNextWord() {
        currentWordIndex += settings.chunkSize
        wordsReadInSession += settings.chunkSize

        if settings.hapticFeedback && currentWordIndex % 10 == 0 {
            hapticGenerator.impactOccurred()
        }

        if currentWordIndex >= words.count {
            completeReading()
        } else {
            updateCurrentChunk()
        }
    }

    private func hasPunctuation(_ word: String) -> Bool {
        let punctuation = CharacterSet(charactersIn: ".!?;:")
        return word.unicodeScalars.contains { punctuation.contains($0) }
    }

    private func completeReading() {
        pause()
        article.isCompleted = true
        article.currentWordIndex = words.count
        currentChunk = "Done!"
        saveProgress()
    }

    func skipForward() {
        let skip = min(10, words.count - currentWordIndex)
        currentWordIndex += skip
        updateCurrentChunk()

        if settings.hapticFeedback {
            hapticGenerator.impactOccurred()
        }
    }

    func skipBackward() {
        currentWordIndex = max(0, currentWordIndex - 10)
        updateCurrentChunk()

        if settings.hapticFeedback {
            hapticGenerator.impactOccurred()
        }
    }

    func seekTo(progress: Double) {
        let wasPlaying = isPlaying
        if isPlaying { pause() }

        currentWordIndex = Int(progress * Double(words.count))
        updateCurrentChunk()

        if wasPlaying { play() }
    }

    func adjustSpeed(by delta: Int) {
        settings.wordsPerMinute = max(50, min(1000, settings.wordsPerMinute + delta))
        if isPlaying {
            startTimer() // Restart with new interval
        }
    }

    func updateSettings(_ newSettings: ReadingSettings) {
        settings = newSettings
        if isPlaying {
            startTimer()
        }
    }

    func restart() {
        pause()
        currentWordIndex = 0
        wordsReadInSession = 0
        sessionStartTime = nil
        article.isCompleted = false
        updateCurrentChunk()
    }

    private func saveProgress() {
        article.currentWordIndex = currentWordIndex
        article.lastReadDate = Date()

        if let startTime = sessionStartTime {
            article.totalReadingTime += Date().timeIntervalSince(startTime)
            sessionStartTime = Date()
        }

        storageManager.updateArticle(article)
    }

    deinit {
        stopTimer()
    }
}
