//
//  Decoder.swift
//  CryptoAssets
//
//  Created by Globus Dev on 22.11.2022.
//

import Foundation

enum JsonDecoder {
    
    private static let decoder = JSONDecoder()
    
    static func decode<T: Decodable>(_ data: Data?, to type: T.Type) -> T? {
        if let data = data {
            do {
                return try decoder.decode(type, from: data)
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        return nil
    }
    
}
