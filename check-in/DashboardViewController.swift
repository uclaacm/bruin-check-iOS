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
    
    @IBOutlet weak var chartView: BarChartView!
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateChartWithData()
    }
    
    func updateChartWithData() {
        var dataEntries: [ILineChartDataSet] = []
        let visitorCounts = [ 1, 3, 2, 5, 6, 8, 7]
        for i in 0..<visitorCounts.count {
            let dataEntry = ILineChartData(x: Double(i), y: Double(visitorCounts[i]))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = ILineChartDataSet(values: dataEntries, label: "Visitor count")
        let chartData = ILineChartDataSet(dataSet: chartDataSet)
        chartView.data = chartData
    }
    
}
