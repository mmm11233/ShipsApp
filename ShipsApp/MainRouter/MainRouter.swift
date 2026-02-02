//
//  MainRouter.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 02.02.26.
//

import UIKit
import SwiftUI
import CoreData
//MARK: TODO gaakete protocol
final class MainRouter {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func goToOnboarding() {
        let view = OnboardingView(
            onSwiftUIVersionTap: { [weak self] in
                self?.goToShipsListSwiftUI()
            },
            onUIKitVersionTap: { [weak self] in
                self?.goToShipsListTableView()
            }
        )
        
        let hostingController = UIHostingController(rootView: view)
        hostingController.navigationItem.largeTitleDisplayMode = .never
        navigationController.setViewControllers([hostingController], animated: false)
    }
    
    func goToShipsListSwiftUI() {
        let dataController = DataController()
        
        let view = ShipsListView(
            dataController: dataController,
            onShipTap: { [weak self] ship in
                self?.goToShipDetails(ship: ship)
            }
        )
            .environment(\.managedObjectContext, dataController.getContext())
        
        let hostingController = UIHostingController(rootView: view)
        hostingController.title = "Ships"
        hostingController.navigationItem.largeTitleDisplayMode = .automatic
        
        navigationController.pushViewController(hostingController, animated: false)
    }
    
    func goToShipsListTableView() {
        let dataController = DataController()
        let viewModel = ShipsViewModel(dataController: dataController)
        let shipsVC = ShipsListViewController(viewModel: viewModel, router: self)
        shipsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        navigationController.pushViewController(shipsVC, animated: false)
    }
    
    func goToShipDetails(ship: Ship) {
        let detailsView = ShipDetailsView(ship: ship)
        let hostingController = UIHostingController(rootView: detailsView)
        hostingController.title = ship.name
        hostingController.navigationItem.largeTitleDisplayMode = .never
        
        navigationController.pushViewController(hostingController, animated: false)
    }
}
