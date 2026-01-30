//
//  ImageLoader.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 31.01.26.
//


import UIKit

final class ImageLoader {

    private let cache: ImageCacheProtocol

    init(cache: ImageCacheProtocol = ImageCache.shared) {
        self.cache = cache
    }

    func loadImage(from urlString: String) async throws -> UIImage {
        
        //MARK: - Check cache
        if let cachedImage = cache.image(forKey: urlString) {
            return cachedImage
        }

        //MARK: - Download
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }

        //MARK: - Save to cache
        cache.setImage(image, forKey: urlString)

        return image
    }
}
