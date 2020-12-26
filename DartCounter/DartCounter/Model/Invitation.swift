//
//  Invitation.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 16.12.20.
//

import Foundation

class Invitation {
    
    var inviterUid: String
    var inviterName: String
    var gameCode: Int
    
    init(inviterUid: String, dict: [String:Any]) throws {
        self.inviterUid = inviterUid
        if let iN = dict["inviterName"] as? String,
           let g = dict["gameCode"] as? Int {
            self.inviterName = iN
            self.gameCode = g
            return
        }
        
        throw Errors.GeneralError.initError("Can't construct Invitation from given dict")
    }
    
    init(inviterUid: String, inviterName: String, gameCode: Int) {
        self.inviterUid = inviterUid
        self.inviterName = inviterName
        self.gameCode = gameCode
    }
    
    init() {
        self.inviterUid = "TEST UID"
        self.inviterName = "TEST"
        self.gameCode = 8888
    }
    
    var dict: [String:Any] {
        return [
            "inviterUid": inviterUid,
            "inviterName": inviterName,
            "gameCode": gameCode,
        ]
    }
    
    
}
