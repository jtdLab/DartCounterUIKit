//
//  Set.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import Foundation

class Set {
    
    var legs: [Leg]
    var legsNeededToWin :Int
    var startIndex :Int
    
    init(startIndex :Int, legsNeededToWin: Int) {
        legs = [Leg]()
        self.legsNeededToWin = legsNeededToWin
        self.startIndex = startIndex
    }
    
    func getWinner() -> Int? {
        var winners = [Int]()
        
        for leg in legs {
            winners.append(leg.getWinner()!)
        }
        
        var map = [Int : Int]()
        winners.forEach({ element in
            if map[element] == nil {
                map[element] = 1
            } else {
                map[element] = map[element]! + 1
            }
        })
        
        for key in map.keys {
            if map[key] == legsNeededToWin {
                return key
            }
        }
        
        return nil
    }
    
    func addLeg(leg :Leg) {
        legs.append(leg)
    }
    
}
