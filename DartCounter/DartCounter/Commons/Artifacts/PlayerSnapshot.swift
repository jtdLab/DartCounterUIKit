//
//  PlayerSnapshot.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import Foundation

class PlayerSnapshot {
    
    let name: String?
    
    let isNext: Bool?
    
    let lastThrow :Int?
    let pointsLeft :Int?
    let dartsThrown :Int?
    
    let sets :Int?
    let legs :Int?
    
    let average :String?
    let checkoutPercentage :String?
    
    init(player :Player) {
        name = player.name
        isNext = player.isNext
        lastThrow = player.lastThrow
        pointsLeft = player.pointsLeft
        dartsThrown = player.dartsThrown
        sets = player.sets
        legs = player.legs
        average = player.average
        checkoutPercentage = player.checkoutPercentage
    }
    
}

extension PlayerSnapshot: CustomStringConvertible {
    public var description: String {
        return "{" + "\n" +
            "name: " + name! + "\n" +
            "isNext: " + String(isNext ?? false) + "\n" +
            "lastThrow: " + String(lastThrow ?? -1) + "\n" +
            "pointsLeft: " + String(pointsLeft ?? -1) + "\n" +
            "dartsThrown: " + String(dartsThrown ?? -1) + "\n" +
            "sets: " + String(sets ?? -1) + "\n" +
            "legs: " + String(legs ?? -1) + "\n" +
            "average: " + average! + "\n" +
            "checkoutPercentage: " + checkoutPercentage! + "\n" +
            "}"
    }
}

extension PlayerSnapshot: Equatable {
    static func == (lhs: PlayerSnapshot, rhs: PlayerSnapshot) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.isNext == rhs.isNext &&
            lhs.lastThrow == rhs.lastThrow &&
            lhs.pointsLeft == rhs.pointsLeft &&
            lhs.dartsThrown == rhs.dartsThrown &&
            lhs.sets == rhs.sets &&
            lhs.legs == rhs.legs &&
            lhs.average == rhs.average &&
            lhs.checkoutPercentage == rhs.checkoutPercentage
    }
}
