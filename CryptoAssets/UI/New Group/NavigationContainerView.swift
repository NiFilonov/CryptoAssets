//
//  NavigationContainerView.swift
//  CryptoAssets
//
//  Created by Globus Dev on 24.11.2022.
//

import UIKit

final class NavigationContainerView: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarHidden(true, animated: false)
    }
    
}
