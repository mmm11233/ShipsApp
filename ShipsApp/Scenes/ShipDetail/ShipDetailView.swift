//
//  ShipDetailView.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 31.01.26.
//

import SwiftUI

struct ShipDetailsView: View {
    let ship: Ship
    
    var body: some View {
        ScrollView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    shipImageBlock
                    
                    headerBlock
                    
                    detailsBlock
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            .background(DS.Colors.background)
            .navigationTitle(ship.name)
        }
    }
    
    private var shipImageBlock: some View {
        Group {
            if let imageURL = ship.image {
                RemoteImageView(urlString: imageURL)
                    .aspectRatio(16/9, contentMode: .fit)
                    .frame(maxHeight: 240)
                    .clipShape(RoundedRectangle(cornerRadius: DS.Radius.medium))
                    .shadow(radius: 8)
            }
        }
    }
    
    private var headerBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(ship.name)
                .font(DS.Typography.heading(24))
            
            Text(ship.type)
                .font(.title3)
                .foregroundStyle(.secondary)
            
            StatusBadge(ship: ship)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var detailsBlock: some View {
        VStack(spacing: 12) {
            DetailRow(title: "Port", value: ship.homePort ?? "Unknown")
            DetailRow(title: "Year Built", value: ship.yearBuilt?.description ?? "Unknown")
            DetailRow(title: "Mass (kg)", value: ship.massKg?.description ?? "Unknown")
            DetailRow(title: "MMSI", value: ship.mmsi?.description ?? "Unknown")
            
            if let url = ship.websiteURL {
                DetailRow(title: "More Info", value: "Open in Safari", url: url)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .shadow(radius: 4)
        )
    }
}

// MARK: - Supporting Subviews
private struct StatusBadge: View {
    let ship: Ship
    
    var body: some View {
        Text(ship.activeText)
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(statusColor.opacity(0.2))
            )
            .foregroundColor(statusColor)
    }
    
    private var statusColor: Color {
        ship.active ? DS.Colors.success : DS.Colors.danger
    }
}

private struct DetailRow: View {
    let title: String
    let value: String
    var url: URL?
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            if let url {
                Link(value, destination: url)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
            } else {
                Text(value).fontWeight(.medium)
            }
        }
    }
}
