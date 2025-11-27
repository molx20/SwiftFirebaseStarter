//
//  AuthServiceProtocol.swift
//  SwiftFirebaseStarter
//
//  Protocol defining authentication service interface.
//  Enables dependency injection and testing with mock implementations.
//

import Foundation

// MARK: - AuthServiceProtocol

/// Protocol for authentication operations
/// Implemented by FirebaseAuthService and MockAuthService for testing
protocol AuthServiceProtocol: Sendable {

    // MARK: - Current User

    /// Current authenticated user, if any
    /// Returns nil if no user is logged in
    var currentUser: User? { get async }

    // MARK: - Authentication Methods

    /// Sign in with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: Authenticated User object
    /// - Throws: AppError if authentication fails
    func signIn(email: String, password: String) async throws -> User

    /// Create new account with email and password
    /// Also creates user document in Firestore
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password (minimum 6 characters)
    /// - Returns: Newly created User object
    /// - Throws: AppError if signup fails (email in use, weak password, etc.)
    func signUp(email: String, password: String) async throws -> User

    /// Sign in anonymously as guest user
    /// Allows users to try the app without creating an account
    /// - Returns: Anonymous User object
    /// - Throws: AppError if anonymous signin fails
    func signInAnonymously() async throws -> User

    /// Sign out current user
    /// Clears authentication state
    /// - Throws: AppError if signout fails
    func signOut() throws

    // MARK: - Auth State Observation

    /// Observe authentication state changes
    /// Emits User? whenever auth state changes (login, logout, etc.)
    /// - Returns: AsyncStream that emits current user on state changes
    func observeAuthState() -> AsyncStream<User?>

    // MARK: - Password Management

    /// Send password reset email
    /// - Parameter email: Email address to send reset link
    /// - Throws: AppError if email is invalid or user not found
    func sendPasswordReset(email: String) async throws

    // MARK: - Account Management

    /// Delete current user's account
    /// WARNING: This is permanent and cannot be undone
    /// - Throws: AppError if deletion fails (requires recent auth)
    func deleteAccount() async throws
}

// MARK: - Default Implementations

extension AuthServiceProtocol {

    /// Check if a user is currently authenticated
    /// Convenience property for checking auth status
    var isAuthenticated: Bool {
        get async {
            await currentUser != nil
        }
    }

    /// Check if current user is anonymous
    /// Returns false if no user is logged in
    var isAnonymous: Bool {
        get async {
            await currentUser?.isAnonymous ?? false
        }
    }
}

// MARK: - TODO

// TODO: Add email verification methods (sendVerificationEmail, checkVerificationStatus)
// TODO: Add OAuth providers (Google, Apple, etc.) when implementing social login
// TODO: Add method to link anonymous account with email/password
// TODO: Add multi-factor authentication support
