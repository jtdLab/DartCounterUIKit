//
//  SettingsViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 26.11.20.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    var items = [("SPRACHE", "de")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register SettingsCell to SettingsTable
        settingsTableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        
        // set datasource and delegate of tableview
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        
        // disable scroll of tableview
        settingsTableView.isScrollEnabled = false
    }

}


extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // specify number of rows
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // specify view of settings cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        cell.label_title.text = items[indexPath.row].0
        cell.imageView_icon.image = UIImage(named: items[indexPath.row].1)
        return cell
    }
}
