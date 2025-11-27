//
//  CardView.swift
//  SwiftFirebaseStarter
//
//  Card container with shadow and rounded corners.
//

import SwiftUI

struct CardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(Constants.UI.cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    CardView {
        VStack(alignment: .leading, spacing: 8) {
            Text("Card Title")
                .font(.headline)
            Text("This is sample content in a card")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    .padding()
}
