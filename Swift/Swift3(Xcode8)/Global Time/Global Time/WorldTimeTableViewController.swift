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

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return selectedTimeZones.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClockCell", for: indexPath) as! ClockCell

        // Configure the cell...
        let timeZoneName = selectedTimeZones[indexPath.row]
        let possibleTimeZone = NSTimeZone(name: timeZoneName)
        if let timezone = possibleTimeZone
        {
            cell.clockView.timezone = timezone
        }
        let timezoneComponents = timeZoneName.components(separatedBy: "/")
        cell.timeZoneLabel.text = timezoneComponents[timezoneComponents.count-1].replacingOccurrences(of: "_", with: " ")
        

        return cell
    }
    
    func didChooseTimeZone(timezone: String)
    {
        dismiss(animated: true, completion: nil)
        selectedTimeZones.append(timezone)
        tableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "PopoverTimeZonesSegue"
        {
            let timeZonesTVC = segue.destination as! TimeZonesTableViewController
            timeZonesTVC.popoverPresentationController?.delegate = self
            timeZonesTVC.preferredContentSize = CGSize(width: view.frame.size.width * 0.7, height: view.frame.size.height * 0.7)
            timeZonesTVC.delegate = self
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .none
    }
}
