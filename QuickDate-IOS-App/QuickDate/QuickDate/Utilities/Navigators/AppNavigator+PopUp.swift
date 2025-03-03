//
//  AppNavigator+PopUpNavigator.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 4.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

extension AppNavigator: PopUpNavigator {
    
    enum PopUpScreen {
        
        /// [ChooseCategoryViewController.swift](x-source-tag://ChooseCategoryViewController)
        case noInternet
        /// Present [CustomAlertViewController](x-source-tag://CustomAlertViewController)
        /// to warn users not over TabBar
        case customAlertOverNavBar(title: String?, message: String?)
        /// Present [CustomAlertViewController](x-source-tag://CustomAlertViewController)
        /// to warn users  over TabBar
        case customAlertOverTabBar(title: String?, message: String?)
        /// [SelectGenderPopUpViewController](x-source-tag://SelectGenderPopUpViewController)
        case selectGender(UIViewController)
        /// [TutorialViewVC](x-source-tag://TutorialViewVC)
        case tutorial
        /// [ProfileEditPopUpVC](x-source-tag://ProfileEditPopUpVC)
        case profileEdit(delegate: UIViewController, type: ProfileEditType)

        var storyboard: StoryboardName {
            switch self {
            case .noInternet:            return .popUp
            case .customAlertOverNavBar: return .popUp
            case .customAlertOverTabBar: return .popUp
            case .selectGender:          return .popUp
            case .tutorial:              return .popUp
            case .profileEdit:           return .popUp
            }
        }
    }
    
    func popUpNavigate(to popUp: PopUpScreen) {
        switch popUp {
        case .noInternet:
            let viewController = NoInternetViewController.instantiate(fromStoryboardNamed: popUp.storyboard)
            navigationController = UINavigationController(rootViewController: viewController)
            self.window.rootViewController = navigationController
            self.hideNavigationController()
            
        case .customAlertOverNavBar(let title, let message):
            let viewController = CustomAlertViewController.instantiate(fromStoryboardNamed: popUp.storyboard)
            viewController.titleText = title
            viewController.messageText = message

            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(navigationController, animated: true, completion: nil)
            
        case .customAlertOverTabBar(let title, let message):
            let viewController = CustomAlertViewController.instantiate(fromStoryboardNamed: popUp.storyboard)
            viewController.titleText = title
            viewController.messageText = message
            
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overCurrentContext
            self.tabBarController?.present(navigationController, animated: true, completion: nil)
            
        case .selectGender(let delegateVC):
            let viewController = SelectGenderPopUpViewController.instantiate(fromStoryboardNamed: popUp.storyboard)
            viewController.delegate = delegateVC as? SelectGenderPopUpViewControllerDelegate
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(navigationController, animated: true, completion: nil)
            
        case .tutorial:
            let viewController = TutorialViewVC.instantiate(fromStoryboardNamed: popUp.storyboard)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(navigationController, animated: true, completion: nil)
            
        case .profileEdit(let delegate, let editType):
            let viewController = ProfileEditPopUpVC.instantiate(fromStoryboardNamed: popUp.storyboard)
            viewController.delegate = delegate as? DidSetProfilesParamDelegate
            viewController.editType = editType
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .overCurrentContext
            self.tabBarController?.present(navigationController, animated: true, completion: nil)
        }
    }
    
}
