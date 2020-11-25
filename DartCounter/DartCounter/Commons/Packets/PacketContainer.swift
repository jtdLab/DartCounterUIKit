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

class PacketContainer : Codable {
    
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
        case cancelGame
        case createGame
        case exitGame
        case joinGame
        case performThrow
        case startGame
        case undoThrow
        
        case authResponse
        case createGameResponse
        case joinGameResponse
        case gameCanceled
        case gameStarted
        case snapshot
        case playerExited
        case playerJoined
    }
    
    init(payload: Packet) {
        if payload is AuthRequestPacket {
            payloadType = PayloadType.authRequest.rawValue
        } else if payload is CancelGamePacket {
            payloadType = PayloadType.cancelGame.rawValue
        } else if payload is CreateGamePacket {
            payloadType = PayloadType.createGame.rawValue
        } else if payload is ExitGamePacket {
            payloadType = PayloadType.exitGame.rawValue
        } else if payload is JoinGamePacket {
            payloadType = PayloadType.joinGame.rawValue
        } else if payload is PerformThrowPacket {
            payloadType = PayloadType.performThrow.rawValue
        } else if payload is StartGamePacket {
            payloadType = PayloadType.startGame.rawValue
        } else if payload is UndoThrowPacket {
            payloadType = PayloadType.undoThrow.rawValue
        } else {
            payloadType = "unknwon"
        }
        
        self.payload = payload
        self.timestamp = Date()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.payloadType = try container.decode(String.self, forKey: .payloadType)
        
        switch payloadType {
        case PayloadType.authResponse.rawValue:
            self.payload = try container.decode(AuthResponsePacket.self, forKey: .payload)
        case PayloadType.createGameResponse.rawValue:
            self.payload = try container.decode(CreateGameResponsePacket.self, forKey: .payload)
        case PayloadType.joinGameResponse.rawValue:
            self.payload = try container.decode(JoinGameResponsePacket.self, forKey: .payload)
        case PayloadType.gameCanceled.rawValue:
            self.payload = try container.decode(GameCanceledPacket.self, forKey: .payload)
        case PayloadType.gameStarted.rawValue:
            self.payload = try container.decode(GameStartedPacket.self, forKey: .payload)
        case PayloadType.snapshot.rawValue:
            self.payload = try container.decode(SnapshotPacket.self, forKey: .payload)
        case PayloadType.playerExited.rawValue:
            self.payload = try container.decode(PlayerExitedPacket.self, forKey: .payload)
        case PayloadType.playerJoined.rawValue:
            self.payload = try container.decode(PlayerJoinedPacket.self, forKey: .payload)
        default:
            self.payload = nil
        }
        
        self.timestamp = DateFormatter.packetTimestampFormatter.date(from: try container.decode(String.self, forKey: .timestamp))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(payloadType, forKey: .payloadType)
        try container.encode(payload, forKey: .payload)
        try container.encode(DateFormatter.packetTimestampFormatter.string(from: Date()), forKey: .timestamp)
    }
    
}
