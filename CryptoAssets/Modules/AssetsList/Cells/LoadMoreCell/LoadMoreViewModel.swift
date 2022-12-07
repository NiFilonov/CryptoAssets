//
//  LoadMoreViewModel.swift
//  CryptoAssets
//
//  Created by Globus Dev on 26.11.2022.
//

import DifferenceKit

final class LoadMoreViewModel {
    let id = UUID().uuidString
}

extension LoadMoreViewModel: Differentiable {
    func isContentEqual(to source: LoadMoreViewModel) -> Bool {
        source.id == id
    }
    
    var differenceIdentifier: String {
        id
    }
}
