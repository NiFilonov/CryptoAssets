//
//  StorageManager.swift
//  CryptoAssets
//
//  Created by Globus Dev on 24.11.2022.
//

import Foundation

final class StorageManager {
    
    private var storageService: StorageService? = ServicesAssembly.container.resolve(StorageService.self)
    
}

// MARK: - Favorite

extension StorageManager {
    
    func getFavoriteIds() -> [String] {
        storageService?.fetch(key: .favoriteIds) ?? []
    }
    
    func addFavoriteId(_ id: String) {
        var ids = getFavoriteIds()
        ids.append(id)
        saveFavoriteIds(ids)
    }
    
    func removeFromFavorite(id: String) {
        var ids = getFavoriteIds()
        ids.removeAll(where: { $0 == id })
        saveFavoriteIds(ids)
    }
    
    func saveFavoriteIds(_ ids: [String]) {
        storageService?.save(key: .favoriteIds, value: ids)
    }
    
}
