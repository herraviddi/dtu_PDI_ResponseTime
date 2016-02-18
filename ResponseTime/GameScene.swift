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
    var questionLabel = UILabel()
    
    
    // screen properties
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    var questionView = UIView()
    
    
    //var randomSecondDelayArray = [Double]()
    var timeVisibleArray = [CGFloat]()
    
    var numberOfGames = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        
        if (numberOfGames < 10) {
            createGame()
        }
        
    }
    
    func createGame() {
        gameStartTime = NSDate.timeIntervalSinceReferenceDate()
        
        NSTimer.scheduledTimerWithTimeInterval(0.02,
            target: self,
            selector: Selector("timerUpdate:"),
            userInfo: nil,
            repeats: true)
        
        gameTimeLabel.fontColor = SKColor.blackColor()
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
        self.sprite.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        
        let randomSecondDelay = randomBetweenNumbers(0.5, secondNum: 4.5)
        let timeVisible = randomBetweenNumbers(0.0, secondNum: 0.1)
        
        timeVisibleArray.append(timeVisible)
        print(randomSecondDelay)
        
        NSTimer.scheduledTimerWithTimeInterval(
            Double(randomSecondDelay),
            target: self,
            selector: Selector("colorUpdate:"),
            userInfo: ["timeVisible": Double(timeVisible)],
            repeats: false)
        
        self.addChild(self.sprite)
        
        questionView.frame = CGRectMake(screenWidth/2, screenHeight/2, 200, 150)
        questionView.hidden = false
        questionView.backgroundColor = UIColor.blueColor()
        
        questionLabel.text = "Did the circle change?"
        questionLabel.hidden = false
        
        questionView.addSubview(questionLabel)

        self.view?.addSubview(questionView)
        
        
        print (self)

    }
   
    func timerUpdate(timer:NSTimer){
        self.gameTime = NSDate.timeIntervalSinceReferenceDate() - gameStartTime
        gameTimeLabel.text = String(format: "%.2f",gameTime)
    }
    
    func colorUpdate(timer: NSTimer){
        self.sprite.fillColor = UIColor.orangeColor()
        var userInfo = timer.userInfo as! Dictionary<String, Double>
        let timeVisible = 0.001
        print(userInfo["timeVisible"])
        delay(userInfo["timeVisible"]! as Double) {
        //delay(timeVisible as Double) {
           self.sprite.fillColor = UIColor.redColor()
        }
    }
    
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        

    }
    
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

    }
    
    
}
