//
//  PreferenceManager.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/23/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation

class PreferenceManager{
    
    static let sharedInstance = PreferenceManager()
    
    private let userDefaults:NSUserDefaults
    
    private init(){
        userDefaults =  NSUserDefaults.standardUserDefaults();
    }
    
    func valueForKey(key: String) -> String?{
        return (userDefaults.valueForKey(key) as? String)
    }
    
    func setValue(value: String?, forKey: String){
        userDefaults.setValue(value, forKey: forKey)
        userDefaults.synchronize()
    }
}