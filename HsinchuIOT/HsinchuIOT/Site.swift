//
//  Site.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/27/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation

struct Site{
    let siteID: String
    var siteName: String?
    var device: Device?
    var aggregationData: IOTMonitorData?
    
    var status: Int {
        get{
            var _status: Int = 0
            if let data = aggregationData{
                if data.isCO2Missing(){
                    if data.isTemperatureMissing(){
                        _status = 1
                    }else if data.isTemperatureAlarm(){
                        _status = 7
                    }else if data.isTemperatureWarning(){
                        _status = 5
                    }else{
                        _status = 2
                    }
                }else if data.isCO2Alarm(){
                    if data.isTemperatureMissing(){
                        _status = 13
                    }else if data.isTemperatureAlarm(){
                        _status = 16
                    }else if data.isTemperatureWarning(){
                        _status = 15
                    }else{
                        _status = 14
                    }
                }else if data.isCO2Warning(){
                    if data.isTemperatureMissing(){
                        _status = 9
                    }else if data.isTemperatureAlarm(){
                        _status = 12
                    }else if data.isTemperatureWarning(){
                        _status = 11
                    }else{
                        _status = 10
                    }
                }else{
                    if data.isTemperatureMissing(){
                        _status = 3
                    }else if data.isTemperatureAlarm(){
                        _status = 8
                    }else if data.isTemperatureWarning(){
                        _status = 6
                    }else{
                        _status = 4
                    }
                }
            }
            
            return _status
        }
    }
     
    
    init(siteID: String){
        self.siteID = siteID
    }
}