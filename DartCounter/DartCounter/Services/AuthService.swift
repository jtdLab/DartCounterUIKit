//
//  AuthService.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 25.10.20.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseAuth.FIRAuthErrors


public class AuthService {
    
    static func signUpUsernameAndPassword(username :String, password :String, onError: @escaping (NSError) -> Void) {
        Auth.auth().createUser(withEmail: username + "@username.com", password: password) { authResult, error in
            if error == nil {
                guard let newUser = authResult?.user else { return }
                
                DatabaseService.createProfile(uid: newUser.uid, username: username, onError: onError)
                DatabaseService.createCareerStats(uid: newUser.uid, onError: onError)
                
            } else {
                onError(error! as NSError)
            }
        }
    }
    
    static func signInUsernameAndPassword(username :String, password :String, onError: @escaping (NSError) -> Void) {
        Auth.auth().signIn(withEmail: username + "@username.com", password: password) { authResult, error in
            if error != nil {
                onError(error! as NSError)
            }
        }
    }
    
    static func signInFacebook(onError: @escaping (NSError) -> Void) {
        // TODO
    }
    
    static func signInGoogle(onError: @escaping (NSError) -> Void) {
        // TODO
    }
    
    static func signInInstagram(onError: @escaping (NSError) -> Void) {
        // TODO
    }
    
    static func signOut() {
        do {
          try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
}


