//
//  DynamicsViewController.swift
//  DynamicGame
//
//  Created by Ben Gohlke on 8/18/16.
//  Copyright © 2016 The Iron Yard. All rights reserved.
//

import UIKit

class DynamicsViewController: UIViewController, UICollisionBehaviorDelegate
{
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    
    var square: UIView!
    var snap: UISnapBehavior!

    override func viewDidLoad()
    {
        super.viewDidLoad()
//        let square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        square.backgroundColor = UIColor.gray
        view.addSubview(square)
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [square])
        animator.addBehavior(gravity)
        
        collision = UICollisionBehavior(items: [square])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        let barrier = UIView(frame: CGRect(x: 0, y: 300, width: 130, height: 20))
        barrier.backgroundColor = UIColor.red
        view.addSubview(barrier)
        
        collision.addItem(barrier)
        collision.addBoundary(withIdentifier: "barrier", for: UIBezierPath(rect: barrier.frame))
        
        collision.collisionDelegate = self
        
        let itemBehavior = UIDynamicItemBehavior(items: [square])
        itemBehavior.elasticity = 0.6
        animator.addBehavior(itemBehavior)
        
        var updateCount = 0
        collision.action = {
            if updateCount % 3 == 0
            {
                let outline = UIView(frame: self.square.bounds)
                outline.transform = self.square.transform
                outline.center = self.square.center
                
                outline.alpha = 0.5
                outline.backgroundColor = UIColor.clear
                outline.layer.borderColor = self.square.layer.presentation()?.backgroundColor
                outline.layer.borderWidth = 1.0
                self.view.addSubview(outline)
            }
            
            updateCount += 1
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint)
    {
        let collidingView = item as! UIView
        collidingView.backgroundColor = UIColor.yellow
        UIView.animate(withDuration: 0.3) {
            collidingView.backgroundColor = UIColor.gray
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if snap != nil
        {
            animator.removeBehavior(snap)
        }
        
        let touch = touches.first!
        snap = UISnapBehavior(item: square, snapTo: touch.location(in: view))
        animator.addBehavior(snap)
    }
}

