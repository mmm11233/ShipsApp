//
//  ShipsViewModel.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 30.01.26.
//

import Foundation
import Combine
import NetworkKit

@MainActor
final class ShipsViewModel: ObservableObject {

    // MARK: - Published properties
    @Published var searchText: String = ""
    @Published private(set) var ships: [Ship] = []
    @Published var isLoading: Bool = false

    // MARK: - Dependencies
    private let service: ShipsServiceProtocol
    private let persistence: PersistenceControllerProtocol

    // MARK: - Init
    init(
        service: ShipsServiceProtocol = ShipsService(),
        persistence: PersistenceControllerProtocol
    ) {
        self.service = service
        self.persistence = persistence
    }

    // MARK: - Computed
    var filteredShips: [Ship] {
        guard !searchText.isEmpty else { return ships }
        return ships.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.type.localizedCaseInsensitiveContains(searchText)
        }
    }

    // MARK: - Data loading
    func loadIfNeeded() async {
        guard ships.isEmpty else { return }
        await loadShips()
    }

    func loadShips() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let items = try await service.fetchShips()
            let favourites = Set(persistence.fetchAllFavourites().map(\.id))
            
            ships = items.map { item -> Ship in
                var mutableItem = item
                mutableItem.isFavorite = favourites.contains(item.id)
                
                return mutableItem
            }
        } catch {
            print("Ship load failed:", error) //TODO: aq alerti amoagde
        }
    }

    // MARK: - Favourites handling
    func toggleFavourite(for ship: Ship) {
        persistence.toggleFavourite(for: ship)
        updateFavouriteState(for: ship.id)
    }

    private func updateFavouriteState(for id: String) {
        guard let index = ships.firstIndex(where: { $0.id == id }) else { return }
        ships[index].isFavorite?.toggle()
    }
}
