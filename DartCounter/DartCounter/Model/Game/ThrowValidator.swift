//
//  ThrowValidator.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import Foundation

class ThrowValidator {
    
    static func isValidThrow(t :Throw, pointsLeft: Int) -> Bool {
        if t.points < 0  || t.points > 180 {
            return false
        }
        
        if t.points == 0  && t.dartsThrown != 3 {
            return false
        }
        
        if t.points > pointsLeft {
            return false
        }
        
        if [163, 166, 169, 172, 173, 175, 176, 178, 179].contains(t.points) {
            return false
        }
        
        if t.dartsThrown < 1 || t.dartsThrown > 3 {
            return false
        }
        
        if t.dartsOnDouble < 0 || t.dartsOnDouble > 3 {
            return false
        }
        
        if t.dartsOnDouble > t.dartsThrown {
            return false
        }
        
        if t.dartsOnDouble > 0 && !isThreeDartFinish(points: pointsLeft) {
            return false
        }
        
        if t.dartsOnDouble == 2 && (isThreeDartFinish(points: pointsLeft) && !isOneDartFinish(points: pointsLeft) && !isTwoDartFinish(points: pointsLeft)) {
            return false
        }
        
        if t.dartsOnDouble == 3 && !isOneDartFinish(points: pointsLeft) {
            return false
        }
        
        return pointsLeft != 2 || t.dartsOnDouble == t.dartsThrown
    }
    
    static func isThreeDartFinish(points: Int) -> Bool {
        if points < 2 || points > 170 {
            return false
        }
        
        return ![159, 162, 163, 165, 166, 168, 169].contains(points)
    }
    
    static func isTwoDartFinish(points: Int) -> Bool {
        if points < 2 || points > 110 {
            return false
        }
        
        return ![99, 102, 103, 105, 106, 108, 109].contains(points)
    }
    
    static func isOneDartFinish(points: Int) -> Bool {
        if points < 2 || points > 50 {
            return false
        }
            
        return points == 50 || (points <= 40 && points % 2 == 0)
    }
    
}
