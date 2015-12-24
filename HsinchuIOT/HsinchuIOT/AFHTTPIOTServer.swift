//
//  AFHTTPIOTServer.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/19/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation
import CryptoSwift

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
                var error: IOTError? = IOTError(errorCode: IOTError.InvalidMessageError, errorGroup: "GetSessionID")
                
                if let responseName = response.valueForKey?("__name") as? String{
                    if responseName == "NBIResponse" {
                        if let sessionID = response.valueForKey?("GetSessionIDResponse")?.valueForKey?("SessionID") as? String {
                            error = nil
                            onSucceed?(Session(sessionID: sessionID))
                        }
                    }else if responseName == "NBIError" {
                        if let errorCodeStr = response.valueForKey?("Code") as? String{
                            if let errorCode = Int(errorCodeStr){
                                if let errorMsg = response.valueForKey?("String") as? String{
                                    error = IOTError(errorCode: errorCode, errorMsg: errorMsg, errorGroup: "GetSessionID")
                                }
                            }
                        }
                    }
                }
                
                if error != nil{
                    onFailed?(error!)
                }
                
            }, failure: { (operation, error) -> Void in
                onFailed?(error.error("GetSessionID"))
            })
    }
    
    func login(sessionID: String,
        loginName: String,
        password: String,
        onSucceed: ((User) -> ())?,
        onFailed: ((IOTError)->())?) {
            let url = serverAddress + ServerAPIURI.LOGIN
            
            let pwdMD5: String = password.md5()
            let mangledPWD = (pwdMD5 + ":" + sessionID).md5()
           
            let parameters = ["dataType": "xml", "__session_id": sessionID, "username": loginName, "mangled_password": mangledPWD, "lang": "zh-cn", "timezone": "-480"]
            
            var manager = AFHTTPRequestOperationManager()
            manager.responseSerializer  = AFXMLDictionaryResponseSerializer()
            manager.POST(
                url,
                parameters: parameters,
                success: {(operation, response) -> Void in
                    var error: IOTError? = IOTError(errorCode: IOTError.InvalidMessageError, errorGroup: "Login")
                    
                    if let responseName = response.valueForKey?("__name") as? String{
                        if responseName == "NBIResponse" {
                            if let userID = response.valueForKey?("LoginResponse")?.valueForKey?("user_id") as? String {
                                var user = User(userID: userID)
                                user.loginName = loginName
                                user.password = password
                                if let permission = response.valueForKey?("LoginResponse")?.valueForKey?("permission") as? String{
                                    user.permission = permission
                                }
                                error = nil
                                onSucceed?(user)
                            }
                        }else if responseName == "NBIError" {
                            if let errorCodeStr = response.valueForKey?("Code") as? String{
                                if let errorCode = Int(errorCodeStr){
                                    if let errorMsg = response.valueForKey?("String") as? String{
                                        error = IOTError(errorCode: errorCode, errorMsg: errorMsg, errorGroup: "Login")
                                    }
                                }
                            }
                        }
                    }
                    
                    if error != nil{
                        onFailed?(error!)
                    }
                    
                },
                failure: {(operation, error) -> Void in
                    onFailed?(error.error("Login"))
                }
        )

    }
}