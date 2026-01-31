//
//  FavouritesManager.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 31.01.26.
//


import SwiftUI

@Observable
final class FavouritesManager {
    static let shared: FavouritesManager = .init()
    
    private var ships: Set<String>
    private let key = "Favorites"
    private let storage: UserDefaults
    
    private init(storage: UserDefaults = .standard) {
        self.storage = storage
        if let saved = storage.array(forKey: key) as? [String] {
            ships = Set(saved)
        } else {
            ships = []
        }
    }
}

extension FavouritesManager {
    func contains(_ ship: Ship) -> Bool {
        ships.contains(ship.id)
    }
    
    func add(_ ship: Ship) {
        ships.insert(ship.id)
        save()
    }
    
    func remove(_ ship: Ship) {
        ships.remove(ship.id)
        save()
    }
    
    private func save() {
        storage.set(Array(ships), forKey: key)
    }
}
