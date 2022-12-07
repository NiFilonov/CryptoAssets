//
//  NetworkService.swift
//  CryptoAssets
//
//  Created by Globus Dev on 20.11.2022.
//

import Foundation

final class NetworkService {
    
    private struct HTTPHeader {
        let name: String
        let value: String
    }
    
    private enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    private enum Constants {
        static let retryLimit = UInt(4)
        static let retryDelay = TimeInterval(1)
        static let timeout = TimeInterval(45)
        static let httpMaximumConnectionsPerHost = 3
        static let authHeader = HTTPHeader(name: "Authorization", value: "Bearer c0e31b5a-6b12-4dde-a6ac-a30827ce5066")
        static let acceptEncodingHeader = HTTPHeader(name: "Accept-Encoding", value: "gzip, deflate")
    }
    
    struct UnknownError: Error {
        var description = "Unknown error"
    }
    
    struct SerializationError: Error {
        var description = "Serialization error"
    }
    
    func get<T: Decodable>(endpoint: Endpoint,
                           completion: @escaping ((Result<T, Error>) -> Void) ) {
        guard let url = endpoint.url,
              let urlRequest = makeUrlRequest(url: url, method: .get) else {
            completion(.failure(UnknownError()))
            return
        }
        request(urlRequest: urlRequest, completion: completion)
    }
    
    func get<T: Decodable>(url: URL,
                           completion: @escaping ((Result<T, Error>) -> Void) ) {
        guard let urlRequest = makeUrlRequest(url: url, method: .get) else {
            completion(.failure(UnknownError()))
            return
        }
        request(urlRequest: urlRequest, completion: completion)
    }
    
    func post<T: Decodable>(endpoint: Endpoint,
                           completion: @escaping ((Result<T, Error>) -> Void) ) {
        guard let url = endpoint.url,
              let urlRequest = makeUrlRequest(url: url, method: .post) else {
            completion(.failure(UnknownError()))
            return
        }
        request(urlRequest: urlRequest, completion: completion)
    }
    
    func post<T: Decodable>(url: URL,
                           completion: @escaping ((Result<T, Error>) -> Void) ) {
        guard let urlRequest = makeUrlRequest(url: url, method: .post) else {
            completion(.failure(UnknownError()))
            return
        }
        request(urlRequest: urlRequest, completion: completion)
    }
    
    private func makeUrlRequest(url: URL, method: HTTPMethod) -> URLRequest? {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
    
    private func request<T: Decodable>(urlRequest: URLRequest,
                                   completion: @escaping ((Result<T, Error>) -> Void) ) {
        var request = urlRequest
        request.setValue(Constants.authHeader.value,
                         forHTTPHeaderField: Constants.authHeader.name)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            if let data = data {
                print(String(data: data, encoding: .utf8))
            }
            if let decodedResponse = JsonDecoder.decode(data, to: T.self) {
                completion(.success(decodedResponse))
            } else {
                completion(.failure(SerializationError()))
            }
        }
        task.resume()
    }
    
}
