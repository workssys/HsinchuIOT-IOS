//
//  Constants.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/9/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation

struct PreferenceKey {
    static let SESSIONID = "SESSION_ID"
    static let LOGINNAME = "LOGIN_NAME"
    static let PASSWORD = "PASSWORD"
    static let LANGUAGE = "LANGUAGE"
    static let SYSTEM_LANGUAGE = "AppleLanguages"
    
}

struct StringKey{
    static let LOGINNAME_HINT = "LOGINNAME_HIHT"
    static let PASSWORD_HINT = "PASSWORD_HINT"
    static let REMEMBER_ME = "LOGIN_REMEMBER_ME"
    static let LOGIN_BTN = "LOGIN_LOGIN_BTN"
    static let APP_TITLE_1 = "APP_TITLE_1"
    static let APP_TITLE_2 = "APP_TITLE_2"
    
    static let OK = "OK"
    
    static let ERROR_TITLE = "ERROR_TITLE"
    static let ERROR_NOT_INPUT_LOGINNAME = "ERROR_NOT_INPUT_LOGINNAME"
    static let ERROR_NOT_INPUT_PASSWORD = "ERROR_NOT_INPUT_PASSWORD"
}

struct Colors{
    static let BK_BLUE = UIColor ( red: 0.4199, green: 0.7361, blue: 1.0, alpha: 1.0 )
    
    static let TEXT_BLUE = UIColor(rgba: "#448ccb")
    
    static let BORDER = UIColor.lightGrayColor()
    static let TEXT = UIColor.darkGrayColor()
}