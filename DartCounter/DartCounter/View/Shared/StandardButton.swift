//
//  StandardButton.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 16.12.20.
//

import UIKit

@IBDesignable
class StandardButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 25 {
       didSet {
           layer.cornerRadius = cornerRadius
           layer.masksToBounds = cornerRadius > 0
       }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
