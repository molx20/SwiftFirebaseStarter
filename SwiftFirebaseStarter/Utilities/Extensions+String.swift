//
//  Extensions+String.swift
//  SwiftFirebaseStarter
//
//  String extensions for validation and manipulation.
//  Provides utilities for email validation, trimming, and text processing.
//

import Foundation

// MARK: - String Extensions

extension String {

    // MARK: - Validation

    /// Check if string is a valid email address
    /// Uses regex pattern defined in Constants
    var isValidEmail: Bool {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", Constants.Validation.emailRegex)
        return emailPredicate.evaluate(with: self)
    }

    /// Check if string is empty or contains only whitespace
    var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Check if string has content (not blank)
    var hasContent: Bool {
        !isBlank
    }

    /// Check if string length is within a specific range
    /// - Parameters:
    ///   - min: Minimum length (inclusive)
    ///   - max: Maximum length (inclusive)
    /// - Returns: true if length is within range
    func hasLength(min: Int, max: Int) -> Bool {
        let length = count
        return length >= min && length <= max
    }

    /// Check if string meets minimum length requirement
    /// - Parameter min: Minimum length (inclusive)
    /// - Returns: true if length is at least min
    func meetsMinLength(_ min: Int) -> Bool {
        count >= min
    }

    // MARK: - Trimming

    /// Trimmed string (removes leading/trailing whitespace and newlines)
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Trim whitespace and newlines in place
    mutating func trim() {
        self = trimmed
    }

    /// Remove all whitespace from string
    var withoutWhitespace: String {
        components(separatedBy: .whitespaces).joined()
    }

    // MARK: - Capitalization

    /// Capitalize first letter only (unlike capitalized which does each word)
    var capitalizedFirst: String {
        guard !isEmpty else { return self }
        return prefix(1).uppercased() + dropFirst()
    }

    // MARK: - Truncation

    /// Truncate string to maximum length with ellipsis
    /// - Parameters:
    ///   - maxLength: Maximum length before truncation
    ///   - trailing: Trailing string (defaults to "...")
    /// - Returns: Truncated string if needed
    func truncated(to maxLength: Int, trailing: String = "...") -> String {
        guard count > maxLength else { return self }
        let endIndex = index(startIndex, offsetBy: maxLength - trailing.count)
        return String(self[..<endIndex]) + trailing
    }

    // MARK: - Number Extraction

    /// Extract digits from string
    var digits: String {
        components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }

    /// Convert to Int if possible
    var toInt: Int? {
        Int(self)
    }

    /// Convert to Double if possible
    var toDouble: Double? {
        Double(self)
    }

    // MARK: - Subscript Utilities

    /// Safe character access by integer index
    /// - Parameter index: Integer index
    /// - Returns: Character at index, or nil if out of bounds
    subscript(safe index: Int) -> Character? {
        guard index >= 0 && index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }

    // MARK: - Contains

    /// Check if string contains another string (case insensitive)
    /// - Parameter string: String to search for
    /// - Returns: true if found
    func containsIgnoringCase(_ string: String) -> Bool {
        range(of: string, options: .caseInsensitive) != nil
    }

    // MARK: - URL Utilities

    /// Check if string is a valid URL
    var isValidURL: Bool {
        guard let url = URL(string: self) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    /// Convert string to URL
    var toURL: URL? {
        URL(string: self)
    }

    // MARK: - Encoding

    /// URL encoded string
    var urlEncoded: String? {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    /// Base64 encoded string
    var base64Encoded: String {
        Data(utf8).base64EncodedString()
    }

    /// Decode base64 string
    var base64Decoded: String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

// MARK: - Optional String Extensions

extension Optional where Wrapped == String {

    /// Check if optional string is nil or blank
    var isNilOrBlank: Bool {
        guard let value = self else { return true }
        return value.isBlank
    }

    /// Return string or empty if nil
    var orEmpty: String {
        self ?? ""
    }

    /// Return trimmed string or nil if blank
    var trimmedOrNil: String? {
        guard let value = self else { return nil }
        let trimmed = value.trimmed
        return trimmed.isEmpty ? nil : trimmed
    }
}

// MARK: - Localization Helpers

extension String {

    /// Localized string (convenience for NSLocalizedString)
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    /// Localized string with comment
    /// - Parameter comment: Comment for translators
    /// - Returns: Localized string
    func localized(withComment comment: String) -> String {
        NSLocalizedString(self, comment: comment)
    }
}

// MARK: - Preview Helpers

#if DEBUG
extension String {

    /// Generate lorem ipsum placeholder text
    /// - Parameter wordCount: Number of words to generate
    /// - Returns: Lorem ipsum text
    static func loremIpsum(wordCount: Int = 50) -> String {
        let words = [
            "lorem", "ipsum", "dolor", "sit", "amet", "consectetur",
            "adipiscing", "elit", "sed", "do", "eiusmod", "tempor",
            "incididunt", "ut", "labore", "et", "dolore", "magna",
            "aliqua", "enim", "ad", "minim", "veniam", "quis"
        ]

        return (0..<wordCount)
            .map { _ in words.randomElement() ?? "lorem" }
            .joined(separator: " ")
            .capitalizedFirst
    }
}
#endif

// MARK: - TODO

// TODO: Add phone number validation for profile features
// TODO: Consider adding credit card validation if implementing payments
// TODO: Add markdown parsing utilities if needed for rich text
