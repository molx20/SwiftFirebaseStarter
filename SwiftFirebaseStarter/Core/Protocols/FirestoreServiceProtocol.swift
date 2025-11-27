//
//  FirestoreServiceProtocol.swift
//  SwiftFirebaseStarter
//
//  Protocol defining Firestore database service interface.
//  Provides CRUD operations for todos with real-time synchronization.
//

import Foundation

// MARK: - FirestoreServiceProtocol

/// Protocol for Firestore database operations
/// Implemented by FirebaseFirestoreService and MockFirestoreService for testing
protocol FirestoreServiceProtocol: Sendable {

    // MARK: - Todo CRUD Operations

    /// Create a new todo for the specified user
    /// - Parameters:
    ///   - userId: ID of the user who owns the todo
    ///   - title: Todo title/description
    /// - Returns: Newly created Todo object with generated ID
    /// - Throws: AppError if creation fails
    func createTodo(userId: String, title: String) async throws -> Todo

    /// Fetch all todos for a specific user
    /// Returns todos sorted by creation date (newest first)
    /// - Parameter userId: ID of the user whose todos to fetch
    /// - Returns: Array of Todo objects
    /// - Throws: AppError if fetch fails
    func fetchTodos(userId: String) async throws -> [Todo]

    /// Update a todo's completion status
    /// Also updates the updatedAt timestamp
    /// - Parameters:
    ///   - userId: ID of the user who owns the todo
    ///   - todoId: ID of the todo to update
    ///   - isCompleted: New completion status
    /// - Throws: AppError if update fails
    func updateTodoCompletion(userId: String, todoId: String, isCompleted: Bool) async throws

    /// Update a todo's title
    /// Also updates the updatedAt timestamp
    /// - Parameters:
    ///   - userId: ID of the user who owns the todo
    ///   - todoId: ID of the todo to update
    ///   - title: New title
    /// - Throws: AppError if update fails
    func updateTodoTitle(userId: String, todoId: String, title: String) async throws

    /// Delete a todo
    /// - Parameters:
    ///   - userId: ID of the user who owns the todo
    ///   - todoId: ID of the todo to delete
    /// - Throws: AppError if deletion fails
    func deleteTodo(userId: String, todoId: String) async throws

    // MARK: - Real-time Observation

    /// Observe real-time changes to a user's todos
    /// Emits updated todo list whenever data changes in Firestore
    /// - Parameter userId: ID of the user whose todos to observe
    /// - Returns: AsyncStream that emits todo arrays on changes
    func observeTodos(userId: String) -> AsyncStream<[Todo]>

    // MARK: - Batch Operations

    /// Delete all todos for a user
    /// Useful when deleting user account
    /// - Parameter userId: ID of the user whose todos to delete
    /// - Throws: AppError if batch deletion fails
    func deleteAllTodos(userId: String) async throws

    /// Mark all todos as completed
    /// - Parameter userId: ID of the user whose todos to complete
    /// - Throws: AppError if batch update fails
    func completeAllTodos(userId: String) async throws

    // MARK: - Statistics

    /// Get todo statistics for a user
    /// - Parameter userId: ID of the user
    /// - Returns: TodoStatistics object with counts and percentages
    /// - Throws: AppError if fetch fails
    func getTodoStatistics(userId: String) async throws -> TodoStatistics
}

// MARK: - TodoStatistics

/// Statistics about a user's todos
struct TodoStatistics: Sendable {

    /// Total number of todos
    let totalCount: Int

    /// Number of completed todos
    let completedCount: Int

    /// Number of active (not completed) todos
    let activeCount: Int

    /// Completion percentage (0.0 to 1.0)
    var completionPercentage: Double {
        guard totalCount > 0 else { return 0.0 }
        return Double(completedCount) / Double(totalCount)
    }

    /// Completion percentage as formatted string (e.g., "75%")
    var completionPercentageString: String {
        String(format: "%.0f%%", completionPercentage * 100)
    }

    /// Initialize from todo array
    /// - Parameter todos: Array of todos to analyze
    init(todos: [Todo]) {
        self.totalCount = todos.count
        self.completedCount = todos.filter { $0.isCompleted }.count
        self.activeCount = todos.filter { !$0.isCompleted }.count
    }

    /// Initialize with explicit values
    /// - Parameters:
    ///   - totalCount: Total number of todos
    ///   - completedCount: Number of completed todos
    ///   - activeCount: Number of active todos
    init(totalCount: Int, completedCount: Int, activeCount: Int) {
        self.totalCount = totalCount
        self.completedCount = completedCount
        self.activeCount = activeCount
    }

    /// Empty statistics (no todos)
    static let empty = TodoStatistics(totalCount: 0, completedCount: 0, activeCount: 0)
}

// MARK: - Default Implementations

extension FirestoreServiceProtocol {

    /// Get todo statistics (default implementation using fetchTodos)
    func getTodoStatistics(userId: String) async throws -> TodoStatistics {
        let todos = try await fetchTodos(userId: userId)
        return TodoStatistics(todos: todos)
    }

    /// Delete all todos (default implementation using fetchTodos + deleteTodo)
    func deleteAllTodos(userId: String) async throws {
        let todos = try await fetchTodos(userId: userId)
        for todo in todos {
            try await deleteTodo(userId: userId, todoId: todo.id)
        }
    }

    /// Complete all todos (default implementation using fetchTodos + updateTodoCompletion)
    func completeAllTodos(userId: String) async throws {
        let todos = try await fetchTodos(userId: userId)
        for todo in todos where !todo.isCompleted {
            try await updateTodoCompletion(userId: userId, todoId: todo.id, isCompleted: true)
        }
    }
}

// MARK: - TODO

// TODO: Add support for todo categories/tags
// TODO: Implement pagination for large todo lists
// TODO: Add search/filter functionality
// TODO: Consider adding due dates and reminders
// TODO: Add support for todo attachments (images, files)
