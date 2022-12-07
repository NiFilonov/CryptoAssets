//
//  AssetCellViewModel.swift
//  CryptoAssets
//
//  Created by Globus Dev on 21.11.2022.
//

import DifferenceKit

final class AssetCellViewModel {
    let id: String
    let name: String
    let symbol: String
    let price: String
    let change24: String
    let change24Color: ColorAsset
    
    init(asset: Asset) {
        id = asset.id
        name = asset.name
        symbol = asset.symbol
        price = asset.priceUsd
        change24 = asset.changePercent24Hr
        change24Color = change24.first == "-" ? R.Assets.Colors.textRed : R.Assets.Colors.textGreen
    }
    
}

extension AssetCellViewModel: Differentiable {
    func isContentEqual(to source: AssetCellViewModel) -> Bool {
        source.id == id &&
        source.name == name
    }
    
    var differenceIdentifier: String {
        id
    }
}
