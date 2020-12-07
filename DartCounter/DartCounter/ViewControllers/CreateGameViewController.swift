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
    @IBOutlet weak var dartBotView: UIView!
    @IBOutlet weak var sliderDartbotAverage: UISlider!
    @IBOutlet weak var labelDartbotAverage: UILabel!
    @IBOutlet weak var playerTableView: UITableView!
    @IBOutlet weak var segmentedStartingScore: UISegmentedControl!
    var startingScoreData = [301, 501, 701]
    @IBOutlet weak var segmentedGameMode: UISegmentedControl!
    var gameModeData = ["FIRST TO", "BEST OF"]
    @IBOutlet weak var pickerSize: UIPickerView!
    @IBOutlet weak var segmentedGameType: UISegmentedControl!
    var gameTypeData = ["LEGS", "SETS"]
    @IBOutlet weak var advancedSettingsTableView: UITableView!
    var advancedSettingsData = ["SPRACHEINGABE", "AVERAGE ANZEIGEN", "DOPPELQUOTE ANZEIGEN"]
    @IBOutlet weak var buttonStartGame: UIButton!
    
    
    @IBAction func onDartBotChanged(_ sender: UISwitch) {
        onDartBotChanged(isOn: sender.isOn)
    }
    
    @IBAction func onDartBotAvgChanged(_ sender: UISlider) {
        onDartBotAvgChanged()
    }
    
    @IBAction func onAddPlayer(_ sender: UIButton) {
        onAddPlayer()
    }
    
    @IBAction func onStartGame(_ sender: UIButton) {
       onStartGame()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.CreateGame_InGame, let viewController = segue.destination as? InGameViewController {
            viewController.snapshot = self.snapshot
            viewController.online = online
        }
    }
    
    private func initView() {
        if online {
            PlayService.delegate = self
            PlayService.createGame()
            dartBotHeader.isHidden = true
            dartBotContent.isHidden = true
        } else {
            App.game = Game(player: Player(name: UserService.currentProfile!.username))
            switchDartbot.isOn = false
            dartBotView.isHidden = true
        }
        
        segmentedStartingScore.selectedSegmentIndex = 1
        
        playerTableView.dataSource = self
        playerTableView.delegate = self
        
        pickerSize.dataSource = self
        pickerSize.delegate = self
        
        advancedSettingsTableView.dataSource = self
        advancedSettingsTableView.delegate = self
        
        segmentedStartingScore.addTarget(self, action: #selector(onStartingPointsChanged), for: .valueChanged)
        segmentedGameMode.addTarget(self, action: #selector(onModeChanged), for: .valueChanged)
        segmentedGameType.addTarget(self, action: #selector(onTypeChanged), for: .valueChanged)
    }
    
    @objc func onStartingPointsChanged(sender: UISegmentedControl) {
        guard let config = snapshot?.config else { return }
        
        config.startingPoints = startingScoreData[sender.selectedSegmentIndex]
        
        if online {
            PlayService.updateGameConfig(gameConfig: config)
        } else {
            // TODO
        }
      
    }
    
    @objc func onModeChanged(sender: UISegmentedControl) {
        guard let config = snapshot?.config else { return }
        
        if sender.selectedSegmentIndex == 0 {
            config.mode = .FIRST_TO
        } else if sender.selectedSegmentIndex == 1 {
            config.mode = .BEST_OF
        }
        
        if online {
            PlayService.updateGameConfig(gameConfig: config)
        } else {
            // TODO
        }
    }
    
    func onSizeChanged(size: Int) {
        guard let config = snapshot?.config else { return }
        
        config.size = size
        
        if online {
            PlayService.updateGameConfig(gameConfig: config)
        } else {
            // TODO
        }
    }
    
    @objc func onTypeChanged(sender: UISegmentedControl) {
        guard let config = snapshot?.config else { return }
        
        if sender.selectedSegmentIndex == 0 {
            config.type = .LEGS
        } else if sender.selectedSegmentIndex == 1 {
            config.type = .SETS
        }
        
        if online {
            PlayService.updateGameConfig(gameConfig: config)
        } else {
            // TODO
        }
    }

}

// Contains UserEventHandling
extension CreateGameViewController {
    
    func onDartBotChanged(isOn: Bool) {
        if isOn {
            dartBotView.isHidden = false
        } else {
            dartBotView.isHidden = true
        }
    }
    
    func onDartBotAvgChanged() {
        labelDartbotAverage.text = String(Int(sliderDartbotAverage.value))
    }
    
    func onAddPlayer() {
        if online {
            // TODO
        } else {
            if App.game!.addPlayer() {
                playerTableView.constraints[0].constant += 50
                playerTableView.reloadData()
            }
        }
    }
    
    func onStartGame() {
        if online {
            PlayService.startGame()
        } else {
            let dartBotAverage = Int(labelDartbotAverage.text!) ?? 10
            
            if switchDartbot.isOn {
                App.game!.addDartBot(targetAverage: dartBotAverage)
            }
            let mode = segmentedGameMode.selectedSegmentIndex == 0 ? GameMode.FIRST_TO : GameMode.BEST_OF
            let type = segmentedGameType.selectedSegmentIndex == 0 ? GameType.LEGS : GameType.SETS
            let size = pickerSize.selectedRow(inComponent: 0) + 1
            let startingPoints = segmentedStartingScore.selectedSegmentIndex == 0 ? 301 : segmentedStartingScore.selectedSegmentIndex == 1 ? 501 : 701
            
            App.game!.config = GameConfig(mode: mode, type: type, size: size, startingPoints: startingPoints)
            if App.game!.start() {
                self.performSegue(withIdentifier: Segues.CreateGame_InGame, sender: self)
            }
        }
    }
    
}

extension CreateGameViewController: PlayServiceDelegate {
    
    func onCreateGameResponse(createGameResponse: CreateGameResponsePacket) {
        createGameResponse.successful ? print("Created game1") : print("Couldn't create game1")
    }
    
    func onJoinGameResponse(joinGameResponse: JoinGameResponsePacket) {
        joinGameResponse.successful ? print("Joined game1") : print("Couldn't join game1")
    }
    
    func onGameCanceled(gameCanceled: GameCanceledPacket) {
        print("Game canceled")
    }
    
    func onGameStarted(gameStarted: GameStartedPacket) {
        print("Game started")
    }
    
    func onSnapshot(snapshot: SnapshotPacket) {
        self.snapshot = snapshot.snapshot
        print("Snapshot received")
        if self.snapshot?.status == .RUNNING {
            performSegue(withIdentifier: Segues.CreateGame_InGame, sender: self)
        }
       
        if self.snapshot?.ownerUsername != UserService.currentProfile?.username {
            // Disable controlls
            segmentedStartingScore.isUserInteractionEnabled = false
            segmentedGameMode.isUserInteractionEnabled = false
            pickerSize.isUserInteractionEnabled = false
            segmentedGameType.isUserInteractionEnabled = false
            
            buttonStartGame.isHidden = true
        }
        
        let startingPoints = self.snapshot?.config.startingPoints
        if startingPoints == 301 {
            segmentedStartingScore.selectedSegmentIndex = 0
        } else if startingPoints == 501 {
            segmentedStartingScore.selectedSegmentIndex = 1
        } else if startingPoints == 701 {
            segmentedStartingScore.selectedSegmentIndex = 2
        }
        
        let mode = self.snapshot?.config.mode
        if mode == .FIRST_TO {
            segmentedGameMode.selectedSegmentIndex = 0
        } else if mode == .BEST_OF {
            segmentedGameMode.selectedSegmentIndex = 1
        }
        
        
        let size = self.snapshot!.config.size
        pickerSize.selectRow(size-1, inComponent: 0, animated: true)
        
        let type = self.snapshot?.config.type
        if type == .LEGS {
            segmentedGameType.selectedSegmentIndex = 0
        } else if type == .SETS {
            segmentedGameType.selectedSegmentIndex = 1
        }
        
        playerTableView.constraints[0].constant = CGFloat(self.snapshot!.players.count * 50)
        playerTableView.reloadData()
    }
    
    func onPlayerExited(playerExited: PlayerExitedPacket) {
        print(playerExited.username + " exited the game")
    }
    
    func onPlayerJoined(playerJoined: PlayerJoinedPacket) {
        print(playerJoined.username + " joined the game")
    }
    
}

extension CreateGameViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case playerTableView:
            return snapshot?.players.count ?? 0
        case advancedSettingsTableView:
            return advancedSettingsData.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case playerTableView:
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
