//
//  UserProfile.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 03.12.20.
//

import Foundation

class UserProfile {
    
    var uid: String
    var username: String
    var photoURL: URL?
    
    init(uid: String, username: String, photoURL: URL?) {
        self.uid = uid
        self.username = username
        self.photoURL = photoURL
    }
    
    var dict: [String:Any] {
        return [
            "uid": uid,
            "username": username,
            "photoURL": photoURL?.absoluteString,
        ]
    }
    
    static func fromDict(uid: String, dict: [String:Any]) -> UserProfile? {
        if let un = dict["username"] as? String {
            if let p = dict["photoURL"] as? String {
                return UserProfile(uid: uid, username: un, photoURL: URL(string: p))
            } else {
                return UserProfile(uid: uid, username: un, photoURL: nil)
            }
        }
        
        return nil
    }

}
