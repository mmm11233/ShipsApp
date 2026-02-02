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
                image
                    .resizable()
                
            case .failure:
                placeholder
                
            @unknown default:
                placeholder
            }
        }
    }
    
    private var imageURL: URL? {
        guard let urlString, let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    private var placeholder: some View {
        ZStack {
            Color.gray.opacity(0.3)
            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundColor(.white.opacity(0.6))
        }
    }
}
