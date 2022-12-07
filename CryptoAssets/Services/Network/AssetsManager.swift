//
//  AssetsManager.swift
//  CryptoAssets
//
//  Created by Globus Dev on 22.11.2022.
//

import Foundation

extension Notification.Name {
    static let assetsFetched = Notification.Name(rawValue: "assetsFetched")
    static let allAssetsFetched = Notification.Name(rawValue: "allAssetsFetched")
    static let assetsFetchingFailed = Notification.Name(rawValue: "assetsFetchingFailed")
}

final class AssetsManager {
    
    private enum Constants {
        static let assetsLimit: Int = 10
    }
    
    private var network: NetworkManaging? = ManagersAssembly.container.resolve(NetworkManager.self)
    
    private var assetOffset: Int {
        return assets.count
    }
    
    var assets: [Asset] = []
    
    func fetchAssets(isRefresh: Bool = false) {
        if isRefresh {
            assets = []
        }
        network?.fetchAssets(limit: Constants.assetsLimit,
                             offset: assetOffset, { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let assets):
                self.assets.append(contentsOf: assets)
                if !assets.isEmpty {
                    NotificationCenter.default.post(name: .assetsFetched, object: nil)
                } else {
                    NotificationCenter.default.post(name: .allAssetsFetched, object: nil)
                }
            case .failure:
                NotificationCenter.default.post(name: .assetsFetchingFailed, object: nil)
            }
        })
    }
    
}
