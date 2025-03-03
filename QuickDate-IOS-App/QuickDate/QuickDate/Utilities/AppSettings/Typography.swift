//
//  Typography.swift
//  Market Storm
//
//  Created by Nazmi Yavuz on 21.11.2021.
//  Copyright © 2021 ScriptSun. All rights reserved.
//

import UIKit

// MARK: - ColorSettings
protocol FontSettings {
    var adminFont: String { get }
}

// MARK: - Theme

/// Font values to be handled by Admin
/// - Tag: Typography
enum Typography {
    
    case navBarTitle(size: CGFloat)
    
    case boldTitle(size: CGFloat)
    
    case semiBoldTitle(size: CGFloat)
    
    case mediumTitle(size: CGFloat)

    case regularText(size: CGFloat)
    
    case lightText(size: CGFloat)
    
    case buttonTitle(size: CGFloat)
    
    var font: UIFont {
        
        switch self {
            
        case .navBarTitle(let navBar):
            return UIFont(name: adminFont, size: navBar) ?? .systemFont(ofSize: navBar, weight: .semibold)
            
        case .boldTitle(let boldSize):
            return UIFont(name: adminFont, size: boldSize) ?? .systemFont(ofSize: boldSize, weight: .bold)
        
        case .semiBoldTitle(let titleSize):
            return UIFont(name: adminFont, size: titleSize) ?? .systemFont(ofSize: titleSize, weight: .semibold)
            
        case .mediumTitle(let mediumSize):
            return UIFont(name: adminFont, size: mediumSize) ?? .systemFont(ofSize: mediumSize, weight: .medium)
            
        case .regularText(let regularSize):
            return UIFont(name: adminFont, size: regularSize) ?? .systemFont(ofSize: regularSize, weight: .regular)
            
        case .lightText(let lightSize):
            return UIFont(name: adminFont, size: lightSize) ?? .systemFont(ofSize: lightSize, weight: .light)
            
        case .buttonTitle(let buttonSize):
            return UIFont(name: adminFont, size: buttonSize) ?? .systemFont(ofSize: buttonSize, weight: .semibold)
            
        }
    }
}
