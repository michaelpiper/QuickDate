//
//  OnlineUserCollectionItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import SDWebImage
/// This collectionCell is actually pro user not Online
class OnlineUserCollectionItem: UICollectionViewCell {
    
    // MARK: - Views
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    // MARK: - Properties
    var user: UserProfileSettings? {
        didSet {
            usernameLabel.text = (user?.first_name ?? "") + " " + (user?.last_name ?? "") //user?.username
            if (usernameLabel.text?.trim() ?? "").isEmpty {
                usernameLabel.text = user?.username
            }
            let avatarURL = URL(string: user?.avatar ?? "")
            self.profileImage.sd_setImage(with: avatarURL, placeholderImage: .thumbnail)
        }
    }
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        //   profileImage.borderColorV = Theme.primaryEndColor.colour
    }
    
    func bind(_ object:[String:Any]){
        let user = object["user"] as? [String:Any]
        let firstName = user?["first_name"] as? String
        let lastName = user?["last_name"] as? String
        let username = user?["username"] as? String
        let avater = user?["avater"] as? String
        if firstName == "" && lastName  == ""{
            self.usernameLabel.text = username ?? ""
        }else{
            self.usernameLabel.text =  "\(firstName ?? "") \(firstName ?? "")"
        }
        let url = URL(string: avater ?? "")
        self.profileImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
    }
}

extension OnlineUserCollectionItem: NibReusable {}
