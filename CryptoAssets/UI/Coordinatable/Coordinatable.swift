//
//  Coordinatable.swift
//  CryptoAssets
//
//  Created by Globus Dev on 21.11.2022.
//

import UIKit

public protocol Coordinatable : AnyObject {
    var childCoordinators: [Coordinatable] { get set }
    var navigationController: UINavigationController { get set }
    var coordinatorFinished: (() -> Void)? { get set }
    var isStarted: Bool { get }
    
    func start()
}

public extension Coordinatable {
    
    func addDependency(_ coordinator: Coordinatable) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinatable?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
