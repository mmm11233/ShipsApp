//
//  ShipDetailView.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 31.01.26.
//

import SwiftUI

// MARK: - Ship Details Screen
struct ShipDetailsView: View {
    let ship: Ship

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HeaderImageView(imageURL: ship.image)

                VStack(alignment: .leading, spacing: 12) {
                    TitleSection(ship: ship)
                    Divider()
                    DetailsSection(ship: ship)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
    }
}

 // MARK: - Header Image
private struct HeaderImageView: View {
    let imageURL: String?

    var body: some View {
        RemoteImageView(urlString: imageURL)
            .aspectRatio(16 / 9, contentMode: .fit)
            .frame(maxHeight: 240)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
            .shadow(
                color: .black.opacity(0.2),
                radius: 8,
                y: 4
            )
    }
}

// MARK: - Title Section
private struct TitleSection: View {
    let ship: Ship

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(ship.name)
                .font(.system(.title, design: .rounded, weight: .bold))

            Text(ship.type)
                .font(.title3)
                .foregroundStyle(.secondary)

            StatusBadge(status: ship.status)
                .padding(.top, 4)
        }
    }
}

// MARK: - Status Pill
private struct StatusBadge: View {
    let status: String

    var body: some View {
        Text(status)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(statusColor.opacity(0.15))
            )
            .foregroundColor(statusColor)
    }

    private var statusColor: Color {
        status.lowercased() == "active" ? .green : .red
    }
}

// MARK: - Details Section
private struct DetailsSection: View {
    let ship: Ship

    var body: some View {
        VStack(spacing: 10) {
            DetailRow(title: "Port", value: ship.port ?? "Unknown")
            DetailRow(title: "Year Built", value: yearText)
            DetailRow(title: "Mass (kg)", value: massText)
            DetailRow(title: "MMSI", value: ship.mmsi.map(String.init) ?? "Unknown")

            if let link = ship.linkURL {
                DetailRow(title: "More Info", value: "Open in Safari", url: link)
            }
        }
        .padding(.vertical, 4)
    }

    private var yearText: String {
        ship.yearBuilt.map { String($0) } ?? "Unknown"
    }

    private var massText: String {
        ship.massKg.map { "\($0)" } ?? "Unknown"
    }
}

// MARK: - Reusable Detail Row
private struct DetailRow: View {
    let title: String
    let value: String
    let url: URL?

    init(title: String, value: String, url: URL? = nil) {
        self.title = title
        self.value = value
        self.url = url
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            if let url = url {
                Link(value, destination: url)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.trailing)
            } else {
                Text(value)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding(.vertical, 4)
    }
}
