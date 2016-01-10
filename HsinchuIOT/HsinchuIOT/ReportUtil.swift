//
//  ReportUtil.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 1/6/16.
//  Copyright © 2016 SL Studio. All rights reserved.
//

import Foundation

class ReportUtil {
    static var timeFormatter: NSDateFormatter {
        get{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter
        }
    }
    
    
    static func getServerTimeString(time: NSDate) -> String{
        let serverTime = getServerTime(time)
        return timeFormatter.stringFromDate(serverTime)
    }
    
    static func getServerTime(time: NSDate) -> NSDate{
        return time.dateByAddingTimeInterval(-8 * 60 * 60)
    }
}