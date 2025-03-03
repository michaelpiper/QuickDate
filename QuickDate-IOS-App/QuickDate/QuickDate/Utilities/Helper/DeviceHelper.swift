//
//  DeviceHelper.swift
//  Market Storm
//
//  Created by Nazmi Yavuz on 18.11.2021.
//  Copyright © 2021 ScriptSun. All rights reserved.
//

import UIKit

enum DeviceType {
    case iPhone
    case iPad
}

enum Orientation {
    case portrait
    case landscape
}

/// Handle device edge values for orientation and set constraints to user interface
struct DimensionValues {
    let short: CGFloat
    let long: CGFloat
}

/// Get safe area paddings from device
/// - Tag: SafeAreaPaddings
struct SafeAreaPaddings {
    let top, left, bottom, right: CGFloat
}

// MARK: - DeviceHelper

struct DeviceHelper {
    
    static let shared = DeviceHelper()
    
    /// recognize device type to handle some user interface
    /// - Returns:
    ///     DeviceType
    ///     1. iPhone
    ///     2. iPad
    func decideDeviceType() -> DeviceType {
        let model = UIDevice.current.model
        return model == "iPhone" ? .iPhone : .iPad
    }
    /// setting size property for any ui object according to device type
    /// - Parameters:
    ///     - iPhone: size which will be shown on iPhone
    ///     - iPad: size which will be shown on iPad
    /// - Returns: CGFloat
    func setCGFloat(iPhone: CGFloat, iPad: CGFloat) -> CGFloat {
        let device = decideDeviceType()
        return device == .iPhone ? iPhone : iPad
    }
    
    /// Recognize orientation for the first loading
    /// - Returns: orientation value of the custom enum type
    func deviceOrientation() -> Orientation {
        let size = UIScreen.main.bounds.size
        return size.width < size.height ? .portrait : .landscape
    }
    
    /// Handle device dimensions to create some views in terms of the dimension
    /// - Returns: small and long value
    func getDeviceTotalDimension() -> DimensionValues {
        let size = UIScreen.main.bounds.size
        let sizes = [size.width, size.height].sorted { $0 < $1 }
        return DimensionValues(short: sizes[0], long: sizes[1])
    }
    
    /// Handle device dimensions to create some views in terms of the dimension
    /// - Returns: small and long value
    func getDeviceSafeAreaDimensions() -> DimensionValues {
        let size = UIScreen.main.bounds.size
        let sizes = [size.width, size.height].sorted { $0 < $1 }
        let isPortrait = deviceOrientation() == .portrait
        let paddings = getDeviceSafeAreaPaddings()
        let longAreaPadding = isPortrait ? paddings.top + paddings.bottom : paddings.left + paddings.right
        let shortAreaPadding = isPortrait ? paddings.left + paddings.right : paddings.top + paddings.bottom
        return DimensionValues(short: sizes[0] - shortAreaPadding, long: sizes[1] - longAreaPadding)
    }
    
    /// Handle safe area paddings for handling orientation
    /// - Returns: get [SafeAreaPaddings](x-source-tag://SafeAreaPaddings)
    func getDeviceSafeAreaPaddings() -> SafeAreaPaddings {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        let isPortrait = deviceOrientation() == .portrait
        let topPadding = keyWindow?.safeAreaInsets.top ?? 41
        let leftPadding = keyWindow?.safeAreaInsets.left ?? (isPortrait ? 0 : 41)
        let bottomPadding = keyWindow?.safeAreaInsets.bottom ?? 41
        let rightPadding = keyWindow?.safeAreaInsets.right ?? (isPortrait ? 0 : 41)
        let paddings = SafeAreaPaddings(top: topPadding, left: leftPadding,
                                        bottom: bottomPadding, right: rightPadding)
        return paddings
    }
    /// Set this value according to the smallest iPad device which is iPad Mini 6th generation
//    static let cellWidthForIPad: CGFloat = 712
    
    /// Handle cell width particularly orientation when pagination is enable
    /// - Parameters:
    ///   - iPhonePaddings: Long and short value of related dimension
    ///   - iPadWidth: exact width value for iPad devices
    /// - Returns: cell width that is used for CollectionViewCell
    func getCollectionViewCellWidth(_ paddings: DimensionValues) -> CGFloat {
        let isIPhone = decideDeviceType() == .iPhone
        let dimension = getDeviceTotalDimension()
        let portrait = deviceOrientation() == .portrait
        let width =  isIPhone
        ? (portrait ? (dimension.short - paddings.short) : (dimension.long - paddings.long))
        : (dimension.short - paddings.short)
//        let width = portrait
//        ? (dimension.short - paddings.short)
//        : isIPhone ? (dimension.long - paddings.long)
//        : (dimension.long - paddings .short)
        return width
    }
    
//    func createQuestionAttributedText(question: String) -> NSMutableAttributedString {
//        let attributedText = NSMutableAttributedString(
//            string: "Question:",
//            attributes: [
//                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
//                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
//            ])
//        attributedText.append(
//            NSAttributedString(
//                string: "  \(question)",
//                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
//
//        return attributedText
//    }
    
}
