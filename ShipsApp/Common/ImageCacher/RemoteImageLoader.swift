//
//  RemoteImageLoader.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 01.02.26.
//
import UIKit

final class RemoteImageLoader {
    static let shared = RemoteImageLoader()
    
    private let cache = NSCache<NSURL, UIImage>()
    private let session = URLSession.shared
    
    private init() {}
    
    func load(url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cached = cache.object(forKey: url as NSURL) {
            completion(cached)
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, _, error in
            guard let data, let image = UIImage(data: data), error == nil else {
                completion(nil)
                return
            }
            
            self?.cache.setObject(image, forKey: url as NSURL)
            completion(image)
        }
        task.resume()
    }
}
