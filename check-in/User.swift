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
    
    /* -------------------------------------------------------- */
    
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
    
    var groupID: String? {
        get { return PFUser.current()?["groupID"] as! String? }
        set(i) { PFUser.current()?["groupID"] = i }
    }
    /* -------------------------------------------------------- */
    
    func signup(email: String, password: String, groupID: String, completionHandler: @escaping ( (Error?) -> Void ) ) {
        let user = PFUser()
        
        user.username = email as String
        user.password = password as String
        user.email = email as String
        user["groupID"] = groupID
        // other fields can be set just like with PFObject
        //user["phone"] = "415-392-0202"
        
        user.signUpInBackground { (succeeded: Bool, error: Error?) -> Void in
            completionHandler(error)
        }
    }
    
    func login(email: String, password: String, completionHandler: @escaping ( (Error?) -> Void) ) {
        PFUser.logInWithUsername(inBackground: email, password: password) { (user: PFUser?, error: Error?) -> Void in
            completionHandler(error)
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
