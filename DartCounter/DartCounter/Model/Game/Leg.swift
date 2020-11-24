//
//  Leg.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import Foundation

class Leg {
    
    var pointsLeft :[Int]
    var dartsThrown :[Int]
    var dartsOnDouble :[Int]
    var xThrows :[Throw]
    var startIndex :Int
    
    
    init(startIndex :Int, numberOfPlayers :Int, startingPoints :Int) {
        pointsLeft = [Int].init(repeating: startingPoints, count: numberOfPlayers)
        dartsThrown = [Int].init(repeating: 0, count: numberOfPlayers)
        dartsOnDouble = [Int].init(repeating: 0, count: numberOfPlayers)
        xThrows = [Throw]()
        self.startIndex = startIndex
    }
    
    func performThrow(t :Throw) {
        pointsLeft[t.playerIndex!] -= t.points
        dartsThrown[t.playerIndex!] += t.dartsThrown
        dartsOnDouble[t.playerIndex!] += t.dartsOnDouble
        xThrows.append(t)
    }
    
    func undoThrow() -> Throw? {
        if !xThrows.isEmpty {
            let last :Throw = xThrows[xThrows.count - 1]
            pointsLeft[last.playerIndex!] += last.points
            dartsThrown[last.playerIndex!] -= last.dartsThrown
            dartsOnDouble[last.playerIndex!] -= last.dartsOnDouble
            xThrows.remove(at: xThrows.count - 1)
            
            return last
        }
        
        return nil
    }
    
    func getWinner() -> Int? {
        for (i, _) in pointsLeft.enumerated() {
            if pointsLeft[i] == 0 {
                return i
            }
        }
        
        return nil
    }
}
