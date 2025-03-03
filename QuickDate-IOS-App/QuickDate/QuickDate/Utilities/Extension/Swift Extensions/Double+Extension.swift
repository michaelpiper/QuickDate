//
//  Double+Extension.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 3.02.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

extension Double {
    func toString(with scientificNotation: Int) -> String {
        return String(format: "%.\(scientificNotation)f", self)
    }
}

extension Float {
    func toString(with scientificNotation: Int) -> String {
        return String(format: "%.\(scientificNotation)f", self)
    }
}
