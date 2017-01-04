//
//  Member.swift
//  check-in
//
//  Created by Matt Garnett on 8/14/16.
//  Copyright © 2016 Matt Garnett. All rights reserved.
//

import Foundation
import Parse

class Member : Object {
    
    init?(name: String, email: String, id: String, events: [String]) {
        super.init(className: "Member")
        
        let controller = Controller.sharedInstance
        
        parse_object["name"] = name
        parse_object["email"] = email
        parse_object["id"] = id
        parse_object["events"] = events
        parse_object["group"] = controller.user.currentGroup
        
        controller.getRole(name: controller.user.currentGroup) { (role, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            let acl = controller.createACLforRole(role: role)
            self.parse_object.acl = acl
            
            self.save()
        }
    }
    
    init?(id: String, completion: @escaping (Bool) -> Void) {
        super.init(className: "Member")
        let query = PFQuery(className: "Member")
        query.whereKey("id", equalTo: id)
        
        query.findObjectsInBackground { (objects: [PFObject]?, error) in
            
            if error != nil {
                completion(false)
                //return nil
            }
            
            if objects?.count == 0 {
                completion(false)
                //return nil
            }
            
            let member = (objects?[0])! as PFObject
            //self.init(object: member)
            self.parse_object = member
            
            completion(true)
        }

    }
    
    init(object: PFObject) {
        super.init(className: "Member")
        parse_object = object
    }
    
    /* ------------------GETTERS & SETTERS------------------- */
    
    var name: String {
        get { return parse_object["name"] as! String }
        set(n) { parse_object["name"] = n }
    }
    
    var email: String {
        get { return parse_object["email"] as! String }
        set(e) { parse_object["email"] = e }
    }
    
    var id: String {
        get { return parse_object["id"] as! String }
        set(i) { parse_object["id"] = i }
    }
    
    var events: [String] {
        get { return parse_object["events"] as! [String] }
        set(e) { parse_object["evetns"] = e }
    }
    
    /* ----------------------------------------------------- */
    

    
    func addEvent(e: Event) -> Bool {
        if (events.index(of: e.oid)) != nil {
            return false
        } else {
            events.append(e.oid)
            return true
        }
    }
    
    func removeEvent(entityId: String) {
        if let i = events.index(of: entityId) {
            events.remove(at: i)
        }
    }
}
