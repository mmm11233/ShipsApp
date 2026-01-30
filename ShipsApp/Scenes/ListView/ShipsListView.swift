//
//  ShipsListView.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 26.01.26.
//

import SwiftUI

struct ShipsListView: View {
    
    @StateObject private var viewModel = ShipsViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search Ships", text: $viewModel.searchText)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            if viewModel.isLoading {
                
                ProgressView()
                    .padding()
                
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredShips) { ship in
                            ShipCardView(ship: ship)
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            await viewModel.loadShips()
        }
    }
}

struct ShipCardView: View {
    
    let ship: Ship
    
    var body: some View {
        
        ZStack {
            Image(systemName: "photo")
                .resizable()
                .foregroundColor(.gray)
                .font(.title2)
            
            HStack{
                VStack(alignment: .leading, spacing: 4) {
                    Text(ship.name)
                        .font(.headline)
                        .foregroundColor(.gray)

                    Text(ship.type)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 58) {
                    Image(systemName: ship.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(ship.isFavorite ? .black : .gray)
                    
                    Text(ship.status)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.black.opacity(0.25))
        }
        .frame(height: 150)
        .cornerRadius(12)
    }
}


#Preview {
    ShipsListView()
}
