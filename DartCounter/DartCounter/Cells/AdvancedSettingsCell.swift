//
//  AdvancedSettingsCell.swift
//  DartCounter
//
//  Created by Jonas Schlauch on 25.10.20.
//

import UIKit

class AdvancedSettingsCell: UITableViewCell {

    
    @IBOutlet weak var propertyLabel: UILabel!
    
    @IBOutlet weak var `switch`: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setProperty(property: String) {
        propertyLabel.text = property
    }
}
