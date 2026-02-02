//
//  RemoteImageView.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 31.01.26.
//

import SwiftUI

struct RemoteImageView: View {
    let urlString: String?

    var body: some View {
        AsyncImage(url: imageURL) { phase in
            switch phase {
            case .empty:
                placeholder
            case .success(let image):
                image.resizable()
            case .failure:
                placeholder
            @unknown default:
                placeholder
            }
        }
        .background(DS.Colors.placeholder)
        .clipped()
    }

    private var imageURL: URL? {
        guard let urlString else { return nil }
        return URL(string: urlString)
    }

    private var placeholder: some View {
        ZStack {
            DS.Colors.placeholder
            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundColor(.white.opacity(0.6))
        }
    }
}
