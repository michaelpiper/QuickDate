//
//  UserHairCell.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/14/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

// TODO: If it's not necessary then delete it before release
class UserHairCell: UITableViewCell {

    @IBOutlet var heightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UserHairCell: NibReusable {}
