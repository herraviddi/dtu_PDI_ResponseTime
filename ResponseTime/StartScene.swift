//
//  StartScene.swift
//  ResponseTime
//
//  Created by Vidar Fridriksson on 22/02/16.
//  Copyright © 2016 herraviddi. All rights reserved.
//

import UIKit
import SpriteKit


class StartScene: SKScene {

    var startGameButton = SKLabelNode()
    var explanationText = UILabel()
    
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor()

        
        explanationText.frame = CGRectMake(50, 0, size.width-100, 300)
        explanationText.numberOfLines = 8
        explanationText.text = "This test is to determine if you think the color change is visible, after each run you get a YES or NO question to answer if you noticed a change in color. Since we are measuring speed it is essential that you are as quick as you can in finishing these observations and be quick in answering questions"
        explanationText.textColor = UIColor.whiteColor()
        explanationText.font = UIFont.systemFontOfSize(12)
        explanationText.textAlignment = .Center
        self.view?.addSubview(explanationText)
        
        startGameButton = SKLabelNode()
        startGameButton.position = CGPointMake(size.width/2, size.height/2)
        startGameButton.text = "Start!"
        startGameButton.fontSize = 50
        startGameButton.color = SKColor.blackColor()
        startGameButton.name = "startgame"
        self.addChild(startGameButton)
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.locationInNode(self)
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if(touchedNode.name == "startgame"){
            explanationText.removeFromSuperview()
            let gamescene = CountInGameScene(size: size)
            gamescene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontalWithDuration(1.0)
            
            view?.presentScene(gamescene, transition: transitionType)
        }
        

    
    }
}
