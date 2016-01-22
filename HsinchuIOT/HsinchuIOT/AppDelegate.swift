//
//  AppDelegate.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 12/8/15.
//  Copyright © 2015 SL Studio. All rights reserved.
//

import UIKit

import CryptoSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if AppConfig.TEST {
            if AlarmManager.sharedInstance.loadAlarmList(nil).count == 0 {
                let mockAlarmString = "2015-11-09 18:03:30;1;测试站点1;二氧化碳;1020ppm;超標"
                    + "|2015-11-09 18:09:30;2;测试站点2;二氧化碳;1020ppm;超標"
                    + "|2015-11-21 18:39:30;3;测试站点3;二氧化碳;1020ppm;接近超標"
                    + "|2015-11-11 18:09:30;2;测试站点2;二氧化碳;1020ppm;接近超標"
                + "|2015-11-11 18:09:30;2;测试站点2;二氧化碳;1020ppm;接近超標"
                + "|2015-11-22 18:09:30;2;测试站点2;二氧化碳;1020ppm;接近超標"
                + "|2015-11-23 18:09:30;2;测试站点2;二氧化碳;1020ppm;接近超標"
                + "|2015-11-24 18:09:30;2;测试站点2;二氧化碳;1020ppm;接近超標"
                + "|2015-11-25 18:09:30;6;测试站点6;二氧化碳;1020ppm;接近超標"
                + "|2015-11-26 18:09:30;2;测试站点2;二氧化碳;1020ppm;接近超標"
                + "|2015-11-27 18:09:30;2;测试站点2;二氧化碳;1020ppm;接近超標"
                + "|2015-11-28 18:09:30;3;测试站点3;二氧化碳;1020ppm;接近超標"
                + "|2015-11-29 18:09:30;7;测试站点7;二氧化碳;1020ppm;接近超標"
                + "|2015-11-30 18:09:30;2;测试站点2;二氧化碳;1020ppm;接近超標"
                + "|2015-11-31 18:09:30;2;测试站点2;二氧化碳;1020ppm;接近超標"
                PreferenceManager.sharedInstance.setValue(mockAlarmString, forKey: PreferenceKey.ALARM_LIST)
            }
        }
        
        //check remember username/password
        if let loginname = PreferenceManager.sharedInstance.valueForKey(PreferenceKey.LOGINNAME){
            
            if let encryptedPassword = PreferenceManager.sharedInstance.valueForKey(PreferenceKey.PASSWORD){
                if !encryptedPassword.isEmpty{
                    if let encryptedData = NSData(base64EncodedString: encryptedPassword, options: NSDataBase64DecodingOptions(rawValue:0)){
                        
                        
                        if let decryptedData = try? encryptedData.decrypt(AES(key: CryptoAlgorithm.AES_KEY, iv: CryptoAlgorithm.IV)) {
                            if let decryptedPassword = String(data: decryptedData, encoding: NSUTF8StringEncoding){
                                doAutoLogin(loginname, password: decryptedPassword)
                                
                                return true
                            }
                        }
                    }
                }
            }
        }
        //show login page
        showLoginScreen()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        /* Sent when the application is about to move from active to inactive state. This can occur for
        certain types of temporary interruptions (such as an incoming phone call or SMS message) or when 
        the user quits the application and it begins the transition to the background state.
            */
// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        /* Use this method to release shared resources, save user data, invalidate timers, and store 
        enough application state information to restore your application to its current state in case it 
        is terminated later.
            */
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("Register to APNs succeed.")
        
        if let token = NSString(data: deviceToken, encoding: NSUTF8StringEncoding) as? String {
            NotificationManager.sharedInstance.registerToServer(token,
                onSucceed: registerToServerSucceed, onFailed: registerToServerFailed)
        }else{
            registerToServerFailed(IOTError(errorCode: IOTError.RegisterNotificationError, errorGroup: "Client"))
        }
        
       
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        //failed to register to APNs
        print("Register to APNs failed:\(error.description)")
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if let alarmMsg = userInfo["message"] as? String {
            if let alarm = Alarm(alarmString: alarmMsg) {
                AlarmManager.sharedInstance.addAlarms([alarm])
            }else{
                print("invalid alarm notification:\(alarmMsg)")
            }
        }else{
            print("unknown alarm notification format:\(userInfo)")
        }
    }
    
    
    func registerToServerFailed(error: IOTError){
        print("Register to Server failed:\(error.errorMsg)")
    }
    
    func registerToServerSucceed(){
        print("Register to Server succeed.")
    }
    
    func doAutoLogin(loginName: String, password: String){
        IOTServer.getServer().getSessionID(SessionHandler(appDelegate: self, loginName: loginName, password: password).doLoginIn, onFailed: autoLoginFailed)
    }
    
    func autoLoginFailed(error: IOTError){
        print("Auto login failed: " + error.errorMsg!)
        showLoginScreen()
    }

    func showLoginScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc         = storyboard.instantiateViewControllerWithIdentifier("login")
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
    
    func gotoAdminUserScreen() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginVC = storyboard.instantiateViewControllerWithIdentifier("login") as! LoginViewController
        
        let adminUserTabVC = storyboard.instantiateViewControllerWithIdentifier("adminUser") as! AdminUserTabViewController
        
        //setup tab average value
        let avListVC = storyboard.instantiateViewControllerWithIdentifier("adminUserSiteList") as! AdminUserSiteListViewController
        avListVC.dataLoader = AverageValueLoader()
        
        avListVC.tabBarItem.title = getString(StringKey.ADMINUSER_TAB_AVERAGEVALUE)
        
        avListVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Highlighted)
        avListVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState: UIControlState.Normal)
        
        avListVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: Fonts.FONT_TABBAR], forState: UIControlState.Normal)
        
        avListVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -14)
        
        
        let rdListVC = storyboard.instantiateViewControllerWithIdentifier("adminUserSiteList") as! AdminUserSiteListViewController
        
        rdListVC.dataLoader = RealtimeDataLoader()
        
        rdListVC.tabBarItem.title = getString(StringKey.ADMINUSER_TAB_REALTIMEDATA)
        
        rdListVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Highlighted)
        rdListVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState: UIControlState.Normal)
        
        rdListVC.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: Fonts.FONT_TABBAR], forState: UIControlState.Normal)
        
        rdListVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -14)
        
        adminUserTabVC.viewControllers = [avListVC, rdListVC]
        
        self.window?.rootViewController = loginVC
        self.window?.makeKeyAndVisible()
        
        loginVC.presentViewController(adminUserTabVC, animated: true, completion: nil)
        
    }
    
    func gotoNormalUserScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewControllerWithIdentifier("login") as! LoginViewController
        let normalUserTabVC = storyboard.instantiateViewControllerWithIdentifier("normalUser") as! NormalUserTabViewController
        
        self.window?.rootViewController = loginVC
        self.window?.makeKeyAndVisible()
        
        loginVC.presentViewController(normalUserTabVC, animated: true, completion: nil)
        
    }
    
    struct SessionHandler {
        let appDelegate: AppDelegate
        let loginName: String
        let password: String
        
        init(appDelegate: AppDelegate, loginName: String, password: String){
            self.appDelegate = appDelegate
            self.loginName = loginName
            self.password = password
        }
        
        func doLoginIn(session: Session){
            IOTServer.getServer().login(
                session.sessionID,
                loginName: loginName,
                password: password,
                onSucceed: LoginHandler(appDelegate: appDelegate, session: session).loginSucceed,
                onFailed: appDelegate.autoLoginFailed)
            
        }
    }
    
    struct LoginHandler {
        let appDelegate: AppDelegate
        let session: Session
        
        init(appDelegate: AppDelegate, session: Session){
            self.appDelegate = appDelegate
            self.session = session
        }
        
        func loginSucceed(user: User){
            //first set session ID and login user
            
            SessionManager.sharedInstance.session = session
            SessionManager.sharedInstance.loginUser = user
            
            
            if user.isAdminUser() {
                NotificationManager.sharedInstance.registerPushNotification()
                appDelegate.gotoAdminUserScreen()
            }else if user.isNormalUser() {
                NotificationManager.sharedInstance.registerPushNotification()
                appDelegate.gotoNormalUserScreen()
            }else{
                if AppConfig.TEST {
                    NotificationManager.sharedInstance.registerPushNotification()
                    appDelegate.gotoAdminUserScreen()
                }else{
                    appDelegate.autoLoginFailed(IOTError(errorCode: IOTError.UserPermissionWrongError, errorGroup: "Client"))
                }
            }
        }
    }

}

