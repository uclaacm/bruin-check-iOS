//
//  Member.swift
//  check-in
//
//  Created by Matt Garnett on 8/14/16.
//  Copyright © 2016 Matt Garnett. All rights reserved.
//

import Foundation
import FirebaseAuth

class User {
    
    /* -------------------------------------------------------- */
    
    //var entityId: String? //Kinvey entity _id
    var uid : String? {
        return FIRAuth.auth()?.currentUser?.uid
    }
    
    var name: String? {
        get {
            return FIRAuth.auth()?.currentUser?.displayName
        }
        
        set {
            
        }
        
    }
    
    var email: String? {
        get {
            return FIRAuth.auth()?.currentUser?.email
        }
        
        set {
            
        }
    }

    
    
    //var events: [String]
    //var groupIdentifier: String?
    //var metadata: KCSMetadata? //Kinvey metadata, optional
    
    /* -------------------------------------------------------- */
    
    func signup(email: String, password: String, completionHandler: @escaping ( (Error?) -> Void ) ) {
        FIRAuth.auth()!.createUser(withEmail: email, password: password) { user, error in
            
            if error == nil {
                
            }
            
            completionHandler(error)
        }
    }
    
    func login(email: String, password: String, completionHandler: @escaping ( (Error?) -> Void) ) {
        FIRAuth.auth()!.signIn(withEmail: email, password: password, completion: { (user, error) in
            completionHandler(error)
        })
    }
    
}
