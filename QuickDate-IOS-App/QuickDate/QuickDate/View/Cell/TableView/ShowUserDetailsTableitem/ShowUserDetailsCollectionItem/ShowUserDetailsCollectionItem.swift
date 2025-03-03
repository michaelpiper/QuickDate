//
//  ShowUserDetailsCollectionItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class ShowUserDetailsCollectionItem: UICollectionViewCell {
    
    @IBOutlet weak var showImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(_ url: URL?) {
//        let url = URL(string: object ?? "")
        self.showImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
    }
}

extension ShowUserDetailsCollectionItem: NibReusable {}
