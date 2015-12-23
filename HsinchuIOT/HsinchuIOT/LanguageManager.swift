//
//  LanguageManager.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/17/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation


class LanguageManager{
    
    class var instance: LanguageManager {
        struct Singleton{
            static var onceToken: dispatch_once_t = 0
            static var _instance: LanguageManager? = nil
        }
        dispatch_once(&Singleton.onceToken){
            Singleton._instance = LanguageManager()
        }
        return Singleton._instance!
    }
    
    var bundle: NSBundle{
        get{
            let curLan = getCurrentLanguage()
            let path = NSBundle.mainBundle().pathForResource(curLan, ofType: "lproj")
            
            return NSBundle(path: path!)!
            
        }
        set{
            self.bundle = newValue
        }
    }
    
    private init(){
        print(getCurrentLanguage())
    }
    
    func getCurrentLanguage() -> String{
        var curLan: String?
        if let language = PreferenceManager.instance.valueForKey(PreferenceKey.LANGUAGE) {
            curLan = language
        }else{
            //let languages = userDefaults.objectForKey(PreferenceKey.SYSTEM_LANGUAGE) as! NSArray
            curLan = "zh-Hant"
            setCurrentLanguage("zh-Hant")
            
        }
        return curLan!
    }
    
    func setCurrentLanguage(language: String){
        PreferenceManager.instance.setValue(language, forKey: PreferenceKey.LANGUAGE)
    }
    
}

func getString(key: String) -> String{
    return NSLocalizedString(key, tableName: "Localizable", bundle: LanguageManager.instance.bundle, comment: "")
}