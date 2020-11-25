//
//  HomeViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import UIKit

class HomeViewController: UIViewController {
    
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
        
        PlayService.delegate = self
        PlayService.connect()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.Home_CreateOnlineGame, let viewController = segue.destination as? CreateOnlineGameViewController {
            // TODO
        } else if segue.identifier == Segues.Home_CreateOfflineGame, let viewController = segue.destination as? CreateOfflineGameViewController {
            App.game = Game(player: Player(name: App.user!.username))
        }
    }

}

extension HomeViewController: PlayServiceDelegate {
    
    func onAuthResponse(authResponse: AuthResponsePacket) {
        authResponse.successful ? print("Joined server") : print("Couldn't join server")
    }
    
    func onCreateGameResponse(createGameResponse: CreateGameResponsePacket) {
        createGameResponse.successful ? print("Created game") : print("Couldn't create game")
    }
    
    func onJoinGameResponse(joinGameResponse: JoinGameResponsePacket) {
        joinGameResponse.successful ? print("Joined game") : print("Couldn't join game")
    }
    
    func onGameCanceled(gameCanceled: GameCanceledPacket) {
        print("Game canceled")
    }
    
    func onGameStarted(gameStarted: GameStartedPacket) {
        print("Game started")
    }
    
    func onSnapshot(snapshot: SnapshotPacket) {
        print(snapshot.snapshot.description)
    }
    
    func onPlayerExited(playerExited: PlayerExitedPacket) {
        print(playerExited.username + " exited the game")
    }
    
    func onPlayerJoined(playerJoined: PlayerJoinedPacket) {
        print(playerJoined.username + " joined the game")
    }
    
}

extension HomeViewController {
    
    @objc func onProfile() {

    }
    
    @objc func onOnline() {
        PlayService.createGame()
        self.performSegue(withIdentifier: Segues.Home_CreateOnlineGame, sender: self)
    }
    
    @objc func onOffline() {
        self.performSegue(withIdentifier: Segues.Home_CreateOfflineGame, sender: self)
    }
    
    @objc func onSocialMedia() {
     
    }
    
    @objc func onSettings() {
     
    }
    
}
