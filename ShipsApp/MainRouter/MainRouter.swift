//
//  MainRouter.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 02.02.26.
//

import UIKit
import SwiftUI

final class MainRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Root Onboarding
    func goToOnboarding() {
        let onboarding = OnboardingView(
            onSwiftUIVersionTap: { [weak self] in self?.goToShipsListSwiftUI() },
            onUIKitVersionTap: { [weak self] in self?.goToShipsListUIKit() }
        )
        
        let hosting = UIHostingController(rootView: onboarding)
        hosting.navigationItem.largeTitleDisplayMode = .never
        navigationController.setViewControllers([hosting], animated: false)
    }
    
    // MARK: - SwiftUI version
    func goToShipsListSwiftUI() {
        let persistence = PersistenceController()
        let viewModel = ShipsViewModel(persistence: persistence)
        
        let listView = ShipsListView(
            viewModel: viewModel,
            onShipTap: { [weak self] ship in
                self?.goToShipDetails(ship: ship)
            }
        )
        
        let hostingController = UIHostingController(rootView: listView)
        hostingController.title = "Ships"
        hostingController.navigationItem.largeTitleDisplayMode = .automatic
        navigationController.pushViewController(hostingController, animated: false)
    }
    
    // MARK: - UIKit version
    func goToShipsListUIKit() {
        let persistence = PersistenceController()
        let viewModel = ShipsViewModel(persistence: persistence)
        let controller = ShipsListViewController(viewModel: viewModel, router: self)
        
        controller.navigationItem.largeTitleDisplayMode = .automatic
        navigationController.pushViewController(controller, animated: false)
    }
    
    // MARK: - Details screen
    func goToShipDetails(ship: Ship) {
        let details = ShipDetailsView(ship: ship)
        let hosting = UIHostingController(rootView: details)
        
        hosting.title = ship.name
        hosting.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(hosting, animated: true)
    }
}
