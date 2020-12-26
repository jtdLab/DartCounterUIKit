//
//  User.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 25.12.20.
//

import Foundation

class User {
    
    var uid: String
    
    var profile: Profile
    
    var careerStats: CareerStats
    
    var friends: [String]
    
    var invitations: [Invitation]
    
    
    init(uid: String, dict: [String:Any]) throws {
        if let p = dict["profile"] as? [String:Any] {
            if let cs = dict["careerStats"] as? [String:Any] {
                if dict["invitations"] as? String == "null" {
                    self.invitations = []
                    if dict["friends"] as? String == "null" {
                        self.friends = []
                    } else {
                        if let f = dict["friends"] as? [Any] {
                            var tempFriendss: [String?] = f.map {
                                if $0 is NSNull {
                                    return nil
                                } else {
                                    return ($0 as! String)
                                }
                            }
                            
                            self.friends = tempFriendss.filter { $0 != nil} as! [String]
                        } else {
                            throw Errors.GeneralError.initError("Can't construct User from given dict")
                        }
                    }
                } else {
                    if let i = dict["invitations"] as? [Any] {
                        var tempInvitations: [Invitation?] = i.map {
                            if $0 is NSNull {
                                return nil
                            } else {
                                return try! Invitation(dict: $0 as! [String:Any])
                            }
                        }
                        self.invitations = tempInvitations.filter { $0 != nil} as! [Invitation]
                    } else {
                        throw Errors.GeneralError.initError("Can't construct User from given dict")
                    }
                    if dict["friends"] as? String == "null" {
                        self.friends = []
                    } else {
                        if let f = dict["friends"] as? [Any] {
                            var tempFriendss: [String?] = f.map {
                                if $0 is NSNull {
                                    return nil
                                } else {
                                    return ($0 as! String)
                                }
                            }
                            
                            self.friends = tempFriendss.filter { $0 != nil} as! [String]
                        } else {
                            throw Errors.GeneralError.initError("Can't construct User from given dict")
                        }
                    }
                }
                self.uid = uid
                self.profile = try! Profile(dict: p)
                self.careerStats = try! CareerStats(dict: cs)
                return
            }
        }
        
        throw Errors.GeneralError.initError("Can't construct User from given dict")
    }
    
    init(uid: String, username: String) {
        self.uid = uid
        self.profile = Profile(username: username)
        self.careerStats = CareerStats()
        self.friends = ["HALLO","HDHD"]
        self.invitations = [Invitation(inviter: "Rim", gameCode: 3324), Invitation(inviter: "ha", gameCode: 9999)]
    }
    
    init(uid: String ,profile: Profile, careerStats: CareerStats) {
        self.uid = uid
        self.profile = profile
        self.careerStats = careerStats
        self.friends = []
        self.invitations = []
    }
    
    init(uid: String, profile: Profile, careerStats: CareerStats, friends: [String], invitations: [Invitation]) {
        self.uid = uid
        self.profile = profile
        self.careerStats = careerStats
        self.friends = friends
        self.invitations = invitations
    }
    
    var dict: [String:Any] {
        return [
            "profile": profile.dict,
            "careerStats": careerStats.dict,
            "friends": (friends.count == 0 ? "null" : friends) ,
            "invitations": (invitations.count == 0 ? "null" : invitations.map {$0.dict})
        ]
    }
    
}
