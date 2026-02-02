//
//  CoreDataEntity+Extensions.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 02.02.26.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func count<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil) -> Int {
        let request = T.fetchRequest()
        request.predicate = predicate
        do {
            return try count(for: request)
        } catch {
            print("Count fail for \(T.self):", error)
            return 0
        }
    }
}
