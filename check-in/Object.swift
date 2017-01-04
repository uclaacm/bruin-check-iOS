//
//  Object.swift
//  check-in
//
//  Created by Matt Garnett on 1/3/17.
//  Copyright © 2017 Matt Garnett. All rights reserved.
//

import Foundation
import Parse

class Object {
    
    var parse_object : PFObject
    
    init(className: String) {
        parse_object = PFObject(className: className)
    }
    
    var oid: String {
        return parse_object.objectId!
    }
    
    func save() {
        parse_object.saveInBackground(block: nil)
    }
    
    func save(completionHandler: @escaping (Error?) -> Void) {
        parse_object.saveInBackground(block: { (user, error) -> Void in
            completionHandler(error)
        })
    }

    func delete() {
        parse_object.deleteInBackground(block: nil)
    }
    
    func delete(completionHandler: @escaping (Error?) -> Void) {
        parse_object.deleteInBackground(block: { (user, error) -> Void in
            completionHandler(error)
        })
    }
    
    
}
