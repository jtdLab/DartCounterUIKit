//
//  Game.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import Foundation

class Game {

    var status :GameStatus
    var config :GameConfig
    
    var players :[Player]
    var sets :[Set]
    
    var turnIndex :Int
    
    init(player :Player) {
        config = GameConfig()
        status = .PENDING
        players = [Player]()
        sets = [Set]()
        turnIndex = 0
        players.append(player)
    }
    
    func addPlayer() -> Bool {
        if players.count < 4 {
            players.append(Player(name: "Player " + String(players.count)))
            return true
        }
        return false
    }
    
    func addDartBot(targetAverage: Int) -> Bool {
        if getDartBotIndex() == nil {
            players.append(DartBot(targetAverage: targetAverage))
            return true
        }
        return false
    }
    
    func removePlayer(index :Int) {
        if players.count > 1 {
            players.remove(at: index)
        }
    }
    
    func removePlayer(player :Player) {
        if players.count > 1 {
            if let index = players.firstIndex(of: player) {
                players.remove(at: index)
            }
        }
    }
    
    func removeDartBot() {
        if getDartBotIndex() != nil {
            players.remove(at: getDartBotIndex()!)
        }
    }
    
    func start() -> Bool {
        
        if status == .PENDING && players.count > 0 {
            createSet()
            createLeg()
            initPlayers()
            status = .RUNNING
            return true
        }
        
        return false
    }
    
    func performThrow(t: Throw) -> Bool {
        
        // sets the Player who threw
        t.playerIndex = turnIndex
        
        if status == .RUNNING {
            if turnIndex == t.playerIndex && ThrowValidator.isValidThrow(t: t, pointsLeft: getCurrentTurn().pointsLeft!) {
                getCurrentTurn().isNext = false
                
                // updates the leg data
                getCurrentLeg().performThrow(t: t)
                
                // updates the Player data
                getCurrentTurn().lastThrow = t.points
                getCurrentTurn().pointsLeft = getCurrentTurn().pointsLeft! - t.points
                getCurrentTurn().dartsThrown = getCurrentTurn().dartsThrown! + t.dartsThrown
                getCurrentTurn().average = getAverageCurrentTurn()
                getCurrentTurn().checkoutPercentage = getCheckoutPercentageCurrentTurn()
                
                // updates the reference to the Player who has next turn
                // updates the Player data and creates next leg and set when needed
                if getCurrentLeg().getWinner() != nil {
                    if getCurrentSet().getWinner() != nil {
                        var sets :Int? = nil
                        if config.type == .SETS {
                            sets = getCurrentTurn().sets! + 1
                        }
                        
                        var legs :Int
                        if config.type == .LEGS {
                            legs = getCurrentTurn().legs! + 1
                        } else {
                            legs = 0
                        }
                        
                        getCurrentTurn().pointsLeft = 0
                        getCurrentTurn().sets = sets
                        getCurrentTurn().legs = legs
                        if getWinner() != nil {
                            // GAME FINISHED
                            status = .FINISHED
                        } else {
                            // CONTINUE NEW SET
                            for (i, _) in players.enumerated() {
                                let p :Player  = players[i]
                                p.pointsLeft = config.startingPoints
                                p.dartsThrown = 0
                                p.legs = 0
                            }
                            turnIndex = (getCurrentSet().startIndex + 1) % players.count
                            createSet()
                            createLeg()
                        }
                    } else {
                        // CONTINUE NEW LEG
                        for (i, _) in players.enumerated() {
                            let p :Player = players[i]
                            var legs :Int = p.legs!
                            
                            if i == turnIndex {
                                legs += 1
                            }
                            
                            p.pointsLeft = config.startingPoints
                            p.dartsThrown = 0
                            p.legs = legs
                        }
                        turnIndex = (getCurrentLeg().startIndex + 1) % players.count
                        createLeg()
                    }
                } else {
                    // CONTINUE
                    turnIndex = (turnIndex + 1) % players.count
                }
                
                getCurrentTurn().isNext = true
                
                if getCurrentTurn() is DartBot && getCurrentLeg().getWinner() == nil {
                    performDartBotThrow()
                }
                return true
            }
        }
        return false
    }
    
    func performDartBotThrow() {
        let randomScore = ScoreGenerator.getRandomScore(bot: getCurrentTurn() as! DartBot)
        var t: Throw
        
        if randomScore == getCurrentTurn().pointsLeft {
            if ThrowValidator.isOneDartFinish(points: randomScore) {
                t = Throw(points: randomScore, dartsOnDouble: 1, dartsThrown: 1)
            } else if ThrowValidator.isThreeDartFinish(points: randomScore) {
                t = Throw(points: randomScore, dartsOnDouble: 1, dartsThrown: 3)
            } else {
                t = Throw(points: randomScore, dartsOnDouble: 1, dartsThrown: 2)
            }
        } else {
            t = Throw(points: randomScore, dartsOnDouble: 0, dartsThrown: 3)
        }
        performThrow(t: t)
    }
    
    func undoThrow() -> Bool {
        if status == GameStatus.RUNNING {
            if sets.count == 1 && sets[0].legs.count == 1 && getCurrentLeg().xThrows.count == 0 {
                // NO THROW PERFORMED YET -> do nothing
                return false
            }
            
            getCurrentTurn().isNext = false
            
            if sets.count == 1 && sets[0].legs.count == 1 && getCurrentLeg().xThrows.count <= players.count {
                // UNDO FIRST THROW OF GAME OF PLAYER
                let last = getCurrentLeg().undoThrow()
                turnIndex = last!.playerIndex!
                getCurrentTurn().lastThrow = nil
                getCurrentTurn().pointsLeft = config.startingPoints
                getCurrentTurn().dartsThrown = 0
                getCurrentTurn().average = "0.00"
                getCurrentTurn().checkoutPercentage = "0.00"
            } else if sets.count >= 2 && getCurrentSet().legs.count == 1 && getCurrentLeg().xThrows.count == 0 {
                // UNDO LAST THROW OF SET
                sets.remove(at: sets.count - 1)
                let last = getCurrentLeg().undoThrow()
                turnIndex = last!.playerIndex!
                
                // restore Player data
                for (i, p) in players.enumerated() {
                    if turnIndex == i {
                        p.lastThrow = getCurrentLeg().xThrows[getCurrentLeg().xThrows.count - players.count].points
                        p.average = getAverageCurrentTurn()
                        p.checkoutPercentage = getCheckoutPercentageCurrentTurn()
                    }
                    
                    p.pointsLeft = getCurrentLeg().pointsLeft[i]
                    p.dartsThrown = getCurrentLeg().dartsThrown[i]
                    
                    var s :Int? = 0
                    var l = 0
                    
                    for set in sets {
                        if config.type == GameType.SETS {
                            if set.getWinner() != nil && set.getWinner() == i {
                                s = s! + 1
                            }
                        } else {
                            s = nil
                        }
                    }
                    
                    for leg in getCurrentSet().legs {
                        if leg.getWinner() != nil && leg.getWinner() == i {
                            l += 1
                        }
                    }
                    
                    p.sets = s
                    p.legs = l
                }
            } else if getCurrentSet().legs.count >= 2 && getCurrentLeg().xThrows.count == 0 {
                // UNDO LAST THROW OF LEG
                getCurrentSet().legs.remove(at: getCurrentSet().legs.count - 1)
                let last = getCurrentLeg().undoThrow()
                turnIndex = last!.playerIndex!
                
                // restore Player data
                for (i, p) in players.enumerated() {
                    if turnIndex == i {
                        p.lastThrow = getCurrentLeg().xThrows[getCurrentLeg().xThrows.count - players.count].points
                        p.average = getAverageCurrentTurn()
                        p.checkoutPercentage = getCheckoutPercentageCurrentTurn()
                    }
                    
                    p.pointsLeft = getCurrentLeg().pointsLeft[i]
                    p.dartsThrown = getCurrentLeg().dartsThrown[i]
                    
                    var l = 0
                    
                    for leg in getCurrentSet().legs {
                        if leg.getWinner() != nil && leg.getWinner() == i {
                            l += 1
                        }
                    }
                    
                    p.legs = l
                }
            } else {
                // UNDO STANDARD THROW
                let last = getCurrentLeg().undoThrow()
                turnIndex = last!.playerIndex!
                
                getCurrentTurn().lastThrow = getCurrentLeg().xThrows[getCurrentLeg().xThrows.count - players.count].points
                getCurrentTurn().pointsLeft = getCurrentTurn().pointsLeft! + last!.points
                getCurrentTurn().dartsThrown = getCurrentTurn().dartsThrown! - last!.dartsThrown
                
            }
            
            getCurrentTurn().isNext = true
            getCurrentTurn().average = getAverageCurrentTurn()
            getCurrentTurn().checkoutPercentage = getCheckoutPercentageCurrentTurn()
        }
        return false
    }
    
    func getSnapshot() -> GameSnapshot {
        return GameSnapshot(status: status, description: getDescription(), players: players.map({ player in
            return player.getSnapshot()
        }))
    }
    
    func getWinner() -> Player? {
        switch config.type {
            case .LEGS:
                var legsNeededToWin :Int
                switch config.mode {
                    case .FIRST_TO:
                        legsNeededToWin = config.size
                        for player in players {
                            if player.legs == legsNeededToWin {
                                return player
                            }
                        }
                    case .BEST_OF:
                        legsNeededToWin = (config.size/2) + 1
                        for player in players {
                            if player.legs == legsNeededToWin {
                                return player
                            }
                        }
                        break
                }
                break
            case .SETS:
                var setsNeededToWin :Int
                switch config.mode {
                    case .FIRST_TO:
                        setsNeededToWin = config.size
                        for player in players {
                            if player.sets == setsNeededToWin {
                                return player
                            }
                        }
                    case .BEST_OF:
                        setsNeededToWin = (config.size/2) + 1
                        for player in players {
                            if player.legs == setsNeededToWin {
                                return player
                            }
                        }
                        break
                }
                break
        }
        
        return nil
    }
    
    func getDescription() -> String {
        return config.getModeAsString() + " " + String(config.size) + " " + config.getTypeAsString()
    }
    
    func getCurrentSet() -> Set {
        return sets[sets.count - 1]
    }
    
    func getCurrentLeg() -> Leg {
        let legs :[Leg] = getCurrentSet().legs
        return legs[legs.count - 1]
    }
    
    func getCurrentTurn() -> Player {
        return players[turnIndex]
    }
    
    func getPreviousTurn() -> Player {
        let r = (turnIndex - 1) % players.count
        let i = r >= 0 ? r : r + players.count
        return players[i]
    }
    
    func getOwner() -> Player {
        return players[0]
    }
    
    func getAverageCurrentTurn() -> String {
        var totalDartsThrown :Int = 0
        var totalPointsScored :Int = 0
        for set in sets {
            for leg in set.legs {
                totalDartsThrown += leg.dartsThrown[turnIndex]
                totalPointsScored += (config.startingPoints - leg.pointsLeft[turnIndex])
            }
        }
        
        if totalDartsThrown == 0 {
            return "0.00"
        }
        
        let average :Double = (Double(3 * totalPointsScored) / Double(totalDartsThrown))
        return String(format: "%.2f", average)
    }
    
    func getCheckoutPercentageCurrentTurn() -> String {
        var totalLegsWon :Int = 0
        var totalDartsOnDouble :Int = 0
        for set in sets {
            for leg in set.legs {
                if leg.getWinner() == turnIndex {
                    totalLegsWon += 1
                }
                totalDartsOnDouble += leg.dartsOnDouble[turnIndex]
            }
        }
        
        if totalDartsOnDouble == 0 {
            return "0.00"
        }
        
        let checkoutPercentage :Double = (Double(totalLegsWon) / Double(totalDartsOnDouble)) * 100
        return String(format: "%.2f", checkoutPercentage)
    }
    
    func getDartBotIndex() -> Int? {
        for (i, p) in players.enumerated() {
            if p is DartBot {
                return i
            }
        }
        return nil
    }
    
    func createSet() {
        if config.mode == .FIRST_TO{
            if config.type == .LEGS {
                sets.append(Set(startIndex: turnIndex, legsNeededToWin: config.size))
            } else {
                sets.append(Set(startIndex: turnIndex, legsNeededToWin: 3))
            }
        } else {
            if config.type == .LEGS {
                sets.append(Set(startIndex: turnIndex, legsNeededToWin: (config.size/2) + 1))
            } else {
                sets.append(Set(startIndex: turnIndex, legsNeededToWin: 3))
            }
        }
    }
    
    func createLeg() {
        getCurrentSet().legs.append(Leg(startIndex: turnIndex, numberOfPlayers: players.count, startingPoints: config.startingPoints))
    }
    
    func initPlayers() {
        for player in players {
            player.isNext = false
            player.lastThrow = nil
            player.pointsLeft = config.startingPoints
            player.dartsThrown = 0
            if config.type == .SETS {
                player.sets = 0
            } else {
                player.sets = nil
            }
            player.legs = 0
            player.average = "0.00"
            player.checkoutPercentage = "0.00"
        }
        
        players[turnIndex].isNext = true
    }
}
