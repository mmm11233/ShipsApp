//
//  ShipDetailViewModel.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 31.01.26.
//

import Foundation
import SwiftUI
import Combine

final class ShipDetailsViewModel: ObservableObject {
    
    @Published var ship: ShipDetails
    
    init(ship: ShipDetails) {
        self.ship = ship
    }
    
    var rows: [KeyValueRow] {
        [
            .init(title: "Type", value: ship.type),
            .init(title: "Port", value: ship.port),
            .init(title: "Year", value: ship.year),
            .init(title: "Missions", value: ship.missions),
            .init(title: "Url", value: ship.url, isLink: true)
        ]
    }
}

struct KeyValueRow: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    var isLink: Bool = false
}

struct ShipDetails {
    let name: String
    let imageURL: String?
    let type: String
    let port: String
    let year: String
    let missions: String
    let url: String
}

