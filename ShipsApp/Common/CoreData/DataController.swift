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
    let container = NSPersistentContainer(name: "ShipObj")
     
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription )")
            }
        }
    }
}
