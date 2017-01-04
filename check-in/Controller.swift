//
//  Controller.swift
//  check-in
//
//  Created by Matt Garnett on 12/24/16.
//  Copyright © 2016 Matt Garnett. All rights reserved.
//

import Foundation
import Parse

class Controller {
    
    static let sharedInstance = Controller()
    private init() { }
    
    let user = User()
    
    func createACLforRole(role: PFRole) -> PFACL {
        let acl = PFACL()
        
        acl.getPublicReadAccess = false
        acl.getPublicWriteAccess = false
        acl.setWriteAccess(true, for: role)
        acl.setReadAccess(true, for: role)
        
        return acl
    }
    
    // Get all events
    func getAllEvents(completionHandler: @escaping (([Event], Error?) -> Void)) {
        let query = PFQuery(className: "Event")
        query.findObjectsInBackground { (objects: [PFObject]?, error) in
            var events = [Event]()
            if let objects = objects {
                for object in objects {
                    events.append(Event(object: object))
                }
            }
            
            completionHandler(events, error)
        }
    }
    
    // Get all members
    func getAllMembers(completionHandler: @escaping (([Member], Error?) -> Void)) {
        let query = PFQuery(className: "Member")
        query.findObjectsInBackground { (objects: [PFObject]?, error) in
            var members = [Member]()
            if let objects = objects {
                for object in objects {
                    members.append(Member(object: object))
                }
            }
            
            completionHandler(members, error)
        }
    }
    
    // Get the current role
    func getRole(name: String, completionHandler: @escaping ((PFRole, Error?) -> Void)) {
        let query = PFRole.query()
        query?.whereKey("name", equalTo: name)
        query?.findObjectsInBackground(block: { (objects, error) in
            
            var role = PFRole()
            if let objects = objects {
                let roles = objects as! [PFRole]
                role = roles[0]
            }
            
            completionHandler(role, error)
            
        })

    }
}
