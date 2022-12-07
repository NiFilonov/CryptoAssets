//
//  AssetDetailViewController+UITableView.swift
//  CryptoAssets
//
//  Created by Globus Dev on 22.11.2022.
//

import UIKit

extension AssetDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in _: UITableView) -> Int {
        1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        presenter?.items.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let viewModel = presenter?.items[indexPath.row].base as? AssetDetailChartViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as AssetDetailChartCell
            cell.viewModel = viewModel
            cell.selectionStyle = .none
            return cell
        } else if let viewModel = presenter?.items[indexPath.row].base as? AssetDetailInfoViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as AssetDetailInfoCell
            cell.viewModel = viewModel
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = presenter?.items[indexPath.row].base
        
        if viewModel is AssetDetailChartViewModel {
            return 350.0
        } else {
            return UITableView.automaticDimension
        }
    }
    
}
