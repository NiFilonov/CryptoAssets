//
//  AssetsListViewController.swift
//  CryptoAssets
//
//  Created by Globus Dev on 21.11.2022.
//

import UIKit

extension AssetsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in _: UITableView) -> Int {
        Constant.sectionsCount
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.items.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let viewModel = presenter?.items[indexPath.row].base as? AssetCellViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as AssetCell
            cell.viewModel = viewModel
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        if let viewModel = presenter?.items[indexPath.row].base as? LoadMoreViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as LoadMoreCell
            cell.viewModel = viewModel
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AssetCell,
           let viewModel = cell.viewModel {
            presenter?.assetSelected(viewModel: viewModel)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constant.cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (presenter?.items.count ?? .zero) - 3 {
            presenter?.loadMoreAssets()
        }
    }
}
