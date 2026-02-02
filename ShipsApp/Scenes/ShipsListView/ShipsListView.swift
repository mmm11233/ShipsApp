//
//  ShipsListView.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 26.01.26.
//

import SwiftUI

struct ShipsListView: View {
    @ObservedObject var viewModel: ShipsViewModel
    let onShipTap: (Ship) -> Void
    
    init(viewModel: ShipsViewModel, onShipTap: @escaping (Ship) -> Void) {
        self.viewModel = viewModel
        self.onShipTap = onShipTap
    }
    
    var body: some View {
        NavigationStack {
            content
                .searchable(text: $viewModel.searchText, prompt: "Search Ships")
                .refreshable { await viewModel.loadShips() }
        }
        .task { await viewModel.loadIfNeeded() }
        .background(DS.Colors.background)
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.ships.isEmpty {
            ProgressView("Loading Ships...")
                .progressViewStyle(.circular)
                .padding()
        } else {
            ScrollView {
                LazyVStack(spacing: DS.Spacing.medium) {
                    ForEach(viewModel.filteredShips) { ship in
                        ShipCardView(
                            ship: ship,
                            onFavouriteTap: { viewModel.toggleFavourite(for: ship) }
                        )
                        .onTapGesture { onShipTap(ship) }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Ship Card View
struct ShipCardView: View {
    let ship: Ship
    let onFavouriteTap: () -> Void
    
    @State private var animateLike = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RemoteImageView(urlString: ship.image)
                .aspectRatio(16 / 9, contentMode: .fit)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(ship.name)
                        .font(DS.Typography.subheading())
                        .foregroundColor(.white)
                    Text(ship.type)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                VStack {
                    Button(action: favouriteTapped) {
                        Image(systemName: ship.isFavorite == true ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .scaleEffect(animateLike ? 1.3 : 1)
                    }
                    .buttonStyle(.plain)
                    Text(ship.activeText)
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(
                LinearGradient(colors: [.black.opacity(0.6), .clear],
                               startPoint: .bottom, endPoint: .top)
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.medium))
        .shadow(radius: 5)
    }
    
    private func favouriteTapped() {
        withAnimation(.spring(response: 0.25)) {
            animateLike = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            animateLike = false
            onFavouriteTap()
        }
    }
}
