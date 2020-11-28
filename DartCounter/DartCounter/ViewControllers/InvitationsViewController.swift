//
//  InvitationsViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 26.11.20.
//

import UIKit

class InvitationsViewController: UIViewController {

    @IBOutlet weak var invitationdTableView: UITableView!
    var items = ["ONLINE SPIELER 1", "ONLINE SPIELER 2"]

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        invitationdTableView.dataSource = self
        invitationdTableView.delegate = self
        invitationdTableView.isScrollEnabled = false
    }


}

extension InvitationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvitationCell", for: indexPath) as! InvitationCell
        cell.nameLabel.text = items[indexPath.row]
        return cell
    }
}
