//
//  StringExtension.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/27/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation


extension String{
    var length:Int {
        return self.characters.count
    }
    
    func indexOf(target: String) -> Int? {
        let range = (self as NSString).rangeOfString(target)
        guard range.toRange() != nil else{
            return nil
        }
        return range.location
    }
    
    func lastIndexOf(target: String) -> Int? {
        let range = (self as NSString).rangeOfString(target, options: NSStringCompareOptions.BackwardsSearch)
        guard range.toRange() != nil else{
            return nil
        }
        return range.location
    }
}