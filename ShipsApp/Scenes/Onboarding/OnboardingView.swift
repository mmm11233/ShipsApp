//
//  OnboardingView.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 01.02.26.
//

import SwiftUI
import CoreData

struct OnboardingView: View {
    let onSwiftUIVersionTap: () -> Void
    let onUIKitVersionTap: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text("Welcome to ShipsApp")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 16) {
                Button(action: onSwiftUIVersionTap) {
                    Text("SwiftUI Version")
                        .modifier(OnboardingButtonStyle(color: .blue))
                }
                
                Button(action: onUIKitVersionTap) {
                    Text("UIKit Version")
                        .modifier(OnboardingButtonStyle(color: .green))
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

// MARK: - Button style modifier for consistent look
private struct OnboardingButtonStyle: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .cornerRadius(12)
            .shadow(color: color.opacity(0.3), radius: 6, y: 4)
    }
}

// MARK: - Preview
#Preview {
    OnboardingView(onSwiftUIVersionTap: {}, onUIKitVersionTap: {})
}

