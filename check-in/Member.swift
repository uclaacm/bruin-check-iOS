//
//  Member.swift
//  check-in
//
//  Created by Matt Garnett on 8/14/16.
//  Copyright © 2016 Matt Garnett. All rights reserved.
//

import Foundation
import Parse

class Member {
    
    var parse_member = PFObject(className: "Member")
    
    init?(name: String, email: String, id: String, events: [String]) {
        let controller = Controller.sharedInstance
        
        parse_member["name"] = name
        parse_member["email"] = email
        parse_member["id"] = id
        parse_member["events"] = events
        parse_member["group"] = controller.user.currentGroup
        
        controller.getRole(name: controller.user.currentGroup) { (role, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            let acl = controller.createACLforRole(role: role)
            self.parse_member.acl = acl
            
            self.save()
        }
    }
    
    init?(id: String, completion: @escaping (Bool) -> Void) {
        // TODO
        completion(true)
    }
    
    init(object: PFObject) {
        parse_member = object
    }
    
    func save() {
        parse_member.saveInBackground(block: nil)
    }
    
    func save(completionHandler: @escaping (Error?) -> Void) {
        parse_member.saveInBackground(block: { (user, error) -> Void in
            completionHandler(error)
        })
    }
    
    func delete() {
        parse_member.deleteInBackground(block: nil)
    }
    
    func delete(completionHandler: @escaping (Error?) -> Void) {
        parse_member.deleteInBackground(block: { (user, error) -> Void in
            completionHandler(error)
        })
    }
    
    var oid: String {
        return parse_member.objectId!
    }
    
    var name: String {
        get { return parse_member["name"] as! String }
        set(n) { parse_member["name"] = n }
    }
    
    var email: String {
        get { return parse_member["email"] as! String }
        set(e) { parse_member["email"] = e }
    }
    
    var id: String {
        get { return parse_member["id"] as! String }
        set(i) { parse_member["id"] = i }
    }
    
    var events: [String] {
        get { return parse_member["events"] as! [String] }
        set(e) { parse_member["evetns"] = e }
    }
    
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
