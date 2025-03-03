//
//  ProfileGideCell.swift
//  QuickDate
//
//  Created by iMac on 10/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

class ProfileGideCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet var itemIconImage: UIImageView!
    @IBOutlet var labelItemTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewMain.cornerRadiusV = 20
        self.viewMain.addShadow()
    }
}
