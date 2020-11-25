//
//  JoinGamePacket.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 25.10.20.
//

import Foundation

class JoinGamePacket: Packet {
    
    var gameCode: Int
    
    private enum CodingKeys: String, CodingKey {
            case gameCode
    }
    
    init(gameCode: Int) {
        self.gameCode = gameCode
        super.init()
    }
    
     required init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         self.gameCode = try container.decode(Int.self, forKey: .gameCode)
         try super.init(from: decoder)
     }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(gameCode, forKey: .gameCode)
    }
}
