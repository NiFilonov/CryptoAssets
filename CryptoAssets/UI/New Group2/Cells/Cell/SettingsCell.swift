//
//  SettingsCell.swift
//  CryptoAssets
//
//  Created by Globus Dev on 29.11.2022.
//

import UIKit

final class SettingsCell: TableViewCell<SettingsViewModel>  {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    override func update(with viewModel: SettingsViewModel) {
        nameLabel.text = viewModel.name
        valueLabel.text = viewModel.value
    }
    
}
