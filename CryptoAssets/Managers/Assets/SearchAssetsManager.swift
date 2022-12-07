//
//  SearchAssetsManager.swift
//  CryptoAssets
//
//  Created by Globus Dev on 26.11.2022.
//

import Foundation

final class SearchAssetsManager {
    
    private enum Constants {
        static let assetsLimit: Int = 10
    }
    
    private var network: NetworkManaging? = ManagersAssembly.container.resolve(NetworkManager.self)
    
    private var assetOffset: Int {
        return assets.count
    }
    
    private var text: String = .empty
    
    var assets: [Asset] = []
    
    func fetchAssets(isRefresh: Bool = false, searchText: String? = nil) {
        if isRefresh {
            assets = []
        }
        if let searchText = searchText {
            if text != searchText {
                text = searchText
                assets = []
            }
        }
        network?.fetchSearchAssets(ids: nil,
                             limit: Constants.assetsLimit,
                             offset: assetOffset,
                             searchText: text, { [weak self] result in
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
    
    func clear() {
        assets = []
        text = .empty
    }
    
}
