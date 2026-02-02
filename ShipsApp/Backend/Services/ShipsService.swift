//
//  ShipsService.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 31.01.26.
//

import NetworkKit
import Foundation

protocol ShipsServiceProtocol {
    func fetchShips() async throws -> [ShipDTO]
}

final class ShipsService: ShipsServiceProtocol {
    
    private let client: NetworkClientProtocol
    
    init(client: NetworkClientProtocol) {
        self.client = client
    }
    
    func fetchShips() async throws -> [ShipDTO] {
        do {
            return try await client.request(
                endpoint: ShipsEndpoint.ships,
                responseType: [ShipDTO].self
            )
        } catch {
            print("Ship Fetch Failed:", error.localizedDescription)
            throw error
        }
    }
}

enum ShipsEndpoint: Endpoint {
    case ships
    
    var baseURL: String {
        "https://api.spacexdata.com"
    }
    
    var path: String {
        switch self {
        case .ships:
            return "/v4/ships"
        }
    }
    
    var method: HTTPMethod { .get }
}
