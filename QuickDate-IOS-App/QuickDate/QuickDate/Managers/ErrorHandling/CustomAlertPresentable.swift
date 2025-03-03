//
//  CustomAlertPresentable.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 8.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit
/// Show alert to the users with alert controller
protocol CustomAlertPresentable: Error {
    var alert: (title: String?, message: String?) { get }
}

extension UIViewController {
    /// Create alert according to error that is throwing
    /// - Parameter error: which is come from AlertPresentable.
    /// - Parameter isNavBar: show custom alert, over tabBar or navBar is need to be known
    func presentCustomAlertPresentableWith(_ error: Error, isNavBar: Bool) {
        var alert: (title: String?, message: String?) {
            switch error as? CustomAlertPresentable {
            case let error?:    return (error.alert.title, error.alert.message)
            case nil:           return ("Something went wrong..", "You should control your entries.")
            }
        }
        switch isNavBar {
        case true:  self.showOKAlertOverNavBar(title: alert.title, message: alert.message)
        case false: self.showOKAlertOverTabBar(title: alert.title, message: alert.message)
        }
    }
}
