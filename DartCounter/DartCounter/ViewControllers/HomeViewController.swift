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
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var checkoutLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var defeatsLabel: UILabel!
    
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.Home_CreateOnlineGame, let viewController = segue.destination as? CreateOnlineGameViewController {
            // TODO
        } else if segue.identifier == Segues.Home_CreateOfflineGame, let viewController = segue.destination as? CreateOfflineGameViewController {
            App.game = Game(player: Player(name: UserService.currentProfile!.username))
        }
    }
    

    private func initView() {
        let sideMenuController = SideMenuController()
        sideMenuController.delegate = self
        
        sideMenu = SideMenuNavigationController(rootViewController: sideMenuController)
        sideMenu?.leftSide = true
        sideMenu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
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
        
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.height/2
        profilePictureImageView.clipsToBounds = true
        
        UserService.observeUserProfile(completion: { userProfile in
            guard let profile = userProfile else { return }
            
            self.usernameLabel.text = profile.username
           
            if let photURL = profile.photoURL {
                UserService.getProfilePicture(withURL: photURL, completion: { profileImage in
                     self.profilePictureImageView.image = profileImage
                 })
            } else {
                self.profilePictureImageView.image = UIImage(named: "profile")
            }
        })
        
        UserService.observeCareerStats(completion: { careerStatsObject in
            guard let stats = careerStatsObject else { return }
            
            self.averageLabel.text = String(stats.average)
            self.checkoutLabel.text = String(stats.checkoutPerentage)
            self.winsLabel.text = String(stats.wins)
            self.defeatsLabel.text = String(stats.defeats)
        })
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

extension HomeViewController: SideMenuControllerDelegate {
    
    func onClick(index: Int) {
        sideMenu?.dismiss(animated: false, completion: {
            if index == 0 {
                self.performSegue(withIdentifier: Segues.Home_Profile, sender: self)
            } else if index == 1 {
                self.performSegue(withIdentifier: Segues.Home_Invitations, sender: self)
            } else if index == 2 {
                self.performSegue(withIdentifier: Segues.Home_Friends, sender: self)
            } else if index == 3 {
                self.performSegue(withIdentifier: Segues.Home_Settings, sender: self)
            } else if index == 4 {
                self.performSegue(withIdentifier: Segues.Home_AboutUs, sender: self)
            } else if index == 5 {
                AuthService.shared.signOut()
            }
        })
    }
    
}


// Contains UserEventHandling
extension HomeViewController {
    
    @objc func onProfile() {
        self.performSegue(withIdentifier: Segues.Home_Profile, sender: self)
    }
    
    @objc func onOnline() {
        self.performSegue(withIdentifier: Segues.Home_CreateOnlineGame, sender: self)
    }
    
    @objc func onOffline() {
        self.performSegue(withIdentifier: Segues.Home_CreateOfflineGame, sender: self)
    }
    
    @objc func onSocialMedia() {
        // TODO
    }
    
    @objc func onSettings() {
        self.performSegue(withIdentifier: Segues.Home_Settings, sender: self)
    }
    
}

protocol SideMenuControllerDelegate {
    
    func onClick(index: Int)
    
}

class SideMenuController: UITableViewController {
    
    var delegate: SideMenuControllerDelegate?
    
    var items = [("user", "PROFIL"), ("invite", "EINLADUNGEN"), ("friends", "FREUNDE"), ("settings-1", "EINSTELLUNGEN"), ("info", "SONSTIGES"), ("logout", "AUSLOGGEN"),]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SideMenuItemCell", bundle: nil), forCellReuseIdentifier: "SideMenuItemCell")
        
        tableView.register(UINib(nibName: "SideMenuHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "SideMenuHeader")
        
        tableView.backgroundColor = .black

    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 400
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "SideMenuHeader" ) as! SideMenuHeader
        
        var backgroundConfig = UIBackgroundConfiguration.listPlainHeaderFooter()
        backgroundConfig.backgroundColor = .black
        headerView.backgroundConfiguration = backgroundConfig

        return headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuItemCell", for: indexPath) as! SideMenuItemCell
        cell.iconImageView.image = UIImage(named: items[indexPath.row].0)
        cell.titleLabel.text = items[indexPath.row].1
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.onClick(index: indexPath.row)
    }

}
