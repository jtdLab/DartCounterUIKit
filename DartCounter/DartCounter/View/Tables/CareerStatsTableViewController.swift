//
//  CareerStatsTableViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 27.11.20.
//

import UIKit

class CareerStatsTableViewController: UITableViewController {
        
    var items = [("Karriere Average", "0.00"), ("Karriere First 9", "0.00"), ("Karriere Doppelquote", "0.00"), ("Karriere Siege", "0"), ("Karriere Niederlagen", "0"),]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CareerCell", bundle: nil), forCellReuseIdentifier: "CareerCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CareerCell", for: indexPath) as! CareerCell
        cell.keyLabel.text = items[indexPath.row].0
        cell.valueLabel.text = items[indexPath.row].1
        return cell
    }
}
