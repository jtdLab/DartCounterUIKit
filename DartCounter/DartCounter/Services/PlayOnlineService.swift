//
//  PlayOnlineService.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 25.10.20.
//

import Foundation
import Starscream

protocol PlayOnlineServiceDelegate {
    
    func onAuthResponse(authResponse: AuthResponsePacket)
    
    func onCreateGameResponse(createGameResponse: CreateGameResponsePacket)
    
    func onJoinGameResponse(joinGameResponse: JoinGameResponsePacket)
    
    func onGameCanceled(gameCanceled: GameCanceledPacket)
    
    func onGameStarted(gameStarted: GameStartedPacket)
    
    func onSnapshot(snapshot: GameSnapshot)
    
    func onPlayerExited(playerExited: PlayerExitedPacket)
    
    func onPlayerJoined(playerJoined: PlayerJoinedPacket)
    
}

extension PlayOnlineServiceDelegate {
    
    func onAuthResponse(authResponse: AuthResponsePacket) {}
    
    func onCreateGameResponse(createGameResponse: CreateGameResponsePacket) {}
    
    func onJoinGameResponse(joinGameResponse: JoinGameResponsePacket) {}
    
    func onGameCanceled(gameCanceled: GameCanceledPacket) {}
    
    func onGameStarted(gameStarted: GameStartedPacket) {}
    
    func onSnapshot(snapshot: GameSnapshot) {}
    
    func onPlayerExited(playerExited: PlayerExitedPacket) {}
    
    func onPlayerJoined(playerJoined: PlayerJoinedPacket) {}
    
}

class PlayOnlineService {
    
    static var delegate: PlayOnlineServiceDelegate?
    
    private static let host = "ws://localhost"
    private static let port = 9000
    
    private static var connected = false
    
    private static let socket: WebSocket = {
        var request = URLRequest(url: URL(string: host + ":" + String(port))!)
        request.timeoutInterval = 5
        let ws = WebSocket(request: request)
       
        ws.onDisconnect = { (error: Error?) in
            print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
            connected = false
        }
      
        ws.onText = { (text: String) in
            // add error handling make more robust
            let packetContainer = try! JSONDecoder().decode(PacketContainer.self, from: text.data(using: .utf8)!)
            onPacket(packet: packetContainer.payload!)
        }
        
        return ws
    }()
    
    static func connect(completion: (() -> ())? = nil) {
        if !connected {
            socket.onConnect = {
                guard let uid = UserService.currentProfile?.uid else { return }
                guard let username = UserService.currentProfile?.username else { return }
                
                sendPacket(packet: AuthRequestPacket(uid: uid, username: username))
                connected = true
                
                if let completion = completion {
                    completion()
                }
            }
            socket.connect()
        }
    }
    
    static func cancelGame() {
        sendPacket(packet: CancelGamePacket())
    }
    
    static func createGame() {
        sendPacket(packet: CreateGamePacket())
    }
    
    static func updateGameConfig(gameConfig: GameConfig) {
        sendPacket(packet: UpdateGameConfigPacket(gameConfig: gameConfig))
    }
    
    static func exitGame() {
        sendPacket(packet: ExitGamePacket())
    }
    
    static func joinGame(gameCode: Int) {
        sendPacket(packet: JoinGamePacket(gameCode: gameCode))
    }
    
    static func performThrow(t: Throw) {
        sendPacket(packet: PerformThrowPacket(t: t))
    }
    
    static func startGame() {
        sendPacket(packet: StartGamePacket())
    }
    
    static func undoThrow() {
        sendPacket(packet: UndoThrowPacket())
    }
    
    static func disconnect() {
        if connected {
            socket.disconnect()
        }
    }

    
    private static func sendPacket(packet: Packet) {
        let jsonData = try! JSONEncoder().encode(PacketContainer(payload: packet))
        let json = String(data: jsonData, encoding: String.Encoding.utf8)!
        print(json)
        socket.write(string: json)
    }
    
    private static func onPacket(packet: Packet) {
        if(packet is AuthResponsePacket) {
            delegate?.onAuthResponse(authResponse: packet as! AuthResponsePacket)
        } else if(packet is CreateGameResponsePacket) {
            delegate?.onCreateGameResponse(createGameResponse: packet as! CreateGameResponsePacket)
        } else if(packet is JoinGameResponsePacket) {
            delegate?.onJoinGameResponse(joinGameResponse: packet as! JoinGameResponsePacket)
        } else if(packet is GameCanceledPacket) {
            delegate?.onGameCanceled(gameCanceled: packet as! GameCanceledPacket)
        } else if(packet is GameStartedPacket) {
            delegate?.onGameStarted(gameStarted: packet as! GameStartedPacket)
        } else if(packet is SnapshotPacket) {
            delegate?.onSnapshot(snapshot: (packet as! SnapshotPacket).snapshot)
        } else if(packet is PlayerExitedPacket) {
            delegate?.onPlayerExited(playerExited: packet as! PlayerExitedPacket)
        } else if(packet is PlayerJoinedPacket) {
            delegate?.onPlayerJoined(playerJoined: packet as! PlayerJoinedPacket)
        }
    }
}
