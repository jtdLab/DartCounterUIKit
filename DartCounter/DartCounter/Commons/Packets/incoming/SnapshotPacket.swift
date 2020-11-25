//
//  SnapshotPacket.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 25.10.20.
//

import Foundation

class SnapshotPacket: Packet {
    
    var snapshot: GameSnapshot
    
    private enum CodingKeys: String, CodingKey {
            case snapshot
    }
    
    init(snapshot: GameSnapshot) {
        self.snapshot = snapshot
        super.init()
    }
    
     required init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         self.snapshot = try container.decode(GameSnapshot.self, forKey: .snapshot)
         try super.init(from: decoder)
     }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(snapshot, forKey: .snapshot)
    }
}
