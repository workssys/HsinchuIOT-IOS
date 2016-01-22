//
//  Alarm.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 1/21/16.
//  Copyright © 2016 SL Studio. All rights reserved.
//

import Foundation

struct Alarm {
    
    enum AlarmType: String{
        case BREACHED = "超標", WARNING = "接近超標"
    }
    
    let alarmTime: String
    let deviceID: String
    let alarmSite: String
    let alarmValueType: String
    let alarmValue: String
    let alarmType: AlarmType?
    
    let alarmString: String
    
    init?(alarmString: String){
        
        let strs = alarmString.componentsSeparatedByString(";")
        if strs.count == 6 {
            self.alarmString = alarmString
            self.alarmTime = strs[0]
            self.deviceID = strs[1]
            self.alarmSite = strs[2]
            self.alarmValueType = strs[3]
            self.alarmValue = strs[4]
            self.alarmType = AlarmType(rawValue: strs[5])
        }else{
            return nil
        }
    }
    
}

class AlarmWrapper{
    var alarm: Alarm!
    
    init(alarm: Alarm?){
        self.alarm = alarm
    }
}