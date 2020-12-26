//
//  UserService.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 04.12.20.
//

import Foundation
import UIKit

protocol UserServiceDelegate {
    
    func onUserChanged(user: User)
    
}

extension UserServiceDelegate {
    
    func onUserChanged(user: User) {}
    
}

class UserService {
    
    static var delegate: UserServiceDelegate?
    
    static private(set) var user: User?
    
    static func initUser(user: User) {
        self.user = user
    }
    
    static func removeUser() {
        user = nil
    }
    
    
    static func observeUser(uid: String) {
        RealtimeDatabase.observeUser(uid: uid, onChanged: { user in
            self.user = user
            delegate?.onUserChanged(user: user)
        })
    }
    
    static func observeInvitations(completion: @escaping (_ invitations: [Invitation]) -> Void) throws {
        guard let user = user else { throw Errors.UserServiceError.userNilError("UserSerice.user was nil - This mostly happens when observeInvitations() gets called before initUser()") }
        
        RealtimeDatabase.observeInvitations(uid: user.uid, onChanged: { invitations in
            completion(invitations)
        })
    }
    
   /**
     static func observeInvitations(completion: @escaping ((_ invitations: [Invitation]?) ->())) {
         guard let uid = currentProfile?.uid else { return }
         
         let invitationsReference = Firestore.firestore().collection("users").document(uid)
         
         invitationsReference
             .addSnapshotListener { documentSnapshot, error in
                 guard let document = documentSnapshot else {
                   print("Error fetching document: \(error!)")
                   return
                 }
               
                 guard let data = document.data() else {
                   print("Document data was empty.")
                   return
                 }
                 
                 var invitations: [Invitation]?
                 
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
             }
     }
     
     */
    
    static func updateProfileImage(_ image: UIImage, completion: @escaping (_ success: Bool) ->()) {
        Storage.updateProfileImage(image, completion: completion)
    }
    
    
    static func getProfilePicture(withURL url:URL, completion: @escaping (_ image: UIImage?) ->()) {
        if let image = Storage.imageCache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        } else {
            Storage.downloadProfileImage(withURL: url, completion: completion)
        }
    }
    
}
