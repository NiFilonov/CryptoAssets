//
//  LoadMoreCell.swift
//  CryptoAssets
//
//  Created by Globus Dev on 26.11.2022.
//

import UIKit

class LoadMoreCell: TableViewCell<LoadMoreViewModel> {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func update(with viewModel: LoadMoreViewModel) {
        activityIndicator.startAnimating()
    }
    
}
