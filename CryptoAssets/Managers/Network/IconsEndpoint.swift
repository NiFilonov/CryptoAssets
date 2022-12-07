//
//  IconsEndpoint.swift
//  CryptoAssets
//
//  Created by Globus Dev on 25.11.2022.
//

import Foundation

enum IconsEndpoint: Endpoint {
        
        private var urlComponents: URLComponents? {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "coinicons-api.vercel.app"
            return components
        }
        
        case icon(symbol: String)
        
        var url: URL? {
            switch self {
            case .icon(let symbol):
                if var urlComponents = urlComponents {
                    urlComponents.path = "/api/icon/" + symbol
                    return urlComponents.url
                }
            return nil
        }
    }

    
}
