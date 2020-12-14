//
//  HomeButton.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 12.12.20.
//

import UIKit

class HomeButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let view = ProfileButtonView()
        addSubview(view)
        
    }
    
   
    
}

