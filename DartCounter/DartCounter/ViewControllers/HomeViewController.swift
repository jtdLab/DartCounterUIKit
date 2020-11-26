//
//  HomeViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController {
    
    var sideMenu: SideMenuNavigationController?
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var btn_Profile: UIView!
    @IBOutlet weak var btn_Online: UIView!
    @IBOutlet weak var btn_Offline: UIView!
    @IBOutlet weak var btn_SocialMedia: UIView!
    @IBOutlet weak var btn_Settings: UIView!
    
    
    @IBAction func onSideMenu(_ sender: UIBarButtonItem) {
        present(sideMenu!, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        sideMenu = SideMenuNavigationController(rootViewController: SideMenuController())
        sideMenu?.leftSide = true
        sideMenu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.Home_CreateOnlineGame, let viewController = segue.destination as? CreateOnlineGameViewController {
            // TODO
        } else if segue.identifier == Segues.Home_CreateOfflineGame, let viewController = segue.destination as? CreateOfflineGameViewController {
            App.game = Game(player: Player(name: App.user!.username))
        }
    }
    

    private func initView() {
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
        print("Snapshot")
    }
    
    func onPlayerExited(playerExited: PlayerExitedPacket) {
        print(playerExited.username + " exited the game")
    }
    
    func onPlayerJoined(playerJoined: PlayerJoinedPacket) {
        print(playerJoined.username + " joined the game")
    }
    
}



// Contains UserEventHandling
extension HomeViewController {
    
    @objc func onProfile() {

    }
    
    @objc func onOnline() {
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


class SideMenuController: UITableViewController {
    
    var sideMenuItems = [("user", "PROFIL"), ("invite", "EINLADUNGEN"), ("friends", "FREUNDE"), ("settings-1", "EINSTELLUNGEN"), ("info", "SONSTIGES"),]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SideMenuItemCell", bundle: nil), forCellReuseIdentifier: "SideMenuItemCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuItemCell", for: indexPath) as! SideMenuItemCell
        cell.iconImageView.image = UIImage(named: sideMenuItems[indexPath.row].0)
        cell.titleLabel.text = sideMenuItems[indexPath.row].1
        return cell
    }
}
