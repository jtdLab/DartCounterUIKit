//
//  SearchUserViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 23.12.20.
//

import UIKit

class SearchUserViewController: UIViewController {
    
    @IBOutlet weak var textField_search: StandardTextField!
    @IBOutlet weak var tableView_friends: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // hide keyboard if touched screen somewhere outside of keyboard area
        self.hideKeyboardWhenTappedAround()
        
        textField_search.addTarget(self, action: #selector(onEditingChanged), for: .editingChanged)
    }
    
    @objc func onEditingChanged(sender: UITextField) {
        guard let text = sender.text else { return }
        
        // TODO search users in db and display them depending on text
    }

}
