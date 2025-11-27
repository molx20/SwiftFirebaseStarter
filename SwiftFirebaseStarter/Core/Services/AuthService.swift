//
//  AuthService.swift
//  SwiftFirebaseStarter
//
//  Firebase Authentication service implementation.
//  Handles all authentication operations including sign in, sign up, and auth state observation.
//
//  NOTE: Firebase imports are commented out until integrated with Xcode project.
//  Uncomment Firebase code when adding Firebase via Swift Package Manager.
//

import Foundation
// import FirebaseAuth

// MARK: - FirebaseAuthService

/// Firebase implementation of AuthServiceProtocol
/// Handles all authentication operations using Firebase Auth
final class FirebaseAuthService: AuthServiceProtocol {

    // MARK: - Properties

    // Uncomment when Firebase is integrated:
    // private let auth = Auth.auth()

    // MARK: - Current User

    var currentUser: User? {
        get async {
            // Uncomment when Firebase is integrated:
            /*
            guard let firebaseUser = auth.currentUser else { return nil }
            return mapFirebaseUser(firebaseUser)
            */

            // Temporary: return nil until Firebase is integrated
            return nil
        }
    }

    // MARK: - Authentication Methods

    func signIn(email: String, password: String) async throws -> User {
        Logger.Auth.info("Attempting sign in for email: \(email)")

        // Validate input
        let emailValidation = ValidationService.validateEmail(email)
        guard emailValidation.isValid else {
            throw AppError.validationError(emailValidation.errorMessage ?? "Invalid email")
        }

        let passwordValidation = ValidationService.validatePassword(password)
        guard passwordValidation.isValid else {
            throw AppError.validationError(passwordValidation.errorMessage ?? "Invalid password")
        }

        // Uncomment when Firebase is integrated:
        /*
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            let user = mapFirebaseUser(result.user)
            Logger.Auth.info("Sign in successful for user: \(user.id)")
            return user
        } catch {
            Logger.Auth.error("Sign in failed", error: error)
            throw mapAuthError(error)
        }
        */

        // Temporary: throw error until Firebase is integrated
        throw AppError.authError("Firebase not yet integrated. Add Firebase SDK via SPM.")
    }

    func signUp(email: String, password: String) async throws -> User {
        Logger.Auth.info("Attempting sign up for email: \(email)")

        // Validate input
        let emailValidation = ValidationService.validateEmail(email)
        guard emailValidation.isValid else {
            throw AppError.validationError(emailValidation.errorMessage ?? "Invalid email")
        }

        let passwordValidation = ValidationService.validatePassword(password)
        guard passwordValidation.isValid else {
            throw AppError.validationError(passwordValidation.errorMessage ?? "Invalid password")
        }

        // Uncomment when Firebase is integrated:
        /*
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            let user = mapFirebaseUser(result.user)

            // Create user document in Firestore
            try await createUserDocument(user)

            Logger.Auth.info("Sign up successful for user: \(user.id)")
            return user
        } catch {
            Logger.Auth.error("Sign up failed", error: error)
            throw mapAuthError(error)
        }
        */

        // Temporary: throw error until Firebase is integrated
        throw AppError.authError("Firebase not yet integrated. Add Firebase SDK via SPM.")
    }

    func signInAnonymously() async throws -> User {
        Logger.Auth.info("Attempting anonymous sign in")

        // Uncomment when Firebase is integrated:
        /*
        do {
            let result = try await auth.signInAnonymously()
            let user = mapFirebaseUser(result.user)
            Logger.Auth.info("Anonymous sign in successful for user: \(user.id)")
            return user
        } catch {
            Logger.Auth.error("Anonymous sign in failed", error: error)
            throw mapAuthError(error)
        }
        */

        // Temporary: throw error until Firebase is integrated
        throw AppError.authError("Firebase not yet integrated. Add Firebase SDK via SPM.")
    }

    func signOut() throws {
        Logger.Auth.info("Attempting sign out")

        // Uncomment when Firebase is integrated:
        /*
        do {
            try auth.signOut()
            Logger.Auth.info("Sign out successful")
        } catch {
            Logger.Auth.error("Sign out failed", error: error)
            throw AppError.authError(error.localizedDescription)
        }
        */

        // Temporary: throw error until Firebase is integrated
        throw AppError.authError("Firebase not yet integrated. Add Firebase SDK via SPM.")
    }

    // MARK: - Auth State Observation

    func observeAuthState() -> AsyncStream<User?> {
        AsyncStream { continuation in
            // Uncomment when Firebase is integrated:
            /*
            let handle = auth.addStateDidChangeListener { [weak self] _, firebaseUser in
                let user = firebaseUser.map { self?.mapFirebaseUser($0) } ?? nil
                continuation.yield(user)
                Logger.Auth.info("Auth state changed. User: \(user?.email ?? "none")")
            }

            continuation.onTermination = { @Sendable _ in
                Auth.auth().removeStateDidChangeListener(handle)
            }
            */

            // Temporary: yield nil until Firebase is integrated
            continuation.yield(nil)
        }
    }

    // MARK: - Password Management

    func sendPasswordReset(email: String) async throws {
        Logger.Auth.info("Sending password reset email to: \(email)")

        let emailValidation = ValidationService.validateEmail(email)
        guard emailValidation.isValid else {
            throw AppError.validationError(emailValidation.errorMessage ?? "Invalid email")
        }

        // Uncomment when Firebase is integrated:
        /*
        do {
            try await auth.sendPasswordReset(withEmail: email)
            Logger.Auth.info("Password reset email sent successfully")
        } catch {
            Logger.Auth.error("Failed to send password reset email", error: error)
            throw mapAuthError(error)
        }
        */

        // Temporary: throw error until Firebase is integrated
        throw AppError.authError("Firebase not yet integrated.")
    }

    // MARK: - Account Management

    func deleteAccount() async throws {
        Logger.Auth.info("Attempting to delete user account")

        // Uncomment when Firebase is integrated:
        /*
        guard let firebaseUser = auth.currentUser else {
            throw AppError.authError("No user is currently signed in")
        }

        do {
            try await firebaseUser.delete()
            Logger.Auth.info("User account deleted successfully")
        } catch {
            Logger.Auth.error("Failed to delete user account", error: error)
            throw mapAuthError(error)
        }
        */

        // Temporary: throw error until Firebase is integrated
        throw AppError.authError("Firebase not yet integrated.")
    }

    // MARK: - Private Helpers

    // Uncomment when Firebase is integrated:
    /*
    /// Map Firebase User to app User model
    private func mapFirebaseUser(_ firebaseUser: FirebaseAuth.User) -> User {
        User(
            id: firebaseUser.uid,
            email: firebaseUser.email,
            displayName: firebaseUser.displayName,
            isAnonymous: firebaseUser.isAnonymous,
            createdAt: firebaseUser.metadata.creationDate ?? Date()
        )
    }

    /// Map Firebase Auth errors to AppError
    private func mapAuthError(_ error: Error) -> AppError {
        guard let authError = error as? AuthErrorCode else {
            return .authError(error.localizedDescription)
        }

        switch authError.code {
        case .invalidEmail:
            return .authError("Invalid email address")
        case .wrongPassword:
            return .authError("Incorrect password")
        case .userNotFound:
            return .authError("No account found with this email")
        case .emailAlreadyInUse:
            return .authError("An account already exists with this email")
        case .weakPassword:
            return .authError("Password must be at least 6 characters")
        case .networkError:
            return .networkError("Network connection error. Please try again.")
        case .tooManyRequests:
            return .authError("Too many failed attempts. Please try again later.")
        default:
            return .authError(authError.localizedDescription)
        }
    }

    /// Create user document in Firestore
    private func createUserDocument(_ user: User) async throws {
        let db = Firestore.firestore()
        let userData = user.toFirestore()

        try await db.collection(Constants.Firestore.users)
            .document(user.id)
            .setData(userData)

        Logger.Firestore.info("User document created for: \(user.id)")
    }
    */
}

// MARK: - TODO

// TODO: Uncomment all Firebase code when Firebase SDK is added via SPM
// TODO: Add email verification functionality
// TODO: Add support for linking anonymous accounts to email/password
// TODO: Add OAuth providers (Google Sign-In, Apple Sign-In)
// TODO: Add multi-factor authentication support
