//
//  SettingsViewController.swift
//  CryptoAssets
//
//  Created by Globus Dev on 28.11.2022.
//

import UIKit

import Foundation
import UIKit
import SnapKit

protocol SettingsViewing: AnyObject, ErrorViewingProtocol {
    var presenter: SettingsPresenting? { get set }
    
    func update()
}

final class SettingsViewController: UIViewController, SettingsViewing {
    // MARK: - Internal types
    
    enum Constant {
        static let sectionsCount: Int = 1
        static let cellHeight: CGFloat = 44.0
        static let estimatedRowHeight: CGFloat = 200.0
    }
    
    // MARK: - Internal properties

    var presenter: SettingsPresenting?

    // MARK: - Private properties
    
    private var tableView: UITableView = {
        $0.register(cellType: SettingsCell.self)
        $0.estimatedRowHeight = Constant.estimatedRowHeight
        $0.rowHeight = UITableView.automaticDimension
        $0.tableFooterView = FooterView(frame: CGRect.zero)
        $0.backgroundColor = R.Assets.Colors.cellGrayBackground.color
        return $0
    }(UITableView())
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewLoaded()
    }
    
    // MARK: - Internal methods
    
    func update() {
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        navigationController?.navigationBar.barTintColor = R.Assets.Colors.cellGrayBackground.color
        
        view.backgroundColor = .white
        title = L10n.Settings.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
