//
//  MockServer.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/29/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation

class MockServer: IOTServerProtocol{
    
    func cancelAllRequests(){
    
    }
    
    func getSessionID(onSucceed: ((Session) -> ())?, onFailed: ((IOTError) -> ())?) {
        let session = Session(sessionID: "abcdefg")
        onSucceed?(session)
    }
    
    func login(sessionID: String, loginName: String, password: String, onSucceed: ((User) -> ())?, onFailed: ((IOTError) -> ())?) {
        var user = User(userID: "0")
        user.loginName = loginName
        user.password = password
        
        if loginName == "hsinchu" {
            user.permission = User.PERMISSION_ADMINUSER
        }else{
            user.permission = User.PERMISSION_USER
        }
        onSucceed?(user)
    }
    
    func getSiteListWithAggrData(sessionID: String, onSucceed: (([Site]) -> ())?, onFailed: ((IOTError) -> ())?) {
        
        var sites: [Site] = []
        
        for i in 1...16 {
            let site = Site(siteID: "\(i)")
            site.siteName = "测试站点\(i)"
            
            var device = Device(deviceID: "\(i)")
            device.adminDomain = "测试站点\(i)"
            device.deviceSN = "111111111\(i)"
            site.device = device
            sites.append(site)
        }
        
        
        onSucceed?(sites)
    }
    
    
    func getDeviceList(sessionID: String, onSucceed: (([Device]) -> ())?, onFailed: ((IOTError) -> ())?) {
        
        var devices: [Device] = []
        for i in 1...16 {
            var d = Device(deviceID: "\(i)")
            d.adminDomain = "测试站点\(i)"
            d.deviceSN = "000000000\(i)"
            devices.append(d)
        }
        
        onSucceed?(devices)
    }
    
    
    func getMultipleDevicesRealtimeData(sessionID: String, deviceList: [Device], onSucceed: (([String : IOTMonitorData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        
        let data1 = IOTMonitorData(co2: 1023.18, temperature: 30.9, humidity: 55)
        let data2 = IOTMonitorData(co2: 1134.3, temperature: nil, humidity: 42)
        let data3 = IOTMonitorData(co2: 911.2, temperature: 18.6, humidity: 43)
        let data4 = IOTMonitorData(co2: 1054.22, temperature: 22.8, humidity: 13)
        let data5 = IOTMonitorData(co2: nil, temperature: nil, humidity: nil)
        let data6 = IOTMonitorData(co2: 628.3, temperature: 15.2, humidity: 24)
        let data7 = IOTMonitorData(co2: 1087.3, temperature: 27.7, humidity: 76)
        let data8 = IOTMonitorData(co2: 965.27, temperature: 12.4, humidity: 38)
        let data9 = IOTMonitorData(co2: 899.78, temperature: nil, humidity: 13)
        let data10 = IOTMonitorData(co2: 564.2, temperature: 18.9, humidity: 44)
        let data11 = IOTMonitorData(co2: 256, temperature: nil, humidity: 67)
        let data12 = IOTMonitorData(co2: 765.33, temperature: 39.6, humidity: 62)
        let data13 = IOTMonitorData(co2: 898.18, temperature: 15.8, humidity: 79)
        let data14 = IOTMonitorData(co2: nil, temperature: 10.9, humidity: 54)
        let data15 = IOTMonitorData(co2: nil, temperature: 21.0, humidity: 26)
        let data16 = IOTMonitorData(co2: nil, temperature: 15.5, humidity: 43)
        
        onSucceed?(["1": data1, "2": data2, "3": data3, "4": data4, "5": data5,
            "6": data6, "7": data7, "8": data8, "9": data9, "10": data10,
            "11": data11, "12": data12, "13": data13, "14": data14, "15": data15,
            "16": data16])
    }
    
    func getDeviceRealtimeData(sessionID: String, deviceID: String, onSucceed: ((IOTMonitorData?) -> ())?, onFailed: ((IOTError) -> ())?) {
        let data1 = IOTMonitorData(co2: 1023.18, temperature: 30.9, humidity: 55)
        let data2 = IOTMonitorData(co2: 564.20, temperature: nil, humidity: 42)
        let data3 = IOTMonitorData(co2: 911.2, temperature: 18.6, humidity: 43)
        let data4 = IOTMonitorData(co2: 1054.22, temperature: 22.8, humidity: 13)
        let data5 = IOTMonitorData(co2: nil, temperature: nil, humidity: nil)
        let data6 = IOTMonitorData(co2: 628.3, temperature: 15.2, humidity: 24)
        let data7 = IOTMonitorData(co2: 1087.3, temperature: 27.7, humidity: 76)
        let data8 = IOTMonitorData(co2: 965.27, temperature: 12.4, humidity: 38)
        let data9 = IOTMonitorData(co2: 899.78, temperature: nil, humidity: 13)
        let data10 = IOTMonitorData(co2: 564.2, temperature: 18.9, humidity: 44)
        let data11 = IOTMonitorData(co2: 256, temperature: nil, humidity: 67)
        let data12 = IOTMonitorData(co2: 765.33, temperature: 39.6, humidity: 62)
        let data13 = IOTMonitorData(co2: 898.18, temperature: 15.8, humidity: 79)
        let data14 = IOTMonitorData(co2: nil, temperature: 10.9, humidity: 54)
        let data15 = IOTMonitorData(co2: nil, temperature: 21.0, humidity: 26)
        let data16 = IOTMonitorData(co2: nil, temperature: 15.5, humidity: 43)
        
        let devices = ["1": data1, "2": data2, "3": data3, "4": data4, "5": data5,
            "6": data6, "7": data7, "8": data8, "9": data9, "10": data10,
            "11": data11, "12": data12, "13": data13, "14": data14, "15": data15,
            "16": data16]
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            NSThread.sleepForTimeInterval(2)
            
            dispatch_async(dispatch_get_main_queue()){
                
                onSucceed?(devices[deviceID])
            }
        }
    }
    
    func getDeviceRealtimeDataList(sessionID: String, deviceID: String, recordNumber: Int, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        var result: [IOTSampleData] = []
        let now = NSDate()
        
        for i in 0..<recordNumber {
            let time = now.dateByAddingTimeInterval(Double(-15 * (i/3)))
            let type = IOTSampleData.SampleType(rawValue: i % 3)!
            var value:Float = 0
            
            switch type {
            case .CO2:
                value = Float(arc4random() % 1200)
            case .Temperature:
                value = Float((arc4random() % 400)) / 10
            case .Humidity:
                value = Float((arc4random() % 10000)) / 100
            }
            
            result.append(IOTSampleData(type: type, time: time, value: value))
            
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            NSThread.sleepForTimeInterval(1)
            
            dispatch_async(dispatch_get_main_queue()){
                onSucceed?(result)
            }
        }
        
    }
    
    func getDeviceAggregationDataListBy15Seconds(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        
        getDeviceAggregationDataListByInterval(sessionID, deviceID: deviceID, from: from, to: to, interval: 15, onSucceed: onSucceed, onFailed: onFailed)
    }
    
    func getDeviceAggregationDataListBy1Quarter(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        getDeviceAggregationDataListByInterval(sessionID, deviceID: deviceID, from: from, to: to, interval: (15 * 60), onSucceed: onSucceed, onFailed: onFailed)
    }
    
    func getDeviceAggregationDataListBy1Hour(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        getDeviceAggregationDataListByInterval(sessionID, deviceID: deviceID, from: from, to: to, interval: (60 * 60), onSucceed: onSucceed, onFailed: onFailed)
    }
    
    func getDeviceAggregationDataListBy8Hours(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        getDeviceAggregationDataListByInterval(sessionID, deviceID: deviceID, from: from, to: to, interval: (8 * 60 * 60), onSucceed: onSucceed, onFailed: onFailed)
    }
    
    func getDeviceAggregationDataListBy1Day(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        getDeviceAggregationDataListByInterval(sessionID, deviceID: deviceID, from: from, to: to, interval: (24 * 60 * 60), onSucceed: onSucceed, onFailed: onFailed)
    }
    
    func getDeviceAggregationDataListBy1Week(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        getDeviceAggregationDataListByInterval(sessionID, deviceID: deviceID, from: from, to: to, interval: (7 * 24 * 60 * 60), onSucceed: onSucceed, onFailed: onFailed)
    }
    
    func getDeviceAggregationDataListBy1Month(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        getDeviceAggregationDataListByInterval(sessionID, deviceID: deviceID, from: from, to: to, interval: (30 * 24 * 60 * 60), onSucceed: onSucceed, onFailed: onFailed)
    }
    
    private func getDeviceAggregationDataListByInterval(sessionID: String, deviceID: String, from: NSDate, to: NSDate,interval: NSTimeInterval, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        
        let timeIntervals = to.timeIntervalSinceDate(from)
        
        var recordNumber = Int (3 * (timeIntervals/interval))
        if recordNumber < 0 {
            recordNumber = 0
        }
        
        var result: [IOTSampleData] = []
        for i in 0..<recordNumber {
            let time = from.dateByAddingTimeInterval(interval * Double(i/3))
            let type = IOTSampleData.SampleType(rawValue: i % 3)!
            var value:Float = 0
            
            switch type {
            case .CO2:
                value = Float(arc4random() % 1200)
            case .Temperature:
                value = Float((arc4random() % 400)) / 10
            case .Humidity:
                value = Float((arc4random() % 10000)) / 100
            }
            
            result.append(IOTSampleData(type: type, time: time, value: value))
            
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            NSThread.sleepForTimeInterval(2)
            
            dispatch_async(dispatch_get_main_queue()){
                onSucceed?(result)
            }
        }
    }
   
    func registerDeviceBinding(sessionID: String, username: String, token: String, deviceKey: String, onSucceed: ((String) -> ())?, onFailed: ((IOTError) -> ())?) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)){
            NSThread.sleepForTimeInterval(2)
            
            dispatch_async(dispatch_get_main_queue()){
                onSucceed?("OK")
            }
        }
    }
}