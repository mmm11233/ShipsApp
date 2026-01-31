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

    // MARK: - Published Properties
    @Published var searchText: String = ""
    @Published private(set) var ships: [Ship] = []
    @Published private(set) var isLoading: Bool = false

    // MARK: - Dependencies
    private let service: ShipsServiceProtocol
    private let favouritesManager: FavouritesManagingProtocol

    // MARK: - Init
    init(
        service: ShipsServiceProtocol = ShipsService(client: NetworkClient()),
        favouritesManager: FavouritesManagingProtocol = FavouritesManager.shared
    ) {
        self.service = service
        self.favouritesManager = favouritesManager
    }

    // MARK: - Computed Properties
    var filteredShips: [Ship] {
        guard !searchText.isEmpty else { return ships }
        return ships.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.type.localizedCaseInsensitiveContains(searchText)
        }
    }

    // MARK: - Lifecycle Methods
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
                    isFavorite: favouritesManager.contains(dto.id)
                )
            }
        } catch {
            print("Error loading ships:", error)
        }
    }

    // MARK: - Actions
    func toggleFavourite(for ship: Ship) {
        if favouritesManager.contains(ship.id) {
            favouritesManager.remove(ship.id)
        } else {
            favouritesManager.add(ship.id)
        }

        updateFavouriteState(for: ship.id)
    }

    // MARK: - Private Helpers
    private func updateFavouriteState(for id: String) {
        guard let index = ships.firstIndex(where: { $0.id == id }) else { return }
        ships[index].isFavorite.toggle()
    }
}
