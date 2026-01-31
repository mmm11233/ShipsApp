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
}

struct Ship: Identifiable, Hashable {
    let id: String
    let name: String
    let type: String
    let status: String
    var isFavorite: Bool
    let image: String?

}


extension Ship {
    init(dto: ShipDTO, isFavorite: Bool) {
        self.id = dto.id
        self.name = dto.name
        self.type = dto.type
        self.status = dto.active ? "Active" : "Inactive"
        self.isFavorite = isFavorite
        self.image = dto.image
    }
}
