//
//  AddFriendViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 16.12.20.
//

import UIKit

class AddFriendViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        FriendService.addFriend(uid: "DAVID")
       
    }

}
