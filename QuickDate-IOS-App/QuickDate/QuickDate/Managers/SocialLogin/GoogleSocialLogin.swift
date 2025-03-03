//
//  GoogleSocialLogin.swift
//  QuickDate
//
//  Created by iMac on 03/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

typealias blockCompletedWithStatus = (String) -> Void

class GoogleSocialLogin {
    static let shared = GoogleSocialLogin()

    
    func googleLogin(vc: UIViewController, blockCompletedWithStatus: @escaping blockCompletedWithStatus) {
        //let signInConfig = GIDConfiguration(clientID: ControlSettings.googleClientKey)
        
        GIDSignIn.sharedInstance.signIn(withPresenting: vc) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            
            let user = signInResult.user
            /*let emailAddress = user.profile?.email
             let fullName = user.profile?.name
             let givenName = user.profile?.givenName
             let familyName = user.profile?.familyName
             let profilePicUrl = user.profile?.imageURL(withDimension: 320)*/
            
            signInResult.user.refreshTokensIfNeeded { user, error in
                guard error == nil else { return }
                guard let user = user else { return }
                let idToken = user.idToken?.tokenString
                blockCompletedWithStatus(idToken ?? "")
            }
        }
    }
}
