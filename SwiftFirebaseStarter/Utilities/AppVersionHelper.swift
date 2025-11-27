//
//  AppVersionHelper.swift
//  SwiftFirebaseStarter
//
//  Utility for retrieving app version and build information.
//  Used in Settings screen and for version tracking.
//

import Foundation

// MARK: - AppVersionHelper

/// Utility for accessing app version information
enum AppVersionHelper {

    // MARK: - Version Info

    /// App version from Info.plist (e.g., "1.0.0")
    static var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    /// Build number from Info.plist (e.g., "1")
    static var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }

    /// Full version string combining version and build (e.g., "1.0.0 (1)")
    static var fullVersion: String {
        "Version \(version) (\(buildNumber))"
    }

    /// Compact version string (e.g., "v1.0.0")
    static var compactVersion: String {
        "v\(version)"
    }

    // MARK: - App Info

    /// App display name
    static var appName: String {
        Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
            ?? Bundle.main.infoDictionary?["CFBundleName"] as? String
            ?? Constants.App.name
    }

    /// Bundle identifier (e.g., "com.company.swiftfirebasestarter")
    static var bundleIdentifier: String {
        Bundle.main.bundleIdentifier ?? "unknown"
    }

    /// App icon name from Info.plist
    static var appIconName: String? {
        guard let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let lastIcon = iconFiles.last else {
            return nil
        }
        return lastIcon
    }

    // MARK: - Version Comparison

    /// Compare current version with another version string
    /// - Parameter otherVersion: Version to compare against
    /// - Returns: ComparisonResult (.orderedAscending, .orderedSame, .orderedDescending)
    static func compare(with otherVersion: String) -> ComparisonResult {
        return version.compare(otherVersion, options: .numeric)
    }

    /// Check if current version is greater than another version
    /// - Parameter otherVersion: Version to compare against
    /// - Returns: true if current version is newer
    static func isNewer(than otherVersion: String) -> Bool {
        return compare(with: otherVersion) == .orderedDescending
    }

    /// Check if current version is older than another version
    /// - Parameter otherVersion: Version to compare against
    /// - Returns: true if current version is older
    static func isOlder(than otherVersion: String) -> Bool {
        return compare(with: otherVersion) == .orderedAscending
    }

    // MARK: - Device Info

    /// Device model name (e.g., "iPhone 14 Pro")
    static var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }

    /// iOS version (e.g., "16.0")
    static var iOSVersion: String {
        UIDevice.current.systemVersion
    }

    /// Device name (e.g., "Malcolm's iPhone")
    static var deviceName: String {
        UIDevice.current.name
    }

    // MARK: - Environment

    /// Check if running in debug mode
    static var isDebugMode: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    /// Check if running in simulator
    static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    /// Full system info string for support/debugging
    static var systemInfo: String {
        """
        App: \(appName) \(fullVersion)
        Device: \(deviceName)
        Model: \(deviceModel)
        iOS: \(iOSVersion)
        Debug: \(isDebugMode ? "Yes" : "No")
        Simulator: \(isSimulator ? "Yes" : "No")
        Bundle ID: \(bundleIdentifier)
        """
    }
}

// MARK: - Preview Support

#if DEBUG
extension AppVersionHelper {

    /// Sample version for previews
    static let previewVersion = "1.0.0"

    /// Sample build number for previews
    static let previewBuild = "42"

    /// Sample full version for previews
    static let previewFullVersion = "Version 1.0.0 (42)"
}
#endif

// MARK: - TODO

// TODO: Add method to check App Store for new version availability
// TODO: Implement forced update logic if minimum version is required
// TODO: Add telemetry for version adoption rates
