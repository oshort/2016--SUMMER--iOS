//
//  WorldTimeTableViewController.swift
//  Global Time
//
//  Created by Ben Gohlke on 8/22/16.
//  Copyright © 2016 The Iron Yard. All rights reserved.
//

import UIKit

protocol TimeZoneDelegate
{
    func didChooseTimeZone(timezone: String)
}

class WorldTimeTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, TimeZoneDelegate
{
    
    var selectedTimeZones = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Global Time"
        //selectedTimeZones.append("America/New York")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return selectedTimeZones.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ClockCell") as! ClockCell

        // Configure the cell...
        let timeZoneName = selectedTimeZones[indexPath.row]
        let possibleTimeZone = NSTimeZone(name: timeZoneName)
        if let timezone = possibleTimeZone
        {
            cell.clockView.timezone = timezone
        }
        cell.timeZoneLabel.text = timeZoneName
        

        return cell
    }
    
    func didChooseTimeZone(timezone: String)
    {
        dismissViewControllerAnimated(true, completion: nil)
        selectedTimeZones.append(timezone)
        tableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "PopoverTimeZonesSegue"
        {
            let timeZonesTVC = segue.destinationViewController as! TimeZonesTableViewController
            timeZonesTVC.popoverPresentationController?.delegate = self
            timeZonesTVC.preferredContentSize = CGSize(width: 200, height: view.frame.size.height / 2.0)
            timeZonesTVC.delegate = self
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .None
    }
}
