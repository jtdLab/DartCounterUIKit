//
//  UserProfile.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 03.12.20.
//

import Foundation

class Profile {
    
    var username: String
    var photoURL: URL?
    var isOnline: Bool
    
    init(dict: [String:Any]) throws {
        if let un = dict["username"] as? String {
            if let iO = dict["isOnline"] as?  Bool {
                if let p = dict["photoURL"] as? String {
                    self.username = un
                    self.photoURL = URL(string: p)
                    self.isOnline = iO
                    return
                } else {
                    self.username = un
                    self.photoURL = nil
                    self.isOnline = iO
                    return
                }
            }
       
        }
        
        throw Errors.GeneralError.initError("Can't construct Profile from given dict")
    }
    
    init(username: String) {
        self.username = username
        self.photoURL = nil
        self.isOnline = false
    }
    
    init(username: String, photoURL: URL?, isOnline: Bool) {
        self.username = username
        self.photoURL = photoURL
        self.isOnline = isOnline
    }
    
    var dict: [String:Any] {
        return [
            "username": username,
            "photoURL": photoURL?.absoluteString,
            "isOnline": isOnline
        ]
    }
    
    static func fromDict(dict: [String:Any]) -> Profile? {
        if let un = dict["username"] as? String {
            if let iO = dict["isOnline"] as?  Bool {
                if let p = dict["photoURL"] as? String {
                    return Profile(username: un, photoURL: URL(string: p), isOnline: iO)
                } else {
                    return Profile(username: un, photoURL: nil, isOnline: iO)
                }
            }
       
        }
        
        return nil
    }

}
