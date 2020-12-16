//
//  PlayerView.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 14.12.20.
//

import UIKit

class PlayerView: UIView {
    
    var players: [PlayerSnapshot]?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup() {
        guard let players = players else { return }
        
        var view: UIView?
        
        // create specific playerview depending on amount of players
        switch players.count {
         case 1:
            view = OnePlayerView()
            break
         case 2:
            view = TwoPlayerView()
            break
         case 3:
            view = ThreePlayerView()
            break
         case 4:
            view = FourPlayerView()
            break
         default:
            return
         }
        
        guard let playerView = view else { return }
        
        // add specific playerview
        addSubview(playerView)
        
        // add Constraints to make specific playerview fit
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        playerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        playerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        playerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    func refresh() {
        guard let players = players else { return }
        
        // refresh playerview depending on amount of players
        switch players.count {
         case 1:
            (self.subviews[0] as! OnePlayerView).refresh(players: players)
             break
         case 2:
            (self.subviews[0] as! TwoPlayerView).refresh(players: players)
             break
         case 3:
            (self.subviews[0] as! ThreePlayerView).refresh(players: players)
             break
         case 4:
            (self.subviews[0] as! FourPlayerView).refresh(players: players)
             break
         default:
             return
         }
    }

}
