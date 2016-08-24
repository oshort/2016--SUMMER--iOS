//
//  GameScene.swift
//  SpaceInvaders
//
//  Created by Ben Gohlke on 8/23/16.
//  Copyright © 2016 The Iron Yard. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate
{
    enum InvaderType
    {
        case a
        case b
        case c
    }
    
    enum InvaderMovementDirection
    {
        case right
        case left
        case downThenRight
        case downThenLeft
        case none
    }
    
    enum BulletType
    {
        case shipFired
        case invaderFired
    }
    
    let motionManager = CMMotionManager()
    var tapQueue: Array<Int> = []
    var contactQueue: Array<SKPhysicsContact> = []
    
    let kInvaderCategory: UInt32 = 0x1 << 0
    let kShipFiredBulletCategory: UInt32 = 0x1 << 1
    let kShipCategory: UInt32 = 0x1 << 2
    let kSceneEdgeCategory: UInt32 = 0x1 << 3
    let kInvaderFiredBulletCategory: UInt32 = 0x1 << 4
    
    var contentCreated = false
    var invaderMovementDirection = InvaderMovementDirection.right
    var timeOfLastMove: TimeInterval = 0.0
    let timePerMove: TimeInterval = 1.0
    
    let kInvaderSize = CGSize(width: 24, height: 16)
    let kInvaderGridSpacing = CGSize(width: 12, height: 12)
    let kInvaderRowCount = 6
    let kInvaderColCount = 6
    let kInvaderName = "invader"
    
    let kShipName = "ship"
    let kShipSize = CGSize(width: 30, height: 16)
    
    let kShipFiredBulletName = "shipFiredBullet"
    let kInvaderFiredBulletName = "invaderFiredBullet"
    let kBulletSize = CGSize(width: 4.0, height: 8.0)
    
    let kScoreHudName = "scoreHud"
    let kHealthHudName = "healthHud"
    
    var score: Int = 0
    var shipHealth: Float = 1.0
    
    override func didMove(to view: SKView)
    {
        if !contentCreated
        {
            createContent()
            contentCreated = true
            motionManager.startAccelerometerUpdates()
            isUserInteractionEnabled = true
            physicsWorld.contactDelegate = self
        }
    }
    
    func createContent()
    {
        //let invader = SKSpriteNode(imageNamed: "InvaderA_00.png")
        //invader.position = CGPoint(x: size.width/2, y: size.height/2)
        //addChild(invader)
        backgroundColor = SKColor.black
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody!.categoryBitMask = kSceneEdgeCategory
        setupInvaders()
        setupShip()
        setupHud()
    }
    
    func setupInvaders()
    {
        let baseOrigin = CGPoint(x: size.width/3, y: 180)
        
        for row in 1...kInvaderRowCount
        {
            var invaderType: InvaderType
            if row % 3 == 0
            {
                invaderType = .a
            }
            else if row % 3 == 1
            {
                invaderType = .b
            }
            else
            {
                invaderType = .c
            }
            
            let invaderPositionY = CGFloat(row) * (kInvaderSize.height * 2) + baseOrigin.y
            print("invader position y: \(invaderPositionY)")
            var invaderPosition = CGPoint(x: baseOrigin.x, y: invaderPositionY)
            
            for _ in 1...kInvaderColCount
            {
                let invader = makeInvaderOfType(invaderType: invaderType)
                invader.position = invaderPosition
                addChild(invader)
                
                invaderPosition = CGPoint(x: invaderPosition.x + kInvaderSize.width + kInvaderGridSpacing.width, y: invaderPositionY)
            }
        }
    }
    
    func makeInvaderOfType(invaderType: InvaderType) -> SKNode
    {
        /*
         let invaderColor: SKColor
        
        switch(invaderType)
        {
        case .a:
            invaderColor = SKColor.red
        case .b:
            invaderColor = SKColor.green
        case .c:
            invaderColor = SKColor.blue
        }
        
        let invader = SKSpriteNode(color: invaderColor, size: kInvaderSize)
         */
        
        let invaderTextures = loadInvaderTextures(ofType: invaderType)
        let invader = SKSpriteNode(texture: invaderTextures[0])
        invader.name = kInvaderName
        
        invader.run(SKAction.repeatForever(SKAction.animate(with: invaderTextures, timePerFrame: timePerMove)))
    
        invader.physicsBody = SKPhysicsBody(rectangleOf: invader.frame.size)
        invader.physicsBody!.isDynamic = false
        invader.physicsBody!.categoryBitMask = kInvaderCategory
        invader.physicsBody!.contactTestBitMask = 0x0
        invader.physicsBody!.collisionBitMask = 0x0
        
        return invader
    }
    
    func loadInvaderTextures(ofType type: InvaderType) -> [SKTexture]
    {
        var prefix: String
        
        switch type
        {
        case .a:
            prefix = "InvaderA"
        case .b:
            prefix = "InvaderB"
        case .c:
            prefix = "InvaderC"
        }
        
        let textures = [SKTexture(imageNamed: "\(prefix)_00.png"), SKTexture(imageNamed: "\(prefix)_01.png")]
        return textures
    }
    
    func setupShip()
    {
        let ship = makeShip()
        
        ship.position = CGPoint(x: size.width / 2.0, y: kShipSize.height / 2.0)
        addChild(ship)
    }
    
    func makeShip() -> SKNode
    {
        let ship = SKSpriteNode(imageNamed: "Ship.png")
        ship.name = kShipName
        
        ship.physicsBody = SKPhysicsBody(rectangleOf: ship.frame.size)
        ship.physicsBody!.isDynamic = true
        ship.physicsBody!.affectedByGravity = false
        ship.physicsBody!.mass = 0.02
        ship.physicsBody!.categoryBitMask = kShipCategory
        ship.physicsBody!.contactTestBitMask = 0x0
        ship.physicsBody!.collisionBitMask = kSceneEdgeCategory
        
        return ship
    }
    
    func setupHud()
    {
        let scoreLabel = SKLabelNode(fontNamed: "Courier")
        scoreLabel.name = kScoreHudName
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = SKColor.green
        scoreLabel.text = String(format: "Score %04u", 0)
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - (40 + scoreLabel.frame.size.height / 2))
        addChild(scoreLabel)
        
        let healthLabel = SKLabelNode(fontNamed: "Courier")
        healthLabel.name = kHealthHudName
        healthLabel.fontSize = 25
        healthLabel.fontColor = SKColor.red
        healthLabel.text = String(format: "Health %.1f%%", shipHealth * 100.0)
        healthLabel.position = CGPoint(x: size.width / 2, y: size.height - (80 + healthLabel.frame.size.height / 2))
        addChild(healthLabel)
    }
    
    func moveInvadersForUpdate(_ currentTime: TimeInterval)
    {
        if currentTime - timeOfLastMove < timePerMove
        {
            return
        }
        
        determineInvaderMovementDirection()
        
        enumerateChildNodes(withName: kInvaderName) {
            node, stop in
            switch self.invaderMovementDirection
            {
            case .right:
                node.position = CGPoint(x: node.position.x + 10, y: node.position.y)
            case .left:
                node.position = CGPoint(x: node.position.x - 10, y: node.position.y)
            case .downThenLeft, .downThenRight:
                node.position = CGPoint(x: node.position.x, y: node.position.y - 10)
            case .none:
                break
            }
            self.timeOfLastMove = currentTime
        }
        
    }
    
    func determineInvaderMovementDirection()
    {
        var proposedMovementDirection = invaderMovementDirection
        
        enumerateChildNodes(withName: kInvaderName) {
            node, stop in
            switch self.invaderMovementDirection
            {
            case .right:
                if (node.frame.maxX >= node.scene!.size.width - 5.0)
                {
                    proposedMovementDirection = .downThenLeft
                    stop.pointee = true
                }
            case .left:
                if (node.frame.minX <= 5.0)
                {
                    proposedMovementDirection = .downThenRight
                    stop.pointee = true
                }
            case .downThenLeft:
                proposedMovementDirection = .left
                stop.pointee = true
            case .downThenRight:
                proposedMovementDirection = .right
                stop.pointee = true
            case .none:
                break
            }
        }
        
        invaderMovementDirection = proposedMovementDirection
        
    }
    
    func processUserTapsForUpdate(_ currentTime: TimeInterval)
    {
        for tapCount in tapQueue
        {
            if tapCount == 1
            {
                fireShipBullets()
            }
            tapQueue.remove(at: 0)
        }
    }
    
    func fireShipBullets()
    {
        let existingBullet = childNode(withName: kShipFiredBulletName)
        if existingBullet == nil
        {
            if let ship = childNode(withName: kShipName)
            {
                let bullet = makeBulletOfType(.shipFired)
                bullet.position = CGPoint(x: ship.position.x, y: ship.position.y + ship.frame.size.height - bullet.frame.size.height / 2)
                let bulletDestination = CGPoint(x: ship.position.x, y: frame.size.height + bullet.frame.size.height / 2)
                fire(bullet: bullet, toDestination: bulletDestination, withDuration: 0.5, andSoundFileName: "ShipBullet.wav")
            }
        }
    }
    
    func fire(bullet: SKNode, toDestination destination: CGPoint, withDuration duration: CFTimeInterval, andSoundFileName soundName: String)
    {
        let bulletAction = SKAction.sequence([SKAction.move(to: destination, duration: duration), SKAction.wait(forDuration: 3.0/60.0), SKAction.removeFromParent()])
        let soundAction = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        bullet.run(SKAction.group([bulletAction, soundAction]))
        addChild(bullet)
    }
    
    func makeBulletOfType(_ bulletType: BulletType) -> SKNode
    {
        var bullet: SKNode
        
        switch bulletType
        {
        case .shipFired:
            bullet = SKSpriteNode(color: SKColor.green, size: kBulletSize)
            bullet.name = kShipFiredBulletName
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
            bullet.physicsBody!.isDynamic = true
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = kShipFiredBulletCategory
            bullet.physicsBody!.contactTestBitMask = kInvaderCategory
            bullet.physicsBody!.collisionBitMask = 0x0
            
        case .invaderFired:
            bullet = SKSpriteNode(color: SKColor.magenta, size: kBulletSize)
            bullet.name = kInvaderFiredBulletName
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
            bullet.physicsBody!.isDynamic = true
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = kInvaderFiredBulletCategory
            bullet.physicsBody!.contactTestBitMask = kShipCategory
            bullet.physicsBody!.collisionBitMask = 0x0
        }
        
        return bullet
    }
    
    func fireInvaderBulletsForUpdate(_ currentTime: TimeInterval)
    {
        let existingBullet = childNode(withName: kInvaderFiredBulletName)
        
        if existingBullet == nil
        {
            var allInvaders = Array<SKNode>()
            enumerateChildNodes(withName: kInvaderName) {
                node, stop in
                allInvaders.append(node)
            }
            
            if allInvaders.count > 0
            {
                let randomInvadersIndex = Int(arc4random_uniform(UInt32(allInvaders.count)))
                let invader = allInvaders[randomInvadersIndex]
                let bullet = makeBulletOfType(.invaderFired)
                bullet.position = CGPoint(x: invader.position.x, y: invader.position.y - invader.frame.size.height / 2 + bullet.frame.size.height / 2)
                let bulletDestination = CGPoint(x: invader.position.x, y: -(bullet.frame.size.height / 2.0))
                fire(bullet: bullet, toDestination: bulletDestination, withDuration: 2.0, andSoundFileName: "InvaderBullet.wav")
            }
        }
    }
    
    func processContactsForUpdate(_ currentTime: TimeInterval)
    {
        for contact in contactQueue
        {
            handleContact(contact)
            if let index = (contactQueue as NSArray!).index(of: contact) as Int?
            {
                contactQueue.remove(at: index)
            }
        }
    }
    
    func handleContact(_ contact: SKPhysicsContact)
    {
        if contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil
        {
            return
        }
        
        let nodeNames = [contact.bodyA.node!.name!, contact.bodyB.node!.name!]
        
        if nodeNames.contains(kShipName) && nodeNames.contains(kInvaderFiredBulletName)
        {
            run(SKAction.playSoundFileNamed("ShipHit.wav", waitForCompletion: false))
            
            let healthLabel = childNode(withName: kHealthHudName) as! SKLabelNode
            shipHealth -= 0.25
            healthLabel.text = String(format: "Health %.1f%%", shipHealth * 100.0)
            
            if contact.bodyA.node!.name! == kShipName
            {
                contact.bodyB.node!.removeFromParent()
                if shipHealth == 0
                {
                    contact.bodyA.node!.removeFromParent()
                }
            }
            else
            {
                contact.bodyA.node!.removeFromParent()
                if shipHealth == 0
                {
                    contact.bodyB.node!.removeFromParent()
                }
            }
        }
        else if nodeNames.contains(kInvaderName) && nodeNames.contains(kShipFiredBulletName)
        {
            let scoreLabel = childNode(withName: kScoreHudName) as! SKLabelNode
            score += 10
            scoreLabel.text = String(format: "Score %04u", score)
            
            run(SKAction.playSoundFileNamed("InvaderHit.wav", waitForCompletion: false))
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if contact as SKPhysicsContact? != nil
        {
            contactQueue.append(contact)
        }
    }
    
    func processUserMotionForUpdate(_ currentTime: TimeInterval)
    {
        if let ship = childNode(withName: kShipName) as? SKSpriteNode
        {
            if let data = motionManager.accelerometerData
            {
                if fabs(data.acceleration.x) > 0.2
                {
                    ship.physicsBody!.applyForce(CGVector(dx: 40.0 * CGFloat(data.acceleration.x), dy: 0))
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first! as UITouch
        if touch.tapCount == 1
        {
            tapQueue.append(1)
        }
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        // Called before each frame is rendered
        moveInvadersForUpdate(currentTime)
        processUserMotionForUpdate(currentTime)
        processUserTapsForUpdate(currentTime)
        fireInvaderBulletsForUpdate(currentTime)
        processContactsForUpdate(currentTime)
    }
    
    deinit
    {
        motionManager.stopAccelerometerUpdates()
    }
}
