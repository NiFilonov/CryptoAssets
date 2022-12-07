//
//  RangeLineChartRenderer.swift
//  CryptoAssets
//
//  Created by Globus Dev on 27.11.2022.
//

import UIKit
import Charts
import CoreGraphics

@objc(BarLineScatterCandleBubbleChartRenderer)
open class RangeLineChartRenderer: NSObject, DataRenderer
{
    public let viewPortHandler: ViewPortHandler
    
    public final var accessibleChartElements: [NSUIAccessibilityElement] = []
    
    public let animator: Animator
    
    internal var _xBounds = XBounds() // Reusable XBounds object
    
    @objc open weak var dataProvider: LineChartDataProvider?
    
    private var _lineSegments = [CGPoint](repeating: CGPoint(), count: 2)
    
    public init(dataProvider: LineChartDataProvider, animator: Animator, viewPortHandler: ViewPortHandler)
    {
        self.dataProvider = dataProvider
        self.viewPortHandler = viewPortHandler
        self.animator = animator
        
        super.init()
    }
    
    open func drawData(context: CGContext)
    {
        guard let lineData = dataProvider?.lineData else { return }
        
        let sets = lineData.dataSets as? [LineChartDataSet]
        assert(sets != nil, "Datasets for LineChartRenderer must conform to ILineChartDataSet")
        
        let drawDataSet = { self.drawDataSet(context: context, dataSet: $0) }
        sets!.lazy
            .filter(\.isVisible)
            .forEach(drawDataSet)
    }
    
    @objc open func drawDataSet(context: CGContext, dataSet: LineChartDataSetProtocol)
    {
        if dataSet.entryCount < 1
        {
            return
        }
        
        context.saveGState()
        
        context.setLineWidth(dataSet.lineWidth)
        if dataSet.lineDashLengths != nil
        {
            context.setLineDash(phase: dataSet.lineDashPhase, lengths: dataSet.lineDashLengths!)
        }
        else
        {
            context.setLineDash(phase: 0.0, lengths: [])
        }
        
        context.setLineCap(dataSet.lineCapType)
        
        drawLinear(context: context, dataSet: dataSet)
        
        context.restoreGState()
    }
    
    public func drawValues(context: CGContext) {
        guard
            let dataProvider = dataProvider,
            let lineData = dataProvider.lineData
        else { return }
        
        let phaseY = animator.phaseY
        
        var pt = CGPoint()
        
        for i in lineData.indices
        {
            guard let
                    dataSet = lineData[i] as? RangeLineChartDataSet
            else { continue }
            
            let valueFont = dataSet.valueFont
            
            let formatter = dataSet.valueFormatter
            
            let angleRadians = dataSet.valueLabelAngle.DEG2RAD
            
            let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
            let valueToPixelMatrix = trans.valueToPixelMatrix
            
            // make sure the values do not interfear with the circles
            var valOffset = Int(dataSet.circleRadius * 1.75)
            
            if !dataSet.isDrawCirclesEnabled
            {
                valOffset = valOffset / 2
            }
            
            _xBounds.set(chart: dataProvider, dataSet: dataSet, animator: animator)
            
            for j in _xBounds
            {
                guard let e = dataSet.entryForIndex(j),
                      j == dataSet.minIndex || j == dataSet.maxIndex else { continue }
                pt.x = CGFloat(e.x)
                pt.y = CGFloat(e.y * phaseY)
                pt = pt.applying(valueToPixelMatrix)
                
                if (!viewPortHandler.isInBoundsRight(pt.x))
                {
                    continue
                }
                
                if (!viewPortHandler.isInBoundsLeft(pt.x) || !viewPortHandler.isInBoundsY(pt.y))
                {
                    continue
                }
                
                if dataSet.isDrawValuesEnabled
                {
                    let fontAttributes = [NSAttributedString.Key.font: valueFont]
                    let text = formatter.stringForValue(e.y,
                                                        entry: e,
                                                        dataSetIndex: i,
                                                        viewPortHandler: viewPortHandler)
                    let size = (text as NSString).size(withAttributes: fontAttributes)
                    
                    var point = CGPoint(x: pt.x,
                                        y: pt.y - CGFloat(valOffset) - valueFont.lineHeight)
                    
                    let leftXPosition = pt.x - size.width / 2
                    if !viewPortHandler.isInBoundsLeft(leftXPosition) {
                        point.x = pt.x + abs(leftXPosition) + 8
                    }
                    
                    let rightXPosition = pt.x + size.width + size.width / 2
                    if !viewPortHandler.isInBoundsRight(rightXPosition) {
                        point.x = pt.x - abs(viewPortHandler.contentWidth - rightXPosition) - 8
                    }
                    
                    context.drawText(text,
                                     at: point,
                                     align: .center,
                                     angleRadians: angleRadians,
                                     attributes: [.font: valueFont,
                                                  .foregroundColor: R.Assets.Colors.textGray.color])
                }
            }
        }
    }
    
    @objc open func drawLinear(context: CGContext, dataSet: LineChartDataSetProtocol)
    {
        guard let dataProvider = dataProvider else { return }
        
        let trans = dataProvider.getTransformer(forAxis: dataSet.axisDependency)
        
        let valueToPixelMatrix = trans.valueToPixelMatrix
        
        let isDrawSteppedEnabled = dataSet.mode == .stepped
        
        let phaseY = animator.phaseY
        
        _xBounds.set(chart: dataProvider, dataSet: dataSet, animator: animator)
        
        context.saveGState()
        defer { context.restoreGState() }
        
        guard dataSet.entryForIndex(_xBounds.min) != nil else {
            return
        }
        
        var firstPoint = true
        
        let path = CGMutablePath()
        for x in stride(from: _xBounds.min, through: _xBounds.range + _xBounds.min, by: 1)
        {
            guard let e1 = dataSet.entryForIndex(x == 0 ? 0 : (x - 1)) else { continue }
            guard let e2 = dataSet.entryForIndex(x) else { continue }
            
            let startPoint =
            CGPoint(
                x: CGFloat(e1.x),
                y: CGFloat(e1.y * phaseY))
            .applying(valueToPixelMatrix)
            
            if firstPoint
            {
                path.move(to: startPoint)
                firstPoint = false
            }
            else
            {
                path.addLine(to: startPoint)
            }
            
            if isDrawSteppedEnabled
            {
                let steppedPoint =
                CGPoint(
                    x: CGFloat(e2.x),
                    y: CGFloat(e1.y * phaseY))
                .applying(valueToPixelMatrix)
                path.addLine(to: steppedPoint)
            }
            
            let endPoint =
            CGPoint(
                x: CGFloat(e2.x),
                y: CGFloat(e2.y * phaseY))
            .applying(valueToPixelMatrix)
            path.addLine(to: endPoint)
        }
        
        if !firstPoint
        {
            context.beginPath()
            context.addPath(path)
            context.setStrokeColor(dataSet.color(atIndex: 0).cgColor)
            context.strokePath()
        }
        
    }
    
    open func drawExtras(context: CGContext) { }
    
    open func drawHighlighted(context: CGContext, indices: [Highlight]) { }
    
    /// Checks if the provided entry object is in bounds for drawing considering the current animation phase.
    internal func isInBoundsX(entry e: ChartDataEntry, dataSet: BarLineScatterCandleBubbleChartDataSetProtocol) -> Bool
    {
        let entryIndex = dataSet.entryIndex(entry: e)
        return Double(entryIndex) < Double(dataSet.entryCount) * animator.phaseX
    }
    
    /// Calculates and returns the x-bounds for the given DataSet in terms of index in their values array.
    /// This includes minimum and maximum visible x, as well as range.
    internal func xBounds(chart: BarLineScatterCandleBubbleChartDataProvider,
                          dataSet: BarLineScatterCandleBubbleChartDataSetProtocol,
                          animator: Animator?) -> XBounds
    {
        return XBounds(chart: chart, dataSet: dataSet, animator: animator)
    }
    
    /// - Returns: `true` if the DataSet values should be drawn, `false` if not.
    internal func shouldDrawValues(forDataSet set: ChartDataSetProtocol) -> Bool
    {
        return set.isVisible && (set.isDrawValuesEnabled || set.isDrawIconsEnabled)
    }
    
    open func initBuffers() { }
    
    open func isDrawingValuesAllowed(dataProvider: ChartDataProvider?) -> Bool
    {
        guard let data = dataProvider?.data else { return false }
        return data.entryCount < Int(CGFloat(dataProvider?.maxVisibleCount ?? 0) * viewPortHandler.scaleX)
    }
    
    /// Class representing the bounds of the current viewport in terms of indices in the values array of a DataSet.
    open class XBounds
    {
        /// minimum visible entry index
        open var min: Int = 0
        
        /// maximum visible entry index
        open var max: Int = 0
        
        /// range of visible entry indices
        open var range: Int = 0
        
        public init()
        {
            
        }
        
        public init(chart: BarLineScatterCandleBubbleChartDataProvider,
                    dataSet: BarLineScatterCandleBubbleChartDataSetProtocol,
                    animator: Animator?)
        {
            self.set(chart: chart, dataSet: dataSet, animator: animator)
        }
        
        /// Calculates the minimum and maximum x values as well as the range between them.
        open func set(chart: BarLineScatterCandleBubbleChartDataProvider,
                      dataSet: BarLineScatterCandleBubbleChartDataSetProtocol,
                      animator: Animator?)
        {
            let phaseX = Swift.max(0.0, Swift.min(1.0, animator?.phaseX ?? 1.0))
            
            let low = chart.lowestVisibleX
            let high = chart.highestVisibleX
            
            let entryFrom = dataSet.entryForXValue(low, closestToY: .nan, rounding: .down)
            let entryTo = dataSet.entryForXValue(high, closestToY: .nan, rounding: .up)
            
            self.min = entryFrom == nil ? 0 : dataSet.entryIndex(entry: entryFrom!)
            self.max = entryTo == nil ? 0 : dataSet.entryIndex(entry: entryTo!)
            range = Int(Double(self.max - self.min) * phaseX)
        }
    }
    
    public func createAccessibleHeader(usingChart chart: ChartViewBase, andData data: ChartData, withDefaultDescription defaultDescription: String) -> NSUIAccessibilityElement {
        return AccessibleHeader.create(usingChart: chart, andData: data, withDefaultDescription: defaultDescription)
    }
}

extension RangeLineChartRenderer.XBounds: RangeExpression {
    public func relative<C>(to collection: C) -> Swift.Range<Int>
    where C : Collection, Bound == C.Index
    {
        return Swift.Range<Int>(min...min + range)
    }
    
    public func contains(_ element: Int) -> Bool {
        return (min...min + range).contains(element)
    }
}

extension RangeLineChartRenderer.XBounds: Sequence {
    public func makeIterator() -> Iterator {
        return RangeLineChartRenderer.XBounds.Iterator(min: self.min, max: self.min + self.range)
    }
    
    public struct Iterator: IteratorProtocol {
        private var iterator: IndexingIterator<ClosedRange<Int>>
        
        fileprivate init(min: Int, max: Int) {
            self.iterator = (min...max).makeIterator()
        }
        
        public mutating func next() -> Int? {
            return self.iterator.next()
        }
    }
}

extension RangeLineChartRenderer.XBounds: CustomDebugStringConvertible
{
    public var debugDescription: String
    {
        return "min:\(self.min), max:\(self.max), range:\(self.range)"
    }
}

extension FloatingPoint
{
    var DEG2RAD: Self
    {
        return self * .pi / 180
    }
    
    var RAD2DEG: Self
    {
        return self * 180 / .pi
    }
    
    /// - Note: Value must be in degrees
    /// - Returns: An angle between 0.0 < 360.0 (not less than zero, less than 360)
    var normalizedAngle: Self
    {
        let angle = truncatingRemainder(dividingBy: 360)
        return (sign == .minus) ? angle + 360 : angle
    }
}

internal struct AccessibleHeader {
    static func create(usingChart chart: ChartViewBase,
                       andData data: ChartData,
                       withDefaultDescription defaultDescription: String = "Chart") -> NSUIAccessibilityElement
    {
        let chartDescriptionText = chart.chartDescription.text ?? defaultDescription
        let dataSetDescriptions = data.map { $0.label ?? "" }
        let dataSetDescriptionText = dataSetDescriptions.joined(separator: ", ")
        
        let element = NSUIAccessibilityElement(accessibilityContainer: chart)
        element.accessibilityLabel = chartDescriptionText + ". \(data.count) dataset\(data.count == 1 ? "" : "s"). \(dataSetDescriptionText)"
        element.accessibilityFrame = chart.bounds
        
        return element
    }
}
