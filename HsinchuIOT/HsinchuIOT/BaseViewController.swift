//
//  ViewController.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/8/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import UIKit
import MBProgressHUD
import ObjectiveC


private var _waitingBar: MBProgressHUD?

class BaseViewController: UIViewController{
    
}
extension UIViewController{
    var waitingBar: MBProgressHUD? {
        get{
            return (objc_getAssociatedObject(self, &_waitingBar) as? MBProgressHUD)
        }
        set(newValue){
            objc_setAssociatedObject(self, &_waitingBar, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    func showWaitingBar(){
        waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        waitingBar!.labelText = getString(StringKey.INFO_WAITING)
        waitingBar!.removeFromSuperViewOnHide = true
    }
    
    func hideWaitingBar(){
        waitingBar?.hide(true)
    }
    
    func showError(error: IOTError){
        hideWaitingBar()
        showErrorMsg(error.errorMsg!)
  
    }
    
    func showErrorMsg(message: String){
        let alertView = UIAlertView(title: getString(StringKey.ERROR_TITLE), message: message, delegate: self, cancelButtonTitle: getString(StringKey.OK))
        alertView.show()
    }
}
