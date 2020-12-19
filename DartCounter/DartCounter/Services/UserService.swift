//
//  UserService.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 04.12.20.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

protocol UserServiceDelegate {
    
    func onProfileChanged(profile: UserProfile)
    
    func onCareerStatsChanged(stats: CareerStats)
    
}

extension UserServiceDelegate {
    
    func onProfileChanged(profile: UserProfile) {}
    
    func onCareerStatsChanged(stats: CareerStats) {}
    
}

class UserService {
    
    static var delegate: UserServiceDelegate?
    
    static var currentProfile: UserProfile?
    static var currentCareerStats: CareerStats?
    
    
    static func observeUserProfile(uid: String) {
        let userReference = Database.database().reference().child("/users/\(uid)/profile")
        
        userReference.observe(.value, with: { snapshot in
            var userProfile: UserProfile?
            
            if let dict = snapshot.value as? [String:Any] {
                userProfile = UserProfile.fromDict(uid: uid, dict: dict)
            }
            
            if userProfile != nil {
                currentProfile = userProfile
                delegate?.onProfileChanged(profile: userProfile!)
            }
            
        })
    }
    
    
    static func observeCareerStats(uid: String) {
        let userReference = Database.database().reference().child("/users/\(uid)/careerStats")
        
        userReference.observe(.value, with: { snapshot in
            var careerStats: CareerStats?
            
            if let dict = snapshot.value as? [String:Any] {
                careerStats = CareerStats.fromDict(dict: dict)
            }
            
            if careerStats != nil {
                delegate?.onCareerStatsChanged(stats: careerStats!)
                currentCareerStats = careerStats
            }
            
        })
    }
    
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
    
    
    static func updateProfileImage(_ image: UIImage, completion: @escaping (_ success: Bool) ->()) {
        DatabaseService.updateProfileImage(image, completion: completion)
    }
    
    
    static func getProfilePicture(withURL url:URL, completion: @escaping (_ image: UIImage?) ->()) {
        if let image = DatabaseService.profileImageCache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        } else {
            DatabaseService.downloadProfileImage(withURL: url, completion: completion)
        }
    }
    
}
