//
//  Player.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import Foundation

class Player {
    
    var name: String
    
    var isNext: Bool?
    
    var lastThrow :Int?
    var pointsLeft :Int?
    var dartsThrown :Int?
    
    var sets :Int?
    var legs :Int?
    
    var average :String?
    var checkoutPercentage :String?
    
    init(name: String) {
        self.name = name
        self.isNext = false
    }
    
    func getSnapshot() -> PlayerSnapshot {
        return PlayerSnapshot(player: self)
    }
}

extension Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return
            lhs.name == rhs.name
    }
}
