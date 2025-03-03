//
//  LiverUserCollectionViewCell.swift
//  QuickDate
//
//  Created by iMac on 09/08/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit
import SDWebImage

class LiverUserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblKm: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(_ randomUser: LiveUserModel) {
        let thumbnailURL = URL.init(string: randomUser.user_data?.avatar ?? "")
        let indicator = SDWebImageActivityIndicator.medium
        self.thumbImageView.sd_imageIndicator = indicator
        DispatchQueue.global(qos: .userInteractive).async {
            self.thumbImageView.sd_setImage(with: thumbnailURL, placeholderImage:R.image.imagePlacholder())
        }
        self.lblTitle.text = "\(randomUser.user_data?.fullname ?? ""), \(randomUser.user_data?.age ?? 0)"
        self.lblKm.text = randomUser.user_data?.lastseen_txt
    }
    
}
