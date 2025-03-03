//
//  CGFloat+Extension.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 15.02.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

extension CGFloat {
    
    /// Control equality
    /// - Parameter list: [Double]
    /// - Returns: boolean value true or false
    func controlEqualityAny(_ list: [CGFloat]) -> Bool {
        for number in list where number == self {
            return true
        }
        return false
    }
    
}
