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
    
    let parse_user = PFUser()
    
    var uid : String?
    var name: String? {
        get { return PFUser.current()?.username }
        set(n) {
            parse_user.username = n
            save()
        }
    }
    
    var email: String? {
        get { return PFUser.current()?.email }
        set(n) {
            parse_user.email = n
            save()
        }
    }
    
    var groupID: String?
    /* -------------------------------------------------------- */
    
    func signup(email: String, password: String, completionHandler: @escaping ( (Error?) -> Void ) ) {
        parse_user.username = email
        parse_user.password = password
        parse_user.email = email
        // other fields can be set just like with PFObject
        //user["phone"] = "415-392-0202"
        
        parse_user.signUpInBackground { (succeeded: Bool, error: Error?) -> Void in
            
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
        parse_user.saveInBackground(block: nil)
    }
    
    func save(completionHandler: @escaping (Error?) -> Void) {
        parse_user.saveInBackground(block: { (user, error) -> Void in
            completionHandler(error)
        })
    }
    
}
