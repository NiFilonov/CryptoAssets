//
//  AssetsListCoordinatable.swift
//  CryptoAssets
//
//  Created by Globus Dev on 21.11.2022.
//

import Foundation
import UIKit

class AssetsListCoordinatable: Coordinatable {
    var childCoordinators = [Coordinatable]()
    var navigationController: UINavigationController
    
    var coordinatorFinished: (() -> Void)?
    
    private(set) var isStarted: Bool = false
    
    private let viewController: AssetsListViewing & UIViewController
    private let presenter: AssetsListPresenting
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        viewController = AssetsListViewController()
        presenter = AssetsListPresenter(view: viewController)
        presenter.output = self
    }
    
    func start() {
        navigationController.pushViewController(viewController, animated: true)
        isStarted = true
    }
    
    private func finishCoordinator() {
        popViewContriller()
        coordinatorFinished?()
    }
    
    private func popViewContriller() {
        navigationController.popViewController(animated: true)
    }
    
    private func showAssetDetail(asset: Asset) {
        let detailCoordinatable = AssetDetailCoordinatable(navigationController: navigationController,
                                                           asset: asset)
        detailCoordinatable.start()
    }
    
}

extension AssetsListCoordinatable: AssetsListPresenterOutput {
    
    func showAssetDetails(_ presenter: AssetsListPresenting, asset: Asset) {
        showAssetDetail(asset: asset)
    }
    
}
