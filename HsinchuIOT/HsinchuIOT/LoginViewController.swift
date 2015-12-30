//
//  LoginViewController.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/11/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation
import CryptoSwift
import MBProgressHUD


class LoginViewController: BaseViewController, UITextFieldDelegate, UIAlertViewDelegate{
    
    @IBOutlet weak var ivBg: UIImageView!
    
    @IBOutlet weak var tvLoginname: UITextField!
    
    @IBOutlet weak var tvPassword: UITextField!
    
    @IBOutlet weak var cbRememberMe: M13Checkbox!
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var segLanguage: UISegmentedControl!
    
    @IBOutlet weak var lbAppName1: UILabel!
    
    @IBOutlet weak var lbAppName2: UILabel!
    
   
    
    
    override func viewDidLoad() {
        
        ivBg.backgroundColor = UIColor(patternImage: UIImage(named: "login_bg_v2")!)
        
        tvLoginname.layer.cornerRadius = 8.0
        tvLoginname.layer.borderColor = Colors.BORDER.CGColor
        tvLoginname.layer.borderWidth = 1
        tvLoginname.placeholder = getString(StringKey.LOGINNAME_HINT)
        tvLoginname.delegate = self
        
        tvPassword.layer.cornerRadius = 8.0
        tvPassword.layer.borderColor = Colors.BORDER.CGColor
        tvPassword.layer.borderWidth = 1
        tvPassword.placeholder = getString(StringKey.PASSWORD_HINT)
        tvPassword.delegate = self
        
        cbRememberMe.checkAlignment = M13CheckboxAlignmentLeft
        cbRememberMe.flat = true
        cbRememberMe.uncheckedColor = UIColor(red: 111/255, green: 160/255, blue: 223/255, alpha: 0.4)
        cbRememberMe.tintColor = Colors.TEXT_BLUE
        cbRememberMe.checkColor = UIColor.whiteColor()
        cbRememberMe.strokeColor = Colors.BORDER
        cbRememberMe.strokeWidth = 1
        cbRememberMe.titleLabel.text = getString(StringKey.REMEMBER_ME)
        cbRememberMe.titleLabel.font = UIFont(name: "HelveticaNeue", size: 12.0)
        
        cbRememberMe.checkState = M13CheckboxStateUnchecked
        
        if let loginName = PreferenceManager.sharedInstance.valueForKey(PreferenceKey.LOGINNAME){
            if !loginName.isEmpty{
                cbRememberMe.checkState = M13CheckboxStateChecked
                tvLoginname.text = loginName
            }
        }
        if let encryptedPassword = PreferenceManager.sharedInstance.valueForKey(PreferenceKey.PASSWORD){
            if !encryptedPassword.isEmpty{
                if let encryptedData = NSData(base64EncodedString: encryptedPassword, options: NSDataBase64DecodingOptions(rawValue:0)){
                    
                    
                    if let decryptedData = try? encryptedData.decrypt(AES(key: CryptoAlgorithm.AES_KEY, iv: CryptoAlgorithm.IV)) {
                        if let decryptedPassword = String(data: decryptedData, encoding: NSUTF8StringEncoding){
                            tvPassword.text = decryptedPassword
                        }
                    }
                }
            }
        }
        
        
        btnLogin.setTitle(getString(StringKey.LOGIN_BTN), forState: UIControlState.Normal)
        //btnLogin.color = UIColor.whiteColor()
        btnLogin.layer.cornerRadius = 8.0
        btnLogin.layer.masksToBounds = true
        btnLogin.layer.borderColor = Colors.BORDER.CGColor
        btnLogin.layer.borderWidth = 1.0
        btnLogin.setBackgroundImage(UIColor.whiteColor().toImage(), forState: UIControlState.Normal)
        btnLogin.setBackgroundImage(Colors.TEXT_BLUE.toImage(), forState: UIControlState.Highlighted)
        btnLogin.setTitleColor(Colors.TEXT, forState: UIControlState.Normal)
        btnLogin.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        
        segLanguage.tintColor = Colors.TEXT_BLUE
        
        let currentLanguage = LanguageManager.sharedInstance.getCurrentLanguage()
        if currentLanguage == Language.EN {
            segLanguage.selectedSegmentIndex = 2
        }else if currentLanguage == Language.CN_SIMPLIFIED{
            segLanguage.selectedSegmentIndex = 1
        }else{
            segLanguage.selectedSegmentIndex = 0
        }
        
        
        lbAppName1.textColor = Colors.TEXT_BLUE
        lbAppName1.text = getString(StringKey.APP_TITLE_1)
        
        lbAppName2.textColor = Colors.TEXT_BLUE
        lbAppName2.text = getString(StringKey.APP_TITLE_2)
        
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor(red: 83/255, green: 134/255, blue: 193/255, alpha: 1.0).CGColor
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor ( red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0 ).CGColor
        return true
    }
    
    @IBAction func loginBtnClicked(sender: UIButton) {
        showWaitingBar()
        loginIn()
    }
    
    @IBAction func switchLanguageBtnClicked(sender: UISegmentedControl) {
        if sender.isEqual(segLanguage) {
            switch(sender.selectedSegmentIndex){
            case 0:
                LanguageManager.sharedInstance.setCurrentLanguage(Language.CN_TRADITIONAL)
            case 1:
                LanguageManager.sharedInstance.setCurrentLanguage(Language.CN_SIMPLIFIED)
            case 2:
                LanguageManager.sharedInstance.setCurrentLanguage(Language.EN)
            default:
                LanguageManager.sharedInstance.setCurrentLanguage(Language.CN_TRADITIONAL)
                
            }
            changeUILanguage()
        }
    }
    
    func loginIn() {
        if tvLoginname.text?.characters.count == 0 {
            showError(IOTError(errorCode: IOTError.LoginNameIsEmptyError, errorGroup: "Client"))
            return
        }
        
        if tvPassword.text?.characters.count == 0 {
            showError(IOTError(errorCode: IOTError.PasswordIsEmptyError, errorGroup: "Client"))
            return
        }
        
        let loginName = tvLoginname.text!
        let password = tvPassword.text!
        
        
        IOTServer.getServer().getSessionID(SessionHandler(controller: self, loginName: loginName, password: password).doLoginIn, onFailed: showError)
        
        
    }
    struct SessionHandler {
        let controller: LoginViewController
        let loginName: String
        let password: String
        
        init(controller: LoginViewController, loginName: String, password: String){
            self.controller = controller
            self.loginName = loginName
            self.password = password
        }
        
        func doLoginIn(session: Session){
            IOTServer.getServer().login(
                session.sessionID,
                loginName: loginName,
                password: password,
                onSucceed: LoginHandler(controller: controller, session: session).loginSucceed,
                onFailed: controller.showError)
            
        }
        
        
    }
    
    struct LoginHandler {
        let controller: LoginViewController
        let session: Session
        
        init(controller: LoginViewController, session: Session){
            self.controller = controller
            self.session = session
        }
        
        func loginSucceed(user: User){
            //first set session ID and login user
            
            SessionManager.sharedInstance.session = session
            SessionManager.sharedInstance.loginUser = user
            
            //then save loginname and password
            if controller.cbRememberMe.checkState == M13CheckboxStateChecked {
                
                if let loginname = user.loginName{
                    PreferenceManager.sharedInstance.setValue(loginname, forKey: PreferenceKey.LOGINNAME)
                }
                
                if let pwd = user.password {
                    if let encryptedPwd: String = try? pwd.encrypt(AES(key: CryptoAlgorithm.AES_KEY, iv: CryptoAlgorithm.IV)){
                        PreferenceManager.sharedInstance.setValue(encryptedPwd, forKey: PreferenceKey.PASSWORD)
                    }
                }
            }else{
                PreferenceManager.sharedInstance.setValue(nil, forKey: PreferenceKey.LOGINNAME)
                PreferenceManager.sharedInstance.setValue(nil, forKey: PreferenceKey.PASSWORD)
            }
            controller.hideWaitingBar()
            
            if user.isAdminUser() {
                controller.gotoAdminUserScreen()
            }else if user.isNormalUser() {
                controller.gotoNormalUserScreen()
            }else{
                if AppConfig.TEST {
                    controller.gotoAdminUserScreen()
                }else{
                    controller.showError(IOTError(errorCode: IOTError.UserPermissionWrongError, errorGroup: "Client"))
                }
            }
        }
    }
    
    
    func changeUILanguage(){
        tvLoginname.placeholder = getString(StringKey.LOGINNAME_HINT)
        tvPassword.placeholder = getString(StringKey.PASSWORD_HINT)
        cbRememberMe.titleLabel.text = getString(StringKey.REMEMBER_ME)
        btnLogin.setTitle(getString(StringKey.LOGIN_BTN), forState: UIControlState.Normal)
        lbAppName1.text = getString(StringKey.APP_TITLE_1)
        lbAppName2.text = getString(StringKey.APP_TITLE_2)
        
    }
    
        
    
    
    
    func gotoAdminUserScreen() {
        let storyboard = UIStoryboard(name: "AdminUser", bundle: nil)
        
        let tabVC = storyboard.instantiateViewControllerWithIdentifier("adminUserHome") as! AdminUserHomeViewController
        
        //setup tab average value
        let avListVC = storyboard.instantiateViewControllerWithIdentifier("siteList") as! AdminUserSiteListViewController
        avListVC.dataLoader = AverageValueLoader()
        
        avListVC.tabBarItem.title = getString(StringKey.ADMINUSER_TAB_AVERAGEVALUE)
        
        avListVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Highlighted)
        avListVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState: UIControlState.Normal)
        
        avListVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 15)!], forState: UIControlState.Normal)
        
        avListVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -14)
        
        
        let rdListVC = storyboard.instantiateViewControllerWithIdentifier("siteList") as! AdminUserSiteListViewController
        
        rdListVC.dataLoader = RealtimeDataLoader()
        
        rdListVC.tabBarItem.title = getString(StringKey.ADMINUSER_TAB_REALTIMEDATA)
        
        rdListVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Highlighted)
        rdListVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState: UIControlState.Normal)
        
        rdListVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 15)!], forState: UIControlState.Normal)
        
        rdListVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -14)

        
        
        tabVC.viewControllers = [avListVC, rdListVC]
        
        
        self.presentViewController(tabVC, animated: true, completion: nil)
        
    }
    
    func gotoNormalUserScreen() {
        let storyboard = UIStoryboard(name: "NormalUser", bundle: nil)
        let normalUserHomeViewController = storyboard.instantiateViewControllerWithIdentifier("normalUserHome")
        self.presentViewController(normalUserHomeViewController, animated: true, completion: nil)
    }
    
    
}