//
//  DatabaseService.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 04.12.20.
//

import Foundation
import Firebase

// Bridge to RealtimeDatabase (Firebase)
class RealtimeDatabase {
    
    static func createUser(user: User) {
        let databaseReference = Database.database().reference().child("users/\(user.uid)")
        databaseReference.setValue(user.dict)
    }
    
    static func observeUser(uid: String, onChanged: @escaping (User)-> Void) {
        let ref = Database.database().reference().child("users/\(uid)")
        
        ref.observe(.value, with: { snapshot in
            var updatedUser: User?
            
            if let dict = snapshot.value as? [String:Any] {
                updatedUser = try! User(uid: uid, dict: dict)
            }
            
            if updatedUser != nil {
                onChanged(updatedUser!)
            }
            
        })
    }
    
    static func observeInvitations(uid: String, onChanged: @escaping ([Invitation])-> Void) {
        let ref = Database.database().reference().child("users/\(uid)/invitations")
        
        ref.observe(.value, with: { snapshot in
            var invitations: [Invitation]?
            
            /**
             if let dict = snapshot.value as? [String:Any] {
                 snapshot.childrenCount
             }
             
             let invitationsObject = data["invitations"] as! NSArray
             
             if invitationsObject.count > 0 {
                 invitations = []
             }
             
             for invitation in invitationsObject {
                 let dict = invitation as! [String:Any]
                 if let temp = Invitation.fromDict(dict: dict) {
                     invitations?.append(temp)
                 }
             }
             
             completion(invitations)
             */
            
        })
    }
    
    static func getData(pathString: String) {
        let ref = Database.database().reference().child(pathString)
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
        })
    }

 /**
     static func createProfile(uid: String, username: String, onError: @escaping (NSError) -> Void) {
         
         let databaseReference = Database.database().reference().child("users/\(uid)/profile")
         
         let userObject = [
             "username": username,
         ] as [String:Any]
         
         databaseReference.setValue(userObject) { error, ref in
             if error != nil {
                 onError(error! as NSError)
             }
         }
     }
     
     static func createCareerStats(uid: String, onError: @escaping (NSError) -> Void) {
         let databaseReference = Database.database().reference().child("users/\(uid)/careerStats")
         
         let careerStatsObject = [
             "average": "0.00",
             "firstNine": "0.00",
             "checkoutPerentage": "0.00",
             "wins": "0",
             "defeats": "0"
         ] as [String:Any]
         
         databaseReference.setValue(careerStatsObject) { error, ref in
             if error != nil {
                 onError(error! as NSError)
             }
         }
     }
     
     static func createUsernameUidIndex(username: String, uid: String) {
         let indexReference = Firestore.firestore().collection("usernameUidIndex").document(username)
         
         let careerStatsObject = [
             "uid": uid,
         ] as [String:Any]
         
         indexReference.setData(careerStatsObject)
     }
     */

}
