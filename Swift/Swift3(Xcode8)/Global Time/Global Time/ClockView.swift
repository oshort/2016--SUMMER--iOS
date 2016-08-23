//
//  ClockView.swift
//  Clock
//
//  Created by Ben Gohlke on 11/16/15.
//  Copyright © 2015 The Iron Yard. All rights reserved.
//

import UIKit

let borderWidth: CGFloat = 2
let borderAlpha: CGFloat = 1.0
let graduationOffset: CGFloat = 10
let graduationLength: CGFloat = 5.0
let graduationWidth: CGFloat = 1.0
let digitOffset: CGFloat = 10

@IBDesignable
class ClockView: UIView
{
    
    var animationTimer: CADisplayLink?
    
    var timezone: NSTimeZone?
        {
        didSet {
            animationTimer = CADisplayLink(target: self, selector: #selector(ClockView.timerFired(_:)))
            animationTimer!.frameInterval = 8
            animationTimer!.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        }
    }
    var time: NSDate?
    var seconds: Int = 0
    var minutes: Int = 0
    var hours: Int = 0
    
    var clockBgColor = UIColor.blackColor()
    var borderColor = UIColor.whiteColor()
    var digitColor = UIColor.whiteColor()
    var digitFont: UIFont
    
    override init(frame: CGRect)
    {
        digitFont = UIFont()
        super.init(frame: frame)
        let fontSize = 8.0 + frame.size.width/50.0
        digitFont = UIFont.systemFontOfSize(fontSize)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        digitFont = UIFont()
        super.init(coder: aDecoder)
        let fontSize = 8.0 + frame.size.width/50.0
        digitFont = UIFont.systemFontOfSize(fontSize)
        self.backgroundColor = UIColor.clearColor()
    }
    
    func secondsHandPosition() -> CGPoint
    {
        let secondsAsRadians = Float(Double(seconds) / 60.0 * 2.0 * M_PI - M_PI_2)
        let handRadius = CGFloat(frame.size.width / 3.2)
        return CGPoint(x: handRadius*CGFloat(cosf(secondsAsRadians)) + frame.size.width/2.0, y: handRadius*CGFloat(sinf(secondsAsRadians)) + frame.size.height/2.0)
    }
    
    func minutesHandPosition() -> CGPoint
    {
        let minutesAsRadians = Float(Double(minutes) / 60.0 * 2.0 * M_PI - M_PI_2)
        let handRadius = CGFloat(frame.size.width / 3.6)
        return CGPoint(x: handRadius*CGFloat(cosf(minutesAsRadians)) + frame.size.width/2.0, y: handRadius*CGFloat(sinf(minutesAsRadians)) + frame.size.height/2.0)
    }
    
    func hourHandPosition() -> CGPoint
    {
        let halfClock = Double(hours) + Double(minutes) / 60.0
        let hoursAsRadians = Float(halfClock / 12.0 * 2.0 * M_PI - M_PI_2)
        let handRadius = CGFloat(frame.size.width / 4.2)
        return CGPoint(x: handRadius*CGFloat(cosf(hoursAsRadians)) + frame.size.width/2.0, y: handRadius*CGFloat(sinf(hoursAsRadians)) + frame.size.height/2.0)
    }
    
    override func drawRect(rect: CGRect)
    {
        // clock face
        let cxt = UIGraphicsGetCurrentContext()
        CGContextAddEllipseInRect(cxt, rect)
        CGContextSetFillColorWithColor(cxt, clockBgColor.CGColor)
        CGContextFillPath(cxt)
        
        // clock's center
        var radius: CGFloat = 6.0
        let center2 = CGRect(x: frame.size.width/2.0 - radius, y: frame.size.height/2.0 - radius, width: 2 * radius, height: 2 * radius)
        CGContextAddEllipseInRect(cxt, center2)
        CGContextSetFillColorWithColor(cxt, digitColor.CGColor)
        CGContextFillPath(cxt)
        
        // clock's border
        CGContextAddEllipseInRect(cxt, CGRect(x: rect.origin.x + borderWidth/2, y: rect.origin.y + borderWidth/2, width: rect.size.width - borderWidth, height: rect.size.height - borderWidth))
        CGContextSetStrokeColorWithColor(cxt, borderColor.CGColor)
        CGContextSetLineWidth(cxt, borderWidth)
        CGContextStrokePath(cxt)
        
        // numerals
        
        let center = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        let markingDistanceFromCenter = rect.size.width / 2.0 - digitFont.lineHeight / 4.0 - 15 + digitOffset
        let offset = 4
        
        for i in 0..<12
        {
            let hourString: NSString
            if i + 1 < 10
            {
                hourString = " \(i + 1)"
            }
            else
            {
                hourString = "\(i + 1)"
            }
            let labelX = center.x + (markingDistanceFromCenter - digitFont.lineHeight / 2.0) * CGFloat(cos((M_PI / 180) * Double(i + offset) * 30 + M_PI))
            let labelY = center.y - 1 * (markingDistanceFromCenter - digitFont.lineHeight / 2.0) * CGFloat(sin((M_PI / 180) * Double(i + offset) * 30))
            hourString.drawInRect(CGRect(x: labelX - digitFont.lineHeight / 2.0, y: labelY - digitFont.lineHeight / 2.0, width: digitFont.lineHeight, height: digitFont.lineHeight), withAttributes: [NSForegroundColorAttributeName: digitColor, NSFontAttributeName: digitFont])
            
        }
        
        // hands
        
        let minHandPos = minutesHandPosition()
        CGContextSetStrokeColorWithColor(cxt, digitColor.CGColor)
        CGContextBeginPath(cxt)
        CGContextMoveToPoint(cxt, frame.size.width/2.0, frame.size.height/2.0)
        CGContextSetLineWidth(cxt, 4.0)
        CGContextAddLineToPoint(cxt, minHandPos.x, minHandPos.y)
        CGContextStrokePath(cxt)
        
        let hourHandPos = hourHandPosition()
        CGContextSetStrokeColorWithColor(cxt, digitColor.CGColor)
        CGContextBeginPath(cxt)
        CGContextMoveToPoint(cxt, frame.size.width/2.0, frame.size.height/2.0)
        CGContextSetLineWidth(cxt, 4.0)
        CGContextAddLineToPoint(cxt, hourHandPos.x, hourHandPos.y)
        CGContextStrokePath(cxt)
        
        let secHandPos = secondsHandPosition()
        CGContextSetStrokeColorWithColor(cxt, UIColor.redColor().CGColor)
        CGContextBeginPath(cxt)
        CGContextMoveToPoint(cxt, frame.size.width/2.0, frame.size.height/2.0)
        CGContextSetLineWidth(cxt, 1.0)
        CGContextAddLineToPoint(cxt, secHandPos.x, secHandPos.y)
        CGContextStrokePath(cxt)
        
        // second hand's center
        
        radius = 3.0
        let center3 = CGRect(x: frame.size.width/2.0 - radius, y: frame.size.height/2.0 - radius, width: 2 * radius, height: 2 * radius)
        CGContextAddEllipseInRect(cxt, center3)
        CGContextSetFillColorWithColor(cxt, UIColor.redColor().CGColor)
        CGContextFillPath(cxt)
    }
    
    func timerFired(sender: AnyObject)
    {
        time = NSDate()
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        calendar?.timeZone = timezone!
        let weekdayComponents = calendar?.components([.Hour, .Minute, .Second], fromDate: time!)
        hours = (weekdayComponents?.hour)!
        minutes = (weekdayComponents?.minute)!
        seconds = (weekdayComponents?.second)!
        setNeedsDisplay()
    }
    
    deinit
    {
        animationTimer?.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
}