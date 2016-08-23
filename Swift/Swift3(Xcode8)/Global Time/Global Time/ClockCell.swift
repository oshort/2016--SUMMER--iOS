//
//  ClockCell.swift
//  Global Time
//
//  Created by Ben Gohlke on 8/22/16.
//  Copyright © 2016 The Iron Yard. All rights reserved.
//

import UIKit

class ClockCell: UITableViewCell
{
    
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var clockView: ClockView!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
