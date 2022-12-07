//
//  AssetDTO.swift
//  CryptoAssets
//
//  Created by Globus Dev on 21.11.2022.
//

import Foundation

struct AssetDTO: Codable {
    let id: String
    let rank, symbol, name: String?
    let supply, maxSupply, marketCapUsd, volumeUsd24Hr: String?
    let priceUsd, changePercent24Hr, vwap24Hr: String?
}
