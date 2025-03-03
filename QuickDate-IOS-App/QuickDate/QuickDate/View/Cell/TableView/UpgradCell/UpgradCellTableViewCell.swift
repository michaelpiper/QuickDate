//
//  UpgradCellTableViewCell.swift
//  QuickDate
//
//  Created by iMac on 06/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

class UpgradCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var planTypeLabel: UILabel!
    @IBOutlet weak var backgroundVIew: UIView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var planNameLabel: UILabel!
    
    var vc:UpgradeAccountVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        backgroundVIew.cornerRadiusV = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func bind(_ object:UpgradeDataSetClass) {
        self.planNameLabel.text = object.planName ?? ""
        self.moneyLabel.text = object.planMoney ?? ""
        self.planTypeLabel.text = object.planTyle ?? ""
        self.backgroundVIew.backgroundColor = object.planColor
    }
}
