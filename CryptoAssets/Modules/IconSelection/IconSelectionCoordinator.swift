//
//  IconSelectionCoordinator.swift
//  CryptoAssets
//
//  Created by Globus Dev on 29.11.2022.
//

import Foundation
import UIKit

class IconSelectionCoordinator: Coordinatable {
    var childCoordinators = [Coordinatable]()
    var navigationController: UINavigationController
    
    var coordinatorFinished: (() -> Void)?
    
    private(set) var isStarted: Bool = false
    
    private let viewController: IconSelectionViewing & UIViewController
    private let presenter: IconSelectionPresenting
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        viewController = IconSelectionViewController()
        presenter = IconSelectionPresenter(view: viewController)
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
    
    
}

extension IconSelectionCoordinator: IconSelectionPresenterOutput {
    
    func showAssetDetails(_ presenter: IconSelectionPresenting, asset: Asset) {
        
    }
    
}
