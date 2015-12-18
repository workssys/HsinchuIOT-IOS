//
//  LoginViewController.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/11/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import Foundation

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
        cbRememberMe.checkState = M13CheckboxStateChecked
        
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
        if tvLoginname.text?.characters.count == 0 {
            showError(getString(StringKey.ERROR_NOT_INPUT_LOGINNAME))
            return
        }
        
        if tvPassword.text?.characters.count == 0 {
            showError(getString(StringKey.ERROR_NOT_INPUT_PASSWORD))
            return
        }

        
    }
    
    @IBAction func switchLanguageBtnClicked(sender: UISegmentedControl) {
        if sender.isEqual(segLanguage) {
            switch(sender.selectedSegmentIndex){
            case 0:
                LanguageManager.instance.setCurrentLanguage("zh-Hant")
            case 1:
                LanguageManager.instance.setCurrentLanguage("zh-Hans")
            case 2:
                LanguageManager.instance.setCurrentLanguage("en")
            default:
                LanguageManager.instance.setCurrentLanguage("zh-Hant")
                
            }
            changeUILanguage()
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
    
    func showError(message: String){
        let alertView = UIAlertView(title: getString(StringKey.ERROR_TITLE), message: message, delegate: self, cancelButtonTitle: getString(StringKey.OK))
        alertView.show()
    }
    
}