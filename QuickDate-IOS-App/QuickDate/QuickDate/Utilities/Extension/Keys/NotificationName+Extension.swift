//
//  NotificationName+Extension.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 2.02.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

extension Notification.Name {

    static let hotOrNotUserDelete = Notification.Name(rawValue: "hotOrNotUserDelete")
    static let hotOrNotUserCellError = Notification.Name(rawValue: "hotOrNotUserCellError")

}

enum UserInfoKey: String {
    case error
    case indexPath
}
