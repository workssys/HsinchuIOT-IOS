//
//  User.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/21/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation

struct User{
    static let PERMISSION_ADMINUSER = "65664,65705,65664,0"
    static let PERMISSION_USER = "0,33,0,0"
    
    let userID: String
    var loginName: String?
    var password: String?
    var permission: String?
    
    init(userID: String){
        self.userID = userID
    }
    
    func isAdminUser() -> Bool{
        if let permStr = permission {
            return permStr == User.PERMISSION_ADMINUSER
        }else{
            return false
        }
    }
    
    func isNormalUser() -> Bool{
        if let permStr = permission {
            return permStr == User.PERMISSION_USER
        }else{
            return false
        }
    }
}