//
//  IconSelectionViewController.swift
//  CryptoAssets
//
//  Created by Globus Dev on 29.11.2022.
//

import UIKit

import Foundation
import UIKit
import SnapKit

protocol IconSelectionViewing: AnyObject, ErrorViewingProtocol {
    var presenter: IconSelectionPresenting? { get set }
    
    func update()
}

final class IconSelectionViewController: UIViewController, IconSelectionViewing {
    // MARK: - Internal types
    
    enum Constant {
        static let sectionsCount: Int = 1
        static let cellHeight: CGFloat = 44.0
    }
    
    // MARK: - Internal properties

    var presenter: IconSelectionPresenting?

    // MARK: - Private properties
    
    private var tableView: UITableView = {
        $0.register(cellType: SettingsCell.self)
        $0.estimatedRowHeight = 200.0
        $0.rowHeight = UITableView.automaticDimension
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
        view.backgroundColor = .white
        title = L10n.Watchlist.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.prefersLargeTitles = false
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
