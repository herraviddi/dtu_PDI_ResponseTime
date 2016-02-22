//
//  ResultScreenScene.swift
//  ResponseTime
//
//  Created by Vidar Fridriksson on 22/02/16.
//  Copyright © 2016 herraviddi. All rights reserved.
//

import SpriteKit
import Charts
import CoreData

class ResultScreenScene: SKScene {

    var chartView = LineChartView()
//    var chartDataEntry = [BarChartDataEntry] = []
    
    
    override func didMoveToView(view: SKView) {
    
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "UserResult")
        
        //3
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            print(results)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
//        var dateArray = [NSDate]()
//        var goodTimesArray = [CGFloat]()
//        var badTimesArray = [CGFloat]()
        
        
        
        chartView.frame = CGRectMake(30, 20, size.width-60, size.height/2-60)
        chartView.tintColor = SKColor.redColor()
        chartView.backgroundColor = SKColor.clearColor()
        chartView.descriptionTextColor = UIColor.whiteColor()
        chartView.leftAxis.labelTextColor = UIColor.whiteColor()
        chartView.rightAxis.labelTextColor = UIColor.whiteColor()
        chartView.xAxis.labelTextColor = UIColor.whiteColor()
        chartView.legend.textColor = UIColor.whiteColor()
        
    
        chartView.noDataText = "there is no data here"
        
    }
    
}
