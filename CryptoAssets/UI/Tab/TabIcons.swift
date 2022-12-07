//
//  TabIcons.swift
//  CryptoAssets
//
//  Created by Globus Dev on 28.11.2022.
//

import UIKit

final class TabItemsData {
    
    static var icons: [ImageAsset] {
        return [
            R.Assets.Image.TabBar.asset,
            R.Assets.Image.TabBar.favorite,
            R.Assets.Image.TabBar.settings
        ]
    }
    
    static var titles: [String] {
        return [
            L10n.TabBar.asset,
            L10n.TabBar.favorite,
            L10n.TabBar.settings
        ]
    }
    
}
