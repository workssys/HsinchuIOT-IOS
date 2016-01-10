//
//  IOTServerProtocol.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/19/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation

protocol IOTServerProtocol{
    func cancelAllRequests()
    
    func getSessionID(onSucceed: ((Session) -> ())?, onFailed: ((IOTError) -> ())?)
    
    func login(sessionID: String, loginName: String, password: String, onSucceed:((User) -> ())?, onFailed: ((IOTError) -> ())?)
    
    func getSiteListWithAggrData(sessionID: String, onSucceed:(([Site]) -> ())?, onFailed:((IOTError) -> ())?)
    
    func getDeviceList(sessionID: String, onSucceed:(([Device]) -> ())?, onFailed: ((IOTError) -> ())?)
    
    func getMultipleDevicesRealtimeData(sessionID: String, deviceList: [Device], onSucceed: (([String:IOTMonitorData]) -> ())?, onFailed: ((IOTError) -> ())?)
    
    func getDeviceRealtimeData(sessionID: String, deviceID: String, onSucceed: ((IOTMonitorData?) -> ())?, onFailed: ((IOTError) ->())?)
    
    func getDeviceRealtimeDataList(sessionID: String, deviceID: String, recordNumber: Int, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?)
    
    func getDeviceAggregationDataListBy15Seconds(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed:(([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?)
    
    func getDeviceAggregationDataListBy1Quarter(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed:(([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?)
    
    func getDeviceAggregationDataListBy1Hour(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed:(([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?)
    
    func getDeviceAggregationDataListBy8Hours(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed:(([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?)
    
    func getDeviceAggregationDataListBy1Day(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed:(([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?)
    
    func getDeviceAggregationDataListBy1Week(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed:(([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?)
    
    func getDeviceAggregationDataListBy1Month(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed:(([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?)

    
}

class IOTServer{
    static let serverInstance = MockServer()
    //static let serverInstance = AFHTTPIOTServer()
    
    static func getServer() -> IOTServerProtocol {
        return serverInstance
    }
}