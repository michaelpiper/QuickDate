//
//  ChatScreenTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class ChatScreenTableItem: UITableViewCell {
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var textMsgLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var viewMessgaeCount: UIView!
    @IBOutlet weak var viewSetOnlineOffline: UIImageView!
    @IBOutlet weak var lblTotalMsgCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.circleView()
        viewMessgaeCount.circleView()
        viewSetOnlineOffline.circleView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(_ object: ChatConversationModel) {
        if object.new_messages != 0 {
            viewMessgaeCount.isHidden = false
            lblTotalMsgCount.text = "\(object.new_messages)"
        } else {
            viewMessgaeCount.isHidden = true
        }
        let milisecond = object.user?.lastseen ?? "0"
        let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(milisecond)!/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if dateVar == Date() {
            viewSetOnlineOffline.backgroundColor = UIColor.hexStringToUIColor(hex: "47D017")
        } else {
            viewSetOnlineOffline.backgroundColor = UIColor.hexStringToUIColor(hex: "BDBDBD")
        }
        print(dateFormatter.string(from: dateVar))
        if object.user?.first_name == "" && object.user?.last_name  == "" {
            self.userNameLabel.text = object.user?.username ?? ""
        } else {
            self.userNameLabel.text = "\(object.user?.first_name ?? "") \(object.user?.last_name ?? "")"
        }
        self.timeLabel.text = object.time
        let url = URL(string: object.user?.avatar ?? "")
        self.avatarImageView.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
        if object.message_type == "media" {
            self.textMsgLabel.text = "Photo"
            self.iconImage.isHidden = false
            self.iconImage.image = UIImage(named: "chatIconImage")
        } else if object.message_type == "sticker" {
            self.textMsgLabel.text = "sticker"
            self.iconImage.isHidden = false
            self.iconImage.image = UIImage(named: "icn_smile")
        } else if object.message_type == "text" {
            self.textMsgLabel.text = object.text.htmlAttributedString
            self.iconImage.isHidden = true
        }
    }
}
