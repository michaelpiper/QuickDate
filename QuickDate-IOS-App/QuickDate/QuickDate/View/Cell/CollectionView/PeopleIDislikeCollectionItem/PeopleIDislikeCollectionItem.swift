//
//  PeopleIDislikeCollectionItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async
import QuickDateSDK

protocol PeopleDisLikeDelegate {
    func pressedDisLikedBtn(_ sender: UIButton, id: Int, index: Int)
}

class PeopleIDislikeCollectionItem: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var delegate: PeopleDisLikeDelegate?
    var id:Int? = 0
    var indexpath:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImage.circleView()
    }
    
    /*func bind(_ object:[String:Any],index:Int ){
        let id = object["id"] as? Int
        let lastSeen = object["lastseen"] as? Int
        let userData = object["userData"] as? [String:Any]
        let avater = userData?["avater"] as? String
        let firstName = userData?["first_name"] as? String
        let lastName = userData?["last_name"] as? String
        let username = userData?["username"] as? String
        let url = URL(string: avater ?? "")
        self.dateLabel.text = setTimestamp(epochTime: String(lastSeen ?? 0 ))
        self.profileImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        self.id = id ?? 0
        self.indexpath = index
        if firstName ?? "" == "" && lastName  == "" ?? "" {
            self.usernameLabel.text  = username ?? ""
        }else{
            self.usernameLabel.text = "\(firstName ?? "") \(lastName ?? "")"
        }
    }*/
    
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
            self.delegate?.pressedDisLikedBtn(sender, id: id, index: self.indexpath)
        }
    }
}
