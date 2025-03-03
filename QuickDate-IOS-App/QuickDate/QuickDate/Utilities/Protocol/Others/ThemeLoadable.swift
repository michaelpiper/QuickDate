//
//  ThemeLoadable.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 3.01.2022.
//  Copyright © 2022 Lê Việt Cường. All rights reserved.
//

import UIKit

// MARK: - ThemeLoadable
/**
 Add configure functions somewhere this protocol is added in
  1. func configureUIViews()
  2. func setUpConfigures()
 */
protocol ThemeLoadable {
    
    func configureUIViews()
    /// Will be called  in an init(), viewDidLoad() or any related func to work it
    func setUpConfigures()
    
}

// MARK: - Label
/**
 Add configure functions somewhere this protocol is added in
    1. func configureLabels()
    2. func configureUIViews()
    3. func setUpConfigures()
*/
protocol LabelThemeLoadable: ThemeLoadable {
    func configureLabels()
}

// MARK: - Button
/**
 Add configure functions somewhere this protocol is added in
    1. func configureButtons()
    2. func configureUIViews()
    3. func setUpConfigures()
*/
protocol ButtonThemeLoadable: ThemeLoadable {
    func configureButtons()
}

// MARK: - NavBar
/**
 Add configure functions somewhere this protocol is added in
    1. func configureNavBar()
    2. func configureUIViews()
    3. func setUpConfigures()
*/
protocol NavBarThemeLoadable: ThemeLoadable {
    func configureNavBar()
}

// MARK: - TabBar
/**
 Add configure functions somewhere this protocol is added in
    1. func configureTabBar()
    2. func configureUIViews()
    3. func setUpConfigures()
*/
protocol TabBarThemeLoadable: ThemeLoadable {
    func configureTabBar()
}
