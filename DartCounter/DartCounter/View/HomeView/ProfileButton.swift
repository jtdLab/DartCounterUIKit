//
//  ProfileButtonView.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 12.12.20.
//

import UIKit

@IBDesignable
class ProfileButton: UIView, NibLoadable {

    @IBOutlet private weak var profilePictureImageView: UIImageView!
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var averageLabel: UILabel!
    @IBOutlet private weak var checkoutLabel: UILabel!
    @IBOutlet private weak var winsLabel: UILabel!
    @IBOutlet private weak var defeatLabel: UILabel!
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
       didSet {
           layer.cornerRadius = cornerRadius
           layer.masksToBounds = cornerRadius > 0
       }
    }
    
    // init for interfacebuilder
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
        
        // rounded image in profileButton
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.height/2
        profilePictureImageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
        
        // rounded image in profileButton
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.height/2
        profilePictureImageView.clipsToBounds = true
    }
    
    func setProfilePicture(image: UIImage?) {
        guard let image = image else { return }
        
        profilePictureImageView.image = image
    }
    
    func setName(name: String) {
        nameLabel.text = name
    }
    
    func setAverage(average: String) {
        averageLabel.text = average
    }
    
    func setCheckout(checkout: String) {
        checkoutLabel.text = checkout
    }
    
    func setWins(wins: String) {
        winsLabel.text = wins
    }
    
    func setDefeats(defeats: String) {
        defeatLabel.text = defeats
    }
    
}
