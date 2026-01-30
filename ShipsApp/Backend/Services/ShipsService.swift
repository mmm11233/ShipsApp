//
//  ShipsService.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 31.01.26.
//

import Foundation
import NetworkKit

protocol ShipsServiceProtocol {
    func fetchShips() async throws -> [ShipDTO]
}

final class ShipsService: ShipsServiceProtocol {

    private let client: NetworkClient

    init(client: NetworkClient) {
        self.client = client
    }

    func fetchShips() async throws -> [ShipDTO] {
        try await client.request(
            endpoint: ShipsEndpoint.ships,
            responseType: [ShipDTO].self
        )
    }
}


enum ShipsEndpoint: Endpoint {
  case ships

    var baseURL: String {
        "https://api.spacexdata.com/v4"
    }

    var path: String {
        "/ships"
    }

    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String]? {
       ["" : ""]
    }
    
    var queryItems: [URLQueryItem]? {
        []
    }
}
