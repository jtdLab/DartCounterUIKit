//
//  Authentication.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 25.12.20.
//

import Foundation
import Firebase

// Bridge to Authentication (Firebase)
class Authentication {
    
    static func signUpUsernameAndPassword(username :String, password :String, completion: @escaping (_ user: User?, _ error: NSError?) -> Void) {
        Auth.auth().createUser(withEmail: username + "@username.com", password: password) { authResult, error in
            guard let uid = authResult?.user.uid else {
                completion(nil, error as NSError?)
                return
            }
            
            let user = User(uid: uid, username: username)
            
            completion(user, nil)
        }
    }
    
    static func signInUsernameAndPassword(username :String, password :String, completion: @escaping (_ user: User?, _ error: NSError?) -> Void) {
        Auth.auth().signIn(withEmail: username + "@username.com", password: password) { authResult, error in
            guard let uid = authResult?.user.uid else {
                completion(nil, error as NSError?)
                return
            }
            
            let user = User(uid: uid, username: username)
            
            completion(user, nil)
        }
    }
    
    static func signOut() {
        do {
          try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
}
