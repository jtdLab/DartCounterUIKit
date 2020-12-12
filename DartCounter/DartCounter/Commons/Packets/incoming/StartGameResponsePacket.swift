//
//  StartGameResponsePacket.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 11.12.20.
//

import Foundation

class StartGameResponsePacket: Packet {
    
    var successful: Bool
    
    var snapshot: GameSnapshot
    
    private enum CodingKeys: String, CodingKey {
        case successful
        case snapshot
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.successful = try container.decode(Bool.self, forKey: .successful)
        self.snapshot = try container.decode(GameSnapshot.self, forKey: .snapshot)
        try super.init(from: decoder)
    }
}
