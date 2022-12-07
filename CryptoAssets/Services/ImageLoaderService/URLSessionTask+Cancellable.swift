//
//  URLSessionTask+Cancellable.swift
//  CryptoAssets
//
//  Created by Globus Dev on 01.12.2022.
//

import Foundation

protocol Cancellable {

    // MARK: - Methods

    func cancel()

}

extension URLSessionTask: Cancellable {

}
