//
//  NoInternetViewController.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 4.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

/// - Tag: NoInternetViewController
class NoInternetViewController: UIViewController {
    
    // MARK: - Views
    @IBOutlet weak var upperPrimaryView: UIView!
    @IBOutlet weak var mainBackgroundView: UIView!
    
    @IBOutlet weak var cloudImageView: UIImageView!
    @IBOutlet weak var noInternetLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    // MARK: - Properties
    // Dependency Injections
    private let appNavigator: AppNavigator
//    private let observer: NetworkObserver = .shared
    
    // MARK: - Initialiser
    init?(coder: NSCoder, navigator: AppNavigator) {
        self.appNavigator = navigator
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConfigures()
    }
    
    // MARK: - Orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async { [self] in
            handleGradientLayer()
        }
    }
    
    // MARK: - Layout
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        handleGradientLayer()
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Services
    
    // MARK: - Private Functions
    
    // MARK: - Action
    @IBAction func tryAgainButtonPressed(_ sender: UIButton) {
        Logger.debug("Try again button pressed", context: nil)
        
//        appNavigator.navigate(to: .splashScreen)
    }
    
}

// MARK: - Helper

extension NoInternetViewController {
    
    private func handleGradientLayer() {
        let startColor = Theme.primaryStartColor.colour
        let endColor = Theme.primaryEndColor.colour
        
        tryAgainButton.removeGradientLayer()
        let gradientLayer = createGradient(colors: [startColor, endColor])
        gradientLayer.frame = tryAgainButton.bounds
        gradientLayer.cornerRadius = tryAgainButton.layer.cornerRadius
        tryAgainButton.layer.insertSublayer(gradientLayer, at: 0)
    }
}

// MARK: - ThemeLoadable
extension NoInternetViewController: LabelThemeLoadable, ButtonThemeLoadable {
    internal func configureButtons() {
        tryAgainButton.setTheme(title: "Try Again".localized, font: .semiBoldTitle(size: 15))
    }
    
    internal func configureLabels() {
        noInternetLabel.setTheme(themeColor: .primaryTextColor, font: .semiBoldTitle(size: 20))
        noInternetLabel.text = "No Internet Available".localized
        
        explanationLabel.setTheme(themeColor: .secondaryTextColor, font: .regularText(size: 16))
        explanationLabel.text = "We could not establish a connection with our servers please try again later.".localized
    }
    
    internal func configureUIViews() {
        upperPrimaryView.setThemeBackgroundColor(.primaryEndColor)
        mainBackgroundView.setThemeBackgroundColor(.primaryBackgroundColor)
        
        cloudImageView.setThemeTintColor(.primaryEndColor)
    }
    
    internal func setUpConfigures() {
        configureButtons()
        configureLabels()
        configureUIViews()
    }
}
