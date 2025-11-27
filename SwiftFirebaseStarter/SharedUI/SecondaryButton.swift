//
//  SecondaryButton.swift
//  SwiftFirebaseStarter
//
//  Secondary button with outline style.
//  Used for alternative actions.
//

import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity)
                .frame(height: Constants.UI.buttonHeight)
                .foregroundColor(isDisabled ? .gray : .blue)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                        .stroke(isDisabled ? Color.gray : Color.blue, lineWidth: 2)
                )
        }
        .disabled(isDisabled)
    }
}

#Preview {
    VStack(spacing: 20) {
        SecondaryButton(title: "Cancel") {}
        SecondaryButton(title: "Disabled", action: {}, isDisabled: true)
    }
    .padding()
}
