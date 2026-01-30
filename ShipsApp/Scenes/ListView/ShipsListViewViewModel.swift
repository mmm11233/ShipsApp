//
//  ShipsListViewViewModel.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 30.01.26.
//

import SwiftUI
import Foundation
import Combine

final class ShipsViewModel: ObservableObject {
    @Published var searchText: String = ""
    
    @Published var ships: [Ship] = [
        Ship(name: "MR STEVEN", type: "Tug", status: "Stopped", isFavorite: true),
        Ship(name: "Falcon 9", type: "Ship", status: "Active", isFavorite: false)
    ]
    
    var filteredShips: [Ship] {
        guard !searchText.isEmpty else { return ships }
        return ships.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
}
