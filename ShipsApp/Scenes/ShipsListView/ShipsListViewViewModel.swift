//
//  ShipsListViewViewModel.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 30.01.26.
//

import SwiftUI
import Foundation
import Combine
import NetworkKit

@MainActor
final class ShipsViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published private(set) var ships: [Ship] = []
    @Published var isLoading = false

    private let service: ShipsServiceProtocol
    private let dataController: DataController

    init(
        service: ShipsServiceProtocol = ShipsService(client: NetworkClient()),
        dataController: DataController
    ) {
        self.service = service
        self.dataController = dataController
    }
    
    var filteredShips: [Ship] {
        guard !searchText.isEmpty else { return ships }
        return ships.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.type.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func loadIfNeeded() async {
        guard ships.isEmpty else { return }
        await loadShips()
    }
    
    func loadShips() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let dtoShips = try await service.fetchShips()
            ships = dtoShips.map { dto in
                Ship(
                    dto: dto,
                    isFavorite: dataController.isFavourite(ship: Ship(dto: dto, isFavorite: false))
                )
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - Favourites Actions
    func toggleFavourite(for ship: Ship) {
        if dataController.isFavourite(ship: ship) {
            dataController.removeFavourite(ship: ship)
        } else {
            dataController.addFavourite(ship: ship)
        }
        
        updateFavouriteState(for: ship.id)
    }

    private func updateFavouriteState(for id: String) {
        guard let index = ships.firstIndex(where: { $0.id == id }) else { return }
        ships[index].isFavorite.toggle()
    }
}
