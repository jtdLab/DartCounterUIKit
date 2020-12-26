//
//  FriendsViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 26.11.20.
//

import UIKit

class FriendsViewController: UIViewController {
    
    @IBOutlet weak var tableView_friends: ContentSizedTableView!
    var friends: [Friend]?
    
    @IBAction func onAddFriend(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Segues.Friends_SearchUser, sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register FriendCell to FriendsTable
        tableView_friends.register(UINib(nibName: "FriendCell", bundle: nil), forCellReuseIdentifier: "FriendCell")
        
        tableView_friends.dataSource = self
        tableView_friends.delegate = self
        tableView_friends.isScrollEnabled = false
        
        UserService.delegate = self
        
        guard let user = UserService.user else { return }
        onUserChanged(user: user)
    }

}


// handle events from UserService
extension FriendsViewController: UserServiceDelegate {
    
    func onUserChanged(user: User) {
        self.friends = user.friends
    
        tableView_friends.reloadData()
    }
    
}


extension FriendsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        cell.label_name.text = friends?[indexPath.row].profile.username
        return cell
    }
}

