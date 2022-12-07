//
//  AssetDetailInfoViewModel.swift
//  CryptoAssets
//
//  Created by Globus Dev on 28.11.2022.
//

import DifferenceKit

final class AssetDetailInfoViewModel {
    let id: String
    let name: String
    let value: String
    
    init(name: String, value: String) {
        self.id = UUID().uuidString
        self.name = name
        self.value = value
    }
    
}

extension AssetDetailInfoViewModel: Differentiable {
    func isContentEqual(to source: AssetDetailInfoViewModel) -> Bool {
        source.id == id &&
        source.name == name &&
        source.value == value
    }
    
    var differenceIdentifier: String {
        id
    }
}
