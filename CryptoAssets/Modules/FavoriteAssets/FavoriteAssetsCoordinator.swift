//
//  FavoriteAssetsCoordinator.swift
//  CryptoAssets
//
//  Created by Globus Dev on 24.11.2022.
//

import Foundation
import UIKit

class FavoriteAssetsCoordinatable: Coordinatable {
    var childCoordinators = [Coordinatable]()
    var navigationController: UINavigationController
    
    var coordinatorFinished: (() -> Void)?
    
    private(set) var isStarted: Bool = false
    
    private let viewController: FavoriteAssetsViewing & UIViewController
    private let presenter: FavoriteAssetsPresenting
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        viewController = FavoriteAssetsViewController()
        presenter = FavoriteAssetsPresenter(view: viewController)
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

extension FavoriteAssetsCoordinatable: FavoriteAssetsPresenterOutput {
    
    func showAssetDetails(_ presenter: FavoriteAssetsPresenting, asset: Asset) {
        showAssetDetail(asset: asset)
    }
    
}
