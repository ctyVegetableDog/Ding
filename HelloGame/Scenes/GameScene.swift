//
//  GameScene.swift
//  HelloGame
//
//  Created by 崔泰毓 on 24/08/2019.
//  Copyright © 2019 崔泰毓. All rights reserved.
//

import SpriteKit

enum PlayColors {
    static let colors = [
        UIColor.brown,
        UIColor(red: 241/255, green: 196/255, blue: 12/255, alpha: 1.0)
    ]
}

enum SwitchState: Int {
    case brown, yellow
}

class GameScene: SKScene {
    
    var colorSwitch: SKSpriteNode!
    var switchState = SwitchState.brown
    var currentColorIndex: Int?
    var currentGarivey  = 0.0
    let scoreLabel = SKLabelNode(text: "0")
    var score = 0
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
    }
    
    func setupPhysics() {
        if (score % 10 == 0) {
            currentGarivey -= 2.0
            physicsWorld.gravity = CGVector(dx: 0.0, dy: currentGarivey)
            physicsWorld.contactDelegate = self
        }
    }
    
    func layoutScene() {
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        colorSwitch = SKSpriteNode(imageNamed: "food")
        
        colorSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2)
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCatageories.switchCategory
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)
        colorSwitch.zPosition = ZPositions.colorSwiitch
        colorSwitch.physicsBody?.isDynamic = false
        addChild(colorSwitch)
        
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        
        spawnEater()
    }
    
    func updateLabel () {
        scoreLabel.text = "\(score)"
    }
    
    func spawnEater() {
        currentColorIndex = Int(arc4random_uniform(UInt32(2)))
        
        let eater = SKSpriteNode(texture: SKTexture(imageNamed: "eater"), color: PlayColors.colors[currentColorIndex!], size: CGSize(width: 30.0, height: 30.0))
        eater.colorBlendFactor = 1.0
        eater.name = "eater"
        eater.position = CGPoint(x: frame.midX, y: frame.maxY)
        eater.physicsBody = SKPhysicsBody(circleOfRadius: eater.size.width/2)
        eater.physicsBody?.categoryBitMask = PhysicsCatageories.ballCategory
        eater.physicsBody?.contactTestBitMask = PhysicsCatageories.switchCategory
        eater.physicsBody?.collisionBitMask = PhysicsCatageories.none
        eater.zPosition = ZPositions.eater
        addChild(eater)
    }
    
    func turnWheel() {
        if let newState = SwitchState(rawValue: switchState.rawValue + 1) {
            switchState = newState
        } else {
            switchState = .brown
        }
        
        colorSwitch.run(SKAction.rotate(byAngle: .pi, duration: 0.25))
    }
    
    func gameOver() {
        run(SKAction.playSoundFileNamed("yoo", waitForCompletion: true))
        
        UserDefaults.standard.set(score, forKey: "RecentScore")
        if score > UserDefaults.standard.integer(forKey: "Highscore") {
            UserDefaults.standard.set(score, forKey: "Highscore")
        }
        
        let menuScene = MenuScene(size: view!.bounds.size)
        view!.presentScene(menuScene)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if contactMask == PhysicsCatageories.ballCategory | PhysicsCatageories.switchCategory {
            if let eater = contact.bodyA.node?.name == "eater" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode{
                if currentColorIndex == switchState.rawValue {
                    run(SKAction.playSoundFileNamed("dinger", waitForCompletion: false))
                    score += 1
                    updateLabel()
                    setupPhysics()
                    eater.run(SKAction.fadeOut(withDuration: 0.25), completion: {
                        eater.removeFromParent()
                        self.spawnEater()
                    })
                } else {
                    gameOver()
                }
            }
        }
    }
    
}
