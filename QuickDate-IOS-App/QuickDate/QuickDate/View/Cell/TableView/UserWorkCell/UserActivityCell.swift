//
//  UserActivityCell.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/14/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class UserActivityCell: UITableViewCell {

    @IBOutlet var headingCell: UILabel!
    @IBOutlet var textsLabel: UILabel!
    
    var titleText: String? {
        didSet {
            headingCell.text = titleText
        }
    }
    
    var otherUser: OtherUser? {
        didSet {
            if let otherUser = otherUser {
                var introText = ""
                introText = showCountry(of: otherUser)
                introText += otherUser.userDetails.profile.description
                if otherUser.userDetails.favourites.description != "" {
                    introText += "\n\(otherUser.userDetails.favourites.description)"
                }
                self.textsLabel.text = introText
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func showCountry(of otherUser: OtherUser) -> String {
        return "I'm from \(otherUser.userDetails.country_txt). "
    }
}

extension UserActivityCell: NibReusable {}
