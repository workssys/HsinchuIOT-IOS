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

typealias Closure = ()->()

private var closures = [String: Closure]()

extension UIViewController{
    
    func showWaitingBar(){
        let waitingBar = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        waitingBar!.labelText = getString(StringKey.INFO_WAITING)
        waitingBar!.removeFromSuperViewOnHide = true
    }
    
    func hideWaitingBar(){
        let allWaitingBars = MBProgressHUD.allHUDsForView(self.view)
        for wb in allWaitingBars {
            if let w = wb as? MBProgressHUD {
                w.hide(true)
            }
        }
    }
    
    func showError(error: IOTError){
        hideWaitingBar()
        showErrorMsg(error.errorMsg!)
  
    }
    
    func showErrorMsg(message: String){
        UIAlertView(title: getString(StringKey.ERROR_TITLE), message: message, delegate: self, cancelButtonTitle: getString(StringKey.OK)).show()
    }
    
    func delayed(delay: NSTimeInterval, name: String, closure: Closure){
        closures[name] = closure
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, Int64(delay * NSTimeInterval(NSEC_PER_SEC))),
            dispatch_get_main_queue()) {
                if let closure = closures[name] {
                    print("execute delayed call for name:\(name)")
                    closure()
                    closures[name] = nil
                }
        }
    }
    
    func cancelDelayed(name: String){
        print("cancelled delayed call for name:\(name)")
        closures[name] = nil
    }
    
}
