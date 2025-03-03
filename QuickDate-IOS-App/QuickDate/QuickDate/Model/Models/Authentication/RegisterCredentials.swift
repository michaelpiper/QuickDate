//
//  RegisterCredentials.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 10.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import QuickDateSDK

/// Handle values that are coming from textField to provide clean code
/// in RegistrationScreen
struct RegisterCredentials {
    let firstName, lastName, email: String
    let username, password: String
    // TODO: Change this to new library: Defaults
    let deviceId = UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId)
}

/// Handle values that are coming from textField to provide clean code
/// in LoginScreen
struct LoginCredentials {
    let username, password: String
    let platform: String = "iOS"
    // TODO: Change this to new library: Defaults
    let deviceId = UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId)
    
    var parameters: APIParameters {
        return [
            API.PARAMS.username: username,
            API.PARAMS.password: password,
            API.PARAMS.platform: platform,
            API.PARAMS.device_id: deviceId
        ]
    }
}
