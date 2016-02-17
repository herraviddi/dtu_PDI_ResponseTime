//
//  GameScene.swift
//  ResponseTime
//
//  Created by Vidar Fridriksson on 17/02/16.
//  Copyright (c) 2016 herraviddi. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let sprite = SKShapeNode(circleOfRadius: 100)
    
    var gameStartTime = NSTimeInterval()
    var gameTime = NSTimeInterval()
    
    var gameTimeLabel = SKLabelNode()
    
    
    // screen properties
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        gameStartTime = NSDate.timeIntervalSinceReferenceDate()
        
        NSTimer.scheduledTimerWithTimeInterval(0.02,
            target: self,
            selector: Selector("timerUpdate:"),
            userInfo: nil,
            repeats: true)
        
        

        gameTimeLabel.fontColor = SKColor.yellowColor()
        gameTimeLabel.fontSize = 30
        gameTimeLabel.name = "results"
        gameTimeLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-300)
        self.addChild(gameTimeLabel)
        gameTimeLabel.hidden = false
        
        
        
        
        screenHeight = screenSize.height
        screenWidth = screenSize.width
        

        
        self.sprite.lineWidth = 2.0
        self.sprite.name = "colorBall"
        
        
        self.sprite.fillColor = UIColor.redColor()
        self.sprite.position = CGPointMake(frame.size.width/2, frame.size.height/2
        )
        
        self.addChild(self.sprite)
        
        
    }
//    
//    func timerUpdate(timer:NSTimer){
//        self.gameTime = NSDate.timeIntervalSinceReferenceDate() - gameStartTime
//        gameTimeLabel.text = String(format: "%.2f",gameTime)
//    }
//    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        

    }
    
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

    }
    
    
}
