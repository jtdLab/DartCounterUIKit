//
//  AuthService.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 25.10.20.
//

import Foundation

// this class provides Authentication
public class AuthenticationService {
    
    static func signUpUsernameAndPassword(username :String, password :String, onError: @escaping (_ error: NSError) -> Void) {
        Authentication.signUpUsernameAndPassword(username: username, password: password, completion: { user, error in
            guard let user = user else {
                // signUp failed
                onError(error!)
                return
            }
            
            // signUp successful
            UserService.initUser(user: user)
            // create User in RealtimeDatabase
            RealtimeDatabase.createUser(user: user)
        })
    }
    
    static func signInUsernameAndPassword(username :String, password :String, onError: @escaping (_ error: NSError) -> Void) {
        Authentication.signInUsernameAndPassword(username: username, password: password, completion: { user, error in
            guard let user = user else {
                // signIn failed
                onError(error!)
                return
            }
            
            // signIn successful
            UserService.initUser(user: user)
        })
    }
    
    static func signInFacebook(onError: @escaping (_ error: NSError) -> Void) {
        // TODO
    }
    
    static func signInGoogle(onError: @escaping (_ error: NSError) -> Void) {
        // TODO
    }
    
    static func signInInstagram(onError: @escaping (_ error: NSError) -> Void) {
        // TODO
    }
    
    static func signOut() {
        Authentication.signOut()
    }
    
}


