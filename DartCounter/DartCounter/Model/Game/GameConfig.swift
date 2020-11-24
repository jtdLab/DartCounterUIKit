//
//  GameConfig.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import Foundation

class GameConfig {
    
    var mode :GameMode
    var type :GameType
    var size :Int
    var startingPoints :Int
    
    init() {
        mode = GameMode.FIRST_TO
        type = GameType.LEGS
        size = 3
        startingPoints = 501
    }
    
    init(mode :GameMode, type :GameType, size :Int, startingPoints :Int) {
        self.mode = mode
        self.type = type
        self.size = size
        self.startingPoints = startingPoints
    }
    
    func getModeAsString() -> String {
        switch mode {
            case .FIRST_TO:
                return "first to"
            case .BEST_OF:
                return "best of"
        }
    }
    
    func getTypeAsString() -> String {
        switch type {
            case .LEGS:
                if size == 1 {
                    return "leg"
                }
                return "legs"
            case .SETS:
                if size == 1 {
                    return "set"
                }
                return "sets"
        }
    }
}
