//
//  TimeScopeSettingsViewController.swift
//  HsinchuIOT
//
//  Created by Chandler Li on 1/13/16.
//  Copyright © 2016 SL Studio. All rights reserved.
//

import Foundation
import DatePickerCell

class TimeScopeSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var delegate: TimeScopeSettingsDelegate!
    
    var startTime: NSDate!
    var endTime: NSDate!
    
    var cells: [UITableViewCell] = []

    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var tvSettings: UITableView!
    
    @IBOutlet weak var btnOk: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    override func viewDidLoad() {
        lbTitle.font = Fonts.FONT_TITLE
        lbTitle.text = getString(StringKey.TIMESCOPE_SETTINGS_TITLE)
        
        btnOk.setTitle(getString(StringKey.OK), forState: UIControlState.Normal)
        btnCancel.setTitle(getString(StringKey.CANCEL), forState: UIControlState.Normal)
        
        tvSettings.dataSource = self
        tvSettings.delegate = self
        
        tvSettings.rowHeight = UITableViewAutomaticDimension
        
        
        let startDatePickerCell = DatePickerCell(style: UITableViewCellStyle.Default, reuseIdentifier: "startTimePicker")
        startDatePickerCell.leftLabel.text = getString(StringKey.TIMESCOPE_SETTINGS_START_TIME)
        startDatePickerCell.date = startTime
        
        let endDatePickerCell = DatePickerCell(style: UITableViewCellStyle.Default, reuseIdentifier: "endTimePicker")
        endDatePickerCell.leftLabel.text = getString(StringKey.TIMESCOPE_SETTINGS_END_TIME)
        endDatePickerCell.date = endTime
        
        cells = [startDatePickerCell, endDatePickerCell]
    }
    
    @IBAction func btnOkClicked(sender: UIButton) {
        var newStartTime: NSDate? = nil
        if let startTimeCell = cells[0] as? DatePickerCell {
            newStartTime = startTimeCell.date
        }
        
        var newEndTime: NSDate? = nil
        if let endTimeCell = cells[1] as? DatePickerCell {
            newEndTime = endTimeCell.date
        }
        
        delegate.timeScopeChanged(startTime: newStartTime, endTime: newEndTime)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    @IBAction func btnCancelClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return cells[indexPath.row]
    }
    
    func tableView(tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if let c = cell as? DatePickerCell {
            return c.datePickerHeight()
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        if let c = cell as? DatePickerCell {
            c.selectedInTableView(tableView)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}