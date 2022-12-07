//
//  AssetDetailViewController.swift
//  CryptoAssets
//
//  Created by Globus Dev on 22.11.2022.
//

import Foundation
import UIKit
import SnapKit

protocol AssetDetailViewing: AnyObject, ErrorViewingProtocol {
    var presenter: AssetDetailPresenting? { get set }
    
    func update()
    func updateTitle(_ title: NSAttributedString)
    func updateFavoriteButton(_ isFavorite: Bool)
}

final class AssetDetailViewController: UIViewController, AssetDetailViewing {
    
    // MARK: - Internal properties

    var presenter: AssetDetailPresenting?

    // MARK: - Private properties
    
    private var tableView: UITableView = {
        $0.register(cellType: AssetDetailChartCell.self)
        $0.register(cellType: AssetDetailInfoCell.self)
        $0.estimatedRowHeight = 200.0
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewLoaded()
    }
    
    // MARK: - Internal methods
    
    func update() {
        tableView.reloadData()
    }
    
    @objc
    func favoriteButtonTapped() {
        presenter?.updateFavoriteForCurrentAsset()
    }
    
    func updateTitle(_ title: NSAttributedString) {
        let navigationLabel = UILabel()
        navigationLabel.attributedText = title
        self.navigationItem.titleView = navigationLabel
    }
    
    func updateFavoriteButton(_ isFavorite: Bool) {
        navigationItem.rightBarButtonItem?.image = isFavorite ? R.Assets.Image.heartFilled.image : R.Assets.Image.heart.image
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: nil, style: .done, target: self, action: #selector(favoriteButtonTapped))
        navigationController?.navigationBar.prefersLargeTitles = false
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
