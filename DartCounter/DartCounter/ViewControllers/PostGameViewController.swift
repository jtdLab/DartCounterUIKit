//
//  PostGameViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 15.11.20.
//

import UIKit

class PostGameViewController: UIViewController {
    
    private enum Constants {
        static let PlayAgainSegue = "postGame_createGame"
    }

    @IBOutlet weak var label_winner: UILabel!
    
    
    @IBAction func onStats(_ sender: UIButton) {
        
    }
    
    @IBAction func onPlayAgain(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.PlayAgainSegue, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label_winner.text = App.game!.getWinner()!.name + " gewinnt"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
