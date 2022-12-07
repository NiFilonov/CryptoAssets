//
//  StorageService.swift
//  CryptoAssets
//
//  Created by Globus Dev on 24.11.2022.
//

import Foundation

final class StorageService {
    
    enum Key: String {
        case favoriteIds = "FAVORITE_ID_KEY"
    }
    
    private let defaults = UserDefaults.standard
    
    func save<T>(key: Key, value: T) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    func fetch<T>(key: Key) -> T? {
        defaults.object(forKey: key.rawValue) as? T
    }
    
}
