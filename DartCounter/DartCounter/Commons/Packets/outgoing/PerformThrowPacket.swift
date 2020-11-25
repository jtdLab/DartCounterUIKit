//
//  PerformThrowPacket.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 25.10.20.
//

import Foundation

class PerformThrowPacket: Packet {
    
    var t: Throw

    private enum CodingKeys: String, CodingKey {
            case t
    }
    
    init(t: Throw) {
        self.t = t
        super.init()
    }
    
     required init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         self.t = try container.decode(Throw.self, forKey: .t)
         try super.init(from: decoder)
     }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(t, forKey: .t)
    }
}
