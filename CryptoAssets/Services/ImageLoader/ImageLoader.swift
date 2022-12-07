//
//  ImageLoader.swift
//  CryptoAssets
//
//  Created by Globus Dev on 25.11.2022.
//

import Foundation
import UIKit

class ImageLoader {
    public static let shared = ImageLoader()
    
    private let cache: ImageCacheType
    
    private var runningTasks: [URL: URLSessionDataTask] = [:]
    
    public init(cache: ImageCacheType = ImageCache()) {
        self.cache = cache
    }
    
    func loadImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        guard let url = url else {
            return
        }
        if let image = cache[url] {
            completion(image)
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }
            var image: UIImage?

            defer {
                DispatchQueue.main.async { [weak self] in
                    self?.runningTasks.removeValue(forKey: url)
                    completion(image)
                }
            }

            if let data = data {
                image = UIImage(data: data)
                self.cache[url] = image
            }
        }
        runningTasks[url] = dataTask
        
        dataTask.resume()
    }
    
    func cancelLoading(from url: URL) {
        runningTasks[url]?.cancel()
        runningTasks.removeValue(forKey: url)
    }
    
}
