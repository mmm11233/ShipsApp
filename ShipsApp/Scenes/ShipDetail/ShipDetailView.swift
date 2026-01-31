//
//  ShipDetailView.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 31.01.26.
//

import Foundation
import SwiftUI

struct ShipDetailsView: View {
    
    @StateObject var viewModel: ShipDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                
                ShipHeaderImageView(imageURL: viewModel.ship.imageURL)
                
                ShipTitleView(name: viewModel.ship.name)
                
                ForEach(viewModel.rows) { row in
                    KeyValueRowView(row: row)
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct KeyValueRowView: View {
    
    let row: KeyValueRow
    
    var body: some View {
        HStack(alignment: .top) {
            Text(row.title)
                .foregroundColor(.gray)
            
            Spacer()
            
            if row.isLink, let url = URL(string: row.value) {
                Link(row.value, destination: url)
                    .multilineTextAlignment(.trailing)
            } else {
                Text(row.value)
                    .multilineTextAlignment(.trailing)
            }
        }
        .font(.system(size: 16))
        .padding(.vertical, 6)
    }
}

struct ShipHeaderImageView: View {
    
    let imageURL: String?
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL ?? "")) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .padding(40)
                .foregroundColor(.gray)
        }
        .frame(height: 220)
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .clipped()
    }
}

struct ShipTitleView: View {
    let name: String
    
    var body: some View {
        Text(name)
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
