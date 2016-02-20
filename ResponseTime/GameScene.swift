//
//  GameScene.swift
//  ResponseTime
//
//  Created by Vidar Fridriksson on 17/02/16.
//  Copyright (c) 2016 herraviddi. All rights reserved.
//

import Foundation
import SpriteKit

typealias Task = (cancel : Bool) -> ()

class GameScene: SKScene {
    
    let sprite = SKShapeNode(circleOfRadius: 100)
    
    var gameStartTime = NSTimeInterval()
    var gameTime = Double()
    
    var clickStartTime = NSTimeInterval()
    var clickTime = Double()
    
    var gameTimeLabel = SKLabelNode()
    var questionLabel = UILabel()
    let yesBtn = UIButton()
    let noBtn = UIButton()
    var yesChosen = false
    var noChosen = false
    
    
    // screen properties
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var screenWidth = CGFloat()
    var screenHeight = CGFloat()
    
    var questionView = UIView()
    
    
    //var randomSecondDelayArray = [Double]()
    var timeVisibleArray = [Double]()
    var timeVisible = CGFloat()
    var timeBetweenClick = 0.0
    
    var numberOfGames = 0
    
    class OneGame {
        var timeVisible = Double()
        var yesOrNo = ""
        var pressedAgainAfter = Double()
    }
    
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
    
    func clickTimerUpdate(){
        self.clickTime = NSDate.timeIntervalSinceReferenceDate() - clickStartTime
    }
    
    func displayGame() {
        print ("yoloGame")
        questionView.hidden = true
        gameStartTime = NSDate.timeIntervalSinceReferenceDate()
        
        let randomSecondDelay = randomBetweenNumbers(0.5, secondNum: 4.8)
        timeVisible = randomBetweenNumbers(1, secondNum: 3)
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
        
        NSTimer.scheduledTimerWithTimeInterval(0.02,
            target: self,
            selector: Selector("clickTimerUpdate"),
            userInfo: nil,
            repeats: true)
    }
    
    func colorUpdate(timer: NSTimer){
        self.sprite.fillColor = UIColor.orangeColor()
        //var userInfo = timer.userInfo as! Dictionary<String, Double>
        delay(Double(timeVisible)) {
           self.sprite.fillColor = UIColor.redColor()
        }
    }
    
    func yesButtonPressed() {
        print ("pressed yes")
        yesChosen = true
        if yesChosen == true && timeBetweenClick == 0.0{
            timeBetweenClick = self.clickTime
        }
        
        if noChosen == false {
            delay(Double(self.timeVisible))  {
                self.yesBtn.backgroundColor = UIColor.greenColor()
            }
        }
        
    }
    
    func noButtonPressed() {
        print ("pressed no")
        noChosen = true
        if noChosen == true && timeBetweenClick == 0.0 {
            timeBetweenClick = self.clickTime
        }
        
        if yesChosen == false {
            delay(Double(self.timeVisible))  {
                self.noBtn.backgroundColor = UIColor.redColor()
            }
        }
        
    }
    
    func submit() {
        print ("submit pressed")
        print (yesChosen)
        print (noChosen)
        if yesChosen || noChosen {
            let oneGame = OneGame()
            oneGame.timeVisible = Double(self.timeVisible)
            oneGame.pressedAgainAfter = timeBetweenClick
            if yesChosen == true {
                oneGame.yesOrNo = "yes"
            }
            else {
                oneGame.yesOrNo = "no"
            }
            print (oneGame.pressedAgainAfter)
            sendToApi(oneGame)
            self.timeVisible = 0.0
            yesChosen = false
            noChosen = false
            displayGame()
        }
        
        
    }
    
    func createQuestion() {
        let questionViewWidthTemp = screenWidth*0.8
        let questionViewHeightTemp = screenHeight*0.8
        questionView.frame = CGRectMake(screenWidth/2-questionViewWidthTemp/2, screenHeight/2-questionViewHeightTemp/2, questionViewWidthTemp, questionViewHeightTemp)
        questionView.hidden = true
        questionView.backgroundColor = UIColor.blackColor()
        
        questionLabel.text = "Did the circle change?"
        questionLabel.hidden = false
        questionLabel.textColor = UIColor.whiteColor()
        questionLabel.textAlignment = NSTextAlignment.Center
        questionLabel.font = questionLabel.font.fontWithSize(25)
        
        let questionViewSize = questionView.frame.size
        let questionViewWidth = questionViewSize.width
        let questionViewHeight = questionViewSize.height
        questionLabel.frame = CGRectMake(0, 0, questionViewWidth, questionViewHeight*0.15 )
        
        questionView.addSubview(questionLabel)
        
        
        yesBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        yesBtn.setTitle("Yes", forState: UIControlState.Normal)
        yesBtn.addTarget(self, action: "yesButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        yesBtn.backgroundColor = UIColor.clearColor()
        yesBtn.layer.cornerRadius = 5
        yesBtn.layer.borderWidth = 1
        yesBtn.layer.borderColor = UIColor.whiteColor().CGColor
        yesBtn.frame = CGRectMake(questionViewWidth-questionViewWidth*0.95, questionViewHeight - questionViewHeight*0.70, questionViewWidth-questionViewWidth*0.6, questionViewHeight*0.25)
        yesBtn.hidden = false
        
        questionView.addSubview(yesBtn)
        
        noBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        noBtn.setTitle("No", forState: UIControlState.Normal)
        noBtn.addTarget(self, action: "noButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        //noBtn.performSelector("noButtonPressed", withObject: nil, afterDelay: Double(self.timeVisible))
        noBtn.backgroundColor = UIColor.clearColor()
        noBtn.layer.cornerRadius = 5
        noBtn.layer.borderWidth = 1
        noBtn.layer.borderColor = UIColor.whiteColor().CGColor
        noBtn.frame = CGRectMake(questionViewWidth-questionViewWidth*0.45, questionViewHeight - questionViewHeight*0.70, questionViewWidth-questionViewWidth*0.6, questionViewHeight*0.25)
        noBtn.hidden = false
        
        questionView.addSubview(noBtn)
        
        let submitBtn = UIButton()
        submitBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        submitBtn.setTitle("Next ->", forState: UIControlState.Normal)
        submitBtn.addTarget(self, action: "submit", forControlEvents: UIControlEvents.TouchUpInside)
        submitBtn.backgroundColor = UIColor.whiteColor()
        submitBtn.layer.cornerRadius = 5
        submitBtn.layer.borderWidth = 1
        submitBtn.layer.borderColor = UIColor.whiteColor().CGColor
        submitBtn.frame = CGRectMake(questionViewWidth-questionViewWidth*0.9, questionViewHeight - questionViewHeight*0.30, questionViewWidth-questionViewWidth*0.15, questionViewHeight*0.25)
        submitBtn.hidden = false
        
        questionView.addSubview(submitBtn)
        
        self.view?.addSubview(questionView)
    }
    
    func sendToApi(oneGame: OneGame)
    {
        //Todo
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
    
    func delay_old(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        print ("pressed again")

    }
    
    func delay(time:NSTimeInterval, task:()->()) ->  Task? {
        
        func dispatch_later(block:()->()) {
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(time * Double(NSEC_PER_SEC))),
                dispatch_get_main_queue(),
                block)
        }
        
        var closure: dispatch_block_t? = task
        var result: Task?
        
        let delayedClosure: Task = {
            cancel in
            if let internalClosure = closure {
                if (cancel == false) {
                    dispatch_async(dispatch_get_main_queue(), internalClosure);
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(cancel: false)
            }
        }
        
        return result;
    }
    
    func cancel(task:Task?) {
        task?(cancel: true)
    }
    
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

    }
    
    
}
