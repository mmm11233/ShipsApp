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
            VStack(alignment: .leading, spacing: 16) {
                
                ShipHeaderImageView(imageURL: ship.image)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(ship.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(ship.type)
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    detailRow(title: "Status", value: ship.status)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
    }
}

struct ShipHeaderImageView: View {
    
    let imageURL: String?
    
    var body: some View {
        RemoteImageView(urlString: imageURL)
            .aspectRatio(16 / 9, contentMode: .fit)
            .frame(maxHeight: 220)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
    }
}
