//
//  ChatSenderTableItem.swift
//  DeepSoundiOS
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class ChatSenderTableItem: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewBG: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        self.viewBG.setRoundCornersBY(corners: [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner], cornerRaduis: 12)
    }
    
    func bind(_ object: ChatModel) {
        let text = object.text
        self.titleLabel.text = text.htmlAttributedString
        let seen = object.created_at
        self.dateLabel.text = getDate(unixdate: seen, timezone: "GMT")
    }    
}
