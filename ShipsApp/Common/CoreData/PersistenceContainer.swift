//
//  PersistenceContainer.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 01.02.26.
//

import Foundation
import CoreData
import Combine

// MARK: - Protocol for CoreData abstraction
protocol PersistenceContainerProtocol {
    func toggleFavourite(for ship: Ship)
    func isFavourite(shipID: String) -> Bool
    func fetchAllFavourites() -> [Ship]
}

// MARK: - Implementation
final class PersistenceContainer: ObservableObject, PersistenceContainerProtocol {
    private let container: NSPersistentContainer
    
    init(modelName: String = "Ship") {
        container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { description, error in
            if let error {
                assertionFailure("Failed to load Core Data store: \(error.localizedDescription)")
            }
        }
    }

    private var context: NSManagedObjectContext { container.viewContext }

    // MARK: - Save convenience
    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Core Data save error:", error)
        }
    }

    // MARK: - Favourites API
    func toggleFavourite(for ship: Ship) {
        if isFavourite(shipID: ship.id) {
            removeFavourite(id: ship.id)
        } else {
            addFavourite(ship)
        }
        saveContext() 
    }

    func isFavourite(shipID: String) -> Bool {
        let request: NSFetchRequest<ShipObj> = ShipObj.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", shipID)
        do {
            return try context.count(for: request) > 0
        } catch {
            print("Favorite check failed:", error)
            return false
        }
    }

    func fetchAllFavourites() -> [Ship] {
        let request: NSFetchRequest<ShipObj> = ShipObj.fetchRequest()
        do {
            return try context.fetch(request).compactMap(mapToDomain(_:))
        } catch {
            print("Fetch favorites failed:", error)
            return []
        }
    }

    // MARK: - Internal Helpers
    private func addFavourite(_ ship: Ship) {
        let obj = ShipObj(context: context)
        obj.id = ship.id
        obj.name = ship.name
        obj.type = ship.type
        obj.active = ship.active
        obj.status = ship.status
        obj.image = ship.image
        obj.port = ship.homePort
        obj.year = Int32(ship.yearBuilt ?? 0)
        obj.mass = Int32(ship.massKg ?? 0)
        obj.mission = Int32(ship.mmsi ?? 0)
        obj.link = ship.websiteURL?.absoluteString
    }

    private func removeFavourite(id: String) {
        let request: NSFetchRequest<ShipObj> = ShipObj.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            for obj in try context.fetch(request) {
                context.delete(obj)
            }
        } catch {
            print("Remove favorite failed:", error)
        }
    }

    private func mapToDomain(_ obj: ShipObj) -> Ship {
        Ship(
            id: obj.id ?? "",
            name: obj.name ?? "",
            type: obj.type ?? "",
            active: obj.active,
            image: obj.image,
            status: obj.status,
            homePort: obj.port,
            yearBuilt: obj.year == 0 ? nil : Int(obj.year),
            massKg: obj.mass == 0 ? nil : Int(obj.mass),
            mmsi: obj.mission == 0 ? nil : Int(obj.mission),
            link: obj.link,
            isFavorite: true
        )
    }
}
