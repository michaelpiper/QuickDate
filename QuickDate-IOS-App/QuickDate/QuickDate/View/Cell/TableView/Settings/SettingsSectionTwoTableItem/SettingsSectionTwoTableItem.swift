//
//  SettingsSectionTwoTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class SettingsSectionTwoTableItem: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var viewMain: UIView!
    // @IBOutlet var subTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.cornerRadiusV = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
