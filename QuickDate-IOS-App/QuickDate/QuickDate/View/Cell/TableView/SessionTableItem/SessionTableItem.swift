//
//  SessionTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
import Async

protocol SessionDelegate {
    func removedBtnPressed(_ sender: UIButton, indexPath: IndexPath)
}

class SessionTableItem: UITableViewCell {

    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var alphaLabel: UILabel!
    @IBOutlet weak var lastSeenlabel: UILabel!
    @IBOutlet weak var browserLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
        
    var singleCharacter :String?
    var indexPath:IndexPath?
    var delegate: SessionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(_ object: SessionData, index: IndexPath) {
        self.indexPath = index
        let os = object.os
        let platform = object.platform
        let timeText = object.timeText
        self.phoneLabel.text = "\(NSLocalizedString("Phone", comment: "Phone")) : \(os ?? "")"
        self.browserLabel.text = "\(NSLocalizedString("Browser", comment: "Browser")) : \(platform ?? "")"
        self.phoneLabel.text = "\(NSLocalizedString("Last seen", comment: "Last seen")) : \(timeText ?? "")"
        if platform == nil {
            self.alphaLabel.text = self.singleCharacter ?? ""
        }else{
            for (index, value) in (platform?.enumerated())!{
                if index == 0 {
                    self.singleCharacter = String(value)
                    break
                }
            }
            self.alphaLabel.text = self.singleCharacter ?? ""
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        if let indexPath = self.indexPath {
            self.delegate?.removedBtnPressed(sender, indexPath: indexPath)
        }
    }
}

