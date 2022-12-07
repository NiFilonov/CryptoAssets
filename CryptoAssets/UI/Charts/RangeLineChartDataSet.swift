//
//  RangeLineChartDataSet.swift
//  CryptoAssets
//
//  Created by Globus Dev on 27.11.2022.
//

import Foundation
import CoreGraphics
import Charts

open class RangeLineChartDataSet: LineChartDataSet
{
    var minIndex: Int?
    var maxIndex: Int?
    
    @objc(LineChartMode)
    public enum Mode: Int
    {
        case linear
        case stepped
        case cubicBezier
        case horizontalBezier
    }
    
    private func initialize()
    {
        let minMax = entries.enumerated().minAndMax(by: { $0.element.y < $1.element.y })
        minIndex = minMax?.min.offset
        maxIndex = minMax?.max.offset
    }
    
    public required init()
    {
        super.init()
        initialize()
    }
    
    public override init(entries: [ChartDataEntry], label: String)
    {
        super.init(entries: entries, label: label)
        initialize()
    }
}
