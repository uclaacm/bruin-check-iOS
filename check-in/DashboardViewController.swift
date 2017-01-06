//
//  DashboardViewController.swift
//  check-in
//
//  Created by Matt Garnett on 1/4/17.
//  Copyright © 2017 Matt Garnett. All rights reserved.
//



import Foundation
import UIKit

class DashboardViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var chartView: ScrollableGraphView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    /* -------------------------------------------------------- */
    
    var type : String?
    var events = [Event]()
    var members = [Member]()
    
    var refresh = UIRefreshControl()
    
    @IBOutlet weak var listView: UITableView!
    
    let controller = Controller.sharedInstance
    
    /* -------------------------------------------------------- */
    
    override func viewDidLoad() {
        // Set the UITableView delegates
        listView.dataSource = self
        listView.delegate = self
        
        // Make tableview background white
        listView.backgroundColor = .white
        
        // Setup activity wheel
        listView.refreshControl = self.refresh
        refresh.tintColor = .black
        refresh.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        
        // Start a refresh...eventually should figure out a better way
        refresh.beginRefreshingManually()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return events.count//type == "events" ? (events.count < 5 ? events.count : 5) : (members.count < 5 ? members.count : 5)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Name the sections best or worst depeding on whether it is section 0 or 1
        if let type = type {
            if section == 0 {
                return "Best " + (type == "events" ? "Events" : "Members")
            } else if section == 1 {
                return "Worst " + (type == "events" ? "Events" : "Members")
            }
        }
        
        // ...
        return ""
    }
    
    // Create a custom label for the section headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
        let cell = DashboardCell()
        myLabel.frame = CGRect(x: 15, y: cell.frame.height / 2, width: 320, height: 20)
        myLabel.font = UIFont(name: "Futura-bold", size: 18)
        myLabel.text = self.tableView(listView, titleForHeaderInSection: section)
        myLabel.textColor = .black
        let myView = UIView()
        myView.addSubview(myLabel)
        return myView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Magic number
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // For some reason if you return 0 it goes back to the default
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell", for: indexPath) as! DashboardCell
                
        var index = indexPath.row
        
        if indexPath.section == 1 {
            index = events.count - indexPath.row - 1
        }
        
        let event = events[index]
        cell.title.text = event.name
        cell.subtitle.text = event.location
        cell.countLabel.text = "\(event.attendee_count)"
        cell.countType.text = event.attendee_count == 1 ? "attendee" : "attendees"
            
        /*
        var index = indexPath.row
        
        if indexPath.section == 1 {
            index = members.count - indexPath.row - 1
        }
        
        let member = members[index]
        cell.title.text = member.name
        cell.subtitle.text = member.email
        cell.countLabel.text = "\(member.events.count)"
        cell.countType.text = member.events.count == 1 ? "event" : "events"
        */
        
        return cell
    }
    
    func loadData() {
        
        // Find events
        controller.getAllEvents { (events_list, error) in
            
            // Sucessfully got events list
            self.events = events_list
            
            // Sort the events array alphbetically
            self.events.sort(by: { (a, b) -> Bool in
                return a.attendee_count > b.attendee_count
            })
            
            // Reload with new data
            self.updateChartWithData()
            self.listView.reloadData()
        }
        
        // Done interacting w/ the interwebs...we can turn off the activity wheel
        self.refresh.endRefreshing()
        
        /*
        // find members
        controller.getAllMembers { (members_list, error) in
            
            // Sucessfully got members list
            self.members = members_list
            
            // Sort the events array alphbetically
            self.members.sort(by: { (a, b) -> Bool in
                return a.events.count > b.events.count
            })
            
            // Reload with new data
            self.listView.reloadData()
        }
        
        // Done interacting w/ the interwebs...we can turn off the activity wheel
        self.refresh.endRefreshing()
         */
    
    }
    
    func updateChartWithData() {
        
        
        var oldest = Date.init()
        
        for event in events {
            if event.startDate < oldest && event.startDate > Date.init() {
            oldest = event.startDate
        }
        
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
