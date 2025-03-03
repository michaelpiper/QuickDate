//
//  ShowBlogSectionOneTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit

class ShowBlogSectionOneTableItem: UITableViewCell {

    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func bind(_ object:[String:Any]){
        let title = object["title"] as? String
        let thumbnail = object["thumbnail"] as? String
        self.titleLabel.text = title?.htmlAttributedString ?? ""
        let url = URL(string: thumbnail ?? "")
               self.thumbImage.sd_setImage(with: url, placeholderImage: R.image.thumbnail())
    }
}
