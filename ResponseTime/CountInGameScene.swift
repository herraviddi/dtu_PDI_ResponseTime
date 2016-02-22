//
//  CountInGameScene.swift
//  ResponseTime
//
//  Created by Vidar Fridriksson on 22/02/16.
//  Copyright © 2016 herraviddi. All rights reserved.
//


import UIKit
import SpriteKit

class CountInGameScene: SKScene {
    
    var counter = 3
    var countDownLabel = SKLabelNode()
    
    var counterTimer = NSTimeInterval()
    
    override func didMoveToView(view: SKView) {
        
        countDownLabel.name = "countDown"
        countDownLabel.position = CGPointMake(size.width/2, size.height/2)
        countDownLabel.fontSize = 80
        countDownLabel.text = String(counter)
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateCountDown", userInfo: nil, repeats: true)
        
        countDownLabel.color = SKColor.blackColor()
        self.addChild(countDownLabel)
    }
    
    func updateCountDown(){
        counter -= 1
        countDownLabel.text = String(counter)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        if(counter == 0){
            let gamescene = GameScene(size: size)
            gamescene.scaleMode = scaleMode
            let transitionType = SKTransition.doorsOpenHorizontalWithDuration(1.0)
            gamescene.userData = self.userData
            view?.presentScene(gamescene, transition: transitionType)
            
            
        }
        
    }
}
