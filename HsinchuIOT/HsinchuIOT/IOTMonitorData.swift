//
//  IOTMonitorData.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/27/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation

struct IOTMonitorData {
    var co2: Float?
    var temperature: Float?
    var humidity: Float?
    

    init(){
        co2 = nil
        temperature = nil
        humidity = nil
    }
    
    init(co2: Float?, temperature: Float?, humidity: Float?){
        self.co2 = co2
        self.temperature = temperature
        self.humidity = humidity
    }
    
    
    func isCO2Alarm() -> Bool {
        if let value = co2{
            return value >= 1000
        }else{
            return false
        }
    }
    
    func isCO2Warning() -> Bool {
        if let value = co2{
            return (value >= 800 && value < 1000)
        }else{
            return false
        }
    }
    
    func isCO2Missing() -> Bool{
        return co2 == nil
    }
    
    func isTemperatureAlarm() -> Bool {
        if let value = temperature{
            return (value <= 15 || value >= 28)
        }else{
            return false
        }
    }
    
    func isTemperatureWarning() -> Bool {
        if let value = temperature{
            return (value < 16 || value > 27)
        }else{
            return false
        }
        
    }
    
    func isTemperatureMissing() -> Bool{
        return temperature == nil
    }
    
    func isHumidityAlarm() -> Bool {
        if let value = humidity {
            return (value <= 40 || value >= 65)
        }else{
            return false
        }
    }
    
    func isHumidityWarning() -> Bool {
        if let value = humidity{
            return (value < 45 || value > 60)
        }else{
            return false
        }
    }
    
    func isHumidityMissing() -> Bool{
        return humidity == nil
    }

    
}