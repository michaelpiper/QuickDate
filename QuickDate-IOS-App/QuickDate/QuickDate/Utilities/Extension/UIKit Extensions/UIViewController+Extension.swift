//
//  UIViewController+Extension.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 3.01.2022.
//  Copyright © 2022 Lê Việt Cường. All rights reserved.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: - Nazmi
    
    /// Create CAGradientLayer to provide better user interface
    /// - Parameter colors: which are used to create gradient presentation
    /// - Returns: CAGradientLayer is to create
    func createGradient(colors: [UIColor]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint =  CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.2, y: 0.5)
        return gradientLayer
    }
    
    func showOKAlertOverNavBar(title: String?, message: String?) {
        let appNavigator: AppNavigator = .shared
        appNavigator.popUpNavigate(to: .customAlertOverNavBar(
            title: title, message: message))
    }
    
    func showOKAlertOverTabBar(title: String?, message: String?) {
        let appNavigator: AppNavigator = .shared
        appNavigator.popUpNavigate(to: .customAlertOverTabBar(
            title: title, message: message))
    }
    
    func showOKAlert(title: String?, message: String?, completion: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Haris
    
    func showNavigation(title: String, shadow: Bool = true, background: UIImage = UIImage()) {
        
        self.title = title
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = .Main_StartColor
        navigationController?.navigationBar.setBackgroundImage(background, for: UIBarMetrics.default)
        if !shadow {
            navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
    
    func hideNavigation(hide: Bool) {
        
        navigationController?.setNavigationBarHidden(hide, animated: false)
    }
    
    func setNavigationButtons(left: [UIBarButtonItem] = [], right: [UIBarButtonItem] = []) {
        
        navigationItem.setRightBarButtonItems(right, animated: false)
        navigationItem.setLeftBarButtonItems(left, animated: false)
    }
}

extension UIViewController {
    /// Not using static as it wont be possible to override to provide custom storyboardID then
    class public var storyboardID: String {
        return "\(self)"
    }
    
    static public func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}

extension UIViewController {
    
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar || false
    }
    
}
