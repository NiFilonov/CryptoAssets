//
//  FavoriteAssetsViewController.swift
//  CryptoAssets
//
//  Created by Globus Dev on 24.11.2022.
//

import UIKit

import Foundation
import UIKit
import SnapKit

protocol FavoriteAssetsViewing: AnyObject, ErrorViewingProtocol {
    var presenter: FavoriteAssetsPresenting? { get set }
    
    func update()
}

final class FavoriteAssetsViewController: UIViewController, FavoriteAssetsViewing {
    
    // MARK: - Internal types
    
    enum Constant {
        static let sectionsCount: Int = 1
        static let minimumCountOfRows: Int = 1
        static let cellHeight: CGFloat = 80.0
    }
    
    // MARK: - Internal properties

    var presenter: FavoriteAssetsPresenting?

    // MARK: - Private properties
    
    private var tableView: UITableView = {
        $0.register(cellType: AssetCell.self)
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
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        view.backgroundColor = R.Assets.Colors.cellGrayBackground.color
        title = L10n.Watchlist.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
