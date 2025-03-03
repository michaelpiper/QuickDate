//
//  AppNavigator+Dashboard.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 7.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit
import FittedSheets

enum DelegateType {
    case controller(UIViewController)
    case tableCell(UITableViewCell)
    case collectionCell(UICollectionViewCell)
    case none
}

extension AppNavigator: DashboardNavigator {
    
    enum DashboardScreen {
        /// [IntroViewController.swift](x-source-tag://IntroViewController)
        case intro
        /// [ShowUserDetailsViewController](x-source-tag://ShowUserDetailsViewController)
        case userDetail(user: OtherUser, delegate: DelegateType)
        /// [ShowImageController](x-source-tag://ShowImageController)
        case imageController(imageURL: URL?)
        
        var storyboard: StoryboardName {
            switch self {
            case .intro:      return .auth
            case .userDetail: return .main
            case .imageController: return .main
            }
        }
    }
    
    func dashboardNavigate(to screen: DashboardScreen) {
        
        switch screen {
            
        case .intro:
            let viewController = IntroViewController.instantiate(fromStoryboardNamed: screen.storyboard)
            navigationController = UINavigationController(rootViewController: viewController)
            self.window.rootViewController = navigationController
            self.hideNavigationController()
            
        case .userDetail(let otherUser, let delegate):
            let viewController = ShowUserDetailsViewController.instantiate(fromStoryboardNamed: screen.storyboard)
            viewController.otherUser = otherUser
            switch delegate {
            case .controller(let controller):
                viewController.delegate = controller as? UserInteractionDelegate
            case .tableCell(let cell):
                viewController.delegate = cell as? UserInteractionDelegate
            case .collectionCell(let cell):
                viewController.delegate = cell as? UserInteractionDelegate
            case .none: break
            }
            self.navigationController?.pushViewController(viewController, animated: true)
            
        case .imageController(let imageURL):
            let viewController = ShowImageController.instantiate(fromStoryboardNamed: .main)
            viewController.imageUrl = imageURL
            viewController.modalTransitionStyle = .coverVertical
            viewController.modalPresentationStyle = .fullScreen
            self.navigationController?.present(viewController, animated: true, completion: nil)
        }
    }
}
