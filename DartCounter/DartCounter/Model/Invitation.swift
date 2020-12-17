//
//  Invitation.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 16.12.20.
//

import Foundation

class Invitation {
    
    var inviter: String
    var gameCode: Int
    
    
    init(inviter: String, gameCode: Int) {
        self.inviter = inviter
        self.gameCode = gameCode
    }
    
    var dict: [String:Any] {
        return [
            "inviter": inviter,
            "gameCode": gameCode,
        ]
    }
    
    static func fromDict(dict: [String:Any]) -> Invitation? {
        if let i = dict["inviter"] as? String,
           let g = dict["gameCode"] as? Int {
            return Invitation(inviter: i, gameCode: g)
        }
        return nil
    }
    
}
