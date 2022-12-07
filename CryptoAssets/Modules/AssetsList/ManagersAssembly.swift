//
//  ManagersAssembly.swift
//  CryptoAssets
//
//  Created by Globus Dev on 20.11.2022.
//

import Swinject

enum ManagersAssembly {
    
    public static let container: Container = {
        let container: Container = Container()
        
        container.register(NetworkManager.self) { _ in
            NetworkManager()
        }
        
        container.register(AssetsManager.self) { _ in
            AssetsManager()
        }
        
        container.register(StorageManager.self) { _ in
            StorageManager()
        }
        
        container.register(ChartsManager.self) { _ in
            ChartsManager()
        }
        
        container.register(FavoriteAssetsManager.self) { _ in
            FavoriteAssetsManager()
        }
        
        container.register(SearchAssetsManager.self) { _ in
            SearchAssetsManager()
        }
        
        container.register(IconsManager.self) { _ in
            IconsManager()
        }
        
        return container
    }()
    
}
