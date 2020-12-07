//
//  InGameViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 24.10.20.
//

import UIKit
import Starscream

class InGameViewController: UIViewController {
    
    var playerContainer: UIView? // TODO check if good practice
    
    var online: Bool = false
    var snapshot: GameSnapshot?
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var label_pointsScored: UILabel!
    
    
    @IBAction func onExit(_ sender: UIBarButtonItem) {
        onExit()
    }
    
    @IBAction func onStats(_ sender: Any) {
        onStats()
    }
    
    @IBAction func onUndo(_ sender: UIButton) {
       onUndo()
    }
    
    @IBAction func onPerform(_ sender: UIButton) {
        onPerformThrow()
    }
    
    @IBAction func onOne(_ sender: UIButton) {
        onDigit(digit: 1)
    }
    
    @IBAction func onTwo(_ sender: UIButton) {
        onDigit(digit: 2)
    }
    
    @IBAction func onThree(_ sender: UIButton) {
        onDigit(digit: 3)
    }
    
    @IBAction func onFour(_ sender: UIButton) {
        onDigit(digit: 4)
    }
    
    @IBAction func onFive(_ sender: UIButton) {
        onDigit(digit: 5)
    }
    
    @IBAction func onSix(_ sender: UIButton) {
        onDigit(digit: 6)
    }
    
    @IBAction func onSeven(_ sender: UIButton) {
        onDigit(digit: 7)
    }
    
    @IBAction func onEight(_ sender: UIButton) {
        onDigit(digit: 8)
    }
    
    @IBAction func onNine(_ sender: UIButton) {
        onDigit(digit: 9)
    }
    
    @IBAction func onCheck(_ sender: UIButton) {
        onCheck()
    }
    
    @IBAction func onZero(_ sender: UIButton) {
        onDigit(digit: 0)
    }
    
    @IBAction func onDelete(_ sender: UIButton) {
        onDelete()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.InGame_Home, let viewController = segue.destination as? HomeViewController {
            // TODO
        } else if segue.identifier == Segues.InGame_CheckoutDetails, let viewController = segue.destination as? CheckoutDetailsViewController {

            viewController.delegate = self
            viewController.pointsLeft = App.game!.getCurrentTurn().pointsLeft!
            viewController.pointsScored = Int(label_pointsScored.text!)!
        } else if segue.identifier == Segues.Ingame_Stats, let viewController = segue.destination as? StatsViewController {
            // TODO
        }
    }

    
    private func initView() {
        navItem.hidesBackButton = true
        label_pointsScored.text = "0"
        navItem.title = snapshot?.getDescription()
        
        if !online {
            navItem.title = App.game!.getDescription().uppercased()
            switch App.game!.players.count {
            case 1:
                playerContainer = OnePlayerView()
                playerView.addSubview(playerContainer!)
                break
            case 2:
                playerContainer = TwoPlayerView()
                playerView.addSubview(playerContainer!)
                break
            case 3:
                playerContainer = ThreePlayerView()
                playerView.addSubview(playerContainer!)
                break
            case 4:
                playerContainer = FourPlayerView()
                playerView.addSubview(playerContainer!)
                break
            default:
                return
            }
        } else {
            PlayService.delegate = self
            
            switch snapshot!.players.count {
            case 1:
                playerContainer = OnePlayerView()
                playerView.addSubview(playerContainer!)
                break
            case 2:
                playerContainer = TwoPlayerView()
                playerView.addSubview(playerContainer!)
                break
            case 3:
                playerContainer = ThreePlayerView()
                playerView.addSubview(playerContainer!)
                break
            case 4:
                playerContainer = FourPlayerView()
                playerView.addSubview(playerContainer!)
                break
            default:
                return
            }
        }
        
        refreshView()
    }

    private func refreshView() {
        label_pointsScored.text = "0"
        navItem.title = snapshot?.getDescription()
        
        if !online {
            if App.game!.getWinner() != nil {
                performSegue(withIdentifier: Segues.InGame_PostGame, sender: self)
                return
            }
            
            switch App.game!.players.count {
            case 1:
                (playerContainer as! OnePlayerView).refreshView(snapshot: self.snapshot!.players[0])
                break
            case 2:
                (playerContainer as! TwoPlayerView).refreshView(snapshots: snapshot!.players)
                break
            case 3:
                (playerContainer as! ThreePlayerView).refreshView(snapshots: snapshot!.players)
                break
            case 4:
                (playerContainer as! FourPlayerView).refreshView(snapshots: snapshot!.players)
                break
            default:
                return
            }
        } else {
            if self.snapshot?.status == .FINISHED {
                performSegue(withIdentifier: Segues.InGame_PostGame, sender: self)
                return
            }
            
            switch self.snapshot?.players.count {
            case 2:
                (playerContainer as! TwoPlayerView).refreshView(snapshots: snapshot!.players)
                break
            case 3:
                (playerContainer as! ThreePlayerView).refreshView(snapshots: snapshot!.players)
                break
            case 4:
                (playerContainer as! FourPlayerView).refreshView(snapshots: snapshot!.players)
                break
            default:
                return
            }
        }
    }
    
}


// Contains UserEventHandling
extension InGameViewController {
    
    func onExit() {
        performSegue(withIdentifier: Segues.InGame_Home, sender: self)
    }
    
    func onStats() {
        performSegue(withIdentifier: Segues.Ingame_Stats, sender: self)
    }
    
    func onUndo() {
        /*
        if App.game!.undoThrow() {
            refreshView()
        }
        */
    }
    
    func onPerformThrow() {
        var pointsLeft: Int
        var points: Int
        
        if online {
            pointsLeft = snapshot!.getCurrentTurn()!.pointsLeft!
            points = Int(label_pointsScored.text!)!
        } else {
            pointsLeft = App.game!.getCurrentTurn().pointsLeft!
            points = Int(label_pointsScored.text!)!
        }
        
        
        if ThrowValidator.isThreeDartFinish(points: pointsLeft) {
            // TODO logic to show Details Screen
            performSegue(withIdentifier: Segues.InGame_CheckoutDetails, sender: self)
        } else {
            if online {
                PlayService.performThrow(t: Throw(points: points, dartsOnDouble: 0, dartsThrown: 3))
            } else {
                if App.game!.performThrow(t: Throw(points: points, dartsOnDouble: 0, dartsThrown: 3)) {
                    refreshView()
                }
            }
        }
    }
    
    func onDigit(digit: Int) {
        var pointsLeft: Int
        if online {
            pointsLeft = snapshot!.getCurrentTurn()!.pointsLeft!
        } else {
            pointsLeft = App.game!.getCurrentTurn().pointsLeft!
        }
       
        let currentPoints = label_pointsScored.text!
    
        if currentPoints == "0" {
            switch digit {
                case 1:
                    label_pointsScored.text = "1"
                    return
                case 2:
                    label_pointsScored.text = "2"
                    return
                case 3:
                    label_pointsScored.text = "3"
                    return
                case 4:
                    label_pointsScored.text = "4"
                    return
                case 5:
                    label_pointsScored.text = "5"
                    return
                case 6:
                    label_pointsScored.text = "6"
                    return
                case 7:
                    label_pointsScored.text = "7"
                    return
                case 8:
                    label_pointsScored.text = "8"
                    return
                case 9:
                    label_pointsScored.text = "9"
                    return
                default:
                    return
    
            }
        }
        
        let nextPointsString = label_pointsScored.text! + String(digit)
        let nextPoints = Int(nextPointsString)!
        
        if nextPoints > 180 || ((pointsLeft - nextPoints) < 2 && pointsLeft != nextPoints) {
            return
        }
        
        label_pointsScored.text = nextPointsString
    }
    
    func onCheck() {
        let pointsLeft = App.game!.getCurrentTurn().pointsLeft!
        if ThrowValidator.isThreeDartFinish(points: pointsLeft) {
            label_pointsScored.text = String(pointsLeft)
            // TODO logic to show Details Screen
            performSegue(withIdentifier: Segues.InGame_CheckoutDetails, sender: self)
        }
    }
    
    func onDelete() {
        let currentPoints = label_pointsScored.text!
        
        if currentPoints.count == 1 {
            label_pointsScored.text = "0"
            return
        }
    
        if currentPoints != "0" {
            label_pointsScored.text = String(currentPoints.dropLast())
        }
    }
    
}

extension InGameViewController: PlayServiceDelegate {
    
    func onSnapshot(snapshot: SnapshotPacket) {
        self.snapshot = snapshot.snapshot
        refreshView()
    }
}

extension InGameViewController: DimissManager {
    
    func onDismiss() {
        refreshView()
    }

}

