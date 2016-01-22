//
//  UUIDManager.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 1/22/16.
//  Copyright © 2016 SL Studio. All rights reserved.
//

import Foundation

class UUIDManager{
    static let sharedInstance = UUIDManager()
    
    private init(){
        
    }
    
    func getUUID() -> String {
        if let uuid = PreferenceManager.sharedInstance.valueForKey(PreferenceKey.UUID){
            return uuid
        }
        let newUUID = NSUUID().UUIDString
        PreferenceManager.sharedInstance.setValue(newUUID, forKey: PreferenceKey.UUID)
        return newUUID
    }
}