//
//  AssetDetailPresenter.swift
//  CryptoAssets
//
//  Created by Globus Dev on 22.11.2022.
//

import DifferenceKit

protocol AssetDetailPresenterOutput: AnyObject {
    func close(_ presenter: AssetDetailViewing)
}

protocol AssetDetailPresenting: AnyObject {
    
    var output: AssetDetailPresenterOutput? { get set }
    var items: [AnyDifferentiable] { get }
    var isFavorite: Bool { get }
    
    func viewLoaded()
    func updateFavoriteForCurrentAsset()
}

final class AssetDetailPresenter: AssetDetailPresenting {
    
    // MARK: - Internal properties
    
    weak var output: AssetDetailPresenterOutput?
    
    var items: [AnyDifferentiable] = []
    
    var isFavorite: Bool = false {
        didSet {
            view?.updateFavoriteButton(isFavorite)
        }
    }
    
    // MARK: - Private properties
    
    private weak var view: AssetDetailViewing?
    
    private let favoriteManager: FavoriteAssetsManager? = ManagersAssembly.container.resolve(FavoriteAssetsManager.self)
    private let storageManager: StorageManager? = ManagersAssembly.container.resolve(StorageManager.self)
    private let chartManager: ChartsManager? = ManagersAssembly.container.resolve(ChartsManager.self)
    
    private var asset: Asset
    
    private var chartData: [ChartPoint] {
        chartManager?.chartPoints ?? []
    }
    
    // MARK: - Init
    
    init(view: AssetDetailViewing, asset: Asset) {
        self.view = view
        self.asset = asset
        self.view?.presenter = self
        subscribeToNotifications()
    }
    
    deinit {
        unsubscribeFromNotifications()
    }
    
    // MARK: - Internal methods
    
    func viewLoaded() {
        updateTitle()
        setFavorite()
        fetchChartData()
    }
    
    func updateFavoriteForCurrentAsset() {
        if isFavorite {
            storageManager?.removeFromFavorite(id: asset.id)
        } else {
            storageManager?.addFavoriteId(asset.id)
        }
        isFavorite.toggle()
    }
    
    // MARK: - Private methods
    
    private func fetchChartData() {
        chartManager?.fetchChartData(asset: asset)
    }
    
    private func prepareDataForView() {
        items = []
        
        if !chartData.isEmpty {
            let chartViewModel = AssetDetailChartViewModel(asset: asset, points: chartData)
            items.append(AnyDifferentiable(chartViewModel))
        }
        
        let marketCapViewModel = AssetDetailInfoViewModel(name: L10n.AssetsDetails.marketCap, value: asset.marketCapUsd.currencyFormat)
        
        let supplyViewModel = AssetDetailInfoViewModel(name: L10n.AssetsDetails.supply, value: asset.supply.currencyFormat)
        
        let volumeViewModel = AssetDetailInfoViewModel(name: L10n.AssetsDetails.volume24h, value: asset.volumeUsd24Hr.currencyFormat)
        
        items.append(AnyDifferentiable(marketCapViewModel))
        items.append(AnyDifferentiable(supplyViewModel))
        items.append(AnyDifferentiable(volumeViewModel))
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(forName: .chartFetched, object: nil, queue: nil) { _ in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.prepareDataForView()
                self.view?.update()
            }
        }
        
        NotificationCenter.default.addObserver(forName: .chartFetchingFailed, object: nil, queue: nil) { _ in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.view?.showError(title: L10n.Error.title, message: L10n.Error.offline)
                self.prepareDataForView()
                self.view?.update()
            }
        }
    }
    
    private func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func updateTitle() {
        let title = makeAttributtedTitle()
        view?.updateTitle(title)
    }
    
    private func makeAttributtedTitle() -> NSAttributedString {
        let title = NSMutableAttributedString(string: asset.name + .space, attributes:[
            NSAttributedString.Key.foregroundColor: R.Assets.Colors.textBlack.color])
        title.append(NSMutableAttributedString(string: asset.symbol, attributes:[
            NSAttributedString.Key.foregroundColor: R.Assets.Colors.textGray.color]))
        return title
    }
    
    private func setFavorite() {
        isFavorite = favoriteManager?.isFavorite(asset: asset) ?? false
    }
    
}
