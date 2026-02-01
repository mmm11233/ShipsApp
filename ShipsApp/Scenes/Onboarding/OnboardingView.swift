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
                        UIKitShipsViewControllerWrapper()
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

// MARK: - UIKit Version Wrapper
struct UIKitShipsViewControllerWrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = UIKitShipsViewController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

// MARK: - UIKit Version Placeholder
class UIKitShipsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "UIKit Version Page"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Preview
#Preview {
    OnboardingView()
}
