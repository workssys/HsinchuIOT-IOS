//
//  LoginViewController.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/11/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation
import CryptoSwift


class LoginViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate{
    
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
        cbRememberMe.titleLabel.font = UIFont(name: "System Font", size: 12.0)
        
        if let loginName = PreferenceManager.sharedInstance.valueForKey(PreferenceKey.LOGINNAME){
            if !loginName.isEmpty{
                cbRememberMe.checkState = M13CheckboxStateChecked
                tvLoginname.text = loginName
            }
        }
        //if let password = PreferenceManager
        cbRememberMe.checkState = M13CheckboxStateUnchecked
        
        
        btnLogin.setTitle(getString(StringKey.LOGIN_BTN), forState: UIControlState.Normal)
        //btnLogin.color = UIColor.whiteColor()
        btnLogin.layer.cornerRadius = 8.0
        btnLogin.layer.masksToBounds = true
        btnLogin.layer.borderColor = Colors.BORDER.CGColor
        btnLogin.layer.borderWidth = 1.0
        btnLogin.setBackgroundImage(imageWithColor(UIColor.whiteColor()), forState: UIControlState.Normal)
        btnLogin.setBackgroundImage(imageWithColor(Colors.TEXT_BLUE), forState: UIControlState.Highlighted)
        btnLogin.setTitleColor(Colors.TEXT, forState: UIControlState.Normal)
        btnLogin.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        
        segLanguage.tintColor = Colors.TEXT_BLUE
        
        
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
        loginIn()
    }
    
    @IBAction func switchLanguageBtnClicked(sender: UISegmentedControl) {
        if sender.isEqual(segLanguage) {
            switch(sender.selectedSegmentIndex){
            case 0:
                LanguageManager.sharedInstance.setCurrentLanguage("zh-Hant")
            case 1:
                LanguageManager.sharedInstance.setCurrentLanguage("zh-Hans")
            case 2:
                LanguageManager.sharedInstance.setCurrentLanguage("en")
            default:
                LanguageManager.sharedInstance.setCurrentLanguage("zh-Hant")
                
            }
            changeUILanguage()
        }
    }
    
    func loginIn() {
        if tvLoginname.text?.characters.count == 0 {
            showErrorString(getString(StringKey.ERROR_NOT_INPUT_LOGINNAME))
            return
        }
        
        if tvPassword.text?.characters.count == 0 {
            showErrorString(getString(StringKey.ERROR_NOT_INPUT_PASSWORD))
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
            //first save loginname and password
            if controller.cbRememberMe.checkState == M13CheckboxStateChecked {
                let key = "HSINCHUIOT000000"
                let iv = "1234567890123456"
                if let pwd = user.password {
                    if let encryptedPwd: String = try? pwd.encrypt(AES(key: key, iv: iv)){
                        controller.showErrorString(encryptedPwd)
                        
                        if let encryptedData = NSData(base64EncodedString: encryptedPwd, options: NSDataBase64DecodingOptions(rawValue:0)){
                        
                        
                            if let decryptedData = try? encryptedData.decrypt(AES(key: key, iv: iv)) {
                                if let decryptedStr = String(data: decryptedData, encoding: NSUTF8StringEncoding){
                                    controller.showErrorString(decryptedStr)
                                }
                            }
                        }
                    }
                }
                
                
                
                
                
            }
            
            controller.showErrorString(user.permission!)
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
    
    func imageWithColor(color: UIColor) -> UIImage{
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
        
    }
    
    func showError(error: IOTError){
        showErrorString(error.errorMsg!)
    }
    
    func showErrorString(message: String){
        let alertView = UIAlertView(title: getString(StringKey.ERROR_TITLE), message: message, delegate: self, cancelButtonTitle: getString(StringKey.OK))
        alertView.show()
    }
    
}