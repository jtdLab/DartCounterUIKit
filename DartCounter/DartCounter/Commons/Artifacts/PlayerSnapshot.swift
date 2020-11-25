//
//  PlayerSnapshot.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import Foundation

class PlayerSnapshot: Codable {
    
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
        
        let tempIsNext = String(isNext ?? false)
        var tempLastThrow = String(lastThrow ?? -1)
        if tempLastThrow == "-1" {
            tempLastThrow = "-"
        }
        let tempPointsLeft = String(pointsLeft!)
        let tempDartsThrown = String(dartsThrown!)
        var tempSets = String(sets ?? -1)
        if tempSets == "-1" {
            tempSets = ""
        }
        let tempLegs = String(legs!)
        
        return "{" + "\n" +
            "name: " + name! + "\n" +
            "isNext: " + tempIsNext + "\n" +
            "lastThrow: " + tempLastThrow + "\n" +
            "pointsLeft: " + tempPointsLeft + "\n" +
            "dartsThrown: " + tempDartsThrown + "\n" +
            "sets: " + tempSets + "\n" +
            "legs: " + tempLegs + "\n" +
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
