//
//  FavoriteAssetsManager.swift
//  CryptoAssets
//
//  Created by Globus Dev on 24.11.2022.
//

import Foundation

extension Notification.Name {
    static let favoriteAssetsFetched = Notification.Name(rawValue: "favoriteAssetsFetched")
    static let favoriteAssetsFetchingFailed = Notification.Name(rawValue: "favoriteAssetsFetchingFailed")
}

final class FavoriteAssetsManager {
    
    private enum Constants {
        static let assetsLimit: Int = 10
    }
    
    private var network: NetworkManaging? = ManagersAssembly.container.resolve(NetworkManager.self)
    private var storage: StorageManager? = ManagersAssembly.container.resolve(StorageManager.self)
    
    var assets: [Asset] = []
    
    func removeFromFavorite(asset: Asset) {
        storage?.removeFromFavorite(id: asset.id)
        assets.removeAll(where: { $0 == asset })
        fetchAssets()
    }
    
    func fetchAssets() {
        let ids = storage?.getFavoriteIds() ?? []
        if !ids.isEmpty {
            network?.fetchAssets(ids: ids,
                                 limit: nil,
                                 offset: nil, { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let assets):
                    if assets.count < ids.count {
                        NotificationCenter.default.post(name: .favoriteAssetsFetchingFailed, object: nil)
                    } else {
                        self.assets = assets
                        NotificationCenter.default.post(name: .favoriteAssetsFetched, object: nil)
                    }
                case .failure:
                    NotificationCenter.default.post(name: .favoriteAssetsFetchingFailed, object: nil)
                }
            })
        } else {
            assets = []
            NotificationCenter.default.post(name: .favoriteAssetsFetched, object: nil)
        }
    }
    
    func isFavorite(asset: Asset) -> Bool {
        guard let storage = storage else {
            return false
        }
        return storage.getFavoriteIds().contains(where: { $0 == asset.id })
    }
    
}
