//
//  FirstViewController.swift
//  check-in
//
//  Created by Matt Garnett on 8/12/16.
//  Copyright © 2016 Matt Garnett. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }
}

class EventsViewController: UITableViewController {

    /* -------------------------------------------------------- */
    
    let controller = Controller.sharedInstance
    
    var events = [Event]()
    var refresh = UIRefreshControl()
    
    /* -------------------------------------------------------- */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Events loaded")

        // Configure the navbar
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.23, green:0.48, blue:0.84, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // Configure the activity wheel
        tableView.refreshControl = self.refresh
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }

    override func viewDidAppear(_ animated: Bool) {
        // Update the view whenever it has appeared
        // TODO: find a better way to do this ??!?!?
        self.refreshControl?.beginRefreshing()
        
        if fabs(self.tableView.contentOffset.y) < CGFloat(FLT_EPSILON) {
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.tableView.contentOffset = CGPoint(x: 0, y: -self.refreshControl!.frame.size.height);
            }, completion: nil)
        }
        
        refresh.sendActions(for: .valueChanged)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsCell", for: indexPath)
        
        var event : Event
        event = events[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = event.name
        cell.detailTextLabel?.text = "\(event.attendee_count) " + (event.attendee_count == 1 ? "attendee" : "attendees")
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let eventToDelete = events[indexPath.row]
            events.remove(at: indexPath.row)
            
            eventToDelete.delete(completionHandler: { (error) in
                if let error = error {
                    //error occurred - add back into the list
                    self.events.insert(eventToDelete, at: indexPath.row)
                    tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)

                    print(error)
                    return
                }
                
                
            })
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let selectedEventCell = sender as? UITableViewCell {
            let eventViewController = segue.destination as! EventViewController
            let indexPath = tableView.indexPath(for: selectedEventCell)!
            let selectedEvent = events[(indexPath.row)]
            
            // Pass the selected event into the next view controller
            eventViewController.event = selectedEvent
        }
    }
    
    func loadData() {
        // Load the all the group's events from database
        controller.getAllEvents { (events_list, error) in
            self.events = events_list
            
            // sort the events based on their start date ( newest events at top )
            self.events.sort(by: { (a, b) -> Bool in
                return (a.startDate as NSDate!).timeIntervalSinceNow > (b.startDate as NSDate!).timeIntervalSinceNow
            })
            
            self.tableView.reloadData()
        }
        
        self.refresh.endRefreshing()
    }
}

