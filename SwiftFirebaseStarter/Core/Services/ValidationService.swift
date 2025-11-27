//
//  ValidationService.swift
//  SwiftFirebaseStarter
//
//  Input validation service with pure functions.
//  Provides email, password, and general input validation.
//

import Foundation

// MARK: - ValidationService

/// Service for validating user input
/// All methods are pure functions (no state)
enum ValidationService {

    // MARK: - Email Validation

    /// Validate email address format
    /// - Parameter email: Email address to validate
    /// - Returns: ValidationResult with success or error
    static func validateEmail(_ email: String) -> ValidationResult {
        let trimmed = email.trimmed

        // Check if empty
        guard !trimmed.isEmpty else {
            return .failure("Email address is required")
        }

        // Check format
        guard trimmed.isValidEmail else {
            return .failure("Please enter a valid email address")
        }

        return .success
    }

    // MARK: - Password Validation

    /// Validate password meets requirements
    /// - Parameter password: Password to validate
    /// - Returns: ValidationResult with success or error
    static func validatePassword(_ password: String) -> ValidationResult {
        // Check if empty
        guard !password.isEmpty else {
            return .failure("Password is required")
        }

        // Check minimum length
        guard password.count >= Constants.Validation.minPasswordLength else {
            return .failure("Password must be at least \(Constants.Validation.minPasswordLength) characters")
        }

        return .success
    }

    /// Validate password confirmation matches
    /// - Parameters:
    ///   - password: Original password
    ///   - confirmation: Confirmation password
    /// - Returns: ValidationResult with success or error
    static func validatePasswordMatch(password: String, confirmation: String) -> ValidationResult {
        guard password == confirmation else {
            return .failure("Passwords do not match")
        }

        return .success
    }

    // MARK: - Todo Validation

    /// Validate todo title
    /// - Parameter title: Todo title to validate
    /// - Returns: ValidationResult with success or error
    static func validateTodoTitle(_ title: String) -> ValidationResult {
        let trimmed = title.trimmed

        // Check if empty
        guard !trimmed.isEmpty else {
            return .failure("Title cannot be empty")
        }

        // Check maximum length
        guard trimmed.count <= Constants.Validation.maxTodoTitleLength else {
            return .failure("Title must be \(Constants.Validation.maxTodoTitleLength) characters or less")
        }

        return .success
    }

    // MARK: - General Validation

    /// Validate string is not empty
    /// - Parameters:
    ///   - value: String to validate
    ///   - fieldName: Name of field for error message
    /// - Returns: ValidationResult with success or error
    static func validateRequired(_ value: String, fieldName: String = "This field") -> ValidationResult {
        guard !value.trimmed.isEmpty else {
            return .failure("\(fieldName) is required")
        }

        return .success
    }

    /// Validate string length is within range
    /// - Parameters:
    ///   - value: String to validate
    ///   - minLength: Minimum length (inclusive)
    ///   - maxLength: Maximum length (inclusive)
    ///   - fieldName: Name of field for error message
    /// - Returns: ValidationResult with success or error
    static func validateLength(
        _ value: String,
        min minLength: Int,
        max maxLength: Int,
        fieldName: String = "This field"
    ) -> ValidationResult {
        let count = value.count

        if count < minLength {
            return .failure("\(fieldName) must be at least \(minLength) characters")
        }

        if count > maxLength {
            return .failure("\(fieldName) must be \(maxLength) characters or less")
        }

        return .success
    }
}

// MARK: - ValidationResult

/// Result of a validation operation
enum ValidationResult {
    case success
    case failure(String)

    /// Check if validation succeeded
    var isValid: Bool {
        if case .success = self {
            return true
        }
        return false
    }

    /// Get error message if validation failed
    var errorMessage: String? {
        if case .failure(let message) = self {
            return message
        }
        return nil
    }
}

// MARK: - TODO

// TODO: Add phone number validation when adding profile features
// TODO: Add URL validation for user-submitted links
// TODO: Add credit card validation if implementing payments
// TODO: Consider adding custom regex validation method
