//
//  ErrorAlertModifier.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 03.02.26.
//

import SwiftUI

// MARK: - ViewModifier for error alert
struct ErrorAlertModifier: ViewModifier {
    @Binding var errorMessage: String?
    
    func body(content: Content) -> some View {
        content
            .alert("Error", isPresented: Binding<Bool>(
                get: { errorMessage != nil },
                set: { _ in errorMessage = nil }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "Unknown error")
            }
    }
}

// MARK: - View extension for easier usage
extension View {
    func errorAlert(errorMessage: Binding<String?>) -> some View {
        self.modifier(ErrorAlertModifier(errorMessage: errorMessage))
    }
}
