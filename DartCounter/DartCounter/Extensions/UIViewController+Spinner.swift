//
//  UIViewController+Spinner.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 04.12.20.
//

import Foundation
import UIKit

fileprivate var aView: UIView?

extension UIViewController {
    
    func showSpinner() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.8)
        
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator.center = aView!.center
        activityIndicator.startAnimating()
        aView?.addSubview(activityIndicator)
        self.view.addSubview(aView!)
        
        // TODO add timeout
    }
    
    func removeSpinner() {
        aView?.removeFromSuperview()
        aView = nil
    }
    
}
