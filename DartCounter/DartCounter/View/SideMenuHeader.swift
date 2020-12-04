//
//  SideMenuHeader.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 29.11.20.
//

import UIKit

class SideMenuHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func didMoveToSuperview() {
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.height/2
        profilePictureImageView.clipsToBounds = true
        
        UserService.observeUserProfile(completion: { userProfile in
            guard let profile = userProfile else { return }
           
            self.usernameLabel.text = profile.username
            
            if let photURL = profile.photoURL {
                UserService.getProfilePicture(withURL: photURL, completion: { profileImage in
                     self.profilePictureImageView.image = profileImage
                 })
            } else {
                self.profilePictureImageView.image = UIImage(named: "profile")
            }
        })
    }
    
}
