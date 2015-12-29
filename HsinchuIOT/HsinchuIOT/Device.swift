//
//  Device.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/27/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation

struct Device {
    let deviceID: String
    var deviceSN: String?
    var adminDomain: String?
    
    var siteName: String{
        if let domain = adminDomain{
            if let lastIndex = domain.lastIndexOf(":"){
                return (domain as NSString).substringFromIndex(lastIndex + 1)
            }else{
                return domain
            }
        }else{
            return "Unknown"
        }
    }
    
    init(deviceID: String){
        self.deviceID = deviceID
    }
    
}