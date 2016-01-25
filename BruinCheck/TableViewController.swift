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
    var tableViewCellDates = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("ENTERED TABLEVIEW")
        
        //Use a different value for className
        let query = PFQuery(className: "Posts")
        query.orderByDescending("createdAt")    //Chronological order
        query.findObjectsInBackgroundWithBlock {
            (posts:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                //Success fetching objects
                for post in posts! {
                    print(post)
                    print("\n")
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
