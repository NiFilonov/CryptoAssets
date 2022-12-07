//
//  SettingsPresenter.swift
//  CryptoAssets
//
//  Created by Globus Dev on 28.11.2022.
//

import DifferenceKit

protocol SettingsPresenterOutput: AnyObject {
    func showIconSelection(_ presenter: SettingsPresenting)
}

protocol SettingsPresenting: AnyObject {
    var output: SettingsPresenterOutput? { get set }
    var items: [AnyDifferentiable] { get }
    
    func viewLoaded()
    func handleItemSelection(viewModel: SettingsViewModel)
}

final class SettingsPresenter: SettingsPresenting {
    
    // MARK: - Internal properties
    
    var output: SettingsPresenterOutput?
    
    var items: [AnyDifferentiable] = []
    
    // MARK: - Private properties
    
    private weak var view: SettingsViewing?
    
    private let iconsManager: IconsManager? = ManagersAssembly.container.resolve(IconsManager.self)
    
    // MARK: - Init
    
    init(view: SettingsViewing) {
        self.view = view
        self.view?.presenter = self
    }
    
    // MARK: - Internal methods
    
    func viewLoaded() {
        prepareDataForView()
        view?.update()
    }
    
    func handleItemSelection(viewModel: SettingsViewModel) {
        output?.showIconSelection(self)
    }
    
    // MARK: - Private methods
    
    private func prepareDataForView() {
        items = []
        
        let iconViewModel = SettingsViewModel(name: "Icon",
                                              value: iconsManager?.currentIcon.name ?? .empty)
        
        items = [AnyDifferentiable(iconViewModel)]
    }
    
}
