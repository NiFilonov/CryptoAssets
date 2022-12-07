//
//  NavigationController.swift
//  CryptoAssets
//
//  Created by Globus Dev on 07.12.2022.
//

import UIKit

final class NavigationController: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = R.Assets.Colors.cellGrayBackground.color
            
    }
    
}
