//
//  PeopleILikeCollectionItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

protocol PeopleLikeDelegate {
    func pressedLikedBtn(_ sender: UIButton, id: Int, index: Int)
}

class PeopleILikeCollectionItem: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var delegate: PeopleLikeDelegate?
    var id:Int? = 0
    var indexpath:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImage.circleView()
    }
    
    func bind(_ object: UserProfileSettings, index: Int) {
        var strURL = ""
        if object.avatar.contains("https") {
            strURL = object.avatar
        }else {
            strURL = object.userData?.avatar ?? ""
        }
        let url = URL(string: strURL)
        let date = Date(timeIntervalSince1970: TimeInterval(object.lastseen) ?? 0)
        self.dateLabel.text = Date().timeAgo(from: date)//setTimestamp(epochTime: object.lastseen)
//        self.dateLabel.text = setTimestamp(epochTime: object.lastseen)
        self.profileImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        if object.first_name == "" && object.last_name == "" {
            self.usernameLabel.text  = object.username
        }else{
            self.usernameLabel.text = "\(object.first_name) \(object.last_name)"
        }
        self.id = Int(object.id)
        self.indexpath = index
    }
    
    @IBAction func disHeartPressed(_ sender: UIButton) {
        if let id = id {
            self.delegate?.pressedLikedBtn(sender, id: id, index: self.indexpath)
        }
    }
}
