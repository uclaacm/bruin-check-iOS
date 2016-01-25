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

    @IBOutlet weak var tableViewCells: UITableViewCell!
    
    var tableViewCellNames = [String]()
    var tableViewCellDates = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("ENTERED TABLEVIEW")
        
        //Use a different value for className
        let query = PFQuery(className: "Posts")
        query.orderByDescending("createdAt")    //Chronological order
        query.findObjectsInBackgroundWithBlock {
            (posts: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                //Success fetching objects
                print(posts!.count)
                for post in posts! {
                    self.tableViewCellNames.append(post["names"]) as! String
                    self.tableViewCellDates.append(post["dates"]) as! String
                }
            } else {
                print(error)
            }
        }
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
