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

class UserService {
    
    static var currentProfile: UserProfile?
    
    static func observeUserProfile(completion: @escaping ((_ userProfile: UserProfile?) ->())) {
        guard let uid = currentProfile?.uid else { return }
        
        let userReference = Database.database().reference().child("/users/profile/\(uid)")
        
        userReference.observe(.value, with: { snapshot in
            var userProfile: UserProfile?
            
            if let dict = snapshot.value as? [String:Any] {
                userProfile = UserProfile.fromDict(uid: uid, dict: dict)
            }
            
            completion(userProfile)
        })
    }
    
    
    static func observeCareerStats(completion: @escaping ((_ careerStats: CareerStats?) ->())) {
        guard let uid = currentProfile?.uid else { return }
        
        let userReference = Database.database().reference().child("/users/careerStats/\(uid)")
        
        userReference.observe(.value, with: { snapshot in
            var careerStats: CareerStats?
            
            if let dict = snapshot.value as? [String:Any] {
                careerStats = CareerStats.fromDict(dict: dict)
            }
            
            completion(careerStats)
        })
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
