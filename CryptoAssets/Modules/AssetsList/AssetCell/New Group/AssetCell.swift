//
//  AssetCell.swift
//  CryptoAssets
//
//  Created by Globus Dev on 21.11.2022.
//

import UIKit

final class AssetCell: TableViewCell<AssetCellViewModel> {
    
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var symbolLabel: UILabel!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var priceLabel: UILabel!
    @IBOutlet weak private var changeLabel: UILabel!
    
    override func update(with viewModel: AssetCellViewModel) {
        symbolLabel.text = viewModel.symbol
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        changeLabel.text = viewModel.change24
        changeLabel.textColor = viewModel.change24Color.color
        iconImageView.setIcon(symbol: viewModel.symbol)
    }
    
    override func prepareForReuse() {
        iconImageView.cancelLoadingIcon(for: viewModel?.symbol ?? .empty)
        iconImageView.image = nil
        nameLabel.text = nil
        symbolLabel.text = nil
        priceLabel.text = nil
        changeLabel.text = nil
    }
    
}
