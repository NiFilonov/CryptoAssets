//
//  String+Double.swift
//  CryptoAssets
//
//  Created by Globus Dev on 25.11.2022.
//

import Foundation

extension String {
    
    var currencyFormat: String {
        let doubleValue: Double = Double(CLongDouble(self) ?? .zero)
        let number = NSNumber(value: doubleValue)
        return NumberFormatter.currency.string(from: number) ?? .empty
    }
    
    var percentFormat: String {
        let doubleValue: Double = Double(CLongDouble(self) ?? .zero)
        let number = NSNumber(value: doubleValue / 100)
        return NumberFormatter.percent.string(from: number) ?? .empty
    }
    
}
