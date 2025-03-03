//
//  GetPremiumStickerCell.swift
//  QuickDate
//
//  Created by iMac on 08/08/23.
//  Copyright © 2023 ScriptSun. All rights reserved.
//

import UIKit

protocol GetPremiumStickerDelegate {
    func getBtnAction(_ sender: UIButton)
    func buyCreditsBtnAction(_ sender: UIButton)
}

class GetPremiumStickerCell: UICollectionViewCell {
    
    @IBOutlet weak var getBtn: UIButton!
    @IBOutlet weak var buyCreditBtn: UIButton!
    
    var delegate: GetPremiumStickerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func getBtnAction(_ sender: UIButton) {
        self.delegate?.getBtnAction(sender)
    }
    
    @IBAction func buyCreditsBtnAction(_ sender: UIButton) {
        self.delegate?.buyCreditsBtnAction(sender)
    }    
}

extension GetPremiumStickerCell: NibReusable {}
