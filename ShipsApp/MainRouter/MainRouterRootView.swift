import SwiftUI
import UIKit

struct MainRouterRootView: UIViewControllerRepresentable {
    final class Coordinator {
        var router: MainRouter?
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        
        let router = MainRouter(navigationController: navigationController)
        context.coordinator.router = router
        router.goToOnboarding()
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
