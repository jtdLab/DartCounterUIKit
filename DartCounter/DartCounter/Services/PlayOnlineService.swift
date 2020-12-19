//
//  PlayOnlineService.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 25.10.20.
//

import Foundation
import Starscream

protocol PlayOnlineServiceDelegate {
    
    func onAuthResponse(successful: Bool)
    
    func onCreateGameResponse(successful: Bool, snapshot: GameSnapshot)
    
    func onJoinGameResponse(successful: Bool, snapshot: GameSnapshot)
    
    func onStartGameResponse(successful: Bool, snapshot: GameSnapshot)
    
    func onGameCanceled()
    
    func onSnapshot(snapshot: GameSnapshot)
    
    func onPlayerExited(username: String)
    
    func onPlayerJoined(username: String)
    
}

extension PlayOnlineServiceDelegate {
    
    func onAuthResponse(successful: Bool) {}
    
    func onCreateGameResponse(successful: Bool, snapshot: GameSnapshot) {}
    
    func onJoinGameResponse(successful: Bool, snapshot: GameSnapshot) {}
    
    func onStartGameResponse(successful: Bool, snapshot: GameSnapshot) {}
    
    func onGameCanceled() {}
    
    func onSnapshot(snapshot: GameSnapshot) {}
    
    func onPlayerExited(username: String) {}
    
    func onPlayerJoined(username: String) {}
    
}

class PlayOnlineService {
    
    static var delegate: PlayOnlineServiceDelegate?
    
    private static let host = "ws://127.0.0.1" //"ws://46.101.130.16"
    private static let port = 9000
    
    static var isConnected = false
    
    private static let socket: WebSocket = {
        var request = URLRequest(url: URL(string: host + ":" + String(port))!)
        request.timeoutInterval = 5
        let ws = WebSocket(request: request)
        
        ws.onEvent = { event in
            
            switch event {
                case .connected(let headers):
                    guard let uid = UserService.currentProfile?.uid else { return }
                    guard let username = UserService.currentProfile?.username else { return }
                    sendPacket(packet: AuthRequestPacket(uid: uid, username: username))
                case .disconnected(let reason, let code):
                    isConnected = false
                    print("websocket is disconnected: \(reason) with code: \(code)")
                case .text(let string):
                    // TODO add error handling make more robust
                    let packetContainer = try! JSONDecoder().decode(PacketContainer.self, from: string.data(using: .utf8)!)
                    onPacket(packet: packetContainer.payload!)
                case .binary(let data):
                    break
                case .ping(_):
                    break
                case .pong(_):
                    break
                case .viabilityChanged(_):
                    break
                case .reconnectSuggested(_):
                    break
                case .cancelled:
                    isConnected = false
                case .error(let error):
                    isConnected = false
                   // TODO handle error
                }
            }
        
        return ws
    }()
    
    static func connect() {
        if !isConnected {
            socket.connect()
        }
    }
    
    static func createGame() {
        sendPacket(packet: CreateGamePacket())
    }
    
    static func updateGameConfig(gameConfig: GameConfig) {
        sendPacket(packet: UpdateGameConfigPacket(gameConfig: gameConfig))
    }
    
    static func inviteToGame(uid: String, username: String) {
        sendPacket(packet: InviteToGamePacket(uid: uid, username: username))
    }
    
    static func joinGame(gameCode: Int) {
        sendPacket(packet: JoinGamePacket(gameCode: gameCode))
    }
    
    static func startGame() {
        sendPacket(packet: StartGamePacket())
    }
    
    static func performThrow(t: Throw) {
        sendPacket(packet: PerformThrowPacket(t: t))
    }
    
    static func undoThrow() {
        sendPacket(packet: UndoThrowPacket())
    }
    
    static func exitGame() {
        sendPacket(packet: ExitGamePacket())
    }
    
    static func disconnect() {
        if isConnected {
            socket.disconnect()
        }
    }

    private static func sendPacket(packet: Packet) {
        let jsonData = try! JSONEncoder().encode(PacketContainer(payload: packet))
        let json = String(data: jsonData, encoding: String.Encoding.utf8)!
        socket.write(string: json)
    }
    
    private static func onPacket(packet: Packet) {
        if(packet is AuthResponsePacket) {
            let packet = (packet as! AuthResponsePacket)
            delegate?.onAuthResponse(successful: packet.successful)
            isConnected = packet.successful
        } else if(packet is CreateGameResponsePacket) {
            let packet = (packet as! CreateGameResponsePacket)
            delegate?.onCreateGameResponse(successful: packet.successful, snapshot: packet.snapshot)
        } else if(packet is JoinGameResponsePacket) {
            let packet = (packet as! JoinGameResponsePacket)
            delegate?.onJoinGameResponse(successful: packet.successful, snapshot: packet.snapshot)
        } else if(packet is StartGameResponsePacket) {
            let packet = (packet as! StartGameResponsePacket)
            delegate?.onStartGameResponse(successful: packet.successful, snapshot: packet.snapshot)
        } else if(packet is InviteToGameResponse) {
            // TODO
        } else if(packet is SnapshotPacket) {
            delegate?.onSnapshot(snapshot: (packet as! SnapshotPacket).snapshot)
        } else if(packet is PlayerExitedPacket) {
            delegate?.onPlayerExited(username: (packet as! PlayerExitedPacket).username)
        } else if(packet is PlayerJoinedPacket) {
            delegate?.onPlayerJoined(username: (packet as! PlayerJoinedPacket).username)
        }
    }
}
