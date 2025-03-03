//
//  Theme+Extension.swift
//  Market Storm
//
//  Created by Nazmi Yavuz on 22.11.2021.
//  Copyright © 2021 ScriptSun. All rights reserved.
//

import UIKit

// MARK: - UIView
extension UIView {
    /// Set background color of related view
    /// - Parameter themeColor: [Theme](x-source-tag://Theme)
    func setThemeBackgroundColor(_ themeColor: Theme) {
        self.backgroundColor = themeColor.colour
    }
}

// MARK: - UIButton
extension UIButton {
    
    /// Set [Theme](x-source-tag://Theme) colors of related UIButton
    /// - Parameters:
    ///   - background: Background color
    ///   - themeColor: Tint color
    ///   - title: Button attributed title
    ///   - typography: [Typography](x-source-tag://Typography) for admin choice
    func setTheme(background: Theme? = nil,
                  tint themeColor: Theme? = nil,
                  title: String? = nil,
                  font typography: Typography? = nil) {
        if let themeColor = themeColor {
            self.tintColor = themeColor.colour
        }
        if let background = background {
            self.backgroundColor = background.colour
        }
        
        if let title = title {
            var attributedString: NSAttributedString {
                switch typography {
                case .none:
                    return NSAttributedString(string: title)
                case .some(let typography):
                    return NSAttributedString(string: title, attributes: [
                        NSAttributedString.Key.font: typography.font
                    ])
                }
            }
            self.setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    /// Set [Theme](x-source-tag://Theme) colors of related UIButton
    /// - Parameters:
    ///   - background: Background color
    ///   - tintColor: Tint color
    ///   - title: Button attributed title
    ///   - typography: [Typography](x-source-tag://Typography) for admin choice
    func setProperties(background: UIColor? = nil,
                       tint tintColor: UIColor? = nil,
                       title: String? = nil,
                       font typography: Typography? = nil) {
        if let tintColor = tintColor {
            self.tintColor = tintColor
        }
        if let background = background {
            self.backgroundColor = background
        }
        
        if let title = title {
            var attributedString: NSAttributedString {
                switch typography {
                case .none:
                    return NSAttributedString(string: title)
                case .some(let typography):
                    return NSAttributedString(string: title, attributes: [
                        NSAttributedString.Key.font: typography.font
                    ])
                }
            }
            self.setAttributedTitle(attributedString, for: .normal)
        }
    }
    
}

// MARK: - UILabel
extension UILabel {
    
    /// Set textColor of related UILabel according to [Theme](x-source-tag://Theme)
    /// and font type according to [Typography](x-source-tag://Typography)
    /// - Parameters:
    ///   - text: Text which is seen by user
    ///   - color: Text Color
    ///   - font: Text Font
    func setTheme(text: String? = nil,
                  themeColor: Theme? = nil,
                  font: Typography? = nil) {
        if let text = text {
            self.text = text
        }
        if let themeColor = themeColor {
            self.textColor = themeColor.colour
        }
        if let font = font {
            self.font = font.font
        }
    }
    
    /// Set textColor of related UILabel
    /// and font type according to [Typography](x-source-tag://Typography)
    /// - Parameters:
    ///   - text: Text which is seen by user
    ///   - color: Text Color
    ///   - font: Text Font
    func setProperties(text: String? = nil,
                       textColor: UIColor? = nil,
                       font: Typography? = nil) {
        if let text = text {
            self.text = text
        }
        if let textColor = textColor {
            self.textColor = textColor
        }
        if let font = font {
            self.font = font.font
        }
    }
}

// MARK: - UINavigationBar
extension UINavigationBar {
    
    /// Set UINavigationBar barTintColor and tintColor according to
    ///  [Theme](x-source-tag://Theme)
    /// - Parameters:
    ///   - barTint: BarTintColor of the related NavBar
    ///   - tint: TintColor of the related NavBar
    func setTheme(barTint: Theme, tint: Theme) {
        self.isTranslucent = false
        self.barTintColor = barTint.colour
        self.tintColor = tint.colour
        self.shadowImage = UIImage()
    }
}

// MARK: - UIImageView
extension UIImageView {
    
    ///  Set UIImageView tintColor according to [Theme](x-source-tag://Theme)
    /// - Parameter tint: TintColor of the related ImageView
    func setThemeTintColor(_ tint: Theme) {
        self.tintColor = tint.colour
    }
}

// MARK: - UITextField
extension UITextField {
    
    /// Set textColor of related UITextField according to [Theme](x-source-tag://Theme)
    /// and font type according to [Typography](x-source-tag://Typography)
    /// - Parameters:
    ///   - color: Text Color
    ///   - font: Text Font
    func setTheme(_ color: Theme? = nil, _ font: Typography? = nil) {
        if let color = color {
            self.textColor = color.colour
        }
        if let font = font {
            self.font = font.font
        }
    }
}
