//
//  UpgradeAccountCollectionItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class UpgradeAccountCollectionItem: UICollectionViewCell {
    
    @IBOutlet weak var planTypeLabel: UILabel!
    @IBOutlet weak var backgroundVIew: UIView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var planNameLabel: UILabel!
    
    var vc:UpgradeAccountVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func bind(_ object:UpgradeDataSetClass){
        self.planNameLabel.text = object.planName ?? ""
        self.moneyLabel.text = object.planMoney ?? ""
        self.planTypeLabel.text = object.planTyle ?? ""
        self.backgroundVIew.backgroundColor = object.planColor
    }
    
}
