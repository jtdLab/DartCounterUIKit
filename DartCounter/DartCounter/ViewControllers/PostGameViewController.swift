//
//  PostGameViewController.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 15.11.20.
//

import UIKit

class PostGameViewController: UIViewController {

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var label_winner: UILabel!
    
    
    @IBAction func onStats(_ sender: UIButton) {
        performSegue(withIdentifier: Segues.PostGame_Stats, sender: self)
    }
    
    @IBAction func onPlayAgain(_ sender: UIButton) {
        performSegue(withIdentifier: Segues.PostGame_Home, sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    
    private func initView() {
        navItem.hidesBackButton = true
        
        label_winner.text = App.game!.getWinner()!.name + " gewinnt"
    }
    
}
