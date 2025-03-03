//
//  CATransition+Extension.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 6.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

extension CATransition {
    func presentationStyle(type transitionType: CATransitionType, subtype from: CATransitionSubtype) {
        duration = 0.5
        timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        type = transitionType
        subtype = from
    }
}
