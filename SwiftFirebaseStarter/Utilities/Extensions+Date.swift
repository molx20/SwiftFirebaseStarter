//
//  Extensions+Date.swift
//  SwiftFirebaseStarter
//
//  Date extensions for formatting and relative time display.
//  Provides user-friendly date representations throughout the app.
//

import Foundation

// MARK: - Date Extensions

extension Date {

    // MARK: - Relative Time

    /// Relative time string (e.g., "2 hours ago", "just now")
    /// Provides human-readable time differences
    var relativeString: String {
        let now = Date()
        let interval = now.timeIntervalSince(self)

        // Future dates
        if interval < 0 {
            return "in the future"
        }

        // Less than 1 minute
        if interval < 60 {
            return "just now"
        }

        // Less than 1 hour
        if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes) \(minutes == 1 ? "minute" : "minutes") ago"
        }

        // Less than 1 day
        if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours) \(hours == 1 ? "hour" : "hours") ago"
        }

        // Less than 1 week
        if interval < 604800 {
            let days = Int(interval / 86400)
            return "\(days) \(days == 1 ? "day" : "days") ago"
        }

        // Less than 1 month
        if interval < 2592000 {
            let weeks = Int(interval / 604800)
            return "\(weeks) \(weeks == 1 ? "week" : "weeks") ago"
        }

        // Less than 1 year
        if interval < 31536000 {
            let months = Int(interval / 2592000)
            return "\(months) \(months == 1 ? "month" : "months") ago"
        }

        // Over a year
        let years = Int(interval / 31536000)
        return "\(years) \(years == 1 ? "year" : "years") ago"
    }

    // MARK: - Formatted Strings

    /// Short date format (e.g., "Jan 15, 2024")
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }

    /// Full date and time format (e.g., "January 15, 2024 at 3:30 PM")
    var fullDateTimeString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    /// Time only format (e.g., "3:30 PM")
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    /// ISO8601 string for API communication
    var iso8601String: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }

    // MARK: - Date Components

    /// Check if date is today
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// Check if date is yesterday
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }

    /// Check if date is within the current week
    var isThisWeek: Bool {
        guard let weekStart = Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.start else {
            return false
        }
        return self >= weekStart
    }

    /// Start of day (midnight)
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// End of day (11:59:59 PM)
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }

    // MARK: - Comparison Helpers

    /// Check if date is in the past
    var isPast: Bool {
        self < Date()
    }

    /// Check if date is in the future
    var isFuture: Bool {
        self > Date()
    }

    /// Days since this date (negative if in future)
    var daysSinceNow: Int {
        Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
    }

    /// Hours since this date (negative if in future)
    var hoursSinceNow: Int {
        Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
    }

    // MARK: - Date Manipulation

    /// Add days to date
    /// - Parameter days: Number of days to add (can be negative)
    /// - Returns: New date with days added
    func adding(days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }

    /// Add hours to date
    /// - Parameter hours: Number of hours to add (can be negative)
    /// - Returns: New date with hours added
    func adding(hours: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: hours, to: self) ?? self
    }

    /// Add minutes to date
    /// - Parameter minutes: Number of minutes to add (can be negative)
    /// - Returns: New date with minutes added
    func adding(minutes: Int) -> Date {
        Calendar.current.date(byAdding: .minute, value: minutes, to: self) ?? self
    }
}

// MARK: - DateFormatter Helpers

extension DateFormatter {

    /// Shared date formatter for performance (reuses instances)
    static let shared = DateFormatter()

    /// Short date formatter (e.g., "1/15/24")
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    /// Medium date formatter (e.g., "Jan 15, 2024")
    static let mediumDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    /// Long date formatter (e.g., "January 15, 2024")
    static let longDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    /// Time only formatter (e.g., "3:30 PM")
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}

// MARK: - TODO

// TODO: Add localization support for different languages
// TODO: Consider adding fiscal calendar support if needed
// TODO: Add timezone conversion helpers for multi-region apps
