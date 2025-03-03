//
//  UIColorExtensions.swift
//  Movie App
//
//  Created by iMac on 16/3/23.
//

import UIKit

//MARK: - Random Color Generator
class ColorGenerator {
    static let shared = ColorGenerator()
    
    private var last: UIColor
    private var lastForgound: UIColor
    var backgroundColors: [UIColor] = [UIColor.hexStringToUIColor(hexStr: "FF007F").withAlphaComponent(0.05),
                                       UIColor.hexStringToUIColor(hexStr: "BF00FF").withAlphaComponent(0.05),
                                       UIColor.hexStringToUIColor(hexStr: "47D017").withAlphaComponent(0.05)]
    var forgroudnColors: [UIColor] = [UIColor.hexStringToUIColor(hexStr: "FF007F"),
                                      UIColor.hexStringToUIColor(hexStr: "BF00FF"),
                                      UIColor.hexStringToUIColor(hexStr: "47D017")]

    private init() {
        let random = Int(arc4random_uniform(UInt32(backgroundColors.count)))
        self.last = backgroundColors[random]
        self.lastForgound = forgroudnColors[random]
        backgroundColors.remove(at: random)
        forgroudnColors.remove(at: random)
    }
    
    func randomColor() -> (bg: UIColor, fg: UIColor) {
        let random = Int(arc4random_uniform(UInt32(backgroundColors.count)))
        swap(&backgroundColors[random], &last)
        swap(&forgroudnColors[random], &lastForgound)
        //return background and forground color
        return (bg: last, fg: lastForgound)
    }
    
}

extension UIColor {
    class func hexStringToUIColor (hexStr: String) -> UIColor {
        var cString:String = hexStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
    
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }

    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let (red, green, blue, _) = rgba
        return (red, green, blue)
    }
    
    // neither of the following computed static properties can be made stored property - their current values need to computed at the time of accesing them
    public static var colorPickerBorderColor: UIColor {
        return pickColorForMode(lightModeColor: #colorLiteral(red: 0.7089999914, green: 0.7089999914, blue: 0.7089999914, alpha: 1), darkModeColor: #colorLiteral(red: 0.4203212857, green: 0.4203212857, blue: 0.4203212857, alpha: 1))
    }
    
    public static var colorPickerLabelTextColor: UIColor {
        return pickColorForMode(lightModeColor: #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1), darkModeColor: #colorLiteral(red: 0.6395837665, green: 0.6395837665, blue: 0.6395837665, alpha: 1))
    }
    
    public static var colorPickerLightBorderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.200000003)
    public static var colorPickerThumbViewWideBorderColor: UIColor {
      return pickColorForMode(lightModeColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6999999881), darkModeColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5995928578))
    }
    
    public static var colorPickerThumbViewWideBorderDarkColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3000000119)

    public func hexValue(alwaysIncludeAlpha: Bool = false) -> String {
        let (red, green, blue, alpha) = rgba
        let r = colorComponentToUInt8(red)
        let g = colorComponentToUInt8(green)
        let b = colorComponentToUInt8(blue)
        let a = colorComponentToUInt8(alpha)

        if alpha == 1 && !alwaysIncludeAlpha {
            return String(format: "%02lX%02lX%02lX", r, g, b)
        }
        return String(format: "%02lX%02lX%02lX%02lX", r, g, b, a)
    }

    /// Computes contrast ratio between this color and given color as a value from interval <0, 1> where 0 is contrast ratio of the same colors and 1 is contrast ratio between black and white.
    func constrastRatio(with color: UIColor) -> CGFloat {
        let (r1, g1, b1) = rgb
        let (r2, g2, b2) = color.rgb

        return (abs(r1 - r2) + abs(g1 - g2) + abs(b1 - b2)) / 3
    }
}

private func pickColorForMode(lightModeColor: UIColor, darkModeColor: UIColor) -> UIColor {
    if #available(iOS 13, *) {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            UITraitCollection.userInterfaceStyle == .dark ? darkModeColor : lightModeColor
        }
    }
    return lightModeColor
}

@inline(__always)
public func colorComponentToUInt8(_ component: CGFloat) -> UInt8 {
    return UInt8(max(0, min(255, round(255 * component))))
}

/// Translates color from HSB system to RGB, given constant Brightness value of 1.
/// @param hue Hue value in range from 0 to 1 (inclusive).
/// @param saturation Saturation value in range from 0 to 1 (inclusive).
/// @param brightness Brightness value in range from 0 to 1 (inclusive).
public func rgbFrom(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
    let hPrime = Int(hue * 6)
    let f = hue * 6 - CGFloat(hPrime)
    let p = brightness * (1 - saturation)
    let q = brightness * (1 - f * saturation)
    let t = brightness * (1 - (1 - f) * saturation)

    switch hPrime % 6 {
    case 0: return (brightness, t, p)
    case 1: return (q, brightness, p)
    case 2: return (p, brightness, t)
    case 3: return (p, q, brightness)
    case 4: return (t, p, brightness)
    default: return (brightness, p, q)
    }
}

//code currently not used but might consider publishing it in the future as a color utilities - leaving here for reference
extension UIColor {
    //    public var alpha: CGFloat {
    //        return rgba.alpha
    //    }
    //
    //    public func withRed(_ red: CGFloat) -> UIColor {
    //        let (_, g, b, a) = self.rgba
    //        return UIColor(red: red, green: g, blue: b, alpha: a)
    //    }
    //
    //    public func withGreen(_ green: CGFloat) -> UIColor {
    //        let (r, _ , b, a) = self.rgba
    //        return UIColor(red: r, green: green, blue: b, alpha: a)
    //    }
    //
    //    public func withBlue(_ blue: CGFloat) -> UIColor {
    //        let (r, g, _, a) = self.rgba
    //        return UIColor(red: r, green: g, blue: blue, alpha: a)
    //    }
}
