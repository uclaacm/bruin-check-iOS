//
//  DashboardViewController.swift
//  check-in
//
//  Created by Matt Garnett on 1/4/17.
//  Copyright © 2017 Matt Garnett. All rights reserved.
//



import Foundation
import UIKit

class DashboardViewController : UIViewController {
    
    @IBOutlet weak var chartView: ScrollableGraphView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        updateChartWithData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func updateChartWithData() {
        /*
        var data: [CGFloat] = []
        
        // Generate some dummy data
        for _ in 0...10 {
            data.append(CGFloat(100 + (arc4random() % 100)))
        }
        */
        
        self.view.backgroundColor = UIColor(red:0.23, green:0.48, blue:0.84, alpha:1.0)
        navigationBar.barTintColor = UIColor(red:0.23, green:0.48, blue:0.84, alpha:1.0)
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        let navBorder: UIView = UIView(frame: CGRect(x: 0, y: navigationBar.frame.size.height - 1, width: navigationBar.frame.size.width, height: 2))
        // Set the color you want here
        navBorder.backgroundColor = UIColor(red:0.23, green:0.48, blue:0.84, alpha:1)
        navBorder.isOpaque = true
        navigationBar.addSubview(navBorder)
        
        /*
        let navBorder2: UIView = UIView(frame: CGRect(x: 0, y: navigationBar.frame.size.height - 1, width: navigationBar.frame.size.width, height: 0.4))
        // Set the color you want here
        navBorder2.backgroundColor = UIColor.white
        navBorder2.isOpaque = true
        navigationBar.addSubview(navBorder2) */

        let data: [Double] = [4, 8, 15, 16, 23, 42]
        let labels = ["one", "two", "three", "four", "five", "six"]
        
        let graphView = chartView!
        
        graphView.showsHorizontalScrollIndicator = false
        graphView.direction = .rightToLeft
        graphView.bottomMargin = -25
        graphView.topMargin = 50
        
        graphView.dataPointLabelTopMargin = 18
        graphView.dataPointLabelOnTop = true
        
        graphView.backgroundFillColor = UIColor(red:0.23, green:0.48, blue:0.84, alpha:0)
        graphView.lineColor = UIColor.clear
        
        graphView.shouldFill = true
        graphView.fillColor = UIColor.white//UIColor(red:0.23, green:0.48, blue:0.84, alpha:1.0)
        
        graphView.shouldDrawDataPoint = false
        graphView.dataPointSpacing = 80
        graphView.dataPointLabelFont = UIFont.boldSystemFont(ofSize: 10)
        graphView.dataPointLabelColor = UIColor.white
       
        graphView.referenceLineThickness = 1
        graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 10)
        graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.5)
        graphView.referenceLineLabelColor = UIColor.white
        graphView.referenceLinePosition = ScrollableGraphViewReferenceLinePosition.both
        
        graphView.numberOfIntermediateReferenceLines = 1
        
        graphView.rangeMax = 50
        
        
        graphView.set(data: data, withLabels: labels)
        //chartView.addSubview(graphView)
        
    }
    
}
