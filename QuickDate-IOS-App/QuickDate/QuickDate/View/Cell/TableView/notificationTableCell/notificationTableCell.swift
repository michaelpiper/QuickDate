//
//  notificationTableCell.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import SDWebImage

class notificationTableCell: UITableViewCell {
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var notifyContentLabel: UILabel!
    @IBOutlet var notifyTypeIcon: UIImageView!
    
    var notification: AppNotification? {
        didSet {
            guard let notification = notification else { Logger.error("getting user"); return }
            
         //   self.notifyTypeIcon.backgroundColor = .Main_StartColor
            //let image: UIImage? = notification.type == .visit ? .eyeFillCustom : .heartFillCustom
          //  notifyTypeIcon.image = image
            // notificationLabel
            let type = notification.type
            let text: String =
            type == .gotNewMatch ? "You got a new match, click to view!".localized :
            type == .visit ? "Visit you" .localized :
            type == .like ? "Like you" .localized :
            type == .dislike ? "Dislike you" .localized :
            type == .friendAccept ? "Is now in your friend list" .localized
            : "Requested to be a friend with you" .localized
            notifyContentLabel.text = text
            avatarImageView.sd_setImage(with: notification.notifierUser.avatarURL,
                                        placeholderImage: .unisexAvatar)
            self.userLabel.text = notification.notifierUser.fullname
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.notifyTypeIcon.backgroundColor = .Main_StartColor
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension notificationTableCell: NibReusable {}
