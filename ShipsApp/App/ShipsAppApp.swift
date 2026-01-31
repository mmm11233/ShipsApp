//
//  ShipsAppApp.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 26.01.26.
//

import SwiftUI
import CoreData

@main
struct ShipsAppApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ShipsListView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
