//
//  FavouritesManaging.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 31.01.26.
//

import Foundation

protocol FavouritesManagingProtocol {
    func contains(_ id: String) -> Bool
    func add(_ id: String)
    func remove(_ id: String)
}

final class FavouritesManager: FavouritesManagingProtocol {
    // MARK: - Singleton
    static let shared = FavouritesManager()

    // MARK: - Private Properties
    private let key = "Favorites"
    private let storage: UserDefaults
    private var favourites: Set<String>
    
    // Serial queue ensures thread-safe access
    private let queue = DispatchQueue(label: "com.shipsapp.favouritesQueue")

    // MARK: - Initializer
    private init(storage: UserDefaults = .standard) {
        self.storage = storage
        let saved = storage.stringArray(forKey: key) ?? []
        self.favourites = Set(saved)
    }

    // MARK: - Public API
    func contains(_ id: String) -> Bool {
        queue.sync {
            favourites.contains(id)
        }
    }

    func add(_ id: String) {
        queue.sync {
            favourites.insert(id)
            persist()
        }
    }

    func remove(_ id: String) {
        queue.sync {
            favourites.remove(id)
            persist()
        }
    }

    // MARK: - Persistence
    private func persist() {
        storage.set(Array(favourites), forKey: key)
    }
}
