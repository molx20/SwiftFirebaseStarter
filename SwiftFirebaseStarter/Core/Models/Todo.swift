//
//  Todo.swift
//  SwiftFirebaseStarter
//
//  Todo/Task model for the example app functionality.
//  Demonstrates Firestore CRUD operations and real-time synchronization.
//

import Foundation

// MARK: - Todo Model

/// Represents a todo/task item in the application
/// Stored in Firestore under users/{userId}/todos/{todoId}
struct Todo: Codable, Identifiable, Equatable, Sendable {

    // MARK: - Properties

    /// Unique identifier (Firestore document ID)
    let id: String

    /// Owner's user ID (Firebase Auth UID)
    let userId: String

    /// Todo title/description
    var title: String

    /// Completion status
    var isCompleted: Bool

    /// Creation timestamp
    let createdAt: Date

    /// Last update timestamp
    var updatedAt: Date

    // MARK: - Computed Properties

    /// Status emoji for visual display
    var statusEmoji: String {
        isCompleted ? "✅" : "⭕️"
    }

    /// Indicates if todo was recently created (within last 5 minutes)
    var isNew: Bool {
        Date().timeIntervalSince(createdAt) < 300 // 5 minutes
    }

    // MARK: - Initialization

    /// Standard initializer for creating Todo instances
    /// - Parameters:
    ///   - id: Unique todo identifier (usually Firestore auto-generated)
    ///   - userId: ID of the user who owns this todo
    ///   - title: Todo title/description
    ///   - isCompleted: Completion status (defaults to false)
    ///   - createdAt: Creation date (defaults to now)
    ///   - updatedAt: Last update date (defaults to now)
    init(
        id: String = UUID().uuidString,
        userId: String,
        title: String,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    // MARK: - Firestore Mapping

    /// Coding keys for Firestore serialization
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case title
        case isCompleted
        case createdAt
        case updatedAt
    }

    /// Convert Todo to Firestore-compatible dictionary
    /// - Returns: Dictionary representation suitable for Firestore
    func toFirestore() -> [String: Any] {
        return [
            Constants.Firestore.todoId: id,
            Constants.Firestore.todoUserId: userId,
            Constants.Firestore.todoTitle: title,
            Constants.Firestore.todoIsCompleted: isCompleted,
            Constants.Firestore.todoCreatedAt: createdAt,
            Constants.Firestore.todoUpdatedAt: updatedAt
        ]
    }

    // MARK: - Update Methods

    /// Create a new Todo with updated completion status
    /// - Parameter isCompleted: New completion status
    /// - Returns: New Todo instance with updated status and timestamp
    func withUpdatedCompletion(_ isCompleted: Bool) -> Todo {
        var updated = self
        updated.isCompleted = isCompleted
        updated.updatedAt = Date()
        return updated
    }

    /// Create a new Todo with updated title
    /// - Parameter title: New title
    /// - Returns: New Todo instance with updated title and timestamp
    func withUpdatedTitle(_ title: String) -> Todo {
        var updated = self
        updated.title = title
        updated.updatedAt = Date()
        return updated
    }

    // MARK: - Equatable

    /// Custom equality check (comparing IDs is sufficient)
    static func == (lhs: Todo, rhs: Todo) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Preview Data

#if DEBUG
extension Todo {

    /// Sample completed todo for previews
    static let preview1 = Todo(
        id: "preview-todo-1",
        userId: "preview-user-id",
        title: "Set up Firebase project",
        isCompleted: true,
        createdAt: Date().addingTimeInterval(-86400 * 2), // 2 days ago
        updatedAt: Date().addingTimeInterval(-86400) // 1 day ago
    )

    /// Sample active todo for previews
    static let preview2 = Todo(
        id: "preview-todo-2",
        userId: "preview-user-id",
        title: "Implement authentication flow",
        isCompleted: false,
        createdAt: Date().addingTimeInterval(-3600 * 5), // 5 hours ago
        updatedAt: Date().addingTimeInterval(-3600 * 5)
    )

    /// Sample todo with long title for layout testing
    static let preview3 = Todo(
        id: "preview-todo-3",
        userId: "preview-user-id",
        title: "Build comprehensive README documentation with setup instructions and troubleshooting guide",
        isCompleted: false,
        createdAt: Date().addingTimeInterval(-1800), // 30 minutes ago
        updatedAt: Date().addingTimeInterval(-1800)
    )

    /// Sample recently created todo
    static let preview4 = Todo(
        id: "preview-todo-4",
        userId: "preview-user-id",
        title: "Add unit tests for ViewModels",
        isCompleted: false,
        createdAt: Date().addingTimeInterval(-60), // 1 minute ago
        updatedAt: Date().addingTimeInterval(-60)
    )

    /// Array of sample todos for list previews
    static let previews = [preview1, preview2, preview3, preview4]

    /// Empty array for testing empty states
    static let emptyPreviews: [Todo] = []
}
#endif

// MARK: - Extensions

extension Array where Element == Todo {

    /// Filter completed todos
    var completed: [Todo] {
        filter { $0.isCompleted }
    }

    /// Filter active (not completed) todos
    var active: [Todo] {
        filter { !$0.isCompleted }
    }

    /// Count of completed todos
    var completedCount: Int {
        completed.count
    }

    /// Count of active todos
    var activeCount: Int {
        active.count
    }

    /// Completion percentage (0.0 to 1.0)
    var completionPercentage: Double {
        guard !isEmpty else { return 0.0 }
        return Double(completedCount) / Double(count)
    }
}

// MARK: - TODO

// TODO: Add priority levels (low, medium, high) when extending functionality
// TODO: Consider adding due date property for todo scheduling
// TODO: Add tags/categories for todo organization
// TODO: Implement subtasks/checklist items for complex todos
