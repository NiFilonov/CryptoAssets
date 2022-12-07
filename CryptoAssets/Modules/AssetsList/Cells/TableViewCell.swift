//
//  TableViewCell.swift
//  CryptoAssets
//
//  Created by Globus Dev on 21.11.2022.
//

import Reusable
import UIKit

open class TableViewCell<ViewModel>: UITableViewCell, NibReusable {
    public var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }

            update(with: viewModel)
        }
    }

    open func update(with viewModel: ViewModel) {}
}

open class TableViewCellReusable<ViewModel>: UITableViewCell, Reusable {
    public var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }

            update(with: viewModel)
        }
    }

    open func update(with viewModel: ViewModel) {}
}
