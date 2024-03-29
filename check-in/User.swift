//
//  Member.swift
//  check-in
//
//  Created by Matt Garnett on 8/14/16.
//  Copyright © 2016 Matt Garnett. All rights reserved.
//

import Foundation
import Parse

class User {
    
    /* -------------------GETTERS & SETTERS-------------------- */
    
    //let parse_user = PFUser()

    var uid : String?
    var name: String? {
        get { return PFUser.current()?.username }
        set(n) { PFUser.current()?.username = n }
    }
    
    var email: String? {
        get { return PFUser.current()?.email }
        set(n) { PFUser.current()?.email = n }
    }
    
    var groups: [String]? {
        get { return PFUser.current()?["groups"] as! [String]? }
        set(g) { PFUser.current()?["groups"] = g }
    }
    
    var currentGroup: String {
        get { return PFUser.current()?["currentGroup"] as! String }
        set(g) { PFUser.current()?["currentGroup"] = g }
    }

    /* -------------------------------------------------------- */
    
    func signup(name: String, email: String, password: String, groupID: String, completionHandler: @escaping ( (Error?) -> Void ) ) {
        let user = PFUser()
        
        user.username = email as String
        user.password = password as String
        user.email = email as String
        
        user["name"] = name
        
        var groups = [String]()
        groups.append(groupID)
        user["groups"] = groups
        user["currentGroup"] = groupID
        
        user.signUpInBackground { (succeeded: Bool, error: Error?) -> Void in
           
            if let error = error {
                completionHandler(error)
                return
            }
            
            
            let acl = PFACL()
            acl.getPublicReadAccess = false
            acl.getPublicWriteAccess = false
            
            acl.setWriteAccess(true, for: user)
            acl.setReadAccess(true, for: user)
            
            let role = PFRole(name: groupID, acl: acl)
            
            role.users.add(user)
            role.saveInBackground(block: { (success, error) in
                
                completionHandler(error)
            })
        }
    }
    
    func createAndSaveUser(email: String, password: String, completionHandler: @escaping ( (Error?) -> Void ) ) {
    
    }
    
    func login(email: String, password: String, completionHandler: @escaping ( (Error?) -> Void) ) {
        PFUser.logInWithUsername(inBackground: email, password: password) { (user: PFUser?, error: Error?) -> Void in
            if user != nil {
                let query = PFRole.query()
                query?.whereKey("users", equalTo: PFUser.current()!)
                query?.findObjectsInBackground(block: { (objects, error) in
                    PFUser.current()?["currentRole"] = objects?[0] as! PFRole
                    completionHandler(error)
                })
            } else {
                completionHandler(error)
            }
        }
    }
    
    func logout() {
        PFUser.logOut()
    }
    
    func save() {
        PFUser.current()?.saveInBackground(block: nil)
    }
    
    func save(completionHandler: @escaping (Error?) -> Void) {
        PFUser.current()?.saveInBackground(block: { (user, error) -> Void in
            completionHandler(error)
        })
    }
    
}
