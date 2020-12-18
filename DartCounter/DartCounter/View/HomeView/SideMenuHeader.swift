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
    }
    
    
    func setProfilePicture(image: UIImage?) {
        guard let image = image else { return }
        
        profilePictureImageView.image = image
    }
    
    func setName(name: String) {
        usernameLabel.text = name
    }
    
    
}


