//
//  DartBot.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 14.11.20.
//

import Foundation

class DartBot :Player {
    
    var targetAverage: Int
    
    init(targetAverage: Int) {
        self.targetAverage = targetAverage
        super.init(name: "Dartbot")
    }
}
