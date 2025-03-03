//
//  UIStackView+Extension.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 10.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

extension UIStackView {

    func removeAllArrangedSubviews() {

        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }

        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))

        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
