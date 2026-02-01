//
//  Ship.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 31.01.26.
//

import Foundation

struct ShipDTO: Decodable {
    let id: String
    let name: String
    let type: String
    let active: Bool
    let image: String?
    let status: String?
    let home_port: String?
    let year_built: Int?
    let mass_kg: Int?
    let mmsi: Int?
    let link: String?
    
}

struct Ship: Identifiable, Hashable {
    let id: String
    let name: String
    let type: String
    let status: String
    var isFavorite: Bool
    let image: String?
    let port: String?
    let yearBuilt: Int?
    let massKg: Int?
    let mmsi: Int?
    let linkURL: URL?
}


extension Ship {
    init(dto: ShipDTO, isFavorite: Bool) {
        self.id = dto.id
        self.name = dto.name
        self.type = dto.type
        self.status = dto.active ? "Active" : "Inactive"
        self.isFavorite = isFavorite
        self.image = dto.image
        self.linkURL = dto.link.flatMap { URL(string: $0) }
        
        self.port = dto.home_port
        self.yearBuilt = dto.year_built
        self.massKg = dto.mass_kg
        self.mmsi = dto.mmsi
    }
}
