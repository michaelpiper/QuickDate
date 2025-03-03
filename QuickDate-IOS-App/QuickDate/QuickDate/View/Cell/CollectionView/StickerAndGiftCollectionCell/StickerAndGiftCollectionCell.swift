//
//  StickerAndGiftCollectionCell.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 27.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit
import SDWebImage

class StickerAndGiftCollectionCell: UICollectionViewCell {
    
    // Views
    @IBOutlet weak var stickerImageView: UIImageView!
    
    // Properties
    var stickerLink: String? {
        didSet {
            guard let stickerLink = stickerLink else {
                Logger.error("getting sticker link"); return
            }
            let url = URL(string: stickerLink)
            let indicator = SDWebImageActivityIndicator.medium
            self.stickerImageView.sd_imageIndicator = indicator
            DispatchQueue.global(qos: .userInteractive).async {
                self.stickerImageView.sd_setImage(with: url, placeholderImage: .thumbnail)
            }
        }
    }
    
    // MARK: - LifeCycle -
    // first loading func
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

extension StickerAndGiftCollectionCell: NibReusable {}
