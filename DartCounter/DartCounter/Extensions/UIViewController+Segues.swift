//
//  UIViewController+Segues.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 24.11.20.
//

import Foundation
import UIKit

extension UIViewController {
    
    enum Segues {
        static let SignIn_SignUp = "SignIn_SignUp"
        //static let SignUp_SignIn = "SignUp_SignIn"
        static let SignIn_Home = "SignIn_Home"
        static let SignUp_Home = "SignUp_Home"
        static let Home_CreateOnlineGame = "Home_CreateOnlineGame"
        static let Home_CreateOfflineGame = "Home_CreateOfflineGame"
        static let Home_Profile = "Home_Profile"
        static let Home_Invitations = "Home_Invitations"
        static let Home_Friends = "Home_Friends"
        static let Home_Settings = "Home_Settings"
        static let Home_AboutUs = "Home_AboutUs"
        static let CreateOnlineGame_InGame = "CreateOnlineGame_InGame"
        static let CreateOfflineGame_InGame = "CreateOfflineGame_InGame"
        static let InGame_CheckoutDetails = "InGame_CheckoutDetails"
        static let InGame_Home = "InGame_Home"
        static let InGame_PostGame = "InGame_PostGame"
        static let PostGame_Home = "PostGame_Home"
        static let PostGame_Stats = "PostGame_Stats"
    }
}
