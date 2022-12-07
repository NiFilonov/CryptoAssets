//
//  AssetDetailCoordinatable.swift
//  CryptoAssets
//
//  Created by Globus Dev on 22.11.2022.
//

import Foundation
import UIKit

class AssetDetailCoordinatable: Coordinatable {
    var childCoordinators = [Coordinatable]()
    var navigationController: UINavigationController
    
    var coordinatorFinished: (() -> Void)?
    
    private(set) var isStarted: Bool = false
    
    private let viewController: AssetDetailViewing & UIViewController
    private let presenter: AssetDetailPresenting
    
    init(navigationController: UINavigationController, asset: Asset) {
        self.navigationController = navigationController
        
        viewController = AssetDetailViewController()
        presenter = AssetDetailPresenter(view: viewController, asset: asset)
        commonInit()
    }
    
    func start() {
        navigationController.pushViewController(viewController, animated: true)
        isStarted = true
    }
    
    private func commonInit() {
    }
    
    private func finishCoordinator() {
        popViewContriller()
        coordinatorFinished?()
    }
    
    private func popViewContriller() {
        navigationController.popViewController(animated: true)
    }
    
}

extension AssetDetailCoordinatable: AssetDetailPresenterOutput {
    
    func close(_ presenter: AssetDetailViewing) {
        popViewContriller()
    }
    
}
