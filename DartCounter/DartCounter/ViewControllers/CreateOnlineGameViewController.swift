//
//  CreateOnlineGameViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import UIKit

class CreateOnlineGameViewController: UIViewController {
    
    @IBAction func onStartGame(_ sender: UIButton) {
        self.performSegue(withIdentifier: Segues.CreateOnlineGame_InGame, sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.CreateOnlineGame_InGame, let viewController = segue.destination as? InGameViewController {
          // TODO
        }
    }
    

}
