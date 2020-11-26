//
//  CreateOnlineGameViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import UIKit

class CreateOnlineGameViewController: UIViewController {
    
    var snapshot: GameSnapshot?
    
    @IBOutlet weak var playerTableView: UITableView!
    @IBOutlet weak var segmentedStartingScore: UISegmentedControl!
    @IBOutlet weak var segmentedGameMode: UISegmentedControl!
    @IBOutlet weak var pickerSize: UIPickerView!
    @IBOutlet weak var segmentedGameType: UISegmentedControl!
    @IBOutlet weak var advancedSettingsTableView: UITableView!
    var advancedSettingsData = ["SPRACHEINGABE", "AVERAGE ANZEIGEN", "DOPPELQUOTE ANZEIGEN"]
    
    
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
        if segue.identifier == Segues.CreateOnlineGame_InGame, let viewController = segue.destination as? InGameViewController {
          // TODO
        }
    }
    
    
    private func initView() {
        PlayService.delegate = self
        PlayService.createGame()
        
        segmentedStartingScore.selectedSegmentIndex = 1
        
        playerTableView.dataSource = self
        playerTableView.delegate = self
        
        pickerSize.dataSource = self
        pickerSize.delegate = self
        
        advancedSettingsTableView.dataSource = self
        advancedSettingsTableView.delegate = self
    }
    
}

// Contains UserEventHandling
extension CreateOnlineGameViewController {
    
    func onAddPlayer() {
        
    }
    
    func onStartGame() {
        self.performSegue(withIdentifier: Segues.CreateOnlineGame_InGame, sender: self)
    }
    
}

extension CreateOnlineGameViewController: PlayServiceDelegate {
     
    func onCreateGameResponse(createGameResponse: CreateGameResponsePacket) {
        createGameResponse.successful ? print("Created game1") : print("Couldn't create game1")
    }
    
    func onJoinGameResponse(joinGameResponse: JoinGameResponsePacket) {
        joinGameResponse.successful ? print("Joined game1") : print("Couldn't join game1")
    }
    
    func onGameCanceled(gameCanceled: GameCanceledPacket) {
        print("Game canceled1")
    }
    
    func onGameStarted(gameStarted: GameStartedPacket) {
        print("Game started1")
    }
    
    func onSnapshot(snapshot: SnapshotPacket) {
        self.snapshot = snapshot.snapshot
        playerTableView.reloadData()
    }
    
    func onPlayerExited(playerExited: PlayerExitedPacket) {
        print(playerExited.username + " exited the game1")
    }
    
    func onPlayerJoined(playerJoined: PlayerJoinedPacket) {
        print(playerJoined.username + " joined the game1")
    }
    
}

extension CreateOnlineGameViewController: UITableViewDataSource, UITableViewDelegate {
    
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


extension CreateOnlineGameViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row+1)
    }
    
}
