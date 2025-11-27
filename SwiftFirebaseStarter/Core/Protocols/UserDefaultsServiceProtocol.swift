//
//  UserDefaultsServiceProtocol.swift
//  SwiftFirebaseStarter
//
//  Protocol for type-safe UserDefaults access.
//  Provides interface for storing and retrieving app preferences.
//

import Foundation

// MARK: - UserDefaultsServiceProtocol

/// Protocol for UserDefaults operations
/// Provides type-safe access to app preferences and settings
protocol UserDefaultsServiceProtocol: Sendable {

    // MARK: - Onboarding

    /// Check if user has completed onboarding
    /// - Returns: true if onboarding has been seen
    func hasSeenOnboarding() -> Bool

    /// Mark onboarding as completed
    /// - Parameter value: Whether onboarding has been completed
    func setHasSeenOnboarding(_ value: Bool)

    // MARK: - App Version

    /// Get stored app version
    /// Used for detecting app updates and migrations
    /// - Returns: Previously stored version string, or nil if first launch
    func getStoredAppVersion() -> String?

    /// Store current app version
    /// Should be called after app update migrations are complete
    /// - Parameter version: Version string to store
    func setStoredAppVersion(_ version: String)

    // MARK: - Last Login

    /// Get last login date
    /// - Returns: Date of last successful login, or nil if never logged in
    func getLastLoginDate() -> Date?

    /// Store last login date
    /// - Parameter date: Date to store (usually current date)
    func setLastLoginDate(_ date: Date)

    // MARK: - Clear Data

    /// Clear all stored preferences
    /// Useful for logout or account deletion
    func clearAll()

    /// Clear specific key
    /// - Parameter key: UserDefaults key to clear
    func clear(key: String)
}

// MARK: - Default Implementations

extension UserDefaultsServiceProtocol {

    /// Check if this is the first app launch
    /// Returns true if app version has never been stored
    func isFirstLaunch() -> Bool {
        getStoredAppVersion() == nil
    }

    /// Check if app was updated since last launch
    /// Compares current version with stored version
    func wasAppUpdated() -> Bool {
        guard let storedVersion = getStoredAppVersion() else {
            return false // First launch, not an update
        }
        return storedVersion != AppVersionHelper.version
    }

    /// Store current app version for future comparison
    func updateStoredVersion() {
        setStoredAppVersion(AppVersionHelper.version)
    }
}

// MARK: - TODO

// TODO: Add theme preference storage (light/dark/system)
// TODO: Add notification preferences
// TODO: Add language preference for multi-language support
// TODO: Consider adding data migration logic for UserDefaults schema changes
