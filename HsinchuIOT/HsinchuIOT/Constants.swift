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
    static let CLOSE = "CLOSE"
    
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
    
    //normal user
    static let NORMALUSER_CO2_NAME = "NORMALUSER_CO2_NAME"
    static let NORMALUSER_TEMPERATURE_NAME = "NORMALUSER_TEMPERATURE_NAME"
    static let NORMALUSER_HUMIDITY_NAME = "NORMALUSER_HUMIDITY_NAME"
    static let NORMALUSER_CO2_UNIT = "NORMALUSER_CO2_UNIT"
    static let NORMALUSER_TEMPERATURE_UNIT = "NORMALUSER_TEMPERATURE_UNIT"
    static let NORMALUSER_HUMIDITY_UNIT = "NORMALUSER_HUMIDITY_UNIT"

    
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
    
    static let TIMESCOPE_SETTINGS_1HOUR = "TIMESCOPE_SETTINGS_1HOUR"
    static let TIMESCOPE_SETTINGS_4HOURS = "TIMESCOPE_SETTINGS_4HOURS"
    static let TIMESCOPE_SETTINGS_8HOURS = "TIMESCOPE_SETTINGS_8HOURS"
    static let TIMESCOPE_SETTINGS_TODAY = "TIMESCOPE_SETTINGS_TODAY"
    static let TIMESCOPE_SETTINGS_YESTERDAY = "TIMESCOPE_SETTINGS_YESTERDAY"
    static let TIMESCOPE_SETTINGS_LAST3DAYS = "TIMESCOPE_SETTINGS_LAST3DAYS"
    static let TIMESCOPE_SETTINGS_LAST5DAYS = "TIMESCOPE_SETTINGS_LAST5DAYS"
    static let TIMESCOPE_SETTINGS_THISWEEK = "TIMESCOPE_SETTINGS_THISWEEK"
    static let TIMESCOPE_SETTINGS_LASTWEEK = "TIMESCOPE_SETTINGS_LASTWEEK"
    static let TIMESCOPE_SETTINGS_LAST2WEEKS = "TIMESCOPE_SETTINGS_LAST2WEEKS"
    static let TIMESCOPE_SETTINGS_LAST3WEEKS = "TIMESCOPE_SETTINGS_LAST3WEEKS"
    static let TIMESCOPE_SETTINGS_THISMONTH = "TIMESCOPE_SETTINGS_THISMONTH"
    static let TIMESCOPE_SETTINGS_LASTMONTH = "TIMESCOPE_SETTINGS_LASTMONTH"
    static let TIMESCOPE_SETTINGS_LAST2MONTHS = "TIMESCOPE_SETTINGS_LAST2MONTHS"
    static let TIMESCOPE_SETTINGS_LAST3MONTHS = "TIMESCOPE_SETTINGS_LAST3MONTHS"
    
    
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
    
    static let PANEL_STATUS_NORMAL_START = UIColor(rgba: "#FFFFFF")
    static let PANEL_STATUS_NORMAL_END = UIColor(rgba: "#8bd543")
    
    static let PANEL_STATUS_WORSE_START = UIColor(rgba: "#FFFFFF")
    static let PANEL_STATUS_WORSE_END = UIColor(rgba: "#959799")
    
    static let PANEL_STATUS_WORST_START = UIColor(rgba: "#d5d7d9")
    static let PANEL_STATUS_WORST_END = UIColor(rgba: "#292627")
    
    static let PANEL_STATUS_WET_START = UIColor(rgba: "#FFFFFF")
    static let PANEL_STATUS_WET_END = UIColor(rgba: "#2eb676")
    
    static let PANEL_STATUS_DRY_START = UIColor(rgba: "#FFFFFF")
    static let PANEL_STATUS_DRY_END = UIColor(rgba: "#d5be6c")
    
    static let PANEL_STATUS_HOT_START = UIColor(rgba: "#f9f5bb")
    static let PANEL_STATUS_HOT_END = UIColor(rgba: "#f69422")
    
    static let PANEL_STATUS_COLD_START = UIColor(rgba: "#FFFFFF")
    static let PANEL_STATUS_COLD_END = UIColor(rgba: "#85d2f0")
    
    static let PANEL_STATUS_MISSING_START = UIColor(rgba: "#AAAAAA")
    static let PANEL_STATUS_MISSING_END = UIColor(rgba: "#EEEEEE")
    
    static let PANEL_TEXT_STATUS_NORMAL = UIColor(rgba: "#5dbc00")
    static let PANEL_TEXT_STATUS_WORSE = UIColor(rgba: "#58595B")
    static let PANEL_TEXT_STATUS_WORST = UIColor(rgba: "#F1F1F2")
    static let PANEL_TEXT_STATUS_COLD = UIColor(rgba: "#1B75BB")
    static let PANEL_TEXT_STATUS_HOT = UIColor(rgba: "#EC1C24")
    static let PANEL_TEXT_STATUS_DRY = UIColor(rgba: "#a67c52")
    static let PANEL_TEXT_STATUS_WET = UIColor(rgba: "#5a45c6")
    static let PANEL_TEXT_STATUS_MISSING = UIColor(rgba: "#A2A2A2")
    
    static let PANEL_TEXT_SHADOW = UIColor(rgba: "#FFFFFF")
    
    static let PANEL_UNIT_TEXT = UIColor(rgba: "#58595B")
    static let PANEL_UNIT_TEXT_SHADOW = UIColor(rgba: "#F3F3F3")
    
    static let PANEL_CAPTION_TEXT = UIColor(rgba: "#58595B")
    static let PANEL_CAPTION_TEXT_SHADOW = UIColor(rgba: "#F3F3F3")
    
    static let STATUS_ICON_NORMAL = UIColor(rgba: "#00FF00")
    static let STATUS_ICON_WARNING = UIColor(rgba: "#FFCC00")
    static let STATUS_ICON_ALARM = UIColor(rgba: "#FF0000")
    static let STATUS_ICON_MISSING = UIColor(rgba: "#CCCCCC")
    
    
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
    static let FONT_TITLE = UIFont(name: "HelveticaNeue", size: 18.0)!
    static let FONT_INFO = UIFont(name: "HelveticaNeue", size: 17.0)!
    static let FONT_TABBAR = UIFont(name: "HelveticaNeue", size: 15)!
    static let FONT_CHART_POINT_TEXT: UIFont = UIFont(name: "HelveticaNeue", size: 6.0)!
    static let FONT_CHART_POINT_HINT: UIFont = UIFont(name: "HelveticaNeue", size: 8.0)!
    static let FONT_CHART_AXIS: UIFont = UIFont(name: "HelveticaNeue", size: 8.0)!
    static let FONT_CHART_AXIS_TITLE: UIFont = UIFont(name: "HelveticaNeue", size: 10.0)!
    static let FONT_CHART_LEGEND: UIFont = UIFont(name: "HelveticaNeue", size: 8.0)!
    
    static let FONT_PANEL_CAPTION: UIFont = UIFont(name: "HelveticaNeue", size: 36.0)!
    static let FONT_PANEL_VALUE: UIFont = UIFont(name: "HelveticaNeue-Bold", size: 36.0)!
    static let FONT_PANEL_UNIT: UIFont = UIFont(name: "HelveticaNeue", size: 24.0)!
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
