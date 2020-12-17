//
//  InvitationsViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 26.11.20.
//

import UIKit

class InvitationsViewController: UIViewController {

    @IBOutlet weak var invitationsTableView: UITableView!
    
    var snapshot: GameSnapshot?
    
    var invitations: [Invitation]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register InvitationCell to InvitationsTable
        invitationsTableView.register(UINib(nibName: "InvitationCell", bundle: nil), forCellReuseIdentifier: "InvitationCell")
        
        invitationsTableView.dataSource = self
        invitationsTableView.delegate = self
        invitationsTableView.isScrollEnabled = false
        
        PlayOnlineService.delegate = self
        PlayOnlineService.connect()
        // TODO
        
        UserService.observeInvitations(completion: { invitationsObject in
            guard let invitations = invitationsObject else { return }
            
            self.invitations = invitations
            self.invitationsTableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.Invitations_CreateGame, let destinationViewController = segue.destination as? CreateGameViewController {
            // init CreateGameViewController
            destinationViewController.online = true
            destinationViewController.snapshot = self.snapshot
        }
    }

}

// handle events from PlayOnlineService
extension InvitationsViewController: PlayOnlineServiceDelegate {
    
    func onSnapshot(snapshot: GameSnapshot) {
        self.snapshot = snapshot
        if snapshot.status == .PENDING {
            performSegue(withIdentifier: Segues.Invitations_CreateGame, sender: self)
        }
    }
    
}

extension InvitationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvitationCell", for: indexPath) as! InvitationCell
        
        cell.label_name.text = invitations![indexPath.row].inviter
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let invitations = self.invitations else { return }
        let gameCode = invitations[indexPath.row].gameCode
        
        PlayOnlineService.joinGame(gameCode: gameCode)
    }
}
