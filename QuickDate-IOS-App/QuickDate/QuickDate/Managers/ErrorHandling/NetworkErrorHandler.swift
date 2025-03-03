//
//  NetworkErrorHandler.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 12.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

enum RemoteDataError: Error {
    case known(String)
    case specific(title: String, message: String)
    case unknown
}
// TODO: create localized string before release
extension RemoteDataError: CustomAlertPresentable {
    var alert: (title: String?, message: String?) {
        let unknownMessage = "You should check your internet connection and try again later."
        switch self {
        case .known(let description):           return ("Security".localized, description)
        case .specific(let title, let message): return (title, message)
        case .unknown:                          return ("Something wrong!", unknownMessage)
        }
    }
}
