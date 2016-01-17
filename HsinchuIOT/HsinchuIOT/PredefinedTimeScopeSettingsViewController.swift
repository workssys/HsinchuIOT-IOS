//
//  PredefinedTimeScopeSettingsViewController.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 1/14/16.
//  Copyright © 2016 SL Studio. All rights reserved.
//

import Foundation

class PredefinedTimeScopeSettingsViewController: BaseViewController{
    enum PredefinedTimeScope{
        case OneHour, FourHours, EightHours
        case Today, Yesterday, Last3Days, Last5Days
        case ThisWeek, LastWeek, Last2Weeks, Last3Weeks
        case ThisMonth, LastMonth, Last2Months, Last3Months
    }
    
    
    var delegate: TimeScopeSettingsDelegate!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var btn1Hour: UIButton!
    
    @IBOutlet weak var btn4Hours: UIButton!
    
    @IBOutlet weak var btn8Hours: UIButton!
    
    @IBOutlet weak var btnToday: UIButton!
    
    @IBOutlet weak var btnYesterday: UIButton!
    
    @IBOutlet weak var btnLast3Days: UIButton!
    
    @IBOutlet weak var btnLast5Days: UIButton!
    
    @IBOutlet weak var btnThisWeek: UIButton!
    
    @IBOutlet weak var btnLastWeek: UIButton!
    
    @IBOutlet weak var btnLast2Weeks: UIButton!
    
    @IBOutlet weak var btnLast3Weeks: UIButton!
    
    @IBOutlet weak var btnThisMonth: UIButton!
    
    @IBOutlet weak var btnLastMonth: UIButton!
    
    @IBOutlet weak var btnLast2Months: UIButton!
    
    @IBOutlet weak var btnLast3Months: UIButton!
    
    override func viewDidLoad() {
        lbTitle.font = Fonts.FONT_TITLE
        lbTitle.text = getString(StringKey.TIMESCOPE_SETTINGS_TITLE)
        
        btn1Hour.setTitle(getString(StringKey.TIMESCOPE_SETTINGS_1HOUR), forState: UIControlState.Normal)
        btn4Hours.setTitle(getString(StringKey.TIMESCOPE_SETTINGS_4HOURS), forState: UIControlState.Normal)
        btn8Hours.setTitle(getString(StringKey.TIMESCOPE_SETTINGS_8HOURS), forState: UIControlState.Normal)
        btnToday.setTitle(getString(StringKey.TIMESCOPE_SETTINGS_TODAY), forState: UIControlState.Normal)
        btnYesterday.setTitle(getString(StringKey.TIMESCOPE_SETTINGS_YESTERDAY), forState: UIControlState.Normal)
        btnLast3Days.setTitle(getString(StringKey.TIMESCOPE_SETTINGS_LAST3DAYS), forState: UIControlState.Normal)
        btnLast5Days.setTitle(getString(StringKey.TIMESCOPE_SETTINGS_LAST5DAYS), forState: UIControlState.Normal)
        btnThisWeek.setTitle(getString(StringKey.TIMESCOPE_SETTINGS_THISWEEK), forState: UIControlState.Normal)
        btnLastWeek.setTitle(getString(StringKey.TIMESCOPE_SETTINGS_LASTWEEK), forState: UIControlState.Normal)
        btnLast2Weeks.setTitle(getString(StringKey.TIMESCOPE_SETTINGS_LAST2WEEKS), forState: UIControlState.Normal)
        btnLast3Weeks.setTitle(getString(StringKey.TIMESCOPE_SETTINGS_LAST3WEEKS), forState: UIControlState.Normal)
        btnThisMonth.setTitle(getString(StringKey.TIMESCOPE_SETTINGS_THISMONTH), forState: UIControlState.Normal)
        btnLastMonth.setTitle(getString(StringKey.TIMESCOPE_SETTINGS_LASTMONTH), forState: UIControlState.Normal)
        btnLast2Months.setTitle(getString(StringKey.TIMESCOPE_SETTINGS_LAST2MONTHS), forState: UIControlState.Normal)
        btnLast3Months.setTitle(getString(StringKey.TIMESCOPE_SETTINGS_LAST3MONTHS), forState: UIControlState.Normal)
        
        btnClose.setTitle(getString(StringKey.CLOSE), forState: UIControlState.Normal)
    }
    
    @IBAction func btn1HourClicked(sender: UIButton) {
        let startTime = getStartTime(PredefinedTimeScope.OneHour)
        let endTime = getEndTime(PredefinedTimeScope.OneHour)
        delegate.timeScopeChanged(startTime: startTime, endTime: endTime)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btn4HoursClicked(sender: UIButton) {
        
        delegate.timeScopeChanged(startTime: getStartTime(PredefinedTimeScope.FourHours), endTime: getEndTime(PredefinedTimeScope.FourHours))
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btn8HoursClicked(sender: UIButton) {
        delegate.timeScopeChanged(startTime: getStartTime(PredefinedTimeScope.EightHours), endTime: getEndTime(PredefinedTimeScope.EightHours))
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnTodayClicked(sender: UIButton) {
        delegate.timeScopeChanged(startTime: getStartTime(PredefinedTimeScope.Today), endTime: getEndTime(PredefinedTimeScope.Today))
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnYesterdayClicked(sender: UIButton) {
        delegate.timeScopeChanged(startTime: getStartTime(PredefinedTimeScope.Yesterday), endTime: getEndTime(PredefinedTimeScope.Yesterday))
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnLast3DaysClicked(sender: UIButton) {
        delegate.timeScopeChanged(startTime: getStartTime(PredefinedTimeScope.Last3Days), endTime: getEndTime(PredefinedTimeScope.Last3Days))
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnLast5DaysClicked(sender: UIButton) {
        delegate.timeScopeChanged(startTime: getStartTime(PredefinedTimeScope.Last5Days), endTime: getEndTime(PredefinedTimeScope.Last5Days))
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnThisWeekClicked(sender: UIButton) {
        delegate.timeScopeChanged(startTime: getStartTime(PredefinedTimeScope.ThisWeek), endTime: getEndTime(PredefinedTimeScope.ThisWeek))
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnLastWeekClicked(sender: UIButton) {
        delegate.timeScopeChanged(startTime: getStartTime(PredefinedTimeScope.LastWeek), endTime: getEndTime(PredefinedTimeScope.LastWeek))
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnLast2WeeksClicked(sender: UIButton) {
        delegate.timeScopeChanged(startTime: getStartTime(PredefinedTimeScope.Last2Weeks), endTime: getEndTime(PredefinedTimeScope.Last2Weeks))
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnLast3WeeksClicked(sender: UIButton) {
        delegate.timeScopeChanged(startTime: getStartTime(PredefinedTimeScope.Last3Weeks), endTime: getEndTime(PredefinedTimeScope.Last3Weeks))
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnThisMonthClicked(sender: UIButton) {
        delegate.timeScopeChanged(startTime: getStartTime(PredefinedTimeScope.ThisMonth), endTime: getEndTime(PredefinedTimeScope.ThisMonth))
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnLastMonthClicked(sender: UIButton) {
        delegate.timeScopeChanged(startTime: getStartTime(PredefinedTimeScope.LastMonth), endTime: getEndTime(PredefinedTimeScope.LastMonth))
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnLast2MonthsClicked(sender: UIButton) {
        delegate.timeScopeChanged(startTime: getStartTime(PredefinedTimeScope.Last2Months), endTime: getEndTime(PredefinedTimeScope.Last2Months))
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func btnLast3MonthsClicked(sender: UIButton) {
        delegate.timeScopeChanged(startTime: getStartTime(PredefinedTimeScope.Last3Months), endTime: getEndTime(PredefinedTimeScope.Last3Months))
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnCloseClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func getStartTime(timescope: PredefinedTimeScope) -> NSDate?{
        let cal = NSCalendar.currentCalendar()
        let now = NSDate()
        let components = cal.components(
            [NSCalendarUnit.Year,
                NSCalendarUnit.Month,
                NSCalendarUnit.Weekday,
                NSCalendarUnit.Day,
                NSCalendarUnit.Hour,
                NSCalendarUnit.Minute,
                NSCalendarUnit.Second
            ], fromDate: now)
        switch timescope{
        case .OneHour:
            components.hour -= 1
            print("\(components.year), \(components.month), \(components.day), \(components.hour), \(components.minute)")
        case .FourHours:
            components.hour -= 4
        case .EightHours:
            components.hour -= 8
        case .Today:
            components.hour = 0
            components.minute = 0
            components.second = 0
        case .Yesterday:
            components.day -= 1
            components.hour = 0
            components.minute = 0
            components.second = 0
        case .Last3Days:
            components.day -= 3
            components.hour = 0
            components.minute = 0
            components.second = 0
        case .Last5Days:
            components.day -= 5
            components.hour = 0
            components.minute = 0
            components.second = 0
        case .ThisWeek:
            components.day -= (components.weekday - 1)
            components.hour = 0
            components.minute = 0
            components.second = 0
        case .LastWeek:
            components.day -= (components.weekday - 1 + 7)
            components.hour = 0
            components.minute = 0
            components.second = 0
        case .Last2Weeks:
            components.day -= (components.weekday - 1 + 14)
            components.hour = 0
            components.minute = 0
            components.second = 0
        case .Last3Weeks:
            components.day -= (components.weekday - 1 + 21)
            components.hour = 0
            components.minute = 0
            components.second = 0
        case .ThisMonth:
            components.day = 1
            components.hour = 0
            components.minute = 0
            components.second = 0
        case .LastMonth:
            components.month  -= 1
            components.day = 1
            components.hour = 0
            components.minute = 0
            components.second = 0
        case .Last2Months:
            components.month  -= 2
            components.day = 1
            components.hour = 0
            components.minute = 0
            components.second = 0
        case .Last3Months:
            components.month  -= 3
            components.day = 1
            components.hour = 0
            components.minute = 0
            components.second = 0

        }
        return cal.dateFromComponents(components)
        
    }
    
    private func getEndTime(timescope: PredefinedTimeScope) -> NSDate? {
        if let startTime = getStartTime(timescope) {
            let cal = NSCalendar.currentCalendar()
            let components = cal.components(
                [NSCalendarUnit.Year,
                    NSCalendarUnit.Month,
                    NSCalendarUnit.Day,
                    NSCalendarUnit.Hour,
                    NSCalendarUnit.Minute,
                    NSCalendarUnit.Second
                    ], fromDate: startTime)
            switch timescope{
            case .Today, .ThisWeek, .ThisMonth:
                return NSDate()
            case .OneHour:
                components.hour += 1
            case .FourHours:
                components.hour += 4
            case .EightHours:
                components.hour += 8
            case .Yesterday:
                components.day += 1
                components.second -= 1
            case .Last3Days:
                components.day += 3
                components.second -= 1
            case .Last5Days:
                components.day += 5
                components.second -= 1
            case .LastWeek:
                components.day += 7
                components.second -= 1
            case .Last2Weeks:
                components.day += 14
                components.second -= 1
            case .Last3Weeks:
                components.day += 21
                components.second -= 1
            case .LastMonth:
                components.month += 1
                components.second -= 1
            case .Last2Months:
                components.month += 2
                components.second -= 1
            case .Last3Months:
                components.month += 3
                components.second -= 1
            }
            
            return cal.dateFromComponents(components)
        }
        return nil
    }
    
}