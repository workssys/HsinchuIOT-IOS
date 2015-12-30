//
//  MockServer.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/29/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation

class MockServer: IOTServerProtocol{
    func getSessionID(onSucceed: ((Session) -> ())?, onFailed: ((IOTError) -> ())?) {
        let session = Session(sessionID: "abcdefg")
        onSucceed?(session)
    }
    
    func login(sessionID: String, loginName: String, password: String, onSucceed: ((User) -> ())?, onFailed: ((IOTError) -> ())?) {
        var user = User(userID: "0")
        user.loginName = loginName
        user.password = password
        user.permission = User.PERMISSION_ADMINUSER
        
        onSucceed?(user)
    }
    
    func getSiteListWithAggrData(sessionID: String, onSucceed: (([Site]) -> ())?, onFailed: ((IOTError) -> ())?) {
        var s1 = Site(siteID: "1")
        s1.siteName = "测试站点1"
        
        var d1 = Device(deviceID: "1")
        d1.adminDomain = "测试站点1"
        d1.deviceSN = "1111111111"
        s1.device = d1
        
        let data1 = IOTMonitorData(co2: 926, temperature: 32.1, humidity: 77)
        s1.aggregationData = data1
        
        
        var s2 = Site(siteID: "2")
        s2.siteName = "测试站点2"
        
        var d2 = Device(deviceID: "2")
        d2.adminDomain = "测试站点2"
        d2.deviceSN = "1111111112"
        s2.device = d2
        
        let data2 = IOTMonitorData(co2: 602.98, temperature: 23.9, humidity: 52)
        s2.aggregationData = data2
        
        var s3 = Site(siteID: "3")
        s3.siteName = "测试站点3"
        
        var d3 = Device(deviceID: "3")
        d3.adminDomain = "测试站点3"
        d3.deviceSN = "1111111113"
        s3.device = d3
        
        let data3 = IOTMonitorData(co2: 810.6, temperature: 25.1, humidity: 16)
        s3.aggregationData = data3
        
        onSucceed?([s1, s2, s3])
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
    
}