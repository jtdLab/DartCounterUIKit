//
//  CreateGameViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 24.10.20.
//

import UIKit
import Starscream

class CreateOfflineGameViewController: UIViewController {

    @IBOutlet weak var switchDartbot: UISwitch!
    @IBOutlet weak var dartBotView: UIView!
    @IBOutlet weak var sliderDartbotAverage: UISlider!
    @IBOutlet weak var labelDartbotAverage: UILabel!
    @IBOutlet weak var playerTableView: UITableView!
    @IBOutlet weak var segmentedStartingScore: UISegmentedControl!
    @IBOutlet weak var segmentedGameMode: UISegmentedControl!
    @IBOutlet weak var pickerSize: UIPickerView!
    @IBOutlet weak var segmentedGameType: UISegmentedControl!
    @IBOutlet weak var advancedSettingsTableView: UITableView!
    var advancedSettingsData = ["SPRACHEINGABE", "AVERAGE ANZEIGEN", "DOPPELQUOTE ANZEIGEN"]

    
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
        if segue.identifier == Segues.CreateOfflineGame_InGame, let viewController = segue.destination as? InGameViewController {
            // TODO
        }
    }
    
    
    private func initView() {
        switchDartbot.isOn = false
        dartBotView.isHidden = true
        
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
extension CreateOfflineGameViewController {
    
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
        if App.game!.addPlayer() {
            playerTableView.constraints[0].constant += 50
            playerTableView.reloadData()
        }
    }
    
    func onStartGame() {
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
            self.performSegue(withIdentifier: Segues.CreateOfflineGame_InGame, sender: self)
        }
    }
    
}

extension CreateOfflineGameViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case playerTableView:
            return App.game!.players.count
        case advancedSettingsTableView:
            return advancedSettingsData.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case playerTableView:
            let cell :PlayerCell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerCell
            cell.label_name.text = App.game!.players[indexPath.row].name
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


extension CreateOfflineGameViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
