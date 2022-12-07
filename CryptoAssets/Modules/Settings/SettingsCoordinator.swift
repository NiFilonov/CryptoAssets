//
//  SettingsCoordinator.swift
//  CryptoAssets
//
//  Created by Globus Dev on 28.11.2022.
//

import Foundation
import UIKit

class SettingsCoordinator: Coordinatable {
    var childCoordinators = [Coordinatable]()
    var navigationController: UINavigationController
    
    var coordinatorFinished: (() -> Void)?
    
    private(set) var isStarted: Bool = false
    
    private let viewController: SettingsViewing & UIViewController
    private let presenter: SettingsPresenting
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        viewController = SettingsViewController()
        presenter = SettingsPresenter(view: viewController)
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
    
    private func showIconSelection() {
        let iconSelectionCoordinator = IconSelectionCoordinator(navigationController: navigationController)
        iconSelectionCoordinator.start()
    }
    
    
}

extension SettingsCoordinator: SettingsPresenterOutput {
    
    func showIconSelection(_ presenter: SettingsPresenting) {
        showIconSelection()
    }
    
}
