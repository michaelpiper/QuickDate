//
//  AppNavigator.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 4.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

final class AppNavigator: MainNavigator {
    
    // MARK: - Destination
    enum Destination {
        /// [NoInternetViewController](x-source-tag://NoInternetViewController)
        case noInternet
        /// [StartViewController](x-source-tag://StartViewController)
        case authentication
        /// [MainTabBarViewController](x-source-tag://MainTabBarViewController)
        case mainTab
        case tab(String?)
        case dashboard
        case trending
        case notifications
        case chats
        case profile
        
        var storyboard: StoryboardName {
            switch self {
            case .noInternet:     return .popUp
            // Start Screen
            case .authentication: return .auth
            // MainTab
            case .mainTab:        return .main
            case .tab(_):         return .main
            case .dashboard:      return .main
            case .trending:       return .main
            case .notifications:  return .main
            case .chats:          return .main
            case .profile:        return .main
            }
        }
    }
    
    static let shared = AppNavigator()
        
    // MARK: Properties
    internal let window = UIWindow()
    internal var destinationEnum = Destination.authentication
    internal var navigationController: UINavigationController?
    internal var tabBarController: UITabBarController?
    
    // MARK: Initialiser
    private init() {
        self.window.backgroundColor = .white
    }
    
    // MARK: - Start
    func start(from destination: Destination) {
        navigate(to: destination)
        self.window.makeKeyAndVisible()
    }
   
    // swiftlint:disable all
    // MARK: - Navigate
    func navigate(to destination: Destination) {
        destinationEnum = destination
        switch destination {
            
        case .noInternet:
            let info = NoInternetViewController.getStoryboard(fromStoryboardNamed: destination.storyboard)
            let viewController = info.storyboard.instantiateViewController(identifier: info.identifier) { coder in
                return NoInternetViewController(coder: coder, navigator: self)
            }
            navigationController = UINavigationController(rootViewController: viewController)
            self.window.rootViewController = navigationController
            self.hideNavigationController()
            
        // MARK: Authentication
        case .authentication:
            let info = NewStartViewController.getStoryboard(fromStoryboardNamed: destination.storyboard)
            let viewController = info.storyboard.instantiateViewController(identifier: info.identifier) { coder in
                return NewStartViewController(coder: coder, navigator: self)
            }
            self.hideNavigationController()
            self.navigationController = UINavigationController(rootViewController: viewController)
            self.window.rootViewController = self.navigationController
            
//            let info = SplashNewViewController.getStoryboard(fromStoryboardNamed: destination.storyboard)
//            let viewController = info.storyboard.instantiateViewController(identifier: info.identifier) { coder in
//                return SplashNewViewController(coder: coder, navigator: self)
//            }
//            viewController.onNavigationNewStartVC = { () in
//                let info = NewStartViewController.getStoryboard(fromStoryboardNamed: destination.storyboard)
//                let viewController = info.storyboard.instantiateViewController(identifier: info.identifier) { coder in
//                    return NewStartViewController(coder: coder, navigator: self)
//                }
//                self.hideNavigationController()
//                self.navigationController = UINavigationController(rootViewController: viewController)
//                self.window.rootViewController = self.navigationController
//            }
//            hideNavigationController()
//            navigationController = UINavigationController(rootViewController: viewController)
//            self.window.rootViewController = navigationController
            
        // MARK: - MainTab
        case .mainTab:
            
            let tabBarVc = MainTabBarViewController()
            navigationController = UINavigationController(rootViewController: tabBarVc)
            tabBarController = tabBarVc
            navigationController?.setNavigationBarHidden(true, animated: false)
            self.window.rootViewController = navigationController
            let transition = CATransition()
            transition.presentationStyle(type: .push, subtype: .fromRight)
            self.navigationController?.view.window?.layer.add(transition, forKey: kCATransition)
            
//            let controller = MainTabBarViewController.initial(fromStoryboardNamed: .main)
//            tabBarController = controller
//            navigationController = UINavigationController(rootViewController: controller)
//            navigationController?.setNavigationBarHidden(true, animated: false)
//            self.window.rootViewController = navigationController
//
//            let transition = CATransition()
//            transition.presentationStyle(type: .push, subtype: .fromTop)
//            self.navigationController?.view.window?.layer.add(transition, forKey: kCATransition)
            
        case .tab(let title):
            guard let tabBarController = tabBarController else {
                Logger.error("getting tabBar"); return
            }
            guard
                let items = tabBarController.tabBar.items,
                let item = items.first(where: {$0.title == title}),
                let index = items.firstIndex(of: item)
            else {
                Logger.error("getting index of a tab from tabBarController"); return
            }
            tabBarController.selectedIndex = index
            navigationController = tabBarController.selectedViewController as? UINavigationController
            
        case .dashboard:     navigate(to: .tab(" "))
        case .trending:      navigate(to: .tab("  "))
        case .notifications: navigate(to: .tab("   "))
        case .chats:         navigate(to: .tab("    "))
        case .profile:       navigate(to: .tab("     "))
        }
        
    }
    // swiftlint:enable all
    
    func hideNavigationController() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}
