//
//  CommentTableViewCell.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 7.02.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit
import SDWebImage

class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Views
    @IBOutlet weak var publisherImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    // MARK: - Properties
    
    var comment: Comment? {
        didSet {
            publisherImageView.sd_setImage(
                with: comment?.publisher.avatarURL, placeholderImage: .unisexAvatar)
            fullNameLabel.text = comment?.publisher.fullName
            commentLabel.text = comment?.text.html2AttributedString
            
        }
    }
    
    // MARK: - LifeCycle
    
    // first loading func
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}

extension CommentTableViewCell: NibReusable {}
