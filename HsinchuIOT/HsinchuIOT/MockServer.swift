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
        
        var sites = [s1, s2, s3]
        
        onSucceed?(sites)
    }
    
    
}