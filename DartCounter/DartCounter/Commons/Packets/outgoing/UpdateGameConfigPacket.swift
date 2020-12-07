//
//  UpdateGameConfigPacket.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 07.12.20.
//

import Foundation

class UpdateGameConfigPacket: Packet {
    
    var gameConfig: GameConfig
    
    private enum CodingKeys: String, CodingKey {
            case gameConfig
    }
    
    init(gameConfig: GameConfig) {
        self.gameConfig = gameConfig
        super.init()
    }
    
     required init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         self.gameConfig = try container.decode(GameConfig.self, forKey: .gameConfig)
         try super.init(from: decoder)
     }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(gameConfig, forKey: .gameConfig)
    }
}
