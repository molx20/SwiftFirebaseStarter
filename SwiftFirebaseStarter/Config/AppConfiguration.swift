//
//  AppConfiguration.swift
//  SwiftFirebaseStarter
//
//  App-wide configuration and feature flags.
//  Central location for environment-specific settings.
//

import Foundation

// MARK: - AppConfiguration

/// Central configuration for the application
/// Manages environment-specific settings and feature flags
enum AppConfiguration {

    // MARK: - Environment

    /// App environment
    enum Environment {
        case development
        case staging
        case production

        /// Current environment based on build configuration
        static var current: Environment {
            #if DEBUG
            return .development
            #else
            return .production
            #endif
        }

        /// Environment display name
        var displayName: String {
            switch self {
            case .development: return "Development"
            case .staging: return "Staging"
            case .production: return "Production"
            }
        }
    }

    /// Current app environment
    static var environment: Environment {
        Environment.current
    }

    // MARK: - Feature Flags

    /// Feature flags for enabling/disabling functionality
    enum FeatureFlags {

        /// Enable push notifications (stubbed for now)
        static let pushNotificationsEnabled = false

        /// Enable analytics tracking
        static let analyticsEnabled = false

        /// Enable crash reporting
        static let crashReportingEnabled = false

        /// Enable offline mode with local persistence
        static let offlineModeEnabled = true

        /// Show debug information in UI
        static let showDebugInfo = Environment.current == .development

        /// Enable detailed logging
        static let verboseLoggingEnabled = Environment.current == .development
    }

    // MARK: - API Configuration

    /// API-related configuration (for future backend integration)
    enum API {

        /// Base URL for API (if using custom backend)
        static var baseURL: String {
            switch Environment.current {
            case .development:
                return "https://dev-api.example.com"
            case .staging:
                return "https://staging-api.example.com"
            case .production:
                return "https://api.example.com"
            }
        }

        /// API timeout interval in seconds
        static let timeoutInterval: TimeInterval = 30

        /// Maximum retry attempts for failed requests
        static let maxRetryAttempts = 3
    }

    // MARK: - Firebase Configuration

    /// Firebase-specific configuration
    enum Firebase {

        /// Enable Firestore offline persistence
        static let offlinePersistenceEnabled = true

        /// Firestore cache size (unlimited)
        static let cacheSizeBytes: Int64 = -1 // FirestoreCacheSizeUnlimited

        /// Enable Firebase Analytics
        static let analyticsEnabled = false

        /// Enable Firebase Crashlytics
        static let crashlyticsEnabled = false
    }

    // MARK: - UI Configuration

    /// UI-related configuration
    enum UI {

        /// Animation speed multiplier (1.0 = normal)
        static let animationSpeed: Double = 1.0

        /// Enable haptic feedback
        static let hapticsEnabled = true

        /// Show splash screen on launch
        static let showSplashScreen = false

        /// Splash screen duration in seconds
        static let splashScreenDuration: TimeInterval = 2.0
    }

    // MARK: - Validation Configuration

    /// Validation rules
    enum Validation {

        /// Minimum password length (Firebase requirement)
        static let minPasswordLength = 6

        /// Maximum todo title length
        static let maxTodoTitleLength = 200

        /// Enable strict email validation
        static let strictEmailValidation = true
    }

    // MARK: - Debug Configuration

    /// Debug-only configuration
    enum Debug {

        /// Enable network request logging
        static let logNetworkRequests = Environment.current == .development

        /// Enable Firestore operation logging
        static let logFirestoreOperations = Environment.current == .development

        /// Enable view lifecycle logging
        static let logViewLifecycle = false

        /// Simulate slow network (adds delay to requests)
        static let simulateSlowNetwork = false

        /// Simulated network delay in seconds
        static let simulatedNetworkDelay: TimeInterval = 2.0
    }

    // MARK: - App Limits

    /// App usage limits
    enum Limits {

        /// Maximum number of todos per user
        static let maxTodosPerUser = 1000

        /// Maximum number of todos to display in list
        static let maxTodosToDisplay = 100

        /// Pagination page size
        static let pageSize = 20
    }
}

// MARK: - Configuration Helpers

extension AppConfiguration {

    /// Check if running in debug mode
    static var isDebug: Bool {
        environment == .development
    }

    /// Check if running in production
    static var isProduction: Bool {
        environment == .production
    }

    /// Full app info string for debugging
    static var appInfo: String {
        """
        App: \(Constants.App.name)
        Version: \(Constants.App.fullVersion)
        Environment: \(environment.displayName)
        Bundle ID: \(AppVersionHelper.bundleIdentifier)
        """
    }
}

// MARK: - TODO

// TODO: Add remote configuration support (e.g., Firebase Remote Config)
// TODO: Add A/B testing configuration
// TODO: Add support for different configuration files per environment
// TODO: Consider adding configuration validation on app launch
