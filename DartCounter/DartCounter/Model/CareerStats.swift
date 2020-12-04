//
//  CareerStats.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 04.12.20.
//

import Foundation

class CareerStats {
    
    var average: String
    var firstNine: String
    var checkoutPerentage: String
    var wins: String
    var defeats: String
    
    init(average: String, firstNine: String, checkoutPerentage: String, wins: String, defeats: String) {
        self.average = average
        self.firstNine = firstNine
        self.checkoutPerentage = checkoutPerentage
        self.wins = wins
        self.defeats = defeats
    }
    
    var dict: [String:Any] {
        return [
            "average": average,
            "firstNine": firstNine,
            "checkoutPerentage": checkoutPerentage,
            "wins": wins,
            "defeats": defeats
        ]
    }
    
    static func fromDict(dict: [String:Any]) -> CareerStats? {
        if let a = dict["average"] as? String,
           let f = dict["firstNine"] as? String,
           let c = dict["checkoutPerentage"] as? String,
           let w = dict["wins"] as? String,
           let d = dict["defeats"] as? String {
            return CareerStats(average: a, firstNine: f, checkoutPerentage: c, wins: w, defeats: d)
        }
        
        return nil
    }
    
}
