//
//  UIViewController+Storyboard.swift
//  CryptoAssets
//
//  Created by Nikita Filonov on 20.11.2022.
//

import UIKit

public protocol StoryboardInitilaizable {
    
    static func makeWithStoryboard() -> Self
}

extension StoryboardInitilaizable where Self: UIViewController {
    
    public static func makeWithStoryboard() -> Self {
        return UIStoryboard(name: String(describing: self),
                            bundle: nil)
            .instantiate(self)
    }
}

extension UIStoryboard {
    
    public func instantiate<ViewController: UIViewController>(_ viewController: ViewController.Type) -> ViewController {
        guard let viewController = self.instantiateInitialViewController() as? ViewController else {
            fatalError("Fatal error - \(type(of: ViewController.self))")
        }
        
        return viewController
    }
}

extension UIViewController: StoryboardInitilaizable { }
