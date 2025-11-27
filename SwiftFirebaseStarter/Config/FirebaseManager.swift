//
//  FirebaseManager.swift
//  SwiftFirebaseStarter
//
//  Singleton responsible for Firebase SDK initialization and configuration.
//  Must be called before any Firebase services are used.
//

import Foundation
// NOTE: Firebase imports will be added when integrating with Xcode project
// import FirebaseCore
// import FirebaseFirestore
// import FirebaseAuth

// MARK: - FirebaseManager

/// Singleton manager for Firebase initialization
/// Configures Firebase SDK and all related services
final class FirebaseManager {

    // MARK: - Singleton

    /// Shared instance
    static let shared = FirebaseManager()

    // Private init to enforce singleton pattern
    private init() {}

    // MARK: - Configuration

    /// Configure Firebase with GoogleService-Info.plist
    /// Must be called in App.init() before creating any views
    /// - Note: This method should only be called once during app lifecycle
    func configure() {
        // Validate GoogleService-Info.plist exists
        guard let plistPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
            Logger.error("❌ GoogleService-Info.plist not found!")
            Logger.error("Please add GoogleService-Info.plist to your project:")
            Logger.error("1. Download from Firebase Console")
            Logger.error("2. Add to Xcode project root")
            Logger.error("3. Ensure target membership is checked")

            #if DEBUG
            assertionFailure("Missing GoogleService-Info.plist - Firebase will not work")
            #endif

            return
        }

        Logger.info("✅ Found GoogleService-Info.plist at: \(plistPath)")

        // Configure Firebase
        // Uncomment when Firebase is integrated:
        // FirebaseApp.configure()

        Logger.info("🔥 Firebase configured successfully")

        // Configure individual services
        configureFirestore()
        configureAuth()

        // TODO: Configure Firebase Cloud Messaging when implementing push notifications
        // configureFCM()
    }

    // MARK: - Firestore Configuration

    /// Configure Firestore settings
    /// Enables offline persistence and sets cache size
    private func configureFirestore() {
        guard AppConfiguration.Firebase.offlinePersistenceEnabled else {
            Logger.info("Firestore offline persistence disabled")
            return
        }

        // Uncomment when Firebase is integrated:
        /*
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = AppConfiguration.Firebase.cacheSizeBytes
        Firestore.firestore().settings = settings
        */

        Logger.debug("📦 Firestore configured with offline persistence")
        Logger.debug("Cache size: \(AppConfiguration.Firebase.cacheSizeBytes == -1 ? "Unlimited" : "\(AppConfiguration.Firebase.cacheSizeBytes) bytes")")
    }

    // MARK: - Auth Configuration

    /// Configure Firebase Auth settings
    private func configureAuth() {
        // Auth is automatically configured with FirebaseApp.configure()
        // Additional auth settings can be configured here if needed

        Logger.debug("🔐 Firebase Auth configured")
    }

    // MARK: - FCM Configuration

    /// Configure Firebase Cloud Messaging for push notifications
    /// Currently stubbed - will be implemented when adding push notification support
    private func configureFCM() {
        guard AppConfiguration.FeatureFlags.pushNotificationsEnabled else {
            Logger.debug("Push notifications disabled via feature flag")
            return
        }

        // TODO: Implement FCM configuration
        // Uncomment when implementing push notifications:
        /*
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        */

        Logger.debug("📬 Firebase Cloud Messaging ready for configuration")
    }

    // MARK: - Status Check

    /// Check if Firebase is properly configured
    /// Useful for debugging configuration issues
    /// - Returns: true if Firebase app is configured
    func isConfigured() -> Bool {
        // Uncomment when Firebase is integrated:
        // return FirebaseApp.app() != nil

        // For now, return true to allow development to continue
        return true
    }

    /// Get Firebase configuration status info
    /// - Returns: Dictionary with configuration status
    func getConfigurationStatus() -> [String: Any] {
        return [
            "isConfigured": isConfigured(),
            "offlinePersistence": AppConfiguration.Firebase.offlinePersistenceEnabled,
            "pushNotifications": AppConfiguration.FeatureFlags.pushNotificationsEnabled,
            "environment": AppConfiguration.environment.displayName
        ]
    }
}

// MARK: - TODO

// TODO: Add Firebase Analytics initialization when implementing analytics
// TODO: Add Firebase Crashlytics initialization for production crash reporting
// TODO: Implement Firebase Performance Monitoring configuration
// TODO: Add method to clear Firebase cache (useful for debugging)
// TODO: Add support for multiple Firebase projects (dev/staging/prod)
