//
//  UserDefaultsService.swift
//  SwiftFirebaseStarter
//
//  Type-safe wrapper for UserDefaults.
//  Implements UserDefaultsServiceProtocol for testing.
//

import Foundation

// MARK: - UserDefaultsService

/// Implementation of UserDefaultsServiceProtocol using UserDefaults
final class UserDefaultsService: UserDefaultsServiceProtocol {

    // MARK: - Properties

    /// UserDefaults instance (injectable for testing)
    private let defaults: UserDefaults

    // MARK: - Initialization

    /// Initialize with custom UserDefaults instance
    /// - Parameter defaults: UserDefaults instance (defaults to standard)
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    // MARK: - Onboarding

    func hasSeenOnboarding() -> Bool {
        defaults.bool(forKey: Constants.UserDefaults.hasSeenOnboarding)
    }

    func setHasSeenOnboarding(_ value: Bool) {
        defaults.set(value, forKey: Constants.UserDefaults.hasSeenOnboarding)
        Logger.info("Onboarding status set to: \(value)")
    }

    // MARK: - App Version

    func getStoredAppVersion() -> String? {
        defaults.string(forKey: Constants.UserDefaults.appVersion)
    }

    func setStoredAppVersion(_ version: String) {
        defaults.set(version, forKey: Constants.UserDefaults.appVersion)
        Logger.debug("Stored app version: \(version)")
    }

    // MARK: - Last Login

    func getLastLoginDate() -> Date? {
        defaults.object(forKey: Constants.UserDefaults.lastLoginDate) as? Date
    }

    func setLastLoginDate(_ date: Date) {
        defaults.set(date, forKey: Constants.UserDefaults.lastLoginDate)
        Logger.debug("Last login date set to: \(date.shortDateString)")
    }

    // MARK: - Clear Data

    func clearAll() {
        let domain = Bundle.main.bundleIdentifier ?? "com.swiftfirebasestarter"
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
        Logger.info("All UserDefaults cleared")
    }

    func clear(key: String) {
        defaults.removeObject(forKey: key)
        Logger.debug("Cleared UserDefaults key: \(key)")
    }
}

// MARK: - TODO

// TODO: Add iCloud sync support for UserDefaults if needed
// TODO: Add data migration support for UserDefaults schema changes
// TODO: Consider adding encrypted storage for sensitive preferences
