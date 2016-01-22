//
//  AlarmListViewController.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 1/21/16.
//  Copyright © 2016 SL Studio. All rights reserved.
//

import Foundation

class AlarmListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var btnDeleteAll: UIButton!
    
    @IBOutlet weak var tvAlarmList: UITableView!
    
    var alarms: [Alarm] = []
    
    var site: Site? = nil
    
    var avDeleteAll: UIAlertView!
   
    var avDelete: UIAlertView!
    
    override func viewDidLoad() {
        
        lbTitle.text = getString(StringKey.ALARM_LIST_TITLE)
        avDeleteAll = UIAlertView(title: getString(StringKey.ALARM_LIST_TITLE_DELETEALL), message: getString(StringKey.ALARM_LIST_DELETEALL), delegate: self, cancelButtonTitle: getString(StringKey.CANCEL), otherButtonTitles: getString(StringKey.OK))
        avDelete = UIAlertView(title: getString(StringKey.ALARM_LIST_TITLE_DELETE), message: getString(StringKey.ALARM_LIST_DELETE), delegate: self, cancelButtonTitle: getString(StringKey.CANCEL), otherButtonTitles: getString(StringKey.OK))
        
        tvAlarmList.dataSource = self
        tvAlarmList.delegate = self
    }
    
    @IBAction func btnBackClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnDeleteAllClicked(sender: UIButton) {
        
        avDeleteAll.show()
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let c = tvAlarmList.dequeueReusableCellWithIdentifier("alarmListTableViewCell"){
            cell = c
        }else{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "alarmListTableViewCell")
        }
        
        let alarm = alarms[indexPath.row]
        
        
        
        if let ivAlarmType = cell.viewWithTag(ListItemTag.LISTITEM_ALARMLIST_ALARMTYPE) as? UIImageView{
            
            if let alarmType = alarm.alarmType {
                if alarmType == Alarm.AlarmType.BREACHED {
                    ivAlarmType.image = UIImage(named: "alarm_type_breached.png")
                }else if alarmType == Alarm.AlarmType.WARNING {
                    ivAlarmType.image = UIImage(named: "alarm_type_warning.png")
                }
            }else{
                ivAlarmType.image = UIImage(named: "alarm_type_missing.png")
            }
        }
        
        
        if let lbAlarmTime = cell.viewWithTag(ListItemTag.LISTITEM_ALARMLIST_ALARMTIME) as? UILabel {
            lbAlarmTime.text = alarm.alarmTime
        }
        
        if let lbAlarmSite = cell.viewWithTag(ListItemTag.LISTITEM_ALARMLIST_ALARMSITE) as? UILabel {
            lbAlarmSite.text = alarm.alarmSite
        }
        if let lbAlarmValueType = cell.viewWithTag(ListItemTag.LISTITEM_ALARMLIST_ALARMVALUETYPE) as? UILabel {
            lbAlarmValueType.text = alarm.alarmValueType
        }
        if let lbAlarmValue = cell.viewWithTag(ListItemTag.LISTITEM_ALARMLIST_ALARMVALUE) as? UILabel {
            lbAlarmValue.text = alarm.alarmValue
        }
        if let btnDelete = cell.viewWithTag(ListItemTag.LISTITEM_ALARMLIST_DELETEBUTTON) as? UIButton {
            btnDelete.tag = indexPath.row
            btnDelete.addTarget(self, action: "deleteAlarm:", forControlEvents: UIControlEvents.TouchUpInside)
            
        }
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("alarmChart", sender: AlarmWrapper(alarm: alarms[indexPath.row]))
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "alarmChart" {
            if let detailVC = segue.destinationViewController as? SiteDetailViewController, wrapper = sender as? AlarmWrapper {
                let alarm = wrapper.alarm
                let fakeDevice = Device(deviceID: alarm.deviceID)
                let fakeSite = Site(siteID: "FAKESITEID")
                fakeSite.device = fakeDevice
                fakeSite.siteName = alarm.alarmSite
                
                detailVC.currentSite = fakeSite
                detailVC.currentChartType = SiteDetailViewController.ChartType.Aggregation
                detailVC.rtChartDuration = 10
                detailVC.aggrChartGranularity = SiteDetailViewController.AggregationChartGranularity.Seconds
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                var time = NSDate()
                if let alarmTime = dateFormatter.dateFromString(alarm.alarmTime) {
                    time = alarmTime
                }
                let from = time.dateByAddingTimeInterval(-5 * 60)
                let to  = time.dateByAddingTimeInterval(5 * 60)
                detailVC.chartStartTime = from
                detailVC.chartEndTime = to
            }
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if let av = avDeleteAll {
            if alertView == av && buttonIndex == 1 {
                AlarmManager.sharedInstance.clearAlarms(site)
                alarms = AlarmManager.sharedInstance.loadAlarmList(site)
                tvAlarmList.reloadData()
            }
        }
        
        if let av = avDelete {
            if alertView == av && buttonIndex == 1 {
                let alarm = self.alarms[av.tag]
                //alarms.append(alarm)
                AlarmManager.sharedInstance.removeAlarms([alarm])
                alarms = AlarmManager.sharedInstance.loadAlarmList(site)
                tvAlarmList.reloadData()
            }
        }
    }
    
    func deleteAlarm(sender: UIButton) {
        avDelete.tag = sender.tag
        //avDelete.setValue(, forKey: "targetAlarm")
        avDelete.show()
    }
    
    
}