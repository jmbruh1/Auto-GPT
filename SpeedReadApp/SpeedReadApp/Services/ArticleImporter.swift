import Foundation
import SwiftUI

enum ArticleImporter {
    enum ImportError: LocalizedError {
        case invalidURL
        case networkError(Error)
        case parsingError
        case emptyContent
        case unsupportedFormat

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL format"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            case .parsingError:
                return "Failed to parse content"
            case .emptyContent:
                return "No readable content found"
            case .unsupportedFormat:
                return "Unsupported file format"
            }
        }
    }

    /// Import article content from URL
    static func importFromURL(_ urlString: String) async throws -> (title: String, content: String) {
        guard let url = URL(string: urlString) else {
            throw ImportError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        guard let html = String(data: data, encoding: .utf8) else {
            throw ImportError.parsingError
        }

        let title = extractTitle(from: html) ?? url.host ?? "Imported Article"
        let content = extractContent(from: html)

        guard !content.isEmpty else {
            throw ImportError.emptyContent
        }

        return (title, content)
    }

    /// Extract title from HTML
    private static func extractTitle(from html: String) -> String? {
        // Try <title> tag
        if let titleRange = html.range(of: "<title>"),
           let endRange = html.range(of: "</title>", range: titleRange.upperBound..<html.endIndex) {
            let title = String(html[titleRange.upperBound..<endRange.lowerBound])
            return TextProcessor.cleanText(title)
        }

        // Try og:title meta tag
        if let ogTitle = extractMetaContent(from: html, property: "og:title") {
            return ogTitle
        }

        // Try h1
        if let h1Range = html.range(of: "<h1[^>]*>", options: .regularExpression),
           let endRange = html.range(of: "</h1>", range: h1Range.upperBound..<html.endIndex) {
            let h1 = String(html[h1Range.upperBound..<endRange.lowerBound])
            return TextProcessor.cleanText(h1)
        }

        return nil
    }

    /// Extract meta content
    private static func extractMetaContent(from html: String, property: String) -> String? {
        let pattern = "<meta[^>]*property=[\"']\(property)[\"'][^>]*content=[\"']([^\"']*)[\"']"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
           let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
           let range = Range(match.range(at: 1), in: html) {
            return String(html[range])
        }
        return nil
    }

    /// Extract main content from HTML
    private static func extractContent(from html: String) -> String {
        var content = html

        // Remove script tags
        content = content.replacingOccurrences(
            of: "<script[^>]*>[\\s\\S]*?</script>",
            with: "",
            options: .regularExpression
        )

        // Remove style tags
        content = content.replacingOccurrences(
            of: "<style[^>]*>[\\s\\S]*?</style>",
            with: "",
            options: .regularExpression
        )

        // Remove nav, header, footer
        for tag in ["nav", "header", "footer", "aside"] {
            content = content.replacingOccurrences(
                of: "<\(tag)[^>]*>[\\s\\S]*?</\(tag)>",
                with: "",
                options: .regularExpression
            )
        }

        // Try to find article or main content
        if let articleContent = extractTag(from: content, tag: "article") {
            content = articleContent
        } else if let mainContent = extractTag(from: content, tag: "main") {
            content = mainContent
        }

        // Convert paragraphs to newlines
        content = content.replacingOccurrences(of: "</p>", with: "\n\n")
        content = content.replacingOccurrences(of: "<br>", with: "\n")
        content = content.replacingOccurrences(of: "<br/>", with: "\n")
        content = content.replacingOccurrences(of: "<br />", with: "\n")

        // Clean remaining HTML
        return TextProcessor.cleanText(content)
    }

    /// Extract content from specific tag
    private static func extractTag(from html: String, tag: String) -> String? {
        let pattern = "<\(tag)[^>]*>([\\s\\S]*?)</\(tag)>"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
           let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
           let range = Range(match.range(at: 1), in: html) {
            return String(html[range])
        }
        return nil
    }

    /// Import from file URL
    static func importFromFile(_ url: URL) throws -> (title: String, content: String) {
        let fileExtension = url.pathExtension.lowercased()

        guard ["txt", "md", "rtf", "html", "htm"].contains(fileExtension) else {
            throw ImportError.unsupportedFormat
        }

        let content: String

        if fileExtension == "rtf" {
            if let attributedString = try? NSAttributedString(
                url: url,
                options: [.documentType: NSAttributedString.DocumentType.rtf],
                documentAttributes: nil
            ) {
                content = attributedString.string
            } else {
                throw ImportError.parsingError
            }
        } else {
            content = try String(contentsOf: url, encoding: .utf8)
        }

        let cleanedContent: String
        if fileExtension == "html" || fileExtension == "htm" {
            cleanedContent = extractContent(from: content)
        } else {
            cleanedContent = TextProcessor.cleanText(content)
        }

        guard !cleanedContent.isEmpty else {
            throw ImportError.emptyContent
        }

        let title = url.deletingPathExtension().lastPathComponent

        return (title, cleanedContent)
    }
}
