//
//  TabsCoordinatorsFabric.swift
//  CryptoAssets
//
//  Created by Globus Dev on 24.11.2022.
//

import UIKit

final class TabsCoordinatorsFabric {
    
    func makeTabs() -> [Coordinatable] {
        [AssetsListCoordinatable(navigationController: NavigationController()),
        FavoriteAssetsCoordinatable(navigationController: NavigationController()),
        SettingsCoordinator(navigationController: NavigationController())]
    }
    
}
