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
    private let persistence: PersistenceContainerProtocol

    // MARK: - Init
    init(
        service: ShipsServiceProtocol,
        persistence: PersistenceContainerProtocol
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
            let items: [Ship]
            if await ReachabilityManager.shared.isInternetAvailable() {
                items = try await Task.detached(priority: .userInitiated) { [service] in
                    try await service.fetchShips()
                }.value
            } else {
                items = try await persistence.fetchShips()
            }
            
            let favourites = try await Set(persistence.fetchShips().map(\.id))
            
            ships = items.map { item -> Ship in
                var mutableItem = item
                mutableItem.isFavorite = favourites.contains(item.id)
                
                return mutableItem
            }
        } catch {
            print("Ship load failed:", error)
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
