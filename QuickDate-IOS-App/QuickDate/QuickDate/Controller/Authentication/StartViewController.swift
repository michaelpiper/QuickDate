//
//  StartViewController.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 3.01.2022.
//  Copyright © 2022 Lê Việt Cường. All rights reserved.
//

import UIKit

/// - Tag: StartViewController
class StartViewController: UIViewController {
    
    // MARK: - Views
    @IBOutlet weak var mainColorUpperView: UIView!
    
    @IBOutlet weak var upperExplanationLabel: UILabel!
    @IBOutlet weak var bottomExplanationLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    private let startColor = Theme.primaryStartColor.colour
    private let endColor = Theme.primaryEndColor.colour
    
    // MARK: - Properties
    // Dependency Injections
    private let appNavigator: AppNavigator
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // change status text colors to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async { [self] in
            createMainViewGradientLayer()
            halfCircleAndSquareView()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        createMainViewGradientLayer()
        halfCircleAndSquareView()
    }
    
    // MARK: - Services
    
    // MARK: - Private Functions
    
    // MARK: - Action
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        appNavigator.authNavigate(to: .registration(comingFromStart: true))
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        appNavigator.authNavigate(to: .login(comingFromStart: true))
    }
    
}

// MARK: - Gradient

extension StartViewController {
    
    private func createMainViewGradientLayer() {
        let gradientViewList: [UIView] = [mainColorUpperView, registerButton, loginButton]
        gradientViewList.forEach { gradientView in
            gradientView.removeGradientLayer()
            let gradientLayer = createGradient(colors: [startColor, endColor])
            gradientLayer.frame = gradientView.bounds
            gradientLayer.cornerRadius = gradientView.layer.cornerRadius
            gradientView.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    private func halfCircleAndSquareView() {
        let deviceHelper: DeviceHelper = .shared
        let isPortrait = deviceHelper.deviceOrientation() == .portrait
        let longEdge = deviceHelper.getDeviceTotalDimension().long
        let shortEdge = deviceHelper.getDeviceTotalDimension().short
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: mainColorUpperView.bounds.size.width / 2, y: 0),
            radius: longEdge*0.55,
            startAngle: 0.0, endAngle: .pi, clockwise: true)
        let square = UIBezierPath(rect: CGRect(x: 0, y: 0, width: longEdge, height: shortEdge*0.55))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = isPortrait ? circlePath.cgPath : square.cgPath
        mainColorUpperView.layer.mask = shapeLayer
    }
}

// MARK: - ThemeLoadable
extension StartViewController: LabelThemeLoadable, ButtonThemeLoadable {
    
    internal func configureButtons() {
        registerButton.setTheme(title: "Register".localized, font: .regularText(size: 13))
        loginButton.setTheme(title: "Login".localized, font: .regularText(size: 13))
                
    }
    
    internal func configureLabels() {
        upperExplanationLabel.setTheme(font: .regularText(size: 13))
        upperExplanationLabel.text = "Swipe right to like someone and if you both like each other? Its a match.".localized
        
        bottomExplanationLabel.setTheme(themeColor: .primaryTextColor, font: .regularText(size: 13))
        bottomExplanationLabel.text = "Flirt, Chat, and meet people around you.".localized
        
    }
    
    internal func configureUIViews() {
        view.setThemeBackgroundColor(.primaryBackgroundColor)
    }
    
    internal func setUpConfigures() {
        configureButtons()
        configureLabels()
        configureUIViews()
    }
}
