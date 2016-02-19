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
    var gameTime = Double()
    
    var gameTimeLabel = SKLabelNode()
    var questionLabel = UILabel()
    
    
    // screen properties
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    var questionView = UIView()
    
    
    //var randomSecondDelayArray = [Double]()
    var timeVisibleArray = [Double]()
    var timeVisible = CGFloat()
    
    var numberOfGames = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        createGame()
        createQuestion()
        displayGame()
        
    }
   
    func timerUpdate(timer:NSTimer){
        self.gameTime = NSDate.timeIntervalSinceReferenceDate() - gameStartTime
        gameTimeLabel.text = String(format: "%.2f",gameTime)
        var userInfo = timer.userInfo as! Dictionary<String, Double>
        if self.gameTime > 5.2 {
            displayQuestion(Double(timeVisible))
            
        }
    }
    
    func displayGame() {
        print ("yoloGame")
        questionView.hidden = true
        gameStartTime = NSDate.timeIntervalSinceReferenceDate()
        
        let randomSecondDelay = randomBetweenNumbers(0.5, secondNum: 4.8)
        timeVisible = randomBetweenNumbers(0.0, secondNum: 0.08)
        print(timeVisible)
        timeVisibleArray.append(Double(timeVisible))
        
        NSTimer.scheduledTimerWithTimeInterval(
            Double(randomSecondDelay),
            target: self,
            selector: Selector("colorUpdate:"),
            userInfo: ["timeVisible": Double(timeVisible)],
            repeats: false)
        
        NSTimer.scheduledTimerWithTimeInterval(0.02,
            target: self,
            selector: Selector("timerUpdate:"),
            userInfo: ["timeVisible": Double(timeVisible)],
            repeats: true)
        
        print(timeVisibleArray)
    }
    
    func displayQuestion(timeVisible: Double) {
        questionView.hidden = false
    }
    
    func colorUpdate(timer: NSTimer){
        self.sprite.fillColor = UIColor.orangeColor()
        //var userInfo = timer.userInfo as! Dictionary<String, Double>
        delay(Double(timeVisible)) {
           self.sprite.fillColor = UIColor.redColor()
        }
    }
    
    func createQuestion() {
        let questionViewWidthTemp = screenWidth*0.8
        let questionViewHeightTemp = screenHeight*0.8
        questionView.frame = CGRectMake(screenWidth/2-questionViewWidthTemp/2, screenHeight/2-questionViewHeightTemp/2, questionViewWidthTemp, questionViewHeightTemp)
        questionView.hidden = true
        questionView.backgroundColor = UIColor.whiteColor()
        
        questionLabel.text = "Did the circle change?"
        questionLabel.hidden = false
        questionLabel.textColor = UIColor.blackColor()
        questionLabel.textAlignment = NSTextAlignment.Center
        questionLabel.font = questionLabel.font.fontWithSize(25)
        
        let questionViewSize = questionView.frame.size
        let questionViewWidth = questionViewSize.width
        let questionViewHeight = questionViewSize.height
        questionLabel.frame = CGRectMake(0, 0, questionViewWidth, questionViewHeight*0.15 )
        
        questionView.addSubview(questionLabel)
        
        let yesBtn = UIButton()
        //yesBtn.titleLabel?.font = yesBt
        yesBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        //yesBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        
        yesBtn.setTitle("Yes", forState: UIControlState.Normal)
        yesBtn.addTarget(self, action: "displayGame", forControlEvents: UIControlEvents.TouchUpInside)
        //yesBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        yesBtn.backgroundColor = UIColor.greenColor()
        yesBtn.frame = CGRectMake(questionViewWidth-questionViewWidth*0.95, questionViewHeight - questionViewHeight*0.70, questionViewWidth-questionViewWidth*0.6, questionViewHeight*0.25)
        //yesBtn.frame = CGRectMake(15, -50, 300, 500)
        yesBtn.hidden = false
        
        questionView.addSubview(yesBtn)
        
        let noBtn = UIButton()
        noBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        noBtn.setTitle("No", forState: UIControlState.Normal)
        noBtn.addTarget(self, action: "displayGame", forControlEvents: UIControlEvents.TouchUpInside)
        noBtn.backgroundColor = UIColor.redColor()
        noBtn.frame = CGRectMake(questionViewWidth-questionViewWidth*0.45, questionViewHeight - questionViewHeight*0.70, questionViewWidth-questionViewWidth*0.6, questionViewHeight*0.25)
        noBtn.hidden = false
        
        questionView.addSubview(noBtn)
        
        self.view?.addSubview(questionView)
    }
    func noTest() {
        print ("no")
    }
    
    func yesTest() {
        print ("yes")
    }
    
    func createGame() {
        gameStartTime = NSDate.timeIntervalSinceReferenceDate()
        
        gameTimeLabel.fontColor = SKColor.whiteColor()
        gameTimeLabel.fontSize = 30
        gameTimeLabel.name = "results"
        gameTimeLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-300)
        self.addChild(gameTimeLabel)
        gameTimeLabel.hidden = false
        
        self.backgroundColor = UIColor.blackColor()

        screenHeight = screenSize.height
        screenWidth = screenSize.width
        
        self.sprite.lineWidth = 2.0
        self.sprite.name = "colorBall"
        
        
        self.sprite.fillColor = UIColor.redColor()
        self.sprite.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        
        self.addChild(self.sprite)
        
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
