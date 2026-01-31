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
        NavigationStack {
            content
                .navigationTitle("Ships")
                .task {
                    if viewModel.ships.isEmpty {
                        await viewModel.initialLoad()
                    }
                }
        }
    }
    
    private var content: some View {
        VStack(spacing: 12) {
            searchBar
            
            if viewModel.isLoading {
                skeletonList
            } else {
                shipsList
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search Ships", text: $viewModel.searchText)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private var skeletonList: some View {
        List(0..<3, id: \.self) { _ in
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(16 / 9, contentMode: .fit)
                .frame(maxHeight: 220)
                .redacted(reason: .placeholder)
            
        }
        .listStyle(.plain)
    }
    
    private var shipsList: some View {
        List(viewModel.filteredShips) { ship in
            ShipCardView(ship: ship)
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.loadShips()
        }
    }
}

struct ShipCardView: View {
    
    let ship: Ship
    
    var body: some View {
        RemoteImageView(urlString: ship.image)
            .aspectRatio(16 / 9, contentMode: .fit)
            .frame(maxHeight: 220)
            .overlay(alignment: .bottom) {
                infoOverlay
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(ship.name), \(ship.type), \(ship.status)")
    }
    
    private var infoOverlay: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(ship.name)
                    .font(.headline)
                
                Text(ship.type)
                    .font(.subheadline)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                Image(systemName: ship.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(ship.isFavorite ? .red : .white)
                
                Text(ship.status)
                    .font(.subheadline)
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(
            LinearGradient(
                colors: [.black.opacity(0.6), .clear],
                startPoint: .bottom,
                endPoint: .top
            )
        )
    }
}


#Preview {
    ShipsListView()
}
