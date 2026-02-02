//
//  MainRouterRootView.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 31.01.26.
//

import SwiftUI
import UIKit

struct MainRouterRootView: UIViewControllerRepresentable {
    final class Coordinator {
        var router: MainRouter?
    }
    
    func makeCoordinator() -> Coordinator { Coordinator() }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let nav = UINavigationController()
        nav.navigationBar.prefersLargeTitles = true
        
        let router = MainRouter(navigationController: nav)
        context.coordinator.router = router
        router.goToOnboarding()
        
        return nav
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
