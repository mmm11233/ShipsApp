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
    @Published var ships: [Ship] = []
    @Published var isLoading = false
    
    private let service: ShipsServiceProtocol
    
    init() {
        let client = NetworkClient()
        self.service = ShipsService(client: client)
    }
    
    
    var filteredShips: [Ship] {
        guard !searchText.isEmpty else { return ships }
        return ships.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.type.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    //MARK: - Actions
    func favouriteButtonDidTap(ship: Ship) {
        if FavouritesManager.shared.contains(ship) {
            FavouritesManager.shared.remove(ship)
        } else {
            FavouritesManager.shared.add(ship)
        }
    }
    
    func loadShips() async {
        do {
            let dtoShips = try await service.fetchShips()
            ships = dtoShips.map { Ship(dto: $0, isFavorite: false) }
        } catch {
            print(error)
        }
    }
    
    func initialLoad() async {
        isLoading = true
        await loadShips()
        isLoading = false
    }
}
