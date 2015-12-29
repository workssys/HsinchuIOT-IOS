//
//  Error.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/19/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation

typealias IOTErrorCode = (code: Int, messageKey: String)

struct IOTError{
    var errorCode: Int = -1
    var errorMsg: String? = nil
    var errorGroup: String?
    
    
    init(errorCode: Int, errorMsg: String?, errorGroup: String?){
        self.errorCode = errorCode
        self.errorMsg = errorMsg
        self.errorGroup = errorGroup
    }
    
    init(errorCode: IOTErrorCode, errorGroup: String?){
        self.errorCode = errorCode.code
        self.errorMsg = getString(errorCode.messageKey)
        self.errorGroup = errorGroup
    }
    
    
    static let UnknownError: IOTErrorCode = (-1, StringKey.ERROR_UNKNOWN)
    static let LoginNameIsEmptyError: IOTErrorCode = (-2, StringKey.ERROR_NOT_INPUT_LOGINNAME)
    static let PasswordIsEmptyError: IOTErrorCode = ( -3, StringKey.ERROR_NOT_INPUT_PASSWORD)
    static let UserPermissionWrongError: IOTErrorCode = (-4, StringKey.ERROR_USER_PERMISSION_WRONG)
    static let InvalidMessageError: IOTErrorCode = (-5, StringKey.ERROR_INVALID_MESSAGE)
    static let InvalidSessionError: IOTErrorCode = (-6, StringKey.ERROR_INVALID_SESSION)
    
}


extension NSError{
    func error(errorGroup: String) -> IOTError{
        return IOTError(errorCode: self.code, errorMsg: self.description, errorGroup: errorGroup)
    }
}
