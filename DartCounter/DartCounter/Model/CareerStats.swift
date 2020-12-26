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
    
    init() {
        self.average = "0.00"
        self.firstNine = "0.00"
        self.checkoutPerentage = "0.00"
        self.wins = "0"
        self.defeats = "0"
    }
    
    init(dict: [String:Any]) throws {
        if let a = dict["average"] as? String,
           let f = dict["firstNine"] as? String,
           let c = dict["checkoutPerentage"] as? String,
           let w = dict["wins"] as? String,
           let d = dict["defeats"] as? String {
            self.average = a
            self.firstNine = f
            self.checkoutPerentage = c
            self.wins = w
            self.defeats = d
            return
        }
        
        throw Errors.GeneralError.initError("Can't construct CareerStats from given dict")
    }
    
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
    
}
