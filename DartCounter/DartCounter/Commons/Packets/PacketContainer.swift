//
//  PacketContainer.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 25.10.20.
//

import Foundation

extension DateFormatter {
    static var packetTimestampFormatter : DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return dateFormatter
    }
}

class PacketContainer : Decodable {
    
    let payloadType: String
    let payload: Packet?
    let timestamp: Date?
    
    
    enum CodingKeys: CodingKey {
        case payloadType
        case payload
        case timestamp
    }
    
    enum PayloadType: String, Decodable {
        case authRequest
        case authResponse
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.payloadType = try container.decode(String.self, forKey: .payloadType)
        
        switch payloadType {
        case "authRequest":
            self.payload = try container.decode(AuthRequestPacket.self, forKey: .payload)
        case "authResponse":
            self.payload = try container.decode(AuthResponsePacket.self, forKey: .payload)
        default:
            self.payload = nil
        }
        
        self.timestamp = DateFormatter.packetTimestampFormatter.date(from: try container.decode(String.self, forKey: .timestamp))
    }
    
}
