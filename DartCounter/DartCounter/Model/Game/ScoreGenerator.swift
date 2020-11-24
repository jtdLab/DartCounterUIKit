//
//  ScoreGenerator.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 14.11.20.
//

import Foundation

class ScoreGenerator {
    
    static func getRandomScore(bot: DartBot) -> Int {
        let avg = Int(Double(bot.average!)!)
        let pointsLeft = bot.pointsLeft!
        
        if bot.dartsThrown! < 9 {
            // am Anfang
            return bot.targetAverage + Int.random(in: 0...bot.targetAverage / 5)
        }
        
        var score: Int?
        if avg < bot.targetAverage {
            score = bot.targetAverage + Int.random(in: 0...bot.targetAverage / 5)
        } else {
            score = bot.targetAverage - Int.random(in: 0...bot.targetAverage / 5)
        }
        
        if score! >= pointsLeft {
            if ThrowValidator.isThreeDartFinish(points: pointsLeft) {
                return pointsLeft
            } else {
                return getRandomScore(bot: bot)
            }
        } else {
            if pointsLeft - score! >= 2 {
                if ThrowValidator.isValidThrow(t: Throw(points: score!, dartsOnDouble: 0, dartsThrown: 3), pointsLeft: pointsLeft) {
                    return score!
                } else {
                    return getRandomScore(bot: bot)
                }
            } else {
                if pointsLeft > 40 {
                    return pointsLeft - 40
                } else if pointsLeft > 36 {
                    return pointsLeft - 36
                } else if pointsLeft > 32 {
                    return pointsLeft - 32
                } else if pointsLeft > 16 {
                    return pointsLeft - 16
                } else if pointsLeft > 8 {
                    return pointsLeft - 8
                } else if pointsLeft > 4 {
                    return pointsLeft - 4
                } else if pointsLeft > 2 {
                    return pointsLeft - 2
                }
            }
        }
        
        return getRandomScore(bot: bot)
    }
    
    static func getDartsNeededForFinish(game: Game, bot: DartBot) -> Int {
        // TODO
        return 1
    }
    
}
