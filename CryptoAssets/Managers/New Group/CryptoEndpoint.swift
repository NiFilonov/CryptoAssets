//
//  ApiEndpoint.swift
//  CryptoAssets
//
//  Created by Globus Dev on 20.11.2022.
//

import Foundation

enum CryptoEndpoint: Endpoint {
    
    private var urlComponents: URLComponents? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coincap.io"
        return components
    }
    
    private var apiVersion: String {
        return "/v2"
    }
    
    case assets(ids: [String]?, limit: Int?, offset: Int?, searchText: String?)
    case history(currency: String, interval: String)
    
    var url: URL? {
        switch self {
        case .assets(let ids, let limit, let offset, let searchText):
            if var urlComponents = urlComponents {
                urlComponents.path = apiVersion + "/assets"
                var queryItems: [URLQueryItem] = []
                if let ids = ids, !ids.isEmpty {
                    queryItems.append(URLQueryItem(name: "ids", value: ids.joined(separator: ",")))
                }
                if let limit = limit {
                    queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
                }
                if let offset = offset {
                    queryItems.append(URLQueryItem(name: "offset", value: String(offset)))
                }
                if let searchText = searchText {
                    queryItems.append(URLQueryItem(name: "search", value: String(searchText)))
                }
                urlComponents.queryItems = queryItems
                return urlComponents.url
            }
        case .history(let currency, let interval):
            if var urlComponents = urlComponents {
                urlComponents.path = apiVersion + "/assets/\(currency)/history"
                urlComponents.queryItems = [URLQueryItem(name: "interval", value: interval)]
                return urlComponents.url
            }
        }
        return nil
    }
}
