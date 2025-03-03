//
//  FavoriteCollectionItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

protocol FavoriteDelegate {
    func pressedUnFavoriteBtn(_ sender: UIButton, id: Int, index: Int)
}

class FavoriteCollectionItem: UICollectionViewCell {
    
    @IBOutlet var avtImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var unFavButton: UIButton!
    
    var delegate: FavoriteDelegate?
    var id:Int? = 0
    var indexPath:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.unFavButton.setTitle(NSLocalizedString("UnFavorite", comment: "UnFavorite"), for: .normal)
//        unFavButton.setTitleColor(.Button_StartColor, for: .normal)
//        unFavButton.borderColorV = .Button_StartColor
//        self.avtImageView.circleView()
    }
    
    func bind(_ object: UserProfileSettings, index: Int) {
        var strURL = ""
        if object.avatar.contains("https") {
            strURL = object.avatar
        }else {
            strURL = object.userData?.avatar ?? ""
        }
        let url = URL(string: strURL)
        self.avtImageView.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        if object.first_name == "" && object.last_name == "" {
            self.userNameLabel.text  = object.username
        }else{
            self.userNameLabel.text = "\(object.first_name) \(object.last_name)"
        }
        self.id = Int(object.id)
        self.indexPath = index
    }
    
    @IBAction func unFavButtonAction(_ sender: UIButton) {
        if let id = id {
            self.delegate?.pressedUnFavoriteBtn(sender, id: id, index: self.indexPath)
        }
    }
}
