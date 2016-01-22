//
//  NotificationManager.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 1/22/16.
//  Copyright © 2016 SL Studio. All rights reserved.
//

import Foundation

class NotificationManager{
    static let sharedInstance = NotificationManager()
    
    private init(){
    }
    
    func registerPushNotification(){
        if Double(UIDevice.currentDevice().systemVersion) < 8.0 {
            UIApplication.sharedApplication().registerForRemoteNotificationTypes([UIRemoteNotificationType.Alert, UIRemoteNotificationType.Sound, UIRemoteNotificationType.Badge])
        }else{
            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Sound, UIUserNotificationType.Badge], categories: nil))
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
    }
    
    
    func registerToServer(token: String, onSucceed: (() -> ())?, onFailed: ((IOTError) -> ())?) {
        
        if let sessionID = SessionManager.sharedInstance.session?.sessionID,
            username = SessionManager.sharedInstance.loginUser?.loginName {
                
                let deviceKey = UUIDManager.sharedInstance.getUUID()
                
                IOTServer.getServer().registerDeviceBinding(sessionID,
                    username: username,
                    token: token,
                    deviceKey: deviceKey,
                    onSucceed: { (status) -> () in
                        if status == "Ok" {
                            onSucceed?()
                        }else{
                            onFailed?(IOTError(errorCode: IOTError.RegisterNotificationError, errorGroup: "registerToServer"))
                        }
                    },
                    onFailed: { (error) ->() in
                        onFailed?(error)
                    }
                    
                )
                
        }else{
            onFailed?(IOTError(errorCode: IOTError.InvalidSessionError, errorGroup: "registerToServer"))
        }
    }
}