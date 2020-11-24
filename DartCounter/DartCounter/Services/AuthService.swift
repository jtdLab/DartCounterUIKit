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
    
    static let shared = AuthService()
    
    private init() {
        
    }
    
    func signUpUsernameAndPassword(username :String, password :String, onSuccess: @escaping (FirebaseAuth.User) -> Void, onError: @escaping (NSError) -> Void) {
        Auth.auth().createUser(withEmail: username + "@username.com", password: password) { authResult, error in
            if error != nil {
                onError(error! as NSError)
                return
            }
            
            onSuccess(authResult!.user)
        }
    }
    
    func signInUsernameAndPassword(username :String, password :String, onSuccess: @escaping (FirebaseAuth.User) -> Void, onError: @escaping (NSError) -> Void) {
        Auth.auth().signIn(withEmail: username + "@username.com", password: password) { authResult, error in
            if error != nil {
                onError(error! as NSError)
                return
            }
            
            onSuccess(authResult!.user)
        }
    }
    
    func signInFacebook(onError: @escaping (NSError) -> Void) {
        // TODO
    }
    
    func signInGoogle(onError: @escaping (NSError) -> Void) {
        // TODO
    }
    
    func signInInstagram(onError: @escaping (NSError) -> Void) {
        // TODO
    }
    
    func signOut() {
        do {
          try Auth.auth().signOut()
          App.user = nil
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
}


