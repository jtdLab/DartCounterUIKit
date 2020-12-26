//
//  PlayOfflineService.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 08.12.20.
//

import Foundation

protocol PlayOfflineServiceDelegate {
    
    func onSnapshot(snapshot: GameSnapshot)
    
}

extension PlayOfflineServiceDelegate {
    
    func onSnapshot(snapshot: GameSnapshot) {}
    
}

class PlayOfflineService {
    
    static var delegate: PlayOfflineServiceDelegate?
    
    private static var game: Game?
    
    static func cancelGame() {
      game = nil
        // Maybe add status canceled
    }
    
    static func createGame() {
        guard let username = UserService.user?.profile.username else { return }
        
        game = Game(player: Player(name: username))
        
        delegate?.onSnapshot(snapshot: game!.getSnapshot())
    }
    
    static func addPlayer() -> Bool {
        guard let game = game else { return false }
        
        let added = game.addPlayer()
        
        if added {
            delegate?.onSnapshot(snapshot: game.getSnapshot())
        }
        
        return added
    }
    
    static func addDartbot(targetAverage: Int) {
        guard let game = game else { return }
        
        if game.addDartBot(targetAverage: targetAverage) {
            delegate?.onSnapshot(snapshot: game.getSnapshot())
        }
    }
    
    static func updateGameConfig(gameConfig: GameConfig) {
        guard let game = game else { return }
        game.config = gameConfig
        
        delegate?.onSnapshot(snapshot: game.getSnapshot())
    }
    
    static func performThrow(t: Throw) -> Bool {
        guard let game = game else { return false }
        
        let successful = game.performThrow(t: t)
        
        if successful {
            delegate?.onSnapshot(snapshot: game.getSnapshot())
        }
        
        return successful
    }
    
    static func performCheck(onSuccess: ((_ pointsChecked: Int) -> ())? = nil) {
        guard let game = game else { return }
        
        let pointsLeft = game.getCurrentTurn().pointsLeft!
        if ThrowValidator.isThreeDartFinish(points: pointsLeft) {
            DispatchQueue.main.async {
                onSuccess!(pointsLeft)
            }
        }
        
    }
    
    static func startGame() {
        guard let game = game else { return }
        
        if game.start() {
            delegate?.onSnapshot(snapshot: game.getSnapshot())
        }
        
    }
    
    static func undoThrow() {
        guard let game = game else { return }
        
        if game.undoThrow() {
            delegate?.onSnapshot(snapshot: game.getSnapshot())
        }
    }
    
}
