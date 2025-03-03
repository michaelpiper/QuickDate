//
//  ContactCell.swift
//  Playtube
//
//  Created by iMac on 03/07/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit

protocol ContactSendDelegate {
    func sendBtnAction(_ sender: UIButton, _ indexPath: IndexPath)
}

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!

    var delegate: ContactSendDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func sendBtnAction(_ sender: UIButton) {
        if let indexPath = indexPath {
            self.delegate?.sendBtnAction(sender, indexPath)
        }
    }
    
}
