//
//  ProfileViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 26.11.20.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var careerStatsTableView: UITableView!
    var items = [("Karriere Average", "0.00"), ("Karriere First 9", "0.00"), ("Karriere Doppelquote", "0.00"), ("Karriere Siege", "0"), ("Karriere Niederlagen", "0"),]

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        careerStatsTableView.dataSource = self
        careerStatsTableView.delegate = self
        careerStatsTableView.isScrollEnabled = false
    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
   /**
     override func viewDidLoad() {
         super.viewDidLoad()
         tableView.register(UINib(nibName: "CareerCell", bundle: nil), forCellReuseIdentifier: "CareerCell")
     }
     
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CareerCell", for: indexPath) as! CareerCell
        cell.keyLabel.text = items[indexPath.row].0
        cell.valueLabel.text = items[indexPath.row].1
        return cell
    }
}

