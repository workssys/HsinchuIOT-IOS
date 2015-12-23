//
//  PreferenceManager.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/23/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation

class PreferenceManager{
    class var instance: PreferenceManager{
        struct Singleton{
            static var onceToken: dispatch_once_t = 0
            static var _instance: PreferenceManager? = nil
        }
        
        dispatch_once(&Singleton.onceToken){
            Singleton._instance = PreferenceManager()
        }
        
        return Singleton._instance!
        
    }
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func valueForKey(key: String) -> String?{
        return (userDefaults.valueForKey(key) as? String)
    }
    
    func setValue(value: String?, forKey: String){
        userDefaults.setValue(value, forKey: forKey)
        userDefaults.synchronize()
    }
}