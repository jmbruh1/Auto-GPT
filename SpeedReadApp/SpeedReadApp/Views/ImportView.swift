import SwiftUI
import UniformTypeIdentifiers

struct ImportView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var libraryViewModel: LibraryViewModel
    @State private var selectedTab = 0
    @State private var urlText = ""
    @State private var manualTitle = ""
    @State private var manualContent = ""
    @State private var isImporting = false
    @State private var showingFilePicker = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab picker
                Picker("Import Method", selection: $selectedTab) {
                    Text("Clipboard").tag(0)
                    Text("URL").tag(1)
                    Text("Text").tag(2)
                    Text("File").tag(3)
                }
                .pickerStyle(.segmented)
                .padding()

                Divider()

                // Content based on selected tab
                ScrollView {
                    VStack(spacing: 20) {
                        switch selectedTab {
                        case 0:
                            clipboardImport
                        case 1:
                            urlImport
                        case 2:
                            manualImport
                        case 3:
                            fileImport
                        default:
                            EmptyView()
                        }
                    }
                    .padding()
                }

                // Error message
                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding()
                }

                // Import button
                importButton
            }
            .navigationTitle("Add Article")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .fileImporter(
                isPresented: $showingFilePicker,
                allowedContentTypes: [.plainText, .html, .rtf],
                allowsMultipleSelection: false
            ) { result in
                handleFileImport(result)
            }
            .disabled(isImporting)
            .overlay {
                if isImporting {
                    ProgressView("Importing...")
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .shadow(radius: 4)
                }
            }
        }
    }

    private var clipboardImport: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.on.clipboard")
                .font(.system(size: 50))
                .foregroundColor(.blue)

            Text("Import from Clipboard")
                .font(.headline)

            Text("Paste text directly from your clipboard. The first line or sentence will be used as the title.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            if let clipboardText = UIPasteboard.general.string, !clipboardText.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Preview:")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(clipboardText.prefix(200) + (clipboardText.count > 200 ? "..." : ""))
                        .font(.caption)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
            } else {
                Text("Clipboard is empty")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }

    private var urlImport: some View {
        VStack(spacing: 16) {
            Image(systemName: "link")
                .font(.system(size: 50))
                .foregroundColor(.green)

            Text("Import from URL")
                .font(.headline)

            Text("Enter a webpage URL to extract and import the article content.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            TextField("https://example.com/article", text: $urlText)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.URL)
                .autocapitalization(.none)
                .autocorrectionDisabled()
        }
    }

    private var manualImport: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.and.pencil")
                .font(.system(size: 50))
                .foregroundColor(.orange)

            Text("Manual Entry")
                .font(.headline)

            TextField("Title", text: $manualTitle)
                .textFieldStyle(.roundedBorder)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $manualContent)
                    .frame(minHeight: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )

                if manualContent.isEmpty {
                    Text("Paste or type your text here...")
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                        .allowsHitTesting(false)
                }
            }
        }
    }

    private var fileImport: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 50))
                .foregroundColor(.purple)

            Text("Import from File")
                .font(.headline)

            Text("Select a text file (.txt, .md, .rtf, or .html) to import.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(action: { showingFilePicker = true }) {
                Label("Choose File", systemImage: "folder")
                    .font(.headline)
            }
            .buttonStyle(.bordered)
        }
    }

    private var importButton: some View {
        Button(action: performImport) {
            HStack {
                if isImporting {
                    ProgressView()
                        .tint(.white)
                }
                Text("Import Article")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isImportEnabled ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(!isImportEnabled || isImporting)
        .padding()
    }

    private var isImportEnabled: Bool {
        switch selectedTab {
        case 0:
            return UIPasteboard.general.string != nil && !UIPasteboard.general.string!.isEmpty
        case 1:
            return !urlText.isEmpty
        case 2:
            return !manualContent.isEmpty
        case 3:
            return false // Handled by file picker
        default:
            return false
        }
    }

    private func performImport() {
        errorMessage = nil
        isImporting = true

        Task {
            do {
                switch selectedTab {
                case 0:
                    await libraryViewModel.importFromClipboard()
                case 1:
                    await libraryViewModel.importFromURL(urlText)
                case 2:
                    libraryViewModel.importFromText(title: manualTitle, content: manualContent)
                default:
                    break
                }

                if libraryViewModel.errorMessage == nil {
                    await MainActor.run {
                        dismiss()
                    }
                } else {
                    errorMessage = libraryViewModel.errorMessage
                }
            }

            await MainActor.run {
                isImporting = false
            }
        }
    }

    private func handleFileImport(_ result: Result<[URL], Error>) {
        isImporting = true
        errorMessage = nil

        switch result {
        case .success(let urls):
            guard let url = urls.first else {
                errorMessage = "No file selected"
                isImporting = false
                return
            }

            do {
                guard url.startAccessingSecurityScopedResource() else {
                    throw ArticleImporter.ImportError.parsingError
                }
                defer { url.stopAccessingSecurityScopedResource() }

                let (title, content) = try ArticleImporter.importFromFile(url)
                libraryViewModel.importFromText(title: title, content: content)
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
            }

        case .failure(let error):
            errorMessage = error.localizedDescription
        }

        isImporting = false
    }
}

#Preview {
    ImportView()
        .environmentObject(LibraryViewModel())
}
