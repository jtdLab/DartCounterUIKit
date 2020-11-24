//
//  CreateOnlineGameViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 09.11.20.
//

import UIKit

class CreateOnlineGameViewController: UIViewController {
    
    private enum Constants {
        static let InGameSegue = "createOnlineGame_inGame"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onStartGame(_ sender: UIButton) {
        self.performSegue(withIdentifier: Constants.InGameSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.InGameSegue, let viewController = segue.destination as? InGameViewController {
          // TODO
        }
    }
    

}
