//
//  AssetDetailChartCell.swift
//  CryptoAssets
//
//  Created by Globus Dev on 22.11.2022.
//

import UIKit
import Charts

final class AssetDetailChartCell: TableViewCell<AssetDetailChartViewModel>  {
    
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var change24hLabel: UILabel!
    @IBOutlet private weak var chart: LineChartView! {
        didSet {
            chart.setViewPortOffsets(left: .zero, top: .zero, right: .zero, bottom: .zero)
            chart.drawGridBackgroundEnabled = false
            chart.legend.enabled = false
            chart.rightAxis.enabled = false
            chart.leftAxis.enabled = false
            chart.xAxis.enabled = false
            chart.dragEnabled = false
            chart.pinchZoomEnabled = false
            chart.isUserInteractionEnabled = false
            render  = RangeLineChartRenderer(dataProvider: chart, animator: Animator(), viewPortHandler: viewPortHandler)
            chart.renderer = render
        }
    }
    
    private lazy var viewPortHandler = ViewPortHandler(width: bounds.size.width, height: bounds.size.height)
    
    private var render: RangeLineChartRenderer!
    
    override func update(with viewModel: AssetDetailChartViewModel) {
        priceLabel.text = viewModel.price
        change24hLabel.text = viewModel.change24
        change24hLabel.textColor = viewModel.change24Color.color
        backgroundColor = R.Assets.Colors.cellGrayBackground.color
        chart.data = LineChartData(dataSets: [viewModel.dataSet])
    }
    
}









