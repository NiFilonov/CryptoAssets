//
//  AssetsListViewModel.swift
//  CryptoAssets
//
//  Created by Nikita Filonov on 20.11.2022.
//

import DifferenceKit

protocol AssetsListPresenterOutput: AnyObject {
    func showAssetDetails(_ presenter: AssetsListPresenting, asset: Asset)
}

protocol AssetsListPresenting: AnyObject {
    
    var output: AssetsListPresenterOutput? { get set }
    var items: [AnyDifferentiable] { get }
    
    func viewLoaded()
    func assetSelected(viewModel: AssetCellViewModel)
    func refreshAssets()
    func loadMoreAssets()
    func searchAssets(by text: String)
    func searchingCanceled()
}

final class AssetsListPresenter: AssetsListPresenting {
    
    // MARK: - Internal properties
    
    var output: AssetsListPresenterOutput?
    
    var items: [AnyDifferentiable] = []
    
    // MARK: - Private properties
    
    private weak var view: AssetsListViewing?
    
    private let assetsManager: AssetsManager? = ManagersAssembly.container.resolve(AssetsManager.self)
    private let searchAssetsManager: SearchAssetsManager? = ManagersAssembly.container.resolve(SearchAssetsManager.self)
    
    private var assets: [Asset] {
        if isSearching {
            return searchAssetsManager?.assets ?? []
        } else {
            return assetsManager?.assets ?? []
        }
    }
    
    private var isRefreshing: Bool = false
    private var isSearching: Bool = false
    private var isAllDataLoaded: Bool = false
    
    // MARK: - Init
    
    init(view: AssetsListViewing) {
        self.view = view
        self.view?.presenter = self
        prepareAssetsForView()
        subscribeToNotifications()
    }
    
    deinit {
        unsubscribeFromNotifications()
    }
    
    // MARK: - Internal methods
    
    func viewLoaded() {
        loadMoreAssets()
    }
    
    func assetSelected(viewModel: AssetCellViewModel) {
        if let asset = assets.filter({ $0.id == viewModel.id }).first {
            output?.showAssetDetails(self, asset: asset)
        }
    }
    
    func refreshAssets() {
        isRefreshing = true
        isAllDataLoaded = false
        assetsManager?.fetchAssets(isRefresh: true)
    }
    
    func loadMoreAssets() {
        guard !isAllDataLoaded else { return }
        if isSearching {
            searchAssetsManager?.fetchAssets(isRefresh: isRefreshing)
        } else {
            assetsManager?.fetchAssets(isRefresh: isRefreshing)
        }
    }
    
    func searchAssets(by text: String) {
        isSearching = true
        searchAssetsManager?.fetchAssets(isRefresh: isRefreshing, searchText: text)
    }
    
    func searchingCanceled() {
        isSearching = false
        searchAssetsManager?.clear()
        refreshAssets()
    }
    
    // MARK: - Private methods
    
    private func prepareAssetsForView() {
        items = []
        let assetsViewModels = assets.map({ AnyDifferentiable(AssetCellViewModel(asset: $0)) })
        if !assetsViewModels.isEmpty {
            items.append(contentsOf: assetsViewModels)
        }
        if !isAllDataLoaded {
            items.append(AnyDifferentiable(LoadMoreViewModel()))
        }
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(forName: .assetsFetched, object: nil, queue: nil) { _ in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.prepareAssetsForView()
                if self.isRefreshing {
                    self.isRefreshing = false
                    self.view?.stopRefreshing()
                }
                self.view?.update()
            }
        }
        
        NotificationCenter.default.addObserver(forName: .allAssetsFetched, object: nil, queue: nil) { _ in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isAllDataLoaded = true
                self.prepareAssetsForView()
                self.view?.update()
            }
        }
        
        NotificationCenter.default.addObserver(forName: .assetsFetchingFailed, object: nil, queue: nil) { _ in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isAllDataLoaded = true
                if self.isRefreshing {
                    self.isRefreshing = false
                    self.view?.stopRefreshing()
                }
                self.prepareAssetsForView()
                self.view?.update()
                self.view?.showError(title: L10n.Error.title, message: L10n.Error.offline)
            }
        }
    }
    
    private func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
}
