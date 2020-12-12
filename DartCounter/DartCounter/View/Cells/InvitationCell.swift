//
//  InvitationCell.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 28.11.20.
//

import UIKit

class InvitationCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBAction func onAccept(_ sender: UIButton) {
        PlayOnlineService.joinGame(gameCode: 1000)
    }
    
    @IBAction func onDecline(_ sender: UIButton) {
    }
}
extension InvitationCell: PlayOnlineServiceDelegate {
    
    func onJoinGameResponse(successful: Bool, snapshot: GameSnapshot) {
        successful ? print("Joined game") : print("Couldn't join game")
        if successful {
            // go to IngameView
            // TODO
        }
    }
    
}
