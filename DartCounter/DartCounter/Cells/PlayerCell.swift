//
//  PlayersViewCell.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 10.11.20.
//

import UIKit

class PlayerCell: UITableViewCell {

    @IBOutlet weak var label_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
