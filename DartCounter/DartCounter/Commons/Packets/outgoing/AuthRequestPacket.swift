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
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        super.init()
    }
    
     required init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         self.username = try container.decode(String.self, forKey: .username)
         self.password = try container.decode(String.self, forKey: .password)
         try super.init(from: decoder)
     }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
    }
}
