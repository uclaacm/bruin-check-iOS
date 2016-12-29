//
//  Event.swift
//  check-in
//
//  Created by Matt Garnett on 8/13/16.
//  Copyright © 2016 Matt Garnett. All rights reserved.
//

import Foundation
import Parse

class Event {
    
    var parse_event = PFObject(className: "Event")
    
    init?(name: String, startDate: NSDate, endDate: NSDate, location: String, attendees: [Member]) {
    
        let controller = Controller.sharedInstance
        
        var parse_members = [PFObject]()
        for attendee in attendees {
            parse_members.append(attendee.parse_member)
        }
        
        parse_event["name"] = name
        parse_event["startDate"] = startDate as Any
        parse_event["endDate"] = endDate as Any
        parse_event["location"] = location
        parse_event["attendees"] = parse_members
        parse_event["group"] = controller.user.currentGroup
        
        controller.getRole(name: controller.user.currentGroup) { (role, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            print(role.name)
            let acl = controller.createACLforRole(role: role)
            self.parse_event.acl = acl
            
            self.save()
        }
    }
    
    func save() {
        parse_event.saveInBackground(block: nil)
    }
    
    func save(completionHandler: @escaping (Error?) -> Void) {
        parse_event.saveInBackground(block: { (user, error) -> Void in
            completionHandler(error)
        })
    }
    
    var oid: String {
        return parse_event.objectId!
    }
    
    init(object: PFObject) {
        parse_event = object
    }
    
    var name: String {
        get { return parse_event["name"] as! String }
        set(n) { parse_event["name"] = n }
    }
    
    var startDate: NSDate {
        get { return parse_event["startDate"] as! NSDate }
        set(s) { parse_event["startDate"] = s }
    }
    
    var endDate: NSDate {
        get { return parse_event["endDate"] as! NSDate }
        set(e) { parse_event["endDate"] = e }
    }
    
    var location: String {
        get { return parse_event["location"] as! String }
        set(l) { parse_event["location"] = l }
    }
    var attendees: [Member] {
        get { return parse_event["attendees"] as! [Member] }
        set(a) { parse_event["attendees"] = attendees }
    }
    
    func addAttendee(m: Member) -> Bool {
        var temp = attendees
        temp.append(m)
        attendees = temp
        
        return true
    }
    
    func removeAttendee(entityId: String) {
    }
    
    /*
    /* -------------------------------------------------------- */
    
    private(set) var entityId: String? //Kinvey entity _id
    private(set) var name: String?
    private(set) var startDate: NSDate?
    private(set) var endDate: NSDate?
    private(set) var location: String?
    private(set) var attendees: [String]
    private(set) var groupIdentifier: String?
    private(set) var metadata: KCSMetadata? //Kinvey metadata, optional
    
    /* -------------------------------------------------------- */
    
    override init() {
        attendees = []
        super.init()
    }
    
    // Set-ers
    
    func setEntityId(e: String) { entityId = e }
    func setName(n: String) { name = n }
    func setStartDate(s: NSDate) { startDate = s }
    func setEndDate(e: NSDate) { endDate = e }
    func setLocation(l: String) { location = l }
    func setAttendees(a: [String]) { attendees = a }
    func setGroupIdentifier(g: String) { groupIdentifier = g }
    func setMetadata(m: KCSMetadata) { metadata = m }
    func setAll(_entityId: String, _name: String, _startDate: NSDate, _endDate: NSDate, _location: String, _attendees: [String], _groupIdentifer: String, _metadata: KCSMetadata) {
        entityId = _entityId
        name = _name
        startDate = _startDate
        endDate = _endDate
        location = _location
        groupIdentifier = _groupIdentifer
        metadata = _metadata
    }
    
    /* -------------------------------------------------------- */
    
    public func load(entityId: String) {
        
        let collection = KCSCollection.init(from: "Events", of: Event.self)
        let store = KCSAppdataStore(collection: collection, options: nil)
        
        let query = KCSQuery(onField: "entityId", withExactMatchForValue: entityId as NSObject!)
        
        _ = store?.query(withQuery:
            query, withCompletionBlock: { (event, error) -> Void in
                if event?[0] != nil {
                    let e = (event?[0] as! Event)
                    self.entityId = e.entityId
                    self.name = e.name
                    self.startDate = e.startDate
                    self.endDate = e.endDate
                    self.location = e.location
                    self.attendees = e.attendees
                    self.groupIdentifier = e.groupIdentifier
                    self.metadata = e.metadata
                    //self.isEmpty = false
                } else {
                    NSLog("Error constructing event from entityId")
                }
            },
                   withProgressBlock: nil
        )
    }
    
    public func save(completion: @escaping () -> Void) {
        let collection = KCSCollection.init(from: "Events", of: Event.self)
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
                    NSLog("Successfully saved event (id='%@').", (KCSCompletionBlock.0?[0] as! NSObject).kinveyObjectId())
                }
            },
            withProgressBlock: nil
        )
    }

    
    func addAttendee(m: Member) -> Bool {
        if (attendees.index(of: m.entityId!)) != nil {
            return false
        } else {
            attendees.append(m.entityId!)
            return true
        }
    }
    
    func removeAttendee(entityId: String) {
        if let i = attendees.index(of: entityId) {
            attendees.remove(at: i)
        }
    }
    
    override static func kinveyPropertyToCollectionMapping() -> [AnyHashable : Any]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "name" : "name",
            "startDate" : "startDate",
            "endDate" : "endDate",
            "location" : "location",
            "attendees" : "attendees",
            "groupIdentifier" : "groupIdentifier",
            "metadata" : KCSEntityKeyMetadata //optional _metadata field
        ]

    }
 */
}
