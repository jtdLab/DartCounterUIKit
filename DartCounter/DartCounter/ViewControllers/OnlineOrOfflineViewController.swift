//
//  OnlineOrOfflineViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import UIKit

class OnlineOrOfflineViewController: UIViewController {
    
    private enum Constants {
        static let OnOnlineCreateGameSegue = "onOnline_createGame"
        static let OnOfflineCreateGameSegue = "onOffline_createGame"
    }
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet weak var btn_Profile: UIView!
    
    @IBOutlet weak var btn_Online: UIView!
    
    @IBOutlet weak var btn_Offline: UIView!
    
    @IBOutlet weak var btn_SocialMedia: UIView!
    
    @IBOutlet weak var btn_Settings: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let profileTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.onProfile))
        btn_Profile.addGestureRecognizer(profileTapGesture)
        
        let onlineTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.onOnline))
        btn_Online.addGestureRecognizer(onlineTapGesture)
        
        let offlineTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.onOffline))
        btn_Offline.addGestureRecognizer(offlineTapGesture)
        
        let socialMediaTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.onSocialMedia))
        btn_SocialMedia.addGestureRecognizer(socialMediaTapGesture)
        
        let settingsTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.onSettings))
        btn_Settings.addGestureRecognizer(settingsTapGesture)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.OnOnlineCreateGameSegue, let viewController = segue.destination as? CreateOnlineGameViewController {
            // TODO
        } else if segue.identifier == Constants.OnOfflineCreateGameSegue, let viewController = segue.destination as? CreateOfflineGameViewController {
            App.game = Game(player: Player(name: App.user!.username))
        }
    }

}

extension OnlineOrOfflineViewController {
    
    @objc func onProfile() {

    }
    
    @objc func onOnline() {
        self.performSegue(withIdentifier: Constants.OnOnlineCreateGameSegue, sender: self)
    }
    
    @objc func onOffline() {
        self.performSegue(withIdentifier: Constants.OnOfflineCreateGameSegue, sender: self)
    }
    
    @objc func onSocialMedia() {
     
    }
    
    @objc func onSettings() {
     
    }
    
}
