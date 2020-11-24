//
//  FourPlayerView.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 12.11.20.
//

import UIKit

class FourPlayerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initView()
    }
    
    private func initView() {
        guard let view = self.loadViewFromNib(nibName: "FourPlayerView") else { return }
        self.addSubview(view)
        self.refreshView()
    }
    
    func refreshView() {
        // TODO
    }

}
