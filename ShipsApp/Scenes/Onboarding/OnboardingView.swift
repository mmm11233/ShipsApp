//
//  OnboardingView.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 01.02.26.
//

import SwiftUI
import CoreData

struct OnboardingView: View {
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                
                Text("Welcome to ShipsApp")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                // MARK: - Buttons
                VStack(spacing: 16) {
                    NavigationLink {
                        SwiftUIShipsView()
                    } label: {
                        Text("SwiftUI version")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    
                    NavigationLink {
                        UIKitShipsWrapper()
                    } label: {
                        Text("UIKit version")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .navigationTitle("Onboarding")
            .navigationBarHidden(true)
        }
    }
}

// MARK: - SwiftUI Version Placeholder
struct SwiftUIShipsView: View {
        @StateObject private var dataController = DataController()

    var body: some View {
        ShipsListView(dataController: dataController)
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}

// MARK: - UIKit Wrapper for SwiftUI NavigationLink
struct UIKitShipsWrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let dataController = DataController()
        let viewModel = ShipsViewModel(dataController: dataController)
        let shipsVC = ShipsListViewController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: shipsVC)
        return nav
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

// MARK: - Preview
#Preview {
    OnboardingView()
}
