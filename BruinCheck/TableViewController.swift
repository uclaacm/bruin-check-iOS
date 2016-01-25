//
//  TableViewController.swift
//  BruinCheck
//
//  Created by Matthew Allen Lin on 1/17/16.
//  Copyright © 2016 Li-Wei Tseng. All rights reserved.
//

import UIKit
//import Parse

class TableViewController: UITableViewController {

//    @IBOutlet weak var tableViewCells: UITableViewCell!
    @IBOutlet var tableViewVar: UITableView!
    
    var tableViewCellNames = [String]() //Required
    var tableViewCellDates = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("ENTERED TABLEVIEW")
        
        //Use a different value for className
        let query = PFQuery(className: "event_info")
        query.orderByDescending("createdAt")    //Chronological order
        query.findObjectsInBackgroundWithBlock {
            (posts:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                //Success fetching objects
                for post in posts! {
                    print("Parse data: ")
                    print(post)
                    print("\n")
                    
                    self.tableViewCellNames.append(post["event_name"] as! String)
        //            self.tableViewCellDates.append(post["beginning_of_event_time"] as! String)    //Values need to be assigned
                }
                
                /*Reload the table*/
                self.tableViewVar.reloadData()
                
                print(self.tableViewCellNames.count)
            } else {
                print(error)
            }
        }
    }
    
    /*Table view begin*/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCellNames.count;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let singleCell: SingleRowCell = tableView.dequeueReusableCellWithIdentifier("mySingleCell") as! SingleRowCell
        
//        singleCell.textLabel = tableViewCellNames[indexPath.row]
//        singleCell.textLabel = tableViewCellDates[indexPath.row]
//        
        return singleCell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Link everything through Parse, so name of event, date, 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
