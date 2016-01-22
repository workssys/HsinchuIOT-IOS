//
//  NormalUserSiteViewController.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 1/16/16.
//  Copyright © 2016 SL Studio. All rights reserved.
//

import Foundation

class NormalUserSiteHomeViewController: UIViewController {
    
    var currentSite: Site?
    
    @IBOutlet weak var btnLogoff: UIButton!
    
    @IBOutlet weak var btnAlarm: UIButton!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var btnDetail: UIButton!
    
    @IBOutlet weak var lbBottom: UILabel!
    
    @IBOutlet weak var panelCO2: EclipsePanelView!
    
    @IBOutlet weak var iconCO2: StatusIconView!
    
    @IBOutlet weak var lbCO2Name: FBGlowLabel!
    
    @IBOutlet weak var lbCO2Value: FBGlowLabel!
    
    @IBOutlet weak var lbCO2Unit: FBGlowLabel!
    
    @IBOutlet weak var panelTemperature: EclipsePanelView!
    
    @IBOutlet weak var iconTemperature: StatusIconView!
    
    @IBOutlet weak var lbTemperatureName: FBGlowLabel!
    
    @IBOutlet weak var lbTemperatureValue: FBGlowLabel!
    
    @IBOutlet weak var lbTemperatureUnit: FBGlowLabel!
    
    @IBOutlet weak var panelHumidity: EclipsePanelView!
    
    @IBOutlet weak var iconHumidity: StatusIconView!
    
    @IBOutlet weak var lbHumidityName: FBGlowLabel!
    
    @IBOutlet weak var lbHumidityValue: FBGlowLabel!
    
    @IBOutlet weak var lbHumidityUnit: FBGlowLabel!
    
    private var timer: NSTimer?
    
    var refreshInterval: NSTimeInterval = 10
    
    private var lastCallName: String? = nil
    
    var requestHandlers = [String: RealtimeDataHandler]()
    
    //var refreshIntervalQueue = dispatch_queue_create("normaluser_refresh_interval_queue", DISPATCH_QUEUE_CONCURRENT)
    
    override func viewDidLoad() {
    
        self.tabBarController?.moreNavigationController.navigationBarHidden = true
        
        lbTitle.font = Fonts.FONT_TITLE
        lbTitle.text = currentSite?.siteName
        
        
        lbBottom.font = Fonts.FONT_INFO
        
        panelCO2.gradientStartColor = Colors.PANEL_STATUS_NORMAL_START
        panelCO2.gradientEndColor = Colors.PANEL_STATUS_NORMAL_END
        
        iconCO2.shadowGradientStartColor = Colors.PANEL_STATUS_NORMAL_START
        iconCO2.shadowGradientEndColor = Colors.PANEL_STATUS_NORMAL_END
        iconCO2.fillColor = Colors.STATUS_ICON_NORMAL
        
        lbCO2Name.text = getString(StringKey.NORMALUSER_CO2_NAME)
        lbCO2Name.textColor = Colors.PANEL_CAPTION_TEXT
        lbCO2Name.font = Fonts.FONT_PANEL_CAPTION
        lbCO2Name.shadowColor = Colors.PANEL_CAPTION_TEXT_SHADOW
        lbCO2Name.shadowOffset = CGSize(width: 0, height: 2)
        lbCO2Name.glowColor = Colors.PANEL_CAPTION_TEXT_SHADOW
        lbCO2Name.glowSize = 2
        
        lbCO2Value.text = ""
        lbCO2Value.textColor = Colors.PANEL_TEXT_STATUS_NORMAL
        lbCO2Value.font = Fonts.FONT_PANEL_VALUE
        lbCO2Value.glowColor = Colors.PANEL_TEXT_SHADOW
        lbCO2Value.glowSize = 16
        
        lbCO2Unit.text = getString(StringKey.NORMALUSER_CO2_UNIT)
        lbCO2Unit.textColor = Colors.PANEL_UNIT_TEXT
        lbCO2Unit.font = Fonts.FONT_PANEL_UNIT
        lbCO2Unit.shadowColor = Colors.PANEL_UNIT_TEXT_SHADOW
        lbCO2Unit.shadowOffset = CGSize(width: 0, height: 2)
        lbCO2Unit.glowColor = Colors.PANEL_UNIT_TEXT_SHADOW
        lbCO2Unit.glowSize = 2
        
        panelTemperature.gradientStartColor = Colors.PANEL_STATUS_NORMAL_START
        panelTemperature.gradientEndColor = Colors.PANEL_STATUS_NORMAL_END
        
        iconTemperature.shadowGradientStartColor = Colors.PANEL_STATUS_NORMAL_START
        iconTemperature.shadowGradientEndColor = Colors.PANEL_STATUS_NORMAL_END
        iconTemperature.fillColor = Colors.STATUS_ICON_NORMAL
        
        lbTemperatureName.text = getString(StringKey.NORMALUSER_TEMPERATURE_NAME)
        lbTemperatureName.textColor = Colors.PANEL_CAPTION_TEXT
        lbTemperatureName.font = Fonts.FONT_PANEL_CAPTION
        lbTemperatureName.shadowColor = Colors.PANEL_CAPTION_TEXT_SHADOW
        lbTemperatureName.shadowOffset = CGSize(width: 0, height: 2)
        lbTemperatureName.glowColor = Colors.PANEL_CAPTION_TEXT_SHADOW
        lbTemperatureName.glowSize = 2
        
        lbTemperatureValue.text = ""
        lbTemperatureValue.textColor = Colors.PANEL_TEXT_STATUS_NORMAL
        lbTemperatureValue.font = Fonts.FONT_PANEL_VALUE
        lbTemperatureValue.glowColor = Colors.PANEL_TEXT_SHADOW
        lbTemperatureValue.glowSize = 16
        
        lbTemperatureUnit.text = getString(StringKey.NORMALUSER_TEMPERATURE_UNIT)
        lbTemperatureUnit.textColor = Colors.PANEL_UNIT_TEXT
        lbTemperatureUnit.font = Fonts.FONT_PANEL_UNIT
        lbTemperatureUnit.shadowColor = Colors.PANEL_UNIT_TEXT_SHADOW
        lbTemperatureUnit.shadowOffset = CGSize(width: 0, height: 2)
        lbTemperatureUnit.glowColor = Colors.PANEL_UNIT_TEXT_SHADOW
        lbTemperatureUnit.glowSize = 2

        panelHumidity.gradientStartColor = Colors.PANEL_STATUS_NORMAL_START
        panelHumidity.gradientEndColor = Colors.PANEL_STATUS_NORMAL_END
        
        iconHumidity.shadowGradientStartColor = Colors.PANEL_STATUS_NORMAL_START
        iconHumidity.shadowGradientEndColor = Colors.PANEL_STATUS_NORMAL_END
        iconHumidity.fillColor = Colors.STATUS_ICON_NORMAL
        
        lbHumidityName.text = getString(StringKey.NORMALUSER_HUMIDITY_NAME)
        lbHumidityName.textColor = Colors.PANEL_CAPTION_TEXT
        lbHumidityName.font = Fonts.FONT_PANEL_CAPTION
        lbHumidityName.shadowColor = Colors.PANEL_CAPTION_TEXT_SHADOW
        lbHumidityName.shadowOffset = CGSize(width: 0, height: 2)
        lbHumidityName.glowColor = Colors.PANEL_CAPTION_TEXT_SHADOW
        lbHumidityName.glowSize = 2
        
        lbHumidityValue.text = ""
        lbHumidityValue.textColor = Colors.PANEL_TEXT_STATUS_NORMAL
        lbHumidityValue.font = Fonts.FONT_PANEL_VALUE
        lbHumidityValue.glowColor = Colors.PANEL_TEXT_SHADOW
        lbHumidityValue.glowSize = 16
        
        lbHumidityUnit.text = getString(StringKey.NORMALUSER_HUMIDITY_UNIT)
        lbHumidityUnit.textColor = Colors.PANEL_UNIT_TEXT
        lbHumidityUnit.font = Fonts.FONT_PANEL_UNIT
        lbHumidityUnit.shadowColor = Colors.PANEL_UNIT_TEXT_SHADOW
        lbHumidityUnit.shadowOffset = CGSize(width: 0, height: 2)
        lbHumidityUnit.glowColor = Colors.PANEL_UNIT_TEXT_SHADOW
        lbHumidityUnit.glowSize = 2
    
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateAlarmStatus()
        
        startTimer()
        
        lastCallName = nil
        getDeviceRealtimeData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        stopTimer()
        hideWaitingBar()
        for callName in requestHandlers.keys {
            if let requestHandler = requestHandlers[callName] {
                print("set request handle cancelled - \(callName)")
                requestHandler.cancelled = true
            }
        }
        
        if let callName = lastCallName {
            self.cancelDelayed(callName)
        }
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        
        let selectedIndex = self.tabBarController!.selectedIndex
        
        if selectedIndex > 0 {
            if let fromView = self.tabBarController?.selectedViewController?.view,
                toView = self.tabBarController?.viewControllers?[selectedIndex - 1].view {
                    UIView.transitionFromView(fromView, toView: toView, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: { (finished) -> Void in
                        if finished {
                            self.tabBarController!.selectedIndex -= 1
                        }
                    })
            }
        }
    }
    
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
       
        let selectedIndex = self.tabBarController!.selectedIndex
        
        if let count = self.tabBarController?.viewControllers?.count {
            if selectedIndex < count - 1{
                if let fromView = self.tabBarController?.selectedViewController?.view,
                    toView = self.tabBarController?.viewControllers?[selectedIndex + 1].view {
                        UIView.transitionFromView(fromView, toView: toView, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: { (finished) -> Void in
                            if finished {
                                self.tabBarController!.selectedIndex += 1
                            }
                        })
                }
            }
        }


    }
    
    @IBAction func btnLogoffClicked(sender: UIButton) {
        SessionManager.sharedInstance.session = nil
        SessionManager.sharedInstance.loginUser = nil
        
        if self.presentingViewController == nil{
            if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc         = storyboard.instantiateViewControllerWithIdentifier("login")
                
                appDelegate.window?.rootViewController = vc
                
                appDelegate.window?.makeKeyAndVisible()
            }
        }else {
            self.dismissViewControllerAnimated(true, completion: {
                print("dismiss vc")
            })
        }
        
        
        

    }
    
    @IBAction func btnAlarmClicked(sender: UIButton) {
        self.performSegueWithIdentifier("alarmList", sender: self)
    }
    
    @IBAction func btnDetailClicked(sender: UIButton) {
        self.performSegueWithIdentifier("siteDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "siteDetail" {
            if let detailVC = segue.destinationViewController as? SiteDetailViewController{
                detailVC.currentSite = self.currentSite
                detailVC.currentChartType = SiteDetailViewController.ChartType.Realtime
                detailVC.rtChartDuration = 10
                detailVC.aggrChartGranularity = SiteDetailViewController.AggregationChartGranularity.Seconds
                
                let now = NSDate()
                let start = now.dateByAddingTimeInterval(-10 * 60)
                detailVC.chartStartTime = start
                detailVC.chartEndTime = now
            }
        }else if segue.identifier == "alarmList" {
            if let alarmListVC = segue.destinationViewController as? AlarmListViewController {
                alarmListVC.site = self.currentSite
                alarmListVC.alarms = AlarmManager.sharedInstance.loadAlarmList(self.currentSite)
            }
        }
    }
    
    func updateAlarmStatus() {
        if AlarmManager.sharedInstance.loadAlarmList(currentSite).count > 0 {
            btnAlarm.setImage(UIImage(named: "btn_alarm_red.png") , forState: UIControlState.Normal)
            btnAlarm.setImage(UIImage(named: "btn_alarm_red_pressed.png"), forState: UIControlState.Highlighted)
        }else {
            btnAlarm.setImage(UIImage(named: "btn_alarm.png") , forState: UIControlState.Normal)
            btnAlarm.setImage(UIImage(named: "btn_alarm_pressed.png"), forState: UIControlState.Highlighted)
        }
    }
    
    func startTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTimeInfo:", userInfo: nil, repeats:true);
        timer!.fire()
    }
    
    func stopTimer(){
        if let t = timer{
            if t.valid {
                t.invalidate()
            }
            timer = nil
        }
    }
    
    func getDeviceRealtimeData(){
        
        print("get real time data for site: \(currentSite?.siteName!)")
        showWaitingBar()
        
        
        lastCallName = "\(NSDate().timeIntervalSince1970)"
        
        let handler = RealtimeDataHandler(controller: self, handlerName: lastCallName!)
        requestHandlers[lastCallName!] = handler
        
        if let sessionID = SessionManager.sharedInstance.session?.sessionID, deviceID = currentSite?.device?.deviceID{
             IOTServer.getServer().getDeviceRealtimeData(sessionID,
                deviceID: deviceID,
                onSucceed: handler.process,
                onFailed: showError)
        }else{
            showError(IOTError(errorCode: IOTError.InvalidSessionError, errorGroup: "Client"))
        }
    }
    
    func updateRealtimeData(callName: String, data: IOTMonitorData?) {
        
        print("update real time date for site: \(currentSite?.siteName!)")
            
        hideWaitingBar()
        
        updateUI(data)
        
        self.delayed(self.refreshInterval, name: callName, closure: self.getDeviceRealtimeData)
        
        //self.performSelector("getDeviceRealtimeData", withObject: nil, afterDelay: self.refreshInterval)
        /*
        if (!stopRefresh) {
            
            dispatch_async(refreshIntervalQueue){
                NSThread.sleepForTimeInterval(self.refreshInterval)
                dispatch_async(dispatch_get_main_queue()){
                    if(!self.stopRefresh) {
                        self.getDeviceRealtimeData()
                    }
                }
            }
        } */
    }
    
    
    func updateUI(data: IOTMonitorData?) {
    
        if let d = data {
            if let co2 = d.co2 {
                let co2Str: NSString = "\(co2)"
                let textSize = co2Str.sizeWithAttributes([NSFontAttributeName:Fonts.FONT_PANEL_VALUE])
                lbCO2Value.frame = CGRectMake(lbCO2Value.frame.origin.x, lbCO2Value.frame.origin.y, textSize.width + 20, lbCO2Value.frame.height)
                lbCO2Value.text = co2Str as String
                
                lbCO2Unit.frame = CGRectMake(lbCO2Value.frame.origin.x + textSize.width + 20, lbCO2Unit.frame.origin.y, lbCO2Unit.frame.width, lbCO2Unit.frame.height)
            } else {
                lbCO2Value.text = ""
            }
            if d.isCO2Missing() {
                panelCO2.gradientStartColor = Colors.PANEL_STATUS_MISSING_START
                panelCO2.gradientEndColor = Colors.PANEL_STATUS_MISSING_END
                lbCO2Value.textColor = Colors.PANEL_TEXT_STATUS_MISSING
                iconCO2.shadowGradientStartColor = Colors.PANEL_STATUS_MISSING_START
                iconCO2.shadowGradientEndColor = Colors.PANEL_STATUS_MISSING_END
                iconCO2.fillColor = Colors.STATUS_ICON_MISSING
                
            }else if d.isCO2Alarm() {
                panelCO2.gradientStartColor = Colors.PANEL_STATUS_WORST_START
                panelCO2.gradientEndColor = Colors.PANEL_STATUS_WORST_END
                lbCO2Value.textColor = Colors.PANEL_TEXT_STATUS_WORST
                iconCO2.shadowGradientStartColor = Colors.PANEL_STATUS_WORST_START
                iconCO2.shadowGradientEndColor = Colors.PANEL_STATUS_WORST_END
                iconCO2.fillColor = Colors.STATUS_ICON_ALARM
                
                
            }else if d.isCO2Warning(){
                panelCO2.gradientStartColor = Colors.PANEL_STATUS_WORSE_START
                panelCO2.gradientEndColor = Colors.PANEL_STATUS_WORSE_END
                lbCO2Value.textColor = Colors.PANEL_TEXT_STATUS_WORSE
                iconCO2.shadowGradientStartColor = Colors.PANEL_STATUS_WORSE_START
                iconCO2.shadowGradientEndColor = Colors.PANEL_STATUS_WORSE_END
                iconCO2.fillColor = Colors.STATUS_ICON_WARNING
            }else{
                panelCO2.gradientStartColor = Colors.PANEL_STATUS_NORMAL_START
                panelCO2.gradientEndColor = Colors.PANEL_STATUS_NORMAL_END
                lbCO2Value.textColor = Colors.PANEL_TEXT_STATUS_NORMAL
                iconCO2.shadowGradientStartColor = Colors.PANEL_STATUS_NORMAL_START
                iconCO2.shadowGradientEndColor = Colors.PANEL_STATUS_NORMAL_END
                iconCO2.fillColor = Colors.STATUS_ICON_NORMAL
            }
            
            if let temp = d.temperature {
                let tempStr: NSString = "\(temp)"
                let textSize = tempStr.sizeWithAttributes([NSFontAttributeName:Fonts.FONT_PANEL_VALUE])
                lbTemperatureValue.frame = CGRectMake(lbTemperatureValue.frame.origin.x, lbTemperatureValue.frame.origin.y, textSize.width + 20, lbTemperatureValue.frame.height)
                lbTemperatureValue.text = tempStr as String
                
                lbTemperatureUnit.frame = CGRectMake(lbTemperatureValue.frame.origin.x + textSize.width + 20, lbTemperatureValue.frame.origin.y, lbTemperatureUnit.frame.width, lbTemperatureUnit.frame.height)
                
                if temp < 15 {
                    panelTemperature.gradientStartColor = Colors.PANEL_STATUS_COLD_START
                    panelTemperature.gradientEndColor = Colors.PANEL_STATUS_COLD_END
                    lbTemperatureValue.textColor = Colors.PANEL_TEXT_STATUS_COLD
                    iconTemperature.shadowGradientStartColor = Colors.PANEL_STATUS_COLD_START
                    iconTemperature.shadowGradientEndColor = Colors.PANEL_STATUS_COLD_END
                }else if temp > 28 {
                    panelTemperature.gradientStartColor = Colors.PANEL_STATUS_HOT_START
                    panelTemperature.gradientEndColor = Colors.PANEL_STATUS_HOT_END
                    lbTemperatureValue.textColor = Colors.PANEL_TEXT_STATUS_HOT
                    iconTemperature.shadowGradientStartColor = Colors.PANEL_STATUS_HOT_START
                    iconTemperature.shadowGradientEndColor = Colors.PANEL_STATUS_HOT_END
                }else{
                    panelTemperature.gradientStartColor = Colors.PANEL_STATUS_NORMAL_START
                    panelTemperature.gradientEndColor = Colors.PANEL_STATUS_NORMAL_END
                    lbTemperatureValue.textColor = Colors.PANEL_TEXT_STATUS_NORMAL
                    iconTemperature.shadowGradientStartColor = Colors.PANEL_STATUS_NORMAL_START
                    iconTemperature.shadowGradientEndColor = Colors.PANEL_STATUS_NORMAL_END
                }
            } else {
                lbTemperatureValue.text = ""
                panelTemperature.gradientStartColor = Colors.PANEL_STATUS_MISSING_START
                panelTemperature.gradientEndColor = Colors.PANEL_STATUS_MISSING_END
                lbTemperatureValue.textColor = Colors.PANEL_TEXT_STATUS_MISSING
                iconTemperature.shadowGradientStartColor = Colors.PANEL_STATUS_MISSING_START
                iconTemperature.shadowGradientEndColor = Colors.PANEL_STATUS_MISSING_END
            }
            
            if d.isTemperatureMissing() {
                iconTemperature.fillColor = Colors.STATUS_ICON_MISSING
            }else if d.isTemperatureAlarm() {
                iconTemperature.fillColor = Colors.STATUS_ICON_ALARM
            }else if d.isTemperatureWarning() {
                iconTemperature.fillColor = Colors.STATUS_ICON_WARNING
            }else {
                iconTemperature.fillColor = Colors.STATUS_ICON_NORMAL
            }

            if let humidity = d.humidity {
                let humidityStr: NSString = "\(humidity)"
                let textSize = humidityStr.sizeWithAttributes([NSFontAttributeName:Fonts.FONT_PANEL_VALUE])
                lbHumidityValue.frame = CGRectMake(lbHumidityValue.frame.origin.x, lbHumidityValue.frame.origin.y, textSize.width + 20, lbHumidityValue.frame.height)
                lbHumidityValue.text = humidityStr as String
                
                lbHumidityUnit.frame = CGRectMake(lbHumidityValue.frame.origin.x + textSize.width + 20, lbHumidityValue.frame.origin.y, lbHumidityUnit.frame.width, lbHumidityUnit.frame.height)
                
                if humidity < 40 {
                    panelHumidity.gradientStartColor = Colors.PANEL_STATUS_DRY_START
                    panelHumidity.gradientEndColor = Colors.PANEL_STATUS_DRY_END
                    lbHumidityValue.textColor = Colors.PANEL_TEXT_STATUS_DRY
                    iconHumidity.shadowGradientStartColor = Colors.PANEL_STATUS_DRY_START
                    iconHumidity.shadowGradientEndColor = Colors.PANEL_STATUS_DRY_END
                }else if humidity > 60 {
                    panelHumidity.gradientStartColor = Colors.PANEL_STATUS_WET_START
                    panelHumidity.gradientEndColor = Colors.PANEL_STATUS_WET_END
                    lbHumidityValue.textColor = Colors.PANEL_TEXT_STATUS_WET
                    iconHumidity.shadowGradientStartColor = Colors.PANEL_STATUS_WET_START
                    iconHumidity.shadowGradientEndColor = Colors.PANEL_STATUS_WET_END
                }else{
                    panelHumidity.gradientStartColor = Colors.PANEL_STATUS_NORMAL_START
                    panelHumidity.gradientEndColor = Colors.PANEL_STATUS_NORMAL_END
                    lbHumidityValue.textColor = Colors.PANEL_TEXT_STATUS_NORMAL
                    iconHumidity.shadowGradientStartColor = Colors.PANEL_STATUS_NORMAL_START
                    iconHumidity.shadowGradientEndColor = Colors.PANEL_STATUS_NORMAL_END
                }
            } else {
                lbHumidityValue.text = ""
                panelHumidity.gradientStartColor = Colors.PANEL_STATUS_MISSING_START
                panelHumidity.gradientEndColor = Colors.PANEL_STATUS_MISSING_END
                lbHumidityValue.textColor = Colors.PANEL_TEXT_STATUS_MISSING
                iconHumidity.shadowGradientStartColor = Colors.PANEL_STATUS_MISSING_START
                iconHumidity.shadowGradientEndColor = Colors.PANEL_STATUS_MISSING_END
            }
            
            if d.isHumidityMissing() {
                iconHumidity.fillColor = Colors.STATUS_ICON_MISSING
            }else if d.isHumidityAlarm() {
                iconHumidity.fillColor = Colors.STATUS_ICON_ALARM
            }else if d.isHumidityWarning() {
                iconHumidity.fillColor = Colors.STATUS_ICON_WARNING
            }else {
                iconHumidity.fillColor = Colors.STATUS_ICON_NORMAL
            }
            
            panelCO2.setNeedsDisplay()
            iconCO2.setNeedsDisplay()

            panelTemperature.setNeedsDisplay()
            iconTemperature.setNeedsDisplay()
            
            panelHumidity.setNeedsDisplay()
            iconHumidity.setNeedsDisplay()
        }
        
    }
    
    
    func updateTimeInfo(timer: NSTimer) {
        let formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let strNow = formatter.stringFromDate(NSDate())
        lbBottom.text  = "\(strNow)"
    }

    class RealtimeDataHandler{
        var cancelled: Bool = false
        var controller: NormalUserSiteHomeViewController
        var handlerName: String
        
        init(controller: NormalUserSiteHomeViewController, handlerName: String){
            self.controller = controller
            self.handlerName = handlerName
        }
        
        func process(data: IOTMonitorData?) {
            if !cancelled {
                print("update method for handler - \(handlerName) has been called")
                controller.updateRealtimeData(handlerName, data: data)
            }else{
                print("update method for handler - \(handlerName) not called")
            }
            
            controller.requestHandlers[handlerName] = nil
        }
    }

}