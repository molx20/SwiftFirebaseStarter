//
//  Extensions+View.swift
//  SwiftFirebaseStarter
//
//  SwiftUI View extensions for common modifiers and utilities.
//  Provides reusable view modifiers to maintain consistency across the app.
//

import SwiftUI

// MARK: - View Extensions

extension View {

    // MARK: - Keyboard

    /// Hide keyboard when tapping outside text fields
    /// - Returns: Modified view with tap gesture to dismiss keyboard
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
    }

    // MARK: - Conditional Modifiers

    /// Apply modifier conditionally
    /// - Parameters:
    ///   - condition: Condition to check
    ///   - transform: Transform to apply if condition is true
    /// - Returns: Modified view if condition is true, original view otherwise
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Apply one of two modifiers based on condition
    /// - Parameters:
    ///   - condition: Condition to check
    ///   - ifTransform: Transform to apply if condition is true
    ///   - elseTransform: Transform to apply if condition is false
    /// - Returns: Modified view based on condition
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }

    // MARK: - Navigation

    /// Add navigation bar title with automatic dismiss button
    /// Useful for sheet presentations
    /// - Parameters:
    ///   - title: Navigation bar title
    ///   - dismiss: DismissAction from environment
    /// - Returns: Modified view with navigation setup
    func navigationBarTitleWithDismiss(
        _ title: String,
        dismiss: DismissAction
    ) -> some View {
        self
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
    }

    // MARK: - Loading Overlay

    /// Add loading overlay when condition is true
    /// - Parameters:
    ///   - isLoading: Whether to show loading overlay
    ///   - message: Optional message to display
    /// - Returns: Modified view with optional loading overlay
    func loadingOverlay(
        isLoading: Bool,
        message: String? = nil
    ) -> some View {
        self.overlay {
            if isLoading {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()

                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)

                        if let message = message {
                            Text(message)
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.9))
                    )
                }
            }
        }
    }

    // MARK: - Error Alert

    /// Present alert for error message
    /// - Parameter errorMessage: Binding to optional error message
    /// - Returns: Modified view with error alert
    func errorAlert(_ errorMessage: Binding<String?>) -> some View {
        self.alert("Error", isPresented: .constant(errorMessage.wrappedValue != nil)) {
            Button("OK") {
                errorMessage.wrappedValue = nil
            }
        } message: {
            if let message = errorMessage.wrappedValue {
                Text(message)
            }
        }
    }

    // MARK: - Card Style

    /// Apply card styling (background, shadow, corner radius)
    /// - Parameters:
    ///   - backgroundColor: Card background color
    ///   - cornerRadius: Corner radius
    ///   - shadowRadius: Shadow radius
    /// - Returns: Modified view with card styling
    func cardStyle(
        backgroundColor: Color = Color(.systemBackground),
        cornerRadius: CGFloat = Constants.UI.cornerRadius,
        shadowRadius: CGFloat = 4
    ) -> some View {
        self
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: shadowRadius, x: 0, y: 2)
    }

    // MARK: - Padding Helpers

    /// Apply standard padding
    func standardPadding() -> some View {
        self.padding(Constants.UI.standardPadding)
    }

    /// Apply small padding
    func smallPadding() -> some View {
        self.padding(Constants.UI.smallPadding)
    }

    /// Apply large padding
    func largePadding() -> some View {
        self.padding(Constants.UI.largePadding)
    }

    // MARK: - Responsive Width

    /// Limit view width on larger screens for better readability
    /// - Parameter maxWidth: Maximum width (defaults to Constants.UI.maxContentWidth)
    /// - Returns: Modified view with constrained width
    func responsiveWidth(maxWidth: CGFloat = Constants.UI.maxContentWidth) -> some View {
        self.frame(maxWidth: maxWidth)
    }

    // MARK: - Animation Helpers

    /// Apply standard animation
    func withStandardAnimation() -> some View {
        self.animation(.easeInOut(duration: Constants.Animation.standard), value: UUID())
    }

    // MARK: - Accessibility

    /// Add accessibility label and hint
    /// - Parameters:
    ///   - label: Accessibility label
    ///   - hint: Accessibility hint
    /// - Returns: Modified view with accessibility info
    func accessibilityLabel(_ label: String, hint: String) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint)
    }
}

// MARK: - Custom View Modifiers

/// Custom view modifier for text field styling
struct CustomTextFieldModifier: ViewModifier {
    var isValid: Bool = true

    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(Constants.UI.smallCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.UI.smallCornerRadius)
                    .stroke(isValid ? Color.clear : Color.red, lineWidth: 1)
            )
    }
}

extension View {
    /// Apply custom text field styling
    /// - Parameter isValid: Whether the field contains valid input
    /// - Returns: Styled view
    func customTextFieldStyle(isValid: Bool = true) -> some View {
        self.modifier(CustomTextFieldModifier(isValid: isValid))
    }
}

// MARK: - Preview Helpers

#if DEBUG
extension View {
    /// Embed view in NavigationView for previews
    func previewInNavigation() -> some View {
        NavigationView {
            self
        }
    }

    /// Add preview device name
    func previewDevice(_ deviceName: String) -> some View {
        self.previewDevice(PreviewDevice(rawValue: deviceName))
    }

    /// Add preview display name
    func previewDisplayName(_ name: String) -> some View {
        self.previewDisplayName(name)
    }
}
#endif

// MARK: - TODO

// TODO: Add haptic feedback modifiers for tactile responses
// TODO: Consider adding skeleton loading view modifier
// TODO: Add safe area ignore helpers for specific edges
