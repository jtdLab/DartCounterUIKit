//
//  GameSnapshot.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import Foundation

class GameSnapshot: Codable  {
    
    let status :GameStatus
    let config :GameConfig
    let players :[PlayerSnapshot]
    
    var ownerUsername: String {
        return players[0].name!
    }
    
    private enum CodingKeys: String, CodingKey {
        case status
        case config
        case players
    }
    
    init(status :GameStatus, config :GameConfig, players: [PlayerSnapshot]) {
        self.status = status
        self.config = config
        self.players = players
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = GameStatus(rawValue: try! container.decode(String.self, forKey: .status).uppercased())!
        self.config = try container.decode(GameConfig.self, forKey: .config)
        self.players = try container.decode([PlayerSnapshot].self, forKey: .players)
    }
   
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status.rawValue.lowercased(), forKey: .status)
        try container.encode(config, forKey: .config)
        try container.encode(players, forKey: .players)
   }
    
    
    func getDescription() -> String {
        return (config.getModeAsString() + " " + String(config.size) + " " + config.getTypeAsString()).uppercased()
    }
    
    func getCurrentTurn() -> PlayerSnapshot? {
        for player in players {
            if(player.isNext!) {
                return player
            }
        }
        return nil
    }
    
    func getWinner() -> PlayerSnapshot? {
        if status == .CANCELLED {
            if config.type == .LEGS {
                let l = players.map { $0.legs! }
                let max = l.max()!
                let firstIndex = l.firstIndex(of: max)!
                let lastIndex = l.lastIndex(of: max)!
                
                if firstIndex == lastIndex {
                    // winner found
                    return players[lastIndex]
                } else {
                    // points left decide
                    var ps: PlayerSnapshot?
                    for p in players {
                        if p.legs == max {
                            if ps == nil {
                                ps = p
                                continue
                            }
                            
                            if p.pointsLeft! < ps!.pointsLeft! {
                                ps = p
                            }
                        }
                    }
                    return ps
                }
            } else {
                let s = players.map { $0.sets! }
                let sMax = s.max()!
                let firstIndex = s.firstIndex(of: sMax)!
                let lastIndex = s.lastIndex(of: sMax)!
                
                if firstIndex == lastIndex {
                    // winner found
                    return players[lastIndex]
                } else {
                    // legs decide
                    var ps: PlayerSnapshot?
                    for p in players {
                        if p.sets! == sMax {
                            if ps == nil {
                                ps = p
                                continue
                            }
                            
                            if p.legs! > ps!.legs! {
                                ps = p
                            } else if p.legs! == ps!.legs! {
                                if p.pointsLeft! < ps!.pointsLeft! {
                                    ps = p
                                }
                            }
                        }
                    }
                    return ps
                }
            }
        } else if status == .FINISHED {
            if config.type == .LEGS {
                for player in players {
                    if player.legs! == config.size {
                        return player
                    }
                }
            } else {
                for player in players {
                    if player.sets! == config.size {
                        return player
                    }
                }
            }
        }
        
        return nil
    }
    
}

extension GameSnapshot: CustomStringConvertible {
    public var description: String {
        var statusString: String
        
        if status == .PENDING {
            statusString = "running"
        } else if status == .RUNNING {
            statusString = "running"
        } else if status == .CANCELLED {
            statusString = "cancelled"
        } else {
            statusString = "finished"
        }
        
        var playerString = ""
        
        players.forEach({ playerSnapshot in
            playerString += playerSnapshot.description  + "\n"
        })
        
        return statusString + "\n" + config.getModeAsString() + String(config.size) + config.getTypeAsString()  + "\n" + playerString
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
