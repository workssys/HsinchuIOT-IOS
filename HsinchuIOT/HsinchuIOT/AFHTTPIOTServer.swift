//
//  AFHTTPIOTServer.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/19/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation

class AFHTTPIOTServer: IOTServerProtocol{
    var serverAddress: String {
        get{
            var url = AppConfig.PROTOCOL
            url += AppConfig.DOMAIN
            url += ":"
            url += String(AppConfig.PORT)
            url += "/"
            return url
        }
    }
    
    
    func getSessionID(onSucceed: ((Session) -> ())?, onFailed: ((IOTError) -> ())?) {
        let url = serverAddress + ServerAPIURI.GET_SESSION_ID
        var manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFXMLDictionaryResponseSerializer()
        manager.GET(
            url,
            parameters: ["dataType": "xml"],
            success: { (operation, response) -> Void in
                if let dict = response as? NSDictionary{
                    if let dict2 = dict.objectForKey("GetSessionIDResponse") as? NSDictionary{
                        if let sessionID = dict2.objectForKey("SessionID") as? String{
                            let session = Session(sessionID: sessionID)
                            if let succeedFunc = onSucceed {
                                succeedFunc(session)
                            }
                        } else {
                            if let failedFunc = onFailed {
                                failedFunc(IOTError(errorCode: -1, errorMsg: "Unknown Error"))
                            }
                        }
                    }else{
                        if let failedFunc = onFailed {
                            failedFunc(IOTError(errorCode: -1, errorMsg: "Unknown Error"))
                        }
                    }
                }else{
                    if let failedFunc = onFailed {
                        failedFunc(IOTError(errorCode: -1, errorMsg: "Unknown Error"))
                    }
                }
            }, failure: { (operation, error) -> Void in
                if let failedFunc = onFailed {
                    failedFunc(error.error)
                }
            })
    }
    
    func login(sessionID: String,
        loginName: String,
        password: String,
        onSucceed: ((User) -> ())?,
        onFailed: ((IOTError)->())?) {
            let url = serverAddress + ServerAPIURI.LOGIN
            
            let pwdMD5: String = password.md5
            let mangledPWD = (pwdMD5 + ":" + sessionID).md5
           
            let parameters = ["dataType": "xml", "__session_id": sessionID, "username": loginName, "mangled_password": mangledPWD, "lang": "zh-cn", "timezone": "-480"]
            
            var manager = AFHTTPRequestOperationManager()
            manager.responseSerializer  = AFXMLDictionaryResponseSerializer()
            manager.POST(
                url,
                parameters: parameters,
                success: {(operation, response) -> Void in
                    print(operation.responseString)
                    if let dict = response as? NSDictionary{
                        if let responseName = dict.valueForKey("__name") as? String {
                            if responseName == "NBIResponse" {
                                if let dict2 = dict.valueForKey("LoginResponse") as? NSDictionary{
                                    if let userID = dict2.valueForKey("user_id") as? String {
                                        var user = User(userID: userID)
                                        user.loginName = loginName
                                        user.password = password
                                        
                                        if let permission = dict2.valueForKey("permission") as? String{
                                            user.permission = permission
                                        }
                                        
                                        if let succeedFunc = onSucceed {
                                            succeedFunc(user)
                                        }
                                        
                                        
                                    }else{
                                        if let failedFunc = onFailed {
                                            failedFunc(IOTError(errorCode: -2, errorMsg: "Invalid User"))
                                        }
                                    }
                                }else{
                                    if let failedFunc = onFailed {
                                        failedFunc(IOTError(errorCode: -3, errorMsg: "Invalid Message"))
                                    }
                                }
                            } else if responseName == "NBIError" {
                                var errorCode: Int? = nil
                                
                                if let errorCodeStr = dict.valueForKey("Code") as? String{
                                    errorCode = Int(errorCodeStr)
                                    
                                }
                                if(errorCode == nil){
                                    errorCode = -1
                                }
                                
                                var errorMsg: String? = nil
                                if let msg = dict.valueForKey("String") as? String {
                                    errorMsg = msg
                                }else{
                                    errorMsg = "Unknown Error"
                                }
                                
                                if let failedFunc = onFailed {
                                    failedFunc(IOTError(errorCode: errorCode!, errorMsg: errorMsg))
                                }

                            }else{
                                if let failedFunc = onFailed {
                                    failedFunc(IOTError(errorCode: -1, errorMsg: "Unknown Error"))
                                }
                            }
                        }else{
                            if let failedFunc = onFailed {
                                failedFunc(IOTError(errorCode: -1, errorMsg: "Unknown Error"))
                            }
                        }
                    }else{
                        if let failedFunc = onFailed {
                            failedFunc(IOTError(errorCode: -1, errorMsg: "Unknown Error"))
                        }
                    }
                    
                },
                failure: {(operation, error) -> Void in
                    if let failedFunc = onFailed {
                        failedFunc(error.error)
                    }
                }
        )

    }
}