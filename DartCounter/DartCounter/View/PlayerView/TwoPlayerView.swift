//
//  TwoPlayerView.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 12.11.20.
//

import UIKit

class TwoPlayerView: UIView, NibLoadable {
    
    @IBOutlet weak var label_player1_name: UILabel!
    @IBOutlet weak var label_player1_sets: UILabel!
    @IBOutlet weak var label_player1_legs: UILabel!
    @IBOutlet weak var label_player1_pointsLeft: UILabel!
    @IBOutlet weak var label_player1_lastThrow: UILabel!
    @IBOutlet weak var label_player1_dartsThrown: UILabel!
    @IBOutlet weak var label_player1_average: UILabel!
    @IBOutlet weak var label_player1_checkoutPercentage: UILabel!

    @IBOutlet weak var label_player2_name: UILabel!
    @IBOutlet weak var label_player2_sets: UILabel!
    @IBOutlet weak var label_player2_legs: UILabel!
    @IBOutlet weak var label_player2_pointsLeft: UILabel!
    @IBOutlet weak var label_player2_lastThrow: UILabel!
    @IBOutlet weak var label_player2_dartsThrown: UILabel!
    @IBOutlet weak var label_player2_average: UILabel!
    @IBOutlet weak var label_player2_checkoutPercentage: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }
    
    func refreshView(snapshots: [PlayerSnapshot]) {
        let player1 = snapshots[0]
        let player2 = snapshots[1]
        
        if player1.isNext! {
            // TODO
        } else {
            // TODO
        }
        
        if player2.isNext! {
            // TODO
        } else {
            // TODO
        }
        
        label_player1_name.text = player1.name
        label_player1_sets.text = "S: " + String(player1.sets ?? -1)
        label_player1_legs.text = "L: " + String(player1.legs!)
        label_player1_pointsLeft.text = String(player1.pointsLeft!)
        label_player1_lastThrow.text = String(player1.lastThrow ?? -1)
        label_player1_dartsThrown.text = String(player1.dartsThrown!)
        
        label_player2_name.text = player2.name
        label_player2_sets.text = "S: " + String(player2.sets ?? -1)
        label_player2_legs.text = "L: " + String(player2.legs!)
        label_player2_pointsLeft.text = String(player2.pointsLeft!)
        label_player2_lastThrow.text = String(player2.lastThrow ?? -1)
        label_player2_dartsThrown.text = String(player2.dartsThrown!)
        
        
        if App.settings.showAverage {
            label_player1_average.text = String(player1.average!)
            label_player2_average.text = String(player2.average!)
        } else {
            label_player1_average.isHidden = true
            label_player2_average.isHidden = true
        }
        
        if App.settings.showCheckoutPercentage {
            label_player1_checkoutPercentage.text = String(player1.checkoutPercentage!)
            label_player2_checkoutPercentage.text = String(player2.checkoutPercentage!)
        } else {
            label_player1_checkoutPercentage.isHidden = true
            label_player2_checkoutPercentage.isHidden = true
        }
    }

}
