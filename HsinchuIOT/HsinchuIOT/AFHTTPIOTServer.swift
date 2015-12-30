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
    
    static let NAME_CO2 = "CO2"
    static let NAME_TEMPERATURE = "Temp"
    static let NAME_TEMPERATURE_FULL = "Temperature"
    static let NAME_HUMIDITY = "Humidity"
    
    
    var serverAddress: String {
        get{
            var url: String
            if AppConfig.TEST {
                url = "http://60.30.32.20:33661/"
            }else{
                url = AppConfig.PROTOCOL
                url += AppConfig.DOMAIN
                url += ":"
                url += String(AppConfig.PORT)
                url += "/"
            }
            
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
    
    func getSiteListWithAggrData(sessionID: String,
        onSucceed: (([Site]) -> ())?,
        onFailed: ((IOTError) -> ())?) {
        
        let url = serverAddress + ServerAPIURI.GET_SITE_LIST_WITH_AGGREGATION_DATA
        let parameters = ["dataType": "json", "__session_id": sessionID]
            
        var manager = AFHTTPRequestOperationManager()
        manager.responseSerializer  = AFJSONResponseSerializer()
        manager.GET(
            url,
            parameters: parameters,
            success: { (operation, response) -> Void in
                print(response)
                
                var symbol: String
                if AppConfig.TEST {
                    symbol = "@"
                }else {
                    symbol = "$"
                }
                var result: [Site] = []
                if let count = response.objectForKey("count") as? Int{
                    for i in 1 ... count{
                        
                        if let siteObj = response.objectForKey("\(i)") {
                            if let deviceID = siteObj.objectForKey("did")?.objectForKey(symbol) as? Int{
                                
                                var site: Site = Site(siteID: "\(deviceID)")
                                
                                var device = Device(deviceID: "\(deviceID)")
                                
                                if let deviceSN = siteObj.objectForKey("sn")?.objectForKey(symbol) as? String{
                                    device.deviceSN = deviceSN
                                }
                                if let domainName = siteObj.objectForKey("domain_name")?.objectForKey(symbol) as? String{
                                    device.adminDomain = domainName
                                }
                                site.device = device
                                site.siteName = device.siteName
                                
                                var iotData = IOTMonitorData()
                                if let co2Value = siteObj.objectForKey("co2_eight_hours_avg")?.objectForKey(symbol) as? String{
                                    if let value = Float(co2Value) {
                                        iotData.co2 = ceil(value * 100) / 100
                                    }
                                }
                                if let temperatureValue = siteObj.objectForKey("temp_hour_avg")?.objectForKey(symbol) as? String{
                                    if let value = Float(temperatureValue){
                                        iotData.temperature = ceil(value * 100) / 100
                                    }
                                }
                                if let humidityValue = siteObj.objectForKey("humidity_hour_avg")?.objectForKey(symbol) as? String{
                                    if let value = Float(humidityValue){
                                        iotData.humidity = ceil(value * 100) / 100
                                    }
                                }
                                site.aggregationData = iotData
                                
                                result.append(site)
                            }
                        }
                    }
                    onSucceed?(result)
                }else{
                    onFailed?(IOTError(errorCode: IOTError.InvalidMessageError, errorGroup: "getSiteListWithAggrData"))
                }
                
            },
            failure: { (operation, error) -> Void in
                onFailed?(error.error("getSiteListWithAggrData"))
            })
    }
    
    func getDeviceList(sessionID: String,
        onSucceed: (([Device]) -> ())?,
        onFailed: ((IOTError) -> ())?) {
        
        let url = serverAddress + ServerAPIURI.GET_DEVICE_LIST
        let parameters = [
            "dataType": "xml",
            "__session_id": sessionID,
            "__page_no": "1",
            "__page_size": "1000",
            "__sort": "-id"]
        
        var manager = AFHTTPRequestOperationManager()
        manager.responseSerializer  = AFXMLDictionaryResponseSerializer()
        manager.GET(
            url,
            parameters: parameters,
            success: { (operation, response) -> Void in
                print(response)
                var error: IOTError? = IOTError(errorCode: IOTError.InvalidMessageError, errorGroup: "GetDeviceList")
                
                if let responseName = response.valueForKey?("__name") as? String{
                    if responseName == "NBIResponse" {
                        if let deviceDictList = response.valueForKey?("Items")?.valueForKey?("Item") as? [AnyObject] {
                            var deviceList: [Device] = []
                            
                            for deviceDict in deviceDictList {
                                if let deviceID = deviceDict.valueForKey?("id") as? String{
                                    var device = Device(deviceID: deviceID)
                                    
                                    if let adminDomain = deviceDict.valueForKey?("admin_domain")?.valueForKey?("__text") as? String{
                                        device.adminDomain = adminDomain
                                    }
                                    if let deviceSN = deviceDict.valueForKey?("sn") as? String {
                                        device.deviceSN = deviceSN
                                    }
                                    deviceList.append(device)
                                }
                            }
                            
                            error = nil
                            onSucceed?(deviceList)
                        }
                    }else if responseName == "NBIError" {
                        if let errorCodeStr = response.valueForKey?("Code") as? String{
                            if let errorCode = Int(errorCodeStr){
                                if let errorMsg = response.valueForKey?("String") as? String{
                                    error = IOTError(errorCode: errorCode, errorMsg: errorMsg, errorGroup: "GetDeviceList")
                                }
                            }
                        }
                    }
                }
                
                if error != nil{
                    onFailed?(error!)
                }

                
            },
            failure: { (operation, error) -> Void in
                onFailed?(error.error("getSiteListWithAggrData"))
        })

        
        
    }
    
    func getMultipleDevicesRealtimeData(sessionID: String, deviceList: [Device], onSucceed: (([String : IOTMonitorData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        
        
        let url = serverAddress + ServerAPIURI.GET_MULTIPLE_DEVICES_REALTIME_DATA
        
        var parameters = [
            "dataType": "xml",
            "__session_id": sessionID,
            "__page_no": "1",
            "__column": "did,sensor,name,value,t",
            "__having_max": "id",
            "__group_by": "did,name",
            "__sort": "-id"]
        
        for i in 0 ..< deviceList.count{
            parameters.updateValue(deviceList[i].deviceID, forKey: "did[\(i)]")
        }
        
        var manager = AFHTTPRequestOperationManager()
        manager.responseSerializer  = AFXMLDictionaryResponseSerializer()
        manager.GET(
            url,
            parameters: parameters,
            success: { (operation, response) -> Void in
                print(response)
                var error: IOTError? = IOTError(errorCode: IOTError.InvalidMessageError, errorGroup: "getMultipleDevicesRealtimeData")
                
                if let responseName = response.valueForKey?("__name") as? String{
                    if responseName == "NBIResponse" {
                        if let dataDictList = response.valueForKey?("Items")?.valueForKey?("Item") as? [AnyObject] {
                            var result: [String: IOTMonitorData] = [:]
                            
                            for dataDict in dataDictList {
                                if let deviceID = dataDict.valueForKey?("did")?.valueForKey?("_ref_val") as? String{
                                    var data: IOTMonitorData? = result[deviceID]
                                    if data == nil {
                                        data = IOTMonitorData()
                                    }
                                    
                                    if let name = dataDict.valueForKey?("name") as? String {
                                        if name == AFHTTPIOTServer.NAME_CO2 {
                                            if let value = dataDict.valueForKey?("value") as? String {
                                                data!.co2 = Float(value)
                                            }
                                        }else if name == AFHTTPIOTServer.NAME_TEMPERATURE || name == AFHTTPIOTServer.NAME_TEMPERATURE_FULL {
                                            if let value = dataDict.valueForKey?("value") as? String {
                                                data!.temperature = Float(value)
                                            }
                                        }else if name == AFHTTPIOTServer.NAME_HUMIDITY {
                                            if let value = dataDict.valueForKey?("value") as? String {
                                                data!.humidity = Float(value)
                                            }
                                        }
                                    }
                                    
                                    result.updateValue(data!, forKey: deviceID)
                                }
                            }
                            
                            error = nil
                            onSucceed?(result)
                        }
                    }else if responseName == "NBIError" {
                        if let errorCodeStr = response.valueForKey?("Code") as? String{
                            if let errorCode = Int(errorCodeStr){
                                if let errorMsg = response.valueForKey?("String") as? String{
                                    error = IOTError(errorCode: errorCode, errorMsg: errorMsg, errorGroup: "getMultipleDevicesRealtimeData")
                                }
                            }
                        }
                    }
                }
                
                if error != nil{
                    onFailed?(error!)
                }
                
                
            },
            failure: { (operation, error) -> Void in
                onFailed?(error.error("getSiteListWithAggrData"))
        })

        
    }
}