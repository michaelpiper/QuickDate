//
//  UserTagViewCell.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/14/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class UserTagViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    var explanation: String? {
        didSet {
            if let text = explanation {
                let arr = text.components(separatedBy: ",")
                self.keywordArray = arr
            }
        }
    }
    
    var keywordArray: [String] = [] {
        didSet {
            self.setupTagListView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.titleLabel.isHidden = titleText == nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupTagListView() {
        tagListView.removeAllTags()
        tagListView.alignment = .leading
        let array = keywordArray.filter({$0 != ""})
        tagListView.addTags(array)
    }
}

extension UserTagViewCell: NibReusable {}
