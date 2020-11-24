//
//  User.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 25.10.20.
//

import Foundation
import FirebaseAuth

class User {
    
    var uid: String
    var username: String
    
    // ONLY WORKS WITH SIGN IN EMAIL AND PASSWORD (if email is given)
    init(firebaseUser :FirebaseAuth.User) {
        self.uid = firebaseUser.uid
        self.username = firebaseUser.email!.components(separatedBy: "@")[0]
    }
}
