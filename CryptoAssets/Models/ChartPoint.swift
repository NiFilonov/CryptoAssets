//
//  ChartPoint.swift
//  CryptoAssets
//
//  Created by Globus Dev on 22.11.2022.
//

import Foundation

struct ChartPoint: Codable {
    let price: Double
    let time: Double
    
    init(dto: ChartPointDTO) {
        price = Double(dto.priceUsd ?? .zero) ?? .zero
        time = dto.time ?? .zero
    }
}

extension ChartPoint: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.price == lhs.price &&
        rhs.time == rhs.time
    }
    
}
