//
//  HotOrNotTableItem.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 5/28/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class HotOrNotTableItem: UITableViewCell {
    @IBOutlet weak var HotImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func hotPressed(_ sender: Any) {
    }
    @IBAction func notPressed(_ sender: Any) {
    }
}
