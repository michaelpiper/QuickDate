//
//  SettingsSectionTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun All rights reserved.
//

import UIKit

class SettingsSectionTableItem: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var viewMain: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.cornerRadiusV = 12
        viewMain.addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
