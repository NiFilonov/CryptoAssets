//
//  TabBarPresenter.swift
//  CryptoAssets
//
//  Created by Globus Dev on 24.11.2022.
//

import Foundation
import UIKit

protocol TabBarPresenterOutput {
    func selectedTabChangedIndex(to index: Int)
}

protocol TabBarPresenting: AnyObject {
    var tabsItems: [TabItem] { get set }
    var output: TabBarPresenterOutput? { get set }
    
    func selectedIndexChanged(to index: Int)
}

final class TabBarPresenter: TabBarPresenting {
    
    var output: TabBarPresenterOutput?
    var view: TabBarViewing?
    
    var tabsItems: [TabItem] = [] {
        didSet {
            view?.set(items: tabsItems)
        }
    }
    
    init(view: TabBarViewing) {
        self.view = view
        self.view?.presenter = self
    }
    
    func selectedIndexChanged(to index: Int) {
        output?.selectedTabChangedIndex(to: index)
    }
    
}
