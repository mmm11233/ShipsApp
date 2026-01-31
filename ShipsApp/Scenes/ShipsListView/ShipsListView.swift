//
//  ShipsListView.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 26.01.26.
//

import SwiftUI

struct ShipsListView: View {
    
    @ObservedObject var viewModel: ShipsViewModel

    init(dataController: DataController) {
            self.viewModel = ShipsViewModel(dataController: dataController)
        }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: Layout.verticalSpacing) {
                searchBar
                content
            }
            .navigationTitle("Ships")
            .navigationDestination(for: Ship.self) {
                ShipDetailsView(ship: $0)
            }
            .task {
                await viewModel.loadIfNeeded()
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
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
        .padding(.horizontal)
    }
    
    // MARK: - Skeleton
    private var skeletonView: some View {
        ScrollView {
            LazyVStack(spacing: Layout.cardSpacing) {
                ForEach(0..<3, id: \.self) { _ in
                    SkeletonCard()
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Ships List
    private var shipsView: some View {
        ScrollView {
            LazyVStack(spacing: Layout.cardSpacing) {
                ForEach(viewModel.filteredShips) { ship in
                    NavigationLink(value: ship) {
                        ShipCardView(
                            ship: ship,
                            onFavouriteTap: {
                                viewModel.toggleFavourite(for: ship)
                            }
                        )
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
}

// MARK: - SkeletonCard
struct SkeletonCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.3))
            .aspectRatio(16 / 9, contentMode: .fit)
            .frame(maxHeight: 220)
            .redacted(reason: .placeholder)
    }
}

// MARK: - Layout
private enum Layout {
    static let verticalSpacing: CGFloat = 12
    static let cardSpacing: CGFloat = 16
    static let cornerRadius: CGFloat = 10
}


struct ShipCardView: View {
    
    let ship: Ship
    let onFavouriteTap: () -> Void
    
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
            shipInfo
            Spacer()
            statusInfo
        }
        .padding()
        .foregroundColor(.white)
        .background(gradientBackground)
    }
    
    private var shipInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(ship.name)
                .font(.headline)
            Text(ship.type)
                .font(.subheadline)
        }
    }
    
    private var statusInfo: some View {
        VStack(alignment: .trailing, spacing: 8) {
            favouriteButton
            Text(ship.status)
                .font(.subheadline)
        }
    }
    
    private var favouriteButton: some View {
        Button(action: onFavouriteTap) {
            Image(systemName: ship.isFavorite ? "heart.fill" : "heart")
                .foregroundColor(.red)
                .frame(width: 24, height: 24)
        }
        .buttonStyle(.plain)
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
