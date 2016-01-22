//
//  AlarmManager.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 1/22/16.
//  Copyright © 2016 SL Studio. All rights reserved.
//

import Foundation

class AlarmManager {
    static let sharedInstance = AlarmManager()
    private init(){
    }
    
    func loadAlarmList(site: Site?) -> [Alarm] {
        var result:[Alarm] = []
        if let alarmListString = PreferenceManager.sharedInstance.valueForKey(PreferenceKey.ALARM_LIST) {
            let alarmStrings = alarmListString.componentsSeparatedByString("|")
            for alarmString in alarmStrings {
                if let alarm = Alarm(alarmString: alarmString) {
                    if let s = site {
                        if alarm.alarmSite == s.siteName {
                            result.append(alarm)
                        }
                    }else{
                        result.append(alarm)
                    }
                }
            }
        }
        return result
    }
    
    func removeAlarms(alarms: [Alarm]) {
        if let alarmListString = PreferenceManager.sharedInstance.valueForKey(PreferenceKey.ALARM_LIST) {
            let alarmStrings = alarmListString.componentsSeparatedByString("|")
            
            var result: String = ""
            
            for alarmString in alarmStrings {
                var needRemove = false
                for alarm in alarms {
                    if alarm.alarmString == alarmString{
                        needRemove = true
                        break
                    }
                }
                if !needRemove {
                    if !result.isEmpty {
                        result += "|"
                    }
                    result += alarmString
                }
            }
            
            PreferenceManager.sharedInstance.setValue(result, forKey: PreferenceKey.ALARM_LIST)
        }
    }
    
    func clearAlarms(site: Site?){
        if let s = site {
            removeAlarms(loadAlarmList(s))
        }else{
        
            PreferenceManager.sharedInstance.setValue("", forKey: PreferenceKey.ALARM_LIST)
        }
    }
    
    func addAlarms(alarms: [Alarm]) {
        var result: String = ""
        if let alarmString = PreferenceManager.sharedInstance.valueForKey(PreferenceKey.ALARM_LIST) {
            if !alarmString.isEmpty {
                result = alarmString
            }
        }
        let count = alarms.count
        for index in 0 ..< count {
            if !result.isEmpty {
                result += "|"
            }
            result += alarms[index].alarmString
        }
        
        PreferenceManager.sharedInstance.setValue(result, forKey: PreferenceKey.ALARM_LIST)
    }
    
}