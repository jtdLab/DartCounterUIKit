//
//  AuthRequestPacket.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 25.10.20.
//

import Foundation

class AuthRequestPacket: Packet {
    
    var uid: String
    var username: String
    
    private enum CodingKeys: String, CodingKey {
        case uid
        case username
    }
    
    init(uid: String, username: String) {
        self.uid = uid
        self.username = username
        super.init()
    }
    
     required init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         self.uid = try container.decode(String.self, forKey: .uid)
         self.username = try container.decode(String.self, forKey: .username)
         try super.init(from: decoder)
     }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(username, forKey: .username)
    }
}
