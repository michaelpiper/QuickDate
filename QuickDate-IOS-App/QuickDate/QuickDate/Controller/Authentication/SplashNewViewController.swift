//
//  SplashNewViewController.swift
//  QuickDate
//
//  Created by iMac on 03/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

class SplashNewViewController: UIViewController {

    // MARK: Properties
    private let appNavigator: AppNavigator
    var onNavigationNewStartVC: (() -> ())?

    // MARK: - Initialiser
    init?(coder: NSCoder, navigator: AppNavigator) {
        self.appNavigator = navigator
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
extension SplashNewViewController {
    @IBAction func onBtnNext(_ sender: UIButton) {
        self.onNavigationNewStartVC?()
    }
}
