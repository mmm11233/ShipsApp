//
//  DataController.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 01.02.26.
//

import Foundation
import CoreData
import Combine

class DataController: ObservableObject {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Ship") // your xcdatamodeld name
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Save Context
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    // MARK: - Add Favourite Ship
    func addFavourite(ship: Ship) {
        let context = container.viewContext
        let obj = ShipObj(context: context)
        obj.id = ship.id
        obj.name = ship.name
        obj.type = ship.type
        obj.statuse = ship.status
        obj.image = ship.image
        saveContext()
    }
    
    // MARK: - Remove Favourite Ship
    func removeFavourite(ship: Ship) {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<ShipObj> = ShipObj.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", ship.id)
        do {
            let results = try context.fetch(fetchRequest)
            for obj in results {
                context.delete(obj)
            }
            saveContext()
        } catch {
            print("Failed to remove favourite: \(error)")
        }
    }
    
    // MARK: - Check if Ship is Favourite
    func isFavourite(ship: Ship) -> Bool {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<ShipObj> = ShipObj.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", ship.id)
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to check favourite: \(error)")
            return false
        }
    }
    
    // MARK: - Fetch All Favourite Ships
    func fetchFavourites() -> [Ship] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<ShipObj> = ShipObj.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { obj in
                Ship(
                    id: obj.id ?? "",
                    name: obj.name ?? "",
                    type: obj.type ?? "",
                    status: obj.statuse ?? "",
                    isFavorite: true,
                    image: obj.image
                )
            }
        } catch {
            print("Failed to fetch favourites: \(error)")
            return []
        }
    }
}
