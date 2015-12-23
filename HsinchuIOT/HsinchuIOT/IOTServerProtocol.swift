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
}

class IOTServer{
    struct Instance{
        static var onceToken: dispatch_once_t = 0
        static var _singleton: IOTServerProtocol? = nil
    }
    
    class func getServer() -> IOTServerProtocol {
        dispatch_once(&Instance.onceToken){
            Instance._singleton = AFHTTPIOTServer()
        }
        return Instance._singleton!
    }
}