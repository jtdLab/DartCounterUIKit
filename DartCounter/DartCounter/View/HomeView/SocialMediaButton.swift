//
//  SocialMediaButton.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 13.12.20.
//

import UIKit

@IBDesignable
class SocialMediaButton: UIView, NibLoadable {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
       didSet {
           layer.cornerRadius = cornerRadius
           layer.masksToBounds = cornerRadius > 0
       }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
}
