//
//  NetworkManager.swift
//  CryptoAssets
//
//  Created by Globus Dev on 20.11.2022.
//

import Foundation
import UIKit

protocol NetworkManaging: AnyObject {
    func fetchAssets(limit: Int?, offset: Int?, _ completion: @escaping NetworkManager.AssetsResult)
    func fetchAssets(ids: [String]?, limit: Int?, offset: Int?, _ completion: @escaping NetworkManager.AssetsResult)
    func fetchSearchAssets(ids: [String]?, limit: Int?, offset: Int?, searchText: String?, _ completion: @escaping NetworkManager.AssetsResult)
    func fetchChart(currency: String, interval: String, _ completion: @escaping NetworkManager.ChartResult)
    func fetchIcon(symbol: String, _ completion: @escaping NetworkManager.IconResult)
}

final class NetworkManager: NetworkManaging {
    
    // MARK: - Internal types
    
    typealias AssetsResult = (Result<[Asset], Error>) -> Void
    typealias AssetsDTOResult = (Result<Response<[AssetDTO]>, Error>) -> Void
    typealias ChartResult = (Result<[ChartPoint], Error>) -> Void
    typealias ChartDTOResult = (Result<Response<[ChartPointDTO]>, Error>) -> Void
    typealias IconResult = (Result<UIImage?, Error>) -> Void
    typealias IconDTOResult = (Result<Response<Data>, Error>) -> Void
    
    // MARK: - Private properties
    
    private let network: NetworkService? = ServicesAssembly.container.resolve(NetworkService.self)
    
    func fetchAssets(limit: Int?, offset: Int?, _ completion: @escaping AssetsResult) {
        network?.get(endpoint: CryptoEndpoint.assets(ids: [], limit: limit, offset: offset, searchText: nil), completion: { result in
            switch result {
            case .success(let response):
                let assets = response.data.map({ Asset(dto: $0) })
                completion(.success(assets))
            case .failure(let error):
                completion(.failure(error))
            }
        } as AssetsDTOResult)
    }
    
    func fetchAssets(ids: [String]?, limit: Int?, offset: Int?, _ completion: @escaping AssetsResult) {
        network?.get(endpoint: CryptoEndpoint.assets(ids: ids, limit: limit, offset: offset, searchText: nil), completion: { result in
            switch result {
            case .success(let response):
                let assets = response.data.map({ Asset(dto: $0) })
                completion(.success(assets))
            case .failure(let error):
                completion(.failure(error))
            }
        } as AssetsDTOResult)
    }
    
    func fetchSearchAssets(ids: [String]?, limit: Int?, offset: Int?, searchText: String?, _ completion: @escaping AssetsResult) {
        network?.get(endpoint: CryptoEndpoint.assets(ids: ids, limit: limit, offset: offset, searchText: searchText), completion: { result in
            switch result {
            case .success(let response):
                let assets = response.data.map({ Asset(dto: $0) })
                completion(.success(assets))
            case .failure(let error):
                completion(.failure(error))
            }
        } as AssetsDTOResult)
    }
    
    func fetchChart(currency: String, interval: String, _ completion: @escaping ChartResult) {
        network?.get(endpoint: CryptoEndpoint.history(currency: currency,
                                        interval: interval), completion: { result in
            switch result {
            case .success(let response):
                let assets = response.data.map({ ChartPoint(dto: $0) })
                completion(.success(assets))
            case .failure(let error):
                completion(.failure(error))
            }
        } as ChartDTOResult)
    }
    
    func fetchIcon(symbol: String, _ completion: @escaping IconResult) {
        network?.get(endpoint: IconsEndpoint.icon(symbol: symbol), completion: { result in
            switch result {
            case .success(let response):
                let imageData = response.data
                completion(.success(UIImage(data: imageData)))
            case .failure(let error):
                completion(.failure(error))
            }
        } as IconDTOResult)
    }
    
}
