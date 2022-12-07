//
//  IconSelectionPresenter.swift
//  CryptoAssets
//
//  Created by Globus Dev on 29.11.2022.
//

import DifferenceKit

protocol IconSelectionPresenterOutput: AnyObject {
    func showAssetDetails(_ presenter: IconSelectionPresenting, asset: Asset)
}

protocol IconSelectionPresenting: AnyObject {
    var output: IconSelectionPresenterOutput? { get set }
    var items: [AnyDifferentiable] { get }
    
    func viewLoaded()
    func handleIconSelected(with viewModel: SettingsViewModel)
}

final class IconSelectionPresenter: IconSelectionPresenting {
    
    // MARK: - Internal properties
    
    var output: IconSelectionPresenterOutput?
    
    var items: [AnyDifferentiable] = []
    
    // MARK: - Private properties
    
    private weak var view: IconSelectionViewing?
    
    private let iconsManager: IconsManager? = ManagersAssembly.container.resolve(IconsManager.self)
    
    // MARK: - Init
    
    init(view: IconSelectionViewing) {
        self.view = view
        self.view?.presenter = self
    }
    
    // MARK: - Internal methods
    
    func viewLoaded() {
        prepareDataForView()
        view?.update()
    }
    
    func handleIconSelected(with viewModel: SettingsViewModel) {
        if let icon = AppIcon(rawValue: viewModel.id) {
            iconsManager?.set(icon: icon)
            prepareDataForView()
            view?.update()
        }
    }
    
    // MARK: - Private methods
    
    private func prepareDataForView() {
        items = []
        
        let currentIcon = iconsManager?.currentIcon
        let iconsDifferentiable = iconsManager?.icons.map({ AnyDifferentiable(SettingsViewModel(id: $0.rawValue,
                                                                                                name: $0.name,
                                                                                                value: .empty,
                                                                                                selected: $0 == currentIcon)) })
        items = iconsDifferentiable ?? []
    }
    
}
