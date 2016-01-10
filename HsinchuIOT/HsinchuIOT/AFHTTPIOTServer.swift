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
    
    var xmlManager: AFHTTPRequestOperationManager!
    
    var jsonManager: AFHTTPRequestOperationManager!
    
    init(){
        xmlManager = AFHTTPRequestOperationManager()
        xmlManager.responseSerializer = AFXMLDictionaryResponseSerializer()
        
        jsonManager = AFHTTPRequestOperationManager()
        jsonManager.responseSerializer = AFJSONResponseSerializer()
    }
    
    func cancelAllRequests(){
        xmlManager.operationQueue.cancelAllOperations()
        jsonManager.operationQueue.cancelAllOperations()
    }
    
    func getSessionID(onSucceed: ((Session) -> ())?, onFailed: ((IOTError) -> ())?) {
        let url = serverAddress + ServerAPIURI.GET_SESSION_ID
        xmlManager.GET(
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
            
            xmlManager.POST(
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
            
        jsonManager.GET(
            url,
            parameters: parameters,
            success: { (operation, response) -> Void in
                //print(response)
                
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
        
        xmlManager.GET(
            url,
            parameters: parameters,
            success: { (operation, response) -> Void in
                //print(response)
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
                onFailed?(error.error("GetDeviceList"))
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
        
        
        
        xmlManager.GET(
            url,
            parameters: parameters,
            success: { (operation, response) -> Void in
                //print(response)
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
                onFailed?(error.error("getMultipleDevicesRealtimeData"))
        })

        
    }
    
    func getDeviceRealtimeData(sessionID: String, deviceID: String, onSucceed: ((IOTMonitorData?) -> ())?, onFailed: ((IOTError) -> ())?) {
        //print("sending request for device:\(deviceID))")
        
        let url = serverAddress + ServerAPIURI.GET_DEVICE_REALTIME_DATA
        
        var parameters = [
            "dataType": "xml",
            "__session_id": sessionID,
            "__page_no": "1",
            "__column": "did,sensor,name,value,t",
            "__having_max": "id",
            "__group_by": "did,name",
            "__sort": "-id",
            "did[0]": deviceID ]
        
        xmlManager.GET(
            url,
            parameters: parameters,
            success: { (operation, response) -> Void in
                //print(response)
                //print("get response for device:\(deviceID))")
                var error: IOTError? = IOTError(errorCode: IOTError.InvalidMessageError, errorGroup: "getDeviceRealtimeData")
                
                if let responseName = response.valueForKey?("__name") as? String{
                    if responseName == "NBIResponse" {
                        if let dataDictList = response.valueForKey?("Items")?.valueForKey?("Item") as? [AnyObject] {
                            var data: IOTMonitorData? = nil
                            
                            for dataDict in dataDictList {
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
                            }
                            
                            error = nil
                            onSucceed?(data)
                        }
                    }else if responseName == "NBIError" {
                        if let errorCodeStr = response.valueForKey?("Code") as? String{
                            if let errorCode = Int(errorCodeStr){
                                if let errorMsg = response.valueForKey?("String") as? String{
                                    error = IOTError(errorCode: errorCode, errorMsg: errorMsg, errorGroup: "getDeviceRealtimeData")
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
                onFailed?(error.error("getDeviceRealtimeData"))
                
        })
        
        //print("sended request for device:\(deviceID))")

    }
    
    func getDeviceRealtimeDataList(sessionID: String, deviceID: String, recordNumber: Int, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        
        let url = serverAddress + ServerAPIURI.GET_DEVICE_REALTIME_DATA_LIST
        
        var parameters = [
            "dataType": "xml",
            "__session_id": sessionID,
            "__page_no": "1",
            "__column": "name,value,t",
            "__page_size": "\(recordNumber)",
            "__group_by": "did,name",
            "__sort": "-id",
            "did[0]": deviceID ]
        
        xmlManager.GET(
            url,
            parameters: parameters,
            success: { (operation, response) -> Void in
                //print(response)
                //print("get response for device:\(deviceID))")
                var error: IOTError? = IOTError(errorCode: IOTError.InvalidMessageError, errorGroup: "getDeviceRealtimeDataList")
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                
                if let responseName = response.valueForKey?("__name") as? String{
                    if responseName == "NBIResponse" {
                        if let dataDictList = response.valueForKey?("Items")?.valueForKey?("Item") as? [AnyObject] {
                            var result: [IOTSampleData] = []
                            
                            for dataDict in dataDictList {
                                if let name = dataDict.valueForKey?("name") as? String {
                                    var data = IOTSampleData()
                                    
                                    if name == AFHTTPIOTServer.NAME_CO2 {
                                        data.type = IOTSampleData.SampleType.CO2
                                    }else if name == AFHTTPIOTServer.NAME_TEMPERATURE || name == AFHTTPIOTServer.NAME_TEMPERATURE_FULL {
                                        data.type = IOTSampleData.SampleType.Temperature
                                    }else if name == AFHTTPIOTServer.NAME_HUMIDITY {
                                        data.type = IOTSampleData.SampleType.Humidity
                                    }
                                    
                                    if let value = dataDict.valueForKey?("value") as? String {
                                        data.value = Float(value)
                                    }
                                    
                                    if let time = dataDict.valueForKey?("t") as? String {
                                        data.time = formatter.dateFromString(time)
                                    }
                                    result.append(data)
                                }
                            }
                            
                            error = nil
                            onSucceed?(result)
                        }
                    }else if responseName == "NBIError" {
                        if let errorCodeStr = response.valueForKey?("Code") as? String{
                            if let errorCode = Int(errorCodeStr){
                                if let errorMsg = response.valueForKey?("String") as? String{
                                    error = IOTError(errorCode: errorCode, errorMsg: errorMsg, errorGroup: "getDeviceRealtimeDataList")
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
                onFailed?(error.error("getDeviceRealtimeDataList"))
                
        })
        
    }
    
    func getDeviceAggregationDataListBy15Seconds(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        let url = serverAddress + ServerAPIURI.GET_DEVICE_AGGREGATION_DATA_LIST_BY_15S
        
        var parameters = [
            "dataType": "xml",
            "__session_id": sessionID,
            "__page_no": "1",
            "__column": "name,value,t",
            "__group_by": "did,name",
            "__sort": "-id",
            "did[0]": deviceID,
            "t__from": ReportUtil.getServerTimeString(from),
            "t__to": ReportUtil.getServerTimeString(to)
        ]
        
       xmlManager.GET(
            url,
            parameters: parameters,
            success: { (operation, response) -> Void in
                //print(response)
                //print("get response for device:\(deviceID))")
                var error: IOTError? = IOTError(errorCode: IOTError.InvalidMessageError, errorGroup: "getDeviceAggregationDataListBy15Seconds")
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                
                if let responseName = response.valueForKey?("__name") as? String{
                    if responseName == "NBIResponse" {
                        if let dataDictList = response.valueForKey?("Items")?.valueForKey?("Item") as? [AnyObject] {
                            var result: [IOTSampleData] = []
                            
                            for dataDict in dataDictList {
                                if let name = dataDict.valueForKey?("name") as? String {
                                    var data = IOTSampleData()
                                    
                                    if name == AFHTTPIOTServer.NAME_CO2 {
                                        data.type = IOTSampleData.SampleType.CO2
                                    }else if name == AFHTTPIOTServer.NAME_TEMPERATURE || name == AFHTTPIOTServer.NAME_TEMPERATURE_FULL {
                                        data.type = IOTSampleData.SampleType.Temperature
                                    }else if name == AFHTTPIOTServer.NAME_HUMIDITY {
                                        data.type = IOTSampleData.SampleType.Humidity
                                    }
                                    
                                    if let value = dataDict.valueForKey?("value") as? String {
                                        data.value = Float(value)
                                    }
                                    
                                    if let time = dataDict.valueForKey?("t") as? String {
                                        data.time = formatter.dateFromString(time)
                                    }
                                    result.append(data)
                                }
                            }
                            
                            error = nil
                            onSucceed?(result)
                        }
                    }else if responseName == "NBIError" {
                        if let errorCodeStr = response.valueForKey?("Code") as? String{
                            if let errorCode = Int(errorCodeStr){
                                if let errorMsg = response.valueForKey?("String") as? String{
                                    error = IOTError(errorCode: errorCode, errorMsg: errorMsg, errorGroup: "getDeviceAggregationDataListBy15Seconds")
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
                onFailed?(error.error("getDeviceAggregationDataListBy15Seconds"))
                
        })
    }
    
    func getDeviceAggregationDataListBy1Quarter(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        let url = serverAddress + ServerAPIURI.GET_DEVICE_AGGREGATION_DATA_LIST_BY_1Q
        
        var parameters = [
            "dataType": "xml",
            "__session_id": sessionID,
            "__page_no": "1",
            "__page_size": "10000",
            "__column": "did,name,value,quarter_in_epoch",
            "__group_by": "did,name,quarter_in_epoch",
            "__sort": "-id",
            "did[0]": deviceID,
            "quarter_in_epoch__from": ReportUtil.getServerTimeString(from),
            "quarter_in_epoch__to": ReportUtil.getServerTimeString(to)
        ]
        
        xmlManager.GET(
            url,
            parameters: parameters,
            success: { (operation, response) -> Void in
                //print(response)
                //print("get response for device:\(deviceID))")
                var error: IOTError? = IOTError(errorCode: IOTError.InvalidMessageError, errorGroup: "getDeviceAggregationDataListBy1Quarter")
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                
                if let responseName = response.valueForKey?("__name") as? String{
                    if responseName == "NBIResponse" {
                        if let dataDictList = response.valueForKey?("Items")?.valueForKey?("Item") as? [AnyObject] {
                            var result: [IOTSampleData] = []
                            
                            for dataDict in dataDictList {
                                if let name = dataDict.valueForKey?("name") as? String {
                                    var data = IOTSampleData()
                                    
                                    if name == AFHTTPIOTServer.NAME_CO2 {
                                        data.type = IOTSampleData.SampleType.CO2
                                    }else if name == AFHTTPIOTServer.NAME_TEMPERATURE || name == AFHTTPIOTServer.NAME_TEMPERATURE_FULL {
                                        data.type = IOTSampleData.SampleType.Temperature
                                    }else if name == AFHTTPIOTServer.NAME_HUMIDITY {
                                        data.type = IOTSampleData.SampleType.Humidity
                                    }
                                    
                                    if let value = dataDict.valueForKey?("value") as? String {
                                        data.value = Float(value)
                                    }
                                    
                                    if let time = dataDict.valueForKey?("quarter_in_epoch") as? String {
                                        data.time = formatter.dateFromString(time)
                                    }
                                    result.append(data)
                                }
                            }
                            
                            error = nil
                            onSucceed?(result)
                        }
                    }else if responseName == "NBIError" {
                        if let errorCodeStr = response.valueForKey?("Code") as? String{
                            if let errorCode = Int(errorCodeStr){
                                if let errorMsg = response.valueForKey?("String") as? String{
                                    error = IOTError(errorCode: errorCode, errorMsg: errorMsg, errorGroup: "getDeviceAggregationDataListBy1Quarter")
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
                onFailed?(error.error("getDeviceAggregationDataListBy1Quarter"))
                
        })
    }
    
    func getDeviceAggregationDataListBy1Hour(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        let url = serverAddress + ServerAPIURI.GET_DEVICE_AGGREGATION_DATA_LIST_BY_1H
        
        var parameters = [
            "dataType": "xml",
            "__session_id": sessionID,
            "__page_no": "1",
            "__page_size": "10000",
            "__column": "did,name,value,hour_in_epoch",
            "__group_by": "did,name,hour_in_epoch",
            "__sort": "-id",
            "did[0]": deviceID,
            "hour_in_epoch__from": ReportUtil.getServerTimeString(from),
            "hour_in_epoch__to": ReportUtil.getServerTimeString(to)
        ]
        
        xmlManager.GET(
            url,
            parameters: parameters,
            success: { (operation, response) -> Void in
                //print(response)
                //print("get response for device:\(deviceID))")
                var error: IOTError? = IOTError(errorCode: IOTError.InvalidMessageError, errorGroup: "getDeviceAggregationDataListBy1Hour")
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                
                if let responseName = response.valueForKey?("__name") as? String{
                    if responseName == "NBIResponse" {
                        if let dataDictList = response.valueForKey?("Items")?.valueForKey?("Item") as? [AnyObject] {
                            var result: [IOTSampleData] = []
                            
                            for dataDict in dataDictList {
                                if let name = dataDict.valueForKey?("name") as? String {
                                    var data = IOTSampleData()
                                    
                                    if name == AFHTTPIOTServer.NAME_CO2 {
                                        data.type = IOTSampleData.SampleType.CO2
                                    }else if name == AFHTTPIOTServer.NAME_TEMPERATURE || name == AFHTTPIOTServer.NAME_TEMPERATURE_FULL {
                                        data.type = IOTSampleData.SampleType.Temperature
                                    }else if name == AFHTTPIOTServer.NAME_HUMIDITY {
                                        data.type = IOTSampleData.SampleType.Humidity
                                    }
                                    
                                    if let value = dataDict.valueForKey?("value") as? String {
                                        data.value = Float(value)
                                    }
                                    
                                    if let time = dataDict.valueForKey?("hour_in_epoch") as? String {
                                        data.time = formatter.dateFromString(time)
                                    }
                                    result.append(data)
                                }
                            }
                            
                            error = nil
                            onSucceed?(result)
                        }
                    }else if responseName == "NBIError" {
                        if let errorCodeStr = response.valueForKey?("Code") as? String{
                            if let errorCode = Int(errorCodeStr){
                                if let errorMsg = response.valueForKey?("String") as? String{
                                    error = IOTError(errorCode: errorCode, errorMsg: errorMsg, errorGroup: "getDeviceAggregationDataListBy1Hour")
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
                onFailed?(error.error("getDeviceAggregationDataListBy1Hour"))
                
        })
    }
    
    
    func getDeviceAggregationDataListBy8Hours(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        let url = serverAddress + ServerAPIURI.GET_DEVICE_AGGREGATION_DATA_LIST_BY_8H
        
        var parameters = [
            "dataType": "xml",
            "__session_id": sessionID,
            "__page_no": "1",
            "__page_size": "10000",
            "__column": "did,name,value,hours_in_epoch",
            "__group_by": "did,name,hours_in_epoch",
            "__sort": "-id",
            "did[0]": deviceID,
            "hours_in_epoch__from": ReportUtil.getServerTimeString(from),
            "hours_in_epoch__to": ReportUtil.getServerTimeString(to)
        ]
        xmlManager.GET(
            url,
            parameters: parameters,
            success: { (operation, response) -> Void in
                //print(response)
                //print("get response for device:\(deviceID))")
                var error: IOTError? = IOTError(errorCode: IOTError.InvalidMessageError, errorGroup: "getDeviceAggregationDataListBy8Hours")
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                
                if let responseName = response.valueForKey?("__name") as? String{
                    if responseName == "NBIResponse" {
                        if let dataDictList = response.valueForKey?("Items")?.valueForKey?("Item") as? [AnyObject] {
                            var result: [IOTSampleData] = []
                            
                            for dataDict in dataDictList {
                                if let name = dataDict.valueForKey?("name") as? String {
                                    var data = IOTSampleData()
                                    
                                    if name == AFHTTPIOTServer.NAME_CO2 {
                                        data.type = IOTSampleData.SampleType.CO2
                                    }else if name == AFHTTPIOTServer.NAME_TEMPERATURE || name == AFHTTPIOTServer.NAME_TEMPERATURE_FULL {
                                        data.type = IOTSampleData.SampleType.Temperature
                                    }else if name == AFHTTPIOTServer.NAME_HUMIDITY {
                                        data.type = IOTSampleData.SampleType.Humidity
                                    }
                                    
                                    if let value = dataDict.valueForKey?("value") as? String {
                                        data.value = Float(value)
                                    }
                                    
                                    if let time = dataDict.valueForKey?("hours_in_epoch") as? String {
                                        data.time = formatter.dateFromString(time)
                                    }
                                    result.append(data)
                                }
                            }
                            
                            error = nil
                            onSucceed?(result)
                        }
                    }else if responseName == "NBIError" {
                        if let errorCodeStr = response.valueForKey?("Code") as? String{
                            if let errorCode = Int(errorCodeStr){
                                if let errorMsg = response.valueForKey?("String") as? String{
                                    error = IOTError(errorCode: errorCode, errorMsg: errorMsg, errorGroup: "getDeviceAggregationDataListBy8Hours")
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
                onFailed?(error.error("getDeviceAggregationDataListBy8Hours"))
                
        })
    }
    
    func getDeviceAggregationDataListBy1Day(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        let url = serverAddress + ServerAPIURI.GET_DEVICE_AGGREGATION_DATA_LIST_BY_1D
        
        var parameters = [
            "dataType": "xml",
            "__session_id": sessionID,
            "__page_no": "1",
            "__page_size": "10000",
            "__column": "did,name,value,day_in_epoch",
            "__group_by": "did,name,day_in_epoch",
            "__sort": "-id",
            "did[0]": deviceID,
            "day_in_epoch__from": ReportUtil.getServerTimeString(from),
            "day_in_epoch__to": ReportUtil.getServerTimeString(to)
        ]
        
        xmlManager.GET(
            url,
            parameters: parameters,
            success: { (operation, response) -> Void in
                //print(response)
                //print("get response for device:\(deviceID))")
                var error: IOTError? = IOTError(errorCode: IOTError.InvalidMessageError, errorGroup: "getDeviceAggregationDataListBy1Day")
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                
                if let responseName = response.valueForKey?("__name") as? String{
                    if responseName == "NBIResponse" {
                        if let dataDictList = response.valueForKey?("Items")?.valueForKey?("Item") as? [AnyObject] {
                            var result: [IOTSampleData] = []
                            
                            for dataDict in dataDictList {
                                if let name = dataDict.valueForKey?("name") as? String {
                                    var data = IOTSampleData()
                                    
                                    if name == AFHTTPIOTServer.NAME_CO2 {
                                        data.type = IOTSampleData.SampleType.CO2
                                    }else if name == AFHTTPIOTServer.NAME_TEMPERATURE || name == AFHTTPIOTServer.NAME_TEMPERATURE_FULL {
                                        data.type = IOTSampleData.SampleType.Temperature
                                    }else if name == AFHTTPIOTServer.NAME_HUMIDITY {
                                        data.type = IOTSampleData.SampleType.Humidity
                                    }
                                    
                                    if let value = dataDict.valueForKey?("value") as? String {
                                        data.value = Float(value)
                                    }
                                    
                                    if let time = dataDict.valueForKey?("day_in_epoch") as? String {
                                        data.time = formatter.dateFromString(time)
                                    }
                                    result.append(data)
                                }
                            }
                            
                            error = nil
                            onSucceed?(result)
                        }
                    }else if responseName == "NBIError" {
                        if let errorCodeStr = response.valueForKey?("Code") as? String{
                            if let errorCode = Int(errorCodeStr){
                                if let errorMsg = response.valueForKey?("String") as? String{
                                    error = IOTError(errorCode: errorCode, errorMsg: errorMsg, errorGroup: "getDeviceAggregationDataListBy1Day")
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
                onFailed?(error.error("getDeviceAggregationDataListBy1Day"))
                
        })
    }
    
    func getDeviceAggregationDataListBy1Week(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        let url = serverAddress + ServerAPIURI.GET_DEVICE_AGGREGATION_DATA_LIST_BY_1W
        
        var parameters = [
            "dataType": "xml",
            "__session_id": sessionID,
            "__page_no": "1",
            "__page_size": "10000",
            "__column": "did,name,value,week_in_epoch",
            "__group_by": "did,name,week_in_epoch",
            "__sort": "-id",
            "did[0]": deviceID,
            "week_in_epoch__from": ReportUtil.getServerTimeString(from),
            "week_in_epoch__to": ReportUtil.getServerTimeString(to)
        ]
        
        xmlManager.GET(
            url,
            parameters: parameters,
            success: { (operation, response) -> Void in
                //print(response)
                //print("get response for device:\(deviceID))")
                var error: IOTError? = IOTError(errorCode: IOTError.InvalidMessageError, errorGroup: "getDeviceAggregationDataListBy1Week")
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                
                if let responseName = response.valueForKey?("__name") as? String{
                    if responseName == "NBIResponse" {
                        if let dataDictList = response.valueForKey?("Items")?.valueForKey?("Item") as? [AnyObject] {
                            var result: [IOTSampleData] = []
                            
                            for dataDict in dataDictList {
                                if let name = dataDict.valueForKey?("name") as? String {
                                    var data = IOTSampleData()
                                    
                                    if name == AFHTTPIOTServer.NAME_CO2 {
                                        data.type = IOTSampleData.SampleType.CO2
                                    }else if name == AFHTTPIOTServer.NAME_TEMPERATURE || name == AFHTTPIOTServer.NAME_TEMPERATURE_FULL {
                                        data.type = IOTSampleData.SampleType.Temperature
                                    }else if name == AFHTTPIOTServer.NAME_HUMIDITY {
                                        data.type = IOTSampleData.SampleType.Humidity
                                    }
                                    
                                    if let value = dataDict.valueForKey?("value") as? String {
                                        data.value = Float(value)
                                    }
                                    
                                    if let time = dataDict.valueForKey?("week_in_epoch") as? String {
                                        data.time = formatter.dateFromString(time)
                                    }
                                    result.append(data)
                                }
                            }
                            
                            error = nil
                            onSucceed?(result)
                        }
                    }else if responseName == "NBIError" {
                        if let errorCodeStr = response.valueForKey?("Code") as? String{
                            if let errorCode = Int(errorCodeStr){
                                if let errorMsg = response.valueForKey?("String") as? String{
                                    error = IOTError(errorCode: errorCode, errorMsg: errorMsg, errorGroup: "getDeviceAggregationDataListBy1Week")
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
                onFailed?(error.error("getDeviceAggregationDataListBy1Week"))
                
        })
    }
    
    func getDeviceAggregationDataListBy1Month(sessionID: String, deviceID: String, from: NSDate, to: NSDate, onSucceed: (([IOTSampleData]) -> ())?, onFailed: ((IOTError) -> ())?) {
        let url = serverAddress + ServerAPIURI.GET_DEVICE_AGGREGATION_DATA_LIST_BY_1M
        
        var parameters = [
            "dataType": "xml",
            "__session_id": sessionID,
            "__page_no": "1",
            "__page_size": "10000",
            "__column": "did,name,value,month_in_epoch",
            "__group_by": "did,name,month_in_epoch",
            "__sort": "-id",
            "did[0]": deviceID,
            "month_in_epoch__from": ReportUtil.getServerTimeString(from),
            "month_in_epoch__to": ReportUtil.getServerTimeString(to)
        ]
        
        xmlManager.GET(
            url,
            parameters: parameters,
            success: { (operation, response) -> Void in
                //print(response)
                //print("get response for device:\(deviceID))")
                var error: IOTError? = IOTError(errorCode: IOTError.InvalidMessageError, errorGroup: "getDeviceAggregationDataListBy1Month")
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                
                if let responseName = response.valueForKey?("__name") as? String{
                    if responseName == "NBIResponse" {
                        if let dataDictList = response.valueForKey?("Items")?.valueForKey?("Item") as? [AnyObject] {
                            var result: [IOTSampleData] = []
                            
                            for dataDict in dataDictList {
                                if let name = dataDict.valueForKey?("name") as? String {
                                    var data = IOTSampleData()
                                    
                                    if name == AFHTTPIOTServer.NAME_CO2 {
                                        data.type = IOTSampleData.SampleType.CO2
                                    }else if name == AFHTTPIOTServer.NAME_TEMPERATURE || name == AFHTTPIOTServer.NAME_TEMPERATURE_FULL {
                                        data.type = IOTSampleData.SampleType.Temperature
                                    }else if name == AFHTTPIOTServer.NAME_HUMIDITY {
                                        data.type = IOTSampleData.SampleType.Humidity
                                    }
                                    
                                    if let value = dataDict.valueForKey?("value") as? String {
                                        data.value = Float(value)
                                    }
                                    
                                    if let time = dataDict.valueForKey?("month_in_epoch") as? String {
                                        data.time = formatter.dateFromString(time)
                                    }
                                    result.append(data)
                                }
                            }
                            
                            error = nil
                            onSucceed?(result)
                        }
                    }else if responseName == "NBIError" {
                        if let errorCodeStr = response.valueForKey?("Code") as? String{
                            if let errorCode = Int(errorCodeStr){
                                if let errorMsg = response.valueForKey?("String") as? String{
                                    error = IOTError(errorCode: errorCode, errorMsg: errorMsg, errorGroup: "getDeviceAggregationDataListBy1Month")
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
                onFailed?(error.error("getDeviceAggregationDataListBy1Month"))
                
        })
    }
}