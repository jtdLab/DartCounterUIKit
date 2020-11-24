//
//  PlayerView.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 11.11.20.
//

import UIKit

class PlayerView: UIView {
    
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var label_playerName: UILabel!
    
    @IBOutlet weak var label_pointsLeft: UILabel!
    
    @IBOutlet weak var label_lastThrow: UILabel!
    
    @IBOutlet weak var label_average: UILabel!
    
    @IBOutlet weak var label_checkout: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initView()
    }
    
    private func initView() {
        guard let view = self.loadViewFromNib(nibName: "PlayerView") else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }

}


