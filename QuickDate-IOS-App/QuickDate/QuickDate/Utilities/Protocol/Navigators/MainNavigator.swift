//
//  MainNavigator.swift
//  Market Storm
//
//  Created by Nazmi Yavuz on 23.11.2021.
//  Copyright © 2021 ScriptSun. All rights reserved.
//

import UIKit

protocol MainNavigator {
    
    /// General destination which is in Authentication Screens and
    ///  [MainTabBarController](x-source-tag://MainTabBarController)
    associatedtype Destination
    
    /**
    Navigate to another screen that is named as Destination
     - parameters:
       - destination: Destination which is associated type, navigate to related destination
     */
    func navigate(to destination: Destination)
    
}
