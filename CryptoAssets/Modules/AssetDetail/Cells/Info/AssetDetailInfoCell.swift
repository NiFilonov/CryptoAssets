//
//  AssetDetailInfoCell.swift
//  CryptoAssets
//
//  Created by Globus Dev on 28.11.2022.
//

import UIKit

final class AssetDetailInfoCell: TableViewCell<AssetDetailInfoViewModel>  {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    override func update(with viewModel: AssetDetailInfoViewModel) {
        nameLabel.text = viewModel.name
        valueLabel.text = viewModel.value
    }
    
}
