//
//  PostGameViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 15.11.20.
//

import UIKit

class PostGameViewController: UIViewController {
    
    var snapshot: GameSnapshot?

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var imageView_WinOrLoose: UIImageView!
    @IBOutlet weak var label_winner: UILabel!
    
    
    @IBAction func onStats(_ sender: UIButton) {
        performSegue(withIdentifier: Segues.PostGame_Stats, sender: self)
    }
    
    @IBAction func onPlayAgain(_ sender: UIButton) {
        performSegue(withIdentifier: Segues.PostGame_Home, sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dont show backButton
        navItem.hidesBackButton = true

        guard let snapshot = self.snapshot else { return }
        
        guard let winner = snapshot.getWinner() else { return }
        
        guard let username = UserService.user?.profile.username else { return }
        
        let won = username == winner.name!
        
        imageView_WinOrLoose.image = won ? UIImage(named: "winner") : UIImage(named: "defeat")
        
        label_winner.text = won ? "Gewonnen" : "Verloren"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
