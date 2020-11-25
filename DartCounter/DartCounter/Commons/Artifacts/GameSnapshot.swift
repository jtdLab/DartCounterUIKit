//
//  GameSnapshot.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import Foundation

class GameSnapshot: Codable  {
    
    let status :GameStatus
    let descr :String
    let players  :[PlayerSnapshot]
    
    private enum CodingKeys: String, CodingKey {
        case status
        case description
        case players
    }
    
    init(status :GameStatus, description :String, players: [PlayerSnapshot]) {
        self.status = status
        self.descr = description
        self.players = players
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = GameStatus(rawValue: try! container.decode(String.self, forKey: .status).uppercased())!
        self.descr = try container.decode(String.self, forKey: .description)
        self.players = try container.decode([PlayerSnapshot].self, forKey: .players)
    }
   
    func encode(to encoder: Encoder) throws {
       var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status.rawValue.lowercased(), forKey: .status)
       try container.encode(descr, forKey: .description)
       try container.encode(players, forKey: .players)
   }
    
    /**
     
     func getCurrentTurn() -> PlayerSnapshot? {
         for player in players {
             if(player.isNext!) {
                 return player
             }
         }
         return nil
     }
     */
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
