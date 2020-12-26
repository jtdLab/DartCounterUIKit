//
//  Friend.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 26.12.20.
//

import Foundation

class Friend {
    
    var uid: String
    var profile: Profile
    
    init(uid: String, dict: [String:Any]) throws {
        self.uid = uid
        self.profile = try! Profile(dict: dict)
    }
    
    init(uid: String, profile: Profile) {
        self.uid = uid
        self.profile = profile
    }
    
    var dict: [String:Any] {
        return [
            "uid": uid,
            "profile": profile.dict,
        ]
    }
    
}
