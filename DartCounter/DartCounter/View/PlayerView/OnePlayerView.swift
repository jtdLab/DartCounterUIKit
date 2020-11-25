//
//  OnePlayerView.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 12.11.20.
//

import UIKit

class OnePlayerView: UIView {
    
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_sets: UILabel!
    @IBOutlet weak var label_legs: UILabel!
    @IBOutlet weak var label_pointsLeft: UILabel!
    @IBOutlet weak var label_lastThrow: UILabel!
    @IBOutlet weak var label_dartsThrown: UILabel!
    @IBOutlet weak var label_average: UILabel!
    @IBOutlet weak var label_checkoutPercentage: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initView()
    }
    
    private func initView() {
        guard let view = self.loadViewFromNib(nibName: "OnePlayerView") else { return }
        self.addSubview(view)
        self.refreshView()
    }
    
    func refreshView() {
        let player = App.game!.players[0]
        label_name.text = player.name
        label_sets.text = "S: " + String(player.sets ?? -1)
        label_legs.text = "L: " + String(player.legs!)
        label_pointsLeft.text = String(player.pointsLeft!)
        label_lastThrow.text = String(player.lastThrow ?? -1)
        label_dartsThrown.text = String(player.dartsThrown!)
        
        if App.settings.showAverage {
            label_average.text = String(player.average!)
        } else {
            label_average.isHidden = true
        }
        
        if App.settings.showCheckoutPercentage {
            label_checkoutPercentage.text = String(player.checkoutPercentage!)
        } else {
            label_checkoutPercentage.isHidden = true
        }
    }

}
