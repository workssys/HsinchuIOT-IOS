//
//  IOTChartPointValueDate.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 1/11/16.
//  Copyright © 2016 SL Studio. All rights reserved.
//

import Foundation
import SwiftCharts

class IOTChartAxisValueDate: ChartAxisValueDate {
    var _formatter: NSDateFormatter
    
    override init(date: NSDate, formatter: NSDateFormatter, labelSettings: ChartLabelSettings = ChartLabelSettings()) {
        self._formatter = NSDateFormatter()
        self._formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        super.init(date: date, formatter: formatter, labelSettings: labelSettings)
        
    }
    
    
    override public var text: String {
        return _formatter.stringFromDate(date)
    }
}