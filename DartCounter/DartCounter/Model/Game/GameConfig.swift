//
//  GameConfig.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import Foundation

class GameConfig: Codable {
    
    var mode :GameMode
    var type :GameType
    var size :Int
    var startingPoints :Int
    
    private enum CodingKeys: String, CodingKey {
        case mode
        case type
        case size
        case startingPoints
    }
    
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
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let modeString = try! container.decode(String.self, forKey: .mode).uppercased()
        let typeString = try! container.decode(String.self, forKey: .type).uppercased()
        self.mode = GameMode(rawValue: modeString.replacingOccurrences(of: " ", with: "_"))!
        self.type = GameType(rawValue: typeString.replacingOccurrences(of: " ", with: "_"))!
        self.size = try container.decode(Int.self, forKey: .size)
        self.startingPoints = try container.decode(Int.self, forKey: .startingPoints)
    }
   
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(getModeAsString(), forKey: .mode)
        try container.encode(getTypeAsString(), forKey: .type)
        try container.encode(size, forKey: .size)
        try container.encode(startingPoints, forKey: .startingPoints)
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
