//
//  RemoteImageView.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 31.01.26.
//


import SwiftUI

struct RemoteImageView: View {

    let urlString: String?

    @State private var image: UIImage?
    @State private var isLoading = false

    private let loader = ImageLoader()

    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if isLoading {
                ProgressView()
            } else {
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            }
        }
        .task {
            await loadImage()
        }
    }

    private func loadImage() async {
        guard let urlString else { return }
        isLoading = true
        do {
            image = try await loader.loadImage(from: urlString)
        } catch {
            print("Image load error:", error)
        }
        isLoading = false
    }
}
