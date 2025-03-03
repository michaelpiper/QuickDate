//
//  InviteFriendsTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class InviteFriendsTableItem: UITableViewCell {
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.topLabel.text = NSLocalizedString("Share The Love", comment: "Share The Love")
        self.bottomLabel.text = "Share the QuickDate by inviting your friends using these"///NSLocalizedString("Share it by inviting your friends using these", comment: "Share it by inviting your friends using these")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
