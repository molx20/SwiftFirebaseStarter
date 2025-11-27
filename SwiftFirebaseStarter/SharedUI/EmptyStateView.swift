//
//  EmptyStateView.swift
//  SwiftFirebaseStarter
//
//  Generic empty state component for lists.
//

import SwiftUI

struct EmptyStateView: View {
    let imageName: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: imageName)
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text(title)
                .font(.title2)
                .fontWeight(.semibold)

            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            if let actionTitle = actionTitle, let action = action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
            }
        }
        .padding()
    }
}

#Preview {
    EmptyStateView(
        imageName: "checklist",
        title: "No Todos Yet",
        message: "Tap the + button to create your first todo",
        actionTitle: "Add Todo",
        action: { print("Add todo tapped") }
    )
}
