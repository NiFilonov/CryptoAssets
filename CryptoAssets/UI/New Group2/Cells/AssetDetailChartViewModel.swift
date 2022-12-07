//
//  AssetDetailChartViewModel.swift
//  CryptoAssets
//
//  Created by Globus Dev on 22.11.2022.
//

import Charts
import DifferenceKit

final class AssetDetailChartViewModel {
    let asset: Asset
    let price: String
    let change24: String
    let change24Color: ColorAsset
    let dataSet: RangeLineChartDataSet
    
    init(asset: Asset, points: [ChartPoint]) {
        self.asset = asset
        self.price = asset.priceUsd
        self.change24 = asset.changePercent24Hr
        self.change24Color = change24.first == "-" ? R.Assets.Colors.textRed : R.Assets.Colors.textGreen
        let entries = points.map({ ChartDataEntry(x: $0.time,
                                                            y: $0.price) })
        
        let dataSet = RangeLineChartDataSet(entries: entries)
        dataSet.colors = [.black]
        dataSet.lineWidth = 2.0
        dataSet.drawCirclesEnabled = false
        dataSet.circleRadius = 1.0
        dataSet.valueFont = UIFont.systemFont(ofSize: 15.0)
        dataSet.highlightEnabled = false
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.drawValuesEnabled = true
        
        if !entries.isEmpty {
            dataSet.valueFormatter = LineChartValueFormatter(chartData: entries.map({ $0.y }), minValueIndex: dataSet.minIndex)
        }
        
        self.dataSet = dataSet
    }
    
}

extension AssetDetailChartViewModel: Differentiable {
    func isContentEqual(to source: AssetDetailChartViewModel) -> Bool {
        source.asset == asset &&
        source.dataSet == dataSet
    }
    
    var differenceIdentifier: String {
        asset.id
    }
}
