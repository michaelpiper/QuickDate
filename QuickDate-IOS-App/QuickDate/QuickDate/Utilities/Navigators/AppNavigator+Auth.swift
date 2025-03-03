//
//  AppNavigator+Auth.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 8.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

extension AppNavigator: AuthenticationNavigator {
    
    enum AuthScreen {
        /// [RegisterVC](x-source-tag://RegisterVC)
        case registration(comingFromStart: Bool)
        /// [LoginViewController](x-source-tag://LoginViewController)
        case login(comingFromStart: Bool)
        /// [TwoFactorVC](x-source-tag://TwoFactorVC)
        case twoFactor(injections: TwoFactorVCInjections)
        /// [LoginWithWoWonderVC](x-source-tag://LoginWithWoWonderVC)
        case loginWithWoWonder
        /// [ForgetPasswordVC](x-source-tag://ForgetPasswordVC)
        case  forgotPassword
        
        var storyboard: StoryboardName {
            switch self {
            case .registration(_):   return .auth
            case .login(_):          return .auth
            case .twoFactor:         return .auth
            case .loginWithWoWonder: return .auth
            case .forgotPassword:    return .auth
            }
        }
    }
    
    func authNavigate(to screen: AuthScreen) {
        
        switch screen {
            
        case .registration(let fromStart):
            let info = RegisterViewController.getStoryboard(fromStoryboardNamed: screen.storyboard)
            let viewController = info.storyboard.instantiateViewController(identifier: info.identifier) { coder in
                return RegisterViewController(coder: coder, navigator: self, fromStart: fromStart)
            }
            navigationController?.pushViewController(viewController, animated: true)
            
        case .login(let fromStart):
            let info = LoginViewController.getStoryboard(fromStoryboardNamed: screen.storyboard)
            let viewController = info.storyboard.instantiateViewController(identifier: info.identifier) { coder in
                return LoginViewController(coder: coder, navigator: self, fromStart: fromStart)
            }
            navigationController?.pushViewController(viewController, animated: true)
            
        case .twoFactor(let injections):
            let viewController = TwoFactorVC.instantiate(fromStoryboardNamed: screen.storyboard)
            viewController.email = injections.email
            viewController.userID = injections.userID
            
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            
            self.navigationController?.present(navigationController, animated: true, completion: nil)
            
        case .loginWithWoWonder:
            let viewController = LoginWithWoWonderVC.instantiate(fromStoryboardNamed: screen.storyboard)
            navigationController?.pushViewController(viewController, animated: true)
            
        case .forgotPassword:
            let viewController = ForgetPasswordVC.instantiate(fromStoryboardNamed: screen.storyboard)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
