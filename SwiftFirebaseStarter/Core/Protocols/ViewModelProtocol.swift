//
//  ViewModelProtocol.swift
//  SwiftFirebaseStarter
//
//  Base protocol for ViewModels providing common functionality.
//  Ensures consistent error handling and loading states across the app.
//

import Foundation
import SwiftUI

// MARK: - ViewModelProtocol

/// Base protocol for ViewModels
/// Provides common properties and methods for all ViewModels
@MainActor
protocol ViewModelProtocol: ObservableObject {

    // MARK: - Required Properties

    /// Loading state indicator
    var isLoading: Bool { get set }

    /// Error message for display in UI
    var errorMessage: String? { get set }

    // MARK: - Lifecycle

    /// Called when view appears
    /// Override to perform setup tasks
    func onAppear()

    /// Called when view disappears
    /// Override to perform cleanup tasks
    func onDisappear()
}

// MARK: - Default Implementations

extension ViewModelProtocol {

    /// Default onAppear implementation (does nothing)
    /// Override in concrete ViewModels as needed
    func onAppear() {
        // Default: no action
    }

    /// Default onDisappear implementation (does nothing)
    /// Override in concrete ViewModels as needed
    func onDisappear() {
        // Default: no action
    }

    // MARK: - Error Handling

    /// Handle error and set error message
    /// Converts AppError to user-friendly message
    /// - Parameter error: Error to handle
    func handleError(_ error: Error) {
        if let appError = error as? AppError {
            errorMessage = appError.userFriendlyMessage
            Logger.error("ViewModel error", error: appError)
        } else {
            errorMessage = "An unexpected error occurred. Please try again."
            Logger.error("Unexpected ViewModel error", error: error)
        }
    }

    /// Clear error message
    func clearError() {
        errorMessage = nil
    }

    // MARK: - Loading State

    /// Execute async operation with automatic loading state management
    /// - Parameter operation: Async operation to perform
    func withLoading(_ operation: @escaping () async throws -> Void) async {
        isLoading = true
        errorMessage = nil

        do {
            try await operation()
        } catch {
            handleError(error)
        }

        isLoading = false
    }

    /// Execute async operation with automatic loading state and return value
    /// - Parameter operation: Async operation to perform
    /// - Returns: Result of operation, or nil if error occurred
    func withLoading<T>(_ operation: @escaping () async throws -> T) async -> T? {
        isLoading = true
        errorMessage = nil

        var result: T?

        do {
            result = try await operation()
        } catch {
            handleError(error)
        }

        isLoading = false
        return result
    }
}

// MARK: - TODO

// TODO: Add success message handling for positive feedback
// TODO: Consider adding retry logic for failed operations
// TODO: Add analytics event tracking for ViewModel actions
