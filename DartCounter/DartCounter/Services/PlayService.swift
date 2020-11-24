//
//  PlayService.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 25.10.20.
//

import Foundation
import Starscream

class PlayService {
    
    private static let socket: WebSocket = {
        let s = WebSocket(url: URL(string: App.playServerUrl)!)
        s.onConnect = {
            print()
        }
        
        s.onDisconnect = { (error: Error?) in
            print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
        }
      
        s.onText = { (text: String) in
            // TODO string -> container -> packet
            print("MESSAGE RECEIVED")
            print(text)

        }
        
        return s
    }()
    
    static func join() {
        connect()
        socket.onConnect = {
            sendPacket()
        }
    }
    
    
    private static func connect() {
        print("Connecting ...")
        socket.connect()
        print("Connected!")
    }
    
    private static func sendPacket() {
        print("Sending ....")
        socket.write(string: #"{"payloadType":"authRequest","payload":{"username":"mrjosch","password":"sanoj050499"},"timestamp":"2020-10-17 03:38:16.44"}"#)
        
        print("Packet sent")
    }
    
    private static func onPacket(packet: Packet) {
        print(packet)
    }
}
