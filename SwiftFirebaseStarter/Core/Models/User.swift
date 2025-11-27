//
//  User.swift
//  SwiftFirebaseStarter
//
//  User model representing an authenticated user (email or anonymous).
//  Includes Firestore mapping for database persistence.
//

import Foundation

// MARK: - User Model

/// Represents an authenticated user in the application
/// Supports both email/password users and anonymous (guest) users
struct User: Codable, Identifiable, Equatable, Sendable {

    // MARK: - Properties

    /// Unique identifier (Firebase Auth UID)
    let id: String

    /// User's email address (nil for anonymous users)
    let email: String?

    /// Optional display name
    var displayName: String?

    /// Whether this is an anonymous/guest account
    let isAnonymous: Bool

    /// Account creation timestamp
    let createdAt: Date

    // MARK: - Computed Properties

    /// Display text for UI presentation
    /// Returns "Guest User" for anonymous accounts or email/displayName for authenticated users
    var displayText: String {
        if isAnonymous {
            return "Guest User"
        }
        return displayName ?? email ?? "User"
    }

    /// Short name for compact display (e.g., in navigation bar)
    /// Returns "Guest" for anonymous or first part of email/displayName
    var shortName: String {
        if isAnonymous {
            return "Guest"
        }
        if let displayName = displayName {
            return displayName.components(separatedBy: " ").first ?? "User"
        }
        if let email = email {
            return email.components(separatedBy: "@").first ?? "User"
        }
        return "User"
    }

    /// User initials for avatar display (e.g., "JD" for "John Doe")
    var initials: String {
        if isAnonymous {
            return "?"
        }

        let name = displayName ?? email ?? "User"
        let components = name.components(separatedBy: CharacterSet.alphanumerics.inverted)
        let letters = components.filter { !$0.isEmpty }

        if letters.count >= 2 {
            return String(letters[0].prefix(1) + letters[1].prefix(1)).uppercased()
        } else if let first = letters.first {
            return String(first.prefix(2)).uppercased()
        }

        return "U"
    }

    // MARK: - Initialization

    /// Standard initializer for creating User instances
    /// - Parameters:
    ///   - id: Unique user identifier (Firebase Auth UID)
    ///   - email: User's email address (nil for anonymous)
    ///   - displayName: Optional display name
    ///   - isAnonymous: Whether this is a guest account
    ///   - createdAt: Account creation date
    init(
        id: String,
        email: String?,
        displayName: String? = nil,
        isAnonymous: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.isAnonymous = isAnonymous
        self.createdAt = createdAt
    }

    // MARK: - Firestore Mapping

    /// Coding keys for Firestore serialization
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case displayName
        case isAnonymous
        case createdAt
    }

    /// Convert User to Firestore-compatible dictionary
    /// - Returns: Dictionary representation suitable for Firestore
    func toFirestore() -> [String: Any] {
        return [
            Constants.Firestore.userEmail: email ?? "",
            Constants.Firestore.userDisplayName: displayName ?? "",
            Constants.Firestore.userIsAnonymous: isAnonymous,
            Constants.Firestore.userCreatedAt: createdAt
        ]
    }

    // MARK: - Equatable

    /// Custom equality check (comparing IDs is sufficient)
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Preview Data

#if DEBUG
extension User {

    /// Sample user for SwiftUI previews and testing
    static let preview = User(
        id: "preview-user-id-12345",
        email: "preview@example.com",
        displayName: "Preview User",
        isAnonymous: false,
        createdAt: Date().addingTimeInterval(-86400 * 30) // 30 days ago
    )

    /// Sample anonymous user for SwiftUI previews
    static let previewAnonymous = User(
        id: "preview-anonymous-id-67890",
        email: nil,
        displayName: nil,
        isAnonymous: true,
        createdAt: Date().addingTimeInterval(-3600) // 1 hour ago
    )

    /// Sample user with display name for testing
    static let previewWithName = User(
        id: "preview-named-user",
        email: "john.doe@example.com",
        displayName: "John Doe",
        isAnonymous: false,
        createdAt: Date().addingTimeInterval(-86400 * 7) // 7 days ago
    )
}
#endif

// MARK: - TODO

// TODO: Add profile photo URL property when implementing profile picture upload
// TODO: Consider adding lastLoginDate for session tracking
// TODO: Add email verification status property
