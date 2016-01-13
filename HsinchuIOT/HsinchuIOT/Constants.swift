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
    static let CANCEL = "CANCEL"
    
    static let INFO_WAITING = "INFO_WAITING"
    
    //error message key
    static let ERROR_TITLE = "ERROR_TITLE"
    static let ERROR_UNKNOWN = "ERROR_UNKNOWN"
    static let ERROR_NOT_INPUT_LOGINNAME = "ERROR_NOT_INPUT_LOGINNAME"
    static let ERROR_NOT_INPUT_PASSWORD = "ERROR_NOT_INPUT_PASSWORD"
    static let ERROR_USER_PERMISSION_WRONG = "ERROR_USER_PERMISSION_WRONG"
    static let ERROR_INVALID_MESSAGE = "ERROR_INVALID_MESSAGE"
    static let ERROR_INVALID_SESSION = "ERROR_INVALID_SESSION"
    static let ERROR_INVALID_DEVICE = "ERROR_INVALID_DEVICE"
    
    //admin user 
    
    static let ADMINUSER_TAB_AVERAGEVALUE = "ADMINUSER_TAB_AVERAGEVALUE"
    static let ADMINUSER_TAB_REALTIMEDATA = "ADMINUSER_TAB_REALTIMEDATA"
    
    static let ADMINUSER_AVLIST_HEADER_STATUS = "ADMINUSER_AVLIST_HEADER_STATUS"
    static let ADMINUSER_AVLIST_HEADER_SITENAME = "ADMINUSER_AVLIST_HEADER_SITENAME"
    static let ADMINUSER_AVLIST_HEADER_CO2 = "ADMINUSER_AVLIST_HEADER_CO2"
    static let ADMINUSER_AVLIST_HEADER_TEMPERATURE = "ADMINUSER_AVLIST_HEADER_TEMPERATURE"
    static let ADMINUSER_AVLIST_HEADER_HUMIDITY = "ADMINUSER_AVLIST_HEADER_HUMIDITY"
    
    static let ADMINUSER_SORT_BY_STATUS = "ADMINUSER_SORT_BY_STATUS"
    static let ADMINUSER_SORT_BY_CO2 = "ADMINUSER_SORT_BY_CO2"
    static let ADMINUSER_SORT_BY_TEMPERATURE = "ADMINUSER_SORT_BY_TEMPERATURE"
    static let ADMINUSER_SORT_BY_HUMIDITY = "ADMINUSER_SORT_BY_HUMIDITY"
    static let ADMINUSER_SORT_BY_SITENAME = "ADMINUSER_SORT_BY_SITENAME"
    
    //site detail
    static let SITEDETAIL_TIMEINTERVAL_CURRENT = "SITEDETAIL_TIMEINTERVAL_CURRENT"
    static let SITEDETAIL_TIMEINTERVAL_BY_15SECONDS = "SITEDETAIL_TIMEINTERVAL_BY_15SECONDS"
    static let SITEDETAIL_TIMEINTERVAL_BY_QUARTER = "SITEDETAIL_TIMEINTERVAL_BY_QUARTER"
    static let SITEDETAIL_TIMEINTERVAL_BY_HOUR = "SITEDETAIL_TIMEINTERVAL_BY_HOUR"
    static let SITEDETAIL_TIMEINTERVAL_BY_8HOURS = "SITEDETAIL_TIMEINTERVAL_BY_8HOURS"
    static let SITEDETAIL_TIMEINTERVAL_BY_DAY = "SITEDETAIL_TIMEINTERVAL_BY_DAY"
    static let SITEDETAIL_TIMEINTERVAL_BY_WEEK = "SITEDETAIL_TIMEINTERVAL_BY_WEEK"
    static let SITEDETAIL_TIMEINTERVAL_BY_MONTH = "SITEDETAIL_TIMEINTERVAL_BY_MONTH"
    
    //time scope settings
    static let TIMESCOPE_SETTINGS_START_TIME = "TIMESCOPE_SETTINGS_START_TIME"
    static let TIMESCOPE_SETTINGS_END_TIME = "TIMESCOPE_SETTINGS_END_TIME"
    static let TIMESCOPE_SETTINGS_TITLE = "TIMESCOPE_SETTINGS_TITLE"
    
    
    //chart
    static let CHART_LEGEND_CO2 = "CHART_LEGEND_CO2"
    static let CHART_LEGEND_TEMPERATURE = "CHART_LEGEND_TEMPERATURE"
    static let CHART_LEGEND_HUMIDITY = "CHART_LEGEND_HUMIDITY"
    
    
    
}

struct Colors{
    static let BK_BLUE = UIColor ( red: 0.4199, green: 0.7361, blue: 1.0, alpha: 1.0 )
    
    static let TEXT_BLUE = UIColor(rgba: "#448ccb")
    
    static let BORDER = UIColor.lightGrayColor()
    static let TEXT = UIColor.darkGrayColor()
    
    static let STATUS_ALARM = UIColor(rgba: "#ff0000")
    static let STATUS_WARNING = UIColor(rgba: "#fcae00")
    static let STATUS_NORMAL = UIColor(rgba: "#000000")
    
    static let CHART_CO2 = UIColor(rgba: "#448CCB")
    static let CHART_TEMPERATURE = UIColor(rgba: "#F8941D")
    static let CHART_HUMIDITY = UIColor(rgba: "#7CC576")
    static let CHART_AXIS = UIColor(rgba: "#707070")
    
}

struct ServerAPIURI {
    static let GET_SESSION_ID = "_NBI/get_session_id.lua"
    static let LOGIN = "_NBI/login.lua"
    static let GET_SITE_LIST_WITH_AGGREGATION_DATA = "_NBI/app_list.lua"
    static let GET_DEVICE_LIST = "Device/_NBI/list.lua"
    static let GET_MULTIPLE_DEVICES_REALTIME_DATA = "M2M_Last/_NBI/list.lua"
    static let GET_DEVICE_REALTIME_DATA = "M2M/_NBI/list.lua"
    static let GET_DEVICE_REALTIME_DATA_LIST = "M2M/_NBI/list.lua"
    static let GET_DEVICE_AGGREGATION_DATA_LIST_BY_15S = "M2M/_NBI/list.lua"
    static let GET_DEVICE_AGGREGATION_DATA_LIST_BY_1Q = "M2MAggByQuarter/_NBI/list.lua"
    static let GET_DEVICE_AGGREGATION_DATA_LIST_BY_1H = "M2MAggByHour/_NBI/list.lua"
    static let GET_DEVICE_AGGREGATION_DATA_LIST_BY_8H = "M2MAggByHours/_NBI/list.lua"
    static let GET_DEVICE_AGGREGATION_DATA_LIST_BY_1D = "M2MAggByDay/_NBI/list.lua"
    static let GET_DEVICE_AGGREGATION_DATA_LIST_BY_1W = "M2MAggByWeek/_NBI/list.lua"
    static let GET_DEVICE_AGGREGATION_DATA_LIST_BY_1M = "M2MAggByMonth/_NBI/list.lua"
    
    
    
}

struct CryptoAlgorithm{
    //key and iv need to be 16 bytes
    static let AES_KEY = "HSINCHUIOT000000"
    static let IV = "0123456789012345"
}

struct Language{
    static let EN = "en"
    static let CN_SIMPLIFIED = "zh-Hans"
    static let CN_TRADITIONAL = "zh-Hant"
}

struct Fonts{
    static let FONT_CHART_LABEL:UIFont = UIFont.systemFontOfSize(10)
    
    static let FONT_CHART_POINT_TEXT: UIFont = UIFont(name: "HelveticaNeue", size: 6.0)!
    static let FONT_CHART_POINT_HINT: UIFont = UIFont(name: "HelveticaNeue", size: 8.0)!
    static let FONT_CHART_AXIS: UIFont = UIFont(name: "HelveticaNeue", size: 8.0)!
    static let FONT_CHART_AXIS_TITLE: UIFont = UIFont(name: "HelveticaNeue", size: 10.0)!
    static let FONT_CHART_LEGEND: UIFont = UIFont(name: "HelveticaNeue", size: 8.0)!
    
}

struct TimeIntervals{
    static let TIME_INTERVAL_1_SECOND: NSTimeInterval = 1
    static let TIME_INTERVAL_1_MINUTE: NSTimeInterval = 60
    static let TIME_INTERVAL_1_QUARTER: NSTimeInterval = 60 * 15
    static let TIME_INTERVAL_1_HOUR: NSTimeInterval = 60 * 60
    static let TIME_INTERVAL_1_DAY: NSTimeInterval = 60 * 60 * 24
    static let TIME_INTERVAL_1_WEEK: NSTimeInterval = 60 * 60 * 24 * 7
    static let TIME_INTERVAL_1_MONTH: NSTimeInterval = 60 * 60 * 24 * 30
}
