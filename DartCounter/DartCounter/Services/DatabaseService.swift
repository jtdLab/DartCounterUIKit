//
//  DatabaseService.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 04.12.20.
//

import Foundation
import Firebase
import FirebaseDatabase

class DatabaseService {
    
    static let profileImageCache = NSCache<NSString, UIImage>()
    
    static func createProfile(uid: String, username: String, onError: @escaping (NSError) -> Void) {
        
        let databaseReference = Database.database().reference().child("users/profile/\(uid)")
        
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
        let databaseReference = Database.database().reference().child("users/careerStats/\(uid)")
        
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
    
    static func updateProfileImage(_ image: UIImage, completion: @escaping (_ success: Bool) ->()) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let storageReference = Storage.storage().reference().child("user/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        storageReference.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil && metaData != nil {
                // success
                storageReference.downloadURL(completion: { url, error in
                    if error == nil && url != nil {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.photoURL = url
                        
                        changeRequest?.commitChanges { error in
                            if error == nil {
                                let databaseReference = Database.database().reference().child("users/profile/\(uid)/photoURL").setValue(url?.absoluteString)
                            }
                        }
                    }
                })
            }
        }
    }
    
    static func downloadProfileImage(withURL url:URL, completion: @escaping (_ image: UIImage?) ->()) {
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, responseUrl, error in
            var downloadedImage: UIImage?
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            if downloadedImage != nil {
                profileImageCache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        dataTask.resume()
    }

}
