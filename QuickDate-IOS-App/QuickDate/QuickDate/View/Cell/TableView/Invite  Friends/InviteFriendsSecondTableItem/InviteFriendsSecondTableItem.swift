//
//  InviteFriendsSecondTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class InviteFriendsSecondTableItem: UITableViewCell {
    
    @IBOutlet var iconBackgroundView: UIView!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configView(row: Int) {
        iconBackgroundView.circleView()
        if row == 1 {
            titleLabel.text = NSLocalizedString("Copy Profile Link", comment: "Copy Profile Link")
            iconBackgroundView.backgroundColor = .Main_StartColor
            iconImage.image = UIImage(named: "copy_link_ic")
        } else if row == 3 {
            titleLabel.text = NSLocalizedString("Social Media Invite", comment: "Social Media Invite")
            iconImage.image = UIImage(named: "icn_share_fill")
            iconBackgroundView.backgroundColor = UIColor(red: 29/255, green: 127/255, blue: 229/255, alpha: 1.0)
        }else {
            titleLabel.text = "Text Invite"//NSLocalizedString("Social Media Invite", comment: "Social Media Invite")
            iconImage.image = UIImage(named: "icn_message")
            iconBackgroundView.backgroundColor = .systemIndigo
        }
    }
}
