//
//  ChartsManager.swift
//  CryptoAssets
//
//  Created by Globus Dev on 24.11.2022.
//

import Foundation

extension Notification.Name {
    static let chartFetched = Notification.Name(rawValue: "chartFetched")
    static let chartFetchingFailed = Notification.Name(rawValue: "chartFetchingFailed")
}

final class ChartsManager {
    
    enum Interval: String {
        case m1, m5, m15, m30, h1, h2, h6, h12, d1
    }
    
    var chartPoints: [ChartPoint] = []
    
    private var network: NetworkManaging? = ManagersAssembly.container.resolve(NetworkManager.self)
    
    func fetchChartData(asset: Asset, interval: Interval = .d1) {
        network?.fetchChart(currency: asset.name.lowercased(),
                            interval: interval.rawValue) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let chartPoints):
                self.chartPoints = chartPoints
                NotificationCenter.default.post(name: .chartFetched, object: nil)
            case .failure:
                NotificationCenter.default.post(name: .chartFetchingFailed, object: nil)
            }
        }
    }
    
    func clearChartPoints() {
        chartPoints = []
    }
}
