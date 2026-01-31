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
            VStack(spacing: 12) {
                searchBar
                content
            }
            .navigationTitle("Ships")
            .navigationDestination(for: Ship.self) { ship in
                ShipDetailsView(ship: ship)
            }
            .task {
                await loadIfNeeded()
            }
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            skeletonView
        } else {
            shipsView
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search Ships", text: $viewModel.searchText)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }

    // MARK: - Skeleton

    private var skeletonView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(0..<3, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(16 / 9, contentMode: .fit)
                        .frame(maxHeight: 220)
                        .redacted(reason: .placeholder)
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Ships List

    private var shipsView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredShips) { ship in
                    NavigationLink(value: ship) {
                        ShipCardView(ship: ship)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
        .refreshable {
            await viewModel.loadShips()
        }
    }

    // MARK: - Helpers

    private func loadIfNeeded() async {
        guard viewModel.ships.isEmpty else { return }
        await viewModel.initialLoad()
    }
}

struct ShipCardView: View {
    @StateObject private var viewModel = ShipsViewModel()
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
            .accessibilityLabel(accessibilityText)
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
                
favouriteButton(with: ship)
                Text(ship.status)
                    .font(.subheadline)
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(gradientBackground)
    }
    
    private func favouriteButton(with ship: Ship)-> some View {
        Button {
            viewModel.favouriteButtonDidTap(ship: ship)
        } label: {
            Image(systemName: FavouritesManager.shared.contains(ship) ? "heart.fill" : "heart")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.red)
        }
        .buttonStyle(.plain)
        .padding()
    }

    private var gradientBackground: some View {
        LinearGradient(
            colors: [.black.opacity(0.6), .clear],
            startPoint: .bottom,
            endPoint: .top
        )
    }

    private var accessibilityText: String {
        "\(ship.name), \(ship.type), \(ship.status)"
    }
}

#Preview {
    ShipsListView()
}
