//
//  UINavigationBar+Extension.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 3.01.2022.
//  Copyright © 2022 Lê Việt Cường. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}
