//
//  NumberFormatter+Extension.swift
//  CryptoAssets
//
//  Created by Globus Dev on 25.11.2022.
//

import Foundation

extension NumberFormatter {
    
    static var currency: NumberFormatter {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.roundingMode = .up
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en_GB")
        numberFormatter.currencySymbol = .usdSign
        return numberFormatter
    }
    
    static var percent: NumberFormatter {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.roundingMode = .up
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.numberStyle = .percent
        numberFormatter.locale = Locale(identifier: "en_GB")
        return numberFormatter
    }
    
}
