//
//  AboutUsViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 26.11.20.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var aboutUsTableView: UITableView!
    
    var items = ["SOCIAL MEDIA", "IMPRESSUM", "DATENSCHUTZ", "SPRACHE"]

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        aboutUsTableView.dataSource = self
        aboutUsTableView.delegate = self
        aboutUsTableView.isScrollEnabled = false
    }

}

extension AboutUsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutUsCell", for: indexPath) as! AboutUsCell
        cell.titleLabel.text = items[indexPath.row]
        return cell
    }
}

