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
        parse_member["name"] = name
        parse_member["email"] = email
        parse_member["id"] = id
        parse_member["events"] = events
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
    
 /*
    func save(completion: @escaping () -> Void) {
        let collection = KCSCollection.init(from: "Members", of: Member.self)
        let store = KCSAppdataStore(collection: collection, options: nil)
        
        store!.save(
            self,
            withCompletionBlock: { (KCSCompletionBlock) -> Void in
                if KCSCompletionBlock.1 != nil {
                    //save failed
                    //NSLog("Save failed, with error: %@", KCSCompletionBlock.1!)
                    
                } else {
                    //save was successful
                    completion()
                    NSLog("Successfully saved member (id='%@').", (KCSCompletionBlock.0?[0] as! NSObject).kinveyObjectId())
                }
            },
            withProgressBlock: nil)
    }
    
    func loadFromID(id: String, groupID: String, completion: @escaping (_ success: Bool) -> Void) {
        
        let collection = KCSCollection.init(from: "Members", of: Member.self)
        let store = KCSAppdataStore(collection: collection, options: nil)
        
        var success = false
        
        
        let query = KCSQuery(onField: "groupIdentifier", withExactMatchForValue: groupID as NSObject!)
        
        _ = store?.query(withQuery:
            query, withCompletionBlock: { (member_list, error) -> Void in
                if let member_list = member_list as? [Member]{
                    for m in member_list {
                        if m.id == id {
                            self.entityId = m.entityId
                            self.name = m.name
                            self.email = m.email
                            self.id = m.id
                            self.events = m.events
                            self.groupIdentifier = m.groupIdentifier
                            self.metadata = m.metadata
                            success = true
                        }
                    }
                } else {
                    // Couldn't find the id in the database, begin configuring new member
                    self.id = id
                }
                
                completion(success)
            },
                   withProgressBlock: nil
        )

    }
    
    func addEvent(e: Event) -> Bool {
        if (events.index(of: e.entityId!)) != nil {
            return false
        } else {
            events.append(e.entityId!)
            return true
        }
    }
    
    func removeEvent(entityId: String) {
        if let i = events.index(of: entityId) {
            events.remove(at: i)
        }
    }
    
    override static func kinveyPropertyToCollectionMapping() -> [AnyHashable : Any]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "name" : "name",
            "email": "email",
            "id" : "id",
            "events" : "events",
            "groupIdentifier" : "groupIdentifier",
            "metadata" : KCSEntityKeyMetadata //optional _metadata field
        ]
    }*/
}
