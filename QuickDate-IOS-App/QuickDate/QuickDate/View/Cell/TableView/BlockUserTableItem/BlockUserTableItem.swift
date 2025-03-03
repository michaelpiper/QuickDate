//
//  BlockUserTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

protocol UnblockUserDelegate {
    func unblockBtnPressed(_ sender: UIButton)
}

class BlockUserTableItem: UITableViewCell {
    
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet weak var unblockBtn: UIButton!
    
    var delegate: UnblockUserDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func unblockBtnAction(_ sender: UIButton) {
        self.delegate?.unblockBtnPressed(sender)
    }
            
    func bind(_ object: UserProfileSettings?) {
        if let object = object {
            let username = object.username
            let firstName = object.first_name
            let lastName = object.last_name
            if firstName == "" && lastName  == "" {
                self.userNameLabel.text = username
            }else{
                self.userNameLabel.text = "\(firstName ) \(lastName )"
            }
            let url = URL(string: object.avatar)
            self.avatarImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        }
    }
}
