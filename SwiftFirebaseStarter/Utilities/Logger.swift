//
//  Logger.swift
//  SwiftFirebaseStarter
//
//  Centralized logging utility for the application.
//  Provides different log levels and includes file/function/line information for debugging.
//  Logs are only printed in DEBUG builds for production safety.
//

import Foundation
import OSLog

// MARK: - Logger

/// Centralized logging utility
/// Provides debug, info, warning, and error logging with file/function/line tracking
enum Logger {

    // MARK: - Log Levels

    /// Log level enumeration
    private enum Level: String {
        case debug = "🔍 DEBUG"
        case info = "ℹ️ INFO"
        case warning = "⚠️ WARNING"
        case error = "❌ ERROR"
    }

    // MARK: - OSLog Categories

    /// OSLog subsystem identifier
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.swiftfirebasestarter"

    /// Logger for authentication operations
    private static let authLogger = OSLog(subsystem: subsystem, category: "Auth")

    /// Logger for Firestore operations
    private static let firestoreLogger = OSLog(subsystem: subsystem, category: "Firestore")

    /// Logger for UI operations
    private static let uiLogger = OSLog(subsystem: subsystem, category: "UI")

    /// Logger for general app operations
    private static let appLogger = OSLog(subsystem: subsystem, category: "App")

    // MARK: - Public Logging Methods

    /// Log debug information (only in DEBUG builds)
    /// - Parameters:
    ///   - message: The message to log
    ///   - file: Source file (automatically captured)
    ///   - function: Function name (automatically captured)
    ///   - line: Line number (automatically captured)
    static func debug(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        log(message, level: .debug, file: file, function: function, line: line)
        #endif
    }

    /// Log informational message
    /// - Parameters:
    ///   - message: The message to log
    ///   - file: Source file (automatically captured)
    ///   - function: Function name (automatically captured)
    ///   - line: Line number (automatically captured)
    static func info(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        log(message, level: .info, file: file, function: function, line: line)
        #endif
    }

    /// Log warning message
    /// - Parameters:
    ///   - message: The message to log
    ///   - file: Source file (automatically captured)
    ///   - function: Function name (automatically captured)
    ///   - line: Line number (automatically captured)
    static func warning(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .warning, file: file, function: function, line: line)
    }

    /// Log error message (always logged, even in release builds)
    /// - Parameters:
    ///   - message: The message to log
    ///   - error: Optional error object to include
    ///   - file: Source file (automatically captured)
    ///   - function: Function name (automatically captured)
    ///   - line: Line number (automatically captured)
    static func error(
        _ message: String,
        error: Error? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        var fullMessage = message
        if let error = error {
            fullMessage += " | Error: \(error.localizedDescription)"
        }
        log(fullMessage, level: .error, file: file, function: function, line: line)
    }

    // MARK: - Private Helpers

    /// Internal logging implementation
    /// - Parameters:
    ///   - message: The message to log
    ///   - level: Log level
    ///   - file: Source file path
    ///   - function: Function name
    ///   - line: Line number
    private static func log(
        _ message: String,
        level: Level,
        file: String,
        function: String,
        line: Int
    ) {
        // Extract filename from full path
        let filename = (file as NSString).lastPathComponent

        // Format the log message
        let logMessage = """
        \(level.rawValue) [\(filename):\(line)] \(function)
        → \(message)
        """

        // Print to console
        print(logMessage)

        // Also log to OSLog for Console.app integration
        let osLogLevel: OSLogType = {
            switch level {
            case .debug: return .debug
            case .info: return .info
            case .warning: return .default
            case .error: return .error
            }
        }()

        os_log("%{public}@", log: appLogger, type: osLogLevel, logMessage)
    }
}

// MARK: - Category-Specific Loggers

extension Logger {

    /// Logger for authentication-related operations
    enum Auth {
        static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
            Logger.info("[Auth] \(message)", file: file, function: function, line: line)
        }

        static func error(_ message: String, error: Error? = nil, file: String = #file, function: String = #function, line: Int = #line) {
            Logger.error("[Auth] \(message)", error: error, file: file, function: function, line: line)
        }
    }

    /// Logger for Firestore-related operations
    enum Firestore {
        static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
            Logger.info("[Firestore] \(message)", file: file, function: function, line: line)
        }

        static func error(_ message: String, error: Error? = nil, file: String = #file, function: String = #function, line: Int = #line) {
            Logger.error("[Firestore] \(message)", error: error, file: file, function: function, line: line)
        }
    }

    /// Logger for UI-related operations
    enum UI {
        static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
            Logger.debug("[UI] \(message)", file: file, function: function, line: line)
        }

        static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
            Logger.info("[UI] \(message)", file: file, function: function, line: line)
        }
    }
}

// MARK: - TODO

// TODO: Add integration with Firebase Crashlytics for production error reporting
// TODO: Add analytics event logging for user behavior tracking
// TODO: Consider adding log persistence for offline debugging
