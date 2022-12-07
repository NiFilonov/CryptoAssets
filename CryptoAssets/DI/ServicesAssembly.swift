//
//  ServicesAssembly.swift
//  CryptoAssets
//
//  Created by Globus Dev on 20.11.2022.
//

import Swinject

enum ServicesAssembly {
    
    public static let container: Container = {
        let container: Container = Container()
        
        container.register(NetworkService.self) { _ in
            NetworkService()
        }
        
        container.register(StorageService.self) { _ in
            StorageService()
        }
        
        return container
    }()
    
}
