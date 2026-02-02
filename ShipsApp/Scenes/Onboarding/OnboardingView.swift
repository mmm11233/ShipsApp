//
//  OnboardingView.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 01.02.26.
//

import SwiftUI

struct OnboardingView: View {
    let onSwiftUIVersionTap: () -> Void
    let onUIKitVersionTap: () -> Void
    
    var body: some View {
        VStack(spacing: DS.Spacing.large) {
            Spacer()
            
            Text("Welcome to ShipsApp")
                .font(DS.Typography.heading())
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: DS.Spacing.medium) {
                Button("SwiftUI Version", action: onSwiftUIVersionTap)
                    .buttonStyle(OnboardingButton(color: DS.Colors.accent))
                Button("UIKit Version", action: onUIKitVersionTap)
                    .buttonStyle(OnboardingButton(color: DS.Colors.success))
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .background(DS.Colors.background.ignoresSafeArea())
    }
}

// MARK: - Button Style
private struct OnboardingButton: ButtonStyle {
    let color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .cornerRadius(DS.Radius.medium)
            .shadow(color: color.opacity(0.25), radius: 6, y: 4)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
