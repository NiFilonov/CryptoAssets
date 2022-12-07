//
//  AssetsListViewController.swift
//  CryptoAssets
//
//  Created by Globus Dev on 20.11.2022.
//

import Foundation
import UIKit
import SnapKit

protocol AssetsListViewing: AnyObject, ErrorViewingProtocol {
    var presenter: AssetsListPresenting? { get set }
    
    func update()
    func stopRefreshing()
}

final class AssetsListViewController: UIViewController, AssetsListViewing {
    
    // MARK: - Internal types
    
    enum Constant {
        static let sectionsCount: Int = 1
        static let minimumCountOfRows: Int = 1
        static let cellHeight: CGFloat = 80.0
    }
    
    // MARK: - Internal properties

    var presenter: AssetsListPresenting?

    // MARK: - Private properties
    
    private let refreshControl = UIRefreshControl()
    
    private var tableView: UITableView = {
        $0.register(cellType: AssetCell.self)
        $0.register(cellType: LoadMoreCell.self)
        $0.keyboardDismissMode = .onDrag
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
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Internal methods
    
    func update() {
        tableView.reloadData()
    }
    
    func stopRefreshing() {
        refreshControl.endRefreshing()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.view.snp.top)
        }
        
        self.view.backgroundColor = R.Assets.Colors.cellGrayBackground.color
        self.title = L10n.Assets.title
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAssets(_:)), for: .valueChanged)
    }
    
    private func setupSearch() {
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        search.searchBar.delegate = self
        search.hidesNavigationBarDuringPresentation = true
        self.navigationItem.searchController = search
    }
    
    @objc
    private func refreshAssets(_ sender: Any) {
        print("start refresh")
        refreshControl.beginRefreshing()
        presenter?.refreshAssets()
    }
}

extension AssetsListViewController: UISearchControllerDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.presenter?.searchingCanceled()
    }
}

extension AssetsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchAssets(by: searchText)
    }
}
