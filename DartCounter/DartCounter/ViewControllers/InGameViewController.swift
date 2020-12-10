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
        // go to HomeView
        performSegue(withIdentifier: Segues.InGame_Home, sender: self)
    }
    
    @IBAction func onStats(_ sender: Any) {
        // go to StatsView
        performSegue(withIdentifier: Segues.Ingame_Stats, sender: self)
    }
    
    @IBAction func onUndo(_ sender: UIButton) {
        // undo throw
        if online {
            PlayOnlineService.undoThrow()
        } else {
            PlayOfflineService.undoThrow()
        }
    }
    
    @IBAction func onPerform(_ sender: UIButton) {
        // check if snapshot of current game is available
        guard let snapshot = self.snapshot else { return }
        
        let pointsLeft = snapshot.getCurrentTurn()!.pointsLeft!
        let points = Int(label_pointsScored.text!)!
        
        // TODO rest of method
        if ThrowValidator.isThreeDartFinish(points: pointsLeft) {
            // TODO logic to show Details Screen
            performSegue(withIdentifier: Segues.InGame_CheckoutDetails, sender: self)
        } else {
            // TODO rework playoffline performthrow
            if online {
                PlayOnlineService.performThrow(t: Throw(points: points, dartsOnDouble: 0, dartsThrown: 3))
                // TODO
            } else {
                if PlayOfflineService.performThrow(t: Throw(points: points, dartsOnDouble: 0, dartsThrown: 3)) {
                    refreshView()
                }
            }
        }
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
        // TODO whole method
        if online {
            // TODO
        } else {
            PlayOfflineService.performCheck(onSuccess: { pointsChecked in
                self.label_pointsScored.text = String(pointsChecked)
                // TODO logic to show Details Screen
                self.performSegue(withIdentifier: Segues.InGame_CheckoutDetails, sender: self)
            })
        }
    }
    
    @IBAction func onZero(_ sender: UIButton) {
        onDigit(digit: 0)
    }
    
    @IBAction func onDelete(_ sender: UIButton) {
        let currentPoints = label_pointsScored.text!
        
        // reset pointsScored to 0 if it contains only 1 digit
        if currentPoints.count == 1 {
            label_pointsScored.text = "0"
            return
        }
    
        // remove last digit from pointsScored
        if currentPoints != "0" {
            label_pointsScored.text = String(currentPoints.dropLast())
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if online {
            // subscribe to PlayOnlineService to receive events
            PlayOnlineService.delegate = self
        } else {
            // subscribe to PlayOfflineService to receive events
            PlayOfflineService.delegate = self
        }
        
        // dont show backButton
        navItem.hidesBackButton = true
        
        // check if snapshot of current game is available
        guard let snapshot = self.snapshot else { return }
        
        // init title with description
        navItem.title = snapshot.getDescription().uppercased()
        
        switch snapshot.players.count {
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
        
        refreshView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // before going to HomeView
        if segue.identifier == Segues.InGame_Home, let destinationViewController  = segue.destination as? HomeViewController {
            // TODO
        }
        // before going to CheckoutDetailsView
        else if segue.identifier == Segues.InGame_CheckoutDetails, let destinationViewController  = segue.destination as? CheckoutDetailsViewController {
            // init CheckoutDetailsViewController
            destinationViewController.online = online
            
            if online {
                // TODO
            } else {
                // TODO
                //destinationViewController.delegate = self
                //destinationViewController.pointsLeft = 301 //App.game!.getCurrentTurn().pointsLeft!
                //destinationViewController.pointsScored = Int(label_pointsScored.text!)!
            }
        }
        // before going to StatsView
        else if segue.identifier == Segues.Ingame_Stats, let destinationViewController  = segue.destination as? StatsViewController {
            // TODO
        }
        // before going to PostGameView
        else if segue.identifier == Segues.InGame_PostGame, let destinationViewController  = segue.destination as? PostGameViewController {
            // init PostGameViewController
            // send winner to postgameview
            //destinationViewController.snapshot = self.snapshot
        }
    }

    func refreshView() {
        // reset pointScored to 0
        label_pointsScored.text = "0"
        
        // check if snapshot of current game is available
        guard let snapshot = self.snapshot else { return }
        
        // if game is finished
        if snapshot.status == .FINISHED {
            performSegue(withIdentifier: Segues.InGame_PostGame, sender: self)
            return
        }
        
        // display players
        switch snapshot.players.count {
        // display one player
        case 1:
            (playerContainer as! OnePlayerView).refreshView(snapshot: snapshot.players[0])
            break
        // display two player
        case 2:
            (playerContainer as! TwoPlayerView).refreshView(snapshots: snapshot.players)
            break
        // display three player
        case 3:
            (playerContainer as! ThreePlayerView).refreshView(snapshots: snapshot.players)
            break
        // display four player
        case 4:
            (playerContainer as! FourPlayerView).refreshView(snapshots: snapshot.players)
            break
        default:
            return
        }
    }
    
    func onDigit(digit: Int) {
        // check if snapshot of current game is available
        guard let snapshot = self.snapshot else { return }
        
        // the points the current player has left
        let pointsLeft = snapshot.getCurrentTurn()!.pointsLeft!
        // the points the player wants to perform a throw with
        let pointsScored = label_pointsScored.text!
    
        // if pointsScord is 0 set pointsScored to digit
        if pointsScored == "0" {
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
        
        // temp var containing the number which pointsScored would contain if the digit would be appended
        let nextPoints = Int(label_pointsScored.text! + String(digit))!
        
        // validate nextPoints if valid set pointsScored to nextPoints
        if !(nextPoints > 180 || ((pointsLeft - nextPoints) < 2 && pointsLeft != nextPoints)) {
            label_pointsScored.text = String(nextPoints)
        }
    }
    
}


// handle events from PlayOffline and PlayOnlineService
extension InGameViewController: PlayOfflineServiceDelegate, PlayOnlineServiceDelegate {
    
    func onSnapshot(snapshot: GameSnapshot) {
        print("Snapshot received")
        
        // set current snapshot to the received snapshot
        self.snapshot = snapshot
        
        // if game is finished go to PostGameView
        if snapshot.status == .FINISHED {
            performSegue(withIdentifier: Segues.InGame_PostGame, sender: self)
        }
        
        // refresh the ui
        refreshView()
    }
}

extension InGameViewController: CheckoutDetailsDismissHandler {
    
    func handleDismiss() {
        // refresh the ui
        refreshView()
    }

}

