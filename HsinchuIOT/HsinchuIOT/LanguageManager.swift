//
//  LanguageManager.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/17/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation


class LanguageManager{
    
    static let sharedInstance = LanguageManager()
    
    
    private var bundle: NSBundle{
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
    }
    
    func getCurrentLanguage() -> String{
        var curLan: String?
        if let language = PreferenceManager.sharedInstance.valueForKey(PreferenceKey.LANGUAGE) {
            curLan = language
        }else{
            //let languages = userDefaults.objectForKey(PreferenceKey.SYSTEM_LANGUAGE) as! NSArray
            curLan = "zh-Hant"
            setCurrentLanguage("zh-Hant")
            
        }
        return curLan!
    }
    
    func setCurrentLanguage(language: String){
        PreferenceManager.sharedInstance.setValue(language, forKey: PreferenceKey.LANGUAGE)
    }
    
}

func getString(key: String) -> String{
    return NSLocalizedString(key, tableName: "Localizable", bundle: LanguageManager.sharedInstance.bundle, comment: "")
}