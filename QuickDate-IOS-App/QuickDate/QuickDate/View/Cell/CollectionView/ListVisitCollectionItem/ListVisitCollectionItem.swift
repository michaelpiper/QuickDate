//
//  ListVisitCollectionItem.swift
//  QuickDate
//
//  Created by iMac on 26/07/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit

class ListVisitCollectionItem: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(_ object: UserProfileSettings) {
        var strURL = ""
        if object.avatar.contains("https") {
            strURL = object.avatar
        }else {
            strURL = object.userData?.avatar ?? ""
        }
        let url = URL(string: strURL)
        self.imageView.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        if object.first_name == "" && object.last_name == "" {
            self.lblTitle.text  = object.username
        }else {
            self.lblTitle.text = "\(object.first_name) \(object.last_name )"
        }
    }
}
