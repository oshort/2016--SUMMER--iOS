//
//  ColoredButton.swift
//  Simon
//
//  Created by Ben Gohlke on 8/19/16.
//  Copyright © 2016 The Iron Yard. All rights reserved.
//

import UIKit
import AudioToolbox

enum ButtonColor: Int
{
    case red = 1
    case green
    case blue
    case yellow
    case brightRed
    case brightGreen
    case brightBlue
    case brightYellow
}

class ColoredButton: UIButton
{
    var soundID: SystemSoundID = 0
    var color = ButtonColor.red {
        didSet {
            var soundURL: CFURL?
            switch color
            {
            case .red:
                backgroundColor = UIColor(hue:0.018, saturation:0.803, brightness:0.4, alpha:1)
                soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "red", "mp3", nil)
            case .brightRed:
                backgroundColor = UIColor(hue:0.016, saturation:0.801, brightness:0.65, alpha:1)
            case .blue:
                backgroundColor = UIColor(hue:0.552, saturation:0.803, brightness:0.4, alpha:1)
                soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "blue", "mp3", nil)
            case .brightBlue:
                backgroundColor = UIColor(hue:0.552, saturation:0.801, brightness:0.65, alpha:1)
            case .green:
                backgroundColor = UIColor(hue:0.389, saturation:0.803, brightness:0.4, alpha:1)
                soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "green", "mp3", nil)
            case .brightGreen:
                backgroundColor = UIColor(hue:0.389, saturation:0.801, brightness:0.65, alpha:1)
            case .yellow:
                backgroundColor = UIColor(hue:0.134, saturation:0.803, brightness:0.4, alpha:1)
                soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "yellow", "mp3", nil)
            case .brightYellow:
                backgroundColor = UIColor(hue:0.134, saturation:0.801, brightness:0.65, alpha:1)
            }
            if let url = soundURL
            {
                AudioServicesCreateSystemSoundID(url, &soundID)
            }
        }
    }
    
    func lightUp()
    {
        let normalColor = color
        switch color
        {
        case .red:
            color = .brightRed
        case .blue:
            color = .brightBlue
        case .green:
            color = .brightGreen
        case .yellow:
            color = .brightYellow
        default: break
        }
        
        AudioServicesPlaySystemSound(soundID)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.color = normalColor
        }, completion: nil)
    }
}
