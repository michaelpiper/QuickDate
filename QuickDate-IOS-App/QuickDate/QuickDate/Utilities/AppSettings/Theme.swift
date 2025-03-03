//
//  Theme.swift
//  Market Storm
//
//  Created by Nazmi Yavuz on 20.11.2021.
//  Copyright © 2021 ScriptSun. All rights reserved.
//

import UIKit

// MARK: - DynamicColor
struct DynamicColor {
    
    let light: String
    let dark: String
    
    var value: UIColor {
        return light.toUIColor() | dark.toUIColor()
    }
}
// MARK: - ColorSettings
protocol ColorSettings {
    var adminSelectedHexValuesOfColors: DynamicColor { get }
}

// MARK: - Theme

/// Custom Theme properties to be handled by admin
///
/// - Tag: Theme
enum Theme {
    
    // MARK: - Primary
    case primaryStartColor
    case primaryEndColor
    
    // MARK: NavBar
    case navBarIconColor
    case navBarTitleColor
    
    // MARK: Screen
    case primaryBackgroundColor
    case secondaryBackgroundColor
    
    // MARK: Text
    case primaryTextColor
    case secondaryTextColor
    
    // MARK: - Button
    case buttonBackgroundStart
    case buttonBackgroundEnd
    case buttonText
    
    // MARK: TabBar
    case tabBarBackgroundColor
    case tabBarIconAndTextColor
    
    var colour: UIColor {
        return adminSelectedHexValuesOfColors.value
    }
}
