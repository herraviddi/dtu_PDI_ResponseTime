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
    var circleStartTime = NSTimeInterval()
    
    var gameTime = Double()
    
    var circleTime = Double()
    
    var extraTouchArray = [CGFloat]()
    var noExtraTouchArray = [CGFloat]()
    
    var clickStartTime = NSTimeInterval()
    var clickTime = Double()
    
    var gameTimeLabel = SKLabelNode()
    var questionLabel = UILabel()
    let yesBtn = UIButton()
    let noBtn = UIButton()
    let submitBtn = UIButton()
    var yesChosen = false
    var noChosen = false
    var numberOfExtraTouches = 0
    
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
    var questionViewEnabled = false
    
    var games = [OneGame]()
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var buttonTouchCount = 0
    
    class OneGame {
        var timeVisible = Double()
        var yesOrNo = ""
        var numberOfExtraTouches = 0
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
        
        self.circleTime = NSDate.timeIntervalSinceReferenceDate() - circleStartTime
//        var userInfo = timer.userInfo as! Dictionary<String, Double>
        if self.circleTime > 5.2 {
            buttonTouchCount = 0
            displayQuestion(Double(timeVisible))
            
        }
    }
    
    func clickTimerUpdate(){
        self.clickTime = NSDate.timeIntervalSinceReferenceDate() - clickStartTime
    }
    
    func displayGame() {
        questionView.hidden = true
        questionViewEnabled = false
//        gameStartTime = NSDate.timeIntervalSinceReferenceDate()
        circleStartTime = NSDate.timeIntervalSinceReferenceDate()
        
        let randomSecondDelay = randomBetweenNumbers(0.5, secondNum: 4.8)
        timeVisible = randomBetweenNumbers(0.0, secondNum: 1.0)
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
    }
    
    func displayQuestion(timeVisible: Double) {
        questionView.hidden = false
        questionViewEnabled = true

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
            self.noExtraTouchArray.append(self.timeVisible)
        }
    }
    
    func yesButtonPressed() {
        if yesChosen == true{
            numberOfExtraTouches += 1
            extraTouchArray.append(timeVisible)
        }
        
        yesChosen = true
        
        if noChosen == false {
            delay(Double(self.timeVisible))  {
                self.yesBtn.backgroundColor = UIColor.greenColor()
                self.noExtraTouchArray.append(self.timeVisible)
                self.delay(0.5){
                    self.submit()
                }
            }
        }
        
    }
    
    func noButtonPressed() {
        
        if noChosen == true {
            numberOfExtraTouches += 1
            
            extraTouchArray.append(timeVisible)
        }
        
        noChosen = true

        if yesChosen == false {
            delay(Double(self.timeVisible))  {
                self.noBtn.backgroundColor = UIColor.redColor()
                self.delay(0.5){
                    self.submit()
                }
            }
        }
    }

    func getMedianValue(valueArray:[CGFloat]) -> CGFloat{
        
        let uniqValues = uniq(valueArray)
        let sortedUniqValues = uniqValues.sort()
        let count = sortedUniqValues.count
        
        let medianValue = sortedUniqValues[count/2]
        
        return medianValue
        
    }
    
    func uniq<S : SequenceType, T : Hashable where S.Generator.Element == T>(source: S) -> [T] {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    func submit() {

        if yesChosen || noChosen {
            let oneGame = OneGame()
            oneGame.timeVisible = Double(self.timeVisible)
            oneGame.numberOfExtraTouches = numberOfExtraTouches
            
            if yesChosen == true {
                oneGame.yesOrNo = "yes"
            }
            
            else {
                oneGame.yesOrNo = "no"
            }
            
            sendToApi(oneGame)
            games.append(oneGame)
            self.timeVisible = 0.0
            yesChosen = false
            noChosen = false
            numberOfExtraTouches = 0
            self.noBtn.backgroundColor = UIColor.clearColor()
            self.yesBtn.backgroundColor = UIColor.clearColor()

            questionViewEnabled = false
            numberOfGames += 1
            if numberOfGames < 10 {
                displayGame()
            }
            else {
                
                self.yesBtn.removeFromSuperview()
                self.noBtn.removeFromSuperview()
                self.submitBtn.removeFromSuperview()
                self.questionLabel.text = "Your results"

                let medianBadTimeHeadingLabel = UILabel()
                medianBadTimeHeadingLabel.textColor = UIColor.whiteColor()
                medianBadTimeHeadingLabel.textAlignment = .Center
                medianBadTimeHeadingLabel.font = UIFont.systemFontOfSize(25.0)
                medianBadTimeHeadingLabel.frame = CGRectMake((self.view?.frame.size.width)!/2-150, self.view!.frame.size.height/2-160, 300, 50)
                medianBadTimeHeadingLabel.text = "Median NOT accepted time"
                self.view?.addSubview(medianBadTimeHeadingLabel)
                
                let medianBadTimeLabel = UILabel()
                medianBadTimeLabel.textColor = UIColor.redColor()
                medianBadTimeLabel.textAlignment = .Center
                medianBadTimeLabel.font = UIFont.systemFontOfSize(30.0)
                medianBadTimeLabel.frame = CGRectMake((self.view?.frame.size.width)!/2-100, self.view!.frame.size.height/2-100, 200, 50)
                medianBadTimeLabel.text = NSString(format: " %.2f",getMedianValue(extraTouchArray)) as String
                self.view?.addSubview(medianBadTimeLabel)

                
                let medianGoodTimeHeadingLabel = UILabel()
                medianGoodTimeHeadingLabel.textColor = UIColor.whiteColor()
                medianGoodTimeHeadingLabel.textAlignment = .Center
                medianGoodTimeHeadingLabel.font = UIFont.systemFontOfSize(25.0)
                medianGoodTimeHeadingLabel.frame = CGRectMake((self.view?.frame.size.width)!/2-150, self.view!.frame.size.height/2, 300, 50)
                medianGoodTimeHeadingLabel.text = "Median accepted time"
                self.view?.addSubview(medianGoodTimeHeadingLabel)
                
                let medianGoodTimeLabel = UILabel()
                medianGoodTimeLabel.textColor = UIColor.greenColor()
                medianGoodTimeLabel.textAlignment = .Center
                medianGoodTimeLabel.font = UIFont.systemFontOfSize(25.0)
                medianGoodTimeLabel.frame = CGRectMake((self.view?.frame.size.width)!/2-100, self.view!.frame.size.height/2+60, 200, 50)
                medianGoodTimeLabel.text = NSString(format: " %.2f",getMedianValue(noExtraTouchArray)) as String
                self.view?.addSubview(medianGoodTimeLabel)
                
                saveResults()
                
            }
        }
    }
    
    func saveResults(){
        let medianGoodTimeResultDict = ["date":NSDate(),"goodTime":getMedianValue(noExtraTouchArray),"badTime":getMedianValue(extraTouchArray)]
        defaults.setObject(medianGoodTimeResultDict, forKey: "ResultDict")
    }
    
    func createQuestion() {
        let questionViewWidthTemp = screenWidth*0.8
        let questionViewHeightTemp = screenHeight*0.6
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
        
        submitBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        submitBtn.setTitle("Next ->", forState: UIControlState.Normal)
        submitBtn.addTarget(self, action: "submit", forControlEvents: UIControlEvents.TouchUpInside)
        submitBtn.backgroundColor = UIColor.whiteColor()
        submitBtn.layer.cornerRadius = 5
        submitBtn.layer.borderWidth = 1
        submitBtn.layer.borderColor = UIColor.whiteColor().CGColor
        submitBtn.frame = CGRectMake(questionViewWidth-questionViewWidth*0.9, questionViewHeight - questionViewHeight*0.30, questionViewWidth-questionViewWidth*0.15, questionViewHeight*0.25)
        submitBtn.hidden = false
        
        self.view?.addSubview(questionView)
    }
    
    func sendToApi(oneGame: OneGame)
    {
        //Todo
    }
    
    func createGame() {
        gameStartTime = NSDate.timeIntervalSinceReferenceDate()
        circleStartTime = NSDate.timeIntervalSinceReferenceDate()
        gameTimeLabel.fontColor = SKColor.whiteColor()
        gameTimeLabel.fontSize = 60
        gameTimeLabel.name = "results"
        gameTimeLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-300)
        self.addChild(gameTimeLabel)
        gameTimeLabel.zPosition = 10
        
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
        
        var i = 1
        for game in games {
//            print ("Game number " + String(i))
//            print ("Extra touches: " + String(game.numberOfExtraTouches))
//            print ("Yes/No: " + game.yesOrNo)
//            print ("Time visible: " + String(game.timeVisible))
            i += 1
//            print ("------------")
        }

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

        if questionViewEnabled{
            noBtn.userInteractionEnabled = true
            yesBtn.userInteractionEnabled = true
        }else{
            noBtn.backgroundColor = UIColor.clearColor()
            yesBtn.backgroundColor = UIColor.clearColor()
            noBtn.userInteractionEnabled = false
            yesBtn.userInteractionEnabled = false
        }
        
    }
    
    
}
