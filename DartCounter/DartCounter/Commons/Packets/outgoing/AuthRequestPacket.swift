//
//  AuthRequestPacket.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 25.10.20.
//

import Foundation

class AuthRequestPacket: Packet {
    
    var username: String
    var password: String
    
    private enum CodingKeys: String, CodingKey {
            case username
            case password
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.password = try container.decode(String.self, forKey: .password)
        try super.init(from: decoder)
    }
}
