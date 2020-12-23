//
//  FriendService.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 23.12.20.
//

import Foundation
import Firebase
import FirebaseDatabase

class FriendService {
    
    static func addFriend(uid: String) {
        guard let currentUid = UserService.currentProfile?.uid else { return }
        
        let friendReference = Firestore.firestore().collection("users").document(currentUid)
        
        let friend = ["uid": uid]
        
        friendReference.updateData(["friends": FieldValue.arrayUnion([friend])])
    }
    
    static func addFriend(username: String) {
        
    }
    
    static func removeFriend(uid: String) {
        
    }
    
    static func removeFriend(username: String) {
        
    }
    
}
