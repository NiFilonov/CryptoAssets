//
//  UIImageView+ImageLoader.swift
//  CryptoAssets
//
//  Created by Globus Dev on 25.11.2022.
//

import UIKit

extension UIImageView {
    func setIcon(symbol: String) {
        loadWithCache(url: IconsEndpoint.icon(symbol: symbol.lowercased()).url)
    }
    
    func cancelLoadingIcon(for symbol: String) {
        if let url = IconsEndpoint.icon(symbol: symbol.lowercased()).url {
            ImageLoader.shared.cancelLoading(from: url)
        }
    }
    
    func loadWithCache(url: URL?) {
        ImageLoader.shared.loadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            self.image = image
        }
    }
}
