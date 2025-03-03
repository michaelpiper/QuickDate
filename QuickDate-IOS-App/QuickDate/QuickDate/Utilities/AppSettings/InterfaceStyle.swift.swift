//
//  InterfaceStyle.swift.swift
//  Market Storm
//
//  Created by Nazmi Yavuz on 22.11.2021.
//  Copyright © 2021 ScriptSun. All rights reserved.
//

import Foundation

enum InterfaceStyle {
    case light
    case dark
    
    init(rawInt: Int) {
        switch rawInt {
        case 2:     self = .dark
        default :   self = .light
        }
    }
}
