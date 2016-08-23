//
//  TimezonesTableViewController.swift
//  Global Time
//
//  Created by Ben Gohlke on 8/22/16.
//  Copyright © 2016 The Iron Yard. All rights reserved.
//

import UIKit

class TimeZonesTableViewController: UITableViewController
{

    let timezones = NSTimeZone.knownTimeZoneNames()
    var timezoneList: [String]?
    var delegate: TimeZoneDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
        return timezones.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimeZoneCell", forIndexPath: indexPath)

        // Configure the cell...
        let aTimezone = timezones[indexPath.row]
        cell.textLabel?.text = aTimezone
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        delegate?.didChooseTimeZone(timezones[indexPath.row])
    }
}
