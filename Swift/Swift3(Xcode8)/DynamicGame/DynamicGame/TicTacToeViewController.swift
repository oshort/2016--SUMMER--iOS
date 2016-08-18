//
//  TicTacToeViewController.swift
//  DynamicGame
//
//  Created by Ben Gohlke on 8/18/16.
//  Copyright © 2016 The Iron Yard. All rights reserved.
//

import UIKit

class TicTacToeViewController: UIViewController
{

    var grid = [[0,0,0], [0,0,0], [0,0,0]]
    
    var isPlayer1Turn = true
    
    var player1Score = 0
    var player2Score = 0
    var stalemateScore = 0
    
    let gameStatusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        gameStatusLabel.text = "Player 1 Turn"
        gameStatusLabel.textAlignment = .center
        gameStatusLabel.textColor = UIColor.magenta
        view.addSubview(gameStatusLabel)
        
        let screenHeight = Int(view.bounds.height)
        let screenWidth = Int(view.bounds.width)
        
        let buttonHW = 100
        let buttonSpacing = 4
        
        let gridHW = (buttonHW * 3) + (buttonSpacing * 2)
        
        let leftSpacing = (screenWidth - gridHW) / 2
        let topSpacing = (screenHeight - gridHW) / 2
        
        for (r, row) in grid.enumerated()
        {
            for (c, _) in row.enumerated()
            {
                let x = c * (buttonHW + buttonSpacing) + leftSpacing
                let y = r * (buttonHW + buttonSpacing) + topSpacing
                
                let button = TTTButton(frame: CGRect(x: x, y: y, width: buttonHW, height: buttonHW))
                button.backgroundColor = UIColor.cyan
                button.row = r
                button.col = c
                
                button.addTarget(self, action: #selector(TicTacToeViewController.spacePressed(_:)), for: .touchUpInside)
                view.addSubview(button)
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func spacePressed(_ button: TTTButton)
    {
        if button.player == 0
        {
//            if isPlayer1Turn
//            {
//                button.player = 1
//            }
//            else
//            {
//                button.player = 2
//            }
            button.player = isPlayer1Turn ? 1 : 2
            grid[button.row][button.col] = isPlayer1Turn ? 1 : 2
            isPlayer1Turn = !isPlayer1Turn
            gameStatusLabel.text = isPlayer1Turn ? "Player 1 Turn" : "Player 2 Turn"
            gameStatusLabel.textColor = isPlayer1Turn ? UIColor.magenta : UIColor.yellow
            
            checkForWinner()
        }
    }
    
    func checkForWinner()
    {
        let possibilities = [
            ((0,0),(0,1),(0,2)),
            ((1,0),(1,1),(1,2)),
            ((2,0),(2,1),(2,2)),
            ((0,0),(1,0),(2,0)),
            ((0,1),(1,1),(2,1)),
            ((0,2),(1,2),(2,2)),
            ((0,0),(1,1),(2,2)),
            ((2,0),(1,1),(0,2))
        ]
        
        for possibility in possibilities
        {
            let (p1, p2, p3) = possibility
            
            let value1 = grid[p1.0][p1.1]
            let value2 = grid[p2.0][p2.1]
            let value3 = grid[p3.0][p3.1]
            
            if value1 == value2 && value2 == value3
            {
                if value1 != 0
                {
                    gameStatusLabel.text = "Player \(value1) wins!"
                    gameStatusLabel.textColor = value1 == 1 ? UIColor.magenta : UIColor.yellow
                }
                else
                {
                    print("No winner: all zeroes")
                }
            }
            else
            {
                print("Does not match")
            }
        }
    }


}

class TTTButton: UIButton
{
    var row = 0
    var col = 0
    var player = 0 {
        didSet {
            switch player {
            case 1: backgroundColor = UIColor.magenta
            case 2: backgroundColor = UIColor.yellow
            default: backgroundColor = UIColor.cyan
            }
        }
    }
}

