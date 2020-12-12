//
//  CreateGameViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 24.10.20.
//

import UIKit
import Starscream

class CreateGameViewController: UIViewController {

    var online: Bool = false
    var snapshot: GameSnapshot?
    
    @IBOutlet weak var dartBotHeader: UIView!
    @IBOutlet weak var dartBotContent: UIView!
    @IBOutlet weak var switchDartbot: UISwitch!
    @IBOutlet weak var sliderDartbotAverage: UISlider!
    @IBOutlet weak var labelDartbotAverage: UILabel!
    @IBOutlet weak var playersTableView: UITableView!
    @IBOutlet weak var segmentedStartingPoints: UISegmentedControl!
    @IBOutlet weak var segmentedGameMode: UISegmentedControl!
    @IBOutlet weak var pickerSize: UIPickerView!
    @IBOutlet weak var segmentedGameType: UISegmentedControl!
    @IBOutlet weak var advancedSettingsTableView: UITableView!
    var advancedSettingsData = ["SPRACHEINGABE", "AVERAGE ANZEIGEN", "DOPPELQUOTE ANZEIGEN"]
    @IBOutlet weak var buttonStartGame: UIButton!
    
    
    @IBAction func onDartBotChanged(_ sender: UISwitch) {
        // show or hide the dartbot picker
        if sender.isOn {
            dartBotContent.isHidden = false
        } else {
            dartBotContent.isHidden = true
        }
    }
    
    @IBAction func onDartBotAvgChanged(_ sender: UISlider) {
        // display average of dartbot
        labelDartbotAverage.text = String(Int(sliderDartbotAverage.value))
    }
    
    @IBAction func onAddPlayer(_ sender: UIButton) {
        if online {
            // TODO show invite dialog
        } else {
            // try add player and display new player if successful
            if PlayOfflineService.addPlayer() {
                playersTableView.reloadData()
            }
        }
    }
    
    @IBAction func onStartGame(_ sender: UIButton) {
        if online {
            PlayOnlineService.startGame()
        } else {
            // add a dartbot to the game with average chosen by user via ui
            let dartBotAverage = Int(labelDartbotAverage.text!) ?? 10
            if switchDartbot.isOn {
                PlayOfflineService.addDartbot(targetAverage: dartBotAverage)
            }
            
            // update game config to current values chosen by user via ui
            let mode = segmentedGameMode.selectedSegmentIndex == 0 ? GameMode.FIRST_TO : GameMode.BEST_OF
            let type = segmentedGameType.selectedSegmentIndex == 0 ? GameType.LEGS : GameType.SETS
            let size = pickerSize.selectedRow(inComponent: 0) + 1
            let startingPoints = segmentedStartingPoints.selectedSegmentIndex == 0 ? 301 : segmentedStartingPoints.selectedSegmentIndex == 1 ? 501 : 701
            let config = GameConfig(mode: mode, type: type, size: size, startingPoints: startingPoints)
            PlayOfflineService.updateGameConfig(gameConfig: config )
            PlayOfflineService.startGame()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if online {
            // subscribe to PlayOnlineService to receive events
            PlayOnlineService.delegate = self
            // hide dartbot picker because dartbot not available in an online game
            dartBotHeader.isHidden = true
            dartBotContent.isHidden = true
        } else {
            // subscribe to PlayOfflineService to receive events
            PlayOfflineService.delegate = self
            // hide dartBotContent as default (user needs to use the switch in the dartBotHeader to show it)
            switchDartbot.isOn = false
            dartBotContent.isHidden = true
        }
        
        // default startingPoints to 501
        segmentedStartingPoints.selectedSegmentIndex = 1
        
        // default gameType to singular
        segmentedGameType.setTitle("LEG", forSegmentAt: 0)
        segmentedGameType.setTitle("SET", forSegmentAt: 1)
        
        // add dataSources and delegates of tables and pickers
        playersTableView.dataSource = self
        playersTableView.delegate = self
        pickerSize.dataSource = self
        pickerSize.delegate = self
        advancedSettingsTableView.dataSource = self
        advancedSettingsTableView.delegate = self
        
        // subscribe to segmentedControl valueChanged events
        segmentedStartingPoints.addTarget(self, action: #selector(onStartingPointsChanged), for: .valueChanged)
        segmentedGameMode.addTarget(self, action: #selector(onModeChanged), for: .valueChanged)
        segmentedGameType.addTarget(self, action: #selector(onTypeChanged), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // before going to InGameView
        if segue.identifier == Segues.CreateGame_InGame, let destinationViewController = segue.destination as? InGameViewController {
            // init InGameViewController
            destinationViewController.snapshot = self.snapshot
            destinationViewController.online = online
        }
    }
    
    
    @objc func onStartingPointsChanged(sender: UISegmentedControl) {
        // check if snapshot of current game is available
        guard let snapshot = self.snapshot else { return }
        
        // current gameConfig
        let gameConfig = snapshot.config

        // change startingPoints of current gameConfig
        let startingPoints = segmentedStartingPoints.selectedSegmentIndex == 0 ? 301 : segmentedStartingPoints.selectedSegmentIndex == 1 ? 501 : 701
        gameConfig.startingPoints = startingPoints
        
        // update the gameConfig of the current game
        if online {
            PlayOnlineService.updateGameConfig(gameConfig: gameConfig)
        } else {
            PlayOfflineService.updateGameConfig(gameConfig: gameConfig)
        }
      
    }
    
    @objc func onModeChanged(sender: UISegmentedControl) {
        // check if snapshot of current game is available
        guard let snapshot = self.snapshot else { return }
        
        // current gameConfig
        let gameConfig = snapshot.config
        
        // change mode of current gameConfig
        if sender.selectedSegmentIndex == 0 {
            gameConfig.mode = .FIRST_TO
        } else if sender.selectedSegmentIndex == 1 {
            gameConfig.mode = .BEST_OF
        }
        
        // update the gameConfig of the current game
        if online {
            PlayOnlineService.updateGameConfig(gameConfig: gameConfig)
        } else {
            PlayOfflineService.updateGameConfig(gameConfig: gameConfig)
        }
    }
    
    func onSizeChanged(size: Int) {
        // check if snapshot of current game is available
        guard let snapshot = self.snapshot else { return }
        
        // current gameConfig
        let gameConfig = snapshot.config
        
        // change size of current gameConfig
        gameConfig.size = size
        
        // set segmented type titles to singular
        if size == 1 {
            segmentedGameType.setTitle("LEG", forSegmentAt: 0)
            segmentedGameType.setTitle("SET", forSegmentAt: 1)
        } else {
            segmentedGameType.setTitle("LEGS", forSegmentAt: 0)
            segmentedGameType.setTitle("SETS", forSegmentAt: 1)
        }
        
        // update the gameConfig of the current game
        if online {
            PlayOnlineService.updateGameConfig(gameConfig: gameConfig)
        } else {
            PlayOfflineService.updateGameConfig(gameConfig: gameConfig)
        }
    }
    
    @objc func onTypeChanged(sender: UISegmentedControl) {
        // check if snapshot of current game is available
        guard let snapshot = self.snapshot else { return }
        
        // current gameConfig
        let gameConfig = snapshot.config
        
        // change type of current gameConfig
        if sender.selectedSegmentIndex == 0 {
            gameConfig.type = .LEGS
        } else if sender.selectedSegmentIndex == 1 {
            gameConfig.type = .SETS
        }
        
        // update the gameConfig of the current game
        if online {
            PlayOnlineService.updateGameConfig(gameConfig: gameConfig)
        } else {
            PlayOfflineService.updateGameConfig(gameConfig: gameConfig)
        }
    }

}


// handle events from PlayOffline and PlayOnlineService
extension CreateGameViewController: PlayOfflineServiceDelegate, PlayOnlineServiceDelegate {
    
    func onCreateGameResponse(createGameResponse: CreateGameResponsePacket) {
        createGameResponse.successful ? print("Created game1") : print("Couldn't create game1")
    }
    
    func onJoinGameResponse(joinGameResponse: JoinGameResponsePacket) {
        joinGameResponse.successful ? print("Joined game1") : print("Couldn't join game1")
    }
    
    func onGameCanceled(gameCanceled: GameCanceledPacket) {
        print("Game canceled")
    }
    
    func onSnapshot(snapshot: GameSnapshot) {
        print("Snapshot received")
        
        // set current snapshot to the received snapshot
        self.snapshot = snapshot
        
        // if game is running
        if snapshot.status == .RUNNING {
            // go to InGameView
            performSegue(withIdentifier: Segues.CreateGame_InGame, sender: self)
        }
        
        // if this client doesn't own the game
        if snapshot.ownerUsername != UserService.currentProfile?.username {
            // disable controlls
            segmentedStartingPoints.isUserInteractionEnabled = false
            segmentedGameMode.isUserInteractionEnabled = false
            pickerSize.isUserInteractionEnabled = false
            segmentedGameType.isUserInteractionEnabled = false
            
            // hide startGame button
            buttonStartGame.isHidden = true
        }
        
        // ** display the new config ** //
        // display startingPoints
        let startingPoints = snapshot.config.startingPoints
        if startingPoints == 301 {
            segmentedStartingPoints.selectedSegmentIndex = 0
        } else if startingPoints == 501 {
            segmentedStartingPoints.selectedSegmentIndex = 1
        } else if startingPoints == 701 {
            segmentedStartingPoints.selectedSegmentIndex = 2
        }
        // display mode
        let mode = snapshot.config.mode
        if mode == .FIRST_TO {
            segmentedGameMode.selectedSegmentIndex = 0
        } else if mode == .BEST_OF {
            segmentedGameMode.selectedSegmentIndex = 1
        }
        
        // display size
        let size = snapshot.config.size
        pickerSize.selectRow(size-1, inComponent: 0, animated: true)
        
        // display type
        let type = self.snapshot?.config.type
        if type == .LEGS {
            segmentedGameType.selectedSegmentIndex = 0
        } else if type == .SETS {
            segmentedGameType.selectedSegmentIndex = 1
        }
        
        // display player
        playersTableView.constraints[0].constant = CGFloat(self.snapshot!.players.count * 50)
        playersTableView.reloadData()
    }
    
    func onPlayerExited(playerExited: PlayerExitedPacket) {
        print(playerExited.username + " exited the game")
    }
    
    func onPlayerJoined(playerJoined: PlayerJoinedPacket) {
        print(playerJoined.username + " joined the game")
    }
    
}


// delegate and dataSource of playersTable and advancedSettingsTable
extension CreateGameViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case playersTableView:
            return snapshot?.players.count ?? 0
        case advancedSettingsTableView:
            return advancedSettingsData.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case playersTableView:
            let cell :PlayerCell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerCell
            cell.label_name.text = snapshot?.players[indexPath.row].name
            return cell
        case advancedSettingsTableView:
            let property = advancedSettingsData[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "advancedSettingsCell", for: indexPath) as! AdvancedSettingsCell
            cell.propertyLabel.text = property
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}


// delegate and dataSource of pickerSize
extension CreateGameViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row+1)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onSizeChanged(size: row+1)
    }
}
