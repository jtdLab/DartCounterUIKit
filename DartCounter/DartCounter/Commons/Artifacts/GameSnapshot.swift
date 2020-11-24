//
//  GameSnapshot.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import Foundation

class GameSnapshot  {
    
    let status :GameStatus
    
    let descr :String
    
    let players  :[PlayerSnapshot]
    
    init(status :GameStatus, description :String, players: [PlayerSnapshot]) {
        self.status = status
        self.descr = description
        self.players = players
    }
}

extension GameSnapshot: CustomStringConvertible {
    public var description: String {
        var statusString = "pending"
        if status == .RUNNING {
            statusString = "running"
        } else {
            statusString = "finished"
        }
        
        var playerString = ""
        
        players.forEach({ playerSnapshot in
            playerString += playerSnapshot.description  + "\n"
        })
        
        return statusString + "\n" + descr  + "\n" + playerString
    }
}

extension GameSnapshot: Equatable {
    static func == (lhs: GameSnapshot, rhs: GameSnapshot) -> Bool {
        return
            lhs.status == rhs.status &&
            lhs.description == rhs.description &&
            lhs.players == rhs.players
    }
}
