//
//  FavoriteAssetsPresenter.swift
//  CryptoAssets
//
//  Created by Globus Dev on 24.11.2022.
//

import DifferenceKit

protocol FavoriteAssetsPresenterOutput: AnyObject {
    func showAssetDetails(_ presenter: FavoriteAssetsPresenting, asset: Asset)
}

protocol FavoriteAssetsPresenting: AnyObject {
    
    var output: FavoriteAssetsPresenterOutput? { get set }
    var items: [AnyDifferentiable] { get }
    
    func viewLoaded()
    func assetSelected(viewModel: AssetCellViewModel)
    func handleRemoveFromFavoriteAction(at index: Int)
}

final class FavoriteAssetsPresenter: FavoriteAssetsPresenting {
    
    // MARK: - Internal properties
    
    var output: FavoriteAssetsPresenterOutput?
    
    var items: [AnyDifferentiable] = []
    
    // MARK: - Private properties
    
    private weak var view: FavoriteAssetsViewing?
    
    private let favoriteManager: FavoriteAssetsManager? = ManagersAssembly.container.resolve(FavoriteAssetsManager.self)
    
    private var assets: [Asset] {
        favoriteManager?.assets ?? []
    }
    
    // MARK: - Init
    
    init(view: FavoriteAssetsViewing) {
        self.view = view
        self.view?.presenter = self
        subscribeToNotifications()
    }
    
    deinit {
        unsubscribeFromNotifications()
    }
    
    // MARK: - Internal methods
    
    func viewLoaded() {
        fetchAssets()
    }
    
    func assetSelected(viewModel: AssetCellViewModel) {
        if let asset = assets.filter({ $0.id == viewModel.id }).first {
            output?.showAssetDetails(self, asset: asset)
        }
    }
    
    func handleRemoveFromFavoriteAction(at index: Int) {
        favoriteManager?.removeFromFavorite(asset: assets[index])
    }
    
    // MARK: - Private methods
    
    private func fetchAssets() {
        favoriteManager?.fetchAssets()
    }
    
    private func prepareAssetsForView() {
        items = assets.map({ AnyDifferentiable(AssetCellViewModel(asset: $0)) })
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(forName: .favoriteAssetsFetched, object: nil, queue: nil) { _ in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.prepareAssetsForView()
                self.view?.update()
            }
        }
        
        NotificationCenter.default.addObserver(forName: .favoriteAssetsFetchingFailed, object: nil, queue: nil) { _ in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.view?.showError(title: L10n.Error.title, message: L10n.Error.offline)
            }
        }
    }
    
    private func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
}
