//
//  FavoriteAssetsViewController+UITableView.swift
//  CryptoAssets
//
//  Created by Globus Dev on 24.11.2022.
//

import UIKit

extension FavoriteAssetsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in _: UITableView) -> Int {
        Constant.sectionsCount
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        presenter?.items.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let viewModel = presenter?.items[indexPath.row].base as? AssetCellViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as AssetCell
            cell.viewModel = viewModel
            cell.accessoryType = .disclosureIndicator
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: L10n.Watchlist.remove) { [weak self] (action, view, completionHandler) in
            self?.presenter?.handleRemoveFromFavoriteAction(at: indexPath.row)
            completionHandler(true)
        }
        action.backgroundColor = R.Assets.Colors.cellRemoveAction.color
        return UISwipeActionsConfiguration(actions: [action])
    }
}
