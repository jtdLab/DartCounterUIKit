//
//  Throw.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import Foundation

class Throw {
    
    var points :Int
    var dartsOnDouble :Int
    var dartsThrown :Int
    var playerIndex :Int?
    
    init(points :Int, dartsOnDouble :Int, dartsThrown :Int) {
        self.points = points
        self.dartsOnDouble = dartsOnDouble
        self.dartsThrown = dartsThrown
    }
    
}

extension Throw: Equatable {
    static func == (lhs: Throw, rhs: Throw) -> Bool {
        return
            lhs.points == rhs.points &&
            lhs.dartsOnDouble == rhs.dartsOnDouble &&
            lhs.dartsThrown == rhs.dartsThrown &&
            lhs.playerIndex == rhs.playerIndex
    }
}
