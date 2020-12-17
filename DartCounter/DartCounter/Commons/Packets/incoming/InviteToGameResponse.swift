//
//  InvitedToGamePacket.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 16.12.20.
//

import Foundation

class InviteToGameResponse: Packet {
    
    var successful: Bool
    
    private enum CodingKeys: String, CodingKey {
        case successful
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.successful = try container.decode(Bool.self, forKey: .successful)
        try super.init(from: decoder)
    }
}
