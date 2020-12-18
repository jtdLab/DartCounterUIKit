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
    var snapshot: GameSnapshot?
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var profileButton: ProfileButton!
    @IBOutlet weak var playOfflineButton: PlayOfflineButton!
    @IBOutlet weak var socialMediaButton: SocialMediaButton!
    @IBOutlet weak var settingsButton: SettingsButton!
    @IBOutlet weak var playOnlineButton: PlayOnlineButton!
    
    
    @IBAction func onSideMenu(_ sender: UIBarButtonItem) {
        // show the sidemenu
        present(sideMenu!, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set navbar title
        self.navigationItem.title = "Home"
        
        // setup sidemenu
        let sideMenuController = SideMenuController()
        sideMenuController.delegate = self
        
        sideMenu = SideMenuNavigationController(rootViewController: sideMenuController)
        sideMenu?.leftSide = true
        sideMenu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        UserService.delegate = self
        if UserService.currentProfile != nil {
            self.onProfileChanged(profile: UserService.currentProfile!)
        }
        
        // add on click to buttons
        let profileTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.onProfile))
        profileButton.addGestureRecognizer(profileTapGesture)
        
        let offlineTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.onPlayOffline))
        playOfflineButton.addGestureRecognizer(offlineTapGesture)
        
        let onlineTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.onPlayOnline))
        playOnlineButton.addGestureRecognizer(onlineTapGesture)
        
        let socialMediaTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.onSocialMedia))
        socialMediaButton.addGestureRecognizer(socialMediaTapGesture)
        
        let settingsTapGesture = UITapGestureRecognizer(target:self,action:#selector(self.onSettings))
        settingsButton.addGestureRecognizer(settingsTapGesture)
        
        // observe changes of invitations
        UserService.observeInvitations(completion: { invitations in
            // TODO set number of sidemenu
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let userProfile = UserService.currentProfile else { return }
        onProfileChanged(profile: userProfile)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.Home_CreateGame_offline, let destinationViewController = segue.destination as? CreateGameViewController {
            // init CreateGameViewController
            destinationViewController.online = false
            destinationViewController.snapshot = self.snapshot
        } else if segue.identifier == Segues.Home_CreateGame_online, let destinationViewController = segue.destination as? CreateGameViewController {
            // init CreateGameViewController
            destinationViewController.online = true
            destinationViewController.snapshot = self.snapshot
        }
    }
    
    @objc func onProfile() {
        // go to ProfileView
        self.performSegue(withIdentifier: Segues.Home_Profile, sender: self)
    }
    
    @objc func onPlayOffline() {
        // subscribe to PlayOnlineService to receive events
        PlayOfflineService.delegate = self
        // try to create an offline game
        PlayOfflineService.createGame()
    }
    
    @objc func onPlayOnline() {
        //showSpinner()
  
        // subscribe to PlayOnlineService to receive events
        PlayOnlineService.delegate = self
        // try to connect to PlayOnlineService -> if successful PlayOnlineServiceDelegate onConnect will fire
        if PlayOnlineService.isConnected {
            PlayOnlineService.createGame()
        } else {
            PlayOnlineService.connect()
        }
        
    }
    
    @objc func onSocialMedia() {
        // TODO
    }
    
    @objc func onSettings() {
        // go to SettingsView
        self.performSegue(withIdentifier: Segues.Home_Settings, sender: self)
    }
    
}


// handle events from UserService
extension HomeViewController: UserServiceDelegate {
    
    func onProfileChanged(profile: UserProfile) {
        //let sideMenuController = sideMenu?.viewControllers[0] as! SideMenuController
        //let sideMenuHeader = sideMenuController.tableView.headerView(forSection: 0) as! SideMenuHeader
        
        // display username in profileButton
        self.profileButton.setName(name: profile.username)
        // display username in sidemenu
        //sideMenuHeader.setName(name: profile.username)
       
        if let photURL = profile.photoURL {
            UserService.getProfilePicture(withURL: photURL, completion: { profileImage in
                // display profilePicture in profileButton
                self.profileButton.setProfilePicture(image: profileImage)
                // display profilePicture in sidemenu
                //sideMenuHeader.setProfilePicture(image: profileImage)
             })
        } else {
            // display a placeholder if no profilePicture available in profileButton
            self.profileButton.setProfilePicture(image: UIImage(named: "profile"))
            // display a placeholder if no profilePicture available in sidemenu
            //sideMenuHeader.setProfilePicture(image: UIImage(named: "profile"))
        }
        
    }
    
    func onCareerStatsChanged(stats: CareerStats) {
        // display career stats in profileButton
        self.profileButton.setAverage(average: stats.average)
        self.profileButton.setCheckout(checkout: stats.checkoutPerentage)
        self.profileButton.setWins(wins: stats.wins)
        self.profileButton.setDefeats(defeats: stats.defeats)
    }

}

// handle events from PlayOfflineService
extension HomeViewController: PlayOfflineServiceDelegate {
    
    func onSnapshot(snapshot: GameSnapshot) {
        self.snapshot = snapshot
        self.performSegue(withIdentifier: Segues.Home_CreateGame_offline, sender: self)
    }
    
}


// handle events from PlayOnlineService
extension HomeViewController: PlayOnlineServiceDelegate {
    
    func onConnect(successful: Bool) {
        successful ? print("Connected to PlayOnlineService") : print("Couldn't connect to PlayOnlineService")
        if successful {
            PlayOnlineService.createGame()
        }
    }
    
    func onCreateGameResponse(successful: Bool, snapshot: GameSnapshot) {
        successful ? print("Created game") : print("Couldn't create game")
        if successful {
            self.snapshot = snapshot
            self.performSegue(withIdentifier: Segues.Home_CreateGame_online, sender: self)
        }
    }
    
}


// handle events from sidemenu
extension HomeViewController: SideMenuControllerDelegate {
    
    func onItemClicked(index: Int) {
        // TODO
        // close the sidemenu and perform action depending on the item clicked
        sideMenu?.dismiss(animated: false, completion: {
            if index == 0 {
                // go to HomeView
                self.performSegue(withIdentifier: Segues.Home_Profile, sender: self)
            } else if index == 1 {
                // go to InvitationsView
                self.performSegue(withIdentifier: Segues.Home_Invitations, sender: self)
            } else if index == 2 {
                // go to FriendsView
                self.performSegue(withIdentifier: Segues.Home_Friends, sender: self)
            } else if index == 3 {
                // go to SettingsView
                self.performSegue(withIdentifier: Segues.Home_Settings, sender: self)
            } else if index == 4 {
                // go to AboutUsView
                self.performSegue(withIdentifier: Segues.Home_AboutUs, sender: self)
            } else if index == 5 {
                // log out 
                AuthService.signOut()
            }
        })
    }
    
}

// sidemenu delegate
protocol SideMenuControllerDelegate {
    
    func onItemClicked(index: Int)
    
}

// the sidemenu is reperesentated by a customized tableview with one section (one section contains one header and n rows)
// the header is a customized view representing the top part of sidemenu
// one row represents one sidemenu item which is part of the bottom part of the sidemenu
class SideMenuController: UITableViewController {
    
    var delegate: SideMenuControllerDelegate?
    
    // sidemenu item content: tuples of (icon_asset_name, title)
    var items = [("user", "PROFIL"), ("invite", "EINLADUNGEN"), ("friends", "FREUNDE"), ("settings-1", "EINSTELLUNGEN"), ("info", "SONSTIGES"), ("logout", "AUSLOGGEN")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // register cells of sidemenu
        tableView.register(UINib(nibName: "SideMenuHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "SideMenuHeader")
        tableView.register(UINib(nibName: "SideMenuItemCell", bundle: nil), forCellReuseIdentifier: "SideMenuItemCell")
        
        // set sidemenu background color to black
        tableView.backgroundColor = .black
        
        tableView.isScrollEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // specify height of header
        return 400
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // specify view of header
        let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "SideMenuHeader" ) as! SideMenuHeader
        
        // set backround color of header to black
        var backgroundConfig = UIBackgroundConfiguration.listPlainHeaderFooter()
        backgroundConfig.backgroundColor = .black
        headerView.backgroundConfiguration = backgroundConfig

        
        guard let profile = UserService.currentProfile else { return headerView }
        headerView.setName(name: profile.username)
        
        guard let url = profile.photoURL else { return headerView }
        UserService.getProfilePicture(withURL: url, completion: { profileImage in
            headerView.setProfilePicture(image: profileImage)
        })
        
        return headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // specify number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // specify number of sidemenu items
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // specify view of sidemenu item
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuItemCell", for: indexPath) as! SideMenuItemCell
        // set icon sidemenu item
        cell.imageView_icon.image = UIImage(named: items[indexPath.row].0)
        // set title of sidemenu item
        cell.label_title.text = items[indexPath.row].1
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // call delegate if item gets selected/clicked
        delegate?.onItemClicked(index: indexPath.row)
    }

}
