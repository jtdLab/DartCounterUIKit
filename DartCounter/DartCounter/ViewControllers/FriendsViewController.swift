//
//  FriendsViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 26.11.20.
//

import UIKit

class FriendsViewController: UIViewController {
    
    @IBOutlet weak var friendsTableView: UITableView!
    var items = ["ONLINE SPIELER 1", "ONLINE SPIELER 2"]

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        friendsTableView.isScrollEnabled = false
    }

}


extension FriendsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        cell.nameLabel.text = items[indexPath.row]
        return cell
    }
}

