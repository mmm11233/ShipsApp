//
//  OnboardingView.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 01.02.26.
//

import SwiftUI
import CoreData

struct OnboardingView: View {
    @State private var showUIKitVersion = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()
                
                Text("Welcome to ShipsApp")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                // MARK: - Buttons
                VStack(spacing: 16) {
                    // SwiftUI version
                    NavigationLink {
                        SwiftUIShipsView()
                    } label: {
                        Text("SwiftUI Version")
                            .modifier(OnboardingButtonStyle(color: .blue))
                    }
                    
                    // UIKit version
                    Button {
                        showUIKitVersion = true
                    } label: {
                        Text("UIKit Version")
                            .modifier(OnboardingButtonStyle(color: .green))
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showUIKitVersion) {
                UIKitShipsWrapper()
                    .ignoresSafeArea()
            }
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

// MARK: - SwiftUI Version (Mvvm)
struct SwiftUIShipsView: View {
    @StateObject private var dataController = DataController()

    var body: some View {
        ShipsListView(dataController: dataController)
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}

// MARK: - UIKit Wrapper for full screen UIKit version
struct UIKitShipsWrapper: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UINavigationController {
        let dataController = DataController()
        let viewModel = ShipsViewModel(dataController: dataController)
        let shipsVC = ShipsListViewController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: shipsVC)
        
        // optional: transparent nav bar
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

// MARK: - Preview
#Preview {
    OnboardingView()
}

