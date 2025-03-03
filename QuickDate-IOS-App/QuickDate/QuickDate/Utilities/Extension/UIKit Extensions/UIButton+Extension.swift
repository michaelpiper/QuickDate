//
//  UIButton+Extension.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 3.01.2022.
//  Copyright © 2022 Lê Việt Cường. All rights reserved.
//

import UIKit

extension UIButton {
    
    func animShow() {
        UIButton.animate(withDuration: 2, delay: 0, options: [.curveEaseIn],
                         animations: {
            self.center.y -= self.bounds.height
            self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    
    func animHide() {
        UIButton.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                         animations: {
            self.center.y += self.bounds.height
            self.layoutIfNeeded()
            
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = true
        })
    }
    
    func attributedTitleForAuthScreens(_ firstText: String, firstColor: UIColor,
                                       _ secondText: String, secondColor: UIColor) {
        // First Part
        let firstFont = Typography.regularText(size: 11).font
        let atts: [NSAttributedString.Key: Any] = [
            .foregroundColor: firstColor,
            .font: firstFont
        ]
        let attributedTitle = NSMutableAttributedString(string: "\(firstText) ", attributes: atts)
        // Second Part
        let secondFont = Typography.boldTitle(size: 11).font
        let boldAtts: [NSAttributedString.Key: Any] = [
            .foregroundColor: secondColor,
            .font: secondFont
        ]
        attributedTitle.append(NSAttributedString(string: secondText, attributes: boldAtts))
        setAttributedTitle(attributedTitle, for: .normal)
    }
}
