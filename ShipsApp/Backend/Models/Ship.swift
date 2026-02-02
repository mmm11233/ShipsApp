//
//  Ship.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 31.01.26.
//

import Foundation

struct Ship: Decodable, Hashable, Identifiable {
    let id: String
    let name: String
    let type: String
    let active: Bool
    let image: String?
    let status: String?
    let homePort: String?
    let yearBuilt: Int?
    let massKg: Int?
    let mmsi: Int?
    let link: String?
    
    var activeText: String {
        active ? "Active" : "Inactive"
    }
    
    var isFavorite: Bool? = false
    var websiteURL: URL? { link.flatMap { URL(string: $0) } }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case active
        case image
        case status
        case homePort = "home_port"
        case yearBuilt = "year_built"
        case massKg = "mass_kg"
        case mmsi
        case link
    }
}
