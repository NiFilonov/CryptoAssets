//
//  LineChartValueFormatter.swift
//  CryptoAssets
//
//  Created by Globus Dev on 27.11.2022.
//

import Foundation
import Charts
enum ChartValueDirection : Int {
    case top
    case topLeft
    case topRight
    case bottom
    case bottomLeft
    case bottomRight
}

func chartValueDirectionIsBottom(_ direction: ChartValueDirection) -> Bool {
    return direction == .bottom || direction == .bottomLeft || direction == .bottomRight
}

func chartValueDirectionIsTop(_ direction: ChartValueDirection) -> Bool {
    return direction == .top || direction == .topLeft || direction == .topRight
}

class LineChartValueFormatter: ValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        if let index = chartData?.firstIndex(of: value) {
            return formattedValueString(at: index) ?? .empty
        }
        return .empty
    }
    
    private var chartData: [Double]?
    private var directions: [ChartValueDirection]?

    init(chartData: [Double]?, minValueIndex: Int?, minValueDirection: ChartValueDirection = .bottom) {
        self.chartData = chartData
        directions = Array<ChartValueDirection>(repeating: .top, count: chartData?.count ?? .zero)
        directions?.append(firstValueDirection())
        for i in 1..<((self.chartData?.count ?? 0) - 1) {
            directions?.append(commonValueDirection(at: i))
        }
        directions?.append(lastValueDirection())
        if let minValueIndex = minValueIndex {
            directions?[minValueIndex] = .bottom
        }
    }

    func formattedValueString(at index: Int) -> String? {
        if let directions = directions, !directions.isEmpty {
            let direction = directions[index]
            let newlineString = "\n"
            let valueString = String(chartData?[index] ?? .zero).currencyFormat
            let numberOfSpaces = valueString.count
            
            let spaceString = "".padding(
                toLength: numberOfSpaces,
                withPad: " ",
                startingAt: 0)
            switch direction {
            case .topLeft:
                return "\(valueString)\(spaceString)"
            case .topRight:
                return "\(spaceString)\(valueString)"
            case .bottom:
                return "\(newlineString)\(valueString)"
            case .bottomLeft:
                return "\(newlineString)\(valueString)\(spaceString)"
            case .bottomRight:
                return "\(newlineString)\(spaceString)\(valueString)"
            default:
                return valueString
            }
        } else {
            return String(chartData?[index] ?? .zero)
        }
    }

        func firstValueDirection() -> ChartValueDirection {
            let rate: Double = chartData?[0] ?? .zero
            let nextRate: Double = chartData?[1] ?? .zero
            if nextRate > rate {
                return .bottomRight
            }
            return .topRight
        }

        func lastValueDirection() -> ChartValueDirection {
            let count: Int = chartData?.count ?? .zero
            let rate: Double = chartData?[count - 1] ?? .zero
            let previousRate: Double = chartData?[count - 2] ?? .zero
            if previousRate > rate {
                return .bottomLeft
            }
            return .topLeft
        }
    
    func commonValueDirection(at index: Int) -> ChartValueDirection {
        let rate = chartData?[index] ?? .zero
        let previousRate = chartData?[index - 1] ?? .zero
        let nextRate = chartData?[index + 1] ?? .zero
        if previousRate > rate && rate > nextRate {
            return .bottomLeft
        }
        if previousRate >= rate && rate <= nextRate {
            return .bottom
        }
        if previousRate < rate && rate < nextRate {
            return .topLeft
        }
        if previousRate <= rate && rate >= nextRate {
            return .top
        }
        return .top
    }
    
}
