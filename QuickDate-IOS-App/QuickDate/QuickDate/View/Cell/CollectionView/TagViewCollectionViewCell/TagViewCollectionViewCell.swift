//
//  TagViewCollectionViewCell.swift
//  QuickDate
//
//  Created by iMac on 17/07/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit

class TagViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textLabel.text = nil
        self.layer.cornerRadius = 15.0
        self.layer.borderWidth = 1.5
        let color = ColorGenerator.shared.randomColor()
        textLabel.textColor = color.fg
        self.layer.borderColor = color.fg.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = nil
    }
}
