//
//  TabBarCoordinatable.swift
//  CryptoAssets
//
//  Created by Globus Dev on 22.11.2022.
//

import UIKit

protocol TabBarCoordinator {
    var assetsListCoordinator: AssetsListCoordinatable { get }
}

final class TabBarCoordinatable: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    
    var coordinatorFinished: (() -> Void)?
    
    var viewController: TabBarViewing & UIViewController
    
    private(set) var isStarted: Bool = false
    
    private var presenter: TabBarPresenting?
    
    private var tabsFabric: TabsCoordinatorsFabric
    
    init(navigationController: UINavigationController, tabsFabric: TabsCoordinatorsFabric) {
        self.tabsFabric = tabsFabric
        self.navigationController = navigationController
        viewController = TabBarViewController.makeWithStoryboard()
        presenter = TabBarPresenter(view: viewController)
        presenter?.output = self
    }
    
    func start() {
        navigationController.pushViewController(viewController, animated: false)
        childCoordinators = tabsFabric.makeTabs()
        
        presenter?.tabsItems = childCoordinators.enumerated().map({ TabItem(viewController: $0.element.navigationController, icon: TabItemsData.icons[$0.offset], title: TabItemsData.titles[$0.offset]) })
        childCoordinators.forEach({ $0.start() })
        isStarted = true
    }
    
}

extension TabBarCoordinatable: TabBarPresenterOutput {
    
    func selectedTabChangedIndex(to index: Int) {
        if !childCoordinators[index].isStarted {
            childCoordinators[index].start()
        }
    }
    
}
