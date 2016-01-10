//
//  IOTSampleData.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 1/2/16.
//  Copyright © 2016 SL Studio. All rights reserved.
//

import Foundation

struct IOTSampleData: CustomStringConvertible {
    enum SampleType:Int{
        case CO2 = 0, Temperature, Humidity
    }
    
    var type: SampleType
    var time: NSDate?
    var value: Float?
    
    init(){
        type = .CO2
        time = nil
        value = nil
    }
    
    init(type: SampleType, time: NSDate?, value: Float?){
        self.type = type
        self.time = time
        self.value = value
    }
    
    
    var description: String{
        if let atime = time {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return "\(type), \(formatter.stringFromDate(atime)), \(value)"
        }else{
            return "\(type), \(value)"
        }
    }
}