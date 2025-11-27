//
//  PrimaryButton.swift
//  SwiftFirebaseStarter
//
//  Reusable primary button component with consistent styling.
//  Used for main actions throughout the app.
//

import SwiftUI

// MARK: - PrimaryButton

/// Primary action button with consistent styling
/// Supports loading state and disabled state
struct PrimaryButton: View {

    // MARK: - Properties

    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }

                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .frame(height: Constants.UI.buttonHeight)
            .foregroundColor(.white)
            .background(
                isDisabled ? Color.gray : Color.blue
            )
            .cornerRadius(Constants.UI.cornerRadius)
            .opacity(isLoading ? 0.8 : 1.0)
        }
        .disabled(isDisabled || isLoading)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(title: "Sign In") {
            print("Sign in tapped")
        }

        PrimaryButton(title: "Loading...", action: {}, isLoading: true)

        PrimaryButton(title: "Disabled", action: {}, isDisabled: true)
    }
    .padding()
}
