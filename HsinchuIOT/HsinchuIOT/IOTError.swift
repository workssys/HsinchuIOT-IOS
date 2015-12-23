//
//  Error.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/19/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation

struct IOTError{
    var errorCode: Int = -1
    var errorMsg: String? = nil
    
    init(errorCode: Int, errorMsg: String?){
        self.errorCode = errorCode
        self.errorMsg = errorMsg
    }
}

extension NSError{
    var error: IOTError{
        return IOTError(errorCode: -1, errorMsg: self.description)
    }
}