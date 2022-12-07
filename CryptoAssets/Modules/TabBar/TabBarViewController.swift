//
//  TabBarViewController.swift
//  CryptoAssets
//
//  Created by Globus Dev on 22.11.2022.
//

import UIKit

protocol TabBarViewing: AnyObject {
    var presenter: TabBarPresenting? { get set }
    
    func set(items: [TabItem])
}

final class TabBarViewController: UITabBarController, TabBarViewing {
    
    var presenter: TabBarPresenting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func set(items: [TabItem]) {
        let viewControllers = items.map({ $0.viewController })
        setViewControllers(viewControllers, animated: false)
        tabBar.items?.enumerated().forEach({ (index, item) in
            item.image = items[index].icon.image
            item.title = items[index].title
        })
        
    }
    
    private func setupUI() {
        UITabBar.appearance().barTintColor = R.Assets.Colors.cellGrayBackground.color
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        presenter?.selectedIndexChanged(to: selectedIndex)
    }
    
}
