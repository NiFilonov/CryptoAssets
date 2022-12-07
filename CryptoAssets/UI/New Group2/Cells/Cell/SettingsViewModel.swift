//
//  SettingsViewModel.swift
//  CryptoAssets
//
//  Created by Globus Dev on 29.11.2022.
//

import DifferenceKit

final class SettingsViewModel {
    let id: String
    let name: String
    let value: String
    let selected: Bool?
    
    init(id: String = UUID().uuidString, name: String, value: String, selected: Bool? = nil) {
        self.id = id
        self.name = name
        self.value = value
        self.selected = selected
    }
    
}

extension SettingsViewModel: Differentiable {
    func isContentEqual(to source: SettingsViewModel) -> Bool {
        source.id == id &&
        source.name == name &&
        source.value == value &&
        source.selected == selected
    }
    
    var differenceIdentifier: String {
        id
    }
}
