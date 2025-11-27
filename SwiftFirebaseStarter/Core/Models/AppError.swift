//
//  AppError.swift
//  SwiftFirebaseStarter
//
//  Centralized error handling for the entire application.
//  Provides user-friendly error messages and conforms to LocalizedError.
//

import Foundation

// MARK: - AppError

/// Custom error type for application-wide error handling
/// Conforms to LocalizedError to provide user-friendly messages
enum AppError: LocalizedError {

    // MARK: - Error Cases

    /// Authentication-related errors (login, signup, etc.)
    case authError(String)

    /// Firestore database errors (CRUD operations)
    case firestoreError(String)

    /// Network connectivity errors
    case networkError(String)

    /// Input validation errors
    case validationError(String)

    /// Unknown or unexpected errors
    case unknown(String)

    // MARK: - LocalizedError Conformance

    /// Technical error description (for debugging)
    var errorDescription: String? {
        switch self {
        case .authError(let message):
            return "Authentication Error: \(message)"
        case .firestoreError(let message):
            return "Database Error: \(message)"
        case .networkError(let message):
            return "Network Error: \(message)"
        case .validationError(let message):
            return "Validation Error: \(message)"
        case .unknown(let message):
            return "Error: \(message)"
        }
    }

    /// User-friendly message suitable for display in UI
    /// Simplified language that doesn't expose technical details
    var userFriendlyMessage: String {
        switch self {
        case .authError(let message):
            // Return the message as-is for auth errors (already user-friendly)
            return message

        case .firestoreError:
            // Generic message for database errors (don't expose internal structure)
            return "Unable to save your data. Please try again."

        case .networkError:
            // Simple network error message
            return "Please check your internet connection and try again."

        case .validationError(let message):
            // Return validation message as-is (already user-friendly)
            return message

        case .unknown:
            // Fallback message for unexpected errors
            return "Something went wrong. Please try again."
        }
    }

    // MARK: - Failure Reason

    /// Optional failure reason for more context
    var failureReason: String? {
        switch self {
        case .authError(let message),
             .firestoreError(let message),
             .networkError(let message),
             .validationError(let message),
             .unknown(let message):
            return message
        }
    }

    // MARK: - Recovery Suggestion

    /// Suggested action for the user to resolve the error
    var recoverySuggestion: String? {
        switch self {
        case .authError:
            return "Please verify your email and password, or try signing in with a different method."

        case .firestoreError:
            return "Check your internet connection and try again. If the problem persists, contact support."

        case .networkError:
            return "Ensure you have a stable internet connection and try again."

        case .validationError:
            return "Please correct the highlighted fields and try again."

        case .unknown:
            return "If this problem continues, please restart the app or contact support."
        }
    }
}

// MARK: - Error Extensions

extension AppError {

    /// Create an auth error from a generic Error
    /// - Parameter error: The original error
    /// - Returns: AppError with appropriate message
    static func fromAuthError(_ error: Error) -> AppError {
        return .authError(error.localizedDescription)
    }

    /// Create a Firestore error from a generic Error
    /// - Parameter error: The original error
    /// - Returns: AppError with appropriate message
    static func fromFirestoreError(_ error: Error) -> AppError {
        return .firestoreError(error.localizedDescription)
    }

    /// Create a network error from a generic Error
    /// - Parameter error: The original error
    /// - Returns: AppError with appropriate message
    static func fromNetworkError(_ error: Error) -> AppError {
        return .networkError(error.localizedDescription)
    }
}

// MARK: - Common Error Messages

extension AppError {

    /// Pre-defined common error messages for consistency

    static let invalidEmail = AppError.validationError("Please enter a valid email address.")
    static let passwordTooShort = AppError.validationError("Password must be at least 6 characters long.")
    static let passwordsDoNotMatch = AppError.validationError("Passwords do not match.")
    static let emptyTitle = AppError.validationError("Title cannot be empty.")
    static let networkUnavailable = AppError.networkError("No internet connection available.")
}
