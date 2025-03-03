//
//  BuyCreditSectionTwoCollectionItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class BuyCreditSectionTwoCollectionItem: UICollectionViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var chargeLabel: UILabel!
    @IBOutlet weak var ammountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // add shadow on cell
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.systemGray.cgColor
        
        // add corner radius on `contentView`
       // contentView.backgroundColor = Theme.secondaryBackgroundColor.colour
        viewMain.layer.cornerRadius = 16
    }
    
    func bind(_ object:dataSetTwo){
        self.ammountLabel.text = object.Credit
        self.chargeLabel.text = object.ammount
        self.titleLabel.text = object.title ?? ""
        self.itemImage.image = object.itemImage
    }
    
}
