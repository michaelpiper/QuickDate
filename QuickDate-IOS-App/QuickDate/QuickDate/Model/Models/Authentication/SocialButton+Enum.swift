//
//  SocialButton+Enum.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 8.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

/// Handle type safety and provide clean code.
/// SocialButton enum is created to handle the tag values of social buttons
/// in authentication screens
enum SocialButton: Int {
    case apple
    case facebook
    case google
    case woWonder
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0:  self = .apple
        case 1:  self = .facebook
        case 2:  self = .google
        case 3:  self = .woWonder
        default: return nil
        }
    }
}
