//
//  Asset.swift
//  CryptoAssets
//
//  Created by Globus Dev on 21.11.2022.
//

import Foundation

struct Asset {
    let id: String
    let rank, symbol, name: String
    let supply, maxSupply, marketCapUsd, volumeUsd24Hr: String
    let priceUsd, changePercent24Hr, vwap24Hr: String
    
    init(dto: AssetDTO) {
        id = dto.id
        rank = dto.rank ?? .empty
        symbol = dto.symbol ?? .empty
        name = dto.name ?? .empty
        supply = dto.supply ?? .zero
        maxSupply = dto.maxSupply ?? .zero
        marketCapUsd = dto.marketCapUsd ?? .zero
        volumeUsd24Hr = dto.volumeUsd24Hr ?? .zero
        priceUsd = (dto.priceUsd ?? .zero).currencyFormat
        changePercent24Hr = (dto.changePercent24Hr ?? .zero).percentFormat
        vwap24Hr = dto.vwap24Hr ?? .zero
    }
}

extension Asset: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
}
