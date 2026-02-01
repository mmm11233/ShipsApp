//
//  ShipDetailView.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 31.01.26.
//

import Foundation
import SwiftUI

struct ShipDetailsView: View {
    
    let ship: Ship
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - Header Image
                ShipHeaderImageView(imageURL: ship.image)
                
                // MARK: - Ship Info
                VStack(alignment: .leading, spacing: 12) {
                    Text(ship.name)
                        .font(.largeTitle.bold())
                    
                    Text(ship.type)
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    // MARK: - Details
                    detailSection
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Details Section
    private var detailSection: some View {
        VStack(spacing: 12) {
            DetailRow(title: "Status", value: ship.status)
            DetailRow(title: "Port", value: ship.port ?? "Unknown")
            DetailRow(title: "Year", value: ship.yearBuilt.map(String.init) ?? "Unknown")
            DetailRow(title: "MMSI", value: ship.mmsi.map(String.init) ?? "Unknown")
            DetailRow(title: "URL", value: ship.linkURL?.absoluteString ?? "No URL", url: ship.linkURL)
        }
    }
}

// MARK: - Reusable Detail Row
struct DetailRow: View {
    let title: String
    let value: String
    let url: URL?
    
    init(title: String, value: String, url: URL? = nil) {
        self.title = title
        self.value = value
        self.url = url
    }
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            
            Spacer()
            
            if let url = url {
                Link(value, destination: url)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.trailing)
            } else {
                Text(value)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}

// MARK: - Ship Header Image
struct ShipHeaderImageView: View {
    let imageURL: String?
    
    var body: some View {
        RemoteImageView(urlString: imageURL)
            .aspectRatio(16 / 9, contentMode: .fit)
            .frame(maxHeight: 220)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            .shadow(radius: 5, y: 2)
    }
}
