//
//  SettingsViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 26.11.20.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    var items = ["SPRACHE"]

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.isScrollEnabled = false
    }

}


extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.titleLable.text = items[indexPath.row]
        return cell
    }
}
