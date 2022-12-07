//
//  IconsManager.swift
//  CryptoAssets
//
//  Created by Globus Dev on 29.11.2022.
//

import Foundation
import UIKit

enum AppIcon: String, CaseIterable {
    case white = "AppIcon-1"
    case black = "AppIcon-2"
    case yellow = "AppIcon-3"
    
    var name: String {
        switch self {
        case .white:
            return L10n.IconSelection.white
        case .black:
            return L10n.IconSelection.black
        case .yellow:
            return L10n.IconSelection.yellow
        }
    }
}

final class IconsManager {
    
    private let primaryIcon: AppIcon = .white
    
    var currentIcon: AppIcon {
        AppIcon(rawValue: UIApplication.shared.alternateIconName ?? primaryIcon.rawValue) ?? .white
    }
    
    var icons: [AppIcon] {
        AppIcon.allCases
    }
    
    func set(icon: AppIcon) {
        if icon != primaryIcon {
            UIApplication.shared.setAlternateIconName(icon.rawValue)
        } else {
            UIApplication.shared.setAlternateIconName(nil)
        }
    }
    
}
