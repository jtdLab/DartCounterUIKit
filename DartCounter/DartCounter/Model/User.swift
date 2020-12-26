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
    
    var friends: [Friend]
    
    var invitations: [Invitation]
    
    
    init(uid: String, dict: [String:Any]) throws {
        if let p = dict["profile"] as? [String:Any] {
            if let cs = dict["careerStats"] as? [String:Any] {
                if dict["invitations"] as? String == "null" {
                    self.invitations = []
                    if dict["friends"] as? String == "null" {
                        self.friends = []
                    } else {
                        if let f = dict["friends"] as? [String:Any] {
                            self.friends = []
                            for tempFriendDict in f {
                                friends.append(try! Friend(uid: tempFriendDict.key , dict: tempFriendDict.value as! [String:Any]))
                            }
                        } else {
                            throw Errors.GeneralError.initError("Can't construct User from given dict")
                        }
                    }
                } else {
                    if let i = dict["invitations"] as? [String:Any] {
                        self.invitations = []
                        for tempInvitationsDict in i {
                            invitations.append(try! Invitation(inviterUid: tempInvitationsDict.key , dict: tempInvitationsDict.value as! [String:Any]))
                        }
                    } else {
                        throw Errors.GeneralError.initError("Can't construct User from given dict")
                    }
                    if dict["friends"] as? String == "null" {
                        self.friends = []
                    } else {
                        if let f = dict["friends"] as? [String:Any] {
                            self.friends = []
                            for tempFriendDict in f {
                                friends.append(try! Friend(uid: tempFriendDict.key , dict: tempFriendDict.value as! [String:Any]))
                            }
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
        self.friends = []
        self.invitations = []
    }
    
    init(uid: String ,profile: Profile, careerStats: CareerStats) {
        self.uid = uid
        self.profile = profile
        self.careerStats = careerStats
        self.friends = []
        self.invitations = []
    }
    
    init(uid: String, profile: Profile, careerStats: CareerStats, friends: [Friend], invitations: [Invitation]) {
        self.uid = uid
        self.profile = profile
        self.careerStats = careerStats
        self.friends = friends
        self.invitations = invitations
    }
    
    var dict: [String:Any] {
        var friendsDict = [String:Any]()
        if friends.count != 0 {
            for friend in friends {
                friendsDict[friend.uid] = friend.profile.dict
            }
        }
        
        var invitationsDict = [String:Any]()
        if invitations.count != 0 {
            for invitation in invitations {
                invitationsDict[invitation.inviterUid] = invitation.dict
            }
        }
        
        return [
            "profile": profile.dict,
            "careerStats": careerStats.dict,
            "friends": (friends.count == 0 ? "null" : friendsDict) ,
            "invitations": (invitations.count == 0 ? "null" : invitationsDict)
        ]
    }
    
}
