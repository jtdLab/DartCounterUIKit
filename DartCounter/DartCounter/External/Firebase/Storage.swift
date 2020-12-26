//
//  Storage.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 25.12.20.
//

import Foundation
import Firebase

// Bridge to Storage (Firebase)
class Storage {
    
    static let imageCache = NSCache<NSString, UIImage>()
    
    static func updateProfileImage(_ image: UIImage, completion: @escaping (_ success: Bool) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let storageReference = Firebase.Storage.storage().reference().child("user/\(uid)")
        
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
                                imageCache.setObject(image, forKey: url!.absoluteString as NSString)
                                
                                let databaseReference = Database.database().reference().child("users/\(uid)/profile/photoURL").setValue(url?.absoluteString)
                            }
                        }
                    }
                })
            }
        }
    }
    
    static func downloadProfileImage(withURL url:URL, completion: @escaping (_ image: UIImage?) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, responseUrl, error in
            var downloadedImage: UIImage?
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            if downloadedImage != nil {
                imageCache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        dataTask.resume()
    }

    
}
