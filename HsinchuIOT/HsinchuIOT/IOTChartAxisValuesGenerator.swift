//
//  IOTChartAxisValuesGenerator.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 1/12/16.
//  Copyright © 2016 SL Studio. All rights reserved.
//

import Foundation
import SwiftCharts

public typealias IOTChartAxisValueGenerator = Double -> ChartAxisValue

// Dynamic axis values generation
public struct IOTChartAxisValuesGenerator {
    
    public static func generateXAxisValuesWithChartPoints(chartPoints: [ChartPoint], minSegmentCount: Double, maxSegmentCount: Double, multiple: Double = 10, axisValueGenerator: ChartAxisValueGenerator, addPaddingSegmentIfEdge: Bool) -> [ChartAxisValue] {
        return self.generateXAxisValuesWithChartPoints(chartPoints, minSegmentCount: minSegmentCount, maxSegmentCount: maxSegmentCount, multiple: multiple, axisValueGenerator: axisValueGenerator, addPaddingSegmentIfEdge: addPaddingSegmentIfEdge, needSegment: false, axisPicker: {$0.x})
    }
    
    public static func generateYAxisValuesWithChartPoints(chartPoints: [ChartPoint], minSegmentCount: Double, maxSegmentCount: Double, multiple: Double = 10, axisValueGenerator: ChartAxisValueGenerator, addPaddingSegmentIfEdge: Bool) -> [ChartAxisValue] {
        return self.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: minSegmentCount, maxSegmentCount: maxSegmentCount, multiple: multiple, axisValueGenerator: axisValueGenerator, addPaddingSegmentIfEdge: addPaddingSegmentIfEdge, needSegment: true, axisPicker: {$0.y})
    }
    
    private static func generateXAxisValuesWithChartPoints(chartPoints: [ChartPoint], minSegmentCount: Double, maxSegmentCount: Double, multiple: Double = 10, axisValueGenerator: ChartAxisValueGenerator, addPaddingSegmentIfEdge: Bool, needSegment: Bool, axisPicker: (ChartPoint) -> ChartAxisValue) -> [ChartAxisValue] {
        let sortedChartPoints = chartPoints.sort {(obj1, obj2) in
            return axisPicker(obj1).scalar < axisPicker(obj2).scalar
        }
        
        if let first = sortedChartPoints.first, last = sortedChartPoints.last {
            return self.generateAxisValuesWithChartPoints(axisPicker(first).scalar, last: axisPicker(last).scalar, minSegmentCount: minSegmentCount, maxSegmentCount: maxSegmentCount, multiple: multiple, axisValueGenerator: axisValueGenerator, addPaddingSegmentIfEdge: addPaddingSegmentIfEdge, needSegment: needSegment)
            
        } else {
            print("Trying to generate X axis without datapoints, returning empty array")
            return []
        }
    }
    
    private static func generateYAxisValuesWithChartPoints(chartPoints: [ChartPoint], minSegmentCount: Double, maxSegmentCount: Double, multiple: Double = 10, axisValueGenerator: ChartAxisValueGenerator, addPaddingSegmentIfEdge: Bool, needSegment: Bool, axisPicker: (ChartPoint) -> ChartAxisValue) -> [ChartAxisValue] {
        
        let sortedChartPoints = chartPoints.sort {(obj1, obj2) in
            return axisPicker(obj1).scalar < axisPicker(obj2).scalar
        }
        
        if let first = sortedChartPoints.first, last = sortedChartPoints.last {
            return self.generateAxisValuesWithChartPoints(axisPicker(first).scalar, last: axisPicker(last).scalar, minSegmentCount: minSegmentCount, maxSegmentCount: maxSegmentCount, multiple: multiple, axisValueGenerator: axisValueGenerator, addPaddingSegmentIfEdge: addPaddingSegmentIfEdge, needSegment: needSegment)
            
        } else {
            print("Trying to generate Y axis without datapoints, returning empty array")
            return []
        }
    }
    
    private static func generateAxisValuesWithChartPoints(first: Double, last: Double, minSegmentCount: Double, maxSegmentCount: Double, multiple: Double, axisValueGenerator:ChartAxisValueGenerator, addPaddingSegmentIfEdge: Bool, needSegment: Bool) -> [ChartAxisValue] {
        
        if last < first {
            fatalError("Invalid range generating axis values")
        }else if last == first{
            return [axisValueGenerator(first - multiple), axisValueGenerator(first), axisValueGenerator(first + multiple)]
        }
        
        var firstValue = first
        var lastValue = last
        
        var segmentSize = multiple
        
        if needSegment {
            firstValue = first - (first % multiple)
            lastValue = last + (abs(multiple - last) % multiple)
        }
        
        
        if firstValue == first && addPaddingSegmentIfEdge {
            firstValue = firstValue - segmentSize
        }
        if lastValue == last && addPaddingSegmentIfEdge {
            lastValue = lastValue + segmentSize
        }
        
        let distance = lastValue - firstValue
        var currentMultiple = multiple
        var segmentCount = distance / currentMultiple
        while segmentCount > maxSegmentCount {
            currentMultiple *= 2
            segmentCount = distance / currentMultiple
        }
        segmentCount = ceil(segmentCount)
        while segmentCount < minSegmentCount {
            segmentCount++
        }
        segmentSize = currentMultiple
        
        let offset = firstValue
        return (0...Int(segmentCount)).map {segment in
            let scalar = offset + (Double(segment) * segmentSize)
            return axisValueGenerator(scalar)
        }
    }
    
}
