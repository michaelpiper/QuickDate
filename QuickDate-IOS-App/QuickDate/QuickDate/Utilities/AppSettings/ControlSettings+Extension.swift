//
//  ControlSettings+Extension.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 7.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

protocol ShowAppleSignInProtocol {
    static var showAppleSignIn: Bool { get }
}

extension ControlSettings: ShowAppleSignInProtocol {
    
    static var showAppleSignIn: Bool {
        let isShown: Bool = ControlSettings.showGoogleLogin || ControlSettings.showFacebookLogin || ControlSettings.showWoWonderLogin
        return isShown
    }
    
}
