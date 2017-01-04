//
//  Event.swift
//  check-in
//
//  Created by Matt Garnett on 8/13/16.
//  Copyright © 2016 Matt Garnett. All rights reserved.
//

import Foundation
import Parse

class Event : Object {
    
    init?(name: String, startDate: NSDate, endDate: NSDate, location: String) {
        super.init(className: "Event")
        
        let controller = Controller.sharedInstance
        
        // Set the fields of the PFObject
        parse_object["name"] = name
        parse_object["startDate"] = startDate as Any
        parse_object["endDate"] = endDate as Any
        parse_object["location"] = location
        parse_object["attendee_count"] = 0
        parse_object["group"] = controller.user.currentGroup
        
        // Get the user's current role, based on their current group
        controller.getRole(name: controller.user.currentGroup) { (role, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            print(role.name)
            let acl = controller.createACLforRole(role: role)
            self.parse_object.acl = acl
            
            self.save()
        }
    }
    
    init(object: PFObject) {
        super.init(className: "Event")
        parse_object = object
    }
    
    /* ------------------GETTERS & SETTERS------------------- */
    
    var name: String {
        get { return parse_object["name"] as! String }
        set(n) { parse_object["name"] = n }
    }
    
    var startDate: NSDate {
        get { return parse_object["startDate"] as! NSDate }
        set(s) { parse_object["startDate"] = s }
    }
    
    var endDate: NSDate {
        get { return parse_object["endDate"] as! NSDate }
        set(e) { parse_object["endDate"] = e }
    }
    
    var location: String {
        get { return parse_object["location"] as! String }
        set(l) { parse_object["location"] = l }
    }
    
    var attendee_count: Int {
        get { return parse_object["attendee_count"] as! Int }
        set(c) { parse_object["attendee_count"] = c }
    }
    
    /* ------------------------------------------------------ */
    
    func addAttendee(m: Member) -> Bool {
        /*
        var temp = attendees
        temp.append(m)
        attendees = temp
        */
        
        /*
        let relation = self.parse_event.relation(forKey: "Members")
        relation.add(m.parse_member)
        */
 
        let join = PFObject(className: "Join")
        
        join.setObject(PFUser.current()!, forKey: "user")
        join.setObject(parse_object, forKey: "event")
        join.setObject(m.parse_object, forKey: "member")
        join.setObject(Date.init(), forKey: "date")
        join.saveInBackground()
        
        attendee_count += 1
        save()
        
        return true
    }
    
    func getAttendees(completionHandler: @escaping ([Member], Error?) -> Void) {
        
        let query = PFQuery(className: "Join")
        query.whereKey("event", equalTo: parse_object)
    
        query.findObjectsInBackground { (objects, error) in
            var members = [Member]()
            
            if let error = error {
                completionHandler(members, error)
                return
            }

            // Loop through the returned objects and fetch them in the background if needed
            for i in 0..<objects!.count {
                let member = objects![i]["member"] as! PFObject
                
                member.fetchIfNeededInBackground(block: { (object, error) in
                    
                    if let error = error {
                        completionHandler(members, error)
                        return
                    }
                    
                    members.append(Member(object: object!))
                    
                    if i == objects!.count-1 {
                        completionHandler(members, error)
                    }
                })
            }
        }
    }
    
    func removeAttendee(member: Member) {
        let query = PFQuery(className: "Join")
        query.whereKey("event", equalTo: parse_object)
        query.whereKey("member", equalTo: member)
        
        query.findObjectsInBackground { (objects, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            for object in objects! {
                object.deleteInBackground()
            }
        }
    }
}
