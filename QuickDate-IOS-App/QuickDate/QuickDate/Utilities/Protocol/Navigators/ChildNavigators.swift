//
//  ChildNavigators.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 4.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation

// MARK: - DashboardNavigator

/// - Tag: AuthenticationNavigator
protocol AuthenticationNavigator {
    /// Screen is a Authentication screen
    associatedtype AuthScreen
    /**
    Navigate to another screen to show _Authentication_ with
    [AuthenticationNavigator protocol](x-source-tag://AuthenticationNavigator)
     - parameters:
       - screen: AuthScreen which is associated type, is navigated to
     */
    func authNavigate(to screen: AuthScreen)
    
}

// MARK: - DashboardNavigator

/// - Tag: DashboardNavigator
protocol DashboardNavigator {
    /// Screen is a Dashboard screen
    associatedtype DashboardScreen
    /**
    Navigate to another screen to show _Dashboard_ with
    [DashboardNavigator protocol](x-source-tag://DashboardNavigator)
     - parameters:
       - screen: DashboardScreen which is associated type, is navigated to
     */
    func dashboardNavigate(to screen: DashboardScreen)
    
}

// MARK: - Trending

/// - Tag: TrendingNavigator
protocol TrendingNavigator {
    /// Screen is a Trending screen
    associatedtype TrendingScreen
    /**
    Navigate to another screen to show _Trending_ with
    [TrendingNavigator protocol](x-source-tag://TrendingNavigator)
     - parameters:
       - screen: TrendingScreen which is associated type, is navigated to
     */
    func trendingNavigate(to screen: TrendingScreen)
    
}

// MARK: - Credit

/// - Tag: CreditNavigator
protocol CreditNavigator {
    /// Screen is a Credit screen
    associatedtype CreditScreen
    /**
    Navigate to another screen to show _Credit_ with
    [CreditNavigator protocol](x-source-tag://CreditNavigator)
     - parameters:
       - screen: CreditScreen which is associated type, is navigated to
     */
    func creditNavigate(to screen: CreditScreen)
    
}

// MARK: - PopUp

/// - Tag: PopUpNavigator
protocol PopUpNavigator {
    /// Screen is a PopUp screen
    associatedtype PopUpScreen
    /**
    Navigate to another screen to show _PopUp_ with
    [PopUpNavigator protocol](x-source-tag://PopUpNavigator)
     - parameters:
       - popUp: PopupScreen which is associated type, is navigated to
     */
    func popUpNavigate(to popUp: PopUpScreen)
    
}
