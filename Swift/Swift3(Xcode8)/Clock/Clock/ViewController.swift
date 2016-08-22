//
//  ViewController.swift
//  Clock
//
//  Created by Ben Gohlke on 7/16/15.
//  Copyright (c) 2015 The Iron Yard. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController
{
    //@IBOutlet weak var clockView: ClockView!
    var clockView: ClockView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        clockView = ClockView(frame: CGRect(x: view.center.x - 100, y: view.center.y - 100, width: 200, height: 200))
        view.addSubview(clockView)
        clockView.timezone = NSTimeZone(name: "America/New York")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
