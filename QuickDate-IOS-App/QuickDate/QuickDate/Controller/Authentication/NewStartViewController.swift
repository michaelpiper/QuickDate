//
//  NewStartViewController.swift
//  QuickDate
//
//  Created by Macmini2022-1 on 22/09/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import UIKit

class NewStartViewController: UIViewController {
    
    @IBOutlet weak var loginButtonView: UIView!
    @IBOutlet weak var registerButtonView: UIView!
    
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.loginButtonView.layer.cornerRadius = self.loginButtonView.frame.height/2
            self.registerButtonView.layer.cornerRadius = self.registerButtonView.frame.height/2
        }
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        appNavigator.authNavigate(to: .login(comingFromStart: true))
    }
    @IBAction func didTapRegister(_ sender: Any) {
        appNavigator.authNavigate(to: .registration(comingFromStart: true))
    }
    
    
}
