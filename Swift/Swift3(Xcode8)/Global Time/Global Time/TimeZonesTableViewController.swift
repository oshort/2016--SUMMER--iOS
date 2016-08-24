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

    let timezones = NSTimeZone.knownTimeZoneNames
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

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return timezones.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeZoneCell", for: indexPath)

        // Configure the cell...
        let aTimezone = timezones[indexPath.row]
        cell.textLabel?.text = aTimezone
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didChooseTimeZone(timezone: timezones[indexPath.row])
    }
}
