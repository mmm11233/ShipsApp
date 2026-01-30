//
//  ImageCache.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 31.01.26.
//

import UIKit

protocol ImageCacheProtocol {
    func image(forKey key: String) -> UIImage?
    func setImage(_ image: UIImage, forKey key: String)
}

final class ImageCache: ImageCacheProtocol {

    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
