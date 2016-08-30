//
//  ViewController.swift
//  Simon
//
//  Created by Ben Gohlke on 8/18/16.
//  Copyright © 2016 The Iron Yard. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController
{

    @IBOutlet weak var redSquare: ColoredButton!
    @IBOutlet weak var greenSquare: ColoredButton!
    @IBOutlet weak var yellowSquare: ColoredButton!
    @IBOutlet weak var blueSquare: ColoredButton!
    @IBOutlet weak var gameControlButton: UIButton!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var gameMgr = GameManager()
    var timer: Timer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Configure the buttons' colors, and this will also set up the sounds for each
        redSquare.color = .red
        greenSquare.color = .green
        yellowSquare.color = .yellow
        blueSquare.color = .blue
        scoreLabel.text = "Score: \(gameMgr.score)"
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action Handlers
    
    @IBAction func coloredButtonTapped(_ sender: ColoredButton)
    {
        sender.lightUp()
        if !gameMgr.gameOver
        {
            let success = gameMgr.analyzeButtonTap(color: sender.color)
            if success
            {
                if gameMgr.levelComplete()
                {
                    gameMgr.advanceToNextLevel()
                    scoreLabel.text = "Score: \(gameMgr.score)"
                    levelLabel.text = "Level \(gameMgr.level)"
                }
            }
            else
            {
                gameOver()
            }
        }
    }
    
    @IBAction func startLevel(_ sender: UIButton)
    {
        if gameMgr.gameOver
        {
            gameMgr = GameManager()
            levelLabel.text = "Level \(gameMgr.level)"
        }
        demonstrateCurrentCycle()
    }
    
    // MARK: - Timer function
    
    func animateButton()
    {
        let currentColorToAnimate = gameMgr.currentCycle[gameMgr.cycleStep]
        switch currentColorToAnimate
        {
        case .red:
            redSquare.lightUp()
        case .blue:
            blueSquare.lightUp()
        case .green:
            greenSquare.lightUp()
        case .yellow:
            yellowSquare.lightUp()
        default:
            break
        }
        if gameMgr.cycleStep == gameMgr.currentCycle.count - 1
        {
            timer.invalidate()
            timer = nil
        }
        else
        {
            gameMgr.cycleStep += 1
        }
    }
    
    // MARK: - Misc.
    
    func demonstrateCurrentCycle()
    {
        gameMgr.createCurrentCycle()
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(animateButton), userInfo: nil, repeats: true)
    }
    
    func gameOver()
    {
        levelLabel.text = "Game Over"
        
        // Create a new Game Manager struct
        gameMgr.gameOver = true
    }
    
}

struct GameManager
{
    var level = 1
    var score = 0
    var currentCycle = [ButtonColor]()
    var cycleStep = 0
    var userCycleStep = 0
    var gameOver = false
    
    mutating func createCurrentCycle()
    {
        cycleStep = 0
        userCycleStep = 0
        currentCycle = [ButtonColor]()
        for _ in 1...level
        {
            let buttonToLight = Int(arc4random_uniform(4) + 1)
            currentCycle.append(ButtonColor(rawValue: buttonToLight)!)
        }
    }
    
    mutating func advanceToNextLevel()
    {
        score += level
        level += 1
        createCurrentCycle()
    }
    
    mutating func analyzeButtonTap(color: ButtonColor) -> Bool
    {
        let expectedColor = currentCycle[userCycleStep]
        if color == expectedColor
        {
            userCycleStep += 1
            return true
        }
        return false
    }
    
    func levelComplete() -> Bool
    {
        if currentCycle.count == userCycleStep
        {
            return true
        }
        return false
    }
}
