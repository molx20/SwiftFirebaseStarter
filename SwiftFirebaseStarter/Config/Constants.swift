//
//  Constants.swift
//  SwiftFirebaseStarter
//
//  Central location for all app-wide constants and configuration values.
//  Organized by category for easy navigation and maintenance.
//

import Foundation

// MARK: - Constants

/// App-wide constants organized by category
enum Constants {

    // MARK: - UserDefaults Keys

    /// Keys for UserDefaults storage
    enum UserDefaults {
        /// Key for tracking whether user has completed onboarding
        static let hasSeenOnboarding = "hasSeenOnboarding"

        /// Key for storing app version (for migration tracking)
        static let appVersion = "appVersion"

        /// Key for storing last login date
        static let lastLoginDate = "lastLoginDate"
    }

    // MARK: - Firestore Collections

    /// Firestore collection and field names
    enum Firestore {
        /// Root collection for user documents
        static let users = "users"

        /// Subcollection name for user's todos
        static let todos = "todos"

        // Field names for User document
        static let userEmail = "email"
        static let userDisplayName = "displayName"
        static let userIsAnonymous = "isAnonymous"
        static let userCreatedAt = "createdAt"

        // Field names for Todo document
        static let todoId = "id"
        static let todoUserId = "userId"
        static let todoTitle = "title"
        static let todoIsCompleted = "isCompleted"
        static let todoCreatedAt = "createdAt"
        static let todoUpdatedAt = "updatedAt"
    }

    // MARK: - UI Constants

    /// UI-related constants for consistent spacing and sizing
    enum UI {
        /// Standard padding for most views
        static let standardPadding: CGFloat = 16

        /// Small padding for compact layouts
        static let smallPadding: CGFloat = 8

        /// Large padding for spacious layouts
        static let largePadding: CGFloat = 24

        /// Standard corner radius for rounded elements
        static let cornerRadius: CGFloat = 12

        /// Small corner radius for subtle rounding
        static let smallCornerRadius: CGFloat = 8

        /// Button height for consistent sizing
        static let buttonHeight: CGFloat = 50

        /// TextField height
        static let textFieldHeight: CGFloat = 50

        /// Maximum width for content on larger screens
        static let maxContentWidth: CGFloat = 500
    }

    // MARK: - Validation

    /// Validation constants for user input
    enum Validation {
        /// Minimum password length (Firebase requirement)
        static let minPasswordLength = 6

        /// Maximum todo title length
        static let maxTodoTitleLength = 200

        /// Email regex pattern for validation
        static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }

    // MARK: - App Info

    /// App metadata
    enum App {
        /// App name displayed in UI
        static let name = "SwiftFirebaseStarter"

        /// App version from Info.plist
        static var version: String {
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        }

        /// Build number from Info.plist
        static var buildNumber: String {
            Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        }

        /// Full version string (e.g., "1.0.0 (1)")
        static var fullVersion: String {
            "\(version) (\(buildNumber))"
        }
    }

    // MARK: - Onboarding

    /// Onboarding-related constants
    enum Onboarding {
        /// Number of onboarding pages
        static let pageCount = 3

        /// Duration for page transition animation
        static let transitionDuration: Double = 0.3
    }

    // MARK: - Animation

    /// Animation durations for consistent feel
    enum Animation {
        /// Quick animation (e.g., button press)
        static let quick: Double = 0.2

        /// Standard animation (e.g., view transitions)
        static let standard: Double = 0.3

        /// Slow animation (e.g., major transitions)
        static let slow: Double = 0.5
    }
}
