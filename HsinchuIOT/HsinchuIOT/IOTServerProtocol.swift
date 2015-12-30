//
//  IOTServerProtocol.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/19/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation

protocol IOTServerProtocol{
    func getSessionID(onSucceed: ((Session) -> ())?, onFailed: ((IOTError) -> ())?)
    func login(sessionID: String, loginName: String, password: String, onSucceed:((User) -> ())?, onFailed: ((IOTError) -> ())?)
    func getSiteListWithAggrData(sessionID: String, onSucceed:(([Site]) -> ())?, onFailed:((IOTError) -> ())?)
    
    func getDeviceList(sessionID: String, onSucceed:(([Device]) -> ())?, onFailed: ((IOTError) -> ())?)
    
    func getMultipleDevicesRealtimeData(sessionID: String, deviceList: [Device], onSucceed: (([String:IOTMonitorData]) -> ())?, onFailed: ((IOTError) -> ())?)
}

class IOTServer{
    //static let serverInstance = MockServer()
    static let serverInstance = AFHTTPIOTServer()
    
    static func getServer() -> IOTServerProtocol {
        return serverInstance
    }
}