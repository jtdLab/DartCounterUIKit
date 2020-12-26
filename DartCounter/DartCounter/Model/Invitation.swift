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
    
    init(dict: [String:Any]) throws {
        if let i = dict["inviter"] as? String,
           let g = dict["gameCode"] as? Int {
            self.inviter = i
            self.gameCode = g
            return
        }
        
        throw Errors.GeneralError.initError("Can't construct Invitation from given dict")
    }
    
    init(inviter: String, gameCode: Int) {
        self.inviter = inviter
        self.gameCode = gameCode
    }
    
    init() {
        self.inviter = "TEST"
        self.gameCode = 8888
    }
    
    var dict: [String:Any] {
        return [
            "inviter": inviter,
            "gameCode": gameCode,
        ]
    }
    
    
}
