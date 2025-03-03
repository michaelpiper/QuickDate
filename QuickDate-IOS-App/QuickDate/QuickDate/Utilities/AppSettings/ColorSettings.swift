//
//  ColorSettings.swift
//  Market Storm
//
//  Created by Nazmi Yavuz on 19.11.2021.
//  Copyright © 2021 ScriptSun. All rights reserved.
//

import UIKit

// MARK: - Color Settings

extension Theme: ColorSettings {
    // You can change Hex values in terms of your choices.
    // These values will affect colors of all application.
    internal var adminSelectedHexValuesOfColors: DynamicColor {
        switch self {
            // MARK: - Primary Color
        case .primaryStartColor:        return DynamicColor(light: "5C1856", dark: "5C1856")
            
        case .primaryEndColor:          return DynamicColor(light: "FF007F", dark: "FF007F")
        
            // MARK: - NavBar
        case .navBarIconColor:          return DynamicColor(light: "F5F5F5", dark: "F7F7F7")
            
        case .navBarTitleColor:         return DynamicColor(light: "FFFFFF", dark: "F7F7F7")
    
            // MARK: - Screen
        case .primaryBackgroundColor:   return DynamicColor(light: "F6F6F6", dark: "232323")
    
        case .secondaryBackgroundColor: return DynamicColor(light: "FFFFFF", dark: "000000")
            
            // MARK: - Text
        case .primaryTextColor:         return DynamicColor(light: "212121", dark: "D6D6D6")
            
        case .secondaryTextColor:       return DynamicColor(light: "424242", dark: "929292")
            
            // MARK: - Button
        case .buttonBackgroundStart:    return DynamicColor(light: "50164B", dark: "50164B")
            
        case .buttonBackgroundEnd:      return DynamicColor(light: "901D84", dark: "901D84")

        case .buttonText:               return DynamicColor(light: "FFF8FF", dark: "AAA7AA")
            
            // MARK: - TabBar
        case .tabBarBackgroundColor:    return DynamicColor(light: "FFFFFF", dark: "101010")
            
        case .tabBarIconAndTextColor:   return DynamicColor(light: "000000", dark: "A3A3A3")
            
        }
    }
    
}
