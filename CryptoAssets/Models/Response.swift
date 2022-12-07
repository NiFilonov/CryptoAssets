//
//  Response.swift
//  CryptoAssets
//
//  Created by Globus Dev on 21.11.2022.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    let data: T
    let timestamp: Double
}
