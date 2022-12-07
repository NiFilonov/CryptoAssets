//
//  SettingsViewController+UITableView.swift
//  CryptoAssets
//
//  Created by Globus Dev on 28.11.2022.
//

import UIKit

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in _: UITableView) -> Int {
        Constant.sectionsCount
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        presenter?.items.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let viewModel = presenter?.items[indexPath.row].base as? SettingsViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as SettingsCell
            cell.viewModel = viewModel
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SettingsCell,
           let viewModel = cell.viewModel {
            presenter?.handleItemSelection(viewModel: viewModel)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constant.cellHeight
    }
}
