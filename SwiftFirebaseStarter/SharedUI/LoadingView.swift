//
//  LoadingView.swift
//  SwiftFirebaseStarter
//
//  Full-screen loading indicator with optional message.
//

import SwiftUI

struct LoadingView: View {
    var message: String?

    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)

            if let message = message {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    LoadingView(message: "Loading your todos...")
}
