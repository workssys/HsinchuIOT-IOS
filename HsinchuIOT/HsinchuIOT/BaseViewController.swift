//
//  ViewController.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/8/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {

    private var waitingBar: MBProgressHUD?
    
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

